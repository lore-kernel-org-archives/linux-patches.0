Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F43B95FA;
	Fri,  4 Sep 2026 05:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499951; cv=none; b=MnJWWPmtwEAYepbyIUBSm/v8oRcqUvxRZGtpBog240zuPoqFfGFSPatmihOhSdc+LJrLhgFMDDNePQMQrzmC6atgz6hNJi687H85a6/SP2xB1V5k1mgTPh8i4FZPoAmDkJIV2p4cn3pJRftal+yRa15YYyXXcE9LUsaYPO26TZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499951; c=relaxed/simple;
	bh=Xgvc3e1DPxbFuxHQ2RA4Asg7vTKXFwoWIOWo7QL8XA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKlrvF3gzF3rpYtt4raDAYr3IxGp0NKgkPrkPP1DKjU4rnlq9LnY77nw0e/3xLyB1CfaDi1upJBp7dwD+HAhf2b/Cs+btAHlvM6FwZzESzsUzz70c713GTTtjNYkQBFrGQgdrI0lEEDhdQorRqjFIybVFZezBZr3r20WFNT5DQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSIjq6B4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSIjq6B4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086361F00A3D;
	Fri,  4 Sep 2026 05:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499950;
	bh=5oZyQ6ZJba11Vqn+Cv/TICNtuCfOyNBXjd1tc5x8D2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSIjq6B4/SBP3xxwtjfDrGUfVN6JcJtGhTdop0ZmnxUDoO8ZWhO2R0CwzX3cVhzaX
	 r1b7018/jH5FCzEaz7fpVfrNwXwpFdASpy3gc9uDOSA4QPR+eaqqzgCNdv6+O1h+VM
	 UasLOS/nDAcfMju4dCUNvB1w7ueGo+gI6qVkUk0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 599/713] net: dsa: realtek: use gpiod_set_value_cansleep for reset GPIO
Date: Fri,  4 Sep 2026 06:59:27 +0200
Message-ID: <20260904045817.253507235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

commit fb58b6a696b30bcbfbe0cfc0a91b19c816a955fc upstream.

rtl83xx_reset_assert() and rtl83xx_reset_deassert() are only called from
the probe path, which may sleep and is not timing-critical.  When the
reset GPIO is provided by a sleeping controller such as an I2C I/O
expander, gpiod_set_value() warns:

  WARNING: drivers/gpio/gpiolib.c:4030 at gpiod_set_value+0x44/0x80, CPU#1: kworker/u16:4/61
  Hardware name: B&O MAP CA33 Rev f (UNKNOWN) (DT)
  Workqueue: events_unbound deferred_probe_work_func
  pc : gpiod_set_value+0x44/0x80
  lr : rtl83xx_probe+0x1d8/0x3a0
  Call trace:
   gpiod_set_value+0x44/0x80 (P)
   rtl83xx_probe+0x1d8/0x3a0
   realtek_mdio_probe+0x24/0xa0
   mdio_probe+0x38/0x78
   really_probe+0xc4/0x3e0
   __driver_probe_device+0x15c/0x1b8
   driver_probe_device+0xb4/0x120
   __device_attach_driver+0xb8/0x1a0
   bus_for_each_drv+0x88/0xf0
   __device_attach+0xa0/0x1d8
   device_initial_probe+0x54/0x68
   bus_probe_device+0x38/0xa0
   deferred_probe_work_func+0xb8/0x120
   process_one_work+0x184/0x4e8
   worker_thread+0x188/0x308
   kthread+0x130/0x150
   ret_from_fork+0x10/0x20

Switch both helpers to gpiod_set_value_cansleep() so such a reset GPIO can
be used without triggering the warning.

The reset GPIO has been driven with the non-sleeping gpiod_set_value()
since the driver was added in v4.19.  The call has since been refactored
across several files - from realtek-smi.c / realtek-mdio.c into the common
rtl83xx.c module and then into the rtl83xx_reset_assert() and
rtl83xx_reset_deassert() helpers (both in v6.9).  This patch therefore
applies as-is only to kernels that carry those helpers (v6.9+); older
stable kernels need the same gpiod_set_value_cansleep() conversion at the
corresponding open-coded call sites.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Alvin Šipraga <alvin.sipraga@analog.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://patch.msgid.link/20260814110102.2362246-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/realtek/rtl83xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/realtek/rtl83xx.c
+++ b/drivers/net/dsa/realtek/rtl83xx.c
@@ -321,7 +321,7 @@ void rtl83xx_reset_assert(struct realtek
 			 "Failed to assert the switch reset control: %pe\n",
 			 ERR_PTR(ret));
 
-	gpiod_set_value(priv->reset, true);
+	gpiod_set_value_cansleep(priv->reset, true);
 }
 
 void rtl83xx_reset_deassert(struct realtek_priv *priv)
@@ -334,7 +334,7 @@ void rtl83xx_reset_deassert(struct realt
 			 "Failed to deassert the switch reset control: %pe\n",
 			 ERR_PTR(ret));
 
-	gpiod_set_value(priv->reset, false);
+	gpiod_set_value_cansleep(priv->reset, false);
 }
 
 /**


