Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FC4413D62;
	Tue, 21 Jul 2026 21:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669559; cv=none; b=uzkGcrcSACu0LpwUT7XJiPMmiyOvbMRoE6JWnhlqVqA9oTIBR8pIB8sAn0JMZFfpZGR+pAgtyaXRIafJFYUXQK3AultLVOJ8ECOZQaq0WrKaRxAOw29Z8NTjSq1kW0fNA3Qk7lVRjK5q1EOC0mpOfmJ9Bcq51dM7sTLCzONYGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669559; c=relaxed/simple;
	bh=ETr+T/4wgh3tZ+Hrc9SStw+7m2fH4gtv63ExYtXWLIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7TPKsVONAaIrO2tq8eTz7cxPUXoGJKbOwaCc9E1NAocEz5vWhN7lR+Owc/Wf4cC2ov8xz5ptRNBJdAe3m9tgabgMfi3x8bq0hJK/ssrVJI1i4WJFI7M49o/fqq+KddrqMzsj7lKyB68Qb0ssfd+H/yb2ihZwWQtWhW3S1nFhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrHgD+fd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrHgD+fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945521F000E9;
	Tue, 21 Jul 2026 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669558;
	bh=6o4vLxY10SKok/7FE54to40bMS136tMfjpjsvUJHKnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrHgD+fdM2xjegyuP6xPtkFUPT+yoB5bjI5brT5jOjIDNk5nE3GpUBhGDqlkpInTG
	 IRk261ySCeObnd3L8rqBKf6HHdyJpsdLP387oWh2Zo9S99aBH6SHU7XajL79t7wQMj
	 0oSsSxy7HU6u0nAqZSd1Xvjg9PsBkn5ebFmxe5TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0599/1067] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:20:00 +0200
Message-ID: <20260721152438.003248804@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit af8d6ae09c0a5f8b8a0d5680203c74b3c1daa85b ]

Not a big deal but this hould have used the real ip header length and not the
base header size.  As-is, if there are options then
nf_skb_is_icmp_unreach() result will be random.

Fixes: db99b2f2b3e2 ("netfilter: nf_reject: don't reply to icmp error messages")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2064b401304129..1632cedcd348ca 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -80,7 +80,7 @@ static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
 	if (iph->protocol != IPPROTO_ICMP)
 		return false;
 
-	thoff = skb_network_offset(skb) + sizeof(*iph);
+	thoff = skb_network_offset(skb) + ip_hdrlen(skb);
 
 	tp = skb_header_pointer(skb,
 				thoff + offsetof(struct icmphdr, type),
-- 
2.53.0



