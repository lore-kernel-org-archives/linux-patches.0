Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6E1D5CE5;
	Mon,  6 Jan 2025 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178294; cv=none; b=BtdYHW4j2IVdTkjFpID2Rrmgo0UuJtodXBgAUIV8HpboherCYFayOtmYU37okGU8i0WGVfEYhwqtdCYQlqQIK2qCLoy5Y9/sFJUbp8ZOmiojTAdCDckEfdB3Fj//l44t5l+Cp2WEWutPcavB5+LBkK1lahPyt02vl5IZ6VRVTps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178294; c=relaxed/simple;
	bh=NAZ1fKWRNQzxdNnjQ7MfJ6Yt08x1F5IAkzBoC6o9j00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/1pcuTeCK8X6hRrCDvZPLttKuYndPUe3n01TMoXK/8Uyzz2vIHegaxKGbAY5sXvxLxA2fjY8goXdu5cue8FVA8lhow++xxl6LSXFIJUVMtoMk0FXkous4Szw5Z6E2fKsIL0bHTE2lqnHAJghcIfNRwRLIuXl0lav8+5tFN9kEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTndIUjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTndIUjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B7BC4CED2;
	Mon,  6 Jan 2025 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178294;
	bh=NAZ1fKWRNQzxdNnjQ7MfJ6Yt08x1F5IAkzBoC6o9j00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTndIUjkpzUUGElBUhA2ZjodquZGagsPSMvTHMchdnuHnLOZp++mWR9cXeLdrcUps
	 khhTW6sFDI1Rz7RIGZqpqNrDlqOSqBPdydhmXzQ58q1cktcjMw2M6FnatPGY/Rc8tU
	 nf4TQALOE/spQ6RyMyX65l8+FpZqyzZKvF88PChc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	"David S. Miller" <davem@davemloft.net>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/138] ipv6: use skb_expand_head in ip6_xmit
Date: Mon,  6 Jan 2025 16:16:35 +0100
Message-ID: <20250106151135.922633793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 0c9f227bee11910a49e1d159abe102d06e3745d5 ]

Unlike skb_realloc_headroom, new helper skb_expand_head
does not allocate a new skb if possible.

Additionally this patch replaces commonly used dereferencing with variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 0c9f227bee11910a49e1d159abe102d06e3745d5)
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 7806963b4539..a8475848d038 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -254,6 +254,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	const struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_addr *first_hop = &fl6->daddr;
 	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = dst->dev;
+	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int head_room;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
@@ -261,22 +263,16 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	int hlimit = -1;
 	u32 mtu;
 
-	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dst->dev);
+	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
-	if (unlikely(skb_headroom(skb) < head_room)) {
-		struct sk_buff *skb2 = skb_realloc_headroom(skb, head_room);
-		if (!skb2) {
-			IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-				      IPSTATS_MIB_OUTDISCARDS);
-			kfree_skb(skb);
+	if (unlikely(head_room > skb_headroom(skb))) {
+		skb = skb_expand_head(skb, head_room);
+		if (!skb) {
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 			return -ENOBUFS;
 		}
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-		consume_skb(skb);
-		skb = skb2;
 	}
 
 	if (opt) {
@@ -318,8 +314,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 
 	mtu = dst_mtu(dst);
 	if ((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb)) {
-		IP6_UPD_PO_STATS(net, ip6_dst_idev(skb_dst(skb)),
-			      IPSTATS_MIB_OUT, skb->len);
+		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
 		/* if egress device is enslaved to an L3 master device pass the
 		 * skb to its handler for processing
@@ -332,17 +327,17 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 		 * we promote our socket to non const
 		 */
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
-			       net, (struct sock *)sk, skb, NULL, dst->dev,
+			       net, (struct sock *)sk, skb, NULL, dev,
 			       dst_output);
 	}
 
-	skb->dev = dst->dev;
+	skb->dev = dev;
 	/* ipv6_local_error() does not require socket lock,
 	 * we promote our socket to non const
 	 */
 	ipv6_local_error((struct sock *)sk, EMSGSIZE, fl6, mtu);
 
-	IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_FRAGFAILS);
+	IP6_INC_STATS(net, idev, IPSTATS_MIB_FRAGFAILS);
 	kfree_skb(skb);
 	return -EMSGSIZE;
 }
-- 
2.39.5



