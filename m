Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0438379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301729; cv=none; b=YKDi+ObNd8HztfTihlEVlZmgHItgwsCIfBxnU0FtTq4uojt457bu1mZiKreneAbhs7eBTMGYXkAbxH/RAecqIjFfLB06AiMETTGuoo/iSk/C3mZSn4VSlitCjQD3ApUby1kS67eXGnuxTrmiWDiEFbFqeP0eY3no42jygZUNeCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301729; c=relaxed/simple;
	bh=ln5iVxIkbVPwkTavUvpbic1jBAnTs5g8BgwuExKnqCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtWKw6315z3Zzmvr863AjTE2pa3iGYqVQhrhwsssJs85gyTyYcLwfpUo6gweDrQevZ6ZTkqpL63CpNFtHGPAdHjOtR6f2sSR3q2Pz/lifT/ywgjvoor7JKzZNSZYh8P4l1iLj3n2KNEvMZoi282ke0hUA5mYFw17viRxqtyptaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdOCip7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdOCip7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAB3C19424;
	Sat, 28 Feb 2026 18:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301729;
	bh=ln5iVxIkbVPwkTavUvpbic1jBAnTs5g8BgwuExKnqCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdOCip7knKB/0SvAZE1vp5S9aRlCRMxk7ZS8LQnpHf8KLSa1M+UndhtdB4fgNP97Z
	 1Yg19mARau2MTbMpsE010dkuj0GFT25s/PDhxBYP+1V2mBxOpbCphnKOVE4S0x50Vp
	 JPA4LpKbnfOYE7s+A9ZmzahSUH4RsscmBwiC8CRVqp4CMSAOTuOy6ET0QBu4V70FxQ
	 CHu0+V0nkrmyWi4QZ+RoWY0yvlxfUE0KbRaTSbI2PDPtItpNlq4dioHrk3/s6vDR3G
	 eOsnuv0vOX+AYnznUOY94y4zlyrm7LC217e1bsGIiBLJnBZve/2V5HDyb8io9WGKHy
	 2KM3Ron4kziYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/385] drm/panthor: Recover from panthor_gpu_flush_caches() failures
Date: Sat, 28 Feb 2026 12:55:50 -0500
Message-ID: <20260228180011.1568201-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 3c0a60195b37af83bbbaf223cd3a78945bace49e ]

We have seen a few cases where the whole memory subsystem is blocked
and flush operations never complete. When that happens, we want to:

- schedule a reset, so we can recover from this situation
- in the reset path, we need to reset the pending_reqs so we can send
  new commands after the reset
- if more panthor_gpu_flush_caches() operations are queued after
  the timeout, we skip them and return -EIO directly to avoid needless
  waits (the memory block won't miraculously work again)

Note that we drop the WARN_ON()s because these hangs can be triggered
with buggy GPU jobs created by the UMD, and there's no way we can
prevent it. We do keep the error messages though.

v2:
- New patch

v3:
- Collect R-b
- Explicitly mention the fact we dropped the WARN_ON()s in the commit
  message

v4:
- No changes

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251128084841.3804658-4-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 1ca2924e6d552..15e4371d98945 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -384,38 +384,42 @@ int panthor_gpu_l2_power_on(struct panthor_device *ptdev)
 int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 			     u32 l2, u32 lsc, u32 other)
 {
-	bool timedout = false;
 	unsigned long flags;
+	int ret = 0;
 
 	/* Serialize cache flush operations. */
 	guard(mutex)(&ptdev->gpu->cache_flush_lock);
 
 	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-	if (!drm_WARN_ON(&ptdev->base,
-			 ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
+	if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
 		ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
 		gpu_write(ptdev, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
+	} else {
+		ret = -EIO;
 	}
 	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 
+	if (ret)
+		return ret;
+
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED),
 				msecs_to_jiffies(100))) {
 		spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
 		if ((ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED) != 0 &&
 		    !(gpu_read(ptdev, GPU_INT_RAWSTAT) & GPU_IRQ_CLEAN_CACHES_COMPLETED))
-			timedout = true;
+			ret = -ETIMEDOUT;
 		else
 			ptdev->gpu->pending_reqs &= ~GPU_IRQ_CLEAN_CACHES_COMPLETED;
 		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 	}
 
-	if (timedout) {
+	if (ret) {
+		panthor_device_schedule_reset(ptdev);
 		drm_err(&ptdev->base, "Flush caches timeout");
-		return -ETIMEDOUT;
 	}
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -455,6 +459,7 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 		return -ETIMEDOUT;
 	}
 
+	ptdev->gpu->pending_reqs = 0;
 	return 0;
 }
 
-- 
2.51.0

