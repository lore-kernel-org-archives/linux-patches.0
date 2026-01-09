Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D20B2EC54D;
	Fri,  9 Jan 2026 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961446; cv=none; b=kuoXrO3wz3XGUPkPPeYxyeaTGlNzllKFAzsHgJtt8btqacS92T7NnHBQaXVTZJx4k6EAWgqYRscAf8ZhdDUwLE8Kns/AILtlTBMEjT8BJAx3uqzEmXdbJ6Ncd1+NCnvIHtale6A1a6z4Ia7mnKKAYBM2rsE8Rm5NCBnJnUOoNhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961446; c=relaxed/simple;
	bh=+AH98aI3wTQkH60K0haPhqRdc1SF0Bm3jxkjDSBI3qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLWeDN9HNsVlD0CMCCualnRQPHDsKdefNlDkhBaW/U1Q9wGA1mZubBycKTqyKplmJxrXco83aLtwgpQF5jxXrW/3/Y4RmPbONF5cIKGeOXSl3COmoQDP8MqhajFMVyr+ST9WaMomkA4V3cbN/LP/qVjF2OsOb671rEMncp4HnXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fyv5VmfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fyv5VmfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91002C4CEF1;
	Fri,  9 Jan 2026 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961445;
	bh=+AH98aI3wTQkH60K0haPhqRdc1SF0Bm3jxkjDSBI3qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fyv5VmfXIznUPwkVjp0caNxJ5u3A3hO97xjERx3SQi5YaP1Kh8s+4L/nDramI4oRG
	 SLeO8zShTJuiYCGrRqJOsvsQHjAwVUMHoP/OnoO5gIG5I6Ue1auKGHgKUT7c5DCRQ+
	 QlQjK/W/5phaIagnJPNG5f5NHHnX4Sk+HUgP/y9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magne Bruno <magne.bruno@addi-data.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 018/634] serial: add support of CPCI cards
Date: Fri,  9 Jan 2026 12:34:56 +0100
Message-ID: <20260109112118.120664533@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magne Bruno <magne.bruno@addi-data.com>

commit 0e5a99e0e5f50353b86939ff6e424800d769c818 upstream.

Addi-Data GmbH is manufacturing multi-serial ports cards supporting CompactPCI (known as CPCI).
Those cards are identified with different DeviceIds. Those cards integrating standard UARTs
work the same way as PCI/PCIe models already supported in the serial driver.

Signed-off-by: Magne Bruno <magne.bruno@addi-data.com>
Link: https://patch.msgid.link/20251110162456.341029-1-magne.bruno@addi-data.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1991,6 +1991,11 @@ pci_moxa_setup(struct serial_private *pr
 #define	PCI_DEVICE_ID_MOXA_CP138E_A	0x1381
 #define	PCI_DEVICE_ID_MOXA_CP168EL_A	0x1683
 
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7500        0x7003
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7500_NG     0x7024
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7420_NG     0x7025
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7300_NG     0x7026
+
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1588	0x1588
@@ -5888,6 +5893,38 @@ static const struct pci_device_id serial
 		0,
 		pbn_ADDIDATA_PCIe_8_3906250 },
 
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_CPCI7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_CPCI7500_NG,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_CPCI7420_NG,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_CPCI7300_NG,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },


