Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE63F471257;
	Tue, 21 Jul 2026 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662981; cv=none; b=FBvr/RTwSNEav27u17HrDJ0EGd31+/WeYdgktfm4cXMwuxYNfAS9+TgMLwNuD53/Qrf+X1YVnhAJl4qrq3UgtirUGpOQfgRhLRtMi96MicB+b0Wcui+9lW8rCB0vaMExlTRpghQRdxmsDVHEhGPp4PWrOSmM/L72T/uA8JJpmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662981; c=relaxed/simple;
	bh=IigdIGKdmka1EiW9ciXcc2ZPc2Ci2v9NpzZcjBmnD80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H59Gi3cfkFUxOFLmGj3oarHnDZjJoxdoTwFcMrgzMGhbOMlT0pycoEbNHtRxq3SufuoEzP4+6yzE+kKaON2ys1k5+1C7mrmz6Lep4EcJjtvFTQYtH3bpRDZXfyaq8yMrk5JTs8AoDD2wUZ623MASZglRFFvJP5qaH5Xxb+T+1YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAdrcCOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAdrcCOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D76F1F000E9;
	Tue, 21 Jul 2026 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662979;
	bh=GPy3R8j+TIiCrjfLRZK7+/nzoRqqV8sGNu5biFIgOfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAdrcCOB3rz6j/Xxm50CLDD2cBcMELcNGnVFkerKgggtv385JUp6DfQH0sj2Evneb
	 77lr0LTwtTlH0/0POtHXL7yFmExpcG0VxgRHKjFuTxCQcjqV7cwwp6EzcI42ROP2RV
	 4V2VLQ4rSdZ8bHREAh2TXzK3cKHscoErUvLMuCS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0597/1276] netfilter: nf_reject: skip iphdr options when looking for icmp header
Date: Tue, 21 Jul 2026 17:17:20 +0200
Message-ID: <20260721152459.474156357@linuxfoundation.org>
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
index a7a3439fe78004..1c739587bacde2 100644
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



