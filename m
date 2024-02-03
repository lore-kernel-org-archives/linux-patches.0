Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64254210E2;
	Sat,  3 Feb 2024 04:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933927; cv=none; b=n9XO7Y8DSAMiLFNK6zxsB/g+vIXPThnPzEep0Ys/3zQ4nw9qfxL1vcdb78UscXZGu7OcMk8nPf0XbLtf5MVw2N8Mo2ud2JR2NBCrdXZwA0xOjWCg/K4I7BvtRDdDK8u/jkXX8jXt7GifiF4+U815bh8T7ahauHn13T1z2a8Jg6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933927; c=relaxed/simple;
	bh=MEMWWicxXwVQwNBqm7/uIIj9jfjCPGETMsjMuQ6tTIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGp+3Qvfk5HO7kB/eFvRMy9Wyv1MFFHGgCw60xf4LAXLJXKdT2uJDsgSRdni1EAx5Fq9LPgAzDrvTj7RQ541TL239jvivMVM3S001lXFjsedtuQGsRTV29bmj9cdDJHdO22QWu0nPGzo6bWXwceKua9S+zceQpvHzEFbSJ+8f04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAxVJBc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAxVJBc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25586C433F1;
	Sat,  3 Feb 2024 04:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933927;
	bh=MEMWWicxXwVQwNBqm7/uIIj9jfjCPGETMsjMuQ6tTIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAxVJBc0IbJdfVagALws+Q12tLNJSs/jYkiwJ6gOeipwgtyxRHPk/YntsU7+FZtIM
	 WtUVCcKy2cvKh3Sg8qglQ4nm/2IoDv71CvLdUzYHoxI7067WqSJI8UYO41WsbfyYmY
	 0jtU212Rx3eIhy+8zs6WDaeaa/owGovtTjUSaphA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crescent CY Hsieh <crescentcy.hsieh@moxa.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 259/353] tty: serial: 8250: Set RS422 interface by default to fix Moxa RS422/RS485 PCIe boards
Date: Fri,  2 Feb 2024 20:06:17 -0800
Message-ID: <20240203035411.941429171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crescent CY Hsieh <crescentcy.hsieh@moxa.com>

[ Upstream commit 43f012df3c1e979966524f79b5371fde6545488a ]

MOXA PCIe RS422/RS485 boards will not function by default because of the
initial default serial interface of all MOXA PCIe boards is set to
RS232.

This patch fixes the problem above by setting the initial default serial
interface to RS422 for those MOXA RS422/RS485 PCIe boards.

Signed-off-by: Crescent CY Hsieh <crescentcy.hsieh@moxa.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20231214060234.6147-1-crescentcy.hsieh@moxa.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 58 +++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 614be0f13a31..8ccf691935b7 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -19,6 +19,7 @@
 #include <linux/serial_core.h>
 #include <linux/8250_pci.h>
 #include <linux/bitops.h>
+#include <linux/bitfield.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -1970,6 +1971,20 @@ pci_sunix_setup(struct serial_private *priv,
 
 #define MOXA_GPIO_PIN2	BIT(2)
 
+#define MOXA_RS232	0x00
+#define MOXA_RS422	0x01
+#define MOXA_RS485_4W	0x0B
+#define MOXA_RS485_2W	0x0F
+#define MOXA_UIR_OFFSET	0x04
+#define MOXA_EVEN_RS_MASK	GENMASK(3, 0)
+#define MOXA_ODD_RS_MASK	GENMASK(7, 4)
+
+enum {
+	MOXA_SUPP_RS232 = BIT(0),
+	MOXA_SUPP_RS422 = BIT(1),
+	MOXA_SUPP_RS485 = BIT(2),
+};
+
 static bool pci_moxa_is_mini_pcie(unsigned short device)
 {
 	if (device == PCI_DEVICE_ID_MOXA_CP102N	||
@@ -1983,13 +1998,54 @@ static bool pci_moxa_is_mini_pcie(unsigned short device)
 	return false;
 }
 
+static unsigned int pci_moxa_supported_rs(struct pci_dev *dev)
+{
+	switch (dev->device & 0x0F00) {
+	case 0x0000:
+	case 0x0600:
+		return MOXA_SUPP_RS232;
+	case 0x0100:
+		return MOXA_SUPP_RS232 | MOXA_SUPP_RS422 | MOXA_SUPP_RS485;
+	case 0x0300:
+		return MOXA_SUPP_RS422 | MOXA_SUPP_RS485;
+	}
+	return 0;
+}
+
+static int pci_moxa_set_interface(const struct pci_dev *dev,
+				  unsigned int port_idx,
+				  u8 mode)
+{
+	resource_size_t iobar_addr = pci_resource_start(dev, 2);
+	resource_size_t UIR_addr = iobar_addr + MOXA_UIR_OFFSET + port_idx / 2;
+	u8 val;
+
+	val = inb(UIR_addr);
+
+	if (port_idx % 2) {
+		val &= ~MOXA_ODD_RS_MASK;
+		val |= FIELD_PREP(MOXA_ODD_RS_MASK, mode);
+	} else {
+		val &= ~MOXA_EVEN_RS_MASK;
+		val |= FIELD_PREP(MOXA_EVEN_RS_MASK, mode);
+	}
+	outb(val, UIR_addr);
+
+	return 0;
+}
+
 static int pci_moxa_init(struct pci_dev *dev)
 {
 	unsigned short device = dev->device;
 	resource_size_t iobar_addr = pci_resource_start(dev, 2);
-	unsigned int num_ports = (device & 0x00F0) >> 4;
+	unsigned int num_ports = (device & 0x00F0) >> 4, i;
 	u8 val;
 
+	if (!(pci_moxa_supported_rs(dev) & MOXA_SUPP_RS232)) {
+		for (i = 0; i < num_ports; ++i)
+			pci_moxa_set_interface(dev, i, MOXA_RS422);
+	}
+
 	/*
 	 * Enable hardware buffer to prevent break signal output when system boots up.
 	 * This hardware buffer is only supported on Mini PCIe series.
-- 
2.43.0



