Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65597518156;
	Thu, 17 Sep 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665830; cv=none; b=dxeHAT46ML1gotJFL46a/Cmcbp/VcxF2NdrpllB0iw76UbOuMTQziUxDOLmNv1slPhdcQ4kHKl7r3rmAZKpVPHBqvSJt3ROwTHN1FAFjET5J+pxNN+9j2LkiGu/Ia2GjPGEqsAyPT+Hy8JI4XGg6yT4dxIyTji2rml9tI9Y8VBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665830; c=relaxed/simple;
	bh=CnmklAW9IKxFcnioOpDFtV1Ul3+eJ38hjpONTcxLEGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqmbMkYMcWN54H3tkCxGri3HasLWYFW3egpn6aAad2n5msEgvIoQWF+mjDX8q1PdjdsRNH1m2nnaujwYUqH5sCnrpZt3Q07w9jkQe6QU1wp3sQ9vx3loUXyx9ZO0J43d1SaUavUkz7c1f8MACzZXe2Ahg15akpOP/o4EUNnWS5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUQiRhZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUQiRhZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7411F00893;
	Thu, 17 Sep 2026 17:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665828;
	bh=GGrjZrWhBFjnX96pcg6IDg/A8KLstGG7e+PUdKj4N8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUQiRhZHCzqqF9YCog36g7xiDLcxJNSr9BA6+1XwIe5ffDxpVxhJDArMoLz97+QnJ
	 au8lKKXEpuK3gQMNuUZ2wuqUkXUFBsR4KD8war5XsebUWGg4md5n+rMqIVQbz90grl
	 njUQhK6hbfK4yvqtsVr71feozWV2FiKmVqDp+7N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Juch <andreas@juch.cc>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0834/1250] iommu/amd: Fix premature break in init_iommu_one() again
Date: Thu, 17 Sep 2026 16:10:29 +0100
Message-ID: <20260917151614.553535762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit eb29b7bbc8ba28bbb0b9fdd655e931e1d1fa625c ]

Commit 283d245468a2 ("iommu/amd: Fix premature break in
init_iommu_one()") unintentionally broke older platforms - such as
the ASRockRack B550D4-4L - where the BIOS advertises incorrect IOMMU
features.

Move the HATDis check ahead of the GASup check, and re-introduce the
break inside the GASup check to restore correct behavior on affected
platforms.

This is a short-term fix to resolve the regression. Longer term, we
should rework how EFRs are tracked and prioritize the MMIO-advertised
EFR over the one reported via IVRS. That requires more extensive
changes and will be addressed separately.

Fixes: 283d245468a2 ("iommu/amd: Fix premature break in init_iommu_one()")
Reported-by: Andreas Juch <andreas@juch.cc>
Closes: https://lore.kernel.org/linux-iommu/07b2d390-f7a0-47e2-bc2c-eb0853acf52e@juch.cc/
Tested-by: Andreas Juch <andreas@juch.cc>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e9f1e38e0deea..c07c3a01b978b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1938,19 +1938,20 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
 		else
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
 
+		if (h->efr_attr & BIT(IOMMU_IVHD_ATTR_HATDIS_SHIFT)) {
+			pr_warn_once("Host Address Translation is not supported.\n");
+			amd_iommu_hatdis = true;
+		}
+
 		/* XT and GAM require GA mode. */
 		if ((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0) {
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
+			break;
 		} else {
 			if (h->efr_reg & BIT(IOMMU_EFR_XTSUP_SHIFT))
 				amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
 		}
 
-		if (h->efr_attr & BIT(IOMMU_IVHD_ATTR_HATDIS_SHIFT)) {
-			pr_warn_once("Host Address Translation is not supported.\n");
-			amd_iommu_hatdis = true;
-		}
-
 		early_iommu_features_init(iommu, h);
 
 		break;
-- 
2.53.0



