Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8D838CFF4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302385; cv=none; b=sMlpvZaNHW7GH3w82jm7Yjc+Z7CZN6wyukVoDXOsxr+KdQ1c6RGioIDsI18pO1LE6HA7Pgm/Bvr8XEVkwXbh6NKP36LWFxw1Uf+SPRB29mnvlgBQ5HQMImXrA8gsdCbanq6W5ADgkqLjDPDt6DzAzJ9opRsagj5hCoLHBz/tP6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302385; c=relaxed/simple;
	bh=ZMrA7uzQ2simGZTtoTtvGQlaP/h5wgtnsIexAPu5N24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA4Jukh94FEsXlrcqleBdZHmdHIz+Fj7SGgf0x4SYHLXZsIBcG7WMSXnkrD+iGsIu8dp2q7vEhokGOL1JglI5OSaAqYWnlL20wT758d1TkuUiHf804sxLuvrLiv8gQAtVbVdehdXm+7xPYfq8FMPmIyanxJBUpZ9SJa+knrauRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5Rb5xbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5Rb5xbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA4DC116D0;
	Sat, 28 Feb 2026 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302385;
	bh=ZMrA7uzQ2simGZTtoTtvGQlaP/h5wgtnsIexAPu5N24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5Rb5xbtSXQcA8TusIKlJXmQZOrN92nxp+hd5Bz1BfTm1X3AVhiaw6LOS0qTrD48s
	 tt8+HQ9QAFKe5yEpRtkuDixMq2EUplZqM48l+mMB+l96dzvlK3paZC9I4AYRf8xqFL
	 jD8L5A2SGVvNlBySnaEA7qQegac8VbSfOZ04RiCvNP4e5T9j5KlsN+1j65reBmsvnL
	 0kRBznU25MwbrqKl8TnNgzh4L7jjdxD3n78snOxGlxPgNZfJyatPHXYur8c8wj4Jof
	 ShmF5xMar3DPaGWhKQ8mt+47MBPsn81A5VcGkmea6vdjF9VEV0srVlpcissPgfodXJ
	 VvG8CpqacVxHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/232] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Sat, 28 Feb 2026 13:09:26 -0500
Message-ID: <20260228181127.1592657-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 48dec8d88af96039a4a17b8c2f148f2a4066e195 ]

bond_update_speed_duplex() first set speed/duplex to unknown and
then asks slave driver for current speed/duplex. Since getting
speed/duplex might take longer there is a race, where this false state
is visible by /proc/net/bonding. With commit 691b2bf14946 ("bonding:
 update port speed when getting bond speed") this race gets more visible,
if user space is calling ethtool on a regular base.

Fix this by only setting speed/duplex to unknown, if link speed is
really unknown/unusable.

Fixes: 98f41f694f46 ("bonding:update speed/duplex for NETDEV_CHANGE")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260203141153.51581-1-tbogendoerfer@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 71912ddfa7149..113a5504c9ebb 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -712,26 +712,29 @@ static int bond_update_speed_duplex(struct slave *slave)
 	struct ethtool_link_ksettings ecmd;
 	int res;
 
-	slave->speed = SPEED_UNKNOWN;
-	slave->duplex = DUPLEX_UNKNOWN;
-
 	res = __ethtool_get_link_ksettings(slave_dev, &ecmd);
 	if (res < 0)
-		return 1;
+		goto speed_duplex_unknown;
 	if (ecmd.base.speed == 0 || ecmd.base.speed == ((__u32)-1))
-		return 1;
+		goto speed_duplex_unknown;
 	switch (ecmd.base.duplex) {
 	case DUPLEX_FULL:
 	case DUPLEX_HALF:
 		break;
 	default:
-		return 1;
+		goto speed_duplex_unknown;
 	}
 
 	slave->speed = ecmd.base.speed;
 	slave->duplex = ecmd.base.duplex;
 
 	return 0;
+
+speed_duplex_unknown:
+	slave->speed = SPEED_UNKNOWN;
+	slave->duplex = DUPLEX_UNKNOWN;
+
+	return 1;
 }
 
 const char *bond_slave_link_status(s8 link)
-- 
2.51.0

