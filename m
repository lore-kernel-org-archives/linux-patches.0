Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF72DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301779; cv=none; b=p++6PItYMlIHJZM1K5mmqO4N5DyKYoRcHTcbr4LIYCUcPWTknR9CULlCt2pCrAciWuzFGuGN2xsdkPwn9elFQ8r/bixp7GuZdQm7KqueLSGYbvoOAmAmumEnL1+F/xiqoXWWzt+urb4Wu4279TzQQ1m7LvtAempiJ3AZ4dNOGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301779; c=relaxed/simple;
	bh=idM+zxi8MtcUBxdTVi2YOQr6bBq+hnUk0nOhscIYgW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R98RMtEQzlQCvz0fN8DSn2yFYMAAIjfJGQwj9FyWQOlBbqA6HpHdXdVkMA+B/YoEq3F2rnAtWQLAdDSpxbDgvzAVqb2ob5hYtP8ikjHcP6xAMvnsSF+6EAwhE6wWYiPEBsS4foOS5zjbVXgGkxVbsQ5B8jgY4AKrV+Y/U3obtl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+5McObw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+5McObw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D34C19423;
	Sat, 28 Feb 2026 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301779;
	bh=idM+zxi8MtcUBxdTVi2YOQr6bBq+hnUk0nOhscIYgW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+5McObw2CMqQWnYYzGedJStDnoMT+KntHxpxtIBuJACokYqLDV1cQDvCXXUr9UnO
	 GioTmLKZbZZ6e/Ckbxtcb8+h3AZL5hnTAKh8To3xZjAg/Mu95Gdi81qRWGjqoeA/DG
	 ClRYL/2icsDS6AbgGjUMJvm1I5p24+5vublyEWbWWRpBYDWBii14CSbsUUTDVWw8o7
	 HwvwTaYN2ji6Kg6ymHV2nUX5RaMgpZtxMm1o30oELNGe/oWKUagFn3WeJdgaXZWbCW
	 UPZLZQEGZnm76k6lDVSFwSbmQWYl4eZLvLlMylQu9VrsPNGVac3J+v1R+stkqYaJ0x
	 yjF6AlaCahMMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/385] netfilter: nf_tables: reset table validation state on abort
Date: Sat, 28 Feb 2026 12:56:51 -0500
Message-ID: <20260228180011.1568201-189-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 3bf88c137868a..42105628d4b98 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11071,6 +11071,13 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
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

