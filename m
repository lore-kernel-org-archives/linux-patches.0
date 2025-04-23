Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72628F502;
	Wed, 23 Apr 2025 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420848; cv=none; b=eWVt+xR7rSgBqsETGK6RSD/gsjtxpKt8e3OcW0C6J6n2FTEto7AoIjUcRodjCSIc/svBpUpDNPjgTfZAsJ+rTFSQ91Ii9p4fvTm9OmH1RPeM+Br+OuOagBO1WNRNjJ2dPsmRFinQn0WTf7bc9+Q1iG8QJRbQsKU6yIYt0b4v+ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420848; c=relaxed/simple;
	bh=AS6E8fIVTrQZKMYOqKArIaoXp4JuIH6govfel82AnHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK8HYpYsrZJF42kWYVe5Xo4Eb1mFQ1YzUmhynYP8at4TLJGFOMin4JrdhbS8XRKCHa6f2X/4fStnPsStOmvlfU3qhuHZ8MKijq4qv7j6Dqb6Pg7riXdz5S4cspBo8mCbTx0aJBKI3VUa9DFXuAT3nld/XXNdv5yoFsv6n1ZOrqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yjk5stg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yjk5stg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AA9C4CEE2;
	Wed, 23 Apr 2025 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420848;
	bh=AS6E8fIVTrQZKMYOqKArIaoXp4JuIH6govfel82AnHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yjk5stg8paq1AOiK+OSH+aod+1THKohbRL+XxseUPw9tLjeZfoHAfatZhVA6MFdwR
	 dVGAWsQqx5HOSbo5Z+kn+s2E8PiRbzHYemWIo1esz9VUe8Gci7AW2KxYGrrntOoit0
	 be+xO9c+aBHNqJ1YQUsBMXBhxY0l9AjO9y4Il5qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 154/223] drm/amd: Handle being compiled without SI or CIK support better
Date: Wed, 23 Apr 2025 16:43:46 +0200
Message-ID: <20250423142623.448811943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
@@ -1795,7 +1795,6 @@ static const u16 amdgpu_unsupported_pcii
 };
 
 static const struct pci_device_id pciidlist[] = {
-#ifdef CONFIG_DRM_AMDGPU_SI
 	{0x1002, 0x6780, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6784, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
 	{0x1002, 0x6788, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI},
@@ -1868,8 +1867,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x6665, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x6667, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
 	{0x1002, 0x666F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HAINAN|AMD_IS_MOBILITY},
-#endif
-#ifdef CONFIG_DRM_AMDGPU_CIK
 	/* Kaveri */
 	{0x1002, 0x1304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x1305, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_KAVERI|AMD_IS_APU},
@@ -1952,7 +1949,6 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x985D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
 	{0x1002, 0x985F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MULLINS|AMD_IS_MOBILITY|AMD_IS_APU},
-#endif
 	/* topaz */
 	{0x1002, 0x6900, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
 	{0x1002, 0x6901, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TOPAZ},
@@ -2284,14 +2280,14 @@ static int amdgpu_pci_probe(struct pci_d
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
@@ -2299,16 +2295,18 @@ static int amdgpu_pci_probe(struct pci_d
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
@@ -2316,8 +2314,14 @@ static int amdgpu_pci_probe(struct pci_d
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


