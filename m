Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74434B8287;
	Wed, 30 Sep 2026 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783770; cv=none; b=spSANA4qthCVQy9fgpgnYWiZ2ciY8PN/tYxbr97lPFr3M4HoNOdX7JCbci9/mmeBjV418ylEcfLtFPKqkXb5VMmyAQbqcBxJK3VfWu5i3QUHXHgSjVSmhizKjXXOrCL4HhspgipzypOMdEqlLUWYk5S/E8rUWsSxAGtCUY1m65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783770; c=relaxed/simple;
	bh=IeLykkcQ4heYzdQGPD0Qa0nf6eLu0drOKsplLFkdAfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex6QoprC+kFbL6Uiqj4OsI/KGql/wCCuLoG3Abb//OiL9pBcgJsd9blx8VzmmaCpyEMqMLKwHK63sHtthboIwjAdJf63X/cwsuj4ltyLxAI4nWxWhaVDKzFLj+H/YEOB2V87lxOGPUUUIjboFaK1UdiItY88q0kMZW3wagOL3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeFr0o5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeFr0o5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7BB1F00893;
	Wed, 30 Sep 2026 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783764;
	bh=tkVzomqFe63JvQf3SsugVoe7OL6lMVKPZIR2nxz2Fnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeFr0o5qRFKYu1cxO41L0HV3n5jokTJDcugACVpsk761S1G7n3kj74U/r9UncSvna
	 E3vVeqJUmiGP9p+wIUUNnBqbxvUkeAcBie84d0ns+81TyugI9KxBcTJbraPwTpGnMR
	 l9ePhQN+vkNG0VWrQsoOfjHhQ492SYBJ8aECUqs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 497/595] netfilter: nft_synproxy: use the family-aware checksum helper
Date: Wed, 30 Sep 2026 17:26:30 +0200
Message-ID: <20260930152358.384340300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a311a898172743558b82f6035ef2aa8c310a4223 ]

nft_synproxy_do_eval() verifies the TCP checksum before it switches on
skb->protocol.  It uses nf_ip_checksum(), which constructs an IPv4
pseudo header and relies on the IPv4 header checksum when folding the
whole skb.  Neither operation is valid for an IPv6 packet.

A correctly checksummed IPv6 segment can therefore fail verification
when it reaches the hook as CHECKSUM_NONE or, at NF_INET_LOCAL_IN,
CHECKSUM_COMPLETE.  nft_synproxy_do_eval() returns NF_DROP before
nft_synproxy_eval_v6() can send a SYN-ACK.

nft_synproxy_validate() deliberately admits NFPROTO_IPV6 and
NFPROTO_INET, and the xtables counterpart ip6t_SYNPROXY.c already calls
nf_ip6_checksum().

Use nf_checksum() with nft_pf() so the checksum helper dispatches to the
packet family's implementation.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_synproxy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index aaba34ed0f717..b02b193a42556 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -117,7 +117,8 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
-	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
+	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
+			nft_pf(pkt))) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-- 
2.53.0



