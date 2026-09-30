Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6410E3C0A15;
	Wed, 30 Sep 2026 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794300; cv=none; b=MXQLYyPCnsrE+Qs0tGkIlniM0MGghgW3aB0lZmPwuTI2XybC0WgnnAp7fl1XOs30a1sfs5CoBAwjxoZkjrle9zryTg7F8zp+cqCv1/whLGwxPqeYL9SPt5ooiMPEatfashMLF5VDdz75NWcFbznFMxYD3IxkQKAlz3ys4GEnFL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794300; c=relaxed/simple;
	bh=UpdcIkKe4Z3q0r7CuSc8q9PVqd+vxq/mWgNXIzL5icM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGWyakl/026u/sCH5m2z3nDQ+j5nYhtlJJqIfh6bcEy/GThTYhc8s7Kxd6WukFQcMniJtc/068Bh5d2qIrjkoYy0x16PaUzM/aGHIuS0FsiOdRif3IDEuLr+7YpB+md6BZqN02LvbbtQTsTVXkePRulvLVgag3pnOa+61nar30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLMwT45M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLMwT45M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD881F000FF;
	Wed, 30 Sep 2026 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794299;
	bh=a/k5pQG2B0dhN6PpCijgQgSZSSmAmL54diO9XTZnhV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLMwT45MD0z30VeDgJ7/nk3W9bRFoLR7iFlIIvGqTLWcB5AxSpOiFxFj9oocceJGd
	 bG+WrXCm8HZy3LUKuURP4y1DgtT+HxADqGHrQ0aOZ4BjNg0obKMjFSIss8SiOZ/8AU
	 qW6hSVtJTmTUALsWc9Gu999l+HzS+KCLacOJW6J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0163/1193] dpaa2-switch: rework FDB management on the bridge leave path
Date: Wed, 30 Sep 2026 17:14:07 +0200
Message-ID: <20260930152437.818130205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit efc1d92eacf03afa6f4d53bf7120e059b6f961f2 ]

On bridge leave, the dpaa2_switch_port_set_fdb() function always
allocates a new FDB for the port which is becoming standalone. In case
no FDB is found, then the port leaving a bridge will continue to use the
current one.

The above logic does not cover the case in which there are multiple
bridges which have ports from the same DPSW instance. In this case, when
the last port leaves bridge #1, it finds an unused FDB to switch to, but
the old FDB is not marked as unused. Since the number of FDBs is equal
to the number of DPSW interfaces, this will eventually lead to multiple
ports sharing the same FDB.

Fix this by changing how we are managing the FDBs on the leave path.
Instead of directly allocating a new FDB, first verify if the current
port is the last one to leave a bridge. If this is the case, then
continue to use the current FDB and only allocate another FDB if there
are other ports remaining in the bridge.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-2-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 501e86e9fd487..a0be969330ef0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -54,27 +54,44 @@ dpaa2_switch_filter_block_get_unused(struct ethsw_core *ethsw)
 static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
 				     struct net_device *bridge_dev)
 {
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct ethsw_port_priv *other_port_priv = NULL;
 	struct dpaa2_switch_fdb *fdb;
 	struct net_device *other_dev;
+	bool last_fdb_user = true;
 	struct list_head *iter;
+	int i;
 
 	/* If we leave a bridge (bridge_dev is NULL), find an unused
 	 * FDB and use that.
 	 */
 	if (!bridge_dev) {
-		fdb = dpaa2_switch_fdb_get_unused(port_priv->ethsw_data);
-
-		/* If there is no unused FDB, we must be the last port that
-		 * leaves the last bridge, all the others are standalone. We
-		 * can just keep the FDB that we already have.
-		 */
+		/* First verify if this is the last port to leave this bridge */
+		for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
+			if (!ethsw->ports[i] || ethsw->ports[i] == port_priv)
+				continue;
+			if (ethsw->ports[i]->fdb == port_priv->fdb) {
+				last_fdb_user = false;
+				break;
+			}
+		}
 
-		if (!fdb) {
+		/* If this is the last user of the FDB, just keep using it. */
+		if (last_fdb_user) {
 			port_priv->fdb->bridge_dev = NULL;
 			return 0;
 		}
 
+		/* Since we are not the last port which leaves a bridge,
+		 * acquire a new FDB and use it. The number of FDBs is sized to
+		 * accommodate all switch ports as standalone, each with its
+		 * private FDB, which means that dpaa2_switch_fdb_get_unused()
+		 * must succeed here. WARN if not.
+		 */
+		fdb = dpaa2_switch_fdb_get_unused(port_priv->ethsw_data);
+		if (WARN_ON(!fdb))
+			return 0;
+
 		port_priv->fdb = fdb;
 		port_priv->fdb->in_use = true;
 		port_priv->fdb->bridge_dev = NULL;
-- 
2.53.0



