Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266612517AC;
	Wed, 28 Jan 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614164; cv=none; b=l2GKcPXcwBHXFvjfMrg5PvmIhZInUDY+GkPQ0SrjM2GaMAieBwrymmy83ZAQVqlDp5seYiGxQFXHhVVIHGQoH/sqN6LWh2ra3Cf8hv/kea8HOB2jsl+otMw09N31IFftGFdTEm3NeaMcrnhjQ1iCMfnc7MvuFRBJD0f158uvqwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614164; c=relaxed/simple;
	bh=dNqUnNAZkK3eZj+6X3Bja14T3Vu2RbrLT87VU/32O7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUz8f68jojtNeuUHCNRUEfufZWhWsXIbnZaGGShRKnI8a8e3AGwNY5cntrDxbLuuJ9etoy4ydvDUlh6y/7grdhYqttoCdeOnwL5ByAGUewYioAwK2Exb8Ov/0vQ7dQb+qcm1PSMTaYqH4LZd2qPBQsxglCTTRkBQ5tjEeyh1eBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz0AGR9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz0AGR9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC57C4CEF1;
	Wed, 28 Jan 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614163;
	bh=dNqUnNAZkK3eZj+6X3Bja14T3Vu2RbrLT87VU/32O7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz0AGR9F5w7gx+q6yIg2ym9WhvirC9l4N0Sbgos5UDqxchLbjUSOMyS1eljclGwZ7
	 ewwuZxh1YzBrsw55qfZ1bWRiEgGPabK5U2O//5RmaO/41dt09adTQ6i+KeRDWRj6OI
	 wdIKjVmRUKv8W2wcZdADBwxzu3XG8mW1AIPh0xQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 054/254] phy: rockchip: inno-usb2: fix disconnection in gadget mode
Date: Wed, 28 Jan 2026 16:20:30 +0100
Message-ID: <20260128145346.644384672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Chauvet <louis.chauvet@bootlin.com>

commit 028e8ca7b20fb7324f3e5db34ba8bd366d9d3acc upstream.

When the OTG USB port is used to power the SoC, configured as peripheral
and used in gadget mode, there is a disconnection about 6 seconds after the
gadget is configured and enumerated.

The problem was observed on a Radxa Rock Pi S board, which can only be
powered by the only USB-C connector. That connector is the only one usable
in gadget mode. This implies the USB cable is connected from before boot
and never disconnects while the kernel runs.

The problem happens because of the PHY driver code flow, summarized as:

 * UDC start code (triggered via configfs at any time after boot)
   -> phy_init
       -> rockchip_usb2phy_init
           -> schedule_delayed_work(otg_sm_work [A], 6 sec)
   -> phy_power_on
       -> rockchip_usb2phy_power_on
           -> enable clock
           -> rockchip_usb2phy_reset

 * Now the gadget interface is up and running.

 * 6 seconds later otg_sm_work starts [A]
   -> rockchip_usb2phy_otg_sm_work():
       if (B_IDLE state && VBUS present && ...):
           schedule_delayed_work(&rport->chg_work [B], 0);

 * immediately the chg_detect_work starts [B]
   -> rockchip_chg_detect_work():
       if chg_state is UNDEFINED:
           if (!rport->suspended):
               rockchip_usb2phy_power_off() <--- [X]

At [X], the PHY is powered off, causing a disconnection. This quickly
triggers a new connection and following re-enumeration, but any connection
that had been established during the 6 seconds is broken.

The code already checks for !rport->suspended (which, somewhat
counter-intuitively, means the PHY is powered on), so add a guard for VBUS
as well to avoid a disconnection when a cable is connected.

Fixes: 98898f3bc83c ("phy: rockchip-inno-usb2: support otg-port for rk3399")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/lkml/20250414185458.7767aabc@booty/
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Co-developed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20251127-rk3308-fix-usb-gadget-phy-disconnect-v2-1-dac8a02cd2ca@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -789,14 +789,16 @@ static void rockchip_chg_detect_work(str
 		container_of(work, struct rockchip_usb2phy_port, chg_work.work);
 	struct rockchip_usb2phy *rphy = dev_get_drvdata(rport->phy->dev.parent);
 	struct regmap *base = get_reg_base(rphy);
-	bool is_dcd, tmout, vout;
+	bool is_dcd, tmout, vout, vbus_attach;
 	unsigned long delay;
 
+	vbus_attach = property_enabled(rphy->grf, &rport->port_cfg->utmi_bvalid);
+
 	dev_dbg(&rport->phy->dev, "chg detection work state = %d\n",
 		rphy->chg_state);
 	switch (rphy->chg_state) {
 	case USB_CHG_STATE_UNDEFINED:
-		if (!rport->suspended)
+		if (!rport->suspended && !vbus_attach)
 			rockchip_usb2phy_power_off(rport->phy);
 		/* put the controller in non-driving mode */
 		if (!vbus_attach)


