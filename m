Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A38A101C5;
	Sat,  3 Feb 2024 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933394; cv=none; b=PhIpEx/qpCpIU2ATh4F2AKeoV4ZSzwIqaDLbvl+JxgjF9xVkaAQoRGTJF9zIzDDI/zkKd9gm+apT+EWRQpn61CXrnPTtbVUu97KXYFFfpmidYOD7TqdwOEF/IkAzgQPYStCTn6zpejVh/OmAPtuOlZ3/+mqehuZF6W8Sr0RFQig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933394; c=relaxed/simple;
	bh=7RSmJ9BLY9PFb2Dulatouwh9nW8vtFyEgo1r8TPxCmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TARwTGmMq2dFWtG1ez0PgsiFdFsadOUgoYfacd/UiPPiEeHgkRmW+3yK2zWnyvZuLakepyjiM2s1XKmxgnw3/zYbMkcW3JpoCXxOj4mumItThztuBmPwUUL87sB5mIX+zET8GAIYdBQTlDNpbkQruiMt1yrOlwykmoW3w67Aylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJeB+oP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJeB+oP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D8EC433C7;
	Sat,  3 Feb 2024 04:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933394;
	bh=7RSmJ9BLY9PFb2Dulatouwh9nW8vtFyEgo1r8TPxCmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJeB+oP06TyIFH0Wdi8YoT1r1VJMKqKQTZBYjlJbqTrzVQW9RxzpoyKXAY3xeQGVw
	 l1pDsnUV3fBw0PcdxGYH6Xzw25az883GUL2L6uIO/ZFKl6pv13EC3h62G+pW4vjEV0
	 +lUwUdlxjBwQNJSx8W/5L6ovTNxVKfFY1S73xyyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Ji <xji@analogixsemi.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/219] drm/bridge: anx7625: Fix Set HPD irq detect window to 2ms
Date: Fri,  2 Feb 2024 20:04:43 -0800
Message-ID: <20240203035332.906409937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Ji <xji@analogixsemi.com>

[ Upstream commit e3af7053de3f685c96158373bc234b2feca1f160 ]

Polling firmware HPD GPIO status, set HPD irq detect window to 2ms
after firmware HPD GPIO initial done

Signed-off-by: Xin Ji <xji@analogixsemi.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231120091038.284825-2-xji@analogixsemi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 51 ++++++++++++++++-------
 drivers/gpu/drm/bridge/analogix/anx7625.h |  4 ++
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 5f8137e9cfd7..77a304ac4d75 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1300,10 +1300,32 @@ static void anx7625_config(struct anx7625_data *ctx)
 			  XTAL_FRQ_SEL, XTAL_FRQ_27M);
 }
 
+static int anx7625_hpd_timer_config(struct anx7625_data *ctx)
+{
+	int ret;
+
+	/* Set irq detect window to 2ms */
+	ret = anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
+				HPD_DET_TIMER_BIT0_7, HPD_TIME & 0xFF);
+	ret |= anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
+				 HPD_DET_TIMER_BIT8_15,
+				 (HPD_TIME >> 8) & 0xFF);
+	ret |= anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
+				 HPD_DET_TIMER_BIT16_23,
+				 (HPD_TIME >> 16) & 0xFF);
+
+	return ret;
+}
+
+static int anx7625_read_hpd_gpio_config_status(struct anx7625_data *ctx)
+{
+	return anx7625_reg_read(ctx, ctx->i2c.rx_p0_client, GPIO_CTRL_2);
+}
+
 static void anx7625_disable_pd_protocol(struct anx7625_data *ctx)
 {
 	struct device *dev = &ctx->client->dev;
-	int ret;
+	int ret, val;
 
 	/* Reset main ocm */
 	ret = anx7625_reg_write(ctx, ctx->i2c.rx_p0_client, 0x88, 0x40);
@@ -1317,6 +1339,19 @@ static void anx7625_disable_pd_protocol(struct anx7625_data *ctx)
 		DRM_DEV_DEBUG_DRIVER(dev, "disable PD feature fail.\n");
 	else
 		DRM_DEV_DEBUG_DRIVER(dev, "disable PD feature succeeded.\n");
+
+	/*
+	 * Make sure the HPD GPIO already be configured after OCM release before
+	 * setting HPD detect window register. Here we poll the status register
+	 * at maximum 40ms, then config HPD irq detect window register
+	 */
+	readx_poll_timeout(anx7625_read_hpd_gpio_config_status,
+			   ctx, val,
+			   ((val & HPD_SOURCE) || (val < 0)),
+			   2000, 2000 * 20);
+
+	/* Set HPD irq detect window to 2ms */
+	anx7625_hpd_timer_config(ctx);
 }
 
 static int anx7625_ocm_loading_check(struct anx7625_data *ctx)
@@ -1440,20 +1475,6 @@ static void anx7625_start_dp_work(struct anx7625_data *ctx)
 
 static int anx7625_read_hpd_status_p0(struct anx7625_data *ctx)
 {
-	int ret;
-
-	/* Set irq detect window to 2ms */
-	ret = anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
-				HPD_DET_TIMER_BIT0_7, HPD_TIME & 0xFF);
-	ret |= anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
-				 HPD_DET_TIMER_BIT8_15,
-				 (HPD_TIME >> 8) & 0xFF);
-	ret |= anx7625_reg_write(ctx, ctx->i2c.tx_p2_client,
-				 HPD_DET_TIMER_BIT16_23,
-				 (HPD_TIME >> 16) & 0xFF);
-	if (ret < 0)
-		return ret;
-
 	return anx7625_reg_read(ctx, ctx->i2c.rx_p0_client, SYSTEM_STSTUS);
 }
 
diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.h b/drivers/gpu/drm/bridge/analogix/anx7625.h
index 239956199e1b..164250c8c8b6 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.h
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.h
@@ -259,6 +259,10 @@
 #define AP_MIPI_RX_EN BIT(5) /* 1: MIPI RX input in  0: no RX in */
 #define AP_DISABLE_PD BIT(6)
 #define AP_DISABLE_DISPLAY BIT(7)
+
+#define GPIO_CTRL_2   0x49
+#define HPD_SOURCE    BIT(6)
+
 /***************************************************************/
 /* Register definition of device address 0x84 */
 #define  MIPI_PHY_CONTROL_3            0x03
-- 
2.43.0



