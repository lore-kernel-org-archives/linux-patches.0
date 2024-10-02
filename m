Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C241D0493;
	Wed,  2 Oct 2024 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876530; cv=none; b=Bk8F0mm/fahXG9xCznleBwYOnefBOT3Vbr70EyfbUUUEItihN7KQLxyLgv7JXrg2GJSWnRHmiPkQJ/E11aYxvQPtNsJR/uCSSLSQX3q/M7YtZdIkobPQcW24pwpe5t5hYT1KC765be514OH7QPoayxXcW36bw5eBGJCZHALHSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876530; c=relaxed/simple;
	bh=7yriKrpCxG52y5dUBgNrgTwra05n9I+8yFWZw0L62rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpdum6xQjpq53osuBMiwna2ClgaIEV6LLfpMm86xWydwfvbmn3kx9nWfYCvSXZC3tJ/kNU/QOoZ8UPdrnzSvJ7ZQ6eYVB3P6CFzpcTZl+tdDyR9eUhNfQGQEvd0krYlg2Fb+dPSsTo+Or8gmSaKeh01wQ4xaZVfxMg7DylMe3bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cULSHfEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cULSHfEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE207C4CECF;
	Wed,  2 Oct 2024 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876530;
	bh=7yriKrpCxG52y5dUBgNrgTwra05n9I+8yFWZw0L62rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cULSHfELvichGe9Q7ch2KCTlNMk8cJhOFzEyIi27Nd27G/Tth2bZcf+OW+jR0iGPS
	 ns+EgzeWj6NdJrSxIbAIExhpk3JNRFHBHN08ne4T8ktO/tJ7m6VChcb4tfwgvnDL93
	 Ki5KQL0nfDSRUuQo2EUvTJudYJ61brPckG8znUzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Hans-Frieder Vogt <hfdevel@gmx.net>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 475/695] net: phy: aquantia: fix -ETIMEDOUT PHY probe failure when firmware not present
Date: Wed,  2 Oct 2024 14:57:53 +0200
Message-ID: <20241002125841.432467792@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 194ef9d0de9021df4a0ba8b112f91e56adaddd22 ]

The author of the blamed commit apparently did not notice something
about aqr_wait_reset_complete(): it polls the exact same register -
MDIO_MMD_VEND1:VEND1_GLOBAL_FW_ID - as aqr_firmware_load().

Thus, the entire logic after the introduction of aqr_wait_reset_complete() is
now completely side-stepped, because if aqr_wait_reset_complete()
succeeds, MDIO_MMD_VEND1:VEND1_GLOBAL_FW_ID could have only been a
non-zero value. The handling of the case where the register reads as 0
is dead code, due to the previous -ETIMEDOUT having stopped execution
and returning a fatal error to the caller. We never attempt to load
new firmware if no firmware is present.

Based on static code analysis, I guess we should simply introduce a
switch/case statement based on the return code from aqr_wait_reset_complete(),
to determine whether to load firmware or not. I am not intending to
change the procedure through which the driver determines whether to load
firmware or not, as I am unaware of alternative possibilities.

At the same time, Russell King suggests that if aqr_wait_reset_complete()
is expected to return -ETIMEDOUT as part of normal operation and not
just catastrophic failure, the use of phy_read_mmd_poll_timeout() is
improper, since that has an embedded print inside. Just open-code a
call to read_poll_timeout() to avoid printing -ETIMEDOUT, but continue
printing actual read errors from the MDIO bus.

Fixes: ad649a1fac37 ("net: phy: aquantia: wait for FW reset before checking the vendor ID")
Reported-by: Clark Wang <xiaoning.wang@nxp.com>
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/netdev/8ac00a45-ac61-41b4-9f74-d18157b8b6bf@nvidia.com/
Reported-by: Hans-Frieder Vogt <hfdevel@gmx.net>
Closes: https://lore.kernel.org/netdev/c7c1a3ae-be97-4929-8d89-04c8aa870209@gmx.net/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Hans-Frieder Vogt <hfdevel@gmx.net>
Link: https://patch.msgid.link/20240913121230.2620122-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia_firmware.c | 42 +++++++++++---------
 drivers/net/phy/aquantia/aquantia_main.c     | 19 +++++++--
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/aquantia/aquantia_firmware.c b/drivers/net/phy/aquantia/aquantia_firmware.c
index 524627a36c6fc..dac6464b5fe2e 100644
--- a/drivers/net/phy/aquantia/aquantia_firmware.c
+++ b/drivers/net/phy/aquantia/aquantia_firmware.c
@@ -353,26 +353,32 @@ int aqr_firmware_load(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = aqr_wait_reset_complete(phydev);
-	if (ret)
-		return ret;
-
-	/* Check if the firmware is not already loaded by pooling
-	 * the current version returned by the PHY. If 0 is returned,
-	 * no firmware is loaded.
+	/* Check if the firmware is not already loaded by polling
+	 * the current version returned by the PHY.
 	 */
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_FW_ID);
-	if (ret > 0)
-		goto exit;
-
-	ret = aqr_firmware_load_nvmem(phydev);
-	if (!ret)
-		goto exit;
-
-	ret = aqr_firmware_load_fs(phydev);
-	if (ret)
+	ret = aqr_wait_reset_complete(phydev);
+	switch (ret) {
+	case 0:
+		/* Some firmware is loaded => do nothing */
+		return 0;
+	case -ETIMEDOUT:
+		/* VEND1_GLOBAL_FW_ID still reads 0 after 2 seconds of polling.
+		 * We don't have full confidence that no firmware is loaded (in
+		 * theory it might just not have loaded yet), but we will
+		 * assume that, and load a new image.
+		 */
+		ret = aqr_firmware_load_nvmem(phydev);
+		if (!ret)
+			return ret;
+
+		ret = aqr_firmware_load_fs(phydev);
+		if (ret)
+			return ret;
+		break;
+	default:
+		/* PHY read error, propagate it to the caller */
 		return ret;
+	}
 
-exit:
 	return 0;
 }
diff --git a/drivers/net/phy/aquantia/aquantia_main.c b/drivers/net/phy/aquantia/aquantia_main.c
index e982e9ce44a59..57b8b8f400fd4 100644
--- a/drivers/net/phy/aquantia/aquantia_main.c
+++ b/drivers/net/phy/aquantia/aquantia_main.c
@@ -435,6 +435,9 @@ static int aqr107_set_tunable(struct phy_device *phydev,
 	}
 }
 
+#define AQR_FW_WAIT_SLEEP_US	20000
+#define AQR_FW_WAIT_TIMEOUT_US	2000000
+
 /* If we configure settings whilst firmware is still initializing the chip,
  * then these settings may be overwritten. Therefore make sure chip
  * initialization has completed. Use presence of the firmware ID as
@@ -444,11 +447,19 @@ static int aqr107_set_tunable(struct phy_device *phydev,
  */
 int aqr_wait_reset_complete(struct phy_device *phydev)
 {
-	int val;
+	int ret, val;
+
+	ret = read_poll_timeout(phy_read_mmd, val, val != 0,
+				AQR_FW_WAIT_SLEEP_US, AQR_FW_WAIT_TIMEOUT_US,
+				false, phydev, MDIO_MMD_VEND1,
+				VEND1_GLOBAL_FW_ID);
+	if (val < 0) {
+		phydev_err(phydev, "Failed to read VEND1_GLOBAL_FW_ID: %pe\n",
+			   ERR_PTR(val));
+		return val;
+	}
 
-	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
-					 VEND1_GLOBAL_FW_ID, val, val != 0,
-					 20000, 2000000, false);
+	return ret;
 }
 
 static void aqr107_chip_info(struct phy_device *phydev)
-- 
2.43.0



