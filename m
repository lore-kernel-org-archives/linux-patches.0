Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50034346A08;
	Sat, 12 Sep 2026 07:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198910; cv=none; b=TVFVl53ssgOMB1Us7bHbpfFbhsSSsRVgt7y9JHO0BH7kQ2LMb0dm82ilvkC7xYdl6n151vIssgHxQQDU8XS5ZIxQv36RaM/9nhS+osCGJNgXDTsFodzF8lnLKplC+xF/fwZ2Q91SaPjqsg3HHgYN+FYEoH6udvg1G6CbgtW9IQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198910; c=relaxed/simple;
	bh=XHKCLhKlrVf8ZI0Rvf13VCyaLXW1+8dvmB8LaJ+OpXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WalpCvL7LfZCIA8RZrq8CwXHE0vvallrEVnlGZjy8YJlHCCntudgijWiyEfIPXSDR17tmOCVvQgkf4/kmaMOLJxjWZ/LetCg0Rqv3D2VjdT30PTaBqKtcoUtHZE2elLAzeXQ02DhW7W72/nvEn5a/WUgmIwxHwJpr2z1S9JWB2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NViCGqhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NViCGqhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07151F000FF;
	Sat, 12 Sep 2026 07:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198908;
	bh=uFHfu52OWexObinqUTNtEb+K2qx2bSNpVlwcgrS8Ctk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NViCGqhU1eM4/NqzkY9cSocP630ScYm/haijcqhFgBbJaNRafZnwji227a0q9pg1h
	 h/anZ80xwvIQGD/G1xDGMVBrgaDFNY/4OAh3ImavrMmNJA2DaoEVgx+fmjkGJRAML5
	 mvKn+s/r2cw1YeRwFER4HQGFJYiadjhzFiNi9BDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0477/1815] drm/msm/a6xx: Fix IRQ storm during msm_recovery test
Date: Sat, 12 Sep 2026 08:37:07 +0200
Message-ID: <20260912065700.087429127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit bc024d325e98b6b2806e00455e030622fb8e1820 ]

Once a hang is triggered by the msm_recovery test, the gpu error irq
remains asserted and triggers an interrupt storm. In the worst case,
this IRQ storm lands on the CPU core where the hangcheck timer is
scheduled, blocking it from running. This eventually leads to CPU
watchdog timeouts.

To fix this, mask the gpu error irqs during msm_recovery test and
enable them back during the recovery.

Fixes: 5edf2750d998 ("drm/msm: Add debugfs to disable hw err handling")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730660/
Message-ID: <20260605-assorted-fixes-june-v1-5-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 5 +++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 5 ++++-
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c | 5 ++++-
 drivers/gpu/drm/msm/msm_gpu.c         | 2 ++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 2c0bbac43c52b..f1df2514c6132 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1275,6 +1275,11 @@ static irqreturn_t a5xx_irq(struct msm_gpu *gpu)
 		status & ~A5XX_RBBM_INT_0_MASK_RBBM_AHB_ERROR);
 
 	if (priv->disable_err_irq) {
+		/* Turn off interrupts to avoid interrupt storm */
+		gpu_write(gpu, REG_A5XX_RBBM_INT_0_MASK,
+			       A5XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS |
+			       A5XX_RBBM_INT_0_MASK_CP_SW);
+
 		status &= A5XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS |
 			  A5XX_RBBM_INT_0_MASK_CP_SW;
 	}
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index a44380316aaa9..e293b4ca808a4 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1911,8 +1911,11 @@ static irqreturn_t a6xx_irq(struct msm_gpu *gpu)
 
 	gpu_write(gpu, REG_A6XX_RBBM_INT_CLEAR_CMD, status);
 
-	if (priv->disable_err_irq)
+	if (priv->disable_err_irq) {
+		/* Turn off interrupts to avoid interrupt storm */
+		gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, A6XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS);
 		status &= A6XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS;
+	}
 
 	if (status & A6XX_RBBM_INT_0_MASK_RBBM_HANG_DETECT)
 		a6xx_fault_detect_irq(gpu);
diff --git a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
index 9e44fd1ae6346..0f6fd35bd5878 100644
--- a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
@@ -1211,8 +1211,11 @@ irqreturn_t a8xx_irq(struct msm_gpu *gpu)
 
 	gpu_write(gpu, REG_A8XX_RBBM_INT_CLEAR_CMD, status);
 
-	if (priv->disable_err_irq)
+	if (priv->disable_err_irq) {
+		/* Turn off interrupts to avoid interrupt storm */
+		gpu_write(gpu, REG_A8XX_RBBM_INT_0_MASK, A6XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS);
 		status &= A6XX_RBBM_INT_0_MASK_CP_CACHE_FLUSH_TS;
+	}
 
 	if (status & A6XX_RBBM_INT_0_MASK_RBBM_HANG_DETECT)
 		a8xx_fault_detect_irq(gpu);
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 9ac7740a87f01..48ac51f4119be 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -552,6 +552,8 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
+	priv->disable_err_irq = false;
+
 	gpu->funcs->recover(gpu);
 
 	/* retire completed submits, plus the one that hung: */
-- 
2.53.0



