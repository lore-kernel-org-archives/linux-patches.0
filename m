Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8CFBA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A7AC433D2;
	Tue,  7 Mar 2023 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215676;
	bh=/nxl+UIFDtE1M3DW0A89Majj37fe32u4g7WZrZCSaD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne8wlT65Fyd0HuHitE3romD5/oahFRU+ucXNF2qApE8/UAI49bFTz57HVhUESMPF7
	 fkG0dHdtnnl0FvgkTDZeXjhyq827mcHaOWpXpDwq374+pGWGbO7g1aPizXHemRWj9h
	 f7HbbHSPbtafpTDle1vYbCronnxL9ml2Juavb1+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/567] iommu/vt-d: Check FL and SL capability sanity in scalable mode
Date: Tue,  7 Mar 2023 18:01:15 +0100
Message-Id: <20230307165920.567029545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 7afd7f6aa21a2929aff3a059b741933ee1819c6b ]

An iommu domain could be allocated and mapped before it's attached to any
device. This requires that in scalable mode, when the domain is allocated,
the format (FL or SL) of the page table must be determined. In order to
achieve this, the platform should support consistent SL or FL capabilities
on all IOMMU's. This adds a check for this and aborts IOMMU probing if it
doesn't meet this requirement.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20210926114535.923263-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20211014053839.727419-5-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 257ec2907419 ("iommu/vt-d: Allow to use flush-queue when first level is default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cap_audit.c | 13 +++++++++++++
 drivers/iommu/intel/cap_audit.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/iommu/intel/cap_audit.c b/drivers/iommu/intel/cap_audit.c
index b12e421a2f1ab..b39d223926a49 100644
--- a/drivers/iommu/intel/cap_audit.c
+++ b/drivers/iommu/intel/cap_audit.c
@@ -163,6 +163,14 @@ static int cap_audit_static(struct intel_iommu *iommu, enum cap_audit_type type)
 			check_irq_capabilities(iommu, i);
 	}
 
+	/*
+	 * If the system is sane to support scalable mode, either SL or FL
+	 * should be sane.
+	 */
+	if (intel_cap_smts_sanity() &&
+	    !intel_cap_flts_sanity() && !intel_cap_slts_sanity())
+		return -EOPNOTSUPP;
+
 out:
 	rcu_read_unlock();
 	return 0;
@@ -203,3 +211,8 @@ bool intel_cap_flts_sanity(void)
 {
 	return ecap_flts(intel_iommu_ecap_sanity);
 }
+
+bool intel_cap_slts_sanity(void)
+{
+	return ecap_slts(intel_iommu_ecap_sanity);
+}
diff --git a/drivers/iommu/intel/cap_audit.h b/drivers/iommu/intel/cap_audit.h
index 74cfccae0e817..d07b75938961f 100644
--- a/drivers/iommu/intel/cap_audit.h
+++ b/drivers/iommu/intel/cap_audit.h
@@ -111,6 +111,7 @@ bool intel_cap_smts_sanity(void);
 bool intel_cap_pasid_sanity(void);
 bool intel_cap_nest_sanity(void);
 bool intel_cap_flts_sanity(void);
+bool intel_cap_slts_sanity(void);
 
 static inline bool scalable_mode_support(void)
 {
-- 
2.39.2



