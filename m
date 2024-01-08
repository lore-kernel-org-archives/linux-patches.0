Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F9A47791;
	Mon,  8 Jan 2024 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr9b8uwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A48C43395;
	Mon,  8 Jan 2024 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726916;
	bh=SPVguaWfg1bDtLRfBkHVx5cG/qVoCiR45H5aBfcNtgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr9b8uwrUwoa/oimwjoBEQugXKmVVbqoM7vJXNMH9xws3WiPtl28yK63P4Cs3cTJZ
	 MsjeOXMm8iCQIizYV4r3UM2Sa5bnedyD8ToYdIke/9A1Vdbo+hsSAsTUKLZnRckseX
	 f9DgWqOmqfzuJWqqtN616HiCfo04MLQAn2irkyys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/124] iommu/vt-d: Support enforce_cache_coherency only for empty domains
Date: Mon,  8 Jan 2024 16:08:36 +0100
Message-ID: <20240108150607.122894273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit e645c20e8e9cde549bc233435d3c1338e1cd27fe ]

The enforce_cache_coherency callback ensures DMA cache coherency for
devices attached to the domain.

Intel IOMMU supports enforced DMA cache coherency when the Snoop
Control bit in the IOMMU's extended capability register is set.
Supporting it differs between legacy and scalable modes.

In legacy mode, it's supported page-level by setting the SNP field
in second-stage page-table entries. In scalable mode, it's supported
in PASID-table granularity by setting the PGSNP field in PASID-table
entries.

In legacy mode, mappings before attaching to a device have SNP
fields cleared, while mappings after the callback have them set.
This means partial DMAs are cache coherent while others are not.

One possible fix is replaying mappings and flipping SNP bits when
attaching a domain to a device. But this seems to be over-engineered,
given that all real use cases just attach an empty domain to a device.

To meet practical needs while reducing mode differences, only support
enforce_cache_coherency on a domain without mappings if SNP field is
used.

Fixes: fc0051cb9590 ("iommu/vt-d: Check domain force_snooping against attached devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20231114011036.70142-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 5 ++++-
 drivers/iommu/intel/iommu.h | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4c3707384bd92..744e4e6b8d72d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2204,6 +2204,8 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			attr |= DMA_FL_PTE_DIRTY;
 	}
 
+	domain->has_mappings = true;
+
 	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
 
 	while (nr_pages > 0) {
@@ -4309,7 +4311,8 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 		return true;
 
 	spin_lock_irqsave(&dmar_domain->lock, flags);
-	if (!domain_support_force_snooping(dmar_domain)) {
+	if (!domain_support_force_snooping(dmar_domain) ||
+	    (!dmar_domain->use_first_level && dmar_domain->has_mappings)) {
 		spin_unlock_irqrestore(&dmar_domain->lock, flags);
 		return false;
 	}
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 7dac94f62b4ec..e6a3e70656166 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -592,6 +592,9 @@ struct dmar_domain {
 					 * otherwise, goes through the second
 					 * level.
 					 */
+	u8 has_mappings:1;		/* Has mappings configured through
+					 * iommu_map() interface.
+					 */
 
 	spinlock_t lock;		/* Protect device tracking lists */
 	struct list_head devices;	/* all devices' list */
-- 
2.43.0



