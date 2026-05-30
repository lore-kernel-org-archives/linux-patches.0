Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7378E24EA90;
	Sat, 30 May 2026 18:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165211; cv=none; b=H3uSx9L3dEDdlQfisVd6Z8+ffsyf+MiWuU0BhnHA+i1WGt/248LgPrQwUJcE5hMC16BM/lsApAW5uMmE2Mphky/C0rzIIrQBtZL+xvTwLbBWGVWR/E7oat5HuRkgk8Iz7Zv+hiDOCMBKybad1uQJYhxpF7qYh0TInKAcFTJfv8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165211; c=relaxed/simple;
	bh=Sp2A3kXvs1uvii3/dVdKlBPUtxPzFZi61Dt4TkY6RHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ceb5KWFhM4CD96O+bdyOXQ0y8VQfWswmdGNn9bWYnQWq4UD2NyeAv6o/9GXrG5HlTt3CZclXZyrdnAOWml4vzR+JVGWHwcZDtDK20EBo9AraATrBMitnNbI6rvTb0r9ZmwVkoAfa112ubxDWuhZVdMI3Ng5jVVll6Pe01DtIiCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUxPXnT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUxPXnT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B836D1F00893;
	Sat, 30 May 2026 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165210;
	bh=MJHbhrNGXTaoMoWFZA5sh7KQbnnWf7rxLThkVAwfZ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUxPXnT7ejyaZeWl4jP6qQvHsVo8e6JLJkH/ZRKdPKlY7xtWwDXSZXB2qs5UAOnRO
	 YyafV6UauG+K6YypG6d1NpU1hhLu9H//G/yAyELoJfHT3XO9MNPlf84Nl7Fg0tfHCd
	 Aoh5r7mq+VS56Nnx4pJUqk8N+IteXxLRwrX72wIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 755/776] drm/msm: Fix iommu_map_sgtable() return value check and avoid WARN
Date: Sat, 30 May 2026 18:07:49 +0200
Message-ID: <20260530160259.264847475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 55e0f0d1c1a4ee1e46da7da4d443eb3044fb3851 ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

Store the return value in the appropriate type and in case of error,
return it rather than WARNing.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Patchwork: https://patchwork.freedesktop.org/patch/719685/
Message-ID: <20260421-iommu_map_sgtable-return-v1-3-fb484c07d2a1@nvidia.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_iommu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index ef4da3f0cd22d..ede7510562f9d 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -262,14 +262,15 @@ static int msm_iommu_map(struct msm_mmu *mmu, uint64_t iova,
 		struct sg_table *sgt, size_t len, int prot)
 {
 	struct msm_iommu *iommu = to_msm_iommu(mmu);
-	size_t ret;
+	ssize_t ret;
 
 	/* The arm-smmu driver expects the addresses to be sign extended */
 	if (iova & BIT_ULL(48))
 		iova |= GENMASK_ULL(63, 49);
 
 	ret = iommu_map_sgtable(iommu->domain, iova, sgt, prot);
-	WARN_ON(!ret);
+	if (ret < 0)
+		return ret;
 
 	return (ret == len) ? 0 : -EINVAL;
 }
-- 
2.53.0



