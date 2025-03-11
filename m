Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350DF1C3BEB;
	Tue, 11 Mar 2025 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705967; cv=none; b=V+kBRyt6yQx2uzzhc4x3dYmbo3hHzxsrvYaxJEgDJsvgNFL8wPqNKp2eNxIO0pPLsCFtzIKY3Yr8jwUVxIaniIEQH0DyAJlgOByh4dij0gEcQ8Wof69gCbWQkF9PwvdIwJTF1oaqpJR+h0ev+yaRF9qIJY9r7FAI0P1+qoqkNp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705967; c=relaxed/simple;
	bh=fuHgTMvEz2EuoyclTWwOB9c6RZb0DzPWRcOOmVRyHec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0vnHnQDDeypFmKizYUx0koJvspHWA0fQ4d5keTKsLTCTb509Wut2VSCp/7EbF90mQVlIXkz5E8Jg936kKPUMw+XlF4sMWa2Isp0Ga0dAox718fJbfs5Y6lybCQuvP30TfEAtO53LL7t5WIgDyC2vieIjJJE3MTUd/d4B5luJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3T16sVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3T16sVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B218EC4CEE9;
	Tue, 11 Mar 2025 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705967;
	bh=fuHgTMvEz2EuoyclTWwOB9c6RZb0DzPWRcOOmVRyHec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3T16sVEixBtDvCDPuNrL5/9djWiVQLtBCCmcrBD622gpv0rWEkniNBdEBCAdGbga
	 PQcqNcldAHBQ4ksFQqyhhU/sz3tmfazqgtbcgdaUu6Cc2DjK7i8HoaGIQ1YtrhOFO5
	 83HT8KlHhs6QKVqr9kOkSpjmHydS1xdW9rnmW7HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.4 217/328] serial: 8250_pci: add support for ASIX AX99100
Date: Tue, 11 Mar 2025 15:59:47 +0100
Message-ID: <20250311145723.528874819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,6 +67,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9922,
 			 0xA000, 0x1000) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
 			 PCI_ANY_ID, PCI_ANY_ID) },
 	{ }
@@ -5757,6 +5759,14 @@ static const struct pci_device_id serial
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


