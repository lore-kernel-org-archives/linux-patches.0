Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119D3355055
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302717; cv=none; b=lBuMRF0d1JBqYEcDQ8PD+QWSVl92sjZ4wBnsgeFt39X++vdpsP3sGtSzMCFDdibW7gdczpmZmrji7M5Av0XFyncKMTI5uwLTMBGuaTMbh15DK7V4O1NaCOs7Z8AXR5XumS09Uce3cdJ/oH0pxzs9hwK254yB5PC+Kp9G2numGZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302717; c=relaxed/simple;
	bh=IalDYb15xOuJp6N6GbMCNM35Jzn/FIITYO1Wli1yrp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKDYabG/65QIgEB3hcBK5qbYIG8ujybOxdmKPV/Rxt7HzgcphIQCcRvYUSnkKsPbkC/aqc9ToxOhQByCNJd5pozMlERKRA5NuP59vQ4wQg0IPlLFnrqgDMXdN+oMEIhABEZB1CQuJFillUEGPqsvHEC4nDVh7GHybKA5ZVAkCwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StQh+jk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StQh+jk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C9BC19425;
	Sat, 28 Feb 2026 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302717;
	bh=IalDYb15xOuJp6N6GbMCNM35Jzn/FIITYO1Wli1yrp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StQh+jk+INAOzj/IKsBo99y5k7YYEPt1X68iNXw0Vmy/zwMyPCGZAk2u1rSMMz6DY
	 dkgAfbq4PGL5zo1vgLzdp/OUMzLVlrG/vqltAbTmkgM3pad99X3EZ2lEZ1ZOfHQshJ
	 SKFEP5z6TeuT1PUIGwmyTxjn7iVIs1IPthKPL/xZTPUUIpLHT9M2CWwsilX5HAfAT/
	 X5ktVdfdHpZjAbF9nqN1mQh+OzJc5WbdQVNTXnGLx3DXVoQDRZzKlDPYSPTl0qi8Cn
	 kOerVrYrqwD7EBGBrxYwo08KGgc81Xp8zphvSFWibi2jbvgbbjxIiV+msFJGO+4EBW
	 xvSmr9EbroDKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/147] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Sat, 28 Feb 2026 13:16:24 -0500
Message-ID: <20260228181736.1605592-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index a6d552a83ca43..1d8a6690527aa 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -638,26 +638,29 @@ static int bond_update_speed_duplex(struct slave *slave)
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

