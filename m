Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F5F2C0263;
	Wed, 25 Feb 2026 06:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002568; cv=none; b=QXtsqvc+MbAuQRLbkfURcTkymObk/+QSkm1Rx2NZF0uULs39HJXPumhwlTC5QqjCDj/JlmJ7M6XnV6In6w4efO/ZyQybSl7Iv+KP/Z++V8GPE1Zw7Alp741YHotmrnU1ySpgLuMiXIb1RlkGaukUGgCXtdIuml0385fCgL/OZdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002568; c=relaxed/simple;
	bh=0gxwDgmgAvSxE5hFBDS56yr8sPxo0GLNHrEBKhn3ChM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCfRaQiRhgWDJTg0TiRgryWnoB5yN1romHwviSEl37gMgWaszQEVB9BZBopUCMkoquTLUfMN2LXnWYLGkD1H9k5+fBh80A5udZrDVZHIe0Z79YMgNvpQbH8+D006elbZK3JtVx0P/oWeuW0y7YwGcUmqzAnjBjZNH1jkbyiPObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjPEGfWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjPEGfWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEA7C19422;
	Wed, 25 Feb 2026 06:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002567;
	bh=0gxwDgmgAvSxE5hFBDS56yr8sPxo0GLNHrEBKhn3ChM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjPEGfWnG9cdG5+kHlnQsGy/eTsLsyDWpatWfJ6lBU7rJS9h7nWWaPiB6wwc8O+kN
	 bkZswQuICsunM058ltYDCUKBHm5MQPqz2Z9r/snNpzw63oKPth2KsV0uDmYOieU6Vg
	 ZIRy60h8iShE5WUSyb2X6YwXa0B+0h3vd+f5q96M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/641] bonding: only set speed/duplex to unknown, if getting speed failed
Date: Tue, 24 Feb 2026 17:20:27 -0800
Message-ID: <20260225012356.039411398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 51733fb29bd77..166dff47a029f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -791,26 +791,29 @@ static int bond_update_speed_duplex(struct slave *slave)
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



