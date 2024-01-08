Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB55D4C602;
	Mon,  8 Jan 2024 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsoSloGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D201DC433D9;
	Mon,  8 Jan 2024 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728238;
	bh=UeVQ0WKcFVmmPURupEiY4OwRpHFZxcXAW9+UZVWX4JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsoSloGmfbNlW6B/CAFyT8FmMPzSBrbsDVq+yddaZ7dAR5tzkCHFQRjcoIcjOD5Gl
	 k2fDfzbzZ+3s9Ck7k/WnpKFzwRT1Wt3HTwQCv0lDonmtdY5zjCMwochAss21OlZXNe
	 MkR9IscZLBGnSfctMkKTSpNk3gIERut3KWCmj1OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/150] netfilter: use skb_ip_totlen and iph_totlen
Date: Mon,  8 Jan 2024 16:34:25 +0100
Message-ID: <20240108153511.921030793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a13fbf5ed5b4fc9095f12e955ca3a59b5507ff01 ]

There are also quite some places in netfilter that may process IPv4 TCP
GSO packets, we need to replace them too.

In length_mt(), we have to use u_int32_t/int to accept skb_ip_totlen()
return value, otherwise it may overflow and mismatch. This change will
also help us add selftest for IPv4 BIG TCP in the following patch.

Note that we don't need to replace the one in tcpmss_tg4(), as it will
return if there is data after tcphdr in tcpmss_mangle_packet(). The
same in mangle_contents() in nf_nat_helper.c, it returns false when
skb->len + extra > 65535 in enlarge_skb().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0ae8e4cca787 ("netfilter: nf_tables: set transport offset from mac header for netdev/egress")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_ipv4.h | 4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c        | 2 +-
 net/netfilter/nf_log_syslog.c          | 2 +-
 net/netfilter/xt_length.c              | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index c4a6147b0ef8c..d8f6cb47ebe37 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -29,7 +29,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 	if (iph->ihl < 5 || iph->version != 4)
 		return -1;
 
-	len = ntohs(iph->tot_len);
+	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
 	if (pkt->skb->len < len)
 		return -1;
@@ -62,7 +62,7 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	if (iph->ihl < 5 || iph->version != 4)
 		goto inhdr_error;
 
-	len = ntohs(iph->tot_len);
+	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
 	if (pkt->skb->len < len) {
 		__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INTRUNCATEDPKTS);
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 7243079ef3546..b452eb3ddcecb 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -994,7 +994,7 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
 		old_dsfield = ipv4_get_dsfield(old_iph);
 		*ttl = old_iph->ttl;
 		if (payload_len)
-			*payload_len = ntohs(old_iph->tot_len);
+			*payload_len = skb_ip_totlen(skb);
 	}
 
 	/* Implement full-functionality option for ECN encapsulation */
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index cb894f0d63e9d..c66689ad2b491 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -322,7 +322,7 @@ dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 
 	/* Max length: 46 "LEN=65535 TOS=0xFF PREC=0xFF TTL=255 ID=65535 " */
 	nf_log_buf_add(m, "LEN=%u TOS=0x%02X PREC=0x%02X TTL=%u ID=%u ",
-		       ntohs(ih->tot_len), ih->tos & IPTOS_TOS_MASK,
+		       iph_totlen(skb, ih), ih->tos & IPTOS_TOS_MASK,
 		       ih->tos & IPTOS_PREC_MASK, ih->ttl, ntohs(ih->id));
 
 	/* Max length: 6 "CE DF MF " */
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 9fbfad13176f0..ca730cedb5d41 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -21,7 +21,7 @@ static bool
 length_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
+	u32 pktlen = skb_ip_totlen(skb);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
-- 
2.43.0



