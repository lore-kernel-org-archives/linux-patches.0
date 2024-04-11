Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680E014A0B5;
	Thu, 11 Apr 2024 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831433; cv=none; b=GBbikUUJW6fcVBauPbmb7RZzXh0vvGM7whPstAAPAwvM4DFhjguH95qHSpZ9NNPH1QD5BwcFqp/cYXD73qEn77Bmgw8EGhwONoGGjwcBnxAO6FiF64HYuLK5JAPPwpmqBkMLtQwoklnIe2M0rvRvvAa1rJX22jXrS0e2rSPIzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831433; c=relaxed/simple;
	bh=dpZNrUUWZp2G1yLdC8F5fLItMXEkPLOPLAeX4ZE0LXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhwzOemwWnFy3biPd9Edf+in/gOWv/hnjGQY/tHZbmQm7QodKLdi8XA/rvu1Ee4Qjt+2UTJHTOgkJAKNps/sVkW3Um/a7uyAwRGHvJLej0ufeR5wBdmzV4aP3Upy4ZMicAEEKak5XgYN2835gZXJBYubKf/1ZSrRUsb7I7IiMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nb3ScEYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nb3ScEYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D03C433C7;
	Thu, 11 Apr 2024 10:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831433;
	bh=dpZNrUUWZp2G1yLdC8F5fLItMXEkPLOPLAeX4ZE0LXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nb3ScEYxE1DcJrAH8WIEafeFwYKXwWu5ETH8oEkuGBs7UEVLA3UoXHAiqRkVeIMc3
	 pDzcwTpXb/P7sEF5aLsNysEFq+9qwIHfHSdIkQdaetKw/pc61gFaJY6dHj/yy9Ns71
	 pQkcHU5ISPE7BQuqdUIzx+vs1dD7wMvP1Aaz2dC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	syzbot+99d15fcdb0132a1e1a82@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 112/114] net: mpls: error out if inner headers are not set
Date: Thu, 11 Apr 2024 11:57:19 +0200
Message-ID: <20240411095420.272994514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 025f8ad20f2e3264d11683aa9cbbf0083eefbdcd upstream.

mpls_gso_segment() assumes skb_inner_network_header() returns
a valid result:

  mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
  if (unlikely(!mpls_hlen || mpls_hlen % MPLS_HLEN))
        goto out;
  if (unlikely(!pskb_may_pull(skb, mpls_hlen)))

With syzbot reproducer, skb_inner_network_header() yields 0,
skb_network_header() returns 108, so this will
"pskb_may_pull(skb, -108)))" which triggers a newly added
DEBUG_NET_WARN_ON_ONCE() check:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5068 at include/linux/skbuff.h:2723 pskb_may_pull_reason include/linux/skbuff.h:2723 [inline]
WARNING: CPU: 0 PID: 5068 at include/linux/skbuff.h:2723 pskb_may_pull include/linux/skbuff.h:2739 [inline]
WARNING: CPU: 0 PID: 5068 at include/linux/skbuff.h:2723 mpls_gso_segment+0x773/0xaa0 net/mpls/mpls_gso.c:34
[..]
 skb_mac_gso_segment+0x383/0x740 net/core/gso.c:53
 nsh_gso_segment+0x40a/0xad0 net/nsh/nsh.c:108
 skb_mac_gso_segment+0x383/0x740 net/core/gso.c:53
 __skb_gso_segment+0x324/0x4c0 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 [..]
 sch_direct_xmit+0x11a/0x5f0 net/sched/sch_generic.c:327
 [..]
 packet_sendmsg+0x46a9/0x6130 net/packet/af_packet.c:3113
 [..]

First iteration of this patch made mpls_hlen signed and changed
test to error out to "mpls_hlen <= 0 || ..".

Eric Dumazet said:
 > I was thinking about adding a debug check in skb_inner_network_header()
 > if inner_network_header is zero (that would mean it is not 'set' yet),
 > but this would trigger even after your patch.

So add new skb_inner_network_header_was_set() helper and use that.

The syzbot reproducer injects data via packet socket. The skb that gets
allocated and passed down the stack has ->protocol set to NSH (0x894f)
and gso_type set to SKB_GSO_UDP | SKB_GSO_DODGY.

This gets passed to skb_mac_gso_segment(), which sees NSH as ptype to
find a callback for.  nsh_gso_segment() retrieves next type:

        proto = tun_p_to_eth_p(nsh_hdr(skb)->np);

... which is MPLS (TUN_P_MPLS_UC). It updates skb->protocol and then
calls mpls_gso_segment().  Inner offsets are all 0, so mpls_gso_segment()
ends up with a negative header size.

In case more callers rely on silent handling of such large may_pull values
we could also 'legalize' this behaviour, either replacing the debug check
with (len > INT_MAX) test or removing it and instead adding a comment
before existing

 if (unlikely(len > skb->len))
    return SKB_DROP_REASON_PKT_TOO_SMALL;

test in pskb_may_pull_reason(), saying that this check also implicitly
takes care of callers that miscompute header sizes.

Cc: Simon Horman <horms@kernel.org>
Fixes: 219eee9c0d16 ("net: skbuff: add overflow debug check to pull/push helpers")
Reported-by: syzbot+99d15fcdb0132a1e1a82@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/00000000000043b1310611e388aa@google.com/raw
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20240222140321.14080-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    5 +++++
 net/mpls/mpls_gso.c    |    3 +++
 2 files changed, 8 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2837,6 +2837,11 @@ static inline void skb_set_inner_network
 	skb->inner_network_header += offset;
 }
 
+static inline bool skb_inner_network_header_was_set(const struct sk_buff *skb)
+{
+	return skb->inner_network_header > 0;
+}
+
 static inline unsigned char *skb_inner_mac_header(const struct sk_buff *skb)
 {
 	return skb->head + skb->inner_mac_header;
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -27,6 +27,9 @@ static struct sk_buff *mpls_gso_segment(
 	__be16 mpls_protocol;
 	unsigned int mpls_hlen;
 
+	if (!skb_inner_network_header_was_set(skb))
+		goto out;
+
 	skb_reset_network_header(skb);
 	mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
 	if (unlikely(!mpls_hlen || mpls_hlen % MPLS_HLEN))


