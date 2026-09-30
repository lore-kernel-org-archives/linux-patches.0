Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6005B51EE1B;
	Wed, 30 Sep 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790896; cv=none; b=WNdhzt+Ih2xjmIP89cL9GayLAt6WDA1szjNZXBmpfswGhBdcWbB9Jnkq0w3tLuXwshRbJeGMdnlTqTDkDgSNX+y7G5Sgr+v/FrSDKctKILQRin9RW2y8YXgELoovelkrxcRgSMUB7L1v8O1CPVY3vngZy5nvdxORy3Eu4az40pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790896; c=relaxed/simple;
	bh=6pTHHNs5uWWxTVEpvzqiwosVXzp6yHVeMHbBQtfaMtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0EOQ+HX5VP56E9SFm1scFCBPYt3jVuIOqNlSAzHgIqwsyzPZrgT+iroGYlObmbQYszWv/8E2L9evtoNYxJzHm8W1jhSQGJPCsgtBbufjv2xQE1SpUfYGxP4/EO+a6+txiu/QPus+VYvOY5R6fC0zwV4eTZssUv4Ygm6sISJxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXFkVs54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXFkVs54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5281F000FF;
	Wed, 30 Sep 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790895;
	bh=GeNjr2jNfxUg5wmFC+aqRfNL+PWumVWTIlTUjsQQ9iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXFkVs54uWHy5MdK9vuKkJTs906SSgXi1ZIlJgwHP50vRln0sxAKF2A2+Lv2KAu1G
	 A+3BskSLLqyjLSizbvKB+rD+lZYpXRAMQ3Gw07hRaYGwzKIRv7uKV+1qO4ZY4wYD58
	 LdTG+VuVCd7rhQNKZ61P7yGlOCwM93WeLQWQXTEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/752] dpaa2-switch: rework FDB management on the bridge leave path
Date: Wed, 30 Sep 2026 17:19:41 +0200
Message-ID: <20260930152400.571684328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d596af27dc0f..9adc21517fd27 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -55,27 +55,44 @@ dpaa2_switch_filter_block_get_unused(struct ethsw_core *ethsw)
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



