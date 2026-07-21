Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD16405845;
	Tue, 21 Jul 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656171; cv=none; b=nfJxdMH2rr8Fs7UwrkI5LPkO/nOy0cW+OgpkQU4jLCG5KDVfYwlMqFM9ppGyXn2esIPhUOfug/pYicPj4CW7P0+7UrmPd4RRNcOOtTkNVdiwasHVUHPXAAl7CbEpyszolD4lktDZNP2B0LoKHWFMLihNk1C7kff3BXLAi7QHOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656171; c=relaxed/simple;
	bh=whi4++P1Qw747g0l3OHJ9NY1nEbfVo0lyIoUTwkkb+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTGNRqxktv5QmpKh7E3nDRTQh3hfmMWrssHiGwTpunVSQtB40V51BNxMDIMTuYI1riYwOzTpHhR/zjeLxYqqNZMW4LEodJhpBpU8Vg+NyopnMBfKbkCeZFjIaqp5rNl+slD/v3NFEITToI2nK3gxxipasYXvxvJh8jeUXyuzkYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGZa251i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGZa251i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013B1F00A3F;
	Tue, 21 Jul 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656170;
	bh=m2n+ILi5UQwYi0FrB/wLBxfpSmy/hkdO3Q8MfEb6HCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGZa251iLUKR2d7LA/k1IDq3ShME5o/JljyMf4L4+8PIosnsWxYarhH26vQDOG0ZE
	 ziUoelUIDmHwbErmZFnw+pj705lXNMIL5tNBXSBSk8uvrUyl/bMqBIbXPdyzdEbeeD
	 6+9YG/rkz5jLlpdrEM/rTRGszLhk6/qaSWRAOrkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheer Dantuluri <dantuluris@google.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0243/1611] iommu/amd: Fix premature break in init_iommu_one()
Date: Tue, 21 Jul 2026 17:05:59 +0200
Message-ID: <20260721152520.485985956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 283d245468a2b61c41aa8b582f25ed5615d1c304 ]

In init_iommu_one(), when processing IOMMU EFR attributes, the code checks
whether GASUP is enabled. If GASUP is not enabled, the code falls back to
legacy guest IR mode and then breaks out of the switch statement.

This break incorrectly skips the subsequent initialization steps that
follow the GASUP check. These initializations are independent of GASUP
support and must always be performed.

Fix this by replacing the early break with a conditional else block,
ensuring that the XTSUP check is only skipped when GASUP is not available.

Fixes: a44092e326d4 ("iommu/amd: Use IVHD EFR for early initialization of IOMMU features")
Reported-by: Sudheer Dantuluri <dantuluris@google.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6e5efc340c83e4..32175daa3dd8a1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1933,12 +1933,11 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
 		/* XT and GAM require GA mode. */
 		if ((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0) {
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
-			break;
+		} else {
+			if (h->efr_reg & BIT(IOMMU_EFR_XTSUP_SHIFT))
+				amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
 		}
 
-		if (h->efr_reg & BIT(IOMMU_EFR_XTSUP_SHIFT))
-			amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
-
 		if (h->efr_attr & BIT(IOMMU_IVHD_ATTR_HATDIS_SHIFT)) {
 			pr_warn_once("Host Address Translation is not supported.\n");
 			amd_iommu_hatdis = true;
-- 
2.53.0



