Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8DE2EA74F;
	Tue, 22 Jul 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192617; cv=none; b=DTATqPSXqJiexuXcM9b3Bw1hPQTCstrTEjjRnYxnKJP3oSObERyCuFhQQTRtnMSaLixzEZwM0erPwV9IDmuGixB1eqdXqoiXSfcxCEcUBAQVjNr+qaoZNRJhjN6XGXHh5HNj1flEwSOYvHBsC46catehZNZejM40g9oVvI2epZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192617; c=relaxed/simple;
	bh=rUMg/qzBrBMQ2l2Uu5btHzMSDvdgDpX+fFh2RYGyug4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1F2FdGpLdYDW5PXJEk3TOaxgkXKQk8r89fOzibw9zTchfQiDcRs6FqB5HctLpqHjJJoLV8HzTXNqDMYTe78IppGwvVhm3jCgd6S+bsI7eDm7OEgkda7X+8FpO7xEhwEu7kNCC7mIGeobjllx/ET+YjMHyT33TWmVt8k9fsWB0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWzEjXqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWzEjXqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A4DC4CEEB;
	Tue, 22 Jul 2025 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192617;
	bh=rUMg/qzBrBMQ2l2Uu5btHzMSDvdgDpX+fFh2RYGyug4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWzEjXqsV7+cscFhDHPTswoTLMpw2C6Uv1pBeycWNxQnd+cnSY5fy6eJiMCEst3oq
	 TjGr45xjFzttbQ6RDoyM06AJkdIlTOMbXPPhRtHNJwwFXLhsokkaEBxnsi3k1nuLGM
	 DLeQLf5QfYbPlGygamjsSP13CE+Cgl/S7qgdHahE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/111] i2c: omap: Add support for setting mux
Date: Tue, 22 Jul 2025 15:45:17 +0200
Message-ID: <20250722134337.214492819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

commit b6ef830c60b6f4adfb72d0780b4363df3a1feb9c upstream.

Some SoCs require muxes in the routing for SDA and SCL lines.
Therefore, add support for setting the mux by reading the mux-states
property from the dt-node.

Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20250318103622.29979-3-j-choudhary@ti.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: a9503a2ecd95 ("i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/Kconfig    |    1 +
 drivers/i2c/busses/i2c-omap.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -899,6 +899,7 @@ config I2C_OMAP
 	tristate "OMAP I2C adapter"
 	depends on ARCH_OMAP || ARCH_K3 || COMPILE_TEST
 	default MACH_OMAP_OSK
+	select MULTIPLEXER
 	help
 	  If you say yes to this option, support will be included for the
 	  I2C interface on the Texas Instruments OMAP1/2 family of processors.
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/mux/consumer.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
@@ -211,6 +212,7 @@ struct omap_i2c_dev {
 	u16			syscstate;
 	u16			westate;
 	u16			errata;
+	struct mux_state	*mux_state;
 };
 
 static const u8 reg_map_ip_v1[] = {
@@ -1455,6 +1457,23 @@ omap_i2c_probe(struct platform_device *p
 				       (1000 * omap->speed / 8);
 	}
 
+	if (of_property_read_bool(node, "mux-states")) {
+		struct mux_state *mux_state;
+
+		mux_state = devm_mux_state_get(&pdev->dev, NULL);
+		if (IS_ERR(mux_state)) {
+			r = PTR_ERR(mux_state);
+			dev_dbg(&pdev->dev, "failed to get I2C mux: %d\n", r);
+			goto err_disable_pm;
+		}
+		omap->mux_state = mux_state;
+		r = mux_state_select(omap->mux_state);
+		if (r) {
+			dev_err(&pdev->dev, "failed to select I2C mux: %d\n", r);
+			goto err_disable_pm;
+		}
+	}
+
 	/* reset ASAP, clearing any IRQs */
 	omap_i2c_init(omap);
 
@@ -1514,6 +1533,9 @@ static void omap_i2c_remove(struct platf
 
 	i2c_del_adapter(&omap->adapter);
 
+	if (omap->mux_state)
+		mux_state_deselect(omap->mux_state);
+
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
 		dev_err(omap->dev, "Failed to resume hardware, skip disable\n");


