Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274F2FE577;
	Mon, 13 Oct 2025 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369413; cv=none; b=prCRSnO5Xb9rvy/MYoN6UQLbxsHGHVp1GYQ9xxA6fxEumvbK5yPlHUTss4mwSzqwwra1hsAWf0ej6lW7baTC6J/ckWxQ2WKS2SasmhMgiql0IJEYXqJWgWV+EahSF+bIxauj0WePJqUXO1LYHo7cVOimylw1BlR+jlTwhgzp+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369413; c=relaxed/simple;
	bh=FafY/LUn+/ZLVKarka+5dYYzbLSUnJBhxccDNfZMhYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFd/DCQmMgI+ew8nCzyV7AQ0R4NjXWhvJDp3Y/TTM9iNVcvAHhZNl3hxo7LqSZjItCoVnaqnHZcDWkCOvzkxc1hDqB3eKJubx5PZ9kYp+J2a3gVrjM9ZuVXlZMdjd1U8oo1vAhBfdU6XXuY4S85Hl6BUlhHa8SNIvIINK50iyB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7T0Ykly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7T0Ykly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2067EC4CEE7;
	Mon, 13 Oct 2025 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369413;
	bh=FafY/LUn+/ZLVKarka+5dYYzbLSUnJBhxccDNfZMhYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7T0YklyfBRSwXLhrbnRTUjWRq/DIOv4+EPFOE2AJFSPIaOSSugu26kkPv7kIg4sB
	 3jT67xPGJCkScRzw94mJI23nJzyzBOjPrGtWIhnnzV1o2MX8p5Y9Z4/AWg9ENyFX1O
	 r+bAH+9ZKGIstVTbEShB0IFK7EOmmU91MnFCotxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 204/563] i2c: spacemit: ensure SDA is released after bus reset
Date: Mon, 13 Oct 2025 16:41:05 +0200
Message-ID: <20251013144418.676325058@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 0de61943244dec418d396633a587adca1c350b55 ]

After performing a conditional bus reset, the controller must ensure
that the SDA line is actually released.

Previously, the reset routine only performed a single check,
which could leave the bus in a locked state in some situations.

This patch introduces a loop that toggles the reset cycle and issues
a reset request up to SPACEMIT_BUS_RESET_CLK_CNT_MAX times, checking
SDA after each attempt. If SDA is released before the maximum count,
the function returns early. Otherwise, a warning is emitted.

This change improves bus recovery reliability.

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-k1.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-k1.c b/drivers/i2c/busses/i2c-k1.c
index 848dfaf634f63..6b918770e612e 100644
--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2024-2025 Troy Mitchell <troymitchell988@gmail.com>
  */
 
+#include <linux/bitfield.h>
  #include <linux/clk.h>
  #include <linux/i2c.h>
  #include <linux/iopoll.h>
@@ -26,7 +27,8 @@
 #define SPACEMIT_CR_MODE_FAST    BIT(8)		/* bus mode (master operation) */
 /* Bit 9 is reserved */
 #define SPACEMIT_CR_UR           BIT(10)	/* unit reset */
-/* Bits 11-12 are reserved */
+#define SPACEMIT_CR_RSTREQ	 BIT(11)	/* i2c bus reset request */
+/* Bit 12 is reserved */
 #define SPACEMIT_CR_SCLE         BIT(13)	/* master clock enable */
 #define SPACEMIT_CR_IUE          BIT(14)	/* unit enable */
 /* Bits 15-17 are reserved */
@@ -78,6 +80,8 @@
 					SPACEMIT_SR_ALD)
 
 #define SPACEMIT_RCR_SDA_GLITCH_NOFIX		BIT(7)		/* bypass the SDA glitch fix */
+/* the cycles of SCL during bus reset */
+#define SPACEMIT_RCR_FIELD_RST_CYC		GENMASK(3, 0)
 
 /* SPACEMIT_IBMR register fields */
 #define SPACEMIT_BMR_SDA         BIT(0)		/* SDA line level */
@@ -91,6 +95,8 @@
 
 #define SPACEMIT_SR_ERR	(SPACEMIT_SR_BED | SPACEMIT_SR_RXOV | SPACEMIT_SR_ALD)
 
+#define SPACEMIT_BUS_RESET_CLK_CNT_MAX		9
+
 enum spacemit_i2c_state {
 	SPACEMIT_STATE_IDLE,
 	SPACEMIT_STATE_START,
@@ -163,6 +169,7 @@ static int spacemit_i2c_handle_err(struct spacemit_i2c_dev *i2c)
 static void spacemit_i2c_conditionally_reset_bus(struct spacemit_i2c_dev *i2c)
 {
 	u32 status;
+	u8 clk_cnt;
 
 	/* if bus is locked, reset unit. 0: locked */
 	status = readl(i2c->base + SPACEMIT_IBMR);
@@ -172,6 +179,18 @@ static void spacemit_i2c_conditionally_reset_bus(struct spacemit_i2c_dev *i2c)
 	spacemit_i2c_reset(i2c);
 	usleep_range(10, 20);
 
+	for (clk_cnt = 0; clk_cnt < SPACEMIT_BUS_RESET_CLK_CNT_MAX; clk_cnt++) {
+		status = readl(i2c->base + SPACEMIT_IBMR);
+		if (status & SPACEMIT_BMR_SDA)
+			return;
+
+		/* There's nothing left to save here, we are about to exit */
+		writel(FIELD_PREP(SPACEMIT_RCR_FIELD_RST_CYC, 1),
+		       i2c->base + SPACEMIT_IRCR);
+		writel(SPACEMIT_CR_RSTREQ, i2c->base + SPACEMIT_ICR);
+		usleep_range(20, 30);
+	}
+
 	/* check sda again here */
 	status = readl(i2c->base + SPACEMIT_IBMR);
 	if (!(status & SPACEMIT_BMR_SDA))
-- 
2.51.0



