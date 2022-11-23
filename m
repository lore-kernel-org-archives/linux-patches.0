Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325DF1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878CAC433D6;
	Wed, 23 Nov 2022 09:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196208;
	bh=W/RNCy4I0ut5XmPf4kYUNGE/dnHtPGYXVksXUND1uVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWNAfoP2E4dyEtcd6woV5DqyTgHgrmKHymeU+yBHO/yb3MckwTuQB4GsQ3gb1+us8
	 ujXiXba6fRNSSS3SGNijksIpuQnn/szQWq67xJqDr6ALsvSNBTKsE0nY/AmoIrny49
	 nE4FT1vyySt0ZYY1QlIn/ykURuEhEa5Dd6F6IGxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 149/181] iommu/vt-d: Set SRE bit only when hardware has SRS cap
Date: Wed, 23 Nov 2022 09:51:52 +0100
Message-Id: <20221123084608.797276393@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tina Zhang <tina.zhang@intel.com>

commit 7fc961cf7ffcb130c4e93ee9a5628134f9de700a upstream.

SRS cap is the hardware cap telling if the hardware IOMMU can support
requests seeking supervisor privilege or not. SRE bit in scalable-mode
PASID table entry is treated as Reserved(0) for implementation not
supporting SRS cap.

Checking SRS cap before setting SRE bit can avoid the non-recoverable
fault of "Non-zero reserved field set in PASID Table Entry" caused by
setting SRE bit while there is no SRS cap support. The fault messages
look like below:

 DMAR: DRHD: handling fault status reg 2
 DMAR: [DMA Read NO_PASID] Request device [00:0d.0] fault addr 0x1154e1000
       [fault reason 0x5a]
       SM: Non-zero reserved field set in PASID Table Entry

Fixes: 6f7db75e1c46 ("iommu/vt-d: Add second level page table interface")
Cc: stable@vger.kernel.org
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Link: https://lore.kernel.org/r/20221115070346.1112273-1-tina.zhang@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20221116051544.26540-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/pasid.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -717,7 +717,7 @@ int intel_pasid_setup_second_level(struc
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
 	 */
-	if (pasid != PASID_RID2PASID)
+	if (pasid != PASID_RID2PASID && ecap_srs(iommu->ecap))
 		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -756,7 +756,8 @@ int intel_pasid_setup_pass_through(struc
 	 * We should set SRE bit as well since the addresses are expected
 	 * to be GPAs.
 	 */
-	pasid_set_sre(pte);
+	if (ecap_srs(iommu->ecap))
+		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
 


