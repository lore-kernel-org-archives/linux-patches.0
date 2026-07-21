Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B900A1A239A;
	Tue, 21 Jul 2026 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648805; cv=none; b=YE43CsQhXbqQaxYEeyv0qzetkhyzESxXWylGd6MMYmvyAWiZ94IiWUyklUgZFbI3muunvbtkOXAbM6xGP2WJ3RBW3UnUpLtznrSPxaBzp3pXCtWM50zPJOSGS0fA/ixHa+H+DcF/zzKVdd7YojXoDRdAxEWPA4cc6aMJ7jULAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648805; c=relaxed/simple;
	bh=8VnSOIp5yw58B1LxQ4Z36iS1qhsRATEgJ2Iv/JNKaRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWW3/+/4NyW+fTcJZt/XhY0GKJGEucot1DHSEPj/+kk4Wq8hiVGCETo1WKpCGxsmnGKeEBUWPbJH+uX0R/Krb2odAfMhnPZ1BW8TKDIBjF1+1RbdosVfi2SYSBCAcZg1NGFUHeC5mMayCHLy6vjCfjcE5gADihi5OBeYRYexGPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP+JhcpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP+JhcpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F041F00A3A;
	Tue, 21 Jul 2026 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648804;
	bh=QRHK9oD4MiCcfKJvzDsvpq6jHaulATpsop14lr7/laU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PP+JhcpQ7PDI3EY0V0hr3N9C18cSJY6tntdCNNLcS/Tdpt5GrK5pogAHe+oc4I86r
	 SGpK6/QNGFqDa96KjWCGFyCbwwpDkACpVzvnCJpXSvQEq5r3cj26tFpSglPIqMc1/+
	 nIQW10M7FxnTbKaLBmdQs6sYL0C+0XfPE1gPxAJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheer Dantuluri <dantuluris@google.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0338/2077] iommu/amd: Fix premature break in init_iommu_one()
Date: Tue, 21 Jul 2026 17:00:11 +0200
Message-ID: <20260721152600.656298830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3bdb380d23e9a9..9a846dcd030638 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1939,12 +1939,11 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
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



