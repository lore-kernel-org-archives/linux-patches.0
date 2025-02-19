Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A202A1EDA3C;
	Wed, 19 Feb 2025 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954855; cv=none; b=j9PlLl6/J1FowXV83oMnuSrabbY5I1emxE97ed0ugsP68suTiFNKz4k/5PURXr20aahkAVsFH9nU9jD4eAWoTs0EzBUW/NbIwt9bJEj/a7rS4w2BEOtkYnKx+OjsFORGpkUzF7HImLAMioZ7SLhnxbD/KQohmd9pu4ca2CuXc5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954855; c=relaxed/simple;
	bh=UV9JC6c97OEML8A/p3rg0AEH4jrj+/vaxI/DtBmj7ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXndNmLfoML7u7o2ezZldx8bmIq5EMKbVI1JiwHQl3rqKDHa+4GPPQoWvXMVc3b/IgmHfzOgBUTF7xsLoC4fy4Gh3UZUTHD6TkgV2psXANEXutPD/dBwkGjdejQpbxGTrtQjIXV0ztKIlXLez9+gpBE3dGd6DH6/owutDRtdEKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6gJfdX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6gJfdX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7595C4CED1;
	Wed, 19 Feb 2025 08:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954855;
	bh=UV9JC6c97OEML8A/p3rg0AEH4jrj+/vaxI/DtBmj7ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6gJfdX+nxH9ni3z2l2EEssLjcUfAqqM35A+RLWEpVt6A5nMd02NB4fU8Pp35g4mU
	 egFR5/nCRw8L7k4j53fyn2VlkrMEWHKxOznUALt6Fpsa2bpj9B3dw+qRpVnDtCWdY2
	 Vl2hc2KRQ6jVJtuhbuQXqiFEM/8Gwt2qVIJHWRZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish McIntyre-Bhatty <kernel-bugzilla@regd.hamishmb.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/230] iommu/amd: Expicitly enable CNTRL.EPHEn bit in resume path
Date: Wed, 19 Feb 2025 09:26:13 +0100
Message-ID: <20250219082603.906913113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 601fb4ee69009..6fb2f2919ab1f 100644
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
index 43131c3a21726..dbe2d13972fef 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2647,6 +2647,10 @@ static void iommu_init_flags(struct amd_iommu *iommu)
 
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



