Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597F1313298;
	Mon, 13 Apr 2026 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099024; cv=none; b=NCFcBMVyWXFJu7rJs/Wg0Oaxut2XapUcH9D1c4ORTAr4fxbkf4T1QCdMBiXjeLqW1ZD5jbaOjOKLL4qGvOlSsYuBlCjYzXmNAgO1jL1ZLJCY04lNrbXJV/kSVQVp3/+9e3y8P89RRc+HK44wWq3aHsOLIVyVGEblHnpK88NyltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099024; c=relaxed/simple;
	bh=huA7cD5OIPO9yJbbNjduiutH/PevPw64ADY7+XNl+mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9O04tvzzzPaUHq5d3gaEt2ZbwKAKOFI4zvJ/d7bSUScirF8tMmbyJErS3fczL++WbzQ2UbO40EXEmwOH11bFkQPebERY5xJ1c1BU1/eB0G638uuVsi8Wy8u+88lSoxTSwl4ywNSKxLEyEqBUBr0mI19tT6+IMr70wpHFQxudHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz3nIYsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz3nIYsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37CBC2BCAF;
	Mon, 13 Apr 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099024;
	bh=huA7cD5OIPO9yJbbNjduiutH/PevPw64ADY7+XNl+mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz3nIYsAY/7bIznQdH+Jf0zqCBCYcQ9ykGSvTbmPDqv19pPkKsaTg1/Shkk5ei9s2
	 h2rFOkdAaiYjZc/YtBikykjXcc9oMCyWH9XHwvhTehhSf99KR+SEEVcXIvxPJm/Rwu
	 mPtl8FDBLfhanXD/z6ImNBIVN25UCv7mZaVYCpBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Roukala=20 ?= <martin.roukala@mupuf.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 148/491] serial: 8250_pci: add support for the AX99100
Date: Mon, 13 Apr 2026 17:56:33 +0200
Message-ID: <20260413155824.574435300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -57,6 +57,8 @@ struct serial_private {
 };
 
 #define PCI_DEVICE_ID_HPE_PCI_SERIAL	0x37e
+#define PCIE_VENDOR_ID_ASIX		0x125B
+#define PCIE_DEVICE_ID_AX99100		0x9100
 
 static const struct pci_device_id pci_use_msi[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9900,
@@ -69,6 +71,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
 			 PCI_ANY_ID, PCI_ANY_ID) },
+	{ PCI_DEVICE_SUB(PCIE_VENDOR_ID_ASIX, PCIE_DEVICE_ID_AX99100,
+			 0xA000, 0x1000) },
 	{ }
 };
 
@@ -853,6 +857,7 @@ static int pci_netmos_init(struct pci_de
 	case PCI_DEVICE_ID_NETMOS_9912:
 	case PCI_DEVICE_ID_NETMOS_9922:
 	case PCI_DEVICE_ID_NETMOS_9900:
+	case PCIE_DEVICE_ID_AX99100:
 		num_serial = pci_netmos_9900_numports(dev);
 		break;
 
@@ -2480,6 +2485,14 @@ static struct pci_serial_quirk pci_seria
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
@@ -5825,6 +5838,10 @@ static const struct pci_device_id serial
 		0xA000, 0x3002,
 		0, 0, pbn_NETMOS9900_2s_115200 },
 
+	{	PCIE_VENDOR_ID_ASIX, PCIE_DEVICE_ID_AX99100,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
 	/*
 	 * Best Connectivity and Rosewill PCI Multi I/O cards
 	 */


