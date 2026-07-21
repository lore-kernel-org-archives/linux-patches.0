Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1E32EBB8D;
	Tue, 21 Jul 2026 20:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666600; cv=none; b=oD10hRkOOglqjMqpiYjFaTw43zJnj+PgRAvWXovtBOPlkOp+1MBwFbFhHuFffGKW/FxqS+ymhqekPSZxtafwSIx4lLyDZH+fWx4Q8YBKt4INt66GDOSHQ0MAlcar3kmzRAVRve+M2u5y3Jz0n40Rq8JVQXFGzZgdPvS/9rA8rUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666600; c=relaxed/simple;
	bh=lM3emk4paP9qxDKTgPpLdXuVQe7GzdX70zts3wRAVK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mki1XgaWfPuC5MiV1Pl/+O4ZKHOz/rgiRiHxv3pBI8VRDzejgmrM9fr5oY7Fbc/arz2gkX4Ef906LBR47YiQ6V6p8e+XUdNjcRXMvECITwVUgZ1CvHe32rLXz/fYvwHRtB9fHrffQbb+RVjTdVKZ4XpJN2wmS4qr5llWN4ZKDO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCyaaVNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCyaaVNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43681F000E9;
	Tue, 21 Jul 2026 20:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666599;
	bh=g0NWfzM314MtLZhpfP+GBAiSr/mQSC1PyjUpYz1x/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCyaaVNkBCs0kQJgy6Zz/61gI8WgkKCQvhjrSUOCCgLtEmiS7OAqcJSGmOwufPLku
	 FLBbS6pj3pF0gj+aTfkMi8lQYditpU88VEFrwTqgYse9VtuN8d4SN67P/SauOnZu4M
	 EOceIvtiuBo+Pjo1rxpn5X0YjMIBz6KEm6TMArM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0745/1266] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152458.541764924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



