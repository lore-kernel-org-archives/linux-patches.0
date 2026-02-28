Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC6359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302479; cv=none; b=NbYGNMPE6yn+iH00rKih0dFAAJkjV5HWVJmSr2Mpo7cAU4A0eXn7asq55chiYOXyRVZJAj2xP6sXwXWiJ8Uj6jf6haBYFpPa6yexakCMzSldj6E/kZL/BIYpubO2o3rt4KW2KgeIPsURvVqJ3RtEGfLTN1F73k1I4Y0/1t3Z+n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302479; c=relaxed/simple;
	bh=YWn4bYO4nW4tJ9yodRdJamvli91r0X3vrUgJER+fS0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIwolyiqjOdhwMTRamvvPuYlIXDqwLecf1n2p8NukWveOkaoBxYJrEHTphSIdPgL4N30fE8MCZ/1AdDmNGDbrF0vUjO/yn20Dk1gaayzf0aJPEtgAk7gUq/6+PCHEpm/emCsJQpXIlmQDb78D8nqoorx6kBfUS40sCgd4prnZB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDfKLbhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDfKLbhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B58C116D0;
	Sat, 28 Feb 2026 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302479;
	bh=YWn4bYO4nW4tJ9yodRdJamvli91r0X3vrUgJER+fS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDfKLbhAVhv8n62KCbbPHI5HRuKEio9evJGYtNlIX86EsIZCQuxK2zO/FQ2Lc/I23
	 SHNn90Y4fcFxQtEUuFqrmeXuDVY/Og/X51kSjqYD5Z+lvf1Cawa/ragKptnutfEu4C
	 BjKTG6VUGd6fs+qNf+efGFdKZD4aAkefA9qrbCh1VFDI4wIJLn0Z2sblXP3WnRHQLz
	 kOtkxqsmCcblujQrZziXwX3C8XHSmcd1p1Vi6nJiwweqcvYCC7T5sB7wGdlfaQNClu
	 kf/wkO7WYo2cffS/3DCsgTAN+RUh5p5EWdgR5hxjqjphNsr5p9ltlIgXxcOhPb+Dvk
	 tJ7jSa8SQd//A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/232] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 28 Feb 2026 13:11:19 -0500
Message-ID: <20260228181127.1592657-226-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Inseo An <y0un9sa@gmail.com>

[ Upstream commit 71e99ee20fc3f662555118cf1159443250647533 ]

nf_tables_addchain() publishes the chain to table->chains via
list_add_tail_rcu() (in nft_chain_add()) before registering hooks.
If nf_tables_register_hook() then fails, the error path calls
nft_chain_del() (list_del_rcu()) followed by nf_tables_chain_destroy()
with no RCU grace period in between.

This creates two use-after-free conditions:

 1) Control-plane: nf_tables_dump_chains() traverses table->chains
    under rcu_read_lock(). A concurrent dump can still be walking
    the chain when the error path frees it.

 2) Packet path: for NFPROTO_INET, nf_register_net_hook() briefly
    installs the IPv4 hook before IPv6 registration fails.  Packets
    entering nft_do_chain() via the transient IPv4 hook can still be
    dereferencing chain->blob_gen_X when the error path frees the
    chain.

Add synchronize_rcu() between nft_chain_del() and the chain destroy
so that all RCU readers -- both dump threads and in-flight packet
evaluation -- have finished before the chain is freed.

Fixes: 91c7b38dc9f0 ("netfilter: nf_tables: use new transaction infrastructure to handle chain")
Signed-off-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67729d7c913a4..ac36183956515 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2510,6 +2510,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
-- 
2.51.0

