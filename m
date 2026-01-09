Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F9F35B153;
	Fri,  9 Jan 2026 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961800; cv=none; b=sWaxGySdKMf0N6xAzNDFgeLAbJuGyLx+cs+KQ2LNKXNKJ8w4LUa9zNKWpcsBt61Eu9pAaON5EcRqaA39Tuby2SptF8pkzhPegNc98a5kgqhMr4rzGAZBAiwgGphePDb/RdLkYTaiIAVq4spZ/Td/dx/fYSUn+EQYTE8Git+icGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961800; c=relaxed/simple;
	bh=F41EzkFY3/wE0GOEjXoo2n6raNlOMtO+HG0PWOC4N2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxye/c8n4yek9OnQX0MC0JJDXjH9sJR+9ri1SWHX6V9NzT/ypTLA69yq7dO7ePnTzGnwK3Jj/GXBXKrk5IyRRZVKw6q7aYh2mgTwCKtRIYw4TNuDcdILSMYvlkRMf6XmShDPJhgmVpwK++2dapq3+TpvN5wfYdzZGt3WCqh0QEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peZB6sKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peZB6sKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA57C19423;
	Fri,  9 Jan 2026 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961799;
	bh=F41EzkFY3/wE0GOEjXoo2n6raNlOMtO+HG0PWOC4N2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peZB6sKkG2qCM/Ch7/L+8Ck7OEc8QE7kPEJH3uSWszqaLSAD5YdFE0bbPWOcRAO4z
	 kRcI3GQpAlflDUoESn0vgPfm+1KDgNQX8STp78kj8tNsQmtkwEmqYd5sdRCWpk/Bdb
	 cyDIXela5Ve6sA3jOMIb6XfT8uHDF4DZ07INjnO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/634] soc: renesas: r9a06g032-sysctrl: Handle h2mode setting based on USBF presence
Date: Fri,  9 Jan 2026 12:36:25 +0100
Message-ID: <20260109112121.460660311@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit e9fee814b054e4f6f2faf3d9c1944869fe41c9dd ]

The CFG_USB[H2MODE] allows to switch the USB configuration. The
configuration supported are:
  - One host and one device
or
  - Two hosts

Set CFG_USB[H2MODE] based on the USBF controller (USB device)
availability.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230105152257.310642-3-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f8def051bbcf ("clk: renesas: r9a06g032: Fix memory leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index 983faa5707b9c..087146f2ee068 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -25,6 +25,8 @@
 #include <linux/spinlock.h>
 #include <dt-bindings/clock/r9a06g032-sysctrl.h>
 
+#define R9A06G032_SYSCTRL_USB    0x00
+#define R9A06G032_SYSCTRL_USB_H2MODE  (1<<1)
 #define R9A06G032_SYSCTRL_DMAMUX 0xA0
 
 struct r9a06g032_gate {
@@ -918,6 +920,29 @@ static void r9a06g032_clocks_del_clk_provider(void *data)
 	of_clk_del_provider(data);
 }
 
+static void __init r9a06g032_init_h2mode(struct r9a06g032_priv *clocks)
+{
+	struct device_node *usbf_np = NULL;
+	u32 usb;
+
+	while ((usbf_np = of_find_compatible_node(usbf_np, NULL,
+						  "renesas,rzn1-usbf"))) {
+		if (of_device_is_available(usbf_np))
+			break;
+	}
+
+	usb = readl(clocks->reg + R9A06G032_SYSCTRL_USB);
+	if (usbf_np) {
+		/* 1 host and 1 device mode */
+		usb &= ~R9A06G032_SYSCTRL_USB_H2MODE;
+		of_node_put(usbf_np);
+	} else {
+		/* 2 hosts mode */
+		usb |= R9A06G032_SYSCTRL_USB_H2MODE;
+	}
+	writel(usb, clocks->reg + R9A06G032_SYSCTRL_USB);
+}
+
 static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -947,6 +972,9 @@ static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
 	clocks->reg = of_iomap(np, 0);
 	if (WARN_ON(!clocks->reg))
 		return -ENOMEM;
+
+	r9a06g032_init_h2mode(clocks);
+
 	for (i = 0; i < ARRAY_SIZE(r9a06g032_clocks); ++i) {
 		const struct r9a06g032_clkdesc *d = &r9a06g032_clocks[i];
 		const char *parent_name = d->source ?
-- 
2.51.0



