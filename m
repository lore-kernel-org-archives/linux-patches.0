Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A734028B;
	Wed,  3 Dec 2025 16:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780007; cv=none; b=Ghh/ejO6yFc5IDPn5sWHG2E0rIwFy2OUFuUHRGbfn9ndu38DRwIxFnNiTvj0hA3oXfY0QRhkOxb2aBN7pDv6XeJFOl6Y1BRoJTV8ZbUjfQCCBa2BF52/7EJlqj5C97RzkKyuY+bVjh51tx4bnGdKfiZXx/N9V4yUH4MGENLKaZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780007; c=relaxed/simple;
	bh=mZCW1EAFqlZIHkeOO0xJ6sp/6qGBw/QGIL0scApWHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOjdY7KNqA44wX3XoVc5XdniNV9CV+oyjAEhp4D0FVcSHeCWZ0ssrxElcW9QMt7oGjssjM0y/o1PdBPPIKE5Rqc/mfTJU34VUA1IsZrEJhDMMqgTGbjJok0k3oGQ/qmPg5Sv/2ixH6jzVInZ6zCq9bABnHBulbis72DIkH6PZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEjdQYun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEjdQYun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8471C4CEF5;
	Wed,  3 Dec 2025 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780006;
	bh=mZCW1EAFqlZIHkeOO0xJ6sp/6qGBw/QGIL0scApWHrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEjdQYunEA4YAIYNmvCJLvyyPBkslkDtlXe0O8KUrxaOHWwh8lt9mRAqE7CTm9auT
	 g48hbrqMbOPoCHJ0rmILkc+OC6N32GYR80HNGfD6erZvBHbZGXdvONX1qMiyZs4+Gt
	 fLaM9GstMdrPfti7YYgv69o1FrS4eE22VpWHO/eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 394/568] netfilter: nf_tables: reject duplicate device on updates
Date: Wed,  3 Dec 2025 16:26:36 +0100
Message-ID: <20251203152455.122223967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit cf5fb87fcdaaaafec55dcc0dc5a9e15ead343973 upstream.

A chain/flowtable update with duplicated devices in the same batch is
possible. Unfortunately, netdev event path only removes the first
device that is found, leaving unregistered the hook of the duplicated
device.

Check if a duplicated device exists in the transaction batch, bail out
with EEXIST in such case.

WARNING is hit when unregistering the hook:

 [49042.221275] WARNING: CPU: 4 PID: 8425 at net/netfilter/core.c:340 nf_hook_entry_head+0xaa/0x150
 [49042.221375] CPU: 4 UID: 0 PID: 8425 Comm: nft Tainted: G S                  6.16.0+ #170 PREEMPT(full)
 [...]
 [49042.221382] RIP: 0010:nf_hook_entry_head+0xaa/0x150

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index df83224bef06c..b278f493cc93c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8078,6 +8078,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8093,6 +8094,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = nft_pernet(ctx->net);
+		list_for_each_entry(trans, &nft_net->commit_list, list) {
+			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
+			    trans->ctx.table != ctx->table ||
+			    !nft_trans_flowtable_update(trans))
+				continue;
+
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+				err = -EEXIST;
+				goto err_flowtable_update_hook;
+			}
 		}
 	}
 
-- 
2.51.0



