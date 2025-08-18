Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BE3322759;
	Mon, 18 Aug 2025 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525566; cv=none; b=HodtI4W5cV0rUjFROUgycsbZsfOkOG0+6UlCrMZGW4JESR+XSJofb6uw1CqVy1d45fw69VYhTKE71RYPTmkdV+oYDHPc4B4mcJAxAJiXmlTHVz5QIfN4Ng3usS3hjma1aGHbSJ5hcAk1uv90LNS12rBkSmqdWD3srm3iRUIspP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525566; c=relaxed/simple;
	bh=hIQnPhVSCGnTU1PWv6PzhT3LZxluHMiTqaPFiuqD/FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBki0f4yrwAf+tvlX6pR5Zb9+dw+rg8xxiWg7jpQiorHocYkBhnGryG5t0jZp8qPOIeUg5S/U8LVhqFa1kaeGv7+YfN2/pN0P9QCls7QO1oZ7kjmvYhgBJD62Dr7xJA6qgPE5pR/Kkc/9YI7M2tSL5ScD30MKhQjmmkXUZaQGQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7Tpv32n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7Tpv32n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE753C4CEEB;
	Mon, 18 Aug 2025 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525566;
	bh=hIQnPhVSCGnTU1PWv6PzhT3LZxluHMiTqaPFiuqD/FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7Tpv32nxiTdxb+8LAzqZkV8f3aqayZZ6cwWCQWzIulUS4ALk1C90O6wQAWJkib/I
	 2bpwDERY5OzH0gDCR4w9Y9+L9YC/PbvXkZNR8YHLg+bbHlxvoFoJcHg70UkYt0G/Yu
	 hJTeKtnhcgs/b2BidJe07Pl3tfQMyGRqsfahTtU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Braunwarth <daniel.braunwarth@kuka.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 300/570] net: phy: realtek: add error handling to rtl8211f_get_wol
Date: Mon, 18 Aug 2025 14:44:47 +0200
Message-ID: <20250818124517.409587765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Braunwarth <daniel.braunwarth@kuka.com>

[ Upstream commit a9b24b3583ae1da7dbda031f141264f2da260219 ]

We should check if the WOL settings was successfully read from the PHY.

In case this fails we cannot just use the error code and proceed.

Signed-off-by: Daniel Braunwarth <daniel.braunwarth@kuka.com>
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/baaa083b-9a69-460f-ab35-2a7cb3246ffd@nvidia.com
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250624-realtek_fixes-v1-1-02a0b7c369bc@kuka.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index c3dcb6257430..dd0d675149ad 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -436,9 +436,15 @@ static irqreturn_t rtl8211f_handle_interrupt(struct phy_device *phydev)
 
 static void rtl8211f_get_wol(struct phy_device *dev, struct ethtool_wolinfo *wol)
 {
+	int wol_events;
+
 	wol->supported = WAKE_MAGIC;
-	if (phy_read_paged(dev, RTL8211F_WOL_SETTINGS_PAGE, RTL8211F_WOL_SETTINGS_EVENTS)
-	    & RTL8211F_WOL_EVENT_MAGIC)
+
+	wol_events = phy_read_paged(dev, RTL8211F_WOL_SETTINGS_PAGE, RTL8211F_WOL_SETTINGS_EVENTS);
+	if (wol_events < 0)
+		return;
+
+	if (wol_events & RTL8211F_WOL_EVENT_MAGIC)
 		wol->wolopts = WAKE_MAGIC;
 }
 
-- 
2.39.5



