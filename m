Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC646E015;
	Tue, 21 Jul 2026 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658271; cv=none; b=qHWUFeA+TQH894J3/RR0RtuP+O3m8WtFCz6r+81PEx63aKDwdutg7XR2AFIpXhiYqiAdgyAwOHknSAZ85BSAgjCZfGfoW6Occt8AxoEkkrjty/SBU6qJfIKiEg9+neaDkokf2uH8mtdrFUQchZaBEg+HljlBz5nZMm5kAAVt8Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658271; c=relaxed/simple;
	bh=XM2kmicJ+/L/ks+06mlazJjF5XuaCnW2kCwx4yXoskY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhP1jshB5P9VkWrEuxHq4q18dDjcumULoiev+PMuWMGbnV4xyY3Lu/ra0QHrVF2bIA2qWiCOFChTLx9nY1dlYuAze7A8Fl/UwNu8Xr+1PoubaK9k8GHDhpv/pGMVG4NNbOaPhr59UPcP0sg1b38TeCjtRXKRR19sybFY7znFcrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHjPZpjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHjPZpjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CFC1F000E9;
	Tue, 21 Jul 2026 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658269;
	bh=53VW822uteRnA/lC5JcLE2G1fSUIXqZLzNhQoUXt3NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHjPZpjQXoThoDF3Vbh6YATRcoNGlJ11abuIolid5zmDHO5nhOMZi/usysOb8LFIK
	 8wwDIOrbh0qfb+lTUnKsGo9I32Ovl96RLdI6bfPrbwBb4VunsA8D82pYxAoczGrKbs
	 6R0Lcyku1Atev/E6pssU87BuQy4sGlDyJlqs9vfs=
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
Subject: [PATCH 6.18 1081/1611] ipvs: use parsed transport offset in TCP state lookup
Date: Tue, 21 Jul 2026 17:19:57 +0200
Message-ID: <20260721152539.726032094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



