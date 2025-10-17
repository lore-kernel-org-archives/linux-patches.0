Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D45695;
	Fri, 17 Oct 2025 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715116; cv=none; b=Ky6JqFn5/DiCNEOxZmiW96MA2cZlUxoGJhT84Uo4sQ4VhUmFbOrHZ5jLuEecP5ySeEKYRDVgoX6kre1zKCQUJLmQrndin16s9rmAq8n+ReqGyxyo5r2+nbhezGgdWulNqLpdWRIuY7AU5jf1g9itF2jpFVToudS2UZ/2kFD5J5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715116; c=relaxed/simple;
	bh=wreVg/ekLFJWuMJ6HaXpFVNOr2djj8BZO9dGX7dwmEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJQOXwv1ZJHyQwmYjHuIF+hrewyo/SSF/GZ083ePXtJVubicf0czcjkqlPUSYtdYO0y7K9T6VJAN+2y7zYiVhGkpGqcWGoGwF2sgXN3wYs5wMKyGsOxSSDdqo0z699lvtuOD8Wfc1BZJGT+3vbil2Rw5xlU4BGF8SBzbfIXJ2vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDucsCdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDucsCdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8915AC4CEE7;
	Fri, 17 Oct 2025 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715115;
	bh=wreVg/ekLFJWuMJ6HaXpFVNOr2djj8BZO9dGX7dwmEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDucsCdHkm1vlWND7+XfpB8E0HygaAHoooQgEtLdPXGae+MvnIaYMMypbQs9H78At
	 G+zZCWPiYAU1OgI+3DJaYLw17ieoFCGg73e2zkQ2Qp1wqYxfy6lzk++cQwPw1BcJRJ
	 s+zJz5IzVm3T3jogDbx8iNceo7X8vVeumttKsHzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 104/371] net: sparx5/lan969x: fix flooding configuration on bridge join/leave
Date: Fri, 17 Oct 2025 16:51:19 +0200
Message-ID: <20251017145205.702569795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit c9d1b0b54258ba13b567dd116ead3c7c30cba7d8 ]

The sparx5 driver programs UC/MC/BC flooding in sparx5_update_fwd() by
unconditionally applying bridge_fwd_mask to all flood PGIDs. Any bridge
topology change that triggers sparx5_update_fwd() (for example enslaving
another port) therefore reinstalls flooding in hardware for already
bridged ports, regardless of their per-port flood flags.

This results in clobbering of the flood masks, and desynchronization
between software and hardware: the bridge still reports “flood off” for
the port, but hardware has flooding enabled due to unconditional PGID
reprogramming.

Steps to reproduce:

    $ ip link add br0 type bridge
    $ ip link set br0 up
    $ ip link set eth0 master br0
    $ ip link set eth0 up
    $ bridge link set dev eth0 flood off
    $ ip link set eth1 master br0
    $ ip link set eth1 up

At this point, flooding is silently re-enabled for eth0. Software still
shows “flood off” for eth0, but hardware has flooding enabled.

To fix this, flooding is now set explicitly during bridge join/leave,
through sparx5_port_attr_bridge_flags():

    On bridge join, UC/MC/BC flooding is enabled by default.

    On bridge leave, UC/MC/BC flooding is disabled.

    sparx5_update_fwd() no longer touches the flood PGIDs, clobbering
    the flood masks, and desynchronizing software and hardware.

    Initialization of the flooding PGIDs have been moved to
    sparx5_start(). This is required as flooding PGIDs defaults to
    0x3fffffff in hardware and the initialization was previously handled
    in sparx5_update_fwd(), which was removed.

With this change, user-configured flooding flags persist across bridge
updates and are no longer overridden by sparx5_update_fwd().

Fixes: d6fce5141929 ("net: sparx5: add switching support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251003-fix-flood-fwd-v1-1-48eb478b2904@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c  |  5 +++++
 .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 12 ++++++++++++
 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c  | 10 ----------
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 74ad1d73b4652..40b1bfc600a79 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -708,6 +708,11 @@ static int sparx5_start(struct sparx5 *sparx5)
 	/* Init masks */
 	sparx5_update_fwd(sparx5);
 
+	/* Init flood masks */
+	for (int pgid = sparx5_get_pgid(sparx5, PGID_UC_FLOOD);
+	     pgid <= sparx5_get_pgid(sparx5, PGID_BCAST); pgid++)
+		sparx5_pgid_clear(sparx5, pgid);
+
 	/* CPU copy CPU pgids */
 	spx5_wr(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1), sparx5,
 		ANA_AC_PGID_MISC_CFG(sparx5_get_pgid(sparx5, PGID_CPU)));
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index bc9ecb9392cd3..0a71abbd3da58 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -176,6 +176,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 				   struct net_device *bridge,
 				   struct netlink_ext_ack *extack)
 {
+	struct switchdev_brport_flags flags = {0};
 	struct sparx5 *sparx5 = port->sparx5;
 	struct net_device *ndev = port->ndev;
 	int err;
@@ -205,6 +206,11 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	 */
 	__dev_mc_unsync(ndev, sparx5_mc_unsync);
 
+	/* Enable uc/mc/bc flooding */
+	flags.mask = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = flags.mask;
+	sparx5_port_attr_bridge_flags(port, flags);
+
 	return 0;
 
 err_switchdev_offload:
@@ -215,6 +221,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 static void sparx5_port_bridge_leave(struct sparx5_port *port,
 				     struct net_device *bridge)
 {
+	struct switchdev_brport_flags flags = {0};
 	struct sparx5 *sparx5 = port->sparx5;
 
 	switchdev_bridge_port_unoffload(port->ndev, NULL, NULL, NULL);
@@ -234,6 +241,11 @@ static void sparx5_port_bridge_leave(struct sparx5_port *port,
 
 	/* Port enters in host more therefore restore mc list */
 	__dev_mc_sync(port->ndev, sparx5_mc_sync, sparx5_mc_unsync);
+
+	/* Disable uc/mc/bc flooding */
+	flags.mask = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	flags.val = 0;
+	sparx5_port_attr_bridge_flags(port, flags);
 }
 
 static int sparx5_port_changeupper(struct net_device *dev,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index d42097aa60a0e..4947828719038 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -167,16 +167,6 @@ void sparx5_update_fwd(struct sparx5 *sparx5)
 	/* Divide up fwd mask in 32 bit words */
 	bitmap_to_arr32(mask, sparx5->bridge_fwd_mask, SPX5_PORTS);
 
-	/* Update flood masks */
-	for (port = sparx5_get_pgid(sparx5, PGID_UC_FLOOD);
-	     port <= sparx5_get_pgid(sparx5, PGID_BCAST); port++) {
-		spx5_wr(mask[0], sparx5, ANA_AC_PGID_CFG(port));
-		if (is_sparx5(sparx5)) {
-			spx5_wr(mask[1], sparx5, ANA_AC_PGID_CFG1(port));
-			spx5_wr(mask[2], sparx5, ANA_AC_PGID_CFG2(port));
-		}
-	}
-
 	/* Update SRC masks */
 	for (port = 0; port < sparx5->data->consts->n_ports; port++) {
 		if (test_bit(port, sparx5->bridge_fwd_mask)) {
-- 
2.51.0



