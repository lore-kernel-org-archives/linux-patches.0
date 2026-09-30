Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C275450AC08;
	Wed, 30 Sep 2026 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784408; cv=none; b=RzrSuLDbPMwWh6QIcnw9bFvzzgdug0yOI5UxaRriflVz86Vuwbq/kb5SYTsL4IrWcBspRRXrE8qPAwDl3er2qVyzfhY+wdF15FWbzmzZGiT1DhJi7R9QEr54U/fAS29v0uK7FrJz/KbO0ZNtqhA2iAc7ZyPHDdZwmORUn0jb0Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784408; c=relaxed/simple;
	bh=fT7Hz9ZpJkR9M0NTDXLHndSHYCJvzaEmZmfdF2U+nQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAxbVuM/XkvNkuy6HphGdsi3VMffrLKrTiZ5MNryglgPmFSpKzInjxZzGNzbAk7wU9iezsUQTxEyE3G0o42q21zS0RW2yOEH0pG7T6jRiwkGlyCc4BMn50cUbQsdVBKCblyYQHqfN/I4ECl/zSv3NJRx8WYxvf5Z1yM/gRhCoMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6/eLOdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6/eLOdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E761F00893;
	Wed, 30 Sep 2026 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784405;
	bh=W6qKQ17Ox+2nORLDVLHpGA6yEqu9TUz7Aw7mkSnnANM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6/eLOdkpqAkgJWRwDP7z0QuLK0jHGGgvb8ojRJWep7Zx23pWGcZEBtAnJQasP+F/
	 2nrhiQIF4/3k1A1i7ZWnpK7iJ+UMKh2wvooz9VK1OCbqZ2YeYDtDqLoJpxJ9knQgIB
	 tCDZ/8tDsbM+rIrZFpCsn8no9ZrPuY9L/DOWwYV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/982] dpaa2-switch: rework FDB management on the bridge leave path
Date: Wed, 30 Sep 2026 17:14:40 +0200
Message-ID: <20260930152419.911468163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7c3466f52c4..763fc85c8d46c 100644
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



