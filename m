Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173E920967D;
	Thu, 12 Dec 2024 17:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024124; cv=none; b=h1fGcStLAS6l+uXNBVsUVbBkvOWxfaNbWJGUR+Ui8PpPGPfF+0TmCuP31jXHvEif8fF6Z7C/bgIM6OrPA1MvWSOoAbt0p7zpdF3yP6lx7bvbURqg8lV0QmbpBgbJySo7HUS5A7VhSgYX8ZRtmowFBLIxkHK0MkgaYHFIhzI9Re4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024124; c=relaxed/simple;
	bh=yEcMXL+dVhN01cmXQbD4sdm3EhW2x6xDyKZYHuu7Y4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hr3N/jWjTNdT17kjWXpXYGS337lUfGAM3UABlgOk/7Say+8UuGkoLs178StmWOt2NbaBUanXznrPJBMxnFnKfziKZ/h27SYxN96BPbOKs/qWJcMtkokEsTuSH9HPc3nMJj+8S18c1qUG/HDf3KtfXrL68X1BCqV0+LQYuvLD41c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yACBf64m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yACBf64m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAF1C4CECE;
	Thu, 12 Dec 2024 17:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024123;
	bh=yEcMXL+dVhN01cmXQbD4sdm3EhW2x6xDyKZYHuu7Y4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yACBf64mQ0r30yPrIEeIHMnjOqOwwr9zI3WfcQ8FjPbYFKzDE9QffUIoOBRv8jnO0
	 /JJsQNrhDVI83DdrfFYkgwqbHjLG+E6IJEZdBA8cFAhAwdLCaYo4AMiJs8UpENKmjj
	 Ohp3An7NKFfNu6fU6mwezpHkV9Kh2NC7uxj6nWDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/459] PCI: cpqphp: Fix PCIBIOS_* return value confusion
Date: Thu, 12 Dec 2024 15:58:52 +0100
Message-ID: <20241212144301.231586227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit e2226dbc4a4919d9c8bd9293299b532090bdf020 ]

Code in and related to PCI_RefinedAccessConfig() has three types of return
type confusion:

 - PCI_RefinedAccessConfig() tests pci_bus_read_config_dword() return value
   against -1.

 - PCI_RefinedAccessConfig() returns both -1 and PCIBIOS_* return codes.

 - Callers of PCI_RefinedAccessConfig() only test for -1.

Make PCI_RefinedAccessConfig() return PCIBIOS_* codes consistently and
adapt callers accordingly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20241022091140.3504-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/cpqphp_pci.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index a20875da4ec70..ce6eb71a63599 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -135,11 +135,13 @@ int cpqhp_unconfigure_device(struct pci_func *func)
 static int PCI_RefinedAccessConfig(struct pci_bus *bus, unsigned int devfn, u8 offset, u32 *value)
 {
 	u32 vendID = 0;
+	int ret;
 
-	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &vendID) == -1)
-		return -1;
+	ret = pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &vendID);
+	if (ret != PCIBIOS_SUCCESSFUL)
+		return PCIBIOS_DEVICE_NOT_FOUND;
 	if (PCI_POSSIBLE_ERROR(vendID))
-		return -1;
+		return PCIBIOS_DEVICE_NOT_FOUND;
 	return pci_bus_read_config_dword(bus, devfn, offset, value);
 }
 
@@ -200,13 +202,15 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 *dev_
 {
 	u16 tdevice;
 	u32 work;
+	int ret;
 	u8 tbus;
 
 	ctrl->pci_bus->number = bus_num;
 
 	for (tdevice = 0; tdevice < 0xFF; tdevice++) {
 		/* Scan for access first */
-		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
+		ret = PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work);
+		if (ret)
 			continue;
 		dbg("Looking for nonbridge bus_num %d dev_num %d\n", bus_num, tdevice);
 		/* Yep we got one. Not a bridge ? */
@@ -218,7 +222,8 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 *dev_
 	}
 	for (tdevice = 0; tdevice < 0xFF; tdevice++) {
 		/* Scan for access first */
-		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
+		ret = PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work);
+		if (ret)
 			continue;
 		dbg("Looking for bridge bus_num %d dev_num %d\n", bus_num, tdevice);
 		/* Yep we got one. bridge ? */
-- 
2.43.0



