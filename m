Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A01A23B0;
	Wed, 23 Apr 2025 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422100; cv=none; b=GuNMO3ia0WJp33odKzkCANvOvq7HMjYYHzINb39PpBt+Tp89fzXaG5cmpUiOFXSLuqxz92FVMPZp88WxoHqsTHBlWsVR2l5DZLSGRDt0ZrkzJA/LkTaaU5cSuqHuvQgcp3P4v6Fo43niHTCSHyeSsndJyDB7effbW/pwepyNcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422100; c=relaxed/simple;
	bh=G1QgOfVVz6bTBZwic3Ip6FK+5ncZdxlgH70wGJfq3IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdkNH+Ynfm7+HG4gdmmjFrZA+LsIZ4uThx2Ifnj1mclt4xOOL0x9WQi/gy1fc4+RZzAoyRlo0Ob1pxWvdHSLnRZ327X9anyukStwFS6fb1GO1I2LoDqMaRywGMp8kFgBQxhClgf8SFP1N99Qxc3n3Q5ELvDxkl2j0l9KP22qs7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgUXawEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgUXawEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262F5C4CEE2;
	Wed, 23 Apr 2025 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422099;
	bh=G1QgOfVVz6bTBZwic3Ip6FK+5ncZdxlgH70wGJfq3IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgUXawEoxZQgnhZUIIH5qXa+WR+sMxIjLGgZWYaBe+x7Vq4wby91A+NE3JjEREnpp
	 AFcsflIKQVpaclh2Y2ypyBlXDOw3cNEd2X6aTI7hW/+T1gDS6h01Mg3ieNyXBJDPBS
	 k2QK2KLB3YCszmMQ7BaU5wHqAZS+bR1wDMbEZIbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 233/291] drm/amd: Handle being compiled without SI or CIK support better
Date: Wed, 23 Apr 2025 16:43:42 +0200
Message-ID: <20250423142633.937077989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1662,7 +1662,6 @@ static const u16 amdgpu_unsupported_pcii
 };
 
 static const struct pci_device_id pciidlist[] = {
-#ifdef CONFIG_DRM_AMDGPU_SI
 	{0x1002, 0x6780, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6784, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6788, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
@@ -1735,8 +1734,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x6665, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x6667, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x666F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
-#endif
-#ifdef CONFIG_DRM_AMDGPU_CIK
 	/* Kaveri */
 	{0x1002, 0x1304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x1305, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_APU},
@@ -1819,7 +1816,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x985D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
-#endif
 	/* topaz */
 	{0x1002, 0x6900, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
 	{0x1002, 0x6901, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
@@ -2099,14 +2095,14 @@ static int amdgpu_pci_probe(struct pci_d
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
@@ -2114,16 +2110,18 @@ static int amdgpu_pci_probe(struct pci_d
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
@@ -2131,8 +2129,14 @@ static int amdgpu_pci_probe(struct pci_d
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


