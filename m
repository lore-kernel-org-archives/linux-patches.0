Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001722D5A19;
	Mon, 13 Apr 2026 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098383; cv=none; b=t+ENOhbngxdkLwICd6Yn7HTV48UrGmpRbQJqN6+H7ILwN1GAXgTqBoPEqcvolfEnMoiV1FwM6oThEsl7RhMi4zeHAwvlPCI1gXrhrED5E1WostmwE/0wK/eG9J9bTJzEEiBWYzio0L71tXN1cVE80aos+SVlK//FOtxZTAW9MFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098383; c=relaxed/simple;
	bh=BRZE2zp4Vzr5lYgebO75alVIxPZXJzy+gXE420L/UVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnfBQNOO6HYhiGQZ4XOHW1jpIMwVYNQczY9gxbvT1h0ryTfQZiI7z86RXj7duJm/OKVZi58YCrWHon7Ts+YlBWx1gtx4W01AmzXiDXdPBnI7Y2QwTBeRs2vP2OigevwXVhsmANEI7x4LtOAgkVniN4gQXjQLsOWxhnVpz+e6Z4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C55in2RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C55in2RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADDBC2BCAF;
	Mon, 13 Apr 2026 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098382;
	bh=BRZE2zp4Vzr5lYgebO75alVIxPZXJzy+gXE420L/UVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C55in2RMiJBXJAZaVC+jXzaW1Nflf5HCTOTTm6qcXuEXz+zGtdjAy6LA5E6gDhAz4
	 JmmEwu3MuL8adbfT1292T5BtJR/oL+I7ybds9iIXVlZZrYdPUtpwurH+RjwbtL9zRj
	 vOIj56A/yMs44/BKz+OXAm4+FBGmSu4Eey1IU8iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 502/570] io_uring/tctx: work around xa_store() allocation error issue
Date: Mon, 13 Apr 2026 18:00:33 +0200
Message-ID: <20260413155849.258514353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 7eb75ce7527129d7f1fee6951566af409a37a1c4 upstream.

syzbot triggered the following WARN_ON:

WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51

which is the

WARN_ON_ONCE(!xa_empty(&tctx->xa));

sanity check in __io_uring_free() when a io_uring_task is going through
its final put. The syzbot test case includes injecting memory allocation
failures, and it very much looks like xa_store() can fail one of its
memory allocations and end up with ->head being non-NULL even though no
entries exist in the xarray.

Until this issue gets sorted out, work around it by attempting to
iterate entries in our xarray, and WARN_ON_ONCE() if one is found.

Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/673c1643.050a0220.87769.0066.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Modify the function in io_uring.c because it's located here in v5.15. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8699,8 +8699,19 @@ static int io_uring_alloc_task_context(s
 void __io_uring_free(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_tctx_node *node;
+	unsigned long index;
 
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	/*
+	 * Fault injection forcing allocation errors in the xa_store() path
+	 * can lead to xa_empty() returning false, even though no actual
+	 * node is stored in the xarray. Until that gets sorted out, attempt
+	 * an iteration here and warn if any entries are found.
+	 */
+	xa_for_each(&tctx->xa, index, node) {
+		WARN_ON_ONCE(1);
+		break;
+	}
 	WARN_ON_ONCE(tctx->io_wq);
 	WARN_ON_ONCE(tctx->cached_refs);
 


