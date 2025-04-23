Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEF928C5BF;
	Wed, 23 Apr 2025 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421360; cv=none; b=EFUpo+DdVTg+GKpYF95AX5DB0MAS2U7YpejqgmSJ/jpJI3m66l0aESAs6P3/VoStwU/qA7syd8rRrKtmpP/HodRopiGSytJuSJFMZ1IgKFY3oz1i8XHxNvXuy6f6xiqeEyn+S1Bf5Jjn28L8GXeXxB4gnXKTclznjOU34XVGbFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421360; c=relaxed/simple;
	bh=NTT0sBUSZIL6IcfXkuRzN9wVmNEsffD4RcPXtnZf9Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPolGlcvwlwEsi1kpaC/S5RGwNMXEWddkkFmgSZ31UAww/+vUdS606KOIG/sKPGQpS2xp9bsJVchFWW65igW7IFkhsK8o91mWE6fH88Ngm3jAGwSdb/iPYqjAlbe+HYrXUJDGYhacPo3sFGGmAx9cnLqVX9t6IivEgsZHEn+q9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHFxlS1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHFxlS1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02D3C4CEE2;
	Wed, 23 Apr 2025 15:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421360;
	bh=NTT0sBUSZIL6IcfXkuRzN9wVmNEsffD4RcPXtnZf9Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHFxlS1uLcr2llZamHt3+un4PZTFwS/MXakSB840Q2JG3TS+57j6FqJbGDhl7JdL+
	 bXwVKi2x5ni210YiqDeviRTjCI0L4bhBHd+SOlC2KTA2iWjP3BjzzSw4gHf//Se5Cn
	 gM+LSSaNVLrwHw3HMEaECCISVJMocKBpUqBeX6dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 178/241] drm/amd: Handle being compiled without SI or CIK support better
Date: Wed, 23 Apr 2025 16:44:02 +0200
Message-ID: <20250423142627.796814891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 5f054ddead33c1622ea9c0c0aaf07c6843fc7ab0 upstream.

If compiled without SI or CIK support but amdgpu tries to load it
will run into failures with uninitialized callbacks.

Show a nicer message in this case and fail probe instead.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4050
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   44 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1791,7 +1791,6 @@ static const u16 amdgpu_unsupported_pcii
 };
 
 static const struct pci_device_id pciidlist[] = {
-#ifdef CONFIG_DRM_AMDGPU_SI
 	{0x1002, 0x6780, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6784, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6788, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
@@ -1864,8 +1863,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x6665, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x6667, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x666F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
-#endif
-#ifdef CONFIG_DRM_AMDGPU_CIK
 	/* Kaveri */
 	{0x1002, 0x1304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x1305, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_APU},
@@ -1948,7 +1945,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x985D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
-#endif
 	/* topaz */
 	{0x1002, 0x6900, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
 	{0x1002, 0x6901, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
@@ -2280,14 +2276,14 @@ static int amdgpu_pci_probe(struct pci_d
 		return -ENOTSUPP;
 	}
 
+	switch (flags & AMD_ASIC_MASK) {
+	case CHIP_TAHITI:
+	case CHIP_PITCAIRN:
+	case CHIP_VERDE:
+	case CHIP_OLAND:
+	case CHIP_HAINAN:
 #ifdef CONFIG_DRM_AMDGPU_SI
-	if (!amdgpu_si_support) {
-		switch (flags & AMD_ASIC_MASK) {
-		case CHIP_TAHITI:
-		case CHIP_PITCAIRN:
-		case CHIP_VERDE:
-		case CHIP_OLAND:
-		case CHIP_HAINAN:
+		if (!amdgpu_si_support) {
 			dev_info(&pdev->dev,
 				 "SI support provided by radeon.\n");
 			dev_info(&pdev->dev,
@@ -2295,16 +2291,18 @@ static int amdgpu_pci_probe(struct pci_d
 				);
 			return -ENODEV;
 		}
-	}
+		break;
+#else
+		dev_info(&pdev->dev, "amdgpu is built without SI support.\n");
+		return -ENODEV;
 #endif
+	case CHIP_KAVERI:
+	case CHIP_BONAIRE:
+	case CHIP_HAWAII:
+	case CHIP_KABINI:
+	case CHIP_MULLINS:
 #ifdef CONFIG_DRM_AMDGPU_CIK
-	if (!amdgpu_cik_support) {
-		switch (flags & AMD_ASIC_MASK) {
-		case CHIP_KAVERI:
-		case CHIP_BONAIRE:
-		case CHIP_HAWAII:
-		case CHIP_KABINI:
-		case CHIP_MULLINS:
+		if (!amdgpu_cik_support) {
 			dev_info(&pdev->dev,
 				 "CIK support provided by radeon.\n");
 			dev_info(&pdev->dev,
@@ -2312,8 +2310,14 @@ static int amdgpu_pci_probe(struct pci_d
 				);
 			return -ENODEV;
 		}
-	}
+		break;
+#else
+		dev_info(&pdev->dev, "amdgpu is built without CIK support.\n");
+		return -ENODEV;
 #endif
+	default:
+		break;
+	}
 
 	adev = devm_drm_dev_alloc(&pdev->dev, &amdgpu_kms_driver, typeof(*adev), ddev);
 	if (IS_ERR(adev))


