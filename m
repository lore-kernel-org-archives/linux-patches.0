Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9123248886;
	Wed, 25 Feb 2026 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984004; cv=none; b=Pj6r4k1uyK3KcOAZY3iWN73pkVA3s4jF6yXshbLn9vLJj2CfoOMb5wgETkwQ8NzQqqyIzNwHLksHGWW63UL5DzYYnXrYNeKmwr0qx5H932mEiD83jjAJ+kSOgeKkGWWp8A4szAMCqVXcLC9WrcgOGT2waqnU9Ug1aIr3eEGkUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984004; c=relaxed/simple;
	bh=NRmaXp04joY0e+4ZWnk9fqUu3g7Mvx5gppyU8hH5WAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6E0QhJm2m+3wh8iFYgcUyddrMUSs6fX8G8MNLF0xVVBCBgZrXhkJ/6IW0YxhkJhfHVKbqBMtLpqlqcdHoSOwf0t+oZ49A0Q/zvBzALyQu7HztGREa8cPvWSMFLjmhD3fMXCL/iF1TCbN9XViQS2oSvYS+VRzWZdZcRpc06ozfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4+42LJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4+42LJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63227C116D0;
	Wed, 25 Feb 2026 01:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984004;
	bh=NRmaXp04joY0e+4ZWnk9fqUu3g7Mvx5gppyU8hH5WAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4+42LJX3cIUaI9MhC8x3UcvT0bZh/qF2/4knUOlIOxUFvitE9CqdrESpXncNaTHR
	 T3Y4sjNxW23TzC7pD5exXwJukX62Mx0+qSCdjyN1oPdnvWmGMMwogod5HyNU0bm5rP
	 GpojBrGzDbNQKMkzmm1zHxwoKNDDsq3rLJDKCswU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/641] netfilter: nf_tables: reset table validation state on abort
Date: Tue, 24 Feb 2026 17:19:42 -0800
Message-ID: <20260225012355.042085508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 6059a299004d4..df18dfd5a8271 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11538,6 +11538,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
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



