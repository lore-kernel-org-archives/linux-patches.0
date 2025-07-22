Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F352EF2B7;
	Tue, 22 Jul 2025 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193543; cv=none; b=IvS7JwcnHA+NFYs2Kge8Msqtr/AYahBo4BhtyL5mu6EHrBfR8f74gaZzuJzwZUGlOEorquB3Dg5WKwTaTUuj5tJvP2kDCEGWCa4BSPUN8Mhvzur94M/+chf4LhIWsq00A4l9dtQPTtcgLlxNwFG4MI0S46FkG3vA9atZ/uwQYBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193543; c=relaxed/simple;
	bh=P2INypJ59NakWimv+4N/Cnah6czjAq+pW7VKo0mRBrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O89EGG2sm/86wq5yRtPxi1mLhitesbeeQT7jBSrKBP/CQFulLyq7AsGFzml4tE6pWI48ONstrU+fTfaD+79Zlp+rVqBuBlqXdizBhPpjrZrO3naelytnCGxcgP7DO4/UObuOIyWHcEoepUWAjgftjWVDCj4orOAhNyW41vB1g9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krekymIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krekymIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C531EC4CEEB;
	Tue, 22 Jul 2025 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193543;
	bh=P2INypJ59NakWimv+4N/Cnah6czjAq+pW7VKo0mRBrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krekymINtBjCQUDg2SYVmMy0sOVz+5jtZze6h+xapgokgL/RkLjEJ3agieiMM/vSX
	 kuMCcBmEL/c7Y4eIA5ZqbnI65n2S4z8ipfYVtZlXekb96U0BdMmM+pWKNs++zd0k8V
	 M9Bk/3I2kCU30mB9iarr35QtZddGi27VmmFh9kfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Werling <brett.werling@garmin.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 124/187] can: tcan4x5x: fix reset gpio usage during probe
Date: Tue, 22 Jul 2025 15:44:54 +0200
Message-ID: <20250722134350.366589162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Werling <brett.werling@garmin.com>

[ Upstream commit 0f97a7588db7a545ea07ee0d512789bfad4931d8 ]

Fixes reset GPIO usage during probe by ensuring we retrieve the GPIO and
take the device out of reset (if it defaults to being in reset) before
we attempt to communicate with the device. This is achieved by moving
the call to tcan4x5x_get_gpios() before tcan4x5x_find_version() and
avoiding any device communication while getting the GPIOs. Once we
determine the version, we can then take the knowledge of which GPIOs we
obtained and use it to decide whether we need to disable the wake or
state pin functions within the device.

This change is necessary in a situation where the reset GPIO is pulled
high externally before the CPU takes control of it, meaning we need to
explicitly bring the device out of reset before we can start
communicating with it at all.

This also has the effect of fixing an issue where a reset of the device
would occur after having called tcan4x5x_disable_wake(), making the
original behavior not actually disable the wake. This patch should now
disable wake or state pin functions well after the reset occurs.

Signed-off-by: Brett Werling <brett.werling@garmin.com>
Link: https://patch.msgid.link/20250711141728.1826073-1-brett.werling@garmin.com
Cc: Markus Schneider-Pargmann <msp@baylibre.com>
Fixes: 142c6dc6d9d7 ("can: tcan4x5x: Add support for tcan4552/4553")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x-core.c | 61 ++++++++++++++++++---------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 8edaa339d590b..39b0b5277b11f 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -343,21 +343,19 @@ static void tcan4x5x_get_dt_data(struct m_can_classdev *cdev)
 		of_property_read_bool(cdev->dev->of_node, "ti,nwkrq-voltage-vio");
 }
 
-static int tcan4x5x_get_gpios(struct m_can_classdev *cdev,
-			      const struct tcan4x5x_version_info *version_info)
+static int tcan4x5x_get_gpios(struct m_can_classdev *cdev)
 {
 	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
 	int ret;
 
-	if (version_info->has_wake_pin) {
-		tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
-							    GPIOD_OUT_HIGH);
-		if (IS_ERR(tcan4x5x->device_wake_gpio)) {
-			if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
+	tcan4x5x->device_wake_gpio = devm_gpiod_get_optional(cdev->dev,
+							     "device-wake",
+							     GPIOD_OUT_HIGH);
+	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
+		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
-			tcan4x5x_disable_wake(cdev);
-		}
+		tcan4x5x->device_wake_gpio = NULL;
 	}
 
 	tcan4x5x->reset_gpio = devm_gpiod_get_optional(cdev->dev, "reset",
@@ -369,14 +367,31 @@ static int tcan4x5x_get_gpios(struct m_can_classdev *cdev,
 	if (ret)
 		return ret;
 
-	if (version_info->has_state_pin) {
-		tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
-								      "device-state",
-								      GPIOD_IN);
-		if (IS_ERR(tcan4x5x->device_state_gpio)) {
-			tcan4x5x->device_state_gpio = NULL;
-			tcan4x5x_disable_state(cdev);
-		}
+	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
+							      "device-state",
+							      GPIOD_IN);
+	if (IS_ERR(tcan4x5x->device_state_gpio))
+		tcan4x5x->device_state_gpio = NULL;
+
+	return 0;
+}
+
+static int tcan4x5x_check_gpios(struct m_can_classdev *cdev,
+				const struct tcan4x5x_version_info *version_info)
+{
+	struct tcan4x5x_priv *tcan4x5x = cdev_to_priv(cdev);
+	int ret;
+
+	if (version_info->has_wake_pin && !tcan4x5x->device_wake_gpio) {
+		ret = tcan4x5x_disable_wake(cdev);
+		if (ret)
+			return ret;
+	}
+
+	if (version_info->has_state_pin && !tcan4x5x->device_state_gpio) {
+		ret = tcan4x5x_disable_state(cdev);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -468,15 +483,21 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		goto out_m_can_class_free_dev;
 	}
 
+	ret = tcan4x5x_get_gpios(mcan_class);
+	if (ret) {
+		dev_err(&spi->dev, "Getting gpios failed %pe\n", ERR_PTR(ret));
+		goto out_power;
+	}
+
 	version_info = tcan4x5x_find_version(priv);
 	if (IS_ERR(version_info)) {
 		ret = PTR_ERR(version_info);
 		goto out_power;
 	}
 
-	ret = tcan4x5x_get_gpios(mcan_class, version_info);
+	ret = tcan4x5x_check_gpios(mcan_class, version_info);
 	if (ret) {
-		dev_err(&spi->dev, "Getting gpios failed %pe\n", ERR_PTR(ret));
+		dev_err(&spi->dev, "Checking gpios failed %pe\n", ERR_PTR(ret));
 		goto out_power;
 	}
 
-- 
2.39.5



