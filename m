Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B8A1DE4EA;
	Wed,  6 Nov 2024 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896059; cv=none; b=NQpZyVd9ZjHXuvwhnAr+7zlWqtUyjFpQQaKQmlIT/f8oO3SL1iTTAibsjNWytwrCoiJ8i6Gp29nofHxZH8v5ftWzwtkf7IlAHDrrDSEibk6uuJbwUhR0PxZKZKOxTIwwvTGX+PZkH9b6PfeJkKgXZDXjY80ULkMClztXFxVm6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896059; c=relaxed/simple;
	bh=8RzyW70rtTu97jnP1SeZbU+sA62kR2iTgdTKzgmFVT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM6ipfzEPDUWyRDRSuTJ6+qcdxgcLDlMpGjiYTQxNa5gr8rq8b2J6mLGEMGCgpW96O4a1qxwKrS2SW90i9KynXWha1womcVy0//l8jeloLutNZ77j8GJF1zQ17cLyiuaoWFDENuZmiRU5FmSOwisP1rGjqzgdxobOLD6fBYHg3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIoX8aC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIoX8aC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50821C4CECD;
	Wed,  6 Nov 2024 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896059;
	bh=8RzyW70rtTu97jnP1SeZbU+sA62kR2iTgdTKzgmFVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIoX8aC+ohvqqXsHD181nLbe5fsBgBxhQGTx9LLxj+QYJaL/U6HFheT+K4V/8JTGN
	 mkNn8f6cF4YlEleluXB4HUfID19zq6UcdRdZfWT8TFMcKe/RscOwBP9MTk+vqommv2
	 N+/SDHo4jwt/BYMPXIn7eT+Vtx6DpHrfb6553ngI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/245] drm/tegra: Fix NULL vs IS_ERR() check in probe()
Date: Wed,  6 Nov 2024 13:02:08 +0100
Message-ID: <20241106120321.052391826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a85df8c7b5ee2d3d4823befada42c5c41aff4cb0 ]

The iommu_paging_domain_alloc() function doesn't  return NULL pointers,
it returns error pointers.  Update the check to match.

Fixes: 45c690aea8ee ("drm/tegra: Use iommu_paging_domain_alloc()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/ba31cf3a-af3d-4ff1-87a8-f05aaf8c780b@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index d79c76a287f22..6a29ac1b2d219 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1152,8 +1152,8 @@ static int host1x_drm_probe(struct host1x_device *dev)
 
 	if (host1x_drm_wants_iommu(dev) && device_iommu_mapped(dma_dev)) {
 		tegra->domain = iommu_paging_domain_alloc(dma_dev);
-		if (!tegra->domain) {
-			err = -ENOMEM;
+		if (IS_ERR(tegra->domain)) {
+			err = PTR_ERR(tegra->domain);
 			goto free;
 		}
 
-- 
2.43.0



