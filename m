Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2EB6DD1D;
	Tue, 14 May 2024 10:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683655; cv=none; b=PKCA/r3VCJnrru5S9ImwRWzm9mX84ldh5oYnto6uL8Ko5ofeJ/X/hMTvJ426e4SxznwfLW6sWclQzRxLHV4DuzeQGAGbu4ZhoEkZ8RCpD6vVIEG07C5z7sx2Au+rurbNAtlQJat/gwInpBqWUWO4+AFAU8lKvZdt3pkIkNd6VwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683655; c=relaxed/simple;
	bh=m52KnLi0ZdeAL0t5UN0lh9zpHE/Y5CObrP31hQ4s8lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/+xcNMqITv93bsFg/D2OSX34g4OKjrynSum/0HCMpiLuRM+Ylxl4pxec8aMFJNVTN/M2UUizcjhenaGBKw3g2Laj8ajOlFT+6gfywtPNPbjMgpDzzaXGSAbSwxnWX4asYWVZWt2pa7U8Nu4qb7D2PU9E8z9OENdmoYEWvlHsBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZRHRuoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZRHRuoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F115BC2BD10;
	Tue, 14 May 2024 10:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683654;
	bh=m52KnLi0ZdeAL0t5UN0lh9zpHE/Y5CObrP31hQ4s8lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZRHRuoG8ZJueI+zHOWlhS4r//V93+j7PMpPpIrBs/a/AESHslhKg1JHfsPhIXDsc
	 8RjvxZZBU0OWIdB8L5nTIceNVKPCWe4qY3NpXOKKghAylODutg+Fs7n8hZkhHDDfSa
	 vo7bytYrkwQzQNJceCBX97mQ8/K8rTreruxWTxmg=
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
Subject: [PATCH 6.8 244/336] Reapply "drm/qxl: simplify qxl_fence_wait"
Date: Tue, 14 May 2024 12:17:28 +0200
Message-ID: <20240514101047.831949132@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -682,11 +682,4 @@ static inline bool dma_fence_is_containe
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


