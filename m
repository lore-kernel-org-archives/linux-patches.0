Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1B41A2389;
	Thu, 15 Jan 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498812; cv=none; b=pSS/yO1msiFGiJVxLiWK5HurG6UsqxLASvLRjkJipFJeBAwMtbX90sIvY0Kmyr9adJbr/QaKexm1kQB55pBNx2hWtVtFvsdzjumuPkgvJn1qyR0z2YGhkKQOk00UX46H9w3H3/9Gj5duwutIyNHaALDs5ij2cXECZm0wJacpBZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498812; c=relaxed/simple;
	bh=5L33FaXvxAxWpReGRg68xoI7cMEb8tHDn3UcKAe5ORM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4TWXXmmtNwRU6L/5QAR898szzb8YVPnzc55zpUz/I2JDORPrqrGRmSXP60RQAhB/jD0/TnXgcEfEXB3k06PjB5HCbZPQRg3dibPG3vu1mUytkIwKtFJFarl6nByTTjlO8k0TSdjx17+8+ag5aL+ozI0hRyq69qcjgSYoUpkmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZFA8u9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZFA8u9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69510C116D0;
	Thu, 15 Jan 2026 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498812;
	bh=5L33FaXvxAxWpReGRg68xoI7cMEb8tHDn3UcKAe5ORM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZFA8u9/J6LDaHOkIOh0PncUzYTirrtGOczaM5mC6Tc5EWOIA4Ib8urYzCxD9yexW
	 v9WKcBgsFduwuOU1MiGismiDIuIkN30aM6nHN7/ptMvwmhvNk8OGyFDmWjogHScODW
	 zmNCNsuqSrdH0lJQTbemlMqnst/1ww8MFmP9uMbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 526/554] netfilter: nf_tables: fix memory leak in nf_tables_newrule()
Date: Thu, 15 Jan 2026 17:49:52 +0100
Message-ID: <20260115164305.367012446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit d077e8119ddbb4fca67540f1a52453631a47f221 ]

In nf_tables_newrule(), if nft_use_inc() fails, the function jumps to
the err_release_rule label without freeing the allocated flow, leading
to a memory leak.

Fix this by adding a new label err_destroy_flow and jumping to it when
nft_use_inc() fails. This ensures that the flow is properly released
in this error case.

Fixes: 1689f25924ada ("netfilter: nf_tables: report use refcount overflow")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 91b012e476be6..e37d2ef9538e5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3741,7 +3741,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (!nft_use_inc(&chain->use)) {
 		err = -EMFILE;
-		goto err_release_rule;
+		goto err_destroy_flow;
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
@@ -3791,6 +3791,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
+err_destroy_flow:
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-- 
2.51.0



