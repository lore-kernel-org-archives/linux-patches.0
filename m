Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04718268C6D;
	Tue, 25 Mar 2025 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905935; cv=none; b=dXEy2voW2ZlQ0KuNTlYoeMMFN9VtUNjYs5QyTPKao8GOsqVMrhHyf8NCjvtx56iRP3yRVgsmp68HwEfSePPouccrSW8sWpMYvy/1fAkUPvR7nm9PFlxga2hkrUvrG41WhTcfjIPE8ZUeNC9pzeUQQi3r1EQytvsv6vfcKChNdj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905935; c=relaxed/simple;
	bh=xiEFL14v2z7PBkD5g0AL4R/v116k9iaSHUeM53egzK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUN3YIqOkyAkUvePN7quUgWZfhtKNWDWPBarm+mZ9WRj+q4vGnjGPQu3Fukiz0L0EkdZi/WllkuwiM2Z7uaavAJDqm0i9P2ASrTw2tY61/w10JSiz/DL2l9/m8mZtfT5rbKb8GeKLUYSmKW8HQUseIlMFaqEF7SpQlcuyP+A8qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMRiwHqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMRiwHqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3579C4CEE4;
	Tue, 25 Mar 2025 12:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905934;
	bh=xiEFL14v2z7PBkD5g0AL4R/v116k9iaSHUeM53egzK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMRiwHqeSlBOzaTjxxM+24EJ/pgzcJ/BIeY66PSYMfj3miUb8qh2gE/vWW2nOgLva
	 MJyZGLwRN6zSR83XOBrSqnY6czt+I6MRF2tmVSxvaxW9peONFiaLBMuXjz7t1yBCXp
	 cWjxpoZXO0V7UjYzGOvtgxa0tB4Ix0k37y7proJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/119] gpu: host1x: Do not assume that a NULL domain means no DMA IOMMU
Date: Tue, 25 Mar 2025 08:21:42 -0400
Message-ID: <20250325122150.181840202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 46cae925b0959..1f93e5e276c08 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -361,6 +361,10 @@ static bool host1x_wants_iommu(struct host1x *host1x)
 	return true;
 }
 
+/*
+ * Returns ERR_PTR on failure, NULL if the translation is IDENTITY, otherwise a
+ * valid paging domain.
+ */
 static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(host->dev);
@@ -385,6 +389,8 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
 	 * Similarly, if host1x is already attached to an IOMMU (via the DMA
 	 * API), don't try to attach again.
 	 */
+	if (domain && domain->type == IOMMU_DOMAIN_IDENTITY)
+		domain = NULL;
 	if (!host1x_wants_iommu(host) || domain)
 		return domain;
 
-- 
2.39.5



