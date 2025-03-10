Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66178234970;
	Mon, 10 Mar 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630505; cv=none; b=fAgJe0neQpL70hDpt1NnxjetjBK0ndL5ouPTaVH/58qM89Sxo/Cp+81vP2UFm7G2pW9MaVxHfenENsJ4hSUa6HLPPbmd9ywpgYoRp1Ih1xb2sKZO+6czRi2JOxJ/jz5llpuxqhzJgxegqC8DbR/PixXDEcn4t2m2U8uMD8K3Xy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630505; c=relaxed/simple;
	bh=oJ/EPyCjlpyKBTGZnscEkod+7N1qufgiqGI0apkkpWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCmfMt3gTltb0kmmTOOZSgtgEQlTt9kdwUSC81I22BIxIEUQrKN/YzJFB5NktbLH8GQWt9zP5LXlqptY3u1i7PBG/9GKmvhkB82QFr48WD0hN6kY5iQsBW7hNLfGaaaWUm9bZoTfRwJYCT8LEPXtC9cgoeosedkKFupphwulyLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awJ6iAH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awJ6iAH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E477DC4CEE5;
	Mon, 10 Mar 2025 18:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630505;
	bh=oJ/EPyCjlpyKBTGZnscEkod+7N1qufgiqGI0apkkpWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awJ6iAH/N6s2IZdW8fG0XdOSmvV2a/uOjk9bv3hzR6aFu8NcOW9G+1GBFRL/U6Zrq
	 tvpi4f35N4fByrEWKwH1/qQz2fAQGiJco3OTWe8xRVJDGIDi5/CHsFiBhL7BvnuLmf
	 8zaWjzbUNSj7xii10Ft9TcJtRAIU82mvC7rvbnBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.15 420/620] serial: 8250_pci: add support for ASIX AX99100
Date: Mon, 10 Mar 2025 18:04:26 +0100
Message-ID: <20250310170602.165665210@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

commit 0b32216557ce3b2a468d1282d99b428bf72ff532 upstream.

Each of the 4 PCI functions on ASIX AX99100 PCIe to Multi I/O
Controller can be configured as a single-port serial port controller.
The subvendor id is 0x1000 when configured as serial port and MSI
interrupts are supported.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230724083933.3173513-4-jiaqing.zhao@linux.intel.com
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -66,6 +66,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9922,
 			 0xA000, 0x1000) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
 			 PCI_ANY_ID, PCI_ANY_ID) },
 	{ }
@@ -6299,6 +6301,14 @@ static const struct pci_device_id serial
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 		0xA000, 0x3004,
 		0, 0, pbn_b0_bt_4_115200 },
+
+	/*
+	 * ASIX AX99100 PCIe to Multi I/O Controller
+	 */
+	{	PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
 	/* Intel CE4100 */
 	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100_UART,
 		PCI_ANY_ID,  PCI_ANY_ID, 0, 0,


