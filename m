Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AB51DE2B5;
	Wed, 19 Feb 2025 08:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954015; cv=none; b=LHhT4uylgA98FVaMmt6MLg4j3PM3v6BBpFVWmFZK7h4RZjKiC3Biy9M18xanGPeozfg5PFJkBV6Un7lXmPtM4tZm9OTRbxXawqYxkTIwyFYqnyduGFaIla0Zhw7L1ui6z81K9RNvOVvO6M9bpmj5pxJimopVESI+K6XwSqgl/z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954015; c=relaxed/simple;
	bh=5rSjT0VbXrwEFUka6MvHc2QYMmTdzi9XH3Nv4CDVM04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJS5GfHRU15lBdn6YYxkKruhF3ths52EjszgIOS0YERjNGBAb4/ihC0mgPEfi/ImWfFyATdg1NDD/gYYsSLPtfSk7GYH8MaMj9sjpOHjyN5hF9jKLETtQ30fAbouud8bv/7O8bTTzJeyIC6MynL13nqCRY1z/3e1hE3SABC0bqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tE9273zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tE9273zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DDBC4CEE8;
	Wed, 19 Feb 2025 08:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954013;
	bh=5rSjT0VbXrwEFUka6MvHc2QYMmTdzi9XH3Nv4CDVM04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tE9273zMSe667xYv9KsrxVVPbYIBgr8XjoUODjgxJSWjLnmqHEM4lRrOS7TP3mXnK
	 habGAersZaWxE2gwJoENaG2zPHFGYjUpdbjVzSfm7ZWMPuMLJYEnZY+d8Ze+kT8hDH
	 tr3tRHkIFWO1H9V20cyPELwIajcQanlq6sGriFyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish McIntyre-Bhatty <kernel-bugzilla@regd.hamishmb.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 067/274] iommu/amd: Expicitly enable CNTRL.EPHEn bit in resume path
Date: Wed, 19 Feb 2025 09:25:21 +0100
Message-ID: <20250219082612.245355059@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit ef75966abf950c0539534effa4960caa29fb7167 ]

With recent kernel, AMDGPU failed to resume after suspend on certain laptop.

Sample log:
-----------
Nov 14 11:52:19 Thinkbook kernel: iommu ivhd0: AMD-Vi: Event logged [ILLEGAL_DEV_TABLE_ENTRY device=0000:06:00.0 pasid=0x00000 address=0x135300000 flags=0x0080]
Nov 14 11:52:19 Thinkbook kernel: AMD-Vi: DTE[0]: 7d90000000000003
Nov 14 11:52:19 Thinkbook kernel: AMD-Vi: DTE[1]: 0000100103fc0009
Nov 14 11:52:19 Thinkbook kernel: AMD-Vi: DTE[2]: 2000000117840013
Nov 14 11:52:19 Thinkbook kernel: AMD-Vi: DTE[3]: 0000000000000000

This is because in resume path, CNTRL[EPHEn] is not set. Fix this by
setting CNTRL[EPHEn] to 1 in resume path if EFR[EPHSUP] is set.

Note
  May be better approach is to save the control register in suspend path
  and restore it in resume path instead of trying to set indivisual
  bits. We will have separate patch for that.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219499
Fixes: c4cb23111103 ("iommu/amd: Add support for enable/disable IOPF")
Tested-by: Hamish McIntyre-Bhatty <kernel-bugzilla@regd.hamishmb.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20250127094411.5931-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h | 1 +
 drivers/iommu/amd/init.c            | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index fdb0357e0bb91..903b426c9f893 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -175,6 +175,7 @@
 #define CONTROL_GAM_EN		25
 #define CONTROL_GALOG_EN	28
 #define CONTROL_GAINT_EN	29
+#define CONTROL_EPH_EN		45
 #define CONTROL_XT_EN		50
 #define CONTROL_INTCAPXT_EN	51
 #define CONTROL_IRTCACHEDIS	59
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index db4b52aae1fcf..4c0f876445de1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2635,6 +2635,10 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 
 	/* Set IOTLB invalidation timeout to 1s */
 	iommu_set_inv_tlb_timeout(iommu, CTRL_INV_TO_1S);
+
+	/* Enable Enhanced Peripheral Page Request Handling */
+	if (check_feature(FEATURE_EPHSUP))
+		iommu_feature_enable(iommu, CONTROL_EPH_EN);
 }
 
 static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
-- 
2.39.5



