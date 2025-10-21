Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CF9274B29;
	Tue, 21 Oct 2025 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076392; cv=none; b=pepixY42/o4pNN6izrM0ZHZK/3A8mIZZyQRJUD2nUjqavneWXzpDn4vxkIkPSXBSDw0aLTceovQGtKfXKbzvoYCdAu2lvgWYplc3reqqswUBOMeXUOOTMXTLPY1kb1bAf1TJqX8SO32QA7Bx1Si3g02yFnHrQdtUyYiu8KVZNds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076392; c=relaxed/simple;
	bh=3ZZc+ItAU4pmNEf9fraT69KxWiiGr9qGlkrF+Ps5gB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDo3Na0IxyHyuiEXMKn6OjvgZ8GfuDDHF2HbUsajeaw+A4FwN4lsbhVPDnTnWKERsIG8849szcCvB92KG5MIz0gIQXSFygRwlPHgKzMCjpQ9qFmWNyqiqBxmyjX9C8cJ6y6Npmr5HcZ10B8ZAg+LHKCJV9Ji4o46O9tZNgqBjyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVLPZbUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVLPZbUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A388FC4CEF1;
	Tue, 21 Oct 2025 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076392;
	bh=3ZZc+ItAU4pmNEf9fraT69KxWiiGr9qGlkrF+Ps5gB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVLPZbULa0+o2+0k5n28J7r3fMXDl11GTaZ9IZ0qeVneQTH6dghmJCERqqPfs2x23
	 ylzyJOGYe8a6IlIhHPZAlROrQaLxP2/xIDrjhv5zohWWSLrJc524Zn0r3890RJgc/x
	 LvABw95ZdIOAXWDWb9UJUjhKyZHh4o/aHaqReHIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/105] drm/msm/adreno: De-spaghettify the use of memory barriers
Date: Tue, 21 Oct 2025 21:50:30 +0200
Message-ID: <20251021195021.998087443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 43ec1a202cfa9f765412d325b93873284e7c3d82 ]

Memory barriers help ensure instruction ordering, NOT time and order
of actual write arrival at other observers (e.g. memory-mapped IP).
On architectures employing weak memory ordering, the latter can be a
giant pain point, and it has been as part of this driver.

Moreover, the gpu_/gmu_ accessors already use non-relaxed versions of
readl/writel, which include r/w (respectively) barriers.

Replace the barriers with a readback (or drop altogether where possible)
that ensures the previous writes have exited the write buffer (as the CPU
must flush the write to the register it's trying to read back).

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/600869/
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: f248d5d5159a ("drm/msm/a6xx: Fix PDC sleep sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c |    4 +---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |   10 ++++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -460,9 +460,7 @@ static int a6xx_rpmh_start(struct a6xx_g
 	int ret;
 	u32 val;
 
-	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, 1 << 1);
-	/* Wait for the register to finish posting */
-	wmb();
+	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, BIT(1));
 
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_RSCC_CONTROL_ACK, val,
 		val & (1 << 1), 100, 10000);
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1209,14 +1209,16 @@ static int hw_init(struct msm_gpu *gpu)
 	/* Clear GBIF halt in case GX domain was not collapsed */
 	if (adreno_is_a619_holi(adreno_gpu)) {
 		gpu_write(gpu, REG_A6XX_GBIF_HALT, 0);
+		gpu_read(gpu, REG_A6XX_GBIF_HALT);
+
 		gpu_write(gpu, REG_A6XX_RBBM_GPR0_CNTL, 0);
-		/* Let's make extra sure that the GPU can access the memory.. */
-		mb();
+		gpu_read(gpu, REG_A6XX_RBBM_GPR0_CNTL);
 	} else if (a6xx_has_gbif(adreno_gpu)) {
 		gpu_write(gpu, REG_A6XX_GBIF_HALT, 0);
+		gpu_read(gpu, REG_A6XX_GBIF_HALT);
+
 		gpu_write(gpu, REG_A6XX_RBBM_GBIF_HALT, 0);
-		/* Let's make extra sure that the GPU can access the memory.. */
-		mb();
+		gpu_read(gpu, REG_A6XX_RBBM_GBIF_HALT);
 	}
 
 	gpu_write(gpu, REG_A6XX_RBBM_SECVID_TSB_CNTL, 0);


