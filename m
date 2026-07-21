Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B847140F;
	Tue, 21 Jul 2026 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664155; cv=none; b=SM4UyLqUnz8TsvWwi7czQeqmrLw+R40O7Sfsz3U/5Vpksxrr0Px7ALrUiq7BH9245zBBhNnfKWgOngkDhFQVjQ8X+MXMBqWwJ1UG6grWPXr6xntXu+kzs30M8A1TBedjilTasp2DLrju+c437VDnKmlpqmU15wTcxT421klMOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664155; c=relaxed/simple;
	bh=yUylF7H/wA6VaGlpA/KSkKdx+7bxDQOK0gV/7n21HY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7Nupwq0YZDTgSRklSErItLCWY1dburfeK4GKB/+mVy4NVmhabPU5lmAhCatLnkGMotMU3CVtkqZwILvEyPis93ID7C7406Yf5dni5tzs9y5mQ4NNj0GJoaqgHeLDmKDK5z0WAz45IikD1cLVI+IT200ky0Lm0GqNENNlfvbsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdxJMfKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdxJMfKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BF31F000E9;
	Tue, 21 Jul 2026 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664154;
	bh=wAojP5DnZ96eyUQ+zd2THIPgGLQ4iI6qN2wM/xWkLbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdxJMfKSMkiZEVAbzEO20/LGNRYxLg/hpSARz53hntFl3G/3E0+mlvb/FEBmdg0Y4
	 1eHZY5gFxSs0Dxi9Zvm2nd4mRFa9TVHIem/ERzLqfv5NixXkZtpsHIn+NPzUgNS/pK
	 wRxGy+jOQD3TCx6XA7fAmtVtp0NGi4XzmN+TTD74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.12 1092/1276] ipvs: use parsed transport offset in SCTP state lookup
Date: Tue, 21 Jul 2026 17:25:35 +0200
Message-ID: <20260721152510.421963939@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit 2f75c0faa3361b28e36cc0512b3299e163e25789 upstream.

set_sctp_state() reads the SCTP chunk header again in order to drive the
IPVS SCTP state table. For IPv6 it computes the offset with
sizeof(struct ipv6hdr), while the surrounding IPVS code uses iph.len from
ip_vs_fill_iph_skb(), where ipv6_find_hdr() has already skipped
extension headers and found the real transport header.

This makes the state machine read from the wrong offset for IPv6 SCTP
packets that carry extension headers. For example, an INIT packet with an
8-byte destination options header can be scheduled correctly by
sctp_conn_schedule(), but set_sctp_state() reads the first byte of the
SCTP verification tag as a DATA chunk type. The connection then moves
from NONE to ESTABLISHED instead of INIT1, gets the longer established
timeout, and updates the active/inactive destination counters
incorrectly. This happens even though the SCTP handshake has not
completed.

Use the parsed transport offset passed down from ip_vs_set_state() for
the SCTP chunk-header lookup. For IPv4 and IPv6 packets without
extension headers this preserves the existing offset.

Fixes: 2906f66a5682 ("ipvs: SCTP Trasport Loadbalancing Support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260705123040.35755-1-zhaoyz24@mails.tsinghua.edu.cn/
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -372,20 +372,15 @@ static const char *sctp_state_name(int s
 
 static inline void
 set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
-		int direction, const struct sk_buff *skb)
+		int direction, const struct sk_buff *skb,
+		unsigned int iph_len)
 {
 	struct sctp_chunkhdr _sctpch, *sch;
 	unsigned char chunk_type;
 	int event, next_state;
-	int ihl, cofs;
-
-#ifdef CONFIG_IP_VS_IPV6
-	ihl = cp->af == AF_INET ? ip_hdrlen(skb) : sizeof(struct ipv6hdr);
-#else
-	ihl = ip_hdrlen(skb);
-#endif
+	int cofs;
 
-	cofs = ihl + sizeof(struct sctphdr);
+	cofs = iph_len + sizeof(struct sctphdr);
 	sch = skb_header_pointer(skb, cofs, sizeof(_sctpch), &_sctpch);
 	if (sch == NULL)
 		return;
@@ -472,7 +467,7 @@ sctp_state_transition(struct ip_vs_conn
 		unsigned int iph_len)
 {
 	spin_lock_bh(&cp->lock);
-	set_sctp_state(pd, cp, direction, skb);
+	set_sctp_state(pd, cp, direction, skb, iph_len);
 	spin_unlock_bh(&cp->lock);
 }
 


