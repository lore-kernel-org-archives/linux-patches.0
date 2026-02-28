Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44839B94B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302569; cv=none; b=Y+CGKVtutuDX0Tq2sb4GK/09+2/2NoJTM4a0JwggJso/LBHQPhamrK/6L0jUwp34L9D9rleis+d71FCaw0m0Y1BZPstSlyXQfAUM0EeYBpiyEaXVl4CyQm93wU5hypY78OAO4kZCf0aDi+5IOnqTyZF+DT2rkWLCckhQThQf6Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302569; c=relaxed/simple;
	bh=yna0ggleYMIpJRLmV7662jaAU7XZAH9WxIdX15vTGTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zre0gjndl53NWHPZ4ENClIFlA7DzCkOps6+SLEhicexv8gNe8XnA0dE28STd7WDqNPtWIrmEJkOGKHwZaF9MrrrPaQUe+OmaHwwbVYrfwdklRSK75S9xGBdvbRTB7FBIesvDg0wdBF2uJQyWWfXH3ghVlb5fXh05uxOD3Wy3nr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q18BHudM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q18BHudM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50311C19425;
	Sat, 28 Feb 2026 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302569;
	bh=yna0ggleYMIpJRLmV7662jaAU7XZAH9WxIdX15vTGTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q18BHudMKB/IcQwbzYvagPZzSsmV7ugiLajBXGGR9oUm016nAAnL0JQNi7MpZKjQq
	 iSORq4gzTq0hrQJz2LfuVBQLToPX/Q26tOClBm1uwR3h8Efp/2cdTncrFazapGQj9A
	 FhxJbbLFE1+OP8YKEzLLa6Ni0oiP0N6rfhasaHN15X/s6RZgsCXuRE0PSxM6sStFuX
	 wF/OawzrnUrg/s9n23r+TNpXo0u96cG8vC9D2Sa+Uy3i66StffBANhFYoTH6Ud8iN2
	 +9x4wkBrZlSrVzHwaE1tJEQ+WqxTaPJKIy3FNMcnmhBYek3beZX6XkIY/bjZ5Ql2cX
	 2I2SseFtO2Viw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/164] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Sat, 28 Feb 2026 13:13:34 -0500
Message-ID: <20260228181505.1600663-75-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index e6394fd45f6df..27ed164375411 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -673,26 +673,29 @@ static int bond_update_speed_duplex(struct slave *slave)
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

