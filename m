Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077281509BF;
	Tue, 20 Feb 2024 20:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462733; cv=none; b=APd+Ty3BmQRSllcNT35Jx5H95h3Hqa11E9c3fQeZdJEfK9qhzNwWjo8O3qswKtxhUNst7mfBANZYb0PAuXv0bG3UVzxrcsfrmRSMyLN75fE4IOMMCDSmoBsoC/ZP/7iwQXltBslAwql8lhMqpSZ751NL4XWOjtbDeitegDieM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462733; c=relaxed/simple;
	bh=S9cS7p6M31Q83wEPcn+sPLsiU12BRFTcWxGEV6FfwT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaZ5/SEYu/7DaIebZpkW3xYTdQZV9rXFOAawxwAN88UHlGEJ0u/XXKNoiv5W57TiBJu520ui3DnoErUL7CayaaLF09qxyNQl8TIamuL9xZ6dL2UFhV0tLaCADXZAWchrHWJ42HZCPnhLMM+Omk05sSg5B0Hu1kKUngt9JcFrfFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCU+qa66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCU+qa66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2019C433C7;
	Tue, 20 Feb 2024 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462732;
	bh=S9cS7p6M31Q83wEPcn+sPLsiU12BRFTcWxGEV6FfwT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCU+qa66uGHL5Z57+AeWvP1w7koXtPq6/nc+ouLWi3ErSwjKK88FsIXyAnNsQ7ydq
	 7PxVAKTZY/f9EF8d8Cpp1+/3fVM9I3Sgd2moVVH37EUeEk/Wk57JhxNA4RUeSDpsGG
	 EaAPBDG0g3n+rOXslc5U/F6y/ZPk6QtfefnDWw/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/197] lan966x: Fix crash when adding interface under a lag
Date: Tue, 20 Feb 2024 21:49:39 +0100
Message-ID: <20240220204841.686056258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 15faa1f67ab405d47789d4702f587ec7df7ef03e ]

There is a crash when adding one of the lan966x interfaces under a lag
interface. The issue can be reproduced like this:
ip link add name bond0 type bond miimon 100 mode balance-xor
ip link set dev eth0 master bond0

The reason is because when adding a interface under the lag it would go
through all the ports and try to figure out which other ports are under
that lag interface. And the issue is that lan966x can have ports that are
NULL pointer as they are not probed. So then iterating over these ports
it would just crash as they are NULL pointers.
The fix consists in actually checking for NULL pointers before accessing
something from the ports. Like we do in other places.

Fixes: cabc9d49333d ("net: lan966x: Add lag support for lan966x")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240206123054.3052966-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
index 41fa2523d91d..5f2cd9a8cf8f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -37,19 +37,24 @@ static void lan966x_lag_set_aggr_pgids(struct lan966x *lan966x)
 
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < lan966x->num_phys_ports; ++lag) {
-		struct net_device *bond = lan966x->ports[lag]->bond;
+		struct lan966x_port *port = lan966x->ports[lag];
 		int num_active_ports = 0;
+		struct net_device *bond;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
-		if (!bond || (visited & BIT(lag)))
+		if (!port || !port->bond || (visited & BIT(lag)))
 			continue;
 
+		bond = port->bond;
 		bond_mask = lan966x_lag_get_mask(lan966x, bond);
 
 		for_each_set_bit(p, &bond_mask, lan966x->num_phys_ports) {
 			struct lan966x_port *port = lan966x->ports[p];
 
+			if (!port)
+				continue;
+
 			lan_wr(ANA_PGID_PGID_SET(bond_mask),
 			       lan966x, ANA_PGID(p));
 			if (port->lag_tx_active)
-- 
2.43.0



