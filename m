Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872211D63F3;
	Mon, 23 Mar 2026 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271064; cv=none; b=h0YmryqzTJZneQfHQLbqSmkQzX3eL5MAkleqkLGyJB4Mc6h7lIIxHzFG/eXeTfLfFnXaKg9nEi1Kcrp05jXQu4dNYn6bj2PlwEk1VWgVLxLo+ySaYfPaHrV2/5qN9ZhDsJTD8Gk2Davo8qBRPaqQKaW+R9vYEqrBXma4XrlMo3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271064; c=relaxed/simple;
	bh=WkFE5JGbZXfHopgp5H1zuI/nmW+VTfwA62y8AucOJtM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=FplGGaPBXBPvisuKMjsOfYtiTMCs7EFUEiJPHtEutOwgEw01keGwac/G8aXkFg3vvy2Lmb2htaIvk64/2v/vejfLvYrqLoX/JuVerIyW1bLtcgLBvlKF1rYYm8FZj6/Ee6Dul8OCxk1J13iIl2Ip8EDgW3KI3i25l1EQjWpV+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVjuSJ7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVjuSJ7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAB2C4CEF7;
	Mon, 23 Mar 2026 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774271064;
	bh=WkFE5JGbZXfHopgp5H1zuI/nmW+VTfwA62y8AucOJtM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=oVjuSJ7aHrZN3NnIxTsN/cOhamTU2GlFxiAykSmkgohk9CK22kX1xawyzH0EEr7XT
	 BceIPIINNi68JbEOOYEGceiznnFg3toWEz13B0dobxn2YVDRea2Oc6PEwZI20q5Ndo
	 i6PWuqKHkY9R+ttxTmQO8DbPPsnXYDRBV7O64aII=
Subject: Patch "net: add support for segmenting TCP fraglist GSO packets" has been added to the 6.1-stable tree
To: 1468888505@139.com,davem@davemloft.net,dsahern@kernel.org,edumazet@google.com,gregkh@linuxfoundation.org,kuba@kernel.org,nbd@nbd.name,pabeni@redhat.com,patches@lists.linux.dev,willemb@google.com,yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 14:03:43 +0100
In-Reply-To: <20260302065044.2694740-1-1468888505@139.com>
Message-ID: <2026032342-breeder-eggplant-ebfe@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    net: add support for segmenting TCP fraglist GSO packets

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-add-support-for-segmenting-tcp-fraglist-gso-packets.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-222520-greg=kroah.com@vger.kernel.org Mon Mar  2 07:51:03 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Mar 2026 14:50:44 +0800
Subject: net: add support for segmenting TCP fraglist GSO packets
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, nbd@nbd.name
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, willemb@google.com
Message-ID: <20260302065044.2694740-1-1468888505@139.com>

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bee88cd5bd83d40b8aec4d6cb729378f707f6197 ]

Preparation for adding TCP fraglist GRO support. It expects packets to be
combined in a similar way as UDP fraglist GSO packets.
For IPv4 packets, NAT is handled in the same way as UDP fraglist GSO.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_offload.c   |   67 +++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcpv6_offload.c |   58 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -30,6 +30,70 @@ static void tcp_gso_tstamp(struct sk_buf
 	}
 }
 
+static void __tcpv4_gso_segment_csum(struct sk_buff *seg,
+				     __be32 *oldip, __be32 newip,
+				     __be16 *oldport, __be16 newport)
+{
+	struct tcphdr *th;
+	struct iphdr *iph;
+
+	if (*oldip == newip && *oldport == newport)
+		return;
+
+	th = tcp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	inet_proto_csum_replace4(&th->check, seg, *oldip, newip, true);
+	inet_proto_csum_replace2(&th->check, seg, *oldport, newport, false);
+	*oldport = newport;
+
+	csum_replace4(&iph->check, *oldip, newip);
+	*oldip = newip;
+}
+
+static struct sk_buff *__tcpv4_gso_segment_list_csum(struct sk_buff *segs)
+{
+	const struct tcphdr *th;
+	const struct iphdr *iph;
+	struct sk_buff *seg;
+	struct tcphdr *th2;
+	struct iphdr *iph2;
+
+	seg = segs;
+	th = tcp_hdr(seg);
+	iph = ip_hdr(seg);
+	th2 = tcp_hdr(seg->next);
+	iph2 = ip_hdr(seg->next);
+
+	if (!(*(const u32 *)&th->source ^ *(const u32 *)&th2->source) &&
+	    iph->daddr == iph2->daddr && iph->saddr == iph2->saddr)
+		return segs;
+
+	while ((seg = seg->next)) {
+		th2 = tcp_hdr(seg);
+		iph2 = ip_hdr(seg);
+
+		__tcpv4_gso_segment_csum(seg,
+					 &iph2->saddr, iph->saddr,
+					 &th2->source, th->source);
+		__tcpv4_gso_segment_csum(seg,
+					 &iph2->daddr, iph->daddr,
+					 &th2->dest, th->dest);
+	}
+
+	return segs;
+}
+
+static struct sk_buff *__tcp4_gso_segment_list(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	if (IS_ERR(skb))
+		return skb;
+
+	return __tcpv4_gso_segment_list_csum(skb);
+}
+
 static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
@@ -39,6 +103,9 @@ static struct sk_buff *tcp4_gso_segment(
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		return ERR_PTR(-EINVAL);
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __tcp4_gso_segment_list(skb, features);
+
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct iphdr *iph = ip_hdr(skb);
 		struct tcphdr *th = tcp_hdr(skb);
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -39,6 +39,61 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_com
 	return tcp_gro_complete(skb);
 }
 
+static void __tcpv6_gso_segment_csum(struct sk_buff *seg,
+				     __be16 *oldport, __be16 newport)
+{
+	struct tcphdr *th;
+
+	if (*oldport == newport)
+		return;
+
+	th = tcp_hdr(seg);
+	inet_proto_csum_replace2(&th->check, seg, *oldport, newport, false);
+	*oldport = newport;
+}
+
+static struct sk_buff *__tcpv6_gso_segment_list_csum(struct sk_buff *segs)
+{
+	const struct tcphdr *th;
+	const struct ipv6hdr *iph;
+	struct sk_buff *seg;
+	struct tcphdr *th2;
+	struct ipv6hdr *iph2;
+
+	seg = segs;
+	th = tcp_hdr(seg);
+	iph = ipv6_hdr(seg);
+	th2 = tcp_hdr(seg->next);
+	iph2 = ipv6_hdr(seg->next);
+
+	if (!(*(const u32 *)&th->source ^ *(const u32 *)&th2->source) &&
+	    ipv6_addr_equal(&iph->saddr, &iph2->saddr) &&
+	    ipv6_addr_equal(&iph->daddr, &iph2->daddr))
+		return segs;
+
+	while ((seg = seg->next)) {
+		th2 = tcp_hdr(seg);
+		iph2 = ipv6_hdr(seg);
+
+		iph2->saddr = iph->saddr;
+		iph2->daddr = iph->daddr;
+		__tcpv6_gso_segment_csum(seg, &th2->source, th->source);
+		__tcpv6_gso_segment_csum(seg, &th2->dest, th->dest);
+	}
+
+	return segs;
+}
+
+static struct sk_buff *__tcp6_gso_segment_list(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	if (IS_ERR(skb))
+		return skb;
+
+	return __tcpv6_gso_segment_list_csum(skb);
+}
+
 static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
@@ -50,6 +105,9 @@ static struct sk_buff *tcp6_gso_segment(
 	if (!pskb_may_pull(skb, sizeof(*th)))
 		return ERR_PTR(-EINVAL);
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __tcp6_gso_segment_list(skb, features);
+
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 		struct tcphdr *th = tcp_hdr(skb);


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/net-fix-segmentation-of-forwarding-fraglist-gro.patch
queue-6.1/net-gso-fix-tcp-fraglist-segmentation-after-pull-from-frag_list.patch
queue-6.1/net-add-support-for-segmenting-tcp-fraglist-gso-packets.patch
