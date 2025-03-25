Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846D426B96B;
	Tue, 25 Mar 2025 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906297; cv=none; b=HJvaCTqgvfztzWoYulqMnOUv55sq4HBFAinc0XucVxptqGxo1TUDbaTSAsqtytpo8J5hm+Ukp6/Ho/oVVONm0AoS9lvjwM+vkeoFl0nJ1KNcACcPPZHVl03F7EEl32AL5louyXYOj4rBInn0qZCogxvy3ffccKEm/hpOv9yXfzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906297; c=relaxed/simple;
	bh=JYKhM14Bqi7EaYyWPiSxPvJbcm02IrK9Fr/j4/7xvds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecFTgDKtC9WwaF/RTFFFVZ+OpV2Tdh74gw1xwUpbIiL1u1oNS0Q5T6AHF8lw+dYAQUrw9VpT79UP4t8qCJXi/D28fAm6G0AsV2LCHwcw/QmlNycF4izqpukRbY+GjUSecqJWG3twRiLstnZ4Q0PXnN1RURqhcaHbWn8ze12ETc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6cIoZwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6cIoZwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299B1C4CEE4;
	Tue, 25 Mar 2025 12:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906297;
	bh=JYKhM14Bqi7EaYyWPiSxPvJbcm02IrK9Fr/j4/7xvds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6cIoZwDSXfBgWhwz+jzqL/yzLtYM1sGtVLm0KD2nkPl7rHDWBlSpDuT1jbiOuBBX
	 pZnHIMIOrmfb2iRwCVymGpcdRyq8FJMaXDZ6TMAlEdUfdjmGZA+s0c1QQ8ANw+COmC
	 TaGoLUiJPt9aB9Gg97X0uBV63MuW7srZxWtGl8o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/116] gpu: host1x: Do not assume that a NULL domain means no DMA IOMMU
Date: Tue, 25 Mar 2025 08:22:10 -0400
Message-ID: <20250325122150.308325801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit cb83f4b965a66d85e9a03621ef3b22c044f4a033 ]

Previously with tegra-smmu, even with CONFIG_IOMMU_DMA, the default domain
could have been left as NULL. The NULL domain is specially recognized by
host1x_iommu_attach() as meaning it is not the DMA domain and
should be replaced with the special shared domain.

This happened prior to the below commit because tegra-smmu was using the
NULL domain to mean IDENTITY.

Now that the domain is properly labled the test in DRM doesn't see NULL.
Check for IDENTITY as well to enable the special domains.

This is the same issue and basic fix as seen in
commit fae6e669cdc5 ("drm/tegra: Do not assume that a NULL domain means no
DMA IOMMU").

Fixes: c8cc2655cc6c ("iommu/tegra-smmu: Implement an IDENTITY domain")
Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Closes: https://lore.kernel.org/all/c6a6f114-3acd-4d56-a13b-b88978e927dc@tecnico.ulisboa.pt/
Tested-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/0-v1-10dcc8ce3869+3a7-host1x_identity_jgg@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 710674ef40a97..3f23a7d91519f 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -367,6 +367,10 @@ static bool host1x_wants_iommu(struct host1x *host1x)
 	return true;
 }
 
+/*
+ * Returns ERR_PTR on failure, NULL if the translation is IDENTITY, otherwise a
+ * valid paging domain.
+ */
 static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(host->dev);
@@ -391,6 +395,8 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
 	 * Similarly, if host1x is already attached to an IOMMU (via the DMA
 	 * API), don't try to attach again.
 	 */
+	if (domain && domain->type == IOMMU_DOMAIN_IDENTITY)
+		domain = NULL;
 	if (!host1x_wants_iommu(host) || domain)
 		return domain;
 
-- 
2.39.5



