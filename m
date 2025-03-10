Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657BC1DE89C;
	Mon, 10 Mar 2025 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630705; cv=none; b=dIisKHGiI1TLXi3C/nwrNGI0bVCuR9yvVQ/GMJ4dpCjAoq8CRo7twmH3PjR0cveyexRzfrPKxi0nmXi5qzuUng3xt0UqyC/i0lWCPuhpxTTkuQNyuNq8e7kkf10PNRb99lB5Hep6h1Gw0GQdYVd9cLJjiVIzSRZj5PL0sxlNJwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630705; c=relaxed/simple;
	bh=faNorA/pvHahRkDSZVoluddfKBDF1tyqVDAIQqDZHCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVkTtZnYW0Pnu55piz1Ew9YrprIK8CIox6Czs7Y2On0Hqt3R2e8V27nUF3K2Oxnd/WODt+nbkCoPRqDnRhPzwG8Ogs3lOGVyTUultU+L6L9FftMMpmskbm5Y4kkJyEafXjViGKHh0ww+URwopxfoE5wtzkNgBCu8iuIJpmwlGlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pg+Q+MXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pg+Q+MXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB90C4CEE5;
	Mon, 10 Mar 2025 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630705;
	bh=faNorA/pvHahRkDSZVoluddfKBDF1tyqVDAIQqDZHCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pg+Q+MXviAn54QXIst+XLLXxj/52UacRN7cd62W2wKF9f178rIcKZaXWLlpkUYffc
	 Ou5HXR8TCA6eMOMjVDynoVHZinM5+aZrxI4cLI7Eou1gVro2yiTg4UVIHtF9Ytb6pP
	 4v9+ZRbFPAtvERme/cQRNV9Ji8tfvQKvTp4NDcSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Anton Makarov <anton.makarov11235@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/620] seg6: add support for SRv6 H.Encaps.Red behavior
Date: Mon, 10 Mar 2025 18:05:52 +0100
Message-ID: <20250310170605.534679632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit b07c8cdbe918aa17da864da9a89b22afaed0393e ]

The SRv6 H.Encaps.Red behavior described in [1] is an optimization of
the SRv6 H.Encaps behavior [2].

H.Encaps.Red reduces the length of the SRH by excluding the first
segment (SID) in the SRH of the pushed IPv6 header. The first SID is
only placed in the IPv6 Destination Address field of the pushed IPv6
header.
When the SRv6 Policy only contains one SID the SRH is omitted, unless
there is an HMAC TLV to be carried.

[1] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.2
[2] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.1

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c64a0727f9b1 ("net: ipv6: fix dst ref loop on input in seg6 lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/seg6_iptunnel.h |   1 +
 net/ipv6/seg6_iptunnel.c           | 128 ++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index eb815e0d0ac3e..538152a7b2c3f 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -35,6 +35,7 @@ enum {
 	SEG6_IPTUN_MODE_INLINE,
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
+	SEG6_IPTUN_MODE_ENCAP_RED,
 };
 
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 135712649d25f..0e4b11d190be3 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -36,6 +36,7 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 	case SEG6_IPTUN_MODE_INLINE:
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		head = sizeof(struct ipv6hdr);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
@@ -197,6 +198,124 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 }
 EXPORT_SYMBOL_GPL(seg6_do_srh_encap);
 
+/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
+static int seg6_do_srh_encap_red(struct sk_buff *skb,
+				 struct ipv6_sr_hdr *osrh, int proto)
+{
+	__u8 first_seg = osrh->first_segment;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net *net = dev_net(dst->dev);
+	struct ipv6hdr *hdr, *inner_hdr;
+	int hdrlen = ipv6_optlen(osrh);
+	int red_tlv_offset, tlv_offset;
+	struct ipv6_sr_hdr *isrh;
+	bool skip_srh = false;
+	__be32 flowlabel;
+	int tot_len, err;
+	int red_hdrlen;
+	int tlvs_len;
+
+	if (first_seg > 0) {
+		red_hdrlen = hdrlen - sizeof(struct in6_addr);
+	} else {
+		/* NOTE: if tag/flags and/or other TLVs are introduced in the
+		 * seg6_iptunnel infrastructure, they should be considered when
+		 * deciding to skip the SRH.
+		 */
+		skip_srh = !sr_has_hmac(osrh);
+
+		red_hdrlen = skip_srh ? 0 : hdrlen;
+	}
+
+	tot_len = red_hdrlen + sizeof(struct ipv6hdr);
+
+	err = skb_cow_head(skb, tot_len + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	inner_hdr = ipv6_hdr(skb);
+	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
+
+	skb_push(skb, tot_len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	hdr = ipv6_hdr(skb);
+
+	/* based on seg6_do_srh_encap() */
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
+			     flowlabel);
+		hdr->hop_limit = inner_hdr->hop_limit;
+	} else {
+		ip6_flow_hdr(hdr, 0, flowlabel);
+		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
+
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		IP6CB(skb)->iif = skb->skb_iif;
+	}
+
+	/* no matter if we have to skip the SRH or not, the first segment
+	 * always comes in the pushed IPv6 header.
+	 */
+	hdr->daddr = osrh->segments[first_seg];
+
+	if (skip_srh) {
+		hdr->nexthdr = proto;
+
+		set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+		goto out;
+	}
+
+	/* we cannot skip the SRH, slow path */
+
+	hdr->nexthdr = NEXTHDR_ROUTING;
+	isrh = (void *)hdr + sizeof(struct ipv6hdr);
+
+	if (unlikely(!first_seg)) {
+		/* this is a very rare case; we have only one SID but
+		 * we cannot skip the SRH since we are carrying some
+		 * other info.
+		 */
+		memcpy(isrh, osrh, hdrlen);
+		goto srcaddr;
+	}
+
+	tlv_offset = sizeof(*osrh) + (first_seg + 1) * sizeof(struct in6_addr);
+	red_tlv_offset = tlv_offset - sizeof(struct in6_addr);
+
+	memcpy(isrh, osrh, red_tlv_offset);
+
+	tlvs_len = hdrlen - tlv_offset;
+	if (unlikely(tlvs_len > 0)) {
+		const void *s = (const void *)osrh + tlv_offset;
+		void *d = (void *)isrh + red_tlv_offset;
+
+		memcpy(d, s, tlvs_len);
+	}
+
+	--isrh->first_segment;
+	isrh->hdrlen -= 2;
+
+srcaddr:
+	isrh->nexthdr = proto;
+	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (unlikely(!skip_srh && sr_has_hmac(isrh))) {
+		err = seg6_push_hmac(net, &hdr->saddr, isrh);
+		if (unlikely(err))
+			return err;
+	}
+#endif
+
+out:
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
+	skb_postpush_rcsum(skb, hdr, tot_len);
+
+	return 0;
+}
+
 /* insert an SRH within an IPv6 packet, just after the IPv6 header */
 int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 {
@@ -269,6 +388,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 			return err;
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 		if (err)
 			return err;
@@ -280,7 +400,11 @@ static int seg6_do_srh(struct sk_buff *skb)
 		else
 			return -EINVAL;
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		if (tinfo->mode == SEG6_IPTUN_MODE_ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh, proto);
+
 		if (err)
 			return err;
 
@@ -516,6 +640,8 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
 		break;
+	case SEG6_IPTUN_MODE_ENCAP_RED:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.5



