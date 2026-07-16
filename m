Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A265B22301;
	Thu, 16 Jul 2026 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210086; cv=none; b=MjjG31yqByvu8Xiq6pXGmwXO3/7iltSuzc3Y0nNCxZlzM1XmTS6tJ/TEnbJO66b349s3BLLVdITiG+AUShyg0zZqt+Zs92J86WiAI5Gd+8gB3wkJ1RJTdRCMMzkp7ZZC0Go1amYYp1n2K3J7VkXzQeAJdBgMWWBfMHbDStB6lO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210086; c=relaxed/simple;
	bh=E5ZOIl2bm0hune65r3c44Pxep2FE1Wk8W4sQb7kpYpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/UOOLMH2Ou6LvLMuTa/GwJtKcn3zUtG7otUXfwWd51RheM5AbRPUGto3tlGSN4phbUct1no7syUb10PeGIkADRyLcSd27CwEfGzcEzIVhaG4pe7Iu86VeMkNoVgmgZoLUb+32u3Dl8/gE29OcqfK8zKXvZ5aXKvzOJ4MPzpId4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eipNLy3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eipNLy3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00CE1F000E9;
	Thu, 16 Jul 2026 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210085;
	bh=V15FWg2zcdEjw3/v/Avp1ve1iM4mj8Q+Qf42DD5L2eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eipNLy3KpGyTkmgZ6t7Zqyf/bgKv0rkw3Hme4xgu3U8ije/Gmuc8ofFh/ipoLaEIj
	 rpdhuL4JH/NEylApf9gisj8BwtGhRSbjweTemWvVhaleG/kYZK9FBfXXUIXz9wFJ2o
	 lvjoSvb3CJ9mf0ByhpAnOa82AwkUGjCgKAaQP4Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nareshkumar Gollakoti <naresh.kumar.g@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.1 431/518] iommu/vt-d: Avoid WARNING in sva unbind path
Date: Thu, 16 Jul 2026 15:31:39 +0200
Message-ID: <20260716133057.271996390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 534b5f98ab7319d8004bbc7dab6481462243e883 upstream.

The Intel IOMMU driver allows SVA on devices even if they do not support
PCI/PRI. Commit 39c20c4e83b9 ("iommu/vt-d: Only handle IOPF for SVA when
PRI is supported") modified the SVA bind path to allow this configuration
by skipping IOPF enablement when PRI is missing. However, it failed to
update the unbind path.

This creates an imbalance: the unbind path attempts to disable IOPF for
a device that never had it enabled, triggering a WARNING in
intel_iommu_disable_iopf():

 WARNING: drivers/iommu/intel/iommu.c:3475 at intel_iommu_disable_iopf+0x4f/0x90d
 Call Trace:
  <TASK>
  blocking_domain_set_dev_pasid+0x50/0x70
  iommu_detach_device_pasid+0x89/0xc0
  iommu_sva_unbind_device+0x73/0x150
  xe_vm_close_and_put+0x4d2/0x1200 [xe]

Fix this by bypassing IOPF operations for SVA domains on non-PRI hardware
in both the bind and unbind paths.

Fixes: 39c20c4e83b9 ("iommu/vt-d: Only handle IOPF for SVA when PRI is supported")
Cc: stable@vger.kernel.org
Reported-by: Nareshkumar Gollakoti <naresh.kumar.g@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260519052917.3729796-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.h |   11 +++++++++++
 drivers/iommu/intel/svm.c   |   12 ++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1254,18 +1254,29 @@ void intel_iommu_disable_iopf(struct dev
 static inline int iopf_for_domain_set(struct iommu_domain *domain,
 				      struct device *dev)
 {
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+
 	if (!domain || !domain->iopf_handler)
 		return 0;
 
+	/* SVA with non-IOMMU/PRI IOPF handling is allowed. */
+	if (domain->type == IOMMU_DOMAIN_SVA && !info->pri_supported)
+		return 0;
+
 	return intel_iommu_enable_iopf(dev);
 }
 
 static inline void iopf_for_domain_remove(struct iommu_domain *domain,
 					  struct device *dev)
 {
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+
 	if (!domain || !domain->iopf_handler)
 		return;
 
+	if (domain->type == IOMMU_DOMAIN_SVA && !info->pri_supported)
+		return;
+
 	intel_iommu_disable_iopf(dev);
 }
 
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -164,12 +164,9 @@ static int intel_svm_set_dev_pasid(struc
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
 
-	/* SVA with non-IOMMU/PRI IOPF handling is allowed. */
-	if (info->pri_supported) {
-		ret = iopf_for_domain_replace(domain, old, dev);
-		if (ret)
-			goto out_remove_dev_pasid;
-	}
+	ret = iopf_for_domain_replace(domain, old, dev);
+	if (ret)
+		goto out_remove_dev_pasid;
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
@@ -184,8 +181,7 @@ static int intel_svm_set_dev_pasid(struc
 
 	return 0;
 out_unwind_iopf:
-	if (info->pri_supported)
-		iopf_for_domain_replace(old, domain, dev);
+	iopf_for_domain_replace(old, domain, dev);
 out_remove_dev_pasid:
 	domain_remove_dev_pasid(domain, dev, pasid);
 	return ret;


