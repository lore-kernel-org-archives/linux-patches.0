Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3C146447;
	Wed, 23 Apr 2025 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421989; cv=none; b=i6ncBXINMmw6J50O7Fi8wvafNiT15w8QN2tZxNEfd+NROyZis4+O6HWvuSX1eb1Co2iChl7TAK779fPOPo1iTSLkbAKTde+3yVDNw8Cu0rJg5+996NB/sngaSUWh2qlBw6F/GRjsND3Jfk2PtSoUayCZ2Ywljn0Z9wckZbdz/YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421989; c=relaxed/simple;
	bh=j6UdI4IUo4oGgAc60c8nm6h7snqTnaZbY4XovDW6PoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwak3egGBT93wx2tBRrkuqzwxidy9MUmazQtBjGNTdIekw/yVhKOOAQf18XDR2k00CL3EYSlQhexPaDnsDwKKnD/t4D63Bu/YlhNR39pt5J6T5WrihXoS2GI5K3003rUH2ETZRNiqQlL3XfkqywyCmM4ggtM8xAuCXpceyl/nN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5JLFxb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5JLFxb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAE4C4CEE2;
	Wed, 23 Apr 2025 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421989;
	bh=j6UdI4IUo4oGgAc60c8nm6h7snqTnaZbY4XovDW6PoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5JLFxb2lq6DC3n5Q92p6ttyqIn8iuyjXjYVea0EI5O6d7SNNlzI3IQBi+Mu8hnHq
	 kNXLw6A0TInyEApDbfUdxqs5Vk7ijlTb/LKit/AwYHLxUuscvFf15wqb9+PGTX/tQ6
	 EEv4SbQvj66wSa+INaxBXNGrWcwkmCyzlvZHk0kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/291] net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered
Date: Wed, 23 Apr 2025 16:42:59 +0200
Message-ID: <20250423142632.148287313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c84f6ce918a9e6f4996597cbc62536bbf2247c96 ]

Russell King reports that a system with mv88e6xxx dereferences a NULL
pointer when unbinding this driver:
https://lore.kernel.org/netdev/Z_lRkMlTJ1KQ0kVX@shell.armlinux.org.uk/

The crash seems to be in devlink_region_destroy(), which is not NULL
tolerant but is given a NULL devlink global region pointer.

At least on some chips, some devlink regions are conditionally registered
since the blamed commit, see mv88e6xxx_setup_devlink_regions_global():

		if (cond && !cond(chip))
			continue;

These are MV88E6XXX_REGION_STU and MV88E6XXX_REGION_PVT. If the chip
does not have an STU or PVT, it should crash like this.

To fix the issue, avoid unregistering those regions which are NULL, i.e.
were skipped at mv88e6xxx_setup_devlink_regions_global() time.

Fixes: 836021a2d0e0 ("net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region")
Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414212850.2953957-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 1266eabee0863..2ab2eb2cb47be 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -743,7 +743,8 @@ void mv88e6xxx_teardown_devlink_regions_global(struct dsa_switch *ds)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++)
-		dsa_devlink_region_destroy(chip->regions[i]);
+		if (chip->regions[i])
+			dsa_devlink_region_destroy(chip->regions[i]);
 }
 
 void mv88e6xxx_teardown_devlink_regions_port(struct dsa_switch *ds, int port)
-- 
2.39.5



