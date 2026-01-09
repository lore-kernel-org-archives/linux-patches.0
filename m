Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB05359F80;
	Fri,  9 Jan 2026 11:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959339; cv=none; b=CGU/fk01tTn43vUPJhog0/L6WFZPbSzo+17CEhF42U5eI1/1ZMrB2YMZPhgUv1ir/FApPkxVCiOdkCbn1t8xP37j6d6BBU4NPGaw3kwHEzUj0614lNohH1XYnniFCZOp8sFZbOkGqNWqLfxhlBVIFDdRsMWZsnx7lNeXuOiza+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959339; c=relaxed/simple;
	bh=i9iew5YSd3sklqa4E2h/VfVwh24ebRfZRC0ltKzD9s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+qynKx+0kTCoOO+QtquWSaNJ3Vt7wW2e3pqdm4Ykv31c+tyYOWt5cX3vfcWcpgrN4CUiXJTzNWHr48kOlVgMJf7Hav0EXbduq5IS8GrwZRQGuW3vp3NmKAgz6Iulm8FwgrOQKTacBr8eyMST6OC/+z1dBxzEd1asavhOyrRg8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6dzacnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6dzacnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC94C16AAE;
	Fri,  9 Jan 2026 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959339;
	bh=i9iew5YSd3sklqa4E2h/VfVwh24ebRfZRC0ltKzD9s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6dzacnA3cc9HchjNXFRfdWj0KSzOfAPn8Mzi+ZMIeKTYtHym6FG/iZ+l5kYOBuxN
	 /jFhF8I97fR8IOHRf4MxFZlI6m0t/SMyqnq7Yj3ds5dG4Wpdf+83sp8ffUJ8tQ2buj
	 EzxKqMypboqLhKfrOgn6j+xyDDew8f/Z4k/Y/sL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magne Bruno <magne.bruno@addi-data.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 018/737] serial: add support of CPCI cards
Date: Fri,  9 Jan 2026 12:32:37 +0100
Message-ID: <20260109112134.680365950@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1971,6 +1971,11 @@ pci_moxa_setup(struct serial_private *pr
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
@@ -5868,6 +5873,38 @@ static const struct pci_device_id serial
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


