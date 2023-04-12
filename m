Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D482F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC979C433D2;
	Wed, 12 Apr 2023 08:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288648;
	bh=q9rItHT/DZ16yQ1ZWUIpHFXvtL31QCYC7fj4bgJ7cu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7vWgo9bcPHi74XtgT88lV645CjkOCRhT7/LvxuBuvu0Xd2wBWiGsyt9GjI+bw4g9
	 zXZB4aJ8oRx+T8T6GKA9d4pa24a9uy4PTDCK/3VlY4/I9ihNZG9ghqxSiAQl3COBZi
	 edzC0Rnm+u9x1WSuB+AxwKyHyO/NXdELPma3yVlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/93] serial: 8250_exar: derive nr_ports from PCI ID for Acces I/O cards
Date: Wed, 12 Apr 2023 10:33:19 +0200
Message-Id: <20230412082823.820999875@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 8e4413aaf6a2e3a46e99a0718ca54c0cf8609cb2 ]

In the similar way how it's done in 8250_pericom, derive the number of
the UART ports from PCI ID for Acces I/O cards.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220127180608.71509-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 14ee78d5932a ("serial: exar: Add support for Sealevel 7xxxC serial cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 37 ++++++++++-------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index d502240bbcf23..7292917ac8784 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -623,7 +623,12 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	maxnr = pci_resource_len(pcidev, bar) >> (board->reg_shift + 3);
 
-	nr_ports = board->num_ports ? board->num_ports : pcidev->device & 0x0f;
+	if (pcidev->vendor == PCI_VENDOR_ID_ACCESSIO)
+		nr_ports = BIT(((pcidev->device & 0x38) >> 3) - 1);
+	else if (board->num_ports)
+		nr_ports = board->num_ports;
+	else
+		nr_ports = pcidev->device & 0x0f;
 
 	priv = devm_kzalloc(&pcidev->dev, struct_size(priv, line, nr_ports), GFP_KERNEL);
 	if (!priv)
@@ -722,22 +727,6 @@ static int __maybe_unused exar_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(exar_pci_pm, exar_suspend, exar_resume);
 
-static const struct exar8250_board acces_com_2x = {
-	.num_ports	= 2,
-	.setup		= pci_xr17c154_setup,
-};
-
-static const struct exar8250_board acces_com_4x = {
-	.num_ports	= 4,
-	.setup		= pci_xr17c154_setup,
-};
-
-static const struct exar8250_board acces_com_8x = {
-	.num_ports	= 8,
-	.setup		= pci_xr17c154_setup,
-};
-
-
 static const struct exar8250_board pbn_fastcom335_2 = {
 	.num_ports	= 2,
 	.setup		= pci_fastcom335_setup,
@@ -822,13 +811,13 @@ static const struct exar8250_board pbn_exar_XR17V8358 = {
 	}
 
 static const struct pci_device_id exar_pci_tbl[] = {
-	EXAR_DEVICE(ACCESSIO, COM_2S, acces_com_2x),
-	EXAR_DEVICE(ACCESSIO, COM_4S, acces_com_4x),
-	EXAR_DEVICE(ACCESSIO, COM_8S, acces_com_8x),
-	EXAR_DEVICE(ACCESSIO, COM232_8, acces_com_8x),
-	EXAR_DEVICE(ACCESSIO, COM_2SM, acces_com_2x),
-	EXAR_DEVICE(ACCESSIO, COM_4SM, acces_com_4x),
-	EXAR_DEVICE(ACCESSIO, COM_8SM, acces_com_8x),
+	EXAR_DEVICE(ACCESSIO, COM_2S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_4S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_8S, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM232_8, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_2SM, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_4SM, pbn_exar_XR17C15x),
+	EXAR_DEVICE(ACCESSIO, COM_8SM, pbn_exar_XR17C15x),
 
 	CONNECT_DEVICE(XR17C152, UART_2_232, pbn_connect),
 	CONNECT_DEVICE(XR17C154, UART_4_232, pbn_connect),
-- 
2.39.2



