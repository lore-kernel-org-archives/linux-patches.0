Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EB03803D9;
	Thu, 20 Aug 2026 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239538; cv=none; b=lkl7ziJzaBWOeSMV48LOcXkGYn7h0I4csASRr37mxlPrH3sdqxEMmsnC4O42AOa7WxmCWjVHSaQ057XxudssjZ6bRz/fOPw/9gC7yKKRUrnO+e73ppWzsoahaQF9DejdQM7yu/qqA4qy44HWKwzPBteSWZXxWb9XYjoc2RYD7xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239538; c=relaxed/simple;
	bh=OgWHd11wi2ai6R6SjqmAM6gouyOpXYbN42xzu2Kb9Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIPi4/rOxiRKKDfvjGLPPO19teZZhSadyn4lyTJuJuGz0IiVBc6WEMOkb8yvpHOHhRJpNpfV5hRZRLzK7GzFKTc+YHxMU25RkaatY6RYt/NYS99wOlvOFWP0aXtVQc+TYpHGcCpxG4/CeUsCcY8x1qagktkCWTP77rx0zE3zGbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjuKE50p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjuKE50p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E353E1F000E9;
	Thu, 20 Aug 2026 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239536;
	bh=512BUicVG8DvPY+JNJBLr7K7wBL0hEu4+Lcj8ckoP1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjuKE50pYW+wC1lnWLHrajq82NinQDRjN3XZ43C2L83/UlZ7hx+nC9zMtuEXnIHoo
	 CWwfyk+LEq6ndYu4RS6LJme40LHy1tBRtYadw25DI+JX+F2TuO7upBZyHUoBUSZsLX
	 /fxd/ZJ3FNWtfQ15qRaLYjd+hc2WJ/yZvHfqy164=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <Kenneth.feng@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 083/220] drm/amdgpu: fix nbif 6.3.1 l1 low power not functional
Date: Thu, 20 Aug 2026 16:54:33 +0200
Message-ID: <20260820145225.978878061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit cd688a3cb342b9f56399aa076157f1c324c15c5a upstream.

The PCIe L1 low‑power settings for NBIF 6.3.1 were never applied due to
unresolved register mapping, which caused the relevant code to be compiled out.
As a result, the PCIe link could not enter L1/L23 power‑down states or transition to L0s.

Properly configure the link control register to enable L1 and L23 power‑down,
and permit L0s link transitions. Keep LTR disabled and let the PCI core enable it
only after verifying end‑to‑end root complex support across switches.

Fixes: 894c6d3522d1 ("drm/amdgpu: Add nbif v6_3_1 ip block support")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Kenneth Feng <Kenneth.feng@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c2417f9fd7049d5a8d87eefd82fd6e36ba1ff7b6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c |   42 ++++++++++++-------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c
@@ -315,7 +315,6 @@ static u32 nbif_v6_3_1_get_rom_offset(st
 static void nbif_v6_3_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
-	u16 devctl2;
 
 	def = RREG32_SOC15(NBIO, 0, regRCC_EP_DEV0_0_EP_PCIE_TX_LTR_CNTL);
 	data = 0x35EB;
@@ -329,15 +328,8 @@ static void nbif_v6_3_1_program_ltr(stru
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_BIF_STRAP2, data);
 
-	pcie_capability_read_word(adev->pdev, PCI_EXP_DEVCTL2, &devctl2);
-
-	if (adev->pdev->ltr_path == (devctl2 & PCI_EXP_DEVCTL2_LTR_EN))
-		return;
-
-	if (adev->pdev->ltr_path)
-		pcie_capability_set_word(adev->pdev, PCI_EXP_DEVCTL2, PCI_EXP_DEVCTL2_LTR_EN);
-	else
-		pcie_capability_clear_word(adev->pdev, PCI_EXP_DEVCTL2, PCI_EXP_DEVCTL2_LTR_EN);
+	pcie_capability_set_word(adev->pdev, PCI_EXP_DEVCTL2,
+				 PCI_EXP_DEVCTL2_LTR_EN);
 }
 #endif
 
@@ -345,7 +337,7 @@ static void nbif_v6_3_1_program_aspm(str
 {
 #ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
-	u16 devctl2, ltr;
+	u16 ltr;
 
 	def = data = RREG32_SOC15(PCIE, 0, regPCIE_LC_CNTL);
 	data &= ~PCIE_LC_CNTL__LC_L1_INACTIVITY_MASK;
@@ -375,11 +367,8 @@ static void nbif_v6_3_1_program_aspm(str
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_BIF_STRAP5, data);
 
-	pcie_capability_read_word(adev->pdev, PCI_EXP_DEVCTL2, &devctl2);
-	data = def = devctl2;
-	data &= ~PCI_EXP_DEVCTL2_LTR_EN;
-	if (def != data)
-		pcie_capability_set_word(adev->pdev, PCI_EXP_DEVCTL2, (u16)data);
+	pcie_capability_clear_word(adev->pdev, PCI_EXP_DEVCTL2,
+				   PCI_EXP_DEVCTL2_LTR_EN);
 
 	ltr = pci_find_ext_capability(adev->pdev, PCI_EXT_CAP_ID_LTR);
 
@@ -387,15 +376,13 @@ static void nbif_v6_3_1_program_aspm(str
 		pci_write_config_dword(adev->pdev, ltr + PCI_LTR_MAX_SNOOP_LAT, 0x10011001);
 	}
 
-#if 0
-	/* regPSWUSP0_PCIE_LC_CNTL2 should be replace by PCIE_LC_CNTL2 or someone else ? */
-	def = data = RREG32_SOC15(NBIO, 0, regPSWUSP0_PCIE_LC_CNTL2);
-	data |= PSWUSP0_PCIE_LC_CNTL2__LC_ALLOW_PDWN_IN_L1_MASK |
-		PSWUSP0_PCIE_LC_CNTL2__LC_ALLOW_PDWN_IN_L23_MASK;
-	data &= ~PSWUSP0_PCIE_LC_CNTL2__LC_RCV_L0_TO_RCV_L0S_DIS_MASK;
+	def = data = RREG32_SOC15(PCIE, 0, regPCIE_LC_CNTL2);
+	data |= PCIE_LC_CNTL2__LC_ALLOW_PDWN_IN_L1_MASK |
+		PCIE_LC_CNTL2__LC_ALLOW_PDWN_IN_L23_MASK;
+	data &= ~PCIE_LC_CNTL2__LC_RCV_L0_TO_RCV_L0S_DIS_MASK;
 	if (def != data)
-		WREG32_SOC15(NBIO, 0, regPSWUSP0_PCIE_LC_CNTL2, data);
-#endif
+		WREG32_SOC15(PCIE, 0, regPCIE_LC_CNTL2, data);
+
 	def = data = RREG32_SOC15(PCIE, 0, regPCIE_LC_CNTL4);
 	data |= PCIE_LC_CNTL4__LC_L1_POWERDOWN_MASK;
 	if (def != data)
@@ -406,7 +393,12 @@ static void nbif_v6_3_1_program_aspm(str
 	if (def != data)
 		WREG32_SOC15(PCIE, 0, regPCIE_LC_RXRECOVER_RXSTANDBY_CNTL, data);
 
-	nbif_v6_3_1_program_ltr(adev);
+	/*
+	 * Do not enable endpoint LTR unless the Root Complex and every
+	 * upstream switch support it.
+	 */
+	if (adev->pdev->ltr_path)
+		nbif_v6_3_1_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_STRAP0_RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;


