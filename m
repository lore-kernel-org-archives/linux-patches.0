Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D519342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301808; cv=none; b=pXt8v1gMIRr5923jxl6Xub/cCSw0wQKElOIzxNW1a1mEqO1NqMlJdKLaA/KPQg5+/1a57pTKESwLy3XeXelHAa4dAOx3xzMiK5+BS69CIOOXQEAlSs+i68Vcccgy02zVS4LDLeS1ZtGW7R5wBSoeaoBjULu/2oSCWYPa4KXJd18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301808; c=relaxed/simple;
	bh=ymiOVPWZ8M20cFnqWUQEv1dW6rTjyuvTX+RM41q/GIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc3lELSG6GjfMl/SPt0Boztvyhy70xg1UhUEbkRwcMLAp1VDUqXLyyqF2MSLIeI+XBhtuZcM2t+Du5TQltvpZpKivYlOfXURuO2UgIb+YtbAnbIVWCnemUtgjQohVFD+FxXFCDX+DBkKQoIAXSkFvMSlzENdAvpbX1E/CwspXBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSZyZYQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSZyZYQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C77C19424;
	Sat, 28 Feb 2026 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301808;
	bh=ymiOVPWZ8M20cFnqWUQEv1dW6rTjyuvTX+RM41q/GIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSZyZYQXQXJt2NUbCdxu2ppbMSXf/PJMuqzQhdeWgjjDQrXfkI/frj66pESc+rAkT
	 uwlsL7lM0rSHJboH44sweqvYTUzfsPTKCjJ7pFfm7lqrbP9LitSrXoqzmTBgE6E3BX
	 maH10zDr2xagQvujndL7PJ/xaXDd2+sDHbrHtapFC2pCVzOp0n6Ugkp3GVkPnOqfGL
	 73URlVoQNKXAn9SQuEi4Co6VUR7scu8OxhiMZCwD2TmGHkns134oSxdWehk8iBdvQw
	 PY8Ts+PJ1mVMfM2qfEM6KnJDpqKikm60O7RgM3ob2uy243GvZMY8J+MeE14/evb8EU
	 jO48gZC2hqJLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/385] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Sat, 28 Feb 2026 12:57:23 -0500
Message-ID: <20260228180011.1568201-221-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 209cab75ac0a5..95456a753b184 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -803,26 +803,29 @@ static int bond_update_speed_duplex(struct slave *slave)
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

