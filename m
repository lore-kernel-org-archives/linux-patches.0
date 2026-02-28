Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC738D01A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302124; cv=none; b=I1nC/FN93YvPb2YBKyhgT60e/Kvqp75V/4u2VCCgpp3wPlIMuC/KJtzqLr9Ta3FqokVKjeXdmzzl2xzSxIE2/bHhS3y023NAabp1Nt6FOuN2LpEfw1E0oRKM2Ot9BWyJXTWiLbBTRxSSEWxbKA3gVk+BuaVRudlwQaODwYzRgrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302124; c=relaxed/simple;
	bh=Djilq7lFIAU4ZgZCWhrv1IcmkWo2ib1QhbL91s1bzRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrSA9vrlWS9OoFyzYHuDpTrCpZ6V0h9eE7/LLLf/FJTjyLQNoUwm/W4kVxUMESaG08un/pMGnF1G5X+4BnbKEkRcwcC03x4gJrB58EJAnnZ36pSGVx8v66dKLh0j5IkWhsm6N/GuSAP7c7vV81/nWgz85if5Vlnlm+9H45ak65I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xf8hf2aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xf8hf2aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ADFC19423;
	Sat, 28 Feb 2026 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302123;
	bh=Djilq7lFIAU4ZgZCWhrv1IcmkWo2ib1QhbL91s1bzRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xf8hf2aWvk42daQA+Ca2TFmAGCBeCaErCw0+6nEoGMAf9G1Uciwy6qED2TirgKxpz
	 snD0jrUOmO02Q/+ggb/TgGUeKhUNv7fZQh01x+InQYr1OjqxjmMozi6QbrwpVepymU
	 wlsXYojeNcurVgnlGdQfUaNwVgsWvespvh4J+yJjQivr+bPDjQW6bNgY9EZRE/IRpH
	 s1sUjGjROPGLwEpIccRDAxUiMxkAoj9UH0hGf9yRJmk/v/Fa/tEuk/funEX0Mm9U3k
	 o1IqiPd1WA9sPTBB1J/E0DqIMeSOGtGMqdHuVp7+GELgwxSmP28FP/5S1R0K/tCA5C
	 5HFU98igno2Og==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/283] netfilter: nf_tables: reset table validation state on abort
Date: Sat, 28 Feb 2026 13:04:17 -0500
Message-ID: <20260228180709.1583486-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6f93616a7323d646d18db9c09f147e453b40fdd7 ]

If a transaction fails the final validation in the commit hook, the table
validation state is changed to NFT_VALIDATE_DO and a replay of the batch is
performed.  Every rule insert will then do a graph validation.

This is much slower, but provides better error reporting to the user
because we can point at the rule that introduces the validation issue.

Without this reset the affected table(s) remain in full validation mode,
i.e. on next transaction we start with slow-mode.

This makes the next transaction after a failed incremental update very slow:

 # time iptables-restore < /tmp/ruleset
 real    0m0.496s [..]
 # time iptables -A CALLEE -j CALLER
 iptables v1.8.11 (nf_tables):  RULE_APPEND failed (Too many links): rule in chain CALLEE
 real    0m0.022s [..]
 # time iptables-restore < /tmp/ruleset
 real    1m22.355s [..]

After this patch, 2nd iptables-restore is back to ~0.5s.

Fixes: 9a32e9850686 ("netfilter: nf_tables: don't write table validation state without mutex")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a0a5d19fa8506..8532d832aad6a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10824,6 +10824,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	if (action == NFNL_ABORT_NONE) {
+		struct nft_table *table;
+
+		list_for_each_entry(table, &nft_net->tables, list)
+			table->validate_state = NFT_VALIDATE_SKIP;
+	}
+
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
 
 	/* module autoload needs to happen after GC sequence update because it
-- 
2.51.0

