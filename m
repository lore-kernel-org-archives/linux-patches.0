Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6CF4E532E;
	Fri,  9 Oct 2026 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555642; cv=none; b=QC5mb3L39GLABU67bseBTCmTPWiTwhwBUWq90FZr8IfyfXrmaU+8U1D6nTFz8et+6jQsNc77E4SbwTLK/ozi1bnoWIA5/1ucNpHZfl1+KzEmcxLvH4qpBW0CdefWt667NVMRQeDmERXv3BeropZKNna/dP64gwFPbQkvI+cKF7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555642; c=relaxed/simple;
	bh=O6Dhn/TNWtwySpmrYNwUDYKH9SWe7yRsMAj2W4WwEuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTWsZKServC/QJVMWSmbtfopYzYr3xNjg10eI296JNExElKzobjBYBovSH16ZWQ5ygdxolhodSg8hhQqstnclphL2WNjhTCu6/hEELP753TSYHz18Mx2ZotZrYIOvBJXKbxtAm+sML3fKkCqfmtMvW2xfdRFrIrR2gbMNIZDo0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPFId5Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPFId5Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E4C1F00899;
	Fri,  9 Oct 2026 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555637;
	bh=HFJz/zJjSkgscdOLW/R88G6CuNqzvaJ3w4ARevZwRFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPFId5ShlHvDCfp1BfXBMiDjGo0LH+ht1sC+UL687T154meyZL1CGFQuJIpxR9NXJ
	 0dJDqR1BJ3AjQNGbDyw5z4Jk41r9hBUSuDLqboOt6ho5fDAsgV3TPGXXZfuj3iyZ1E
	 mtI9d0ki1uP+SSnwChfc9sTUeq3Ox+yQJymuT7QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Piecha <d.piecha@ymail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 041/428] r8169: disable EEE on RTL8168h/8111h
Date: Fri,  9 Oct 2026 16:06:18 +0200
Message-ID: <20261009140947.000131302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 3cdeaef1754ab8155cdd828c958ada3d36e9ad9a upstream.

Force EEE off on the RTL8168h/8111h (RTL_GIGA_MAC_VER_46) at PHY connect
with phy_disable_eee().

Commit 202fef9bbbf5 ("net: phy: realtek: fix EEE advertisement write on
the internal PHY MMD path") made EEE actually advertise on the generic
Realtek PHY; the write had been a no-op before. On the RTL8168h that
un-masks a latent defect: once EEE negotiates, RX silently stalls after
~7-20 minutes. The carrier stays up, no counter or dmesg moves, and only
"ip link set down/up" recovers it; disabling EEE keeps the link stable.

Root-causing the RTL8168h LPI/RX path needs hardware not available now, so
disable EEE for this version. Use phy_disable_eee() rather than dropping
the version from rtl_supports_eee(): the latter also skips
rtl_enable_tx_lpi(), whose disable branch clears the MAC TX-LPI bits (ERI
0x1b0[1:0]) on link up. rtl_hw_start_8168h_1() does not clear them (the
RTL8402/RTL8106e init does), so a warm reboot from an EEE-active state
could otherwise leave TX-LPI asserted while the PHY no longer negotiates
EEE. Keeping the version EEE-capable preserves that clear path. This also
covers the RTL8168M, which shares RTL_GIGA_MAC_VER_46.

Reported-by: Dennis Piecha <d.piecha@ymail.com>
Closes: https://lore.kernel.org/all/353419280.954808.1790290283530@mail.yahoo.com/
Fixes: 202fef9bbbf5 ("net: phy: realtek: fix EEE advertisement write on the internal PHY MMD path")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260925071040.2137178-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5484,6 +5484,12 @@ static int r8169_mdio_register(struct rt
 		phy_disable_eee_mode(tp->phydev,
 				     ETHTOOL_LINK_MODE_2500baseT_Full_BIT);
 
+	/* Keep EEE off but the version stays EEE-capable so that link-up
+	 * still clears the MAC TX-LPI bits.
+	 */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_46)
+		phy_disable_eee(tp->phydev);
+
 	/* PHY will be woken up in rtl_open() */
 	phy_suspend(tp->phydev);
 


