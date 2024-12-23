Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A37E0FF;
	Mon, 23 Dec 2024 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969800; cv=none; b=KDQToMd8xz6qwyd21LDKuZ9rOBmUlLfmUi/VG6Ln0o/o7NlPbTFR+hcAABIdPF/Nw1S9I4oLCavidAJqRD5mZGQzwE0e4G2yYDuNlyv8ut+uKB4YOWq89R2ukwMJHLU6oyUfldC/fw24nBJSTGcf08aYsD9+vH8L+YzbHC3SCSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969800; c=relaxed/simple;
	bh=MQnGHd+sWzoED2f0g171zvOSuYuUNCDiRd+DyZ8+yNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh5G1O1zGRT1P65uLpFYazNNu+Hz6SWYZGcy+mOpxq322bKzF+0izVOZdLoqFxJaN6xcDZA45b3h0n7VTtJcWnE6DGC2l8YwZPhoFLLzt5KAo+StLOmjyVnqmtzbRlPaMJ601Gq163aa22vczROlxGKHsdsmegqvJwxC9K+Hf/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBQTEHDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBQTEHDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D8BC4CED3;
	Mon, 23 Dec 2024 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969800;
	bh=MQnGHd+sWzoED2f0g171zvOSuYuUNCDiRd+DyZ8+yNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBQTEHDCDuR/4dsvqVp55kBQZOwEalWibdHcbkr1vcWdLu61og1xvzd3wsGbf5jTU
	 4eiHTzAW/+zzy9kbDeXnvUqSYj8SKC3iRJmFuMIcEdqeH5/k7YbtqPrVgh+NqYSEsE
	 w8X9wDBvLMGryW5CfKPWi68WNND+1ixBz4Tt+SzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hodaszi <robert.hodaszi@digi.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/160] net: dsa: restore dsa_software_vlan_untag() ability to operate on VLAN-untagged traffic
Date: Mon, 23 Dec 2024 16:57:50 +0100
Message-ID: <20241223155410.959309519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 16f027cd40eeedd2325f7e720689462ca8d9d13e ]

Robert Hodaszi reports that locally terminated traffic towards
VLAN-unaware bridge ports is broken with ocelot-8021q. He is describing
the same symptoms as for commit 1f9fc48fd302 ("net: dsa: sja1105: fix
reception from VLAN-unaware bridges").

For context, the set merged as "VLAN fixes for Ocelot driver":
https://lore.kernel.org/netdev/20240815000707.2006121-1-vladimir.oltean@nxp.com/

was developed in a slightly different form earlier this year, in January.
Initially, the switch was unconditionally configured to set OCELOT_ES0_TAG
when using ocelot-8021q, regardless of port operating mode.

This led to the situation where VLAN-unaware bridge ports would always
push their PVID - see ocelot_vlan_unaware_pvid() - a negligible value
anyway - into RX packets. To strip this in software, we would have needed
DSA to know what private VID the switch chose for VLAN-unaware bridge
ports, and pushed into the packets. This was implemented downstream, and
a remnant of it remains in the form of a comment mentioning
ds->ops->get_private_vid(), as something which would maybe need to be
considered in the future.

However, for upstream, it was deemed inappropriate, because it would
mean introducing yet another behavior for stripping VLAN tags from
VLAN-unaware bridge ports, when one already existed (ds->untag_bridge_pvid).
The latter has been marked as obsolete along with an explanation why it
is logically broken, but still, it would have been confusing.

So, for upstream, felix_update_tag_8021q_rx_rule() was developed, which
essentially changed the state of affairs from "Felix with ocelot-8021q
delivers all packets as VLAN-tagged towards the CPU" into "Felix with
ocelot-8021q delivers all packets from VLAN-aware bridge ports towards
the CPU". This was done on the premise that in VLAN-unaware mode,
there's nothing useful in the VLAN tags, and we can avoid introducing
ds->ops->get_private_vid() in the DSA receive path if we configure the
switch to not push those VLAN tags into packets in the first place.

Unfortunately, and this is when the trainwreck started, the selftests
developed initially and posted with the series were not re-ran.
dsa_software_vlan_untag() was initially written given the assumption
that users of this feature would send _all_ traffic as VLAN-tagged.
It was only partially adapted to the new scheme, by removing
ds->ops->get_private_vid(), which also used to be necessary in
standalone ports mode.

Where the trainwreck became even worse is that I had a second opportunity
to think about this, when the dsa_software_vlan_untag() logic change
initially broke sja1105, in commit 1f9fc48fd302 ("net: dsa: sja1105: fix
reception from VLAN-unaware bridges"). I did not connect the dots that
it also breaks ocelot-8021q, for pretty much the same reason that not
all received packets will be VLAN-tagged.

To be compatible with the optimized Felix control path which runs
felix_update_tag_8021q_rx_rule() to only push VLAN tags when useful (in
VLAN-aware mode), we need to restore the old dsa_software_vlan_untag()
logic. The blamed commit introduced the assumption that
dsa_software_vlan_untag() will see only VLAN-tagged packets, assumption
which is false. What corrupts RX traffic is the fact that we call
skb_vlan_untag() on packets which are not VLAN-tagged in the first
place.

Fixes: 93e4649efa96 ("net: dsa: provide a software untagging function on RX for VLAN-aware bridges")
Reported-by: Robert Hodaszi <robert.hodaszi@digi.com>
Closes: https://lore.kernel.org/netdev/20241215163334.615427-1-robert.hodaszi@digi.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241216135059.1258266-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/dsa/tag.h b/net/dsa/tag.h
index d5707870906b..5d80ddad4ff6 100644
--- a/net/dsa/tag.h
+++ b/net/dsa/tag.h
@@ -138,9 +138,10 @@ static inline void dsa_software_untag_vlan_unaware_bridge(struct sk_buff *skb,
  * dsa_software_vlan_untag: Software VLAN untagging in DSA receive path
  * @skb: Pointer to socket buffer (packet)
  *
- * Receive path method for switches which cannot avoid tagging all packets
- * towards the CPU port. Called when ds->untag_bridge_pvid (legacy) or
- * ds->untag_vlan_aware_bridge_pvid is set to true.
+ * Receive path method for switches which send some packets as VLAN-tagged
+ * towards the CPU port (generally from VLAN-aware bridge ports) even when the
+ * packet was not tagged on the wire. Called when ds->untag_bridge_pvid
+ * (legacy) or ds->untag_vlan_aware_bridge_pvid is set to true.
  *
  * As a side effect of this method, any VLAN tag from the skb head is moved
  * to hwaccel.
@@ -149,14 +150,19 @@ static inline struct sk_buff *dsa_software_vlan_untag(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_user_to_port(skb->dev);
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
-	u16 vid;
+	u16 vid, proto;
+	int err;
 
 	/* software untagging for standalone ports not yet necessary */
 	if (!br)
 		return skb;
 
+	err = br_vlan_get_proto(br, &proto);
+	if (err)
+		return skb;
+
 	/* Move VLAN tag from data to hwaccel */
-	if (!skb_vlan_tag_present(skb)) {
+	if (!skb_vlan_tag_present(skb) && skb->protocol == htons(proto)) {
 		skb = skb_vlan_untag(skb);
 		if (!skb)
 			return NULL;
-- 
2.39.5



