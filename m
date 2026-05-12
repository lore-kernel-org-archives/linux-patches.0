Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD113955D5;
	Tue, 12 May 2026 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608647; cv=none; b=JdQ9KxESnUM2eFJRMOz+9dfN4NgY9SbkHVEC3XBiHmNHs1watsi7JKZ5A2WRbl/I/a9Kd3ZryQwuFwfCU6SGyC8W9TmlMHtSv+eJ8Z9/F3W7LMrFG5jQuGaiU5sff3UjLXs8lvckQEvkDO9k0dzz+esFi/LSZKSCDA4rl+1N8os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608647; c=relaxed/simple;
	bh=HUN4SI2YOaiJgm1VZT+wi0aW34xm/m59H5Om7nZoMGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckwWB7rbwKJDAR6gnxCgFxDL16PUfTa3zrOAZvtooMl2usFkijin54W3KxYZ4M1FuFGVt5MRoYbl7ykPESdNresJAqlEta3Dnzcwkt9i3WbiMq2EOGG53J+25iXeM45g7W6ZRakY35SoKNBK3VJzBELEYZUo/uycZfbiS9u4gMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DedD11Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DedD11Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5031C2BCB0;
	Tue, 12 May 2026 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608647;
	bh=HUN4SI2YOaiJgm1VZT+wi0aW34xm/m59H5Om7nZoMGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DedD11Kw4tLSeT19bDd9IL5gGIPRl0zQn2ivcGQb6E6pOgXM1dUm4zEBxTHNjMG+N
	 qkI8q+HPi8vl8YmLQbMptrg4wbOviheAO5gvRU19RZkDxb777LJJXxZlZsbI2LuMG8
	 ohRgvbJZQ+kld4acM6QKgA05CBbxJAuFJNjtmUDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 159/270] iommu/vt-d: Block PASID attachment to nested domain with dirty tracking
Date: Tue, 12 May 2026 19:39:20 +0200
Message-ID: <20260512173941.793980355@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

commit cc5bd898ff70710ffc41cd8e5c2741cb64750047 upstream.

Kernel lacks dirty tracking support on nested domain attached to PASID,
fails the attachment early if nesting parent domain is dirty tracking
configured, otherwise dirty pages would be lost.

Cc: stable@vger.kernel.org
Fixes: 67f6f56b5912 ("iommu/vt-d: Add set_dev_pasid callback for nested domain")
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20260330101108.12594-2-zhenzhong.duan@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Fixes: 67f6f56b5912 ("iommu/vt-d: Add set_dev_pasid callback for nested  domain")
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/nested.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -154,6 +154,7 @@ static int intel_nested_set_dev_pasid(st
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	struct iommu_domain *s2_domain = &dmar_domain->s2_domain->domain;
 	struct intel_iommu *iommu = info->iommu;
 	struct dev_pasid_info *dev_pasid;
 	int ret;
@@ -161,10 +162,13 @@ static int intel_nested_set_dev_pasid(st
 	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 		return -EOPNOTSUPP;
 
+	if (s2_domain->dirty_ops)
+		return -EINVAL;
+
 	if (context_copied(iommu, info->bus, info->devfn))
 		return -EBUSY;
 
-	ret = paging_domain_compatible(&dmar_domain->s2_domain->domain, dev);
+	ret = paging_domain_compatible(s2_domain, dev);
 	if (ret)
 		return ret;
 


