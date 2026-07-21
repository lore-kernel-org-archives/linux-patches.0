Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932D46C4B2;
	Tue, 21 Jul 2026 15:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649190; cv=none; b=MrlQCJEpSaE0GadMJpBvg8uJj4lq71VY2ZEGVb5cZqU1MeeCXxH6utk0+s9OS4ytD0S8TeESpsKfZhI+U7xW8YT2GtZmsNHBCkO5kMoVjHp5fZLh3cSttakuIPq3d2e18EhSSa4rff77P/UJXMxzRGkUCGj98I04O5im42I23Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649190; c=relaxed/simple;
	bh=zJYDD0ys4qYaupsa2d9btPP/OYenjtpvuYubFTwHvik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLRDmQIIPVO8lzSVvSRwKMrMdk8PTALdklCmaoVpIVD1IujI/T/CtIKe5k7+hi4MZDeSh9+MLsBrrCf7Wpm4KjPIyPMkb2HagX/xY/AWorh9Na+igFRVGnx9Fpvrr2lr6G709trj31gRso+67bsGDnWYkpx830F/vBq7ZQFro38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=134wTMOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="134wTMOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700DF1F00A3A;
	Tue, 21 Jul 2026 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649188;
	bh=n02HlxZwrFDIplvMBjUFDevqNe2zTTKXKsVZRVfVR0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=134wTMODQm45Dn3i76i66ZW2Jb5wxpeOKRFYP4dMe7/L0hZUYKl6MdrrYZkhITPzp
	 K10FhOItDYHfB4Jyxd5DnZapMCyDrq4AjQcesvIee3JW+1u55m7CGHr/WUIsPT3d44
	 seRcwgEYG1LcJ1gcgwQtJzQkSuXRG76a54hG1Htg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0457/2077] iommu/vt-d: Fix RB-tree corruption in probe error path
Date: Tue, 21 Jul 2026 17:02:10 +0200
Message-ID: <20260721152603.566193187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit 43bd9e6d5513cb1edbafdeef146a1edc3aaced56 ]

The info->node RB-tree member is zero-initialized via kzalloc. If
a device does not support ATS, the device_rbtree_insert() call is
skipped. If a subsequent probe step fails, the error path jumps to
device_rbtree_remove(), which misinterprets the zeroed node as
a tree root and corrupts the device RB-tree.

Fix this by explicitly initializing the RB-node as empty using
RB_CLEAR_NODE() during initialization and guarding the removal with
RB_EMPTY_NODE().

Fixes: 4f1492efb495 ("iommu/vt-d: Revert ATS timing change to fix boot failure")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260525205628.CD4431F000E9@smtp.kernel.org/
Suggested-by: Baolu Lu <baolu.lu@linux.intel.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Link: https://lore.kernel.org/r/20260531170254.60493-2-praan@google.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4d0e65bc131d77..849d06dfe1aecf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -157,7 +157,10 @@ static void device_rbtree_remove(struct device_domain_info *info)
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->device_rbtree_lock, flags);
-	rb_erase(&info->node, &iommu->device_rbtree);
+	if (!RB_EMPTY_NODE(&info->node)) {
+		rb_erase(&info->node, &iommu->device_rbtree);
+		RB_CLEAR_NODE(&info->node);
+	}
 	spin_unlock_irqrestore(&iommu->device_rbtree_lock, flags);
 }
 
@@ -3254,6 +3257,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 
 	info->dev = dev;
 	info->iommu = iommu;
+	RB_CLEAR_NODE(&info->node);
 	if (dev_is_pci(dev)) {
 		if (ecap_dev_iotlb_support(iommu->ecap) &&
 		    pci_ats_supported(pdev) &&
-- 
2.53.0



