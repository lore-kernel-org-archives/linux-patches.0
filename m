Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D2638F627
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302148; cv=none; b=KrlrfT9i1dMQ+PMc4OD0b0yGJH01/vNnWw3gNGJHr608M0g+2vfNvG7J/tMK8sNSlb8iQv0aQXMRC1pSWNmXiNtwaprymByHFQcgG+fxSzyOkQK/i3B2v9vxKleYOiCY8/vmcAA+1KNN6fqiGfiUPocDABvRZ4WdHVBjmGNqkPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302148; c=relaxed/simple;
	bh=+VzC36pG5CZW+3yzq8QCETen+U2eD7288fnpV8u+vhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr4Tz/rDLW8MZBSYxhSPeoSOaARxrO/HqQU1Natmdxs4gomGd4ZYCNvvjVJEk/wmvKKs3tNUFlgb+0ZbJgu5LC4ims4d5tsegx2LA0hQBwK4ucEPgWdiLfC1bf+nCZ9/eKBAUuznG64PqQWSI1ldatvFn9I+bixmmJkPZyLE78U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEc9Yn0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEc9Yn0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766E8C116D0;
	Sat, 28 Feb 2026 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302148;
	bh=+VzC36pG5CZW+3yzq8QCETen+U2eD7288fnpV8u+vhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEc9Yn0mpmLm5IsK6VFumCKG6mlPszBTvxfwCiqIN/0Po4j17ADiNItuMcaLgsKd8
	 QrUVawsbQhBSd1NGNt1cVjOpZ9qXzTXamw84S2CLSAHtUVUrX5v5jsI+sTGNzXOz9f
	 Vxf/z1uzHigfHVHAhFcDhvK/byASnL0pZiR7kcig/gQylYxaAboE7n8N6sV9VcfKid
	 Yz9vTS9ZgikEqazHd/N0DCzo55kgso7aJJ4oI8AGpjnn1beMeG7dyF2mEO4VRJIZys
	 I9Box4EFR9zPMfE0zodyoNvTAEea1SKWm4Se7qi54BHrZytNpXwgk5CrT0X9PgbWu3
	 s9IWKklu4xPhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/283] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Sat, 28 Feb 2026 13:04:44 -0500
Message-ID: <20260228180709.1583486-142-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 4373e300879d9..4f8a59b4ba985 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -727,26 +727,29 @@ static int bond_update_speed_duplex(struct slave *slave)
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

