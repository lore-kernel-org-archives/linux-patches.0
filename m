Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D7335C6BC;
	Tue, 21 Jul 2026 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669951; cv=none; b=HlxUSqKpb1lxUZ2sw/8VUvaY9tcb9XiweQDpiHko+O9L/NdbfVhvnDtSACYHdlKcw13NPNg6qEemvmZYCTm/0gJ8HBTGvRtLrt6yhYrBk6DmDPpN3wtviv9XQkNrDMVouob5/T/1wlpaVpMvVJMO+jaTBv1Z1i0rYv+gvUhEtSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669951; c=relaxed/simple;
	bh=FiIN/2vA2KSYeWeFSGiVbdFwnDhuRJh1nRV/9gVvFaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJcAnsM11xgFF8vVVfA/qL1/mxhbncPdLKIlVYpqWb4CuAmZOGjP3RNpcu9m+h/I9W+PF2MbbBl/rf9vYpm1gDY4Mr2qCq/gzlVzY8duW6B6WNKZrViMBreYMnJemcZaX7/nZovZ9+gjZII1u93VBzqwywkGJbEjeAqzkLZhbGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5hbRZyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5hbRZyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCFE1F00A3A;
	Tue, 21 Jul 2026 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669949;
	bh=4YuMb54r1UyRgjTA3gKY/a+qtAk+cB+1goux5tVlHPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5hbRZyjXMGvqSfykJVQfBKG1EfCQPa+uOXSClFy3/Hx6PXxU0orzxiKDcAU3kSub
	 QIVqwgc88p7bpos4vL7H6hqQL/32IXfbFhVyELrBBkeXLaDxOO+XLhGYh9nEF5I9tG
	 bsulpD0PUKvQJcDqC3TEdiLE7p+shIhsPMdyAPI8=
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
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0705/1067] ipvs: use parsed transport offset in TCP state lookup
Date: Tue, 21 Jul 2026 17:21:46 +0200
Message-ID: <20260721152440.361406721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 2500fa3958b1ba51c2b065e39db1b04dfa7e23a2 ]

TCP state handling reparses the skb to find the TCP header. For IPv6 it
uses sizeof(struct ipv6hdr), while the surrounding IPVS code already
parsed the packet with ip_vs_fill_iph_skb() and has the real
transport-header offset in iph.len.

This makes TCP state handling look at the wrong bytes when an IPv6
packet carries extension headers. Use the parsed transport offset passed
down from ip_vs_set_state() when reading the TCP header.

For IPv4 and for IPv6 packets without extension headers, the passed
offset matches the previous value.

Fixes: 0bbdd42b7efa6 ("IPVS: Extend protocol DNAT/SNAT and state handlers")
Link: https://lore.kernel.org/netdev/20260705125659.37744-1-zhaoyz24@mails.tsinghua.edu.cn/
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index dc8394383c148e..b382810156b2c6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -585,13 +585,7 @@ tcp_state_transition(struct ip_vs_conn *cp, int direction,
 {
 	struct tcphdr _tcph, *th;
 
-#ifdef CONFIG_IP_VS_IPV6
-	int ihl = cp->af == AF_INET ? ip_hdrlen(skb) : sizeof(struct ipv6hdr);
-#else
-	int ihl = ip_hdrlen(skb);
-#endif
-
-	th = skb_header_pointer(skb, ihl, sizeof(_tcph), &_tcph);
+	th = skb_header_pointer(skb, iph_len, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return;
 
-- 
2.53.0



