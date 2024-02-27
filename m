Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849E13B7AE;
	Tue, 27 Feb 2024 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041294; cv=none; b=EZvyoloxy6wcX+R9u+5YWiEV0mDa6xjvCmq6TN7v77v9McwYq8qyhS49T7bL1scJ0Svi9oumQAHc0Y0YxlkZIELRQbuoinLucquMcDQ1ih2zrSywltDloAxc0m2b3CfI+1keUJ/u7ncTD96hdjoDPgz3E+iflGm/2/aaL9Knq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041294; c=relaxed/simple;
	bh=YJzbrLdvjtTQPk2N3sMC5+bICNMSlMraZVXdafdMsyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNmeyiGfNVGoKN5X7RyVZy0PiINxeqr6+EbnB6f5Lj8y7T+k0nPGFAEMaZ4BfPsrE4rsXvdJA8vzDI6Ce9ntqZs+L94tG0504tVGHO9CwJyLck+b8piXRy/pbwRgPaFIPSOUh4olvXKjfRsCdFjXvgj5vCpFEMhnoJHQ+uS0l9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVrn/QzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVrn/QzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005B8C433C7;
	Tue, 27 Feb 2024 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041294;
	bh=YJzbrLdvjtTQPk2N3sMC5+bICNMSlMraZVXdafdMsyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVrn/QzTtEHuHK2qG1fR9QqVuS29TbiTE9BA8JFpFbeJtmcNb80zsjFzJ7vm9WwxW
	 /cTMCuNbkB52M0rPXens8CjmFEgTcTMqwKXVLQL4wbjbh8KpqSrbBXaz3GdbREoj/P
	 IxurrJyA4aoDcvsvVEmK7XdQ6RF9oK/qgz6ZIBV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 289/334] iommu/vt-d: Update iotlb in nested domain attach
Date: Tue, 27 Feb 2024 14:22:27 +0100
Message-ID: <20240227131640.337441771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 29e10487d6df050afeee886b7c1da208f389cb5b ]

Should call domain_update_iotlb() to update the has_iotlb_device flag
of the domain after attaching device to nested domain. Without it, this
flag is not set properly and would result in missing device TLB flush.

Fixes: 9838f2bb6b6b ("iommu/vt-d: Set the nested domain to a device")
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240208082307.15759-5-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c  | 4 +---
 drivers/iommu/intel/iommu.h  | 1 +
 drivers/iommu/intel/nested.c | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 897159dba47de..0cc6e08e12c13 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -540,8 +540,6 @@ static int domain_update_device_node(struct dmar_domain *domain)
 	return nid;
 }
 
-static void domain_update_iotlb(struct dmar_domain *domain);
-
 /* Return the super pagesize bitmap if supported. */
 static unsigned long domain_super_pgsize_bitmap(struct dmar_domain *domain)
 {
@@ -1362,7 +1360,7 @@ domain_lookup_dev_info(struct dmar_domain *domain,
 	return NULL;
 }
 
-static void domain_update_iotlb(struct dmar_domain *domain)
+void domain_update_iotlb(struct dmar_domain *domain)
 {
 	struct dev_pasid_info *dev_pasid;
 	struct device_domain_info *info;
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index ce030c5b5772a..70ac2b989127a 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -888,6 +888,7 @@ int qi_submit_sync(struct intel_iommu *iommu, struct qi_desc *desc,
  */
 #define QI_OPT_WAIT_DRAIN		BIT(0)
 
+void domain_update_iotlb(struct dmar_domain *domain);
 int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void device_block_translation(struct device *dev);
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index b5a5563ab32c6..694c1c4223f66 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -65,6 +65,8 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 	list_add(&info->link, &dmar_domain->devices);
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
+	domain_update_iotlb(dmar_domain);
+
 	return 0;
 }
 
-- 
2.43.0



