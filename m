Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C4E522A;
	Wed,  5 Feb 2025 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765164; cv=none; b=C/QCCAb2oiQd0UJQw2WNAe+G7xeDtd0ehJrgy14UkwxACE325vsxuurGAsI05xb07EWaAqrNszKW8Ccox359z1TuSE1eWQS6XYf5GJC9N+gneSoW/mI9JqeWYquG4/b+wq8oHY9L7nRhxMZjZqexDt07Mx6ujEXvzc91xBwKOxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765164; c=relaxed/simple;
	bh=vsfPm1tkP4uQti62ME8KtzJSxGWZ9LWJeRls4IuzGF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IOG4BuL0qtLo1/5pwFMZQCFYRCjf1zvtgvIp08eh8wFUrmtb5FpoFCbQXkEiaWdzH5eZaCpqBfOnaZwZOEe1/YjswTnC2juM9YtutwJN8E0b0TBvJ2svtSLxPMDanFB+OJ54oUJkccETlYOLU+EDv7iO3Sos5tiWaL1AlXpXiCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP+VvCET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP+VvCET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F316C4CED1;
	Wed,  5 Feb 2025 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765163;
	bh=vsfPm1tkP4uQti62ME8KtzJSxGWZ9LWJeRls4IuzGF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zP+VvCETb5KHwWnvR624pfygO4mR6X2M/jhu2sZUMCMIa/zTTvufCiFspBIeHoTwC
	 aypmzfiP2UhRFCIDRJGC8DFtv+kz1IegZTXlZc6nlymB6OJjc3y09LzgQtP3wErrTB
	 YIElZ0oRX70qX6QmTjKBWPEQSFing8KJpRpezv40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Marek Vasut <marex@denx.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 152/623] wifi: wilc1000: unregister wiphy only if it has been registered
Date: Wed,  5 Feb 2025 14:38:14 +0100
Message-ID: <20250205134502.050794116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit 1be94490b6b8a06ff14cd23fda8714e6ec37cdfb ]

There is a specific error path in probe functions in wilc drivers (both
sdio and spi) which can lead to kernel panic, as this one for example
when using SPI:

Unable to handle kernel paging request at virtual address 9f000000 when read
[9f000000] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in: wilc1000_spi(+) crc_itu_t crc7 wilc1000 cfg80211 bluetooth ecdh_generic ecc
CPU: 0 UID: 0 PID: 106 Comm: modprobe Not tainted 6.13.0-rc3+ #22
Hardware name: Atmel SAMA5
PC is at wiphy_unregister+0x244/0xc40 [cfg80211]
LR is at wiphy_unregister+0x1c0/0xc40 [cfg80211]
[...]
 wiphy_unregister [cfg80211] from wilc_netdev_cleanup+0x380/0x494 [wilc1000]
 wilc_netdev_cleanup [wilc1000] from wilc_bus_probe+0x360/0x834 [wilc1000_spi]
 wilc_bus_probe [wilc1000_spi] from spi_probe+0x15c/0x1d4
 spi_probe from really_probe+0x270/0xb2c
 really_probe from __driver_probe_device+0x1dc/0x4e8
 __driver_probe_device from driver_probe_device+0x5c/0x140
 driver_probe_device from __driver_attach+0x220/0x540
 __driver_attach from bus_for_each_dev+0x13c/0x1a8
 bus_for_each_dev from bus_add_driver+0x2a0/0x6a4
 bus_add_driver from driver_register+0x27c/0x51c
 driver_register from do_one_initcall+0xf8/0x564
 do_one_initcall from do_init_module+0x2e4/0x82c
 do_init_module from load_module+0x59a0/0x70c4
 load_module from init_module_from_file+0x100/0x148
 init_module_from_file from sys_finit_module+0x2fc/0x924
 sys_finit_module from ret_fast_syscall+0x0/0x1c

The issue can easily be reproduced, for example by not wiring correctly
a wilc device through SPI (and so, make it unresponsive to early SPI
commands). It is due to a recent change decoupling wiphy allocation from
wiphy registration, however wilc_netdev_cleanup has not been updated
accordingly, letting it possibly call wiphy unregister on a wiphy which
has never been registered.

Fix this crash by moving wiphy_unregister/wiphy_free out of
wilc_netdev_cleanup, and by adjusting error paths in both drivers

Fixes: fbdf0c5248dc ("wifi: wilc1000: Register wiphy after reading out chipid")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241223-wilc_fix_probe_error_path-v1-1-91fa7bd8e5b6@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 2 --
 drivers/net/wireless/microchip/wilc1000/sdio.c   | 9 +++++++--
 drivers/net/wireless/microchip/wilc1000/spi.c    | 9 +++++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 7e84fc0fd9118..af298021e0504 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -925,8 +925,6 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 
 	wilc_wlan_cfg_deinit(wilc);
 	wlan_deinit_locks(wilc);
-	wiphy_unregister(wilc->wiphy);
-	wiphy_free(wilc->wiphy);
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 5262c8846c13d..3751e2ee1ca95 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -193,7 +193,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	ret = wilc_load_mac_from_nv(wilc);
 	if (ret) {
 		pr_err("Can not retrieve MAC address from chip\n");
-		goto dispose_irq;
+		goto unregister_wiphy;
 	}
 
 	wilc_sdio_deinit(wilc);
@@ -202,15 +202,18 @@ static int wilc_sdio_probe(struct sdio_func *func,
 				   NL80211_IFTYPE_STATION, false);
 	if (IS_ERR(vif)) {
 		ret = PTR_ERR(vif);
-		goto dispose_irq;
+		goto unregister_wiphy;
 	}
 
 	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
 
+unregister_wiphy:
+	wiphy_unregister(wilc->wiphy);
 dispose_irq:
 	irq_dispose_mapping(wilc->dev_irq_num);
 	wilc_netdev_cleanup(wilc);
+	wiphy_free(wilc->wiphy);
 free:
 	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
@@ -222,7 +225,9 @@ static void wilc_sdio_remove(struct sdio_func *func)
 	struct wilc *wilc = sdio_get_drvdata(func);
 	struct wilc_sdio *sdio_priv = wilc->bus_data;
 
+	wiphy_unregister(wilc->wiphy);
 	wilc_netdev_cleanup(wilc);
+	wiphy_free(wilc->wiphy);
 	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
 }
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index ce2a9cdd6aa78..31219fd0cfb3f 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -256,7 +256,7 @@ static int wilc_bus_probe(struct spi_device *spi)
 	ret = wilc_load_mac_from_nv(wilc);
 	if (ret) {
 		pr_err("Can not retrieve MAC address from chip\n");
-		goto power_down;
+		goto unregister_wiphy;
 	}
 
 	wilc_wlan_power(wilc, false);
@@ -264,14 +264,17 @@ static int wilc_bus_probe(struct spi_device *spi)
 				   NL80211_IFTYPE_STATION, false);
 	if (IS_ERR(vif)) {
 		ret = PTR_ERR(vif);
-		goto power_down;
+		goto unregister_wiphy;
 	}
 	return 0;
 
+unregister_wiphy:
+	wiphy_unregister(wilc->wiphy);
 power_down:
 	wilc_wlan_power(wilc, false);
 netdev_cleanup:
 	wilc_netdev_cleanup(wilc);
+	wiphy_free(wilc->wiphy);
 free:
 	kfree(spi_priv);
 	return ret;
@@ -282,7 +285,9 @@ static void wilc_bus_remove(struct spi_device *spi)
 	struct wilc *wilc = spi_get_drvdata(spi);
 	struct wilc_spi *spi_priv = wilc->bus_data;
 
+	wiphy_unregister(wilc->wiphy);
 	wilc_netdev_cleanup(wilc);
+	wiphy_free(wilc->wiphy);
 	kfree(spi_priv);
 }
 
-- 
2.39.5



