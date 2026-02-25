Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8D418B0A;
	Wed, 25 Feb 2026 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983256; cv=none; b=mXvDxrydI73Omjq9YGx9KuC4cmLqqW3PLuOJ1Ibr6DzvAbu0Rsz0rf3Wu9Oce0iyNbMTDuMZgK1j20iomLl7qVocbRKXrVFLX+Sc9lMZUYfUgCIhmz45QZcbnoHkaqj7w7GuEOt7M+m+8kPCTEsn6pPd5lY+InWJ1RhaV5FHyc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983256; c=relaxed/simple;
	bh=TSqL8/e/l3vQoDKC7q2TLODonjE2NudyX6AG3Jqu+zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgsVahqqoeVx0njDQWcf7uE41ceIKZJqDcNY+MlqCQKN8d1H/4b6Q8aELg56dhYbw/CR/NGcAjodfsM7jnYdqCL2YFkIy0WWdxF0UOgiKraxBOBE0N4s2KoyK+CHLwg3IH+Q65IzKXmEKDvu0bQdkF3TL0gJ/DASgfSSL/6XxQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSupuQ4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSupuQ4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C30FC116D0;
	Wed, 25 Feb 2026 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983256;
	bh=TSqL8/e/l3vQoDKC7q2TLODonjE2NudyX6AG3Jqu+zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSupuQ4eyYOxmKoGvK345y6NhvDDn/OdNo5HHVjyZsUmUdjzx4CJS2pNvG64EOPdC
	 6To5NRRDCjRq6tdRJChe09auOZ4VoGAYjz1XhBpKs/DrdK78iiDbyrYaajuF8Wb1PN
	 qZ4rn3NqviEV+rKQBekImTjWDR5ozGxplSk53ioU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 345/781] netfilter: nf_tables: reset table validation state on abort
Date: Tue, 24 Feb 2026 17:17:34 -0800
Message-ID: <20260225012408.154779128@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index be92750e2af3a..ec9e5e2a9f277 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11536,6 +11536,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
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



