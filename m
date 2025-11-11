Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312761D6DB5;
	Tue, 11 Nov 2025 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822470; cv=none; b=bjFR9USfmgaZXcS0IXnvQDHXrwdlsUzOdkYw4mZEPDyDwcM9mu0H2l5E8J8gH3F48DCS4l1tCv3ubFoFnrGdzmNCCvSvuIiMw7O6oPwmAnnYBplGMD2lGC7pQ8VWV20EWQe61HPEnfiVSuXjtlhVNdyZ15Zt37lZhnAaRrWFusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822470; c=relaxed/simple;
	bh=RYFlOeIzRr0Ywt/Gxat/4373vS6KnLmULMRSqFBUfwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUAT6YsVZT1HhWx13xo4BNdfGIkx/vdfY4EzJgWk674N6+7eKokxVS2uSPLplGS5FHCCNAtXfbS8u4ZuKwSu8iuFivfFVhf4QcBkUnBF3j/FOyjjvGWyv8EJbA3qUw/UeMZWf+Ucy/4koCWhvw6RsokIJdqUVN2s720fxNcy3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/MaL702; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/MaL702"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0714C4AF09;
	Tue, 11 Nov 2025 00:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822470;
	bh=RYFlOeIzRr0Ywt/Gxat/4373vS6KnLmULMRSqFBUfwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/MaL702S0C0hFnWjrXp2jamoPkXd1IBkExr+KtGtb3UapFsVMdQaoG/Lzl9SFTVl
	 8YpyvNZ6dOIkDwjMs9dr80APoSqO8a9LwR0TIIxdQ11VLsyvp6F4PKV42nPX9jNMwe
	 lHguF+56R239HOWixIcUk9sPSGMMW5oArUNMTrbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/565] drm/msm/a6xx: Fix GMU firmware parser
Date: Tue, 11 Nov 2025 09:38:00 +0900
Message-ID: <20251111004527.419225349@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit b4789aac9d3441d9f830f0a4022d8dc122d6cab3 ]

Current parser logic for GMU firmware assumes a dword aligned payload
size for every block. This is not true for all GMU firmwares. So, fix
this by using correct 'size' value in the calculation for the offset
for the next block's header.

Fixes: c6ed04f856a4 ("drm/msm/a6xx: A640/A650 GMU firmware path")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/674040/
Message-ID: <20250911-assorted-sept-1-v2-2-a8bf1ee20792@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 8609fa38058ea..bfb1225a47c50 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -730,6 +730,9 @@ static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 	return true;
 }
 
+#define NEXT_BLK(blk) \
+	((const struct block_header *)((const char *)(blk) + sizeof(*(blk)) + (blk)->size))
+
 static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 {
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
@@ -760,7 +763,7 @@ static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 
 	for (blk = (const struct block_header *) fw_image->data;
 	     (const u8*) blk < fw_image->data + fw_image->size;
-	     blk = (const struct block_header *) &blk->data[blk->size >> 2]) {
+	     blk = NEXT_BLK(blk)) {
 		if (blk->size == 0)
 			continue;
 
-- 
2.51.0



