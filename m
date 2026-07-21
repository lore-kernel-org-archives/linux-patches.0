Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB0C346A0C;
	Tue, 21 Jul 2026 20:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666574; cv=none; b=CXKqAAD9nakrcPrQ6t/JHzKVPhDenIiB4Mj7+KpamyUcWeiBPsi0TQlnktwOuJLnGMsEsO2RFexZKGOxTx2+wV+WtMujktVxslZ3oZF1hjPue3SBPqfrbO4+NlYx1chWZm8d7qnKqAI7ZsiO9N5vvu99E1tU8Q0Q/tVfsuz98Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666574; c=relaxed/simple;
	bh=Gjutc8SnRN2JX8YAYWchryGRg9KZOqlziJWgOa6agH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7jMU4XVtTLmlSO7cAtmOziZEWmVF1JchEbASC++2XmD52OQ5CQIavW7VltCvQN5xTYaQqaTRzn+MW0QNlWxgVQkgmYwnbnIRz81rgYMeimK8/oNx8J7PJadhpDBjn8QKu1QoEQnaFxpkhuoAt7G1dfUlZE6CoWPkkcezsY0b44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyrpvJcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyrpvJcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF611F000E9;
	Tue, 21 Jul 2026 20:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666572;
	bh=a1Zxc/V50hPmco6KiD9d+Rwc073G5SWYYhSRsiB5VeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyrpvJcw/V7fKJ5DjAB2ehhV8GyMkEl1v88NmmhwV6BTXiY4M7Xvkk6DV1YHQ7N2A
	 gCyfNv3FjTjxmt3f9mxFtiSiAAkey9w9KmNbEUVPjaW0O1gUp7uDGsCVA6C+k9FeWf
	 7ML51vzYD3EHvH7jslkGQkSTZIiyqUSZCbAsltw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fa2f5b1fb06147be5e16@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0732/1266] flow_dissector: check device type before reading ETH_ADDRS
Date: Tue, 21 Jul 2026 17:19:29 +0200
Message-ID: <20260721152458.252605272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit bf6e8af2c8be77489bedeae9f8a9654cb710e500 ]

__skb_flow_dissect() unconditionally reads 12 bytes from eth_hdr(skb)
when FLOW_DISSECTOR_KEY_ETH_ADDRS is requested. This assumes the skb
has a valid Ethernet header at mac_header, which is not always the case.

The problem can be triggered by:
 1. Creating a TUN device in L3 mode (IFF_TUN, hard_header_len=0)
 2. Attaching a multiq qdisc with a flower filter matching on eth_src
 3. Sending a packet through AF_PACKET

Since TUN in L3 mode has no link-layer header, mac_header points to
the L3 data area. The flow dissector reads 12 bytes of uninitialized
skb memory, which then propagates through fl_set_masked_key() and is
used as a rhashtable lookup key in __fl_lookup(), as reported by KMSAN.

Rejecting the filter in the control path (at tc filter add time) is
not feasible because TC filter blocks can be shared between arbitrary
devices -- a filter installed on an Ethernet device may later classify
packets on a headerless device through a shared block. The device
association is not fixed at filter creation time.

Fix this by gating the memcpy on dev->type == ARPHRD_ETHER, which
ensures only true Ethernet-framed packets have their addresses read.
This is more precise than the previous hard_header_len >= 12 check,
which would incorrectly pass for non-Ethernet link types like IPoIB
(ARPHRD_INFINIBAND, hard_header_len=24) and FDDI (hard_header_len=21)
whose L2 headers are not in Ethernet format. Additionally check
skb_mac_header_was_set() to guard against the pathological case where
mac_header is the unset sentinel (~0U), which would cause eth_hdr() to
return a wild pointer.

For the act_mirred redirect case (Ethernet packet redirected to a
non-Ethernet device sharing a TC block), zeroing the key is the correct
behavior: the packet is now being classified on the target device, where
Ethernet address matching is not semantically meaningful.

Note: on non-Ethernet devices, the zeroed key will match a filter
configured with all-zero MAC addresses. This is an improvement over the
previous behavior where uninitialized memory could randomly match any
filter.

Reported-by: syzbot+fa2f5b1fb06147be5e16@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fa2f5b1fb06147be5e16
Fixes: 67a900cc0436 ("flow_dissector: introduce support for Ethernet addresses")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260616123057.482154-1-yun.zhou@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 9432e5362b44f1..5ac4cd4f3c6832 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1149,13 +1149,21 @@ bool __skb_flow_dissect(const struct net *net,
 
 	if (dissector_uses_key(flow_dissector,
 			       FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
-		struct ethhdr *eth = eth_hdr(skb);
 		struct flow_dissector_key_eth_addrs *key_eth_addrs;
 
 		key_eth_addrs = skb_flow_dissector_target(flow_dissector,
 							  FLOW_DISSECTOR_KEY_ETH_ADDRS,
 							  target_container);
-		memcpy(key_eth_addrs, eth, sizeof(*key_eth_addrs));
+		/* TC filter blocks can be shared across devices with
+		 * different link types, so we cannot validate this
+		 * when the filter is installed -- check at dissect time.
+		 */
+		if (skb && skb->dev &&
+		    skb->dev->type == ARPHRD_ETHER &&
+		    skb_mac_header_was_set(skb))
+			memcpy(key_eth_addrs, eth_hdr(skb), sizeof(*key_eth_addrs));
+		else
+			memset(key_eth_addrs, 0, sizeof(*key_eth_addrs));
 	}
 
 	if (dissector_uses_key(flow_dissector,
-- 
2.53.0



