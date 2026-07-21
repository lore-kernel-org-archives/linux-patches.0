Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E0415F04;
	Tue, 21 Jul 2026 20:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664452; cv=none; b=l4VsjWRSJFU/F2egtBx+am1eObHc7KZiSquLVk+DV6dzFI6GHeqqM0OrOLaMcE3PTzyKNNryYtATY9R3AiI+du7jAzT6p1VVeBKz+oVBCWUagM+VWT+xR9RQZNtvY2JlO9rTOfQ1usmZwkkkOj5Zgi7itYJJFuq3wiKQggwtjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664452; c=relaxed/simple;
	bh=fnIXu4E5zPRSb3eaMRxi5jyD1bONVNdhlStzYSuXDco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CagQSEaAWaGwDnWrE8/8LHtiwli8OfOc/ISYVAJxPoU12CtTa92RIYOPh37vjJ0S1/wD5aK006VTKz8hK54/r042TlTZoV8fUTCiyOEHf4d7NcNykw6rgy+bP1k/EIQq/Yh8SzaEgl/UUk2x5H8cWRH0m8lmOkBUDj9sr2N9hzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osPBZA4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osPBZA4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADD11F00A3A;
	Tue, 21 Jul 2026 20:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664451;
	bh=vGl+wYRkcfY119HHLhmaj6jMgcFPGI9iRJ8fgHgjMUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osPBZA4oByOZ2Jhy25aphXdF3HJGa+v8tGgOCwmBIzvse9FciUCsWCu2wBl/IiBNn
	 +l5I9Xly7eW/6xonRYxL/R/b6ntnm1RnZzEjKiJSQhj9ucJ8vQ/ID3M59oD1Wt+QP1
	 kypXLe5YjslCxHBySSkXpYvssX3ieYlOcEn7+p0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1152/1276] PCI: Use pbus_select_window() during BAR resize
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152511.789145948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 7dc58aa7f1b32a215fb0b7c6ca30ddf4663dedf4 ]

Prior to a BAR resize, __resource_resize_store() loops through the normal
resources of the PCI device and releases those that match to the flags of
the BAR to be resized. This is necessary to allow resizing also the
upstream bridge window as only childless bridge windows can be resized.

While the flags check (mostly) works (if corner cases are ignored), the
more straightforward way is to check if the resources share the bridge
window. Change __resource_resize_store() to do the check using
pbus_select_window().

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250829131113.36754-16-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1426,13 +1426,19 @@ static ssize_t __resource_resize_store(s
 				       const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	unsigned long size, flags;
+	struct pci_bus *bus = pdev->bus;
+	struct resource *b_win, *res;
+	unsigned long size;
 	int ret, i;
 	u16 cmd;
 
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
+	b_win = pbus_select_window(bus, pci_resource_n(pdev, n));
+	if (!b_win)
+		return -EINVAL;
+
 	device_lock(dev);
 	if (dev->driver || pci_num_vf(pdev)) {
 		ret = -EBUSY;
@@ -1452,19 +1458,19 @@ static ssize_t __resource_resize_store(s
 	pci_write_config_word(pdev, PCI_COMMAND,
 			      cmd & ~PCI_COMMAND_MEMORY);
 
-	flags = pci_resource_flags(pdev, n);
-
 	pci_remove_resource_files(pdev);
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
-		if (pci_resource_len(pdev, i) &&
-		    pci_resource_flags(pdev, i) == flags)
+	pci_dev_for_each_resource(pdev, res, i) {
+		if (i >= PCI_BRIDGE_RESOURCES)
+			break;
+
+		if (b_win == pbus_select_window(bus, res))
 			pci_release_resource(pdev, i);
 	}
 
 	ret = pci_resize_resource(pdev, n, size);
 
-	pci_assign_unassigned_bus_resources(pdev->bus);
+	pci_assign_unassigned_bus_resources(bus);
 
 	if (pci_create_resource_files(pdev))
 		pci_warn(pdev, "Failed to recreate resource files after BAR resizing\n");


