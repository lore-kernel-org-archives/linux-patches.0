Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2E4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63866C433EF;
	Wed, 15 Mar 2023 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882837;
	bh=5iTdxmkfutspsQiXKljeqJDEZBUvac2V66HVCnasYNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mvdneirXkHlKTyEAVIkHjuaId9wnHWpyCIl2xuj04iFtDjc19NEnUWb7tS+ITM8u
	 dFJq5AKofbynlGEWcVDKLOi5BCkBOYCNXVMmIGR73gE2BYo/Ml8rmk38q3DDmmowkW
	 tgfqiPMPqpsqfg7Df0Emz7Z4h4k09pI+f9oc9Oro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Sukumar Ghorai <sukumar.ghorai@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/104] iommu/vt-d: Fix PASID directory pointer coherency
Date: Wed, 15 Mar 2023 13:11:52 +0100
Message-Id: <20230315115732.954106988@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 194b3348bdbb7db65375c72f3f774aee4cc6614e ]

On platforms that do not support IOMMU Extended capability bit 0
Page-walk Coherency, CPU caches are not snooped when IOMMU is accessing
any translation structures. IOMMU access goes only directly to
memory. Intel IOMMU code was missing a flush for the PASID table
directory that resulted in the unrecoverable fault as shown below.

This patch adds clflush calls whenever allocating and updating
a PASID table directory to ensure cache coherency.

On the reverse direction, there's no need to clflush the PASID directory
pointer when we deactivate a context entry in that IOMMU hardware will
not see the old PASID directory pointer after we clear the context entry.
PASID directory entries are also never freed once allocated.

 DMAR: DRHD: handling fault status reg 3
 DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault addr 0x1026a4000
       [fault reason 0x51] SM: Present bit in Directory Entry is clear
 DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
 DMAR: scalable mode root entry: hi 0x0000000102448001, low 0x0000000101b3e001
 DMAR: context entry: hi 0x0000000000000000, low 0x0000000101b4d401
 DMAR: pasid dir entry: 0x0000000101b4e001
 DMAR: pasid table entry[0]: 0x0000000000000109
 DMAR: pasid table entry[1]: 0x0000000000000001
 DMAR: pasid table entry[2]: 0x0000000000000000
 DMAR: pasid table entry[3]: 0x0000000000000000
 DMAR: pasid table entry[4]: 0x0000000000000000
 DMAR: pasid table entry[5]: 0x0000000000000000
 DMAR: pasid table entry[6]: 0x0000000000000000
 DMAR: pasid table entry[7]: 0x0000000000000000
 DMAR: PTE not present at level 4

Cc: <stable@vger.kernel.org>
Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Link: https://lore.kernel.org/r/20230209212843.1788125-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index f821153390e53..80d6412e2c546 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -186,6 +186,9 @@ int intel_pasid_alloc_table(struct device *dev)
 attach_out:
 	device_attach_pasid_table(info, pasid_table);
 
+	if (!ecap_coherent(info->iommu->ecap))
+		clflush_cache_range(pasid_table->table, size);
+
 	return 0;
 }
 
@@ -276,6 +279,10 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			free_pgtable_page(entries);
 			goto retry;
 		}
+		if (!ecap_coherent(info->iommu->ecap)) {
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
+		}
 	}
 
 	return &entries[index];
-- 
2.39.2



