Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB0344AB7F;
	Tue, 21 Jul 2026 21:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668883; cv=none; b=fD2gvO7JtEQuQEu1gvDWGA6JKXRE8T4osPD14SP6zf3pm34Bm3rSN+O8KjcW2ggsZlaLI3a1DYUnlhZmw++nlY/cBTB3n1PJr/sXpxzy4xlhMpQnCHP71pW7m6G8IIRFNrnOESa10Qsu9IvhwPzP8kE5zHCfyu39k3B4VNl9g5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668883; c=relaxed/simple;
	bh=h6ah32FvRSM2KfNGAP5kXM1hYbN3WCJnJQhkkB5iW14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOsTRbjuGKrjTVQfkBuRe/uFVqPslTJ+oIif9dG3RPUu/gccvuXDHI7JTm6zEHuLaR/garEUaEeZ8jfin8u3N51EDCpwCHzJcijhi6fWQhni8EvJm4bbQccDCZzc3YyPxuKl/FLPybhH6ZwssODQUsetPZkQZpjvcdvOaTz4Zy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXjEmV3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXjEmV3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C051F000E9;
	Tue, 21 Jul 2026 21:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668882;
	bh=rKdsqMiZMNsy86gkUG8/wXLHdzGopqhVrJc/kjpIYGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXjEmV3mulAvhQu98DikWt5kFNxL+s6Vp+xSZb275ERcgw+LY6iI63NDQnWB5W3cu
	 lQ3dRJ+lirqR7mrkcHG6/eiMTpL2IpBdosOwWDX8+Zg+Xpf6SEhk3RjBfYb8SHETJv
	 KqW9r+cUXUng6IYDCgJkqcSySRo+kMfdOIZq37vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0345/1067] drm/tegra: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:15:46 +0200
Message-ID: <20260721152432.313064453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 65b4e4617956c2..3922f86f861515 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -222,6 +222,7 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 {
 	int prot = IOMMU_READ | IOMMU_WRITE;
+	ssize_t size;
 	int err;
 
 	if (bo->mm)
@@ -243,13 +244,15 @@ static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 
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



