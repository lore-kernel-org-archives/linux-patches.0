Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584DA1EB5E1;
	Wed, 25 Feb 2026 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983208; cv=none; b=IWnoOcXACwMmf1bMckTOY+LXNnXUe+B1WEPdxuDGZ0pQ4jZxE3iejOTnk18zwcqprI/aIIzkaXdnJ/T1MguSBDpmnlnofcuCXJV1ixkEtxkJ3525jL7XCjtHuZfmIP40uMfzGx4goJhMFJypQvPJtaC9q7xhi5rpfsE4QbgNl/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983208; c=relaxed/simple;
	bh=xSQUsyk+q48JH9KYmL26l3T2p5TgKk5Jn7ksjj3wJG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJmwF28vCh8ZInp1poy8I6hrf/J6ePqfaPvrXCmmHZyd9j6hPeQryjhtjPZniEuiVxPzCgITbftVwbFHYz6Izh1ZIYsHNqgevCl6Xq+6f3AVGhLWN03T4OV8GUDs5+dziVWfzJD3xC+ttU7GMKb1bc3FK66O8gC18vn2vZF85r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0xpAD6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0xpAD6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D89BC116D0;
	Wed, 25 Feb 2026 01:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983208;
	bh=xSQUsyk+q48JH9KYmL26l3T2p5TgKk5Jn7ksjj3wJG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0xpAD6BvU+/Pupuz0WMMMLIlELFP96u4Yx2Nc8V8xE+QL/LbMBrrt/O4B2d4xvqE
	 SfVlCaPKJRjZz0jOag3W3ASiQNTRqwv2N3UpB+XCNFaKvo40UfnlNBI6H5Wf9YW0qv
	 KuBoi3je6Fxd78WKSWK6SDDkqAmDWu8V9dsL5Zvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 357/781] iommu/vt-d: Fix race condition during PASID entry replacement
Date: Tue, 24 Feb 2026 17:17:46 -0800
Message-ID: <20260225012408.441554266@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c3b1edea3791fa91ab7032faa90355913ad9451b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c  |  29 +++---
 drivers/iommu/intel/nested.c |   9 +-
 drivers/iommu/intel/pasid.c  | 184 -----------------------------------
 drivers/iommu/intel/pasid.h  |  14 ---
 4 files changed, 16 insertions(+), 220 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index c66cc51f9e51e..705828b06e329 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1252,12 +1252,10 @@ int __domain_setup_first_level(struct intel_iommu *iommu, struct device *dev,
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
@@ -1265,23 +1263,20 @@ static int domain_setup_second_level(struct intel_iommu *iommu,
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
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index a3fb8c193ca64..e9a440e9c960b 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -136,11 +136,10 @@ static int domain_setup_nested(struct intel_iommu *iommu,
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
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index db535385778bd..34b209b88be2a 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -417,50 +417,6 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu, struct device *dev,
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
@@ -527,51 +483,6 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	return 0;
 }
 
-int intel_pasid_replace_second_level(struct intel_iommu *iommu,
-				     struct dmar_domain *domain,
-				     struct device *dev, u16 old_did,
-				     u32 pasid)
-{
-	struct pasid_entry *pte, new_pte;
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
-	did = domain_id_iommu(domain, iommu);
-
-	pasid_pte_config_second_level(iommu, &new_pte, domain, did);
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
@@ -684,38 +595,6 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
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
@@ -849,69 +728,6 @@ int intel_pasid_setup_nested(struct intel_iommu *iommu, struct device *dev,
 	return 0;
 }
 
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
-
 /*
  * Interfaces to setup or teardown a pasid table to the scalable-mode
  * context table entry:
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index b67b2dc4ad9c0..48d3bb6b68dea 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -316,20 +316,6 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
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
-- 
2.51.0



