Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EBD3451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301790; cv=none; b=ls15gmaKrlbB+Tyhhn7rO76pzetOAMa7I6N1Bslwp9N22owshEFndmOnUsUoMp4Cb2IMs2FZekyiX+wDcnXoo8J6wt+8qVGhczai1LhWFeNgE0rJtAGxHPDVIk81zhk6tXqonDJmNu9bjr8Jvkf4OQ0gXIj5/UsofMBqNb1+WYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301790; c=relaxed/simple;
	bh=+D/b4HMAoY1fS3ctsf4zq4n5ej1pHm+vDp89BS9stko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGT2IgaYVSbnf13gmcawmIwk8bRg8YUksfLlQemCS57nA4zC0x3XZgv2IVx2gLSLHAIQomKtrYvXcO/T3zCuTjk9ocKskMF3Qgt0Fw5LBCEUVCTNQjN3NsZovyd1mjUilA4F8fkIWOYTu8fVhE09oSmmcfrsZ335iloLmBEQe34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtlQTHqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtlQTHqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA8FC19425;
	Sat, 28 Feb 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301789;
	bh=+D/b4HMAoY1fS3ctsf4zq4n5ej1pHm+vDp89BS9stko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtlQTHqaDanIj8FUoDwjUdRU0sGyhYuVZNI2R8f7PUiP0s2ztyulvf6F3KywNnrcd
	 I7Ly8yx9at2+n1siZztiA0Bh167lZp8nH2oOzaUmzkj3xHbioa6OJ/SciEsygHZ69t
	 4k7EEvOK8RGfNCmcd2yvExz8d+FamR7GTigx51MbklN3oeuR1A6JFPPAquOKyAmblv
	 eYDdqa8MM8W8lK9KyV55VoXjEU0ZAfVcrpveC9TlEP6wBi1DvStLL7ZrV3WUnnoQj2
	 bOJOTs9GKsZHjovhmK1UOD3kb4QZQi2ceOxhROwXxyjKosERaPMh1GDkKQVdHOscHf
	 owDcmC1PAzlDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/385] iommu/vt-d: Drain PRQs when domain removed from RID
Date: Sat, 28 Feb 2026 12:57:01 -0500
Message-ID: <20260228180011.1568201-199-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c43e1ccdebf2c950545fdf12c5796ad6f7bad7ee ]

As this iommu driver now supports page faults for requests without
PASID, page requests should be drained when a domain is removed from
the RID2PASID entry.

This results in the intel_iommu_drain_pasid_prq() call being moved to
intel_pasid_tear_down_entry(). This indicates that when a translation
is removed from any PASID entry and the PRI has been enabled on the
device, page requests are drained in the domain detachment path.

The intel_iommu_drain_pasid_prq() helper has been modified to support
sending device TLB invalidation requests for both PASID and non-PASID
cases.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20241101045543.70086-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 75ed00055c05 ("iommu/vt-d: Clear Present bit before tearing down PASID entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c |  1 -
 drivers/iommu/intel/pasid.c |  1 +
 drivers/iommu/intel/prq.c   | 26 +++++++++-----------------
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 936db952f4385..d4f852f712aa8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4333,7 +4333,6 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		kfree(dev_pasid);
 	}
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
-	intel_iommu_drain_pasid_prq(dev, pasid);
 }
 
 static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 2ec76333b6973..4e4d167720ba8 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -266,6 +266,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	devtlb_invalidation_with_pasid(iommu, dev, pasid);
+	intel_iommu_drain_pasid_prq(dev, pasid);
 }
 
 /*
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index edda5da8ba159..853d1cbb635fd 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -63,26 +63,18 @@ void intel_iommu_drain_pasid_prq(struct device *dev, u32 pasid)
 	struct dmar_domain *domain;
 	struct intel_iommu *iommu;
 	struct qi_desc desc[3];
-	struct pci_dev *pdev;
 	int head, tail;
 	u16 sid, did;
-	int qdep;
 
 	info = dev_iommu_priv_get(dev);
-	if (WARN_ON(!info || !dev_is_pci(dev)))
-		return;
-
 	if (!info->pri_enabled)
 		return;
 
 	iommu = info->iommu;
 	domain = info->domain;
-	pdev = to_pci_dev(dev);
 	sid = PCI_DEVID(info->bus, info->devfn);
 	did = domain ? domain_id_iommu(domain, iommu) : FLPT_DEFAULT_DID;
 
-	qdep = pci_ats_queue_depth(pdev);
-
 	/*
 	 * Check and wait until all pending page requests in the queue are
 	 * handled by the prq handling thread.
@@ -114,15 +106,15 @@ void intel_iommu_drain_pasid_prq(struct device *dev, u32 pasid)
 	desc[0].qw0 = QI_IWD_STATUS_DATA(QI_DONE) |
 			QI_IWD_FENCE |
 			QI_IWD_TYPE;
-	desc[1].qw0 = QI_EIOTLB_PASID(pasid) |
-			QI_EIOTLB_DID(did) |
-			QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
-			QI_EIOTLB_TYPE;
-	desc[2].qw0 = QI_DEV_EIOTLB_PASID(pasid) |
-			QI_DEV_EIOTLB_SID(sid) |
-			QI_DEV_EIOTLB_QDEP(qdep) |
-			QI_DEIOTLB_TYPE |
-			QI_DEV_IOTLB_PFSID(info->pfsid);
+	if (pasid == IOMMU_NO_PASID) {
+		qi_desc_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH, &desc[1]);
+		qi_desc_dev_iotlb(sid, info->pfsid, info->ats_qdep, 0,
+				  MAX_AGAW_PFN_WIDTH, &desc[2]);
+	} else {
+		qi_desc_piotlb(did, pasid, 0, -1, 0, &desc[1]);
+		qi_desc_dev_iotlb_pasid(sid, info->pfsid, pasid, info->ats_qdep,
+					0, MAX_AGAW_PFN_WIDTH, &desc[2]);
+	}
 qi_retry:
 	reinit_completion(&iommu->prq_complete);
 	qi_submit_sync(iommu, desc, 3, QI_OPT_WAIT_DRAIN);
-- 
2.51.0

