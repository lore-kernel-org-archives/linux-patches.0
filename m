Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E45E151988;
	Wed,  5 Feb 2025 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766303; cv=none; b=qF58ckhDVZ93DiY4aWQqXgMd9h5su/vLUAST7Zir8AEcOsB/c98Uz04R0XucU+qR6WcP6YeT/2dx0wbuJAB7ymaDGYuO+07l7cyN/Ea4HBcEhfA1kpACGvS0MMYSWJMYbtIk356PRBuq1dMYpgIUDrG76m+MKpiPoIZeQrOggGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766303; c=relaxed/simple;
	bh=JR2hTv+/8/Rc8yNWuDZYV1d7rl0dOGjdogm13iL0Zgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxqgr6NFFWAIS9ixApmrD9RuSWj1gZsbisbMqACrf34AIJN20h254J33PMLTPqOc8jd9S3WY9uMhbVbplGH7DcyqBflGFBtJWSUejDdLlwAn/zrInyNylKpYyNo32DwzUXAO17ngVIaW2qqSdok+Q5n9zAtFlyfF+j5FmOpj9VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsGafTRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsGafTRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B01C4CED1;
	Wed,  5 Feb 2025 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766302;
	bh=JR2hTv+/8/Rc8yNWuDZYV1d7rl0dOGjdogm13iL0Zgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsGafTRVL0YyaQBlutB/tmIMqKzF5PhZBNEdxa2gItYslFtnIKEshuTTNlFIi19Px
	 dTN4koBix3ZCxJKEvGcOvCyeHZ/n3Zm6CFBA4HvRDzm+MGhotvilJyhEQ6WBuM04DE
	 UbjkiD/PhlhHF+BajFHDa/ibSxpWTMs/4HfD1YsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 261/623] iommu/arm-smmuv3: Update comments about ATS and bypass
Date: Wed,  5 Feb 2025 14:40:03 +0100
Message-ID: <20250205134506.216465919@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9b640ae7fbba13d45a8b9712dff2911a0c2b5ff4 ]

The SMMUv3 spec has a note that BYPASS and ATS don't work together under
the STE EATS field definition. However there is another section "13.6.4
Full ATS skipping stage 1" that explains under certain conditions BYPASS
and ATS do work together if the STE is using S1DSS to select BYPASS and
the CD table has the possibility for a substream.

When these comments were written the understanding was that all forms of
BYPASS just didn't work and this was to be a future problem to solve.

It turns out that ATS and IDENTITY will always work just fine:

 - If STE.Config = BYPASS then the PCI ATS is disabled

 - If a PASID domain is attached then S1DSS = BYPASS and ATS will be
   enabled. This meets the requirements of 13.6.4 to automatically
   generate 1:1 ATS replies on the RID.

Update the comments to reflect this.

Fixes: 7497f4211f4f ("iommu/arm-smmu-v3: Make changing domains be hitless for ATS")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v1-f27174f44f39+27a33-smmuv3_ats_note_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a5c7002ff75bb..6d15405f0ea3e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2745,9 +2745,14 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * Translation Requests and Translated transactions are denied
 		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
 		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
-		 * (IHI0070Ea 5.2 Stream Table Entry). Thus ATS can only be
-		 * enabled if we have arm_smmu_domain, those always have page
-		 * tables.
+		 * (IHI0070Ea 5.2 Stream Table Entry).
+		 *
+		 * However, if we have installed a CD table and are using S1DSS
+		 * then ATS will work in S1DSS bypass. See "13.6.4 Full ATS
+		 * skipping stage 1".
+		 *
+		 * Disable ATS if we are going to create a normal 0b100 bypass
+		 * STE.
 		 */
 		state->ats_enabled = !state->disable_ats &&
 				     arm_smmu_ats_supported(master);
@@ -3070,8 +3075,10 @@ static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	if (arm_smmu_ssids_in_use(&master->cd_table)) {
 		/*
 		 * If a CD table has to be present then we need to run with ATS
-		 * on even though the RID will fail ATS queries with UR. This is
-		 * because we have no idea what the PASID's need.
+		 * on because we have to assume a PASID is using ATS. For
+		 * IDENTITY this will setup things so that S1DSS=bypass which
+		 * follows the explanation in "13.6.4 Full ATS skipping stage 1"
+		 * and allows for ATS on the RID to work.
 		 */
 		state.cd_needs_ats = true;
 		arm_smmu_attach_prepare(&state, domain);
-- 
2.39.5



