Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B53D34F27B;
	Thu, 20 Aug 2026 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238343; cv=none; b=cTOl6Gmxjkt0X5grU3AJj1o/o7FcOeS5wo0ZziDs3VuurpUlCGAHEszVNQi0RoX/uiUrYxW4BMcSRr1ah+Jd00vJ8o7s1mmNDB+jGXreNCauN8Hm+9V07iqfkeZzYXWakv/u1BVGaByQGv793eL/1dSvI/Nbf9mNN4k++bKeDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238343; c=relaxed/simple;
	bh=zyMxYg2vYNtSNQ7YIlREUlUEBrAr+S1x88cV0NVw6Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiCS+GRzTNufRVSuINl3sW+aiv2kcH6jqrmdCv67fqqnQQRSj6GtOFguAmCDuYW/IVxMng36YKnawXKhyqych92GxohejQiSLMd5KF+ZLKKz/t9jtGKx9UuW431/dgwkB+IRKeVkBw37TJY/EtXvHlWDJGMAeKghM3TA32aqwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1emDcd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1emDcd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDCD1F000E9;
	Thu, 20 Aug 2026 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238342;
	bh=sgBNErmkKjPqY46zuYT3/+eGXqsxi8VC3R6GgX0COZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1emDcd4DnaxfPN5JOhtIaZWQCxQCvdYW6G2AdDtEf2nWh9CYEnw/uXQG/uXWEqUV
	 Ab/ZfNFi5273RCcQiOxVMHAvo265EhzXANhwt/wClJfsDBZskSv+u+kAdxFIJrx8j7
	 4+E2Q8ZMsBzkmeClj/9wTtoPn9xoO0d2DtLLxKtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <Kenneth.feng@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 115/228] drm/amdgpu: fix nbif 6.3.1 l1 low power not functional
Date: Thu, 20 Aug 2026 16:54:17 +0200
Message-ID: <20260820145248.130112310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -375,7 +375,6 @@ static u32 nbif_v6_3_1_get_rom_offset(st
 static void nbif_v6_3_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
-	u16 devctl2;
 
 	def = RREG32_SOC15(NBIO, 0, regRCC_EP_DEV0_0_EP_PCIE_TX_LTR_CNTL);
 	data = 0x35EB;
@@ -389,15 +388,8 @@ static void nbif_v6_3_1_program_ltr(stru
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
 
@@ -405,7 +397,7 @@ static void nbif_v6_3_1_program_aspm(str
 {
 #ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
-	u16 devctl2, ltr;
+	u16 ltr;
 
 	def = data = RREG32_SOC15(PCIE, 0, regPCIE_LC_CNTL);
 	data &= ~PCIE_LC_CNTL__LC_L1_INACTIVITY_MASK;
@@ -435,11 +427,8 @@ static void nbif_v6_3_1_program_aspm(str
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
 
@@ -447,15 +436,13 @@ static void nbif_v6_3_1_program_aspm(str
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
@@ -466,7 +453,12 @@ static void nbif_v6_3_1_program_aspm(str
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


