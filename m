Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5360841C69;
	Tue, 11 Nov 2025 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823842; cv=none; b=S3cE0d+cYFnMRj+3ydJQ+ktmNza9vC2pZO1y7KggtYV/VMxYZ7lFi/at3pqXWnWpRV0lVDZyfIzsSk0C6fTUJEK9QxURhqr+GIsDpp4nrwK/OyFYZCAzLQmZyavlO9KCutsypM4zZKGtyO8ebMA9e5UzZU/mkjBJ/k9c3OcJwVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823842; c=relaxed/simple;
	bh=h8o/pBIubkhRf6MxzF3ko6JdarLQ8ZJuzzGQfjVOluc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UAQ2H4gC2uk/nEL9pzrQiMiXO0nsfBvArbJUMYb0QINcxL/I9J/dC6rTjdojpQAzPNpov8WHFx+MpJMKOziX9h5TYHlK0qqEbh2iK5X+qRyU2oExHfOFtIT/Zw4P8QO7WTCu602tZoX2G2A/4h69IdS83qvwUoirI9cfHyjwxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFNC44cX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFNC44cX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74C0C113D0;
	Tue, 11 Nov 2025 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823842;
	bh=h8o/pBIubkhRf6MxzF3ko6JdarLQ8ZJuzzGQfjVOluc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFNC44cXkoWddaiPhHt2IH8F7/vACiZ1yxlwvPm8TNzG8xty8AO8+wz3i6eV+bMM1
	 6MqHI+nXk1GBbR1EiZXoQG3BtIJEZXVv0gePIuF2/rRWGq3NIUmyZZ99iQmSRBwBbY
	 Gyts+MkjA7S7QoPUn8reJ2Ajqj4iNbYeCqHjZUwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Andrew Lunn <andrew@lunn.ch>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/565] net: sh_eth: Disable WoL if system can not suspend
Date: Tue, 11 Nov 2025 09:43:11 +0900
Message-ID: <20251111004534.416991721@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 9c02ea544ac35a9def5827d30594406947ccd81a ]

The MAC can't facilitate WoL if the system can't go to sleep. Gate the
WoL support callbacks in ethtool at compile time using CONFIG_PM_SLEEP.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250909085849.3808169-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index bc12c0c7347f6..b7adbd4f357e5 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2360,6 +2360,7 @@ static int sh_eth_set_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static void sh_eth_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
@@ -2386,6 +2387,7 @@ static int sh_eth_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 	return 0;
 }
+#endif
 
 static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.get_regs_len	= sh_eth_get_regs_len,
@@ -2401,8 +2403,10 @@ static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.set_ringparam	= sh_eth_set_ringparam,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+#ifdef CONFIG_PM_SLEEP
 	.get_wol	= sh_eth_get_wol,
 	.set_wol	= sh_eth_set_wol,
+#endif
 };
 
 /* network device open function */
-- 
2.51.0



