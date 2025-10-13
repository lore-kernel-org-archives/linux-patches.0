Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA64730F543;
	Mon, 13 Oct 2025 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369671; cv=none; b=bI6oMETOU2NfNZu0rjDpDQK5EvoIbJmnK8TLXu5d5lBw0fLvYACvg9PEFcroEHHk81x5csB2vCDl+dxo5Np//FXrSF+DXXr6LmI8W3Wy3P3o638yV01rhphZEglrAL+gTInoehth9txNn2urffnK1nFO/AAd4RT40auJl+2F+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369671; c=relaxed/simple;
	bh=Lg0ENwjqkNiTcYTPxDc437r4y+WAd9VH1CGkSHqWdqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdG2jJ5AXRd3mUmkJ2U/KtOMfqOvmVxVRlEeeYHK9tdLBmIuCOXHNrHGnAzA+a2HPrExoRSSiz/+AK0q1bVO3Muf0fxaredwXcLUzpl9Buan5zTspssWsywweWbCyqBMsdBBKpVs2lApucGvv5E4OeWheqwJEuSq3isiKz6a86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsVs5FVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsVs5FVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45076C116B1;
	Mon, 13 Oct 2025 15:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369671;
	bh=Lg0ENwjqkNiTcYTPxDc437r4y+WAd9VH1CGkSHqWdqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsVs5FVLMoRy9ILxaHHJBTgHogzVOHL1XFAkziyeE6fjE1iM64sUo2VGpWXqePYW1
	 BZ9g8ileiUwC9cSwpVTFFpJ+kTUCxI8ubHsy/A2xHbQ5ANYA256FrDMc7oKAwRzXjJ
	 /0xp277WwF/QXL533q3vDp1tzZgbe8xWEkWALjtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 328/563] drm/msm: stop supporting no-IOMMU configuration
Date: Mon, 13 Oct 2025 16:43:09 +0200
Message-ID: <20251013144423.144801786@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c94fc6d35685587aa0cb9a8d7d7062c73ab04d89 ]

With the switch to GPUVM the msm driver no longer supports the no-IOMMU
configurations (even without the actual GPU). Return an error in case we
face the lack of the IOMMU.

Fixes: 111fdd2198e6 ("drm/msm: drm_gpuvm conversion")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/672559/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_kms.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_kms.c b/drivers/gpu/drm/msm/msm_kms.c
index 56828d218e88a..4c4dcb095c4df 100644
--- a/drivers/gpu/drm/msm/msm_kms.c
+++ b/drivers/gpu/drm/msm/msm_kms.c
@@ -195,14 +195,13 @@ struct drm_gpuvm *msm_kms_init_vm(struct drm_device *dev)
 		iommu_dev = mdp_dev;
 	else
 		iommu_dev = mdss_dev;
-
 	mmu = msm_iommu_disp_new(iommu_dev, 0);
 	if (IS_ERR(mmu))
 		return ERR_CAST(mmu);
 
 	if (!mmu) {
-		drm_info(dev, "no IOMMU, fallback to phys contig buffers for scanout\n");
-		return NULL;
+		drm_info(dev, "no IOMMU, bailing out\n");
+		return ERR_PTR(-ENODEV);
 	}
 
 	vm = msm_gem_vm_create(dev, mmu, "mdp_kms",
-- 
2.51.0



