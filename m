Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8338914A4E6;
	Tue, 20 Feb 2024 21:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464594; cv=none; b=s+jHFdfk/GFBSo7YpBBLv4qUr97p0E9j5keCZu4uQV8MwVqZkocTQrifyRKTanCV1jy8r2ZXBkVhvjKgfsjS2+ErUOvwXbqZJCHy40O0yT4jOTwHjwtrRx60+NMdOhCJDCUGa/hh3C0CWuTetdt+xZrOaj3rMSmCtjoCLNtWpmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464594; c=relaxed/simple;
	bh=OkCnDDfA4vQuudKfmvuHARssmzTbqVoKd6Miq9iH9S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uo1YvJosMEwc4ZJelp6q5xdUgLKB+RgZGvNvS1kMTO5VQowiIaRBcL6w4LuC/CE0kl+6nh3JadRLOCIHzy6ZJX9lS3BBV00vDaMBh+RrElYpASD+78m6+kXxh3nMKqg9Fqejyz87kcmasfH+dp8Jb+KU8picUP0ezgQqAVmFuxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqVGXUfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqVGXUfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0262CC433F1;
	Tue, 20 Feb 2024 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464594;
	bh=OkCnDDfA4vQuudKfmvuHARssmzTbqVoKd6Miq9iH9S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqVGXUfjod4VYvhOQWNlekBTxtPMKTOEQz+WEerdTnhCYZnInUF7o8Ttgmf/tA68+
	 GMFqcTVQ3nQR4CynINuzFo6tYhD54R4WTKu2xHPHoj61wZZElXF5MPHJpDbdCa3s2w
	 oDHPr/aj6j1v8IhfFVYnU71xFXv9JuJ0ZV2Tu/RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-stable@vger.kernel.org,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.7 075/309] nouveau: offload fence uevents work to workqueue
Date: Tue, 20 Feb 2024 21:53:54 +0100
Message-ID: <20240220205635.556932258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

commit 39126abc5e20611579602f03b66627d7cd1422f0 upstream.

This should break the deadlock between the fctx lock and the irq lock.

This offloads the processing off the work from the irq into a workqueue.

Cc: linux-stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/576237/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |   24 ++++++++++++++++++------
 drivers/gpu/drm/nouveau/nouveau_fence.h |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -103,6 +103,7 @@ nouveau_fence_context_kill(struct nouvea
 void
 nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
 {
+	cancel_work_sync(&fctx->uevent_work);
 	nouveau_fence_context_kill(fctx, 0);
 	nvif_event_dtor(&fctx->event);
 	fctx->dead = 1;
@@ -145,12 +146,13 @@ nouveau_fence_update(struct nouveau_chan
 	return drop;
 }
 
-static int
-nouveau_fence_wait_uevent_handler(struct nvif_event *event, void *repv, u32 repc)
+static void
+nouveau_fence_uevent_work(struct work_struct *work)
 {
-	struct nouveau_fence_chan *fctx = container_of(event, typeof(*fctx), event);
+	struct nouveau_fence_chan *fctx = container_of(work, struct nouveau_fence_chan,
+						       uevent_work);
 	unsigned long flags;
-	int ret = NVIF_EVENT_KEEP;
+	int drop = 0;
 
 	spin_lock_irqsave(&fctx->lock, flags);
 	if (!list_empty(&fctx->pending)) {
@@ -160,11 +162,20 @@ nouveau_fence_wait_uevent_handler(struct
 		fence = list_entry(fctx->pending.next, typeof(*fence), head);
 		chan = rcu_dereference_protected(fence->channel, lockdep_is_held(&fctx->lock));
 		if (nouveau_fence_update(chan, fctx))
-			ret = NVIF_EVENT_DROP;
+			drop = 1;
 	}
+	if (drop)
+		nvif_event_block(&fctx->event);
+
 	spin_unlock_irqrestore(&fctx->lock, flags);
+}
 
-	return ret;
+static int
+nouveau_fence_wait_uevent_handler(struct nvif_event *event, void *repv, u32 repc)
+{
+	struct nouveau_fence_chan *fctx = container_of(event, typeof(*fctx), event);
+	schedule_work(&fctx->uevent_work);
+	return NVIF_EVENT_KEEP;
 }
 
 void
@@ -178,6 +189,7 @@ nouveau_fence_context_new(struct nouveau
 	} args;
 	int ret;
 
+	INIT_WORK(&fctx->uevent_work, nouveau_fence_uevent_work);
 	INIT_LIST_HEAD(&fctx->flip);
 	INIT_LIST_HEAD(&fctx->pending);
 	spin_lock_init(&fctx->lock);
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -44,6 +44,7 @@ struct nouveau_fence_chan {
 	u32 context;
 	char name[32];
 
+	struct work_struct uevent_work;
 	struct nvif_event event;
 	int notify_ref, dead, killed;
 };


