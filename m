Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5E18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368F1C433C9;
	Wed, 20 Sep 2023 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210412;
	bh=IKPaIUBOsOx+cr36JKwffDPmHvO9T8Q6Ke7VStMa+w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNbjpOrntpHzRnc6qxHC5YSbDYFSuAzYglLrUW6+MLrkE8/ofs+tWXR1mGSQSqW0y
	 66+qUYTcDS7VKiGQSE9GBY8BICXXZQZ/d798RBiR25VxGF5iXcULK70DpNZTPgF76A
	 cO1kXwBAbO0RF+AtHZQ52uVDux0pdSDY5LWknZ4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Watts <contact@jookia.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 034/211] can: sun4i_can: Add support for the Allwinner D1
Date: Wed, 20 Sep 2023 13:27:58 +0200
Message-ID: <20230920112846.851375754@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Watts <contact@jookia.org>

[ Upstream commit 8abb95250ae6af2d51993da8fcae18da2ce24cc4 ]

The controllers present in the D1 are extremely similar to the R40
and require the same reset quirks, but An extra quirk is needed to support
receiving packets.

Signed-off-by: John Watts <contact@jookia.org>
Link: https://lore.kernel.org/all/20230721221552.1973203-6-contact@jookia.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/Kconfig     |  4 ++--
 drivers/net/can/sun4i_can.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index a5c5036dfb943..e626de33e735d 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -185,10 +185,10 @@ config CAN_SLCAN
 
 config CAN_SUN4I
 	tristate "Allwinner A10 CAN controller"
-	depends on MACH_SUN4I || MACH_SUN7I || COMPILE_TEST
+	depends on MACH_SUN4I || MACH_SUN7I || RISCV || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN controller found on Allwinner
-	  A10/A20 SoCs.
+	  A10/A20/D1 SoCs.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called sun4i_can.
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 1f90fe6dbb8bb..c508a328e38d4 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -91,6 +91,8 @@
 #define SUN4I_REG_BUF12_ADDR	0x0070	/* CAN Tx/Rx Buffer 12 */
 #define SUN4I_REG_ACPC_ADDR	0x0040	/* CAN Acceptance Code 0 */
 #define SUN4I_REG_ACPM_ADDR	0x0044	/* CAN Acceptance Mask 0 */
+#define SUN4I_REG_ACPC_ADDR_D1	0x0028	/* CAN Acceptance Code 0 on the D1 */
+#define SUN4I_REG_ACPM_ADDR_D1	0x002C	/* CAN Acceptance Mask 0 on the D1 */
 #define SUN4I_REG_RBUF_RBACK_START_ADDR	0x0180	/* CAN transmit buffer start */
 #define SUN4I_REG_RBUF_RBACK_END_ADDR	0x01b0	/* CAN transmit buffer end */
 
@@ -779,6 +781,11 @@ static const struct sun4ican_quirks sun4ican_quirks_r40 = {
 	.acp_offset = 0,
 };
 
+static const struct sun4ican_quirks sun4ican_quirks_d1 = {
+	.has_reset = true,
+	.acp_offset = (SUN4I_REG_ACPC_ADDR_D1 - SUN4I_REG_ACPC_ADDR),
+};
+
 static const struct of_device_id sun4ican_of_match[] = {
 	{
 		.compatible = "allwinner,sun4i-a10-can",
@@ -789,6 +796,9 @@ static const struct of_device_id sun4ican_of_match[] = {
 	}, {
 		.compatible = "allwinner,sun8i-r40-can",
 		.data = &sun4ican_quirks_r40
+	}, {
+		.compatible = "allwinner,sun20i-d1-can",
+		.data = &sun4ican_quirks_d1
 	}, {
 		/* sentinel */
 	},
@@ -913,4 +923,4 @@ module_platform_driver(sun4i_can_driver);
 MODULE_AUTHOR("Peter Chen <xingkongcp@gmail.com>");
 MODULE_AUTHOR("Gerhard Bertelsmann <info@gerhard-bertelsmann.de>");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("CAN driver for Allwinner SoCs (A10/A20)");
+MODULE_DESCRIPTION("CAN driver for Allwinner SoCs (A10/A20/D1)");
-- 
2.40.1



