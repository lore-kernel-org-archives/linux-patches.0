Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3784D33F8AE;
	Wed,  3 Dec 2025 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780571; cv=none; b=KZ8j6lsmQhLDkf6Jfbds/u7zQBHXaC2q+K8gajj+Gi7pasVtDApJQTGYhjIgLFvyBrdgHd7ki0yfDgIaQfZwQH+a1LbFNo/cAGi5iMiTxxN05iW0F0CePwVlfF8XQd+gjN7UDJRr+qrujGdBAjk/JVf7a3RRjbxqu/0flwgPxHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780571; c=relaxed/simple;
	bh=LnQNTYkUxgcqY31g69P04jPVlUlyihX8VfJB6ZCKyK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj1TmZfiF0CkmGlBhSWtnprxK60rUkroDiuOjhA352oJ2WPCgTctSJD0UkMdBbSuoF3djJvrqKKBaKYhJwe6G8Ya7BrlR718WXglrgOZ5KpZYgxhTDTkNrqvCT3LNT9SDLfqk9ww9IH8LNLhPb9X/Lt+5VrnuDEgbpqMD0cTouY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jZYRdQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jZYRdQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3315C4CEF5;
	Wed,  3 Dec 2025 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780571;
	bh=LnQNTYkUxgcqY31g69P04jPVlUlyihX8VfJB6ZCKyK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jZYRdQdTD+sof4ODtgRP/Y7OkZ8lhf3ZY6V0+1Ik3cASmKCflerYpiKiEe9GU3uB
	 0IZEwprRZ1CPkjalufhv6xQ7ixmXlL2hF86cTQK3pv4KyW9S5wJt3NJYUkfpWhJqes
	 HghNB3duVMLQdu1XETS8u1QQ9AWGn7RF6686iyqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/132] net: dsa: sja1105: fix SGMII linking at 10M or 100M but not passing traffic
Date: Wed,  3 Dec 2025 16:28:24 +0100
Message-ID: <20251203152344.232856316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit da62abaaa268357b1aa66b372ace562189a05df1 ]

When using the SGMII PCS as a fixed-link chip-to-chip connection, it is
easy to miss the fact that traffic passes only at 1G, since that's what
any normal such connection would use.

When using the SGMII PCS connected towards an on-board PHY or an SFP
module, it is immediately noticeable that when the link resolves to a
speed other than 1G, traffic from the MAC fails to pass: TX counters
increase, but nothing gets decoded by the other end, and no local RX
counters increase either.

Artificially lowering a fixed-link rate to speed = <100> makes us able
to see the same issue as in the case of having an SGMII PHY.

Some debugging shows that the XPCS configuration is A-OK, but that the
MAC Configuration Table entry for the port has the SPEED bits still set
to 1000Mbps, due to a special condition in the driver. Deleting that
condition, and letting the resolved link speed be programmed directly
into the MAC speed field, results in a functional link at all 3 speeds.

This piece of evidence, based on testing on both generations with SGMII
support (SJA1105S and SJA1110A) directly contradicts the statement from
the blamed commit that "the MAC is fixed at 1 Gbps and we need to
configure the PCS only (if even that)". Worse, that statement is not
backed by any documentation, and no one from NXP knows what it might
refer to.

I am unable to recall sufficient context regarding my testing from March
2020 to understand what led me to draw such a braindead and factually
incorrect conclusion. Yet, there is nothing of value regarding forcing
the MAC speed, either for SGMII or 2500Base-X (introduced at a later
stage), so remove all such logic.

Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251122111324.136761-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f3bb49a9e63c0..a078653531b51 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1303,14 +1303,7 @@ static int sja1105_set_port_speed(struct sja1105_private *priv, int port,
 	 * table, since this will be used for the clocking setup, and we no
 	 * longer need to store it in the static config (already told hardware
 	 * we want auto during upload phase).
-	 * Actually for the SGMII port, the MAC is fixed at 1 Gbps and
-	 * we need to configure the PCS only (if even that).
 	 */
-	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
-		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
-	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
-		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
-
 	mac[port].speed = speed;
 
 	return 0;
-- 
2.51.0



