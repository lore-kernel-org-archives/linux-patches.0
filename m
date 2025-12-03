Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C30130AD13;
	Wed,  3 Dec 2025 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775879; cv=none; b=CqZKFP7A1wCYzKsa/cpSZX6cNxuKkA2b8O34nQh2kzyKaqx7DUyVKnFO3Pjcq1zakFMn+9LhD77lQET72nifO+X2YOryntJffzYUXMf6UaECM0Wyav8Rm1/ZOJUvVbBZJaXZOX//kbkKbcrdJixH9YmcAmCp/aIejYQQWCCiz1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775879; c=relaxed/simple;
	bh=F3xeFIj7lp8vtFmjqnqR0uWYNwO7fEL+nZTlqFpbFok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuvAKPqJ7W1XeqId1Uux57nWRKEThy9DKJolSP9A/IgAgR72y1ctvhgPpRxzV+PQfGew3xvuQfjd3uXQCAZpBFQYKApOwP47O92/g48SCar7DgYjZ5uAEL8/8lNPr4yQORptMAhKhvcfsP4EYehIzbNda9UPT2Q+N7RBJbKs7wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiIbBm9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiIbBm9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E8EC4CEF5;
	Wed,  3 Dec 2025 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775878;
	bh=F3xeFIj7lp8vtFmjqnqR0uWYNwO7fEL+nZTlqFpbFok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiIbBm9MpFKzw62zslb3tzUD8VMFRUyKBqWiMPyIk9Z5LZTuO/PSof8Ocg6ocIDgY
	 Z64Dgjeq7oPx4OmGWD1PBbgiHIg3K3uX44SkXe3l/LUh/ZGNC3l76lyZ9yamUHtT5t
	 nDxn4lNQObm4ERJHdwNnANFIyW0Ih+UNCITZVwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/300] drm/msm/a6xx: Fix GMU firmware parser
Date: Wed,  3 Dec 2025 16:23:39 +0100
Message-ID: <20251203152401.022528269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f11da95566dab..e3b36e2373567 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -666,6 +666,9 @@ static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 	return true;
 }
 
+#define NEXT_BLK(blk) \
+	((const struct block_header *)((const char *)(blk) + sizeof(*(blk)) + (blk)->size))
+
 static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 {
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
@@ -696,7 +699,7 @@ static int a6xx_gmu_fw_load(struct a6xx_gmu *gmu)
 
 	for (blk = (const struct block_header *) fw_image->data;
 	     (const u8*) blk < fw_image->data + fw_image->size;
-	     blk = (const struct block_header *) &blk->data[blk->size >> 2]) {
+	     blk = NEXT_BLK(blk)) {
 		if (blk->size == 0)
 			continue;
 
-- 
2.51.0



