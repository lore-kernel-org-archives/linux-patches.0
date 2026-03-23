Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35603A960E;
	Mon, 23 Mar 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282823; cv=none; b=f14O+Vn+j3Q9GZvjBc6Tw5a5ZAhGZ5amM/Xu5RZRIB6kNs8/MRsAACBA94Bg155+s/3zV/3F7ypiLOcLukHHlqi7IHFbGVaV8aAQzavhzeSkFFSgqK8ztWDyjukN5IU0wYU1kmRf/wWFod7cDrD3LaGo8XiNHt62+BzIk4gFXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282823; c=relaxed/simple;
	bh=0JeTYh5DAI3rpBm4zcATVmub6TmZex+tBm9Xb01DFgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQpPA+6jA3gwHRr9rq6vLsu9yyrCNG9N963j0nnVtlIWaJQhBtuPliAr09PjRfM5hFTXfEa2RzYykm60dMeRAkNUhRoxwZZlkrQ0g7r23BqCWNqT1dwi/GWoersskqlfUbiSdKcD/e6BmPX+PEocO1EJuKyrf+AyTMxTThpyHnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mOYgvEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mOYgvEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D270C4CEF7;
	Mon, 23 Mar 2026 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282823;
	bh=0JeTYh5DAI3rpBm4zcATVmub6TmZex+tBm9Xb01DFgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mOYgvEwjSvp8iCRjXW1swYnwXrzMHeelhkbDyGAFS3TPh61VvEpgiAd6mtAt25GQ
	 16bnrTteKJdbzyWv3OTDJJMfNtIteRa2PDcJeECa7EYvJ9GIHnEX7RRyMaKm2XQmNu
	 fMtY7lHjVdF7fSpS5hVKIIoVHMWf1mXhabkpeTzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Roukala=20 ?= <martin.roukala@mupuf.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 299/481] serial: 8250_pci: add support for the AX99100
Date: Mon, 23 Mar 2026 14:44:41 +0100
Message-ID: <20260323134532.401283452@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Roukala (né Peres) <martin.roukala@mupuf.org>

commit 9c0072bc33d349c83d223e64be30794e11938a6b upstream.

This is found in popular brands such as StarTech.com or Delock, and has
been a source of frustration to quite a few people, if I can trust
Amazon comments complaining about Linux support via the official
out-of-the-tree driver.

Signed-off-by: Martin Roukala (né Peres) <martin.roukala@mupuf.org>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260309-8250_pci_ax99100-v1-1-3328bdfd8e94@mupuf.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -58,6 +58,8 @@ struct serial_private {
 };
 
 #define PCI_DEVICE_ID_HPE_PCI_SERIAL	0x37e
+#define PCIE_VENDOR_ID_ASIX		0x125B
+#define PCIE_DEVICE_ID_AX99100		0x9100
 
 static const struct pci_device_id pci_use_msi[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9900,
@@ -70,6 +72,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
 			 PCI_ANY_ID, PCI_ANY_ID) },
+	{ PCI_DEVICE_SUB(PCIE_VENDOR_ID_ASIX, PCIE_DEVICE_ID_AX99100,
+			 0xA000, 0x1000) },
 	{ }
 };
 
@@ -854,6 +858,7 @@ static int pci_netmos_init(struct pci_de
 	case PCI_DEVICE_ID_NETMOS_9912:
 	case PCI_DEVICE_ID_NETMOS_9922:
 	case PCI_DEVICE_ID_NETMOS_9900:
+	case PCIE_DEVICE_ID_AX99100:
 		num_serial = pci_netmos_9900_numports(dev);
 		break;
 
@@ -2416,6 +2421,14 @@ static struct pci_serial_quirk pci_seria
 		.init		= pci_netmos_init,
 		.setup		= pci_netmos_9900_setup,
 	},
+	{
+		.vendor		= PCIE_VENDOR_ID_ASIX,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_netmos_init,
+		.setup		= pci_netmos_9900_setup,
+	},
 	/*
 	 * EndRun Technologies
 	*/
@@ -5960,6 +5973,10 @@ static const struct pci_device_id serial
 		0xA000, 0x3002,
 		0, 0, pbn_NETMOS9900_2s_115200 },
 
+	{	PCIE_VENDOR_ID_ASIX, PCIE_DEVICE_ID_AX99100,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
 	/*
 	 * Best Connectivity and Rosewill PCI Multi I/O cards
 	 */


