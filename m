Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B60435A94;
	Thu, 30 Jul 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427651; cv=none; b=rnbMMmr2z77aT0q8Uuu42WF/emguUmAZYv9j/9YnJS6/vJ1j6DIpSdoYhHecO4XtSdvntbQD1P4gU3TjuUuiuxBKdu0QwM4fy5cfHVkCfQjgKn+q+F4GX4qOyOqR9cy4JCVwDU08jKPVBC1WZ8NBgv6eaKkotuzpUbptWO7fExw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427651; c=relaxed/simple;
	bh=etQilNFRoxOPKoUUxgaIhavD8dgvTxcie4VkxGD4iaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRnoqA2olLZv0sS25D3pIyj+UOFXTdujCXy8yKo5Xxr5A65R7BTmpfZr6KlOljjpfHYbG7pQuZ1BfNMTOQNhQimDq1NivPP43r+tF3blSChqpDI5FJ+wJWla19/U14FeMEM5o6KD8vqqtcDizhPnhAosDQPjyxz6gswJ2eiNQyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHwnTj77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHwnTj77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C191F000E9;
	Thu, 30 Jul 2026 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427649;
	bh=AHSoE/9qsmtYsTAfM312IM9cYchh9MqFg+BtKLwtyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHwnTj77MgNt/QLtWv0h9KptdCl9SuoKFGhGGDjZpSfa9CRYmmT+uXxzn18AsjbdG
	 9b+5way6n9nafhGC91P56NMWJ4xcYmryTxgp2mtGjjVZ75F/TOPF3DhUmviQVLRUvP
	 m3hozbhYnUqpWMVIfwsKKwW0+RStP3lJEhXIV4iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oz Tiram <oz@shift-computing.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 228/484] drm/amdgpu: Fix VFCT bus number matching with soft filter
Date: Thu, 30 Jul 2026 16:12:05 +0200
Message-ID: <20260730141428.429125181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit db7e8108809a2245f0a17ba323f027cac0941ffb upstream.

On systems where PCI bus renumbering occurs (e.g. pci=realloc,
resource conflicts), the runtime bus number may differ from the
BIOS POST bus number recorded in the VFCT table. This causes
amdgpu_acpi_vfct_bios() to fail finding the VBIOS even though
the correct device entry exists.

Introduce amdgpu_acpi_vfct_match() which treats the bus number
as a soft filter: vendor/device/function identity is the hard
requirement, while exact bus match is the preferred path. When
bus numbers disagree but device identity matches, accept the
VFCT entry and log a dev_notice for diagnostics.

Reported-by: Oz Tiram <oz@shift-computing.de>
Closes: https://lore.kernel.org/amd-gfx/20260621173211.28443-1-oz@shift-computing.de/
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20260708193518.702584-2-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 11c141672045ffc0187aa604f2c0f597bc334fb2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c |   45 +++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -361,6 +361,45 @@ static bool amdgpu_read_disabled_bios(st
 }
 
 #ifdef CONFIG_ACPI
+/**
+ * amdgpu_acpi_vfct_match() - Check if a VFCT entry matches the device
+ * @adev: AMDGPU device
+ * @vhdr: VFCT image header to check
+ *
+ * VFCT entries contain the PCI bus number as recorded during BIOS POST.
+ * On systems where the kernel renumbers PCI buses (e.g. pci=realloc or
+ * resource conflicts), the runtime bus number may differ from the POST
+ * value.  Match by device identity (vendor + device + function) and use
+ * the bus number as a preference: exact bus match is preferred, but when
+ * the bus numbers disagree we accept the entry if the device identity
+ * matches.
+ *
+ * Returns: 0 on match, -ENODEV on no match
+ */
+static int amdgpu_acpi_vfct_match(struct amdgpu_device *adev,
+				  VFCT_IMAGE_HEADER *vhdr)
+{
+	/* Vendor and device IDs must always match */
+	if (vhdr->VendorID != adev->pdev->vendor ||
+	    vhdr->DeviceID != adev->pdev->device)
+		return -ENODEV;
+
+	if (vhdr->PCIDevice != PCI_SLOT(adev->pdev->devfn) ||
+	    vhdr->PCIFunction != PCI_FUNC(adev->pdev->devfn))
+		return -ENODEV;
+
+	/* Exact bus number match - preferred */
+	if (vhdr->PCIBus == adev->pdev->bus->number)
+		return 0;
+
+	/* Bus mismatch but device identity matches (PCI renumbering case) */
+	dev_notice(adev->dev,
+		   "VFCT bus number mismatch: table %u != runtime %u, matching by device identity (vendor 0x%04x device 0x%04x)\n",
+		   vhdr->PCIBus, adev->pdev->bus->number,
+		   adev->pdev->vendor, adev->pdev->device);
+	return 0;
+}
+
 static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 {
 	struct acpi_table_header *hdr;
@@ -396,11 +435,7 @@ static bool amdgpu_acpi_vfct_bios(struct
 		}
 
 		if (vhdr->ImageLength &&
-		    vhdr->PCIBus == adev->pdev->bus->number &&
-		    vhdr->PCIDevice == PCI_SLOT(adev->pdev->devfn) &&
-		    vhdr->PCIFunction == PCI_FUNC(adev->pdev->devfn) &&
-		    vhdr->VendorID == adev->pdev->vendor &&
-		    vhdr->DeviceID == adev->pdev->device) {
+		    !amdgpu_acpi_vfct_match(adev, vhdr)) {
 			adev->bios = kmemdup(&vbios->VbiosContent,
 					     vhdr->ImageLength,
 					     GFP_KERNEL);


