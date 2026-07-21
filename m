Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A8746C4B7;
	Tue, 21 Jul 2026 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648837; cv=none; b=TwqVidu6sb33y5QvslabTLR0xu4bOBSzd1P5NKILQNRzke1kW/ztkKN0EymXjRljpyAjB4DWvIn1HPJsRnYt/WhkuFs/vYaCsSDsFydVjy53Md4XHRgG+FkJN+4WO9NuzAf7y0GXTm51CCe17eSBP1+FkwPH87aIhuSjYH/o85M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648837; c=relaxed/simple;
	bh=Q5aiCc8C3MIaUE2YJvJLFHPQ9zDwc0OjBLNPc9lXuMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4tT0Uyxw9ZyJosGOh3Mgr46I1u5ncRy8Nq/pcMlLQC+NnHIKlPshtcNxT6hNK0wS5IMwEWeONvwOoJIHSFMtL2Itfpe1DCQU/+65DaXS1EeJVmbm58T7EHb+WK+Q0ch0UkKYzY/mP37XlW/InrpUN1cG7zw+MwBxW+MCtvHMiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmUAsF/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmUAsF/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F531F00A3F;
	Tue, 21 Jul 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648836;
	bh=PhwhxBiWq0BXQJ6kijtHZsdspTIAUAROs2mHbC5VgUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmUAsF/zrYW2S7Vq2P0qxaFIoOKWKVLbd2nbJxo+USBmzUmXgZCwzA6z0AUWUJQ8X
	 UclSnxw4BXhVL2CuuAFRq07drI/0XjNol62D9HZeM1V2kR3ddljS+xmgfX/N9lMT06
	 t0yh5STuezpKGydyaWertPkqnlMKxWPXuYu2X86E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0349/2077] drm/tegra: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:00:22 +0200
Message-ID: <20260721152600.923811903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit b3f349517de8f4469c385ebb7bfdfcc148790c0f ]

Commit "iommu: return full error code from iommu_map_sg[_atomic]()"
changed iommu_map_sgtable() to return an ssize_t and negative values
in error cases, rather than a size_t and a zero.

Update tegra_bo_iommu_map() to correctly check for errors from
iommu_map_sgtable.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421-iommu_map_sgtable-return-v1-2-fb484c07d2a1@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 2377e2b76397a3..436394e0481252 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -234,6 +234,7 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 {
 	int prot = IOMMU_READ | IOMMU_WRITE;
+	ssize_t size;
 	int err;
 
 	if (bo->mm)
@@ -255,13 +256,15 @@ static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 
 	bo->iova = bo->mm->start;
 
-	bo->size = iommu_map_sgtable(tegra->domain, bo->iova, bo->sgt, prot);
-	if (!bo->size) {
+	size = iommu_map_sgtable(tegra->domain, bo->iova, bo->sgt, prot);
+	if (size < 0) {
 		dev_err(tegra->drm->dev, "failed to map buffer\n");
-		err = -ENOMEM;
+		err = size;
 		goto remove;
 	}
 
+	bo->size = size;
+
 	mutex_unlock(&tegra->mm_lock);
 
 	return 0;
-- 
2.53.0



