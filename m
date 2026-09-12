Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD27E3515CB;
	Sat, 12 Sep 2026 11:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212523; cv=none; b=FuZToBOM4k8knWS5WLP7CoY81GH/7ueS1Bstm2TsqS+OqxizzjtjtI446pDkRx/DfZSSqImUaeXtBUJ02Qxe/cam9cMe1h/ebZgZxFjp9WB0L7R77SgsM6Sd+KirbPuD6H+49ydiPvQqAPV4z/6Bd2KBoEEzgmu9jt83ia0OU0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212523; c=relaxed/simple;
	bh=xIMwxKz8Es4P+MQqdxqJqwhq89BNvQUITTlmszIeGec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muiZR0WUMKAKyELsV6+66h3rXxF34NWxb+n1tKUxuStwpfDrKSY/9OpgsGDvWgRqjdLQC6aNjgZ7hm+sMrhIKcTYZ8Eo5ThEPiHHK+sq1oNktGwK4ls5UHhlyDWEPYkPPLY74yqyLA/j+e50VUlWoabjoxwCVoW+0uz8fsttePs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMZrEjyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMZrEjyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57651F000FF;
	Sat, 12 Sep 2026 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212522;
	bh=XxBs906NJB9be3pBVzGvf7UUMviXm4eiPMvQ9lvLu4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMZrEjyf2FGAGBhjR6zRe9hPakZZw6Jr/Ga3MMx9p1WpMZEjhUhFL+ksviGKiwaWz
	 osGYLEV4nr/3HGvIP+fHYVl/dMaqBqjcHUsl8iO7W6teH8d45o2Z8RitmDfeY//VHl
	 4ttvjwt3DhDm9yfkHbjqwvBxqpI62IxVS7G4TYYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1453/1518] net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:00:22 +0200
Message-ID: <20260912065656.423734068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 2739d6f9a2b8729b0d85cbe0dc93e1d68670b6f2 ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-5-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index ee41c77426f1a..42cd0a01a9cdc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -541,7 +541,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.53.0



