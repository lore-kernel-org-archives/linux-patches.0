Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F49F4746A9;
	Fri,  7 Aug 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117696; cv=none; b=On3xKkXpgJ6Ax2djAtYCwThCA+SBabFwmLK9okDizTPAu0qB+boMqVw6dO2QgeywMqZuBXW5wcW3OzlpwVfDuwzauyKRMBzFHtGhybiVVQ8s/d8at5gF+5qpwT73jx1mRcNdz7u130WU1WJrSfAy1tmQRHbWJdoNxLtEEEEjlMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117696; c=relaxed/simple;
	bh=KNJTWUGCORZ/UfmCCegLd6o+1kz4vmPj3Qu2Q7Mdmow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QENUahbg2vvArZCOyPj9VYyDUMYq1mLMXMin/zocyue8N8C+fNHwRWR6w+gX85SocktZDAT5up17i6kZBPnoA5y6VijcWzvEUH9tkQnMTr1SA+IeDOOiFT6gv1biDuPZb8s4eFC82V6x52r9RWQv4YbsKLJAytZEf8RnGkkaSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8t4BPiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8t4BPiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363331F000E9;
	Fri,  7 Aug 2026 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117694;
	bh=ik4GfzBc52vw8AchDi7h1nYk8YCVrLE4yJZETT6KaOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8t4BPiPf+13i5oFv3nk50VcJ0A5K5LjQeCAwrmYNs6NEG9rxW2pF2uio++2hTPO+
	 nusUh93FiW6Oi/mmLas3SAOqoIbGDj7k5pwC86aEA0acSa1Et8TeSrHAuDy1xysf9p
	 l727l0bKWaM1aePphxRbYVR7w8gz8VXJfrnC/6WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 410/438] drm/vmwgfx: take fman->lock around fence list mutation in fifo_down
Date: Fri,  7 Aug 2026 16:40:06 +0200
Message-ID: <20260807143436.707094753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 250af2e8c3e90dc978e062a936b633870a22e660 upstream.

vmw_fence_fifo_down() drops fman->lock to wait on a fence and, on
timeout, mutates fman->fence_list via list_del_init() and signals
the fence without re-acquiring the lock.  __vmw_fences_update() walks
and removes entries from the same list under fman->lock from any
other waiter, the fence-IRQ thread, or vmw_fences_update(), so the
unlocked list_del_init() can corrupt the list head.

Re-take fman->lock before manipulating fence->head and use
dma_fence_signal_locked().  Wrap the locked signalling in
dma_fence_begin_signalling() / dma_fence_end_signalling() so the
lockdep annotation that dma_fence_signal() previously provided is
preserved (the same pattern as __vmw_fences_update()).

dma_fence_put() is moved outside the lock to avoid a recursive
acquire from vmw_fence_obj_destroy(), which also takes fman->lock.

Fixes: ae2a104058e2 ("vmwgfx: Implement fence objects")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-5-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -367,13 +367,24 @@ void vmw_fence_fifo_down(struct vmw_fenc
 		ret = vmw_fence_obj_wait(fence, false, false,
 					 VMW_FENCE_WAIT_TIMEOUT);
 
+		spin_lock(&fman->lock);
 		if (unlikely(ret != 0)) {
+			bool cookie = dma_fence_begin_signalling();
+
 			list_del_init(&fence->head);
-			dma_fence_signal(&fence->base);
+			if (fence->waiter_added) {
+				vmw_seqno_waiter_remove(fman->dev_priv);
+				fence->waiter_added = false;
+			}
+			dma_fence_signal_locked(&fence->base);
+			dma_fence_end_signalling(cookie);
 		}
 
 		BUG_ON(!list_empty(&fence->head));
+		spin_unlock(&fman->lock);
+
 		dma_fence_put(&fence->base);
+
 		spin_lock(&fman->lock);
 	}
 	spin_unlock(&fman->lock);


