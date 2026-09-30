Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D284DEC26;
	Wed, 30 Sep 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792332; cv=none; b=IdJGmt4lNkEyEm+VyOvwb4ckSWmgWEBWwdJYnSWE4cfm2fLj1YLLtFP+J75ODCHtV1p5EYBjW5NYFGHt7StvS8r79czCZN0LLIBBCG+wEuDEgpzJqhMW7nr5qZhfqCxme1bOpVv6a2XRH45ZPnssDdvnsEuaUlZD1Ze7szY9vxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792332; c=relaxed/simple;
	bh=7z2RiH4cDXEaWJH0y2R8BaPKngpbxYk/T1ucg1WmKN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUff4Ts2oibskJgagZXQZcdx1r1xUu8aRqE4kbuMIzBaTF81YZ/qSU/4ADcJ8j2izZs5kMRCYjn8xcKcSd95L4qQfxh1q8C9eDHKwMAkUD4qyBRTj9U32yzoFVC6sKAILC0id1F33L5bpBytmFJNhnWTpuLTpLEzBHrwvhUk5V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQelRd3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQelRd3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546471F000FF;
	Wed, 30 Sep 2026 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792330;
	bh=XbwEFpkJN335ItOyAldLoydNOYE2ol4aXfVDAk0Xgxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQelRd3kQuUJO2vm7+u9uO3oXUlkW1PLcmcfcDZMLDYflIt9FK3B7gyixP6NXBYu2
	 XqNUVLGDpabEqFwy02CumzTOvl7+ZznaUbg7QBPuHK5AZdmxjXkI2Rhi4Gjx7zxBLx
	 VQdcmxDbg4Msjkcyvq8vksfzGm46xOfVurYScYB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 618/752] netfilter: nft_synproxy: use the family-aware checksum helper
Date: Wed, 30 Sep 2026 17:28:08 +0200
Message-ID: <20260930152411.653380531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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



