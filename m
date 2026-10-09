Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7033BBD9;
	Fri,  9 Oct 2026 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555378; cv=none; b=OpgP/lNyagRxw37gH0eC7zGOC+bYmZXB0FWLVUNyx8VzE9LA+l+Ojz7TQw9WOY25Y2JILaAHIpHr/N4xIlBbj+kxQBgmLoN30ysoXkHG6FMbbwsPxQ5m3I0FtMr2T+ikmaBWgs2MZJw6XgZ2RrFQHcAnwmFsFTv5qzn9guLw5WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555378; c=relaxed/simple;
	bh=2gBtqNw0Rk1zzGFOjqrKpLhFLueVyAxWVpLTUGyN6lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNHV5p4xM0XBxyz8shzm8BQK787VJpZYUuPGbcqG7K9SsQDpGEm1YYGLkPMMUWh5WD7Koms+SffqZlBGvfBMHYqtrXbPnTLK+mJV9bFk3YnoLc4LbhbkAkPxNBWgWts3epsXcFq/s8hbww7TW9pVpXRgYQrgBgJESJuVoYjgq74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8ZSyzyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8ZSyzyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4681F00893;
	Fri,  9 Oct 2026 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555373;
	bh=QUcpF3zeuvZipawNCfLjmrH4a1GCEOt9aVSZzW29P/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8ZSyzyUbiPBaYuQyFNCsf47jW4sNi0cPa8rGNSqhDEltwPUZwt9oHVkdPir4rFpO
	 0LvksslMgNxsgSI27yJwvypbjUs38TSP1HJBWgSQTSIE4QUVl1b/1GJqPkay6hDi7U
	 AP0DIzkFJCBEHX8InThowF1XnnL+tRM5OBf2ff1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Piecha <d.piecha@ymail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 036/403] r8169: disable EEE on RTL8168h/8111h
Date: Fri,  9 Oct 2026 16:06:37 +0200
Message-ID: <20261009140952.954115404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5268,6 +5268,12 @@ static int r8169_mdio_register(struct rt
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
 


