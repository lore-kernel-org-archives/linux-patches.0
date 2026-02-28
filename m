Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8903B379EEE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301943; cv=none; b=EE8MYwK2H/3p27Bfn7MIH8N8XdnIMhL0snDvBAcjJSmd7J0OFBM9JvzxbStRq5nFD8YeOwY/ROHMCVUeXow7cJFXgKCkL+CLx6nS+NgtNTM+uoS/azdl3wBRQHjhHT4Up+2ctLt5bm40gKHEvoQ3y2SrOHaovE8u037cyJ7UsFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301943; c=relaxed/simple;
	bh=dj2xfEOQVWBPazw/FCNzC0EtfLDO7QCaWByUTGS5Kow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkrnXJ/cPUWa6FOp041G7pEipPyNDIYhIQCYvCmvSwtU/nE8UkyEV+TyUVeLyeD0pOLfEC8F0Jephgc6eJ9PJGJZi6/zZ+qwbDdui4JyZY7ngVgZHnwYTNyjGEY1MCdljp8WDrw1dIEc3/GDXM/D4P7K6WmoGOQ9d7KjiPhItfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fG5lFoOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fG5lFoOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB21CC116D0;
	Sat, 28 Feb 2026 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301943;
	bh=dj2xfEOQVWBPazw/FCNzC0EtfLDO7QCaWByUTGS5Kow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fG5lFoOwFhbp335X6YnfFJhbENYsJCrKlxcKwLmjCpElzzfhf98giGgU4D7KlYwZS
	 fbtv4JAPfMJpHSaP0TbUyx9ZoYuaKqISah3kjj7mH/cDRrsLWwI5Wu/WXeq3wFuwEP
	 69RjqNTAclXiGyf3aDN5U3RVNepG3HPCETZ/yQj3E9c0o2lDsDh1SXazZiFHq3TVcb
	 1CqWKLVmocse30OnIW5Gd4XR5+0uSUuB3HEG1oCBXdjM+x6R7KKvMLtdpG8hF/rSvB
	 G27Cm7ZgMYkLTC5661UFtcUYyoloqbbm4L9F1haqqhxFSYYUQRg70jfisaMBbAQWCI
	 64ikQtIy+Bk9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/385] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 28 Feb 2026 13:00:03 -0500
Message-ID: <20260228180011.1568201-381-sashal@kernel.org>
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
index f10be72021ddd..8dccd3598166b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2645,6 +2645,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
-- 
2.51.0

