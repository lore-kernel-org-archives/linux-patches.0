Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0951747D94B;
	Thu, 20 Aug 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247183; cv=none; b=uJM/PSz+fuHMLxPhuGyhVjbLDUqI0hJP1zlLHvXNYO1+XFmuDetI5u0bHAfKzusn+5NVR+RJ+ai+d6co7xcasI5m8Cu6EEhWq41BLra6y7OwJe4KB3F2Mdsire6/BYL7UmGcsDOfDt+VnVzuewQJNgQ0pu6QB6f62TI6134cROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247183; c=relaxed/simple;
	bh=skN71BH5Uger227d+iSmqNyDi/jhajRzvtiWyKDha50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGYNbNt8+sOrUk9A79whDLNiH1qfPcUXZ6G6NBXuPh0fqsM4EaExmva1fFK2mYczjyg524Oe0Z4dXGy9bw0mMtVT3z5GAf8k7Hhr5wmQ3J0c6npODxfycdUf1gbydPjxSBrDRNwEqxdYp4h8TJeF3VLqOBDsizNbWIpFunkxzwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypUIRJAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypUIRJAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F01F000E9;
	Thu, 20 Aug 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247179;
	bh=tLmLYii2VsY1DKsKn9Q4lr4WWaoDk8neYTUoGua/KN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypUIRJAnaw5S0ZSalXdIJC643CIafh441fSEVm9wbDojAmfir7WjhoaSiIXAsyUjJ
	 Zm4vTY6MvsHWm2johzzAQl5vd2H9E0uVF60DyT2nIGIZ/W8+QvQnoGoXFHdvG+HSoZ
	 uNNbdM3gnRPqbMH29WkC3lhHLRMPnnDdcJhaLGd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/220] drm/vmwgfx: take fman->lock around fence list mutation in fifo_down
Date: Thu, 20 Aug 2026 16:56:06 +0200
Message-ID: <20260820145228.764861467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 250af2e8c3e90dc978e062a936b633870a22e660 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -658,9 +658,14 @@ void vmw_fence_fifo_down(struct vmw_fenc
 		ret = vmw_fence_obj_wait(fence, false, false,
 					 VMW_FENCE_WAIT_TIMEOUT);
 
+		spin_lock(&fman->lock);
 		if (unlikely(ret != 0)) {
+			bool cookie = dma_fence_begin_signalling();
+
 			list_del_init(&fence->head);
-			dma_fence_signal(&fence->base);
+			dma_fence_signal_locked(&fence->base);
+			dma_fence_end_signalling(cookie);
+
 			INIT_LIST_HEAD(&action_list);
 			list_splice_init(&fence->seq_passed_actions,
 					 &action_list);
@@ -668,7 +673,10 @@ void vmw_fence_fifo_down(struct vmw_fenc
 		}
 
 		BUG_ON(!list_empty(&fence->head));
+		spin_unlock(&fman->lock);
+
 		dma_fence_put(&fence->base);
+
 		spin_lock(&fman->lock);
 	}
 	spin_unlock(&fman->lock);


