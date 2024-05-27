Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9B317727;
	Mon, 27 May 2024 19:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838330; cv=none; b=YucZNND3ecxC2Lakd76VoLAuDiriKH9pyN+GU1ao6WVRQMHGmQojUuxYa/Pwpapm+LyR2YY8bc8Jf8rmWcyCV7JNLN9nJWR0IuoQw0gvfFk6YwJhveGMbK2mobmizaVJIwIBCgf62WhyXIFn0qXRxElGPBZ1n/r/wQJpIdpmFaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838330; c=relaxed/simple;
	bh=wOzljnaEebenvyFYOnY2zpxirB6GjRSkSoIUTRjVRMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/7jUI/oReCyLUsbl7f0GdHeWARZ5GRz0zHxFMnYYQ0P1PzB4QAAC9lKlKjK4XJ0dfqzGC1H3noSkZ5cHAOJL41Y6z/0HCxotD71EHak73pPk3Cr26tAhXu+mRrHZP72eHwHkwXGO9/dtGJQ4aOkfg5je+PQ4aEWWxGnMDDsXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMpa6gz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMpa6gz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4436AC2BBFC;
	Mon, 27 May 2024 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838330;
	bh=wOzljnaEebenvyFYOnY2zpxirB6GjRSkSoIUTRjVRMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMpa6gz5hvGhEBDjG9E6jCKbyLdU/VrPaGWPdrfzWFVs6ze5YqHUZpC55MXqzmH7B
	 XsCyOAgo0jOFpHT4FOZdmoeiUY8oj8Xg2RS9Q+shBISAi34F2bHaoWLGkWVoe3VwuS
	 mNrbb8T5Vhm/1QTmXcwlv0BXTVz/1aGHWHucuolc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonin Bas <antonin.bas@broadcom.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 311/493] net: openvswitch: fix overwriting ct original tuple for ICMPv6
Date: Mon, 27 May 2024 20:55:13 +0200
Message-ID: <20240527185640.467264437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 7c988176b6c16c516474f6fceebe0f055af5eb56 ]

OVS_PACKET_CMD_EXECUTE has 3 main attributes:
 - OVS_PACKET_ATTR_KEY - Packet metadata in a netlink format.
 - OVS_PACKET_ATTR_PACKET - Binary packet content.
 - OVS_PACKET_ATTR_ACTIONS - Actions to execute on the packet.

OVS_PACKET_ATTR_KEY is parsed first to populate sw_flow_key structure
with the metadata like conntrack state, input port, recirculation id,
etc.  Then the packet itself gets parsed to populate the rest of the
keys from the packet headers.

Whenever the packet parsing code starts parsing the ICMPv6 header, it
first zeroes out fields in the key corresponding to Neighbor Discovery
information even if it is not an ND packet.

It is an 'ipv6.nd' field.  However, the 'ipv6' is a union that shares
the space between 'nd' and 'ct_orig' that holds the original tuple
conntrack metadata parsed from the OVS_PACKET_ATTR_KEY.

ND packets should not normally have conntrack state, so it's fine to
share the space, but normal ICMPv6 Echo packets or maybe other types of
ICMPv6 can have the state attached and it should not be overwritten.

The issue results in all but the last 4 bytes of the destination
address being wiped from the original conntrack tuple leading to
incorrect packet matching and potentially executing wrong actions
in case this packet recirculates within the datapath or goes back
to userspace.

ND fields should not be accessed in non-ND packets, so not clearing
them should be fine.  Executing memset() only for actual ND packets to
avoid the issue.

Initializing the whole thing before parsing is needed because ND packet
may not contain all the options.

The issue only affects the OVS_PACKET_CMD_EXECUTE path and doesn't
affect packets entering OVS datapath from network interfaces, because
in this case CT metadata is populated from skb after the packet is
already parsed.

Fixes: 9dd7f8907c37 ("openvswitch: Add original direction conntrack tuple to sw_flow_key.")
Reported-by: Antonin Bas <antonin.bas@broadcom.com>
Closes: https://github.com/openvswitch/ovs-issues/issues/327
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Aaron Conole <aconole@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20240509094228.1035477-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 33b21a0c05481..8a848ce72e291 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -561,7 +561,6 @@ static int parse_icmpv6(struct sk_buff *skb, struct sw_flow_key *key,
 	 */
 	key->tp.src = htons(icmp->icmp6_type);
 	key->tp.dst = htons(icmp->icmp6_code);
-	memset(&key->ipv6.nd, 0, sizeof(key->ipv6.nd));
 
 	if (icmp->icmp6_code == 0 &&
 	    (icmp->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION ||
@@ -570,6 +569,8 @@ static int parse_icmpv6(struct sk_buff *skb, struct sw_flow_key *key,
 		struct nd_msg *nd;
 		int offset;
 
+		memset(&key->ipv6.nd, 0, sizeof(key->ipv6.nd));
+
 		/* In order to process neighbor discovery options, we need the
 		 * entire packet.
 		 */
-- 
2.43.0



