Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F702F260C;
	Thu, 28 May 2026 20:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998823; cv=none; b=n4R8jLM+KhRE+0+1wZoFhG7Ir+/f6lm5CqXqq3RGrdG8z2jh8QJxacFVglUbNMmFty4vgZwveMwu54S95rXIudhu/a0UHMcnbaqHM8hAqaIf8fIMOtCNiLWXdIlVqY9lfuCit3mS1KFEGmvCSd9dwaJZ3xnAd87q3VjGar1gQDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998823; c=relaxed/simple;
	bh=rPViaSZ8yqPcS2KDyT5rzHDpcO6kQv2fzIXD99xWsOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxlDOkNcLbE12AFYpsFsU9OOXVwnhtdX/o0yYOhm9zjd3oVKDZATWK4OEkjE0FdWoibpaqJ43Xd2V/lNcv2cJUeUZ1gPcCHAm+QS78GQL2/O1MTCV5UPdmv9Sp0uqwSvycyr/02So+i2hk54ahwQX62zKLfvXqVB0hox3Nai9Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkzvrh3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkzvrh3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37FB1F000E9;
	Thu, 28 May 2026 20:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998822;
	bh=DjUDhhO0YZ7KvwaGh0+PjjR2ZhLAOZkyIVToIVwEZd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkzvrh3WfDyCnjVtqxK74Rh7kfZ06zSXxzYZIA9kOibm2dcJR3jswkswpg9g1bw6q
	 HZ2sWbzpPgyxRwIf6hKFj04ZqdhNLu+Gn3hZeJ1qJ+BZOdmokDKCqy0JlAmDFB0XmE
	 wX+dbw5vCuOwMx3nnY8hgpmSs6IU6p6MKYgGVcUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 309/461] drm/msm: Fix iommu_map_sgtable() return value check and avoid WARN
Date: Thu, 28 May 2026 21:47:18 +0200
Message-ID: <20260528194656.231963629@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7d449e5202c5d..058c71c82cf54 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -677,7 +677,7 @@ static int msm_iommu_map(struct msm_mmu *mmu, uint64_t iova,
 			 int prot)
 {
 	struct msm_iommu *iommu = to_msm_iommu(mmu);
-	size_t ret;
+	ssize_t ret;
 
 	WARN_ON(off != 0);
 
@@ -686,7 +686,8 @@ static int msm_iommu_map(struct msm_mmu *mmu, uint64_t iova,
 		iova |= GENMASK_ULL(63, 49);
 
 	ret = iommu_map_sgtable(iommu->domain, iova, sgt, prot);
-	WARN_ON(!ret);
+	if (ret < 0)
+		return ret;
 
 	return (ret == len) ? 0 : -EINVAL;
 }
-- 
2.53.0



