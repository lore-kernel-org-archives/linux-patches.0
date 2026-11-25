Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624622;
	b=1hH5QJ325ILnm9jJBRo89ymuDnSp4t7Y4cPC8NfzjaDA13MhGVULA0B2ORiIWMv70JVp
	 nvjOC+SOqnw2n48hZnx0Qdhq31I73VNqqBA9fENAC/WCNKl4eFIMOJIOeMfm9qKbroGEY
	 zgSWHXcNzKero2aDcV+U9elvCikxH1VBoNmZajYcu2JsLadR8N671IFZxz/+onf1DID1f
	 4LLaxZWBt2Zt7X0sMr4ptrwmwx82t9t/RU5M+bZnaBJjrCfN501/6tX59NxxKd35YXvcL
	 RBoZZEnvEhQ7OFd4KxSRn0S47xXKqYro5l0y2xmN0S+KeXfe/T8XYIj5i4t8PomfZ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aX42F3FOMHE/hqshoUqQmnO0QfaVvK2LCOrPCRMfRhw=;
	b=DGbhr0egzE24fJSoNgBTCWeOSeCSbI9KVkdVdUHUIk7qwxTNNALM+fpkL7C+PF/XN8cB
	 ou0JKHuJ2FToP7/lLRlrfKNmygR+CJK9DmSe76A3cvinMuJj/9UYclREzpJUESY9LweZS
	 qtk6SD9zHZykUSQ9idNG0ODPC2eRJXJP4j1iqTkH6cGAIhwqTPvEuag/5VPvJSG9WR5UX
	 a2BMDmw9bCP+u53Sqax2wapnOEfc5DjSZVNTo0Ie0RnoYUNzROX1YulxvEWe23bJ5InsO
	 laK/FInbMwUFEqMAhx4eaaDz1GCpd0/W/QhJbBdcgbs5UtV/UZskspKXXnZNeqTYVLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bXDwICU3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E0606A338;
	Wed, 25 Nov 2026 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bXDwICU3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BD51F000C4;
	Wed, 25 Nov 2026 16:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624622;
	bh=aX42F3FOMHE/hqshoUqQmnO0QfaVvK2LCOrPCRMfRhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXDwICU3WwXfltQo/c/bdeymtxWo8c2orV7+Ud24+v92VC2OXh29VzKnxAv7n4F5v
	 z5cYDIle9mx7gYwmFBxNpNXvFeqvDl6C8DRUIfRMZzfy8VLDpX8EVcs5sd6ObFG04z
	 M/yhJN9SrF8OAWVk3nRJyR2ccoCnP8KdV0mcpVWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Stukan <timur.stukan.linux@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/816] bonding: 3ad: dont set BOND_LINK_FAIL on a slave that is not up
Date: Wed, 25 Nov 2026 15:29:34 +0100
Message-ID: <20261125143854.439112161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Stukan <timur.stukan.linux@gmail.com>

[ Upstream commit 9a65b9c2a97594bcaaf393329807653eff895bbf ]

In 802.3ad mode, when bond_update_speed_duplex() fails on NETDEV_UP or
NETDEV_CHANGE, bond_slave_netdev_event() sets the slave link to FAIL if
the slave has ever been up (last_link_up != 0), and to DOWN otherwise,
so that miimon can set it right once speed/duplex are valid.

last_link_up is never cleared, so a slave that is currently DOWN but
was up before is set to FAIL as well. miimon then treats it as a slave
that is still in use and takes it through the full down path again:
the link failure count is incremented, "link status definitely down"
is logged and the 802.3ad port is disabled a second time, although the
slave has not been up since it went down.

Reproduced in 802.3ad mode with miimon=100 by setting a slave down and
up again. On NETDEV_UP the speed is still unknown, so the notifier sets
FAIL, and the next miimon pass sees no carrier and proposes DOWN:

	ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate 1
	ip link set enp0s3 down
	ip link set enp0s4 down
	ip link set enp0s3 master bond0
	ip link set enp0s4 master bond0
	ip link set enp0s3 up
	ip link set enp0s4 up
	ip link set bond0 up
	# wait for LACP to settle
	ip link set enp0s3 down
	ip link set enp0s3 up

procfs then shows "Link Failure Count: 2" in enp0s3 slave part. Also in
dmesg wrote twice: "link status definitely down, disabling slave".

Fix this by setting FAIL only for a slave that is currently UP and
leaving other states alone. An up slave that loses speed/duplex still
goes through FAIL as before, and DOWN/BACK slaves are left to miimon,
as in the other modes.

Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
Signed-off-by: Timur Stukan <timur.stukan.linux@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261101145653.63648-1-timur.stukan.linux@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4c11fcc2a99fa..75332e50fcc51 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4034,18 +4034,13 @@ static int bond_slave_netdev_event(unsigned long event,
 	case NETDEV_CHANGE:
 		/* For 802.3ad mode only:
 		 * Getting invalid Speed/Duplex values here will put slave
-		 * in weird state. Mark it as link-fail if the link was
-		 * previously up or link-down if it hasn't yet come up, and
-		 * let link-monitoring (miimon) set it right when correct
-		 * speeds/duplex are available.
+		 * in weird state. Mark an up slave as link-fail and let
+		 * miimon set it right when correct speed/duplex are available.
 		 */
 		if (bond_update_speed_duplex(slave) &&
-		    BOND_MODE(bond) == BOND_MODE_8023AD) {
-			if (slave->last_link_up)
-				slave->link = BOND_LINK_FAIL;
-			else
-				slave->link = BOND_LINK_DOWN;
-		}
+		    BOND_MODE(bond) == BOND_MODE_8023AD &&
+		    slave->link == BOND_LINK_UP)
+			slave->link = BOND_LINK_FAIL;
 
 		if (BOND_MODE(bond) == BOND_MODE_8023AD)
 			bond_3ad_adapter_speed_duplex_changed(slave);
-- 
2.53.0



