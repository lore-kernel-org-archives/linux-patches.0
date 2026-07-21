Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E700470453;
	Tue, 21 Jul 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656081; cv=none; b=OJcCm3t92rW0Cd6dcSDKsYLWt6AMQoTND2m2PeZ/y71itWnm7xda7jCP7UiqwcfFg4Hovx0ZEaNybGI2ZXp1LCJCFbjQWe4Udz/JR/R/wyFIPn/0ySeTUFdYq/1Pykg5kyFySfVPL3SK3DZEzPrD7qvJWugrPNmnOWbw9tBzjUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656081; c=relaxed/simple;
	bh=eLLQUy/4BxvnnKsg/ol2unZWSpLDm+8eKgaFZPRor2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa5JXV1srM5LzQJhLc6KT0MQUz9EAms0iFS81JgZZS2N0Yssc2zvJOOiPIS47v2OVQ1FK1cj0ZO48PhpUw3pL+CtOBV8nBy0Xso8Xw5WVJtxHhbb+Ym4mnV2SCjgui097R34sRtShnfgp+/DlkoAvnZAXbwSkn3PaYZjfqCSP7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaBxJBoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaBxJBoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9E81F00A3A;
	Tue, 21 Jul 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656075;
	bh=nFuvDsJ4oqES4DEgDX8/Z0XG7LPImRETOetkPJmIqiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaBxJBoGN9IdO4P6W3Ef689kt/vUBgS0sO1uRasJ8tmVKDGt5NR1h/mo5uDHEJKwY
	 21nFTq0d1qe8nAF0eKW5trTqbrbAf+yH3HfkLy3elm1u1mlz+OoHl4sj7pzKDlZaCe
	 g8JmU8z6pPUCru8n3WudUQ/XRZQHtaakMP2gJytc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0251/1611] drm/tegra: Fix iommu_map_sgtable() return value check
Date: Tue, 21 Jul 2026 17:06:07 +0200
Message-ID: <20260721152520.679898219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fab3edbe33a6cb..abfac20d63fd2b 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -233,6 +233,7 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 {
 	int prot = IOMMU_READ | IOMMU_WRITE;
+	ssize_t size;
 	int err;
 
 	if (bo->mm)
@@ -254,13 +255,15 @@ static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
 
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



