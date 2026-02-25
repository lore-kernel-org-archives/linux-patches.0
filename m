Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5D251793;
	Wed, 25 Feb 2026 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983028; cv=none; b=SE6n8y9lqE2kEAYdjPaQPZOFB4efYokxaCha6obfzLbfXvl+P05LLwu1Q7ZYCxx8e98Ezy1AfUll67l1lWyN221kLwJemzp/eJKueyO5SWLpnamX7l1fe83yk9vea3EzwY/SN8g317FqYLLkiBeUfmZOIDD5ZgrNs77dWPijM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983028; c=relaxed/simple;
	bh=zckYWesf7nQTCLbqX8YK9yJQIfrXxS7vWjmLUjzVRlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWNFxcpCAtXS5rIhFH7byrAGx98y+CHVC6becwyjz+0JBVxg9PX7vsXbBU30kxo5jLrFwRNAQxmR181dK8/roS3H/ROiwNNIcZFzKsSunRzbK5P2OZ9uozA35jDnnwpwK2q8M3d8hWciiz1sQBZAWxk+lCjXC5SWENrHnrOGUlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1YHtQPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1YHtQPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67BAC116D0;
	Wed, 25 Feb 2026 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983027;
	bh=zckYWesf7nQTCLbqX8YK9yJQIfrXxS7vWjmLUjzVRlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1YHtQPE7sfZT1Oc1VqbFSQEQcUZnkSuqqjxvaEdtf3plCTxZsYMUXyvSi08X8/PW
	 DfGHKB7u78fOxn86vtlRDwNdGUyUfYawj27PlJ3IqCByR0ogrFXd/YIHkVbTyKHxr/
	 U8iIER2bmRJFFzD3Qjaytjz4wrrgzwHohzyl9RXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 193/781] drm/panthor: Recover from panthor_gpu_flush_caches() failures
Date: Tue, 24 Feb 2026 17:15:02 -0800
Message-ID: <20260225012404.383834767@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 06b231b2460ab..9cb5dee932120 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -289,38 +289,42 @@ int panthor_gpu_l2_power_on(struct panthor_device *ptdev)
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
@@ -360,6 +364,7 @@ int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 		return -ETIMEDOUT;
 	}
 
+	ptdev->gpu->pending_reqs = 0;
 	return 0;
 }
 
-- 
2.51.0



