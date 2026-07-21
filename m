Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6E03B52E7;
	Tue, 21 Jul 2026 22:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672077; cv=none; b=hKGSU94QIB9Kz7KS7ZJVayuR86SrCrBLqT4zw/EEX56sDWf/7qentF1BAQp/UlVL42O9jYGnk6eiggmW0AyIr+twQFJGYoiCN+nvwMFoAw0TXcrMYHuChRJWBGD5UmpyV4bOXllhtRNTb21BdWcCptMYs2cx2nHsv/EgTl5Di8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672077; c=relaxed/simple;
	bh=KBthC1cPhkuq4KphNsjzR3bwylCDcSGbPnHjO2ffHV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RznX8bbEHKtaDdFu/pIH/402WwEHUBbaWDggSbTSjRAKuM+UN4biecXUh9PYsANt8//4a3LRLWvTMJFyicMKnEu4gZjhPCi8ujXp0JVwh65icXKe5w9EhC+JK9sliSr0fwK2rA/edQ+W45aCJ2y6gBydTVUCE70t14PxR9EN874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOYjCSTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOYjCSTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39D61F000E9;
	Tue, 21 Jul 2026 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672076;
	bh=vYqjHg0lypATLwDFU8O32S+hVKkiaP+xrwCky6WbP5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOYjCSTH+ARFOYzWNuW36QmNjxSNgWT80GJySUiNxZZlpL7w7HP7xvv4nMQkYgkvT
	 p03X3qh6VSTlTjIKXitJ14FfbrRS6W5/vQllI0UT4F55+ONBhMBrHzmcdZTjnA27Ox
	 wUQA/AqGEQZAk2SjCtNVDLXw2NqnPVVxkI9s0jR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/843] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:21:26 +0200
Message-ID: <20260721152416.173707870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4d16d49b430e9a..fbd264aa0a7ec0 100644
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



