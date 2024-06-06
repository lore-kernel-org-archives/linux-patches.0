Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE1E197537;
	Thu,  6 Jun 2024 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683303; cv=none; b=tAdkKPPkLfK2bbXf2WbkGQg4mjlMpTPciZ6bsSxubfQG7oNjZ7N8SDHvL9vWEeBWxTnmkwVbh/WziHwBCxH5mjPQAwlHEFuHmbJnn7wtbw16N+2IGayt8KqvlDmuP40AVJBvXdVPOUI+yFSKUw2LGk4RAFh2jSD8tPB0Mv+LyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683303; c=relaxed/simple;
	bh=HZqZAvryNye6rhbjtEcTgnCpEeavxJO1W4h7CTxh0fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAIC37xAwKxfcOFcTHyW2hnZWSt4Y8JPBO/Iz6tEzN8uN1DsT08B5ApNdfxqdTcw25VM3PtoYalNuKxVkanmxtFjBxc08zfmIyavx2ZLa8JU1Qjq7AxismbZDXDLeqSfURlBGWk2ZBshZqISpYTvnGcc0RLrxTJ/YnwQWKOOsn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeIYysVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeIYysVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33447C32781;
	Thu,  6 Jun 2024 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683303;
	bh=HZqZAvryNye6rhbjtEcTgnCpEeavxJO1W4h7CTxh0fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeIYysVaSajtefC4VXXh0fshF7rGi0IoPbbnTwI8yE6mg8JuqNtL44VzlbZ83453h
	 gZPYh4l+E1DXsNLNuOH55VbynD8rAhaiFhgMXtY77Vr899mLzYmKlEGQl9DRTaDvbC
	 6tncPQ7slKuX+LsHHTQ2fXrY6H9DF/X34Na+Vy/s=
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
Subject: [PATCH 6.1 174/473] net: openvswitch: fix overwriting ct original tuple for ICMPv6
Date: Thu,  6 Jun 2024 16:01:43 +0200
Message-ID: <20240606131705.691224533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index e20d1a9734175..78960a8a38925 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -558,7 +558,6 @@ static int parse_icmpv6(struct sk_buff *skb, struct sw_flow_key *key,
 	 */
 	key->tp.src = htons(icmp->icmp6_type);
 	key->tp.dst = htons(icmp->icmp6_code);
-	memset(&key->ipv6.nd, 0, sizeof(key->ipv6.nd));
 
 	if (icmp->icmp6_code == 0 &&
 	    (icmp->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION ||
@@ -567,6 +566,8 @@ static int parse_icmpv6(struct sk_buff *skb, struct sw_flow_key *key,
 		struct nd_msg *nd;
 		int offset;
 
+		memset(&key->ipv6.nd, 0, sizeof(key->ipv6.nd));
+
 		/* In order to process neighbor discovery options, we need the
 		 * entire packet.
 		 */
-- 
2.43.0



