Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CE4C97;
	Tue, 11 Nov 2025 00:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822283; cv=none; b=dvoLqU6SQNgRfC/KoM8z8lTSiwNbPujIhcgFQX1mRZxcyMTxBAcZFk1lCTn22//8Xx0lVrzd++I5myDdaszxQ2jh42BUxS21iWziT9Yi7SPuhl/I1XI82Splt5YSmfonzbpleillN4qT3ZEasjTTHS+4LSM2zsluDmN4lk61EF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822283; c=relaxed/simple;
	bh=q07F884U9jtpbcRVutMt4EWlbovexjALbE7GhO6E5HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4gXo/UqtgQosEFxhi2hfqCkIQrycWXS6wREWKGoAlhvQYmUAx0fpQp9H1efMD+Qn/VkudmdAABBwEkJ2rTwDUptA30KkoZINxFDHY8cCGDztppIksfvD3r8z8CfNq9ndzOazWBI6tK6GN+eu/rpIBFTiJ+if3Cj3ovYvWb8W2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXKIOVdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXKIOVdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB956C4CEFB;
	Tue, 11 Nov 2025 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822283;
	bh=q07F884U9jtpbcRVutMt4EWlbovexjALbE7GhO6E5HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXKIOVdlAepdM9QkzX2EuTbC9YlcncKCt17uoJ0cwF3s6RH8mVQntZyV2DDmTXl8+
	 PY3QIbKpJ4De5CZcL18mfXlyZrnDuPYTf1/DHQ4iFAYSluak8P3SiPmru2YFlrB9Ra
	 moaF8TIXxvqPYFDPv3v7VYcivZovWoW+WTPd4Wwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 034/849] drm/msm/a6xx: Fix GMU firmware parser
Date: Tue, 11 Nov 2025 09:33:24 +0900
Message-ID: <20251111004537.269819787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3369a03978d53..ee82489025c3c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -766,6 +766,9 @@ static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 	return true;
 }
 
+#define NEXT_BLK(blk) \
+	((const struct block_header *)((const char *)(blk) + sizeof(*(blk)) + (blk)->size))
+
 static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 {
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
@@ -797,7 +800,7 @@ static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 
 	for (blk = (const struct block_header *) fw_image->data;
 	     (const u8*) blk < fw_image->data + fw_image->size;
-	     blk = (const struct block_header *) &blk->data[blk->size >> 2]) {
+	     blk = NEXT_BLK(blk)) {
 		if (blk->size == 0)
 			continue;
 
-- 
2.51.0



