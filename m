Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17F357A50;
	Wed,  3 Dec 2025 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778823; cv=none; b=T7yS+A6nZ/QDsHl+3tUOKJs69mgjSUiJZf9GlBfUnkhURnVbosqmZ+agcw6EC1GRhQha1eHoO1fKem0aeQ0r6XLoQFi8Wq0rJQgedqwmVQM5E9SiRCFXRHzzeFX0HbaKfaqFkaZMuOiLZY3XApoVbrIz5i9tFyrBttf/cc/1Kk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778823; c=relaxed/simple;
	bh=FSIb3bPXIFZkpe/tyVK8QchfZrE8Zi9Y2Vkx2kNTG3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp8aS/efYKaPbr86wecOi6Lfp6S8vsYci1Ly4LYza7GCymV4zf5AmdsMtla8lY8FVVOQGM0z/ExFp54P9Owzl4dZbc6ZWJjqRw7i12Otmy/q2/eOb+daXU49eW5F6mHt/HgnqZZNGBt4icszoweDSPGyQUTvaYYdZ9VO3veq664=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAA2Y4b/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAA2Y4b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852EDC4CEF5;
	Wed,  3 Dec 2025 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778822;
	bh=FSIb3bPXIFZkpe/tyVK8QchfZrE8Zi9Y2Vkx2kNTG3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAA2Y4b/ADU+pNKmbPNK6Rgx/nLqmOrNb/w8KeeD6ixIos4XMFc+MdkaFuq6YuSwp
	 BalWjbaKEn0PVF1LXpvx22A+qpT9CUou3KCqzRxCZWLplEfk6WkMu9uOdxxYGhymQW
	 tFljLA4WtNBSxHQDooNJgQjd6/88B4wBP8wdJLhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/568] drm/msm/a6xx: Fix GMU firmware parser
Date: Wed,  3 Dec 2025 16:20:39 +0100
Message-ID: <20251203152442.049920740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd1d11104607c..7c1894e5627f8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -689,6 +689,9 @@ static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 	return true;
 }
 
+#define NEXT_BLK(blk) \
+	((const struct block_header *)((const char *)(blk) + sizeof(*(blk)) + (blk)->size))
+
 static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 {
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
@@ -719,7 +722,7 @@ static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 
 	for (blk = (const struct block_header *) fw_image->data;
 	     (const u8*) blk < fw_image->data + fw_image->size;
-	     blk = (const struct block_header *) &blk->data[blk->size >> 2]) {
+	     blk = NEXT_BLK(blk)) {
 		if (blk->size == 0)
 			continue;
 
-- 
2.51.0



