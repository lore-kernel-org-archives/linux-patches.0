Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC9846D2D5;
	Tue, 21 Jul 2026 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660966; cv=none; b=EAEgWwg9UoDXkJVWYgQbFjQDllN+219PpmtvLZI+8XM5C1aik0XcxJCvczSYDgy4cWFhyCaDTGHVmBZjvhoAle1BRDyj86cl/zPpyFCOc8QpUJuu0kyCIt+Nu2tMJqVGcKEcIfrN/0q7od4e0dwv8Rs3QP5tt+j1NVKVf5dhPiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660966; c=relaxed/simple;
	bh=xKpPHFG18YdqD1BHoRVcH0x9rKGJkIHozWdwBRuHU6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKrL5Lsmt7XgBneKYxd4nBwJdTBloW21XqKwqyHjceS27W/dW2246nVlXZMxuhhELC/gi9BQ169Tq1qfjiot525DWXhlVtGGPXjbZJ6sj1qFQLzw0KQHXpCW/nJSxPz8QSnm3dm0pN+TmtIPihX2WatPQquvmBXqrJ7Rkp9w7Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AS276l8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AS276l8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2181F000E9;
	Tue, 21 Jul 2026 19:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660965;
	bh=L5IgQ9DTCFhVVd14D8zNcU1BhhvpbBJI0lHWe5hfZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS276l8EGsvcERkNWkm103pgDIuOL28OaO/0JTsAIEihVnav8zqk0hkm1X3gdS+Hq
	 78mqv7TWFyjTs9DWZs3i5wRJPisF/AXn260XUMZWGEiTaiHEcWxRYWyGI5MZ6BH4bH
	 R0DCOVIST27VWL5qeOMFnDTgE9e4ok4+FSucZnao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1153/2077] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:13:46 +0200
Message-ID: <20260721152620.019326227@linuxfoundation.org>
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
index fecf6621f679f9..4626dc46808f3a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -89,7 +89,7 @@ static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
 	if (iph->protocol != IPPROTO_ICMP)
 		return false;
 
-	thoff = skb_network_offset(skb) + sizeof(*iph);
+	thoff = skb_network_offset(skb) + ip_hdrlen(skb);
 
 	tp = skb_header_pointer(skb,
 				thoff + offsetof(struct icmphdr, type),
-- 
2.53.0



