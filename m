Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879A2F2D;
	Tue, 27 Feb 2024 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041427; cv=none; b=YhkRBeBAVKPm47VHgPHbVlWMVyLK0AmD6iAJdPVJiJbVU+kOmenIHRnB+fvnsf+ja3j5VIHBYol8Nyl6cIQPFrIey6qKUAd8TvPqXeqZHV6K58pUz0scDtjv+VlTLdCIbeRSMkhMux7PNUGPgdxzvyqyx/3cn5Whhk5cko1Sk/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041427; c=relaxed/simple;
	bh=mu10IqJWFPyM3In93hbupdG6jwRkw1jaXZg4I4ry9bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7PuNUfrkzQBtHQMjXf7qqFckvq1j1p8rFWoOzDGeg7lJhgV0zmxAfVax8rJ+FRsqhPpXwxZ63O4c2ob90l07vK1KEEEdFTv2r6Jw8wMEs3FZrB67zgLT4p9XFBXuyBcsknWgj/hU39gmU2ZofkssPaiPnFeq3fnX6e5DmrOxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBy5hm9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBy5hm9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD40C433F1;
	Tue, 27 Feb 2024 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041427;
	bh=mu10IqJWFPyM3In93hbupdG6jwRkw1jaXZg4I4ry9bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBy5hm9dsIcYyu0GKjZyKPgg/pQBHKFupxNlIrzkGK+juagx105I5378AVBbgpUke
	 jQEkDvn94NaDU/J9aISZ/xQwpLNpuZLHnecP9MIeEDCz/nK3QJ3xXdYl233Db1igkA
	 ZcgZT6rr3eDJxdUsu4WwBoq1Dp9AB0on3+MXWbEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 310/334] netfilter: nf_tables: use kzalloc for hook allocation
Date: Tue, 27 Feb 2024 14:22:48 +0100
Message-ID: <20240227131641.073045942@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 195e5f88c2e48330ba5483e0bad2de3b3fad484f ]

KMSAN reports unitialized variable when registering the hook,
   reg->hook_ops_type == NF_HOOK_OP_BPF)
        ~~~~~~~~~~~ undefined

This is a small structure, just use kzalloc to make sure this
won't happen again when new fields get added to nf_hook_ops.

Fixes: 7b4b2fa37587 ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6901067d715dc..79e088e6f103e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2082,7 +2082,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	struct nft_hook *hook;
 	int err;
 
-	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
+	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
 	if (!hook) {
 		err = -ENOMEM;
 		goto err_hook_alloc;
-- 
2.43.0



