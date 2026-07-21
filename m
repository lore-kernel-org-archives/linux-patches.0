Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2B537A821;
	Tue, 21 Jul 2026 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653879; cv=none; b=U0lEvHga+XPyUhLXc5j1bXfHSEEiLZMKqbVUSXKqPpqBuEr7iXu484tbPSRT+Bm0xyeH8yx8qx9ziq0JScv66XIXpFjWV/cDGY4BcRS7bJCy1+EtuUKnoPyxy0lMacS8q4xM1C9cFjxnzu7IjdOBJpcZIh5eKI8S52cUJqOWf24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653879; c=relaxed/simple;
	bh=sqdxnkbF89QhOXEyjnhr00W/yNUDrUB5b+UtnDPyJbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oisFq1PWqi37LsT70pxa8MKKLHVOmv5QaReWwJQfZ8AisNoeRTCqUUU2pxD+JVBZXeF6+NjfH84kUNMRjAnOuGEBq7GnUVBj6oTaCKvIaY4v2//LZrclDhyv4fR5UWA8Ght5Ub7+aGPNzTU0k52HJos+yr+sCLQRxK6DDt8lT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaERysmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaERysmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1318B1F000E9;
	Tue, 21 Jul 2026 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653877;
	bh=HLe4JwSTFGa40RBhJQTD5yWoxg9vP5ZYhckNVgCJyrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaERysmbgRStqzvBUGh1DLYTQmLqElQbo+pa+WNOny1iC0ouuhNxh02sq6v+vaiW4
	 dqJqnTQf/LYNKu9svIoHEvH8IVVgl2qkIV45KIBs6KYnxuggEgVylo9bA8dHbNH5eH
	 PaaE617P1Ek91sEpgXdV9Q/aSuesOsmcIRuVI8q8=
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
Subject: [PATCH 7.1 1493/2077] ipvs: use parsed transport offset in TCP state lookup
Date: Tue, 21 Jul 2026 17:19:26 +0200
Message-ID: <20260721152628.007666644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d3f6aeafe522d..f86b763efcc4dc 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -584,13 +584,7 @@ tcp_state_transition(struct ip_vs_conn *cp, int direction,
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



