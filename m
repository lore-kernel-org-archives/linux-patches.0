Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5146D0A4;
	Tue, 21 Jul 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657649; cv=none; b=H+09/kq6t0IiCUfFRIG6DotNK+tZygD0Qp0noh9qtljje6UuPBq0ejRrxcU7eceWi9upkP7/hBq1G6qnky2vYw97gV0xT4jlk1/I2hPGot1X86kOdukEfkHbzOcMRRnRjflHfksdFO/VOkeyJTiv83vjHFxW+ZLw1Kahn9Quatc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657649; c=relaxed/simple;
	bh=M95BzvCey6dLjqYvcbsnXo23LAWrwWFGQ3aqIsHa3s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxnhPDdaQWBDwFQg2ZD2SvSep7zAHA0SLbSDtVMDm7RpNV3S48ybhCiUjeZfB5tJ6xGPRWBkMoTA/oyKxgqxkvux2yYvMKf9qKVKiFhMRhqU6jxm2uDZ1Rz5/PWt2ADL7+OlDCFnBXPu9aigFzYBZ+6xjNq3MsmFZbUrpSwTtzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRjdokn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRjdokn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABBD1F000E9;
	Tue, 21 Jul 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657648;
	bh=ssUwm50F99VJqcqCh6GKmDwy5Hli+NX2O3gnQDCPBTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRjdokn9t5fKXHvpH4OKi4ErGwDaKVWoQu8X42VrpW4flyA8/xKHPhld6wyN/xkBd
	 tBaa48dYzVmdaXFeLHMlfaK1wPAqAnzkV5MebyNV8zioOvyoFvECKOUkvt+o/B99/q
	 0m//U1s6cA2FTgJeZdonhcaPSAJFWjEDFvovoahU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0845/1611] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:16:01 +0200
Message-ID: <20260721152534.391686942@linuxfoundation.org>
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
index fae4aa4a5f0955..c47d56576720fa 100644
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



