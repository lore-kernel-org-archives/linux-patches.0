Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F124815AAD5;
	Mon, 29 Jan 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548211; cv=none; b=JYd3ptHnpxhrO5d2TxGLg/WTMKZ7whAlIJ8JuzUjt67TxCDvZCuQ6+CmqB2FhbtMvtzlQe+qtqdXiVhISYApdjVUGQXI+/0N2+SxYaGV6/kwqiyKY5P90ae+RbpcmlqSNM+I/gGnvTT40r0FKmn8S6qyOxkxMk5JSVKYRkzAcvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548211; c=relaxed/simple;
	bh=4PyFPTmecQ+YE/qHDVLZjjVEjxWvY/Drmy8WSqLyy7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6wiGWEPmFuw+RsWpXtBWyWpIqVFZIaSS/9/uFrzB4gP/F+LkyD1KdKKBF/6DJh5TTJpYUxUHnKd0MT/kQKB7WJjkUBFOuMt9k/rBy49fvnsHT8kQ7OU8rdfjEohBWDLAhc2Ry80ViXK+uCdZrhBEouzhFP5RfKQya1cKlA5Agk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+Cdmn2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+Cdmn2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6517C43390;
	Mon, 29 Jan 2024 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548210;
	bh=4PyFPTmecQ+YE/qHDVLZjjVEjxWvY/Drmy8WSqLyy7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+Cdmn2oX6z5iT3lSJfOyLIkX4KbjvYJKU1bNx6UPHw+Vo9fa193VbMazmnjY3/x2
	 /hC/ppXoRj/ga2MZBAC4csm8Bv4112zUEeMZeAIeAgwWxYea1xvxdj1f15Qm/uOQNN
	 by2uz0V0QTR9HymG3YbQZPAqeOrSh7S6fy2F3l0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.7 246/346] Revert "nouveau: push event block/allowing out of the fence context"
Date: Mon, 29 Jan 2024 09:04:37 -0800
Message-ID: <20240129170023.655408436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 4d7acc8f48bcf27d0dc068f02e55c77e840b9110 upstream.

This reverts commit eacabb5462717a52fccbbbba458365a4f5e61f35.

This commit causes some regressions in desktop usage, this will
reintroduce the original deadlock in DRI_PRIME situations, I've
got an idea to fix it by offloading to a workqueue in a different
spot, however this code has a race condition where we sometimes
miss interrupts so I'd like to fix that as well.

Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |   28 +++++-----------------------
 drivers/gpu/drm/nouveau/nouveau_fence.h |    5 +----
 2 files changed, 6 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -62,7 +62,7 @@ nouveau_fence_signal(struct nouveau_fenc
 	if (test_bit(DMA_FENCE_FLAG_USER_BITS, &fence->base.flags)) {
 		struct nouveau_fence_chan *fctx = nouveau_fctx(fence);
 
-		if (atomic_dec_and_test(&fctx->notify_ref))
+		if (!--fctx->notify_ref)
 			drop = 1;
 	}
 
@@ -103,7 +103,6 @@ nouveau_fence_context_kill(struct nouvea
 void
 nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
 {
-	cancel_work_sync(&fctx->allow_block_work);
 	nouveau_fence_context_kill(fctx, 0);
 	nvif_event_dtor(&fctx->event);
 	fctx->dead = 1;
@@ -168,18 +167,6 @@ nouveau_fence_wait_uevent_handler(struct
 	return ret;
 }
 
-static void
-nouveau_fence_work_allow_block(struct work_struct *work)
-{
-	struct nouveau_fence_chan *fctx = container_of(work, struct nouveau_fence_chan,
-						       allow_block_work);
-
-	if (atomic_read(&fctx->notify_ref) == 0)
-		nvif_event_block(&fctx->event);
-	else
-		nvif_event_allow(&fctx->event);
-}
-
 void
 nouveau_fence_context_new(struct nouveau_channel *chan, struct nouveau_fence_chan *fctx)
 {
@@ -191,7 +178,6 @@ nouveau_fence_context_new(struct nouveau
 	} args;
 	int ret;
 
-	INIT_WORK(&fctx->allow_block_work, nouveau_fence_work_allow_block);
 	INIT_LIST_HEAD(&fctx->flip);
 	INIT_LIST_HEAD(&fctx->pending);
 	spin_lock_init(&fctx->lock);
@@ -535,19 +521,15 @@ static bool nouveau_fence_enable_signali
 	struct nouveau_fence *fence = from_fence(f);
 	struct nouveau_fence_chan *fctx = nouveau_fctx(fence);
 	bool ret;
-	bool do_work;
 
-	if (atomic_inc_return(&fctx->notify_ref) == 0)
-		do_work = true;
+	if (!fctx->notify_ref++)
+		nvif_event_allow(&fctx->event);
 
 	ret = nouveau_fence_no_signaling(f);
 	if (ret)
 		set_bit(DMA_FENCE_FLAG_USER_BITS, &fence->base.flags);
-	else if (atomic_dec_and_test(&fctx->notify_ref))
-		do_work = true;
-
-	if (do_work)
-		schedule_work(&fctx->allow_block_work);
+	else if (!--fctx->notify_ref)
+		nvif_event_block(&fctx->event);
 
 	return ret;
 }
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -3,7 +3,6 @@
 #define __NOUVEAU_FENCE_H__
 
 #include <linux/dma-fence.h>
-#include <linux/workqueue.h>
 #include <nvif/event.h>
 
 struct nouveau_drm;
@@ -46,9 +45,7 @@ struct nouveau_fence_chan {
 	char name[32];
 
 	struct nvif_event event;
-	struct work_struct allow_block_work;
-	atomic_t notify_ref;
-	int dead, killed;
+	int notify_ref, dead, killed;
 };
 
 struct nouveau_fence_priv {


