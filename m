Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4383F9F21;
	Wed, 20 May 2026 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301569; cv=none; b=qk5PI6RkP3+8l6fjsO/Lr9wk+LMqwGXOwXXWHYyz2PTAP9yy1k/HiA+bONlRvvQ4YvGbpmneYzXaeT/bQmJ73NYWIHgN8ktJvCrdxKSIpMBkF1rqf67fAuiS4Ol7iIp9/3g+yARurWyLehcUfLTORu+BEx40DOw3zvBVycwTSnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301569; c=relaxed/simple;
	bh=UWfVY/ZUYkkVx3NhhK1nR/42bNXJbLDzKTb4FTDHHyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIijohU7PN7xJgiiK1fNbA+uKF0DZvsmd3URT+3ouiDfrFTdr4d4DVJ6LyJ8JrD+4u225hKzfe3tSZPT2eICIOKVAOITuuRdv96cEUi0W8vQo1+QNe8cd0jrNIX0QvDeBgAgbxUxWbcKvHVJYkrY8Jge1JBvRiNsroexcS/+GYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iuucoxwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iuucoxwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACDF1F000E9;
	Wed, 20 May 2026 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301567;
	bh=EjdaP7OaWpv+e3AM9vbsHIp3noK1PrgK347YlsiTarE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuucoxwaB5Gfml7PE3UxrI//qeNtfrm7iDeS981i3EMV+C6IY/tdixaBCxttZub/z
	 jM/4pITVy/gXhMxJf9ZKIFse9hgRwVT97j5i3c3YytpFLWR9GpihGxf4oSsemT6CPp
	 BOTvuMteaeS2907flDQ8iJTOdqZZGFvJfG55lRgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 603/666] iommu/amd: Reorder attach device code
Date: Wed, 20 May 2026 18:23:34 +0200
Message-ID: <20260520162124.337699951@linuxfoundation.org>
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

[ Upstream commit 0b136493d3ffa1358783dcf5b9f866ceef2ff122 ]

Ideally in attach device path, it should take dev_data lock before
making changes to device data including IOPF enablement. So far dev_data
was using spinlock and it was hitting lock order issue when it tries to
enable IOPF. Hence Commit 526606b0a199 ("iommu/amd: Fix Invalid wait
context issue") moved IOPF enablement outside dev_data->lock.

Previous patch converted dev_data lock to mutex. Now its safe to call
amd_iommu_iopf_add_device() with dev_data->mutex. Hence move back PCI
device capability enablement (ATS, PRI, PASID) and IOPF enablement code
inside the lock. Also in attach_device(), update 'dev_data->domain' at
the end so that error handling becomes simple.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241030063556.6104-11-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 4a552f7890f0 ("iommu/amd: Put list_add/del(dev_data) back under the domain->lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 65 +++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a5adc4714f5c9..6f2ce142dff7a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2291,6 +2291,7 @@ static int attach_device(struct device *dev,
 {
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	struct pci_dev *pdev;
 	int ret = 0;
 
 	mutex_lock(&dev_data->mutex);
@@ -2300,10 +2301,6 @@ static int attach_device(struct device *dev,
 		goto out;
 	}
 
-	/* Update data structures */
-	dev_data->domain = domain;
-	list_add(&dev_data->list, &domain->dev_list);
-
 	/* Do reference counting */
 	ret = pdom_attach_iommu(iommu, domain);
 	if (ret)
@@ -2318,6 +2315,28 @@ static int attach_device(struct device *dev,
 		}
 	}
 
+	pdev = dev_is_pci(dev_data->dev) ? to_pci_dev(dev_data->dev) : NULL;
+	if (pdev && pdom_is_sva_capable(domain)) {
+		pdev_enable_caps(pdev);
+
+		/*
+		 * Device can continue to function even if IOPF
+		 * enablement failed. Hence in error path just
+		 * disable device PRI support.
+		 */
+		if (amd_iommu_iopf_add_device(iommu, dev_data))
+			pdev_disable_cap_pri(pdev);
+	} else if (pdev) {
+		pdev_enable_cap_ats(pdev);
+	}
+
+	/* Update data structures */
+	dev_data->domain = domain;
+	list_add(&dev_data->list, &domain->dev_list);
+
+	/* Update device table */
+	dev_update_dte(dev_data, true);
+
 out:
 	mutex_unlock(&dev_data->mutex);
 
@@ -2332,7 +2351,6 @@ static void detach_device(struct device *dev)
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct protection_domain *domain = dev_data->domain;
-	bool ppr = dev_data->ppr;
 	unsigned long flags;
 
 	mutex_lock(&dev_data->mutex);
@@ -2346,13 +2364,15 @@ static void detach_device(struct device *dev)
 	if (WARN_ON(!dev_data->domain))
 		goto out;
 
-	if (ppr) {
+	/* Remove IOPF handler */
+	if (dev_data->ppr) {
 		iopf_queue_flush_dev(dev);
-
-		/* Updated here so that it gets reflected in DTE */
-		dev_data->ppr = false;
+		amd_iommu_iopf_remove_device(iommu, dev_data);
 	}
 
+	if (dev_is_pci(dev))
+		pdev_disable_caps(to_pci_dev(dev));
+
 	/* Clear DTE and flush the entry */
 	dev_update_dte(dev_data, false);
 
@@ -2374,14 +2394,6 @@ static void detach_device(struct device *dev)
 
 out:
 	mutex_unlock(&dev_data->mutex);
-
-	/* Remove IOPF handler */
-	if (ppr)
-		amd_iommu_iopf_remove_device(iommu, dev_data);
-
-	if (dev_is_pci(dev))
-		pdev_disable_caps(to_pci_dev(dev));
-
 }
 
 static struct iommu_device *amd_iommu_probe_device(struct device *dev)
@@ -2670,7 +2682,6 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct protection_domain *domain = to_pdomain(dom);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
-	struct pci_dev *pdev;
 	int ret;
 
 	/*
@@ -2703,24 +2714,6 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	}
 #endif
 
-	pdev = dev_is_pci(dev_data->dev) ? to_pci_dev(dev_data->dev) : NULL;
-	if (pdev && pdom_is_sva_capable(domain)) {
-		pdev_enable_caps(pdev);
-
-		/*
-		 * Device can continue to function even if IOPF
-		 * enablement failed. Hence in error path just
-		 * disable device PRI support.
-		 */
-		if (amd_iommu_iopf_add_device(iommu, dev_data))
-			pdev_disable_cap_pri(pdev);
-	} else if (pdev) {
-		pdev_enable_cap_ats(pdev);
-	}
-
-	/* Update device table */
-	dev_update_dte(dev_data, true);
-
 	return ret;
 }
 
-- 
2.53.0



