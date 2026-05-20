Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B346236D4E1;
	Wed, 20 May 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300576; cv=none; b=kMWjI3X3rSQ5NtdgiTIGJyZ3uFccnDiGnULl8TCB+rrtiJYbD5M97GbEnky2r03XgvmmSIP5se5NO0lBJ2pQTYhuwgwpXIhgg7vSQYp5/tAz8RD/6sfWpz7YEu4lphy/3PSp9vxRjx/myZbylro44UU9UbIDjw296/YeWqZ5CYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300576; c=relaxed/simple;
	bh=/Ec0KN85S43NJ/TPXwP5Lb4unDVxkE4/HwoGumWqRhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQSyH1dcbiXrAcfNpoiicjG9YG5vIoBTb/MAaN0ttoSpDsycRCGfJmBh85Of1aCbnlujTE8YzUr50WRbkBke0OnswI3T4yYRhpgv1og5V+WbcinIxKMEpWadibIWY2/mvelCTJSDArugzCphRHWrY2qtwHBTMuddJeDaFOQiE5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlDgruBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlDgruBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7541F000E9;
	Wed, 20 May 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300575;
	bh=pKmQwl/9z9GFDXmCGQkatvMNdQ6w24+l9VUB5ZMCF/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlDgruBNQcW3XHmxNB305iS51kDWM4Z5zDUzcANGDgYRgEadT+KPpYSHhKw9xZ+KC
	 TyPzvzACrnqaG5l4xd+w0no6vUx4Va1n2Rwyt5h1hSVpSAIZJgXAYiMnY9vBlwXTt5
	 +18p8w3t1nhRbAEnMTt2UjuDtiWFSUBRPpy1SR+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/666] iommu/amd: Do not detach devices in domain free path
Date: Wed, 20 May 2026 18:17:01 +0200
Message-ID: <20260520162115.756002484@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 07bbd660dbd6ff03907d9ddbdfe9deabbd18ac4d ]

All devices attached to a protection domain must be freed before
calling domain free. Hence do not try to free devices in domain
free path. Continue to throw warning if pdom->dev_list is not empty
so that any potential issues can be fixed.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-7-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: faad224fe0f0 ("iommu/amd: Fix clone_alias() to use the original device's devid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index d9b296e007cc7..799e1a1adfc32 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2316,21 +2316,6 @@ static struct iommu_group *amd_iommu_device_group(struct device *dev)
  *
  *****************************************************************************/
 
-static void cleanup_domain(struct protection_domain *domain)
-{
-	struct iommu_dev_data *entry;
-
-	lockdep_assert_held(&domain->lock);
-
-	while (!list_empty(&domain->dev_list)) {
-		entry = list_first_entry(&domain->dev_list,
-					 struct iommu_dev_data, list);
-		BUG_ON(!entry->domain);
-		do_detach(entry);
-	}
-	WARN_ON(!list_empty(&domain->dev_list));
-}
-
 void protection_domain_free(struct protection_domain *domain)
 {
 	WARN_ON(!list_empty(&domain->dev_list));
@@ -2498,16 +2483,7 @@ amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
 {
-	struct protection_domain *domain;
-	unsigned long flags;
-
-	domain = to_pdomain(dom);
-
-	spin_lock_irqsave(&domain->lock, flags);
-
-	cleanup_domain(domain);
-
-	spin_unlock_irqrestore(&domain->lock, flags);
+	struct protection_domain *domain = to_pdomain(dom);
 
 	protection_domain_free(domain);
 }
-- 
2.53.0



