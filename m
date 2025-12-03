Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE692FBDFF;
	Wed,  3 Dec 2025 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780527; cv=none; b=ATRNCmBTlDZBG+aeIlQWCy+v7u8GQPpIcf+3YpNPnuKlMTjbFnSVauXsTE/xll1iO+lRnfLv7KqN1FktCCfJY82PJddgUhvJttrE4Ag1E87fsFuGZLOzeFBcU63lx0VuBwIHZRQeUDC3+FbaYhnlo4eQoGmZyPyhTqSmPNpvA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780527; c=relaxed/simple;
	bh=t/yPiyA8vhBVIoiBf47kU9oGQcn8gCZjpzMyo9TpTCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO6oRYkXA09bk+m1T0azIFMOP7cO4mU3osSUGbMQrS2Z+z7mvQ+1hyUoSgE470dkmAixpM7xTxxsvZi8wWYoVsnl/JA9aW8mFLGJvQiYozZT88oKDgvDYu1qQHpNVoUp3+8Q29ioYIna6fl4OCxHQ/Yo+0xERFAGH00LlOy8aKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv8v1/VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv8v1/VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604D9C4CEF5;
	Wed,  3 Dec 2025 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780526;
	bh=t/yPiyA8vhBVIoiBf47kU9oGQcn8gCZjpzMyo9TpTCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iv8v1/VMGq5tD1bLE+HxYrdjHO9JZQrzY9Ia732xiBNyQvTStoXOfo62kEC1wPPsE
	 6WlkRP5QUh4DXy8zy+jsvOrrYiTlg67Vs01WWdMF3mPSNZAKhCFwuYjwHMwp+fOYdx
	 cZA7p/XVuEJOh6+71Wi9ZtH+q9v/KHg2QWtbdp4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/132] veth: reduce XDP no_direct return section to fix race
Date: Wed,  3 Dec 2025 16:28:12 +0100
Message-ID: <20251203152343.786872948@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <hawk@kernel.org>

[ Upstream commit a14602fcae17a3f1cb8a8521bedf31728f9e7e39 ]

As explain in commit fa349e396e48 ("veth: Fix race with AF_XDP exposing
old or uninitialized descriptors") for veth there is a chance after
napi_complete_done() that another CPU can manage start another NAPI
instance running veth_pool(). For NAPI this is correctly handled as the
napi_schedule_prep() check will prevent multiple instances from getting
scheduled, but for the remaining code in veth_pool() this can run
concurrent with the newly started NAPI instance.

The problem/race is that xdp_clear_return_frame_no_direct() isn't
designed to be nested.

Prior to commit 401cb7dae813 ("net: Reference bpf_redirect_info via
task_struct on PREEMPT_RT.") the temporary BPF net context
bpf_redirect_info was stored per CPU, where this wasn't an issue. Since
this commit the BPF context is stored in 'current' task_struct. When
running veth in threaded-NAPI mode, then the kthread becomes the storage
area. Now a race exists between two concurrent veth_pool() function calls
one exiting NAPI and one running new NAPI, both using the same BPF net
context.

Race is when another CPU gets within the xdp_set_return_frame_no_direct()
section before exiting veth_pool() calls the clear-function
xdp_clear_return_frame_no_direct().

Fixes: 401cb7dae8130 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/176356963888.337072.4805242001928705046.stgit@firesoul
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0f37e056b3dd7..4ff0d4232914f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -975,6 +975,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_redirect > 0)
 		xdp_do_flush();
+	if (stats.xdp_tx > 0)
+		veth_xdp_flush(rq, &bq);
+	xdp_clear_return_frame_no_direct();
 
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
@@ -987,10 +990,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 		}
 	}
 
-	if (stats.xdp_tx > 0)
-		veth_xdp_flush(rq, &bq);
-	xdp_clear_return_frame_no_direct();
-
 	/* Release backpressure per NAPI poll */
 	smp_rmb(); /* Paired with netif_tx_stop_queue set_bit */
 	if (peer_txq && netif_tx_queue_stopped(peer_txq)) {
-- 
2.51.0



