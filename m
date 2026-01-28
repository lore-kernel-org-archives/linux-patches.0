Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12AB368297;
	Wed, 28 Jan 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614153; cv=none; b=NWsaqandLYyMtLBsMr1PTypcD0+4jdRBJRsYGD4VOylh8bNMssQzLD6fwP+2TVY2fRJTpYayAr1m5z0Q1h49tf6Xf7sj0EkcyAwDBU/Stk0w7noUIw2/om9poyiag4vD/g5diCBCixpW7SgMpLJA/a0Tjef+utJ33L82QIVAslw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614153; c=relaxed/simple;
	bh=3n9/bpqXhri/hXzyilJIFBhc2hbZu5QewTZASPUJjOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saVzFQM1ireoKhwwL12hAuqVCOKDWKMmUP3U4Qr7u9/n3Ixdd9u3rlWshoOy9bIX42kQ2V0UEm06Cl3QPSxa4aGCiybxDfuZieZw4GXztxDo0QA2xEWoYUekCj+bcLLSZvxtsee9tj/hvHRilgqFGPSDBj9XCu3ZWyzjYEMKGWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjxUFuym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjxUFuym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378A8C4CEF1;
	Wed, 28 Jan 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614153;
	bh=3n9/bpqXhri/hXzyilJIFBhc2hbZu5QewTZASPUJjOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjxUFuymH9BwjhCEeJLCEoOgyMLJ7cRcBCGgKeUNg1T9Pvx+/7Ry90Ns+MrctfMX2
	 W0nhh4GAh0aWqL4rPDqceXLr/MRtT3Vtq5Dz/QnzO3tvwy3bMGeogMZyd1AjQMtwiA
	 p3+7EjzToS/7Pwbgmbm6RIESH4KnT9fyIImJ+3Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 052/254] phy: rockchip: inno-usb2: fix communication disruption in gadget mode
Date: Wed, 28 Jan 2026 16:20:28 +0100
Message-ID: <20260128145346.573638523@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 7d8f725b79e35fa47e42c88716aad8711e1168d8 upstream.

When the OTG USB port is used to power to SoC, configured as peripheral and
used in gadget mode, communication stops without notice about 6 seconds
after the gadget is configured and enumerated.

The problem was observed on a Radxa Rock Pi S board, which can only be
powered by the only USB-C connector. That connector is the only one usable
in gadget mode. This implies the USB cable is connected from before boot
and never disconnects while the kernel runs.

The related code flow in the PHY driver code can be summarized as:

 * the first time chg_detect_work starts (6 seconds after gadget is
   configured and enumerated)
   -> rockchip_chg_detect_work():
       if chg_state is UNDEFINED:
          property_enable(base, &rphy->phy_cfg->chg_det.opmode, false); [Y]

 * rockchip_chg_detect_work() changes state and re-triggers itself a few
   times until it reaches the DETECTED state:
   -> rockchip_chg_detect_work():
       if chg_state is DETECTED:
          property_enable(base, &rphy->phy_cfg->chg_det.opmode, true); [Z]

At [Y] all existing communications stop. E.g. using a CDC serial gadget,
the /dev/tty* devices are still present on both host and device, but no
data is transferred anymore. The later call with a 'true' argument at [Z]
does not restore it.

Due to the lack of documentation, what chg_det.opmode does exactly is not
clear, however by code inspection it seems reasonable that is disables
something needed to keep the communication working, and testing proves that
disabling these lines lets gadget mode keep working. So prevent changes to
chg_det.opmode when there is a cable connected (VBUS present).

Fixes: 98898f3bc83c ("phy: rockchip-inno-usb2: support otg-port for rk3399")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/lkml/20250414185458.7767aabc@booty/
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20251127-rk3308-fix-usb-gadget-phy-disconnect-v2-2-dac8a02cd2ca@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -799,7 +799,8 @@ static void rockchip_chg_detect_work(str
 		if (!rport->suspended)
 			rockchip_usb2phy_power_off(rport->phy);
 		/* put the controller in non-driving mode */
-		property_enable(base, &rphy->phy_cfg->chg_det.opmode, false);
+		if (!vbus_attach)
+			property_enable(base, &rphy->phy_cfg->chg_det.opmode, false);
 		/* Start DCD processing stage 1 */
 		rockchip_chg_enable_dcd(rphy, true);
 		rphy->chg_state = USB_CHG_STATE_WAIT_FOR_DCD;
@@ -862,7 +863,8 @@ static void rockchip_chg_detect_work(str
 		fallthrough;
 	case USB_CHG_STATE_DETECTED:
 		/* put the controller in normal mode */
-		property_enable(base, &rphy->phy_cfg->chg_det.opmode, true);
+		if (!vbus_attach)
+			property_enable(base, &rphy->phy_cfg->chg_det.opmode, true);
 		rockchip_usb2phy_otg_sm_work(&rport->otg_sm_work.work);
 		dev_dbg(&rport->phy->dev, "charger = %s\n",
 			 chg_to_string(rphy->chg_type));


