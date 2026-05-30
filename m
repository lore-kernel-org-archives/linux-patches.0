Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF9C331A56;
	Sat, 30 May 2026 18:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166655; cv=none; b=EZYPzmxwtTUZ5y9RzfV28Y8irfLIYg9Bg/hl5Dj36r5qL8NNzGKl6eZs50hB30FZwuCq7DYti3mh0gTYjJUgjmDkcevYB25pTcdihhOKrgiMztARBJCWjXzKA+alSXZ4pAomFwm3eC8+lJosovep7zyWeC/9w/7qyARjl6oI6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166655; c=relaxed/simple;
	bh=1uwBHMUZX1atc0k07/vKzHQgjLBhCpImE0Yvrq6NeKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx3VLlJCTo5rEMzVWIE+zFlDkA+/tSMlMiPCxcRy+Yqcal6dgmp2hE2a8QSXWiZ9MJlRBcg/ooTXwGYV7vBV2QKCVYQ+QNHw5arsw+J3zV7pLhNupCUOThIF3t2m2lwWPMip5p9563Xw2+48ziF4Vq8dC4iT9vJhzY3Gwb3rcNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7RglXqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7RglXqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9759F1F00893;
	Sat, 30 May 2026 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166654;
	bh=cWZcOdDAr1ycCL6RTnBzFRKbrHG8pXL14dMU0jnlcZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7RglXqYJk+DsJJujbjYPYgQ/o+6/oAkiJ9qDyg6yqqL07nOFEQTJzjmcYDP2v8CD
	 thyCiO33m9SF+ADIZuw7sw4xlX5TJc33DlWs11xafb08spp7IkrlNtR7ry/q//rA5w
	 9s3zdj7SE1Y+nAsJsCMHyZOhN+1HAaB88pyb8NAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Sukholitko <boris.sukholitko@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/589] flow_dissector: Add number of vlan tags dissector
Date: Sat, 30 May 2026 18:05:10 +0200
Message-ID: <20260530160235.997771473@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Sukholitko <boris.sukholitko@broadcom.com>

[ Upstream commit 34951fcf26c59e78ae430fba1fce7c08b1871249 ]

Our customers in the fiber telecom world have network configurations
where they would like to control their traffic according to the number
of tags appearing in the packet.

For example, TR247 GPON conformance test suite specification mostly
talks about untagged, single, double tagged packets and gives lax
guidelines on the vlan protocol vs. number of vlan tags.

This is different from the common IT networks where 802.1Q and 802.1ad
protocols are usually describe single and double tagged packet. GPON
configurations that we work with have arbitrary mix the above protocols
and number of vlan tags in the packet.

The goal is to make the following TC commands possible:

tc filter add dev eth1 ingress flower \
  num_of_vlans 1 vlan_prio 5 action drop

>From our logs, we have redirect rules such that:

tc filter add dev $GPON ingress flower num_of_vlans $N \
     action mirred egress redirect dev $DEV

where N can range from 0 to 3 and $DEV is the function of $N.

Also there are rules setting skb mark based on the number of vlans:

tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
    $P action skbedit mark $M

This new dissector allows extracting the number of vlan tags existing in
the packet.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cc1ff87bce1c ("pppoe: drop PFC frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_dissector.h |  9 +++++++++
 net/core/flow_dissector.c    | 20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 4036063d047c2..6826309631cb3 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -269,6 +269,14 @@ struct flow_dissector_key_hash {
 	u32 hash;
 };
 
+/**
+ * struct flow_dissector_key_num_of_vlans:
+ * @num_of_vlans: num_of_vlans value
+ */
+struct flow_dissector_key_num_of_vlans {
+	u8 num_of_vlans;
+};
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -298,6 +306,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_META, /* struct flow_dissector_key_meta */
 	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
 	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
+	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 8fe8b3afacd04..146f24c53c660 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1032,6 +1032,16 @@ bool __skb_flow_dissect(const struct net *net,
 		memcpy(key_eth_addrs, &eth->h_dest, sizeof(*key_eth_addrs));
 	}
 
+	if (dissector_uses_key(flow_dissector,
+			       FLOW_DISSECTOR_KEY_NUM_OF_VLANS)) {
+		struct flow_dissector_key_num_of_vlans *key_num_of_vlans;
+
+		key_num_of_vlans = skb_flow_dissector_target(flow_dissector,
+							     FLOW_DISSECTOR_KEY_NUM_OF_VLANS,
+							     target_container);
+		key_num_of_vlans->num_of_vlans = 0;
+	}
+
 proto_again:
 	fdret = FLOW_DISSECT_RET_CONTINUE;
 
@@ -1155,6 +1165,16 @@ bool __skb_flow_dissect(const struct net *net,
 			nhoff += sizeof(*vlan);
 		}
 
+		if (dissector_uses_key(flow_dissector,
+				       FLOW_DISSECTOR_KEY_NUM_OF_VLANS)) {
+			struct flow_dissector_key_num_of_vlans *key_nvs;
+
+			key_nvs = skb_flow_dissector_target(flow_dissector,
+							    FLOW_DISSECTOR_KEY_NUM_OF_VLANS,
+							    target_container);
+			key_nvs->num_of_vlans++;
+		}
+
 		if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX) {
 			dissector_vlan = FLOW_DISSECTOR_KEY_VLAN;
 		} else if (dissector_vlan == FLOW_DISSECTOR_KEY_VLAN) {
-- 
2.53.0



