Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BD719F485;
	Tue, 27 Aug 2024 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770491; cv=none; b=pRt0H0IQZfwlEuYrxhzEh0NbFxIRKSWRuNoduPEO8t3+pfF4JE7Eqouv8AwddBCRx31IpG4MDuW+Bi/rfY8GZbigNVwDWzK5PchHqSJkdOvwl9gxvrl6dSn8aicUJiznaTpMGQqzmwIAYqVuagyGarAQUhsggolubqK+nBuNOLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770491; c=relaxed/simple;
	bh=ii2uObJYDLT+cb9P+Ky6mJ9ZGjceUxFPpL9xw2QQlbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o18bpOtMR+4tNDeTr3Y0Y3JTQ0TRXQAYzpc6PEVxK529kx5AnM0o++eSGqAj24J/tHlnee1HrMBjIRR31Eiegywegy69OgdA30Ju6VVusBrJNwQn5+hpwGiB1yy3ih8UMCiVLSv8tKptDf8e5KNDKDWD/FmfRS3EXKn2tP6hi5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY35u66U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY35u66U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D5EC4E68D;
	Tue, 27 Aug 2024 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770491;
	bh=ii2uObJYDLT+cb9P+Ky6mJ9ZGjceUxFPpL9xw2QQlbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY35u66UV9FkVcYySEoUmQLco5BpVmdVFtD7AmwzR3yu5kB612jHxkDbo9yKUCuHn
	 9lKPUm9I8mf+1HJqAse+qknPbuYMHRu8ttAQY/f2dmXg2wCykVb0rr9hVNaDhb2Tlz
	 spWOcNhC9cV2M8mQahts6phVlwxLKpBCFKRLkEas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/341] net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"
Date: Tue, 27 Aug 2024 16:37:55 +0200
Message-ID: <20240827143852.694696801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c739124b394b5..4e01abf6cc72c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1208,13 +1208,21 @@ void ocelot_ifh_set_basic(void *ifh, struct ocelot *ocelot, int port,
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
@@ -1225,7 +1233,7 @@ EXPORT_SYMBOL(ocelot_ifh_set_basic);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb)
 {
-	u32 ifh[OCELOT_TAG_LEN / 4] = {0};
+	u32 ifh[OCELOT_TAG_LEN / 4];
 	unsigned int i, count, last;
 
 	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index 87b59cc5e4416..00326ae8c708b 100644
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



