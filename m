Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50408F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F62FC433A7;
	Mon, 13 Feb 2023 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300707;
	bh=J37RCpD5IjPq0st9oYAT6iUuCaNZ0LRowah5KIEw0TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rM2yvMerHvyOjl24fDaUVkFRd78PZcLhEfY/z+A5N6VGzlU1u8mFY1GaSvJHBX2Yr
	 P2GRMQJNIRSbaQ6zFrCl4i8AND0+fEPgYW0t1aJq8QcsjivsvcGGXPA5+1X927Msal
	 5OE23c4n1T3QsDz1WMnob/bLmN94x+6l0fl4cDFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/139] net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
Date: Mon, 13 Feb 2023 15:51:02 +0100
Message-Id: <20230213144752.087215093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f964f8399df29d3e3ced77177cf35131cd2491bf ]

Alternative short title: don't instruct the hardware to match on
EtherType with "protocol 802.1Q" flower filters. It doesn't work for the
reasons detailed below.

With a command such as the following:

tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
	protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
	action vlan modify id 300 \
	action goto chain $(IS2 0 0)

the created filter is set by ocelot_flower_parse_key() to be of type
OCELOT_VCAP_KEY_ETYPE, and etype is set to {value=0x8100, mask=0xffff}.
This gets propagated all the way to is1_entry_set() which commits it to
hardware (the VCAP_IS1_HK_ETYPE field of the key). Compare this to the
case where src_mac isn't specified - the key type is OCELOT_VCAP_KEY_ANY,
and is1_entry_set() doesn't populate VCAP_IS1_HK_ETYPE.

The problem is that for VLAN-tagged frames, the hardware interprets the
ETYPE field as holding the encapsulated VLAN protocol. So the above
filter will only match those packets which have an encapsulated protocol
of 0x8100, rather than all packets with VLAN ID 200 and the given src_mac.

The reason why this is allowed to occur is because, although we have a
block of code in ocelot_flower_parse_key() which sets "match_protocol"
to false when VLAN keys are present, that code executes too late.
There is another block of code, which executes for Ethernet addresses,
and has a "goto finished_key_parsing" and skips the VLAN header parsing.
By skipping it, "match_protocol" remains with the value it was
initialized with, i.e. "true", and "proto" is set to f->common.protocol,
or 0x8100.

The concept of ignoring some keys rather than erroring out when they are
present but can't be offloaded is dubious in itself, but is present
since the initial commit fe3490e6107e ("net: mscc: ocelot: Hardware
ofload for tc flower filter"), and it's outside of the scope of this
patch to change that.

The problem was introduced when the driver started to interpret the
flower filter's protocol, and populate the VCAP filter's ETYPE field
based on it.

To fix this, it is sufficient to move the code that parses the VLAN keys
earlier than the "goto finished_key_parsing" instruction. This will
ensure that if we have a flower filter with both VLAN and Ethernet
address keys, it won't match on ETYPE 0x8100, because the VLAN key
parsing sets "match_protocol = false".

Fixes: 86b956de119c ("net: mscc: ocelot: support matching on EtherType")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230205192409.1796428-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b221b83ec5a6f..e56e540ce05c3 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -468,6 +468,18 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		flow_rule_match_control(rule, &match);
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		filter->key_type = OCELOT_VCAP_KEY_ANY;
+		filter->vlan.vid.value = match.key->vlan_id;
+		filter->vlan.vid.mask = match.mask->vlan_id;
+		filter->vlan.pcp.value[0] = match.key->vlan_priority;
+		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		match_protocol = false;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
@@ -600,18 +612,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		match_protocol = false;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_match_vlan match;
-
-		flow_rule_match_vlan(rule, &match);
-		filter->key_type = OCELOT_VCAP_KEY_ANY;
-		filter->vlan.vid.value = match.key->vlan_id;
-		filter->vlan.vid.mask = match.mask->vlan_id;
-		filter->vlan.pcp.value[0] = match.key->vlan_priority;
-		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
-		match_protocol = false;
-	}
-
 finished_key_parsing:
 	if (match_protocol && proto != ETH_P_ALL) {
 		if (filter->block_id == VCAP_ES0) {
-- 
2.39.0



