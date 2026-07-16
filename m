Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC686423788;
	Thu, 16 Jul 2026 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210864; cv=none; b=VTl3qiW4Mt8FpiOjqcdYl0C1/4aUigW0qV7TnqQlfngo25s0hszhR7R9aMttDnVM4F+u3/mUAP6tQSn1JJ2A2VueALb7TeMkK2BwDA/N9ntdy2ZWdB/masDLBPHP+QPha2+WLN4uyWBzij9An9BPkFWbAJvJZp0HVX2VbEo+iGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210864; c=relaxed/simple;
	bh=rDD5AoYQHwnp8baKV3rr3l2BCrRAgH7s8CCa5L0Sauk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKW7O72DDl4e85lPBT+qxLxWKtK3aNdGZ9MOVhs6tGR079KfV527uTpCYC/AKb5KlHEq/yJ5jVSP6aVpoOdorSXwlwvftSdBuAZHPYO30iMoHHycr66k2qYhPYgQ9Vl4HLPIRrn+d3AEHrlBAdrb9ZTIkylDBh5frxSO6dc+h2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzZpyDtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzZpyDtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAA21F000E9;
	Thu, 16 Jul 2026 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210862;
	bh=FOsRSC1r3zdMDzctY1T03XTOHQRBhDaVXpumU+F8dm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzZpyDtj8DiKTJhr8gI5fLe/u1DnOg0xwEv+Zc6BEOkqOwmMvS3K9PakrK//8iMNd
	 b8HUlyKY983ld20NofX2T1BmpTs5XG7WLxkCthIFpOqBgGblRhmEBTkVeFXkGiUl01
	 vBRdPn5HnDcYXhDWaHKsHn6Hg4CLwfFn8eqMnGNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Subject: [PATCH 6.18 209/480] iommu/vt-d: Fix race condition during PASID entry replacement
Date: Thu, 16 Jul 2026 15:29:16 +0200
Message-ID: <20260716133049.250772639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit c3b1edea3791fa91ab7032faa90355913ad9451b upstream.

The Intel VT-d PASID table entry is 512 bits (64 bytes). When replacing
an active PASID entry (e.g., during domain replacement), the current
implementation calculates a new entry on the stack and copies it to the
table using a single structure assignment.

        struct pasid_entry *pte, new_pte;

        pte = intel_pasid_get_entry(dev, pasid);
        pasid_pte_config_first_level(iommu, &new_pte, ...);
        *pte = new_pte;

Because the hardware may fetch the 512-bit PASID entry in multiple
128-bit chunks, updating the entire entry while it is active (Present
bit set) risks a "torn" read. In this scenario, the IOMMU hardware
could observe an inconsistent state — partially new data and partially
old data — leading to unpredictable behavior or spurious faults.

Fix this by removing the unsafe "replace" helpers and following the
"clear-then-update" flow, which ensures the Present bit is cleared and
the required invalidation handshake is completed before the new
configuration is applied.

Fixes: 7543ee63e811 ("iommu/vt-d: Add pasid replace helpers")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260120061816.2132558-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[vineeth: adjusted for 6.18.y: the removed intel_pasid_replace_second_level()
 in 6.18 still computed pgd/pgd_val locally and used the older
 pasid_pte_config_second_level() signature; since the function is deleted
 entirely, the resolution only affects removed lines. The prerequisite
 "Clear Present bit" patches are already in 6.18.y.
 Built and tested on 6.18.38: PASID replace, iommufd RID replace and DMA
 sanity on QEMU VT-d in scalable mode (FS and SS), no regressions.]
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c  |   29 ++----
 drivers/iommu/intel/nested.c |    9 --
 drivers/iommu/intel/pasid.c  |  190 -------------------------------------------
 drivers/iommu/intel/pasid.h  |   14 ---
 4 files changed, 16 insertions(+), 226 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1734,12 +1734,10 @@ int __domain_setup_first_level(struct in
 			       ioasid_t pasid, u16 did, phys_addr_t fsptptr,
 			       int flags, struct iommu_domain *old)
 {
-	if (!old)
-		return intel_pasid_setup_first_level(iommu, dev, fsptptr, pasid,
-						     did, flags);
-	return intel_pasid_replace_first_level(iommu, dev, fsptptr, pasid, did,
-					       iommu_domain_did(old, iommu),
-					       flags);
+	if (old)
+		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+
+	return intel_pasid_setup_first_level(iommu, dev, fsptptr, pasid, did, flags);
 }
 
 static int domain_setup_second_level(struct intel_iommu *iommu,
@@ -1747,23 +1745,20 @@ static int domain_setup_second_level(str
 				     struct device *dev, ioasid_t pasid,
 				     struct iommu_domain *old)
 {
-	if (!old)
-		return intel_pasid_setup_second_level(iommu, domain,
-						      dev, pasid);
-	return intel_pasid_replace_second_level(iommu, domain, dev,
-						iommu_domain_did(old, iommu),
-						pasid);
+	if (old)
+		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+
+	return intel_pasid_setup_second_level(iommu, domain, dev, pasid);
 }
 
 static int domain_setup_passthrough(struct intel_iommu *iommu,
 				    struct device *dev, ioasid_t pasid,
 				    struct iommu_domain *old)
 {
-	if (!old)
-		return intel_pasid_setup_pass_through(iommu, dev, pasid);
-	return intel_pasid_replace_pass_through(iommu, dev,
-						iommu_domain_did(old, iommu),
-						pasid);
+	if (old)
+		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+
+	return intel_pasid_setup_pass_through(iommu, dev, pasid);
 }
 
 static int domain_setup_first_level(struct intel_iommu *iommu,
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -141,11 +141,10 @@ static int domain_setup_nested(struct in
 			       struct device *dev, ioasid_t pasid,
 			       struct iommu_domain *old)
 {
-	if (!old)
-		return intel_pasid_setup_nested(iommu, dev, pasid, domain);
-	return intel_pasid_replace_nested(iommu, dev, pasid,
-					  iommu_domain_did(old, iommu),
-					  domain);
+	if (old)
+		intel_pasid_tear_down_entry(iommu, dev, pasid, false);
+
+	return intel_pasid_setup_nested(iommu, dev, pasid, domain);
 }
 
 static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -417,50 +417,6 @@ int intel_pasid_setup_first_level(struct
 	return 0;
 }
 
-int intel_pasid_replace_first_level(struct intel_iommu *iommu,
-				    struct device *dev, phys_addr_t fsptptr,
-				    u32 pasid, u16 did, u16 old_did,
-				    int flags)
-{
-	struct pasid_entry *pte, new_pte;
-
-	if (!ecap_flts(iommu->ecap)) {
-		pr_err("No first level translation support on %s\n",
-		       iommu->name);
-		return -EINVAL;
-	}
-
-	if ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)) {
-		pr_err("No 5-level paging support for first-level on %s\n",
-		       iommu->name);
-		return -EINVAL;
-	}
-
-	pasid_pte_config_first_level(iommu, &new_pte, fsptptr, did, flags);
-
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
-		return -ENODEV;
-	}
-
-	if (!pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EINVAL;
-	}
-
-	WARN_ON(old_did != pasid_get_domain_id(pte));
-
-	*pte = new_pte;
-	spin_unlock(&iommu->lock);
-
-	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
-	intel_iommu_drain_pasid_prq(dev, pasid);
-
-	return 0;
-}
-
 /*
  * Set up the scalable mode pasid entry for second only translation type.
  */
@@ -528,57 +484,6 @@ int intel_pasid_setup_second_level(struc
 	return 0;
 }
 
-int intel_pasid_replace_second_level(struct intel_iommu *iommu,
-				     struct dmar_domain *domain,
-				     struct device *dev, u16 old_did,
-				     u32 pasid)
-{
-	struct pasid_entry *pte, new_pte;
-	struct dma_pte *pgd;
-	u64 pgd_val;
-	u16 did;
-
-	/*
-	 * If hardware advertises no support for second level
-	 * translation, return directly.
-	 */
-	if (!ecap_slts(iommu->ecap)) {
-		pr_err("No second level translation support on %s\n",
-		       iommu->name);
-		return -EINVAL;
-	}
-
-	pgd = domain->pgd;
-	pgd_val = virt_to_phys(pgd);
-	did = domain_id_iommu(domain, iommu);
-
-	pasid_pte_config_second_level(iommu, &new_pte, pgd_val,
-				      domain->agaw, did,
-				      domain->dirty_tracking);
-
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
-		return -ENODEV;
-	}
-
-	if (!pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EINVAL;
-	}
-
-	WARN_ON(old_did != pasid_get_domain_id(pte));
-
-	*pte = new_pte;
-	spin_unlock(&iommu->lock);
-
-	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
-	intel_iommu_drain_pasid_prq(dev, pasid);
-
-	return 0;
-}
-
 /*
  * Set up dirty tracking on a second only or nested translation type.
  */
@@ -691,38 +596,6 @@ int intel_pasid_setup_pass_through(struc
 	return 0;
 }
 
-int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
-				     struct device *dev, u16 old_did,
-				     u32 pasid)
-{
-	struct pasid_entry *pte, new_pte;
-	u16 did = FLPT_DEFAULT_DID;
-
-	pasid_pte_config_pass_through(iommu, &new_pte, did);
-
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
-		return -ENODEV;
-	}
-
-	if (!pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EINVAL;
-	}
-
-	WARN_ON(old_did != pasid_get_domain_id(pte));
-
-	*pte = new_pte;
-	spin_unlock(&iommu->lock);
-
-	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
-	intel_iommu_drain_pasid_prq(dev, pasid);
-
-	return 0;
-}
-
 /*
  * Set the page snoop control for a pasid entry which has been set up.
  */
@@ -852,69 +725,6 @@ int intel_pasid_setup_nested(struct inte
 
 	return 0;
 }
-
-int intel_pasid_replace_nested(struct intel_iommu *iommu,
-			       struct device *dev, u32 pasid,
-			       u16 old_did, struct dmar_domain *domain)
-{
-	struct iommu_hwpt_vtd_s1 *s1_cfg = &domain->s1_cfg;
-	struct dmar_domain *s2_domain = domain->s2_domain;
-	u16 did = domain_id_iommu(domain, iommu);
-	struct pasid_entry *pte, new_pte;
-
-	/* Address width should match the address width supported by hardware */
-	switch (s1_cfg->addr_width) {
-	case ADDR_WIDTH_4LEVEL:
-		break;
-	case ADDR_WIDTH_5LEVEL:
-		if (!cap_fl5lp_support(iommu->cap)) {
-			dev_err_ratelimited(dev,
-					    "5-level paging not supported\n");
-			return -EINVAL;
-		}
-		break;
-	default:
-		dev_err_ratelimited(dev, "Invalid stage-1 address width %d\n",
-				    s1_cfg->addr_width);
-		return -EINVAL;
-	}
-
-	if ((s1_cfg->flags & IOMMU_VTD_S1_SRE) && !ecap_srs(iommu->ecap)) {
-		pr_err_ratelimited("No supervisor request support on %s\n",
-				   iommu->name);
-		return -EINVAL;
-	}
-
-	if ((s1_cfg->flags & IOMMU_VTD_S1_EAFE) && !ecap_eafs(iommu->ecap)) {
-		pr_err_ratelimited("No extended access flag support on %s\n",
-				   iommu->name);
-		return -EINVAL;
-	}
-
-	pasid_pte_config_nestd(iommu, &new_pte, s1_cfg, s2_domain, did);
-
-	spin_lock(&iommu->lock);
-	pte = intel_pasid_get_entry(dev, pasid);
-	if (!pte) {
-		spin_unlock(&iommu->lock);
-		return -ENODEV;
-	}
-
-	if (!pasid_pte_is_present(pte)) {
-		spin_unlock(&iommu->lock);
-		return -EINVAL;
-	}
-
-	WARN_ON(old_did != pasid_get_domain_id(pte));
-
-	*pte = new_pte;
-	spin_unlock(&iommu->lock);
-
-	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
-	intel_iommu_drain_pasid_prq(dev, pasid);
-
-	return 0;
-}
 
 /*
  * Interfaces to setup or teardown a pasid table to the scalable-mode
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -315,20 +315,6 @@ int intel_pasid_setup_pass_through(struc
 				   struct device *dev, u32 pasid);
 int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 			     u32 pasid, struct dmar_domain *domain);
-int intel_pasid_replace_first_level(struct intel_iommu *iommu,
-				    struct device *dev, phys_addr_t fsptptr,
-				    u32 pasid, u16 did, u16 old_did, int flags);
-int intel_pasid_replace_second_level(struct intel_iommu *iommu,
-				     struct dmar_domain *domain,
-				     struct device *dev, u16 old_did,
-				     u32 pasid);
-int intel_pasid_replace_pass_through(struct intel_iommu *iommu,
-				     struct device *dev, u16 old_did,
-				     u32 pasid);
-int intel_pasid_replace_nested(struct intel_iommu *iommu,
-			       struct device *dev, u32 pasid,
-			       u16 old_did, struct dmar_domain *domain);
-
 void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
 				 struct device *dev, u32 pasid,
 				 bool fault_ignore);


