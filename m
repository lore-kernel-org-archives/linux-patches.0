Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F241A554;
	Mon, 31 Aug 2026 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183244; cv=none; b=CP0O2h5I9EbeJxXEf+aVHQiLtQYFvlp4SjLOct5oJEN1A6frFVW6R9Xuga2f8HY3EiQRvmSuPp97kP3nGzDON9gtd4vCNO5NpxMd363EKsHi6pRSXQkwJqEu6RjokvhTiKbfkdO4niuuPSIYKcASAuV8aZ+FnXWu2D7SkBL7q1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183244; c=relaxed/simple;
	bh=OsGMz0CZ+j/bgM1HlRUPTCF4453HF9QkNkNR9NaBSxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+mcI0YhHbwUeFTWYgBYSbavLjIHtAC7tt7ME8BQq2F5dJhxi/ZWooLOtUNv2mJ2iQwgJg9L+v+atG/ELlW8DVwrxGkpQhjKkQq+i4fwfS5rsAldrrz1SR0MBjarPLZFoWepNZoV5J5+Z867u+WQ8T1B6ZsZX4WqCXPwKaaFvaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2Qfp9CU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2Qfp9CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1451F00ACA;
	Mon, 31 Aug 2026 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183242;
	bh=yv8omFqsKMtAuNj3xSIiZQaCiHeQWc1AE+uWCmFVbio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2Qfp9CUdj6WzMrqqZdyb9v/ehYDXbzFzAPxSlgva9G/uJJ92+hyHs8/LMfPi5r1z
	 Vqo/iOoVNrQpBTKVBC9Gbl5WTdHtY/bOcqThd2rAaDeSuI7U0zTwPFRhowO+5DGLyp
	 zxHDJEcYH8tHg83T26lZ72d3TmKMUtIdrb4B+TrL9cAFf/6EMSqW73reXP1ufTNQrI
	 CQUjYV+CY3LItmy/bnC0nWFrBVMFYNliNk0LNdWZNzDcLa5Kl4QJjUTh0RBA2VMyfM
	 U87ScEdEiIKDLtNkDsOg4dnbs9NrdVsQWTvlvIBzIZALrQI6757XGSksAbPl38fsED
	 dwDCJGLRRXKCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] dpaa2-switch: rework FDB management on the bridge leave path
Date: Mon, 31 Aug 2026 09:20:58 -0400
Message-ID: <20260831133314.4125787-30-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The related-commit search finished. It found no existing “rework FDB
management” fix in this tree; the closest dpaa2-switch FDB commit is
`71150d9447c0f` (“cleanup the egress flood of an unused FDB”). The other
hits were unrelated DSA mv88e6xxx FDB work.

That matches the earlier analysis: the buggy leave-path logic is still
present in 6.18.44, and this patch is a standalone fix worth
backporting.

**YES**

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 846300b77e8ac..13e9e0f34a1b9 100644
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

