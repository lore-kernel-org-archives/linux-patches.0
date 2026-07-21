Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE62338E8AB;
	Tue, 21 Jul 2026 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662804; cv=none; b=oOyNorl4C7sBY4wayyN/9n1SHLtIqp1ynEdEfX5oiBs0E3rAvjgZ2aT1ruQkTtxrao6lY8rNuHoaF4+YQHriepbtSUXrU2upncO2j+XXH3wu+K9iTxotfLgtx8BKSQl6QxxjP/eTEW9lT4/RJp1J/5h9lFzYrcLs7z1LmCPIIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662804; c=relaxed/simple;
	bh=g72vux6D9QoUjQZ5mko16suUy82QWLnMW3up08EnU7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgELau7B///wh6/gMEDtD/Fw4e3PIdqZl/ZKmxZQESwIhh8TErng3bZH7IwsNelRqdaQitUUBsZO2u9vXitISIaUbjVAbri2xqVSq1Dj5iClYvhFeLUb8ag7rpsG3G4WUijbOP5QSX793gnufkDZa0OUqhboC34ojTD3GVF/Nkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/h+0JGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/h+0JGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E5C1F000E9;
	Tue, 21 Jul 2026 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662803;
	bh=3wpariQwNUUHmU+oOdVoMaAqVNzPcfmKyJ4RGew12tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/h+0JGQr7tYEM98N0rkp2n6nhSm0rAEPpbSichtsmIWIb4XTUL+d6o2prQ5El07A
	 GAbYLPkMtTuoMjMKL6Pgdeoc8hFs17Zk0y2Xe5Os6kT9dZon4r9SaWO0SHaN2OY7rh
	 V95bgz8vL3437ddeVXk/EiDKDzGfYUSoj5jVXLZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fa2f5b1fb06147be5e16@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0582/1276] flow_dissector: check device type before reading ETH_ADDRS
Date: Tue, 21 Jul 2026 17:17:05 +0200
Message-ID: <20260721152459.140893111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8be2ef8088be2e..bf63af1bca0dfa 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1173,13 +1173,21 @@ bool __skb_flow_dissect(const struct net *net,
 
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



