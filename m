Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964C64F7970;
	Tue, 13 Oct 2026 11:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892714; cv=none; b=Y/IZyIoc+Ux0BcTYGuk8R37dTzHf7wv/9c1QkFCdP39vG+3hhm5SulW0ig8+i27tHG24pvJLajrbli0zQUmzpIWcKOP0/Z9K3CZZV6cwIi6VxARgJfUO/wep8WQBGyGsH8vhTScuKKpmHiFfWNgEgvWhCPLNwJsQxnAEZ+Rtyvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892714; c=relaxed/simple;
	bh=uFiysWikCxlzFfMB6eF28I21TtoqLHSy2aHE4zY9P2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlhS1Uj/mclHtfuGNqRUYRLuDdGb09ljuatGxZaG7tG9wbRdrOSbUXJhFlcdpSRUrIaJmnts4LcWbkQ26Bt/ZgP2meG0OgqTLmfHEybWHWY8ziwbFbS2Ebv4POa+3mEMiADy9jlUOGjbfQHW5wOb4uuL7wgCY21VTYr5iJz66k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPYIdbXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPYIdbXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20EA1F008BC;
	Tue, 13 Oct 2026 11:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892713;
	bh=mUrX1+Q2O6DzRMgdI4FzqEbowK+FGbN+ogSw113hKs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPYIdbXgHxDsY9Mai7oNnM48U02ZD0nhiTkqNJdCZ25FLvV2NFxkOpaGg3np0EvL1
	 ZeUNA7eASVmq3FpOcrOGVIanLzENMDkky1jSGO8DodjqmMAm17RpnmIzIG7Iadj/Pv
	 nT2nRhU+D1i8TOk4oiGRaMKrBbf4zRLC3dAPt0V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 221/281] net: stmmac: Do not advertise S-VLAN stripping when it is disabled
Date: Tue, 13 Oct 2026 13:38:57 +0200
Message-ID: <20261013112900.521165917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit c63ce7b9c7e7b68267899e4a0fc14b35d2c1dfcc ]

C-VLAN and S-VLAN tag stripping are both controlled by the EVLS bit,
so disabling rx-vlan-offload also disables S-VLAN tag stripping.
However, rx-vlan-stag-hw-parse keeps being advertised as enabled:

root@rzv2h-evk:~# ethtool -K end1 rx-vlan-offload off
root@rzv2h-evk:~# ethtool -k end1 | grep -i vlan
rx-vlan-offload: off
tx-vlan-offload: off [fixed]
rx-vlan-filter: on [fixed]
vlan-challenged: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: on [fixed]
rx-vlan-stag-filter: on [fixed]

Fix this inconsistency by making NETIF_F_HW_VLAN_STAG_RX follow
NETIF_F_HW_VLAN_CTAG_RX.

Fixes: 750011e239a5 ("net: stmmac: Add support for HW-accelerated VLAN stripping")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260928203441.34876-5-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 034d9f941d402..78e2ad0af6623 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6264,6 +6264,13 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
 		features &= ~NETIF_F_CSUM_MASK;
 
+	if (dwmac_is_xmac(priv->plat->core_type)) {
+		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+			features |= NETIF_F_HW_VLAN_STAG_RX;
+		else
+			features &= ~NETIF_F_HW_VLAN_STAG_RX;
+	}
+
 	return features;
 }
 
-- 
2.53.0



