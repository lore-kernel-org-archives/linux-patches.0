Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C9A1CE706;
	Tue, 27 Aug 2024 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772472; cv=none; b=r7JXkhXD3brOMQQBFqDxcOjhJXslrRw+Q47CBafC40ThHyqBCn+gu54SIGPoivMH3XwMSEk4XJVj6hOpsn3tqELUoj5jeHNVF46H4MK9pc1YaG2y1CC10Y18uYbY8Dn7/iSKru0kg9/Siu7q5K6wOHfOEs0Q802BzeFZ5byDBpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772472; c=relaxed/simple;
	bh=tM4yoYdAoaNtu2B4InfX48h3+5OR67gurj9//ngZPrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et4YQuiyEMTk6N2Ep0Q0tST5YWAA0QruC1xPv6epyHb2HMU36cahn67vtb28ot+JaOYK/nOhQKwJnXyoFPS3d07fcPU9dR4SxePIHQJozmjmbEAJZLe5dc3llfegaegh6wOZdVR/liF0PjiGkF+mfBLvfWt2uAvtyxHYVqBKNB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zm59FS6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zm59FS6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32B9C61040;
	Tue, 27 Aug 2024 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772472;
	bh=tM4yoYdAoaNtu2B4InfX48h3+5OR67gurj9//ngZPrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zm59FS6eTUQ7I9Gui+PEDCSagpIuGuLag2cxXJDBJo6f78wL+PscnBPk6w/eBkOXa
	 hufG9HT3+lA61UO6j0ta4u35jMthSfEJrzJXPjyypIAQGQjGDtA+3CpVPzJf4q/pYe
	 BrRlD5+fsS/c03Hz0sD1tqnNcbOgUbKyJ0uhJxXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/321] net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"
Date: Tue, 27 Aug 2024 16:38:53 +0200
Message-ID: <20240827143846.796310901@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e1b9e80236c540fa85d76e2d510d1b38e1968c5d ]

There are 2 distinct code paths (listed below) in the source code which
set up an injection header for Ocelot(-like) switches. Code path (2)
lacks the QoS class and source port being set correctly. Especially the
improper QoS classification is a problem for the "ocelot-8021q"
alternative DSA tagging protocol, because we support tc-taprio and each
packet needs to be scheduled precisely through its time slot. This
includes PTP, which is normally assigned to a traffic class other than
0, but would be sent through TC 0 nonetheless.

The code paths are:

(1) ocelot_xmit_common() from net/dsa/tag_ocelot.c - called only by the
    standard "ocelot" DSA tagging protocol which uses NPI-based
    injection - sets up bit fields in the tag manually to account for
    a small difference (destination port offset) between Ocelot and
    Seville. Namely, ocelot_ifh_set_dest() is omitted out of
    ocelot_xmit_common(), because there's also seville_ifh_set_dest().

(2) ocelot_ifh_set_basic(), called by:
    - ocelot_fdma_prepare_skb() for FDMA transmission of the ocelot
      switchdev driver
    - ocelot_port_xmit() -> ocelot_port_inject_frame() for
      register-based transmission of the ocelot switchdev driver
    - felix_port_deferred_xmit() -> ocelot_port_inject_frame() for the
      DSA tagger ocelot-8021q when it must transmit PTP frames (also
      through register-based injection).
    sets the bit fields according to its own logic.

The problem is that (2) doesn't call ocelot_ifh_set_qos_class().
Copying that logic from ocelot_xmit_common() fixes that.

Unfortunately, although desirable, it is not easily possible to
de-duplicate code paths (1) and (2), and make net/dsa/tag_ocelot.c
directly call ocelot_ifh_set_basic()), because of the ocelot/seville
difference. This is the "minimal" fix with some logic duplicated (but
at least more consolidated).

Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c      | 10 +++++++++-
 drivers/net/ethernet/mscc/ocelot_fdma.c |  1 -
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b594f3054afb6..ad179a9dca61a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1103,13 +1103,21 @@ void ocelot_ifh_set_basic(void *ifh, struct ocelot *ocelot, int port,
 			  u32 rew_op, struct sk_buff *skb)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct net_device *dev = skb->dev;
 	u64 vlan_tci, tag_type;
+	int qos_class;
 
 	ocelot_xmit_get_vlan_info(skb, ocelot_port->bridge, &vlan_tci,
 				  &tag_type);
 
+	qos_class = netdev_get_num_tc(dev) ?
+		    netdev_get_prio_tc_map(dev, skb->priority) : skb->priority;
+
+	memset(ifh, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_bypass(ifh, 1);
+	ocelot_ifh_set_src(ifh, BIT_ULL(ocelot->num_phys_ports));
 	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
+	ocelot_ifh_set_qos_class(ifh, qos_class);
 	ocelot_ifh_set_tag_type(ifh, tag_type);
 	ocelot_ifh_set_vlan_tci(ifh, vlan_tci);
 	if (rew_op)
@@ -1120,7 +1128,7 @@ EXPORT_SYMBOL(ocelot_ifh_set_basic);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	u32 ifh[OCELOT_TAG_LEN / 4] = {0};
+	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index e9d2e96adb229..cc9bce5a4dcdf 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -665,7 +665,6 @@ static int ocelot_fdma_prepare_skb(struct ocelot *ocelot, int port, u32 rew_op,
 
 	ifh = skb_push(skb, OCELOT_TAG_LEN);
 	skb_put(skb, ETH_FCS_LEN);
-	memset(ifh, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_basic(ifh, ocelot, port, rew_op, skb);
 
 	return 0;
-- 
2.43.0



