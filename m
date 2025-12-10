Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C041DD0EF;
	Wed, 10 Dec 2025 07:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351929; cv=none; b=uThSkZmbJUvzZKGx8MTL1PiH7lJIo+SMTiBcPkjjrVnei3UcCW1iQzQgz+MqLvY+/30kPT+SnDEp7+gxM1z9rpOy0W5Wx3ygQ3Mevbu7Gz76ORFF+N69wbFF7rasFYTvoShKClN6xcVW7UMd/IrFA7UminI1ld51ZUZ9WgaBZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351929; c=relaxed/simple;
	bh=3qKBrTsbqmmF3AezLJLnkICD9dnAtv36qbR8U7PV/Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmnUws1KVj/bzoIwdZ87OCOFRMZGO2rTD6s940suPhv6+c23frVW54Yo+IDtDEdN5bVu2ZL5LlMmiTXkTqRsXHYj6DIxVQUAAtv9J1Zsr3M5gTYyFiQIk4+9acqB8I1cylXW9KsArxZVO8/nE6NBoHaODFmNWUVOUYyv+L+7MnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYlMcGnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYlMcGnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23B3C4CEF1;
	Wed, 10 Dec 2025 07:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351929;
	bh=3qKBrTsbqmmF3AezLJLnkICD9dnAtv36qbR8U7PV/Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYlMcGnbGpT9Td9VfYHJnj4+709XoGWCgN2HPz+f6aSN8uuc3RJtcue8ByPALTh9p
	 8rKwy2dS6rWwAmCQa1UPJeGVOQ5k1qYJtdU1JqCk3aWkICmzgdXMeRDQrn6+8ClMTJ
	 Jun5JmcnMay3Yaz/rOWkv6f6noC7n1VynD5qI5BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magne Bruno <magne.bruno@addi-data.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 17/49] serial: add support of CPCI cards
Date: Wed, 10 Dec 2025 16:29:47 +0900
Message-ID: <20251210072948.552426333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,6 +95,11 @@
 #define PCI_DEVICE_ID_MOXA_CP138E_A	0x1381
 #define PCI_DEVICE_ID_MOXA_CP168EL_A	0x1683
 
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7500        0x7003
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7500_NG     0x7024
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7420_NG     0x7025
+#define PCI_DEVICE_ID_ADDIDATA_CPCI7300_NG     0x7026
+
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1588	0x1588
@@ -5956,6 +5961,38 @@ static const struct pci_device_id serial
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


