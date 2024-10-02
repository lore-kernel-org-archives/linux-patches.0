Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E91D0DC1;
	Wed,  2 Oct 2024 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877518; cv=none; b=kX4OVZbRSbtUdzWwspTSEU/MMGe7J+Xf9+SQz3kJ7Yq2Mep17d1+OEZW1bigtVA43Rm7dySJNn1tkHoMqjMi2dBm+gFQ0NoJeJ4fnCqKGQ8IpbEaUTlFB7LmvhdB3I3mph5osLJ2B58StpSZvQwoHVJtXO5inY/tfns3ILB6lj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877518; c=relaxed/simple;
	bh=CI+QYNK/NmyjacNgN7DZUqqpXno5xM5HFi30wElU2OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFoXc9ZMWaLVwmYvcX2u9fCAwZv589Mza3kDw6YK5DsGhgB/DZVu8kP5VbHK7qf1BTl+opi8H5XCyHh3/oYl5Wehc21SSBd/GN1dDK9UgoaXUw1A0kIcyWNsd6Cao3FXAQkTeTqWfS1MgdOTMVxp/ZmbPkoitUpH+Q2ZBPLkVcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiYeFdcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiYeFdcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D22EC4CED3;
	Wed,  2 Oct 2024 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877517;
	bh=CI+QYNK/NmyjacNgN7DZUqqpXno5xM5HFi30wElU2OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiYeFdclL2xTsJHSDAEgE/wNlhwwWSweEyf9W3OVGNqasVDJoc5sfeLoTEreKt9w2
	 aANrcHglKD0EtFujY+tqjegPhaEK4l6Bcwczcdel3nFc9qDsSRG1S6t3jBJhcPuBIi
	 Kz26dxwuazt+tizJtboYvDgsHgjssvRSK388RwWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei WU <en-wei.wu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 098/634] r8169: disable ALDPS per default for RTL8125
Date: Wed,  2 Oct 2024 14:53:18 +0200
Message-ID: <20241002125814.978242472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit b9c7ac4fe22c608acf6153a3329df2b6b6cd416c ]

En-Wei reported that traffic breaks if cable is unplugged for more
than 3s and then re-plugged. This was supposed to be fixed by
621735f59064 ("r8169: fix rare issue with broken rx after link-down on
RTL8125"). But apparently this didn't fix the issue for everybody.
The 3s threshold rang a bell, as this is the delay after which ALDPS
kicks in. And indeed disabling ALDPS fixes the issue for this user.
Maybe this fixes the issue in general. In a follow-up step we could
remove the first fix attempt and see whether anybody complains.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: En-Wei WU <en-wei.wu@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/778b9d86-05c4-4856-be59-cde4487b9e52@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 1f74317beb887..e1e5d9672ae44 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1060,6 +1060,7 @@ static void rtl8125a_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	rtl8168g_enable_gphy_10m(phydev);
 
+	rtl8168g_disable_aldps(phydev);
 	rtl8125a_config_eee_phy(phydev);
 }
 
@@ -1099,6 +1100,7 @@ static void rtl8125b_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xbf8, 0x12, 0xe000, 0xa000);
 
 	rtl8125_legacy_force_mode(phydev);
+	rtl8168g_disable_aldps(phydev);
 	rtl8125b_config_eee_phy(phydev);
 }
 
-- 
2.43.0



