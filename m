Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95692C3268;
	Thu, 15 Jan 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497583; cv=none; b=W8qBUtplZIUe0C8fpFL9oCW8UJp8Df8AMSU4P1I+2A2SWnuqbYv5g5ZIKyD4Pm5u4JGW2eG0e3SzDD2BfWnc5KiOF6aQU5cCdYWNp9QM2a/XLXzyVdP/0jAqdHTt5D2EM4siRcfTnqogJ1HZUk/1CCp7NUXMDVpRC7+GEEgcyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497583; c=relaxed/simple;
	bh=3E4dRfmuHL5i+b6n83abAoEB+CDQOpzDl4gpN1NSG7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFxu6Zb3CiHzt3NkX8Qk7kanR7hWm1zqSEeIGnzb0uzcIOtFQgSVjrTWZANdq24ecaFDadWG8KyRKMp6SvduZVNmaeAIko6Cdnly69I9xt4KexY4QZbSUGXeOZWFk1WDZ3vZYWSl0iNEBmbP6v0nFkTC6oWQ5QHMwgOZoJPN6Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS5J7fzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS5J7fzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E6FC116D0;
	Thu, 15 Jan 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497583;
	bh=3E4dRfmuHL5i+b6n83abAoEB+CDQOpzDl4gpN1NSG7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS5J7fzI2MkK9u6wawleL1bODo8EuI0LqHtuQmnUH5cHkWuacUqoMQGy7R6f02tmF
	 yoFWIWBXrSo7QFL7r93exG5uaO2i5aD1w5+ohDVVdacMbWAOsl7NMZaz6W1zi4DnP/
	 cG1ghgZSQeVsBVmQPjWcb6UyhU2P0iYq6hV7KcCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/554] soc: renesas: r9a06g032-sysctrl: Handle h2mode setting based on USBF presence
Date: Thu, 15 Jan 2026 17:42:45 +0100
Message-ID: <20260115164249.829893367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f42d46ce6192..e46280059db79 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -24,6 +24,8 @@
 #include <linux/spinlock.h>
 #include <dt-bindings/clock/r9a06g032-sysctrl.h>
 
+#define R9A06G032_SYSCTRL_USB    0x00
+#define R9A06G032_SYSCTRL_USB_H2MODE  (1<<1)
 #define R9A06G032_SYSCTRL_DMAMUX 0xA0
 
 struct r9a06g032_gate {
@@ -919,6 +921,29 @@ static void r9a06g032_clocks_del_clk_provider(void *data)
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
@@ -948,6 +973,9 @@ static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
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



