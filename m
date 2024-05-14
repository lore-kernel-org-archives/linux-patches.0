Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B802943F;
	Tue, 14 May 2024 11:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685679; cv=none; b=SUZLT8Gq+A6IOJhkSoJhajIxmAjFq0VPA653WbcCX8cL4BqcY995PtSWn/HQqTTZSP5gZA8HVI6lnxld+PXnhx14TPgHO8nspKe/a42TCVjPHyCfnMffuIIfalkgEn5RYkNmbV62/sfzGSz6ikG1YeSeA9mHyXtY/2JBQCJDhtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685679; c=relaxed/simple;
	bh=0D10LbiPErsVbgCAb0GoNsaHTnf5eorfCwyEp8y484c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gypEgTIKYH58xp9DGyI245xy2JE7JrarEsdXFmAb5PvRuZWdmNnr+x7+zrPILcodryygj7Z5zyjrcemyo8rl2huGqqaaWCF9dcAgaxy9T4x33hpKsxEVNwYI1RtSCdTbtGex1NBX5pL5qgtAdDRz156y/SAzXpMzM2U3o5lix0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjxgr57e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjxgr57e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF69C2BD10;
	Tue, 14 May 2024 11:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685679;
	bh=0D10LbiPErsVbgCAb0GoNsaHTnf5eorfCwyEp8y484c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tjxgr57eydfiwKWxAroie0n2tjAjng5hvJHotJ0jV2kuRRs3zn+51ckLIzvQBgRsS
	 05u63kauislM20bsqEid+3ig5il5RS0IQ76glwCOxUDcUEzoMzrDnPK3fd1a/BPA9p
	 gUiUUv/2vi+fJzPO9mGSYP+sv6Y7M0zxXcr4oDfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Alex Constantino <dreaming.about.electric.sheep@gmail.com>,
	Timo Lindfors <timo.lindfors@iki.fi>,
	Dave Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Daniel Vetter <daniel@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 224/301] Reapply "drm/qxl: simplify qxl_fence_wait"
Date: Tue, 14 May 2024 12:18:15 +0200
Message-ID: <20240514101040.713851532@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3628e0383dd349f02f882e612ab6184e4bb3dc10 upstream.

This reverts commit 07ed11afb68d94eadd4ffc082b97c2331307c5ea.

Stephen Rostedt reports:
 "I went to run my tests on my VMs and the tests hung on boot up.
  Unfortunately, the most I ever got out was:

  [   93.607888] Testing event system initcall: OK
  [   93.667730] Running tests on all trace events:
  [   93.669757] Testing all events: OK
  [   95.631064] ------------[ cut here ]------------
  Timed out after 60 seconds"

and further debugging points to a possible circular locking dependency
between the console_owner locking and the worker pool locking.

Reverting the commit allows Steve's VM to boot to completion again.

[ This may obviously result in the "[TTM] Buffer eviction failed"
  messages again, which was the reason for that original revert. But at
  this point this seems preferable to a non-booting system... ]

Reported-and-bisected-by: Steven Rostedt <rostedt@goodmis.org>
Link: https://lore.kernel.org/all/20240502081641.457aa25f@gandalf.local.home/
Acked-by: Maxime Ripard <mripard@kernel.org>
Cc: Alex Constantino <dreaming.about.electric.sheep@gmail.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Timo Lindfors <timo.lindfors@iki.fi>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_release.c |   50 +++-----------------------------------
 include/linux/dma-fence.h         |    7 -----
 2 files changed, 5 insertions(+), 52 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -58,56 +58,16 @@ static long qxl_fence_wait(struct dma_fe
 			   signed long timeout)
 {
 	struct qxl_device *qdev;
-	struct qxl_release *release;
-	int count = 0, sc = 0;
-	bool have_drawable_releases;
 	unsigned long cur, end = jiffies + timeout;
 
 	qdev = container_of(fence->lock, struct qxl_device, release_lock);
-	release = container_of(fence, struct qxl_release, base);
-	have_drawable_releases = release->type == QXL_RELEASE_DRAWABLE;
 
-retry:
-	sc++;
-
-	if (dma_fence_is_signaled(fence))
-		goto signaled;
-
-	qxl_io_notify_oom(qdev);
-
-	for (count = 0; count < 11; count++) {
-		if (!qxl_queue_garbage_collect(qdev, true))
-			break;
-
-		if (dma_fence_is_signaled(fence))
-			goto signaled;
-	}
-
-	if (dma_fence_is_signaled(fence))
-		goto signaled;
-
-	if (have_drawable_releases || sc < 4) {
-		if (sc > 2)
-			/* back off */
-			usleep_range(500, 1000);
-
-		if (time_after(jiffies, end))
-			return 0;
-
-		if (have_drawable_releases && sc > 300) {
-			DMA_FENCE_WARN(fence,
-				       "failed to wait on release %llu after spincount %d\n",
-				       fence->context & ~0xf0000000, sc);
-			goto signaled;
-		}
-		goto retry;
-	}
-	/*
-	 * yeah, original sync_obj_wait gave up after 3 spins when
-	 * have_drawable_releases is not set.
-	 */
+	if (!wait_event_timeout(qdev->release_event,
+				(dma_fence_is_signaled(fence) ||
+				 (qxl_io_notify_oom(qdev), 0)),
+				timeout))
+		return 0;
 
-signaled:
 	cur = jiffies;
 	if (time_after(cur, end))
 		return 0;
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -681,11 +681,4 @@ static inline bool dma_fence_is_containe
 	return dma_fence_is_array(fence) || dma_fence_is_chain(fence);
 }
 
-#define DMA_FENCE_WARN(f, fmt, args...) \
-	do {								\
-		struct dma_fence *__ff = (f);				\
-		pr_warn("f %llu#%llu: " fmt, __ff->context, __ff->seqno,\
-			 ##args);					\
-	} while (0)
-
 #endif /* __LINUX_DMA_FENCE_H */


