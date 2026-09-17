Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCD1556B85;
	Thu, 17 Sep 2026 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659641; cv=none; b=UqOjA3D6bsPnFcCpPXQ45XL0QsVm9XoayXto7OKA/pvrlM7PBXIXEKv5HpWpVDopWq/pdFQ+s6kSiEsrKzr7c3QoY34kvU1zbCC6twTJuhEvU3rREWYdsta2KiRXoMed/iWH4BvW5gH5Uo7LxYl8SjE0RnWg0xw1cEO92vmpREQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659641; c=relaxed/simple;
	bh=HZplwaJnG6MOa+O31PT3kevUf6JCA4boazr+k29E7CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNMEzeuj1NqrzQ+4NHSgVW9j4YZ7eOSKDpBBewG8LJ5/AFdz4Or7z7frGa38woiy8OY8orUVjO3otFor67+xf+8Lpe5aG1K+azwhCukWOzNqr8grsQl4T9wW59dYidsylsLDqjxUGRs1WXtXoBh7oo7PkjkHGETib3KV/1P9nfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rq4XjqX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rq4XjqX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9541F00893;
	Thu, 17 Sep 2026 15:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659631;
	bh=BwG8Ar68cuUMwcX/pRQ7PiyCIZQ/wtIu1SqjpsBiSQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rq4XjqX3/XnCrf5ctU2whH1oGFws9pjL1rDpk134Sebq3D8NT5hOgVUwRobSQC4AG
	 9xWo2+j9O//xTgGaOoN6zhL00SQOkI5ms16IpLwoOGNIFsnOjbZGA/YrJ7XLY+sVR4
	 ux5bEqPjmX3bz1s2gf94JSSACl87NHQw0aL/7GGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Juch <andreas@juch.cc>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 320/733] iommu/amd: Fix premature break in init_iommu_one() again
Date: Thu, 17 Sep 2026 16:10:28 +0100
Message-ID: <20260917151359.469556430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 16ffc75ef3f0d..3509be3fc744e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1919,19 +1919,20 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
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



