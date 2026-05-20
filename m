Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F283F23BF;
	Wed, 20 May 2026 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299373; cv=none; b=h5Y3aQNoyBnHCdNXlNJKDVx/ksRzvfTMw46b963LQ8J5/RoAKM7qHAlr0anqod0+GoaunERQNAqwfvP2p2A3SUxOkjWcjzy/e8V6gHL3u7XGsNnh/3L6+R8WKAPf9qFRUFxmAtkmNcLaWECJAk+F1eptwl5pqdI29VnHVPecopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299373; c=relaxed/simple;
	bh=uGuo/tju361dEomd9P+FpXkW2Z7ddT+3OVKLe4yYmOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3SKo0QIQKujSpvUrKIqRBuJKdHxEqeek5mybat7Q3S9+ET+V8ySncm3Rs223UaKNYzrPh8NVtViCXQhal8eZEZ6FMrjI2/d+yDc1Jts50WEP6u82OQLgrwBADDT+jUtvn3iLwvViU80GSRvyyQW9IIcw4kGnVjw1s0LVMm7Dfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJAJH3OV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJAJH3OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AD21F00893;
	Wed, 20 May 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299371;
	bh=0aTo8JezqNi7SMsZOvbh/uEhJiL+ZDS2fW2u6JWBjsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJAJH3OVn8PT8ZgY0U0GuSRuzdlU9U7cWLMhh6QMCjIIU1nEZPQHym/7WogG78ZGV
	 xo09bku50w0J/GqgnYaEMAzePrdYuWikSQMvoPKq7oDQzEZvV25IDCYx5EU7D0dQ8Z
	 T6iGGj7vwZvfm3lrZLhKZpkOxKOXOzy+Jxpuq1U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 745/957] netfilter: arp_tables: fix IEEE1394 ARP payload parsing
Date: Wed, 20 May 2026 18:20:28 +0200
Message-ID: <20260520162150.717296241@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 1e8e3f449b1e73b73a843257635b9c50f0cc0f0a ]

Weiming Shi says:

"arp_packet_match() unconditionally parses the ARP payload assuming two
hardware addresses are present (source and target). However,
IPv4-over-IEEE1394 ARP (RFC 2734) omits the target hardware address
field, and arp_hdr_len() already accounts for this by returning a
shorter length for ARPHRD_IEEE1394 devices.

As a result, on IEEE1394 interfaces arp_packet_match() advances past a
nonexistent target hardware address and reads the wrong bytes for both
the target device address comparison and the target IP address. This
causes arptables rules to match against garbage data, leading to
incorrect filtering decisions: packets that should be accepted may be
dropped and vice versa.

The ARP stack in net/ipv4/arp.c (arp_create and arp_process) already
handles this correctly by skipping the target hardware address for
ARPHRD_IEEE1394. Apply the same pattern to arp_packet_match()."

Mangle the original patch to always return 0 (no match) in case user
matches on the target hardware address which is never present in
IEEE1394.

Note that this returns 0 (no match) for either normal and inverse match
because matching in the target hardware address in ARPHRD_IEEE1394 has
never been supported by arptables. This is intentional, matching on the
target hardware address should never evaluate true for ARPHRD_IEEE1394.

Moreover, adjust arpt_mangle to drop the packet too as AI suggests:

In arpt_mangle, the logic assumes a standard ARP layout. Because
IEEE1394 (FireWire) omits the target hardware address, the linear
pointer arithmetic miscalculates the offset for the target IP address.
This causes mangling operations to write to the wrong location, leading
to packet corruption. To ensure safety, this patch drops packets
(NF_DROP) when mangling is requested for these fields on IEEE1394
devices, as the current implementation cannot correctly map the FireWire
ARP payload.

This omits both mangling target hardware and IP address. Even if IP
address mangling should be possible in IEEE1394, this would require
to adjust arpt_mangle offset calculation, which has never been
supported.

Based on patch from Weiming Shi <bestswngs@gmail.com>.

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c  | 18 +++++++++++++++---
 net/ipv4/netfilter/arpt_mangle.c |  8 ++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2da..97ead883e4a13 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -110,13 +110,25 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	arpptr += dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
-	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+
+	if (IS_ENABLED(CONFIG_FIREWIRE_NET) && dev->type == ARPHRD_IEEE1394) {
+		if (unlikely(memchr_inv(arpinfo->tgt_devaddr.mask, 0,
+					sizeof(arpinfo->tgt_devaddr.mask))))
+			return 0;
+
+		tgt_devaddr = NULL;
+	} else {
+		tgt_devaddr = arpptr;
+		arpptr += dev->addr_len;
+	}
 	memcpy(&tgt_ipaddr, arpptr, sizeof(u32));
 
 	if (NF_INVF(arpinfo, ARPT_INV_SRCDEVADDR,
 		    arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr,
-					dev->addr_len)) ||
+					dev->addr_len)))
+		return 0;
+
+	if (tgt_devaddr &&
 	    NF_INVF(arpinfo, ARPT_INV_TGTDEVADDR,
 		    arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr,
 					dev->addr_len)))
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a4e07e5e9c118..f65dd339208e8 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -40,6 +40,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += pln;
 	if (mangle->flags & ARPT_MANGLE_TDEV) {
+		if (unlikely(IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+			     skb->dev->type == ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
 		   (arpptr + hln > skb_tail_pointer(skb)))
 			return NF_DROP;
@@ -47,6 +51,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += hln;
 	if (mangle->flags & ARPT_MANGLE_TIP) {
+		if (unlikely(IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+			     skb->dev->type == ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
 		   (arpptr + pln > skb_tail_pointer(skb)))
 			return NF_DROP;
-- 
2.53.0



