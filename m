Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390B0611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FFFC433EF;
	Sun, 28 May 2023 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303099;
	bh=taUhqejIajZBYqBYH5lK+AHgGO7c1EbYnxrwxTOgLNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erW25Cz7+gyWuUkHY4OnedaFEy7hUkyX+Hsu/Q5Wpi8dFMYWW38qHmLNsUp+cUvO2
	 KLeVNgNJcBCn1bmEr9Ju9GfOL7FzHqRkVRCHo0lZBX2lLs77bCCkGxfR9XaJ4fU6Rf
	 9YZyxJlh81pG+EkAKR+HkH7LyVA8AMGbe1sBFKcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/211] serial: 8250_exar: derive nr_ports from PCI ID for Acces I/O cards
Date: Sun, 28 May 2023 20:11:15 +0100
Message-Id: <20230528190847.336255796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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
Stable-dep-of: 95d698869b40 ("serial: 8250_exar: Add support for USR298x PCI Modems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 37 ++++++++++-------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 2d0e7c7e408dc..3d82902bfe5b9 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -596,7 +596,12 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
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
@@ -695,22 +700,6 @@ static int __maybe_unused exar_resume(struct device *dev)
 
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
@@ -795,13 +784,13 @@ static const struct exar8250_board pbn_exar_XR17V8358 = {
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



