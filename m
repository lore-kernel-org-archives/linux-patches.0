Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419FF26C3BD;
	Mon, 23 Mar 2026 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283316; cv=none; b=K95l+YMjDU1OUzoorAOFyNJoHuaSWvOZxkQtmwNF3PGBK8B+vBzqi3UshZd6IzwXRY8Bp7fk2XL5St3+inbuuXEib2dFNsZo5k+E86ilJQZ9ElPUKDNK+Yl1f7t+N4CEx9b0ajbdM+v64Q4VMqRs/JxT0ZnTU6X5qllsP4eHK/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283316; c=relaxed/simple;
	bh=uv73dyPZlXvDDWSV5zKUap+zoazQJ76zP+RGXqIxdqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2ql72XIl9xeVGfGfHke7nZA8uamJhITfcW7YI/7FADvvpFDkZ78sO0a2vzlGELBBcbH+Gs9cMzrwmOAnZUcdHFmYEftVjUPMPTMra9brUs4+Kn6vZ6VhXY3nXAvLfkNd2k934wfiBRe6lRkxw5789aXD2UMThmAurCvsHPOxbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umyiZc67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umyiZc67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DADC4CEF7;
	Mon, 23 Mar 2026 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283315;
	bh=uv73dyPZlXvDDWSV5zKUap+zoazQJ76zP+RGXqIxdqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umyiZc675PDbdmKo6ryiP8AZ3LwmV5iQvbjAGdiJpGsNNgR0fhnTcSIa4++K5bmby
	 Ov1+9i6Dr3sYzhts8nk7n5Pmpt4B84lY3Esg1RvLtKdEE/oIHO8FN4+MMv7JYeZPIT
	 Ls7dF57rjkO8UbjBspBSq3VYVTU4ikUnMtwAvNT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Fietkau <nbd@nbd.name>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.1 463/481] net: add support for segmenting TCP fraglist GSO packets
Date: Mon, 23 Mar 2026 14:47:25 +0100
Message-ID: <20260323134536.496611689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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


