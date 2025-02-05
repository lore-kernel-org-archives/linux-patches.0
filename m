Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED651662EF;
	Wed,  5 Feb 2025 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766556; cv=none; b=pgzb8V8fw7fq3KsctF8vXcWrZ0i6C0U+TnO8KChrzW3aMc3jest0hG4urtglxd+7ncMd48p06KeHAif7hX8ru45+G6ANTqFl5p476pc7iqhRWYFFOxYoXTWFa+uZZOKPkiO9S0uyR4NABc+mBEu8R/+kh5cLagG1TMiwbDT+/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766556; c=relaxed/simple;
	bh=UQrNuYt24g9XW/S2fqDjKDJXj1yUbP4mhwLa33kPJvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEXKyUDSEQve1tKzWavVRk4crPIg9rveH4ZnW+zukM+E6r1iEQOD3RpzSl0IrDveeP+8XZQzrdPjkoxtMXAaV1wJFkTDz8cJmilZJP3wNMjUTI5LQD5xFkni4/OtPa4VBZ8WRoxDnHAzwJYFXByvOiI5Fj9BmZaRI7rh1xRvTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCXuNKxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCXuNKxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE6C4CED1;
	Wed,  5 Feb 2025 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766556;
	bh=UQrNuYt24g9XW/S2fqDjKDJXj1yUbP4mhwLa33kPJvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCXuNKxV6E6pAbqW71ruGRxUixWC6DAkphqyRpYLGDp4FxaJfk0/W9CvB0q0Z2dDD
	 1stXSGF/r+uBdDXFINnrUsPpdQl9skYn3JSUAcF1DTPD9Gbx3DvmS+UbeeTQMNw3yx
	 1qp7J9GNVxLc+7QJIjpMZXnbYwoh5WdMsWZuByhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 287/623] iommu/vt-d: Draining PRQ in sva unbind path when FPD bit set
Date: Wed,  5 Feb 2025 14:40:29 +0100
Message-ID: <20250205134507.210396382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit cf08ca81d08a04b3b304e8fb4e052f323a09783d ]

When a device uses a PASID for SVA (Shared Virtual Address), it's possible
that the PASID entry is marked as non-present and FPD bit set before the
device flushes all ongoing DMA requests and removes the SVA domain. This
can occur when an exception happens and the process terminates before the
device driver stops DMA and calls the iommu driver to unbind the PASID.

There's no need to drain the PRQ in the mm release path. Instead, the PRQ
will be drained in the SVA unbind path. But in such case,
intel_pasid_tear_down_entry() only checks the presence of the pasid entry
and returns directly.

Add the code to clear the FPD bit and drain the PRQ.

Fixes: c43e1ccdebf2 ("iommu/vt-d: Drain PRQs when domain removed from RID")
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20241217024240.139615-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 22 +++++++++++++++++++++-
 drivers/iommu/intel/pasid.h |  6 ++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 5b7d85f1e143c..fb59a7d35958f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -244,11 +244,31 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
-	if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
+	if (WARN_ON(!pte)) {
 		spin_unlock(&iommu->lock);
 		return;
 	}
 
+	if (!pasid_pte_is_present(pte)) {
+		if (!pasid_pte_is_fault_disabled(pte)) {
+			WARN_ON(READ_ONCE(pte->val[0]) != 0);
+			spin_unlock(&iommu->lock);
+			return;
+		}
+
+		/*
+		 * When a PASID is used for SVA by a device, it's possible
+		 * that the pasid entry is non-present with the Fault
+		 * Processing Disabled bit set. Clear the pasid entry and
+		 * drain the PRQ for the PASID before return.
+		 */
+		pasid_clear_entry(pte);
+		spin_unlock(&iommu->lock);
+		intel_iommu_drain_pasid_prq(dev, pasid);
+
+		return;
+	}
+
 	did = pasid_get_domain_id(pte);
 	pgtt = pasid_pte_get_pgtt(pte);
 	intel_pasid_clear_entry(dev, pasid, fault_ignore);
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 082f4fe20216a..668d8ece6b143 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -73,6 +73,12 @@ static inline bool pasid_pte_is_present(struct pasid_entry *pte)
 	return READ_ONCE(pte->val[0]) & PASID_PTE_PRESENT;
 }
 
+/* Get FPD(Fault Processing Disable) bit of a PASID table entry */
+static inline bool pasid_pte_is_fault_disabled(struct pasid_entry *pte)
+{
+	return READ_ONCE(pte->val[0]) & PASID_PTE_FPD;
+}
+
 /* Get PGTT field of a PASID table entry */
 static inline u16 pasid_pte_get_pgtt(struct pasid_entry *pte)
 {
-- 
2.39.5



