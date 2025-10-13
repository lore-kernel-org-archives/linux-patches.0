Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779E726B971;
	Mon, 13 Oct 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370318; cv=none; b=Q0ZHvU7P3a9c/svei7KxOVq7NNOdwXOFLSN8Yy7sslTNSPonWEgAJUfKs0xceEFVHRXU7o7LaBF10fvYltJo1mFs0Pir9aNz9giwWdbo29jgzCzXIrt3SxuDN9b1pH707B/h5vYtSFeVkYgRdja57eeSJbVHeZJGAXnkJ5wJZS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370318; c=relaxed/simple;
	bh=QRm5qKqlSUKGfpKjTmG5+i7cs9rX7bp/QS+opgcHd7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUP5Vn87lNndsgwlvWMtOqHUgAtQq8VSQYhJrQIK1eRbm25CVeToEBFZQVFx7astFm0Qa26IfvTsUASuZEkEOb0q8gUCCbpVM++iTSSpB78tJtyq5VJt2utLwunU+64bxlMpiZT09lUJgS7PUDoXDPIK+xOA+XNpaK82VO6m66w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJd5P3nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJd5P3nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E722C4CEE7;
	Mon, 13 Oct 2025 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370317;
	bh=QRm5qKqlSUKGfpKjTmG5+i7cs9rX7bp/QS+opgcHd7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJd5P3nTKtRV4m3mgl7tDnjH4WUxF5f51jlTij4Xc4+V/xXhMR9YHXdQGb+QFG9E6
	 VNn/prYIs6PltljGyrA+df2lHOTzxm6eFVwcmUBA9TrhI317bldK9EYuIaRtoSAmXr
	 9dkjWO+tEG6Je6olfnidOmdXp+ngGTSkGDyPWfX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.17 553/563] thunderbolt: Fix use-after-free in tb_dp_dprx_work
Date: Mon, 13 Oct 2025 16:46:54 +0200
Message-ID: <20251013144431.337028069@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 67600ccfc4f38ebd331b9332ac94717bfbc87ea7 upstream.

The original code relies on cancel_delayed_work() in tb_dp_dprx_stop(),
which does not ensure that the delayed work item tunnel->dprx_work has
fully completed if it was already running. This leads to use-after-free
scenarios where tb_tunnel is deallocated by tb_tunnel_put(), while
tunnel->dprx_work remains active and attempts to dereference tb_tunnel
in tb_dp_dprx_work().

A typical race condition is illustrated below:

CPU 0                            | CPU 1
tb_dp_tunnel_active()            |
  tb_deactivate_and_free_tunnel()| tb_dp_dprx_start()
    tb_tunnel_deactivate()       |   queue_delayed_work()
      tb_dp_activate()           |
        tb_dp_dprx_stop()        | tb_dp_dprx_work() //delayed worker
          cancel_delayed_work()  |
    tb_tunnel_put(tunnel);       |
                                 |   tunnel = container_of(...); //UAF
                                 |   tunnel-> //UAF

Replacing cancel_delayed_work() with cancel_delayed_work_sync() is
not feasible as it would introduce a deadlock: both tb_dp_dprx_work()
and the cleanup path acquire tb->lock, and cancel_delayed_work_sync()
would wait indefinitely for the work item that cannot proceed.

Instead, implement proper reference counting:
- If cancel_delayed_work() returns true (work is pending), we release
  the reference in the stop function.
- If it returns false (work is executing or already completed), the
  reference is released in delayed work function itself.

This ensures the tb_tunnel remains valid during work item execution
while preventing memory leaks.

This bug was found by static analysis.

Fixes: d6d458d42e1e ("thunderbolt: Handle DisplayPort tunnel activation asynchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1073,6 +1073,7 @@ static void tb_dp_dprx_work(struct work_
 
 	if (tunnel->callback)
 		tunnel->callback(tunnel, tunnel->callback_data);
+	tb_tunnel_put(tunnel);
 }
 
 static int tb_dp_dprx_start(struct tb_tunnel *tunnel)
@@ -1100,8 +1101,8 @@ static void tb_dp_dprx_stop(struct tb_tu
 	if (tunnel->dprx_started) {
 		tunnel->dprx_started = false;
 		tunnel->dprx_canceled = true;
-		cancel_delayed_work(&tunnel->dprx_work);
-		tb_tunnel_put(tunnel);
+		if (cancel_delayed_work(&tunnel->dprx_work))
+			tb_tunnel_put(tunnel);
 	}
 }
 


