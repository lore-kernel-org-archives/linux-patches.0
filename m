Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2CD5326BC;
	Wed, 23 Sep 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174103; cv=none; b=dDShStuAMCRzrT7be9Y8oS4HXzA/SX02nCtIxur1WJI5hjHESyKZsxkjVhTv2Sn4l2G4NDWesLze3I/Q+bEdHdr9r+S8IMaLtPuJSGIjbWi5LjSbtj6VuAEHiL7VP/8w0zPuO9HJJ7jVSvGam9nImoLvGwm+gb9Q7gE9MLsFNj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174103; c=relaxed/simple;
	bh=ORxxGm8EEC2ps9/jHMRADMs0ln6YYcbNZ2W8A40QJAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iarZ5bmba0rwuII/F3xyZW8rt+n38p3gWYsl9jXbBSTxKgb/I3xfZ6k9h0S3NjIJyirRI5gn16jElSddKr3wHG0OL+17RuacTa2GlPhkK3/rkInFxlIAlyBULzWIf4Qilov8DCTKBkrJ9U5okxl1H+WOjD0Y5rU3VE4QrtN5nbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHuYH6wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHuYH6wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E661F000FF;
	Wed, 23 Sep 2026 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174102;
	bh=/kGN7ka5GrtVyfzZ0XBVU5DICJRMWTG07QpEkYo4V8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHuYH6wx4dHFdcdMZvUFYnHRwi1gIiJOA2VX0wf1Kjx2VNaO0J06t+djWo2N/gJF7
	 vzeP3b8xWLE1kUusbn0DHAcOAteZlhTakPjAZFGiEDR4VUjhpw5ANQ5i3Pq/1fsMLM
	 gFyR0YWYI6X5AREZ0z2Epc0JATCWmhu49AjbTnMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 434/438] drm/amdgpu: Fix GPU PCIe link capability reporting
Date: Wed, 23 Sep 2026 16:07:35 +0200
Message-ID: <20260923140656.185637782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 04de4007d32385b8b6a5dd72bff3146dfdc592c3 ]

Commit eb53125a7ad9 ("drm/amd: Add dedicated helper for
amdgpu_device_find_parent()") made amdgpu_device_gpu_bandwidth() query
the first device outside the dGPU. That is the host side of the
physical link, not the GPU side.

As a result, the ASIC and platform capability masks can both be based
on the host port. drm_amdgpu_info_device then exposes the host
capabilities to userspace, such as Gen5 x16 for a Gen4 x8 GPU.

Cache both ends of the physical link during device initialization.
Use link_dev for the GPU capability and link_partner for the platform
capability and _PR3 detection.

Reported-by: "Marek Olšák" <maraeo@gmail.com>
Closes: https://lore.kernel.org/amd-gfx/CAAxE2A4VhsAzzO1QjBjUg+NgnbD04ZzMyN6xsUJxjKJHH6hxiw@mail.gmail.com/
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Fixes: eb53125a7ad9 ("drm/amd: Add dedicated helper for amdgpu_device_find_parent()")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ea6a47224e2c6e89a3a682d7fbaace4817a55aa)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   48 ++++++++++-------------------
 2 files changed, 20 insertions(+), 31 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -822,6 +822,9 @@ enum amdgpu_enforce_isolation_mode {
 struct amdgpu_device {
 	struct device			*dev;
 	struct pci_dev			*pdev;
+	/* The two ends of the physical PCIe link outside the device. */
+	struct pci_dev			*link_dev;
+	struct pci_dev			*link_partner;
 	struct drm_device		ddev;
 
 #ifdef CONFIG_DRM_AMD_ACP
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2045,18 +2045,17 @@ static void amdgpu_uid_fini(struct amdgp
 	adev->uid_info = NULL;
 }
 
-static struct pci_dev *amdgpu_device_find_parent(struct amdgpu_device *adev)
+static void amdgpu_device_init_pcie_links(struct amdgpu_device *adev)
 {
-	struct pci_dev *parent = adev->pdev;
+	adev->link_dev = adev->pdev;
+	adev->link_partner = pci_upstream_bridge(adev->link_dev);
 
-	/* skip upstream/downstream switches internal to dGPU */
-	while ((parent = pci_upstream_bridge(parent))) {
-		if (parent->vendor == PCI_VENDOR_ID_ATI)
-			continue;
-		break;
+	/* Skip upstream/downstream switches internal to the dGPU. */
+	while (adev->link_partner &&
+	       adev->link_partner->vendor == PCI_VENDOR_ID_ATI) {
+		adev->link_dev = adev->link_partner;
+		adev->link_partner = pci_upstream_bridge(adev->link_dev);
 	}
-
-	return parent;
 }
 
 /**
@@ -2072,7 +2071,6 @@ static struct pci_dev *amdgpu_device_fin
 static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 {
 	struct amdgpu_ip_block *ip_block;
-	struct pci_dev *parent;
 	bool total, skip_bios, early_full_gpu_access = false;
 	uint32_t bios_flags;
 	int i, r;
@@ -2168,10 +2166,9 @@ static int amdgpu_device_ip_early_init(s
 	    !dev_is_removable(&adev->pdev->dev))
 		adev->flags |= AMD_IS_PX;
 
-	if (!(adev->flags & AMD_IS_APU)) {
-		parent = amdgpu_device_find_parent(adev);
-		adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
-	}
+	if (!(adev->flags & AMD_IS_APU))
+		adev->has_pr3 = adev->link_partner &&
+			pci_pr3_present(adev->link_partner);
 
 	adev->pm.pp_feature = amdgpu_pp_feature_mask;
 	if (amdgpu_sriov_vf(adev) || sched_policy == KFD_SCHED_POLICY_NO_HWS)
@@ -3863,6 +3860,7 @@ int amdgpu_device_init(struct amdgpu_dev
 
 	adev->shutdown = false;
 	adev->flags = flags;
+	amdgpu_device_init_pcie_links(adev);
 
 	if (amdgpu_force_asic_type >= 0 && amdgpu_force_asic_type < CHIP_LAST)
 		adev->asic_type = amdgpu_force_asic_type;
@@ -6124,11 +6122,9 @@ static void amdgpu_device_partner_bandwi
 	*width = PCIE_LNK_WIDTH_UNKNOWN;
 
 	if (amdgpu_device_pcie_dynamic_switching_supported(adev)) {
-		struct pci_dev *parent = amdgpu_device_find_parent(adev);
-
-		if (parent) {
-			*speed = pcie_get_speed_cap(parent);
-			*width = pcie_get_width_cap(parent);
+		if (adev->link_partner) {
+			*speed = pcie_get_speed_cap(adev->link_partner);
+			*width = pcie_get_width_cap(adev->link_partner);
 		}
 	} else {
 		/* use the current speeds rather than max if switching is not supported */
@@ -6150,21 +6146,11 @@ static void amdgpu_device_gpu_bandwidth(
 					enum pci_bus_speed *speed,
 					enum pcie_link_width *width)
 {
-	struct pci_dev *parent = adev->pdev;
-
 	if (!speed || !width)
 		return;
 
-	/* use the device itself */
-	*speed = pcie_get_speed_cap(adev->pdev);
-	*width = pcie_get_width_cap(adev->pdev);
-
-	/* use the link outside the device */
-	parent = amdgpu_device_find_parent(adev);
-	if (parent) {
-		*speed = pcie_get_speed_cap(parent);
-		*width = pcie_get_width_cap(parent);
-	}
+	*speed = pcie_get_speed_cap(adev->link_dev);
+	*width = pcie_get_width_cap(adev->link_dev);
 }
 
 /**


