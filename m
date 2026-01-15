Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAB22D663D;
	Thu, 15 Jan 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498989; cv=none; b=XCJl1H6EBjMnxBkrPa6OujD737TMEQOgvCEDVKGB69yscptPP5m/b2XfAZfbt1yHIIvBVEmlJuYHx9NPz3KwoSglRtJVwdGbltNNiJJv7lCWyfmyOiqTk7XcrJyi0gLeNNjP1fe25+WnBq7yzjkFKpPfVbAWPHpxZSfjKHzHJlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498989; c=relaxed/simple;
	bh=A2jjWtmdHFiuguLbxR9vtuU9uo5JppkVwhzbzrqXN58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1hY++vGI76GGs5vdIZOqdxplM03FSummc4zRgp+b5YQa8GFVBDFEWcKqB4nZK7qvG/tWTTyuAqho/LZZKijf4K6bLaeEqXMfosweGm5qq/cKRDv6RXyfsX/XyhxWwTGGp6vPGF51yfm0kE6Q3MFWwg3wVN44mxbNti1UoSl1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezqqqey2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezqqqey2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46622C116D0;
	Thu, 15 Jan 2026 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498989;
	bh=A2jjWtmdHFiuguLbxR9vtuU9uo5JppkVwhzbzrqXN58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezqqqey20sUeXDZJz0GstnEq3q3Ntr4o1apWS2GZUbGfKco0nnsQSBsUZqNmpnc+m
	 kCtC2HLracczS3E6RnjVMsi6cwx+NOTVRIamZ9okMiQtJBtJ0UOr+ASBnByyQhPqjF
	 zLWCaNHrUP2FEBE8tPT8KrT0ICqmZx7q4emD4NpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/451] soc: renesas: r9a06g032-sysctrl: Handle h2mode setting based on USBF presence
Date: Thu, 15 Jan 2026 17:44:31 +0100
Message-ID: <20260115164233.433554572@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65cd6ed68923e..b3fd97615fc4c 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -24,6 +24,8 @@
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



