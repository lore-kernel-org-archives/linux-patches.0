Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D853214A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c81uRQrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54316C433C7;
	Mon, 23 Oct 2023 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059592;
	bh=N32gROQCcIi+G2GrF3BzXoXr6ORZCDUDj0a7cOfjt3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c81uRQrx3K9Dlp0C4lnkE+D5uheXcw08XRWzr14ou4D9f9O2z4luKXNc81upQSqbU
	 /qKGFbXP+MYmQ6+pjG4citK/V9LMExgG5klehMuEUhc178Mj4MaBasvbwbmRmvBNLL
	 m0FsIIGCiMpRAT7+xi1u9hNhA9J/6pvJcPyPvKOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Merlijn Wajer <merlijn@wizzup.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 228/241] phy: mapphone-mdm6600: Fix pinctrl_pm handling for sleep pins
Date: Mon, 23 Oct 2023 12:56:54 +0200
Message-ID: <20231023104839.429482937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 3b384cc74b00b5ac21d18e4c1efc3c1da5300971 ]

Looks like the driver sleep pins configuration is unusable. Adding the
sleep pins causes the usb phy to not respond. We need to use the default
pins in probe, and only set sleep pins at phy_mdm6600_device_power_off().

As the modem can also be booted to a serial port mode for firmware
flashing, let's make the pin changes limited to probe and remove. For
probe, we get the default pins automatically. We only need to set the
sleep pins in phy_mdm6600_device_power_off() to prevent the modem from
waking up because the gpio line glitches.

If it turns out that we need a separate state for phy_mdm6600_power_on()
and phy_mdm6600_power_off(), we can use the pinctrl idle state.

Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Fixes: 2ad2af081622 ("phy: mapphone-mdm6600: Improve phy related runtime PM calls")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20230913060433.48373-3-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/phy-mapphone-mdm6600.c | 29 +++++++++------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/phy/motorola/phy-mapphone-mdm6600.c b/drivers/phy/motorola/phy-mapphone-mdm6600.c
index df48b1becebe6..376d023a0aa90 100644
--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -122,16 +122,10 @@ static int phy_mdm6600_power_on(struct phy *x)
 {
 	struct phy_mdm6600 *ddata = phy_get_drvdata(x);
 	struct gpio_desc *enable_gpio = ddata->ctrl_gpios[PHY_MDM6600_ENABLE];
-	int error;
 
 	if (!ddata->enabled)
 		return -ENODEV;
 
-	error = pinctrl_pm_select_default_state(ddata->dev);
-	if (error)
-		dev_warn(ddata->dev, "%s: error with default_state: %i\n",
-			 __func__, error);
-
 	gpiod_set_value_cansleep(enable_gpio, 1);
 
 	/* Allow aggressive PM for USB, it's only needed for n_gsm port */
@@ -160,11 +154,6 @@ static int phy_mdm6600_power_off(struct phy *x)
 
 	gpiod_set_value_cansleep(enable_gpio, 0);
 
-	error = pinctrl_pm_select_sleep_state(ddata->dev);
-	if (error)
-		dev_warn(ddata->dev, "%s: error with sleep_state: %i\n",
-			 __func__, error);
-
 	return 0;
 }
 
@@ -456,6 +445,7 @@ static void phy_mdm6600_device_power_off(struct phy_mdm6600 *ddata)
 {
 	struct gpio_desc *reset_gpio =
 		ddata->ctrl_gpios[PHY_MDM6600_RESET];
+	int error;
 
 	ddata->enabled = false;
 	phy_mdm6600_cmd(ddata, PHY_MDM6600_CMD_BP_SHUTDOWN_REQ);
@@ -471,6 +461,17 @@ static void phy_mdm6600_device_power_off(struct phy_mdm6600 *ddata)
 	} else {
 		dev_err(ddata->dev, "Timed out powering down\n");
 	}
+
+	/*
+	 * Keep reset gpio high with padconf internal pull-up resistor to
+	 * prevent modem from waking up during deeper SoC idle states. The
+	 * gpio bank lines can have glitches if not in the always-on wkup
+	 * domain.
+	 */
+	error = pinctrl_pm_select_sleep_state(ddata->dev);
+	if (error)
+		dev_warn(ddata->dev, "%s: error with sleep_state: %i\n",
+			 __func__, error);
 }
 
 static void phy_mdm6600_deferred_power_on(struct work_struct *work)
@@ -571,12 +572,6 @@ static int phy_mdm6600_probe(struct platform_device *pdev)
 	ddata->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ddata);
 
-	/* Active state selected in phy_mdm6600_power_on() */
-	error = pinctrl_pm_select_sleep_state(ddata->dev);
-	if (error)
-		dev_warn(ddata->dev, "%s: error with sleep_state: %i\n",
-			 __func__, error);
-
 	error = phy_mdm6600_init_lines(ddata);
 	if (error)
 		return error;
-- 
2.42.0



