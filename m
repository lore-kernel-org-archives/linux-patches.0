Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDD835C68B;
	Tue, 21 Jul 2026 22:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671615; cv=none; b=GLzkYdtn4DsL2PLszIWRZygMfcfBSfD5KN4fX8Cv4OgVTvJcfR9loPSmx4DPxrgTfaW3g+SmqpaLxNa5ILoA+I72qSxft1P+olbE3eIW7atcC/D7EIpWNTYThQp7+f9J2dQURhhTC3hFKHk1vBI/d3w8aaMOy9KT7oa9laF7bZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671615; c=relaxed/simple;
	bh=R69exb2GBz1lzVIX3alSFgHYhgKNBJj/MWm0072aqWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqMh8jXVWkly3rzx2i9iocrVUq3XwL71LXoVB/Ysfs9OulJIPKtiPB/fpKouOPbsijymK70KOlSpv+qqO4Rei3xDm5MxwOGRECXwbmoa02usKQ9Qr3CVOZC2uS+Ecm3dYwdUgXfsp93EtRzHY1L40yf+PXufP1APCRuZb76Mf7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjUAbyVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjUAbyVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36251F000E9;
	Tue, 21 Jul 2026 22:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671614;
	bh=8dC86vS1fzGIKwWLIuhHh7Hzujaw96u6lyAKqbSdP4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjUAbyVjAgP2WUQH31YGiofVtbL9gdDtk7fKtXXofQoW8WBa08XKbMVWu7JtAmwGV
	 BPR+/jQB6561Mwg89UQ5Q2dpasiVot/xhcbo83ncAeli5N0R0y0JQfGJO6mTmWz31L
	 v2EJGIX+MDmQzkcpKgfBi37ABGhHeNiBD6kybalE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/843] drm/tegra: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:18:25 +0200
Message-ID: <20260721152412.098411880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 6ec598f5d5b3ea..bd2362f0a0a84c 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -180,6 +180,7 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 {
 	int prot = IOMMU_READ | IOMMU_WRITE;
+	ssize_t size;
 	int err;
 
 	if (bo->mm)
@@ -201,13 +202,15 @@ static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 
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



