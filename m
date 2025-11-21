Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A2234C802;
	Fri, 21 Nov 2025 13:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732149; cv=none; b=TFOrhCqD7LBEhbp2oXgu2mBKVNV8XfVZIiOujqfTTHhVfW2oDcqBxSdKg1bUcLuFr77bxc3AUu1/6qEEzDTtxuCo+WeTme8O4zuHaV7l9gNGK+zv/VoQc3nHcHGu2S+kpPT4TuHgxkcrdFd7DX3gmYJzQn5qHeEmmz7AIuIyTvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732149; c=relaxed/simple;
	bh=wO5aYqaYisTEaZDl1d9E9FmZ4xb3qPdWxEOL08TTPvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo6F2BToON4rq90ONUva2Z2Twnjm0+glxtm3R0RgxnFZ8hL8+tsH4qdlJbdrpvdh1rKsfJ6F59IoBklH2RxDK6/6PJDfsN4+d2xjct5WYpfS2Q5m31bVUsD+n3s/eq8U5S4N3d2lhK/qESrZLkCrRdaWXeL4GEjgVd7ek+zqu84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+nsnZIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+nsnZIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F4C4CEF1;
	Fri, 21 Nov 2025 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732148;
	bh=wO5aYqaYisTEaZDl1d9E9FmZ4xb3qPdWxEOL08TTPvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+nsnZIooNrZrY7zQ+pps1vtyN9nHeX2aw4PBU0cHj4Xe/soQrqxoRkUzwgq58nIy
	 f0RZaRoO1paC/TEUyzUfj4TNavsREZoF1qVXchoeB1mM9lblR/CKlNqyyYz2sYGzxQ
	 GTb13c2ZjPLWl343GQDBaeRKD3PnciiUznclCTAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/529] drm/msm/a6xx: Fix GMU firmware parser
Date: Fri, 21 Nov 2025 14:05:19 +0100
Message-ID: <20251121130231.720733489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index c50aafa0ecdb6..e816ddcac2f8d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -693,6 +693,9 @@ static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 	return true;
 }
 
+#define NEXT_BLK(blk) \
+	((const struct block_header *)((const char *)(blk) + sizeof(*(blk)) + (blk)->size))
+
 static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 {
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
@@ -723,7 +726,7 @@ static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 
 	for (blk = (const struct block_header *) fw_image->data;
 	     (const u8*) blk < fw_image->data + fw_image->size;
-	     blk = (const struct block_header *) &blk->data[blk->size >> 2]) {
+	     blk = NEXT_BLK(blk)) {
 		if (blk->size == 0)
 			continue;
 
-- 
2.51.0



