Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A785346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302263; cv=none; b=qSVwGJBjv1R425YmtBZ37bEknvJKvKf4gNHw5EqHzVj3Uaa+Ye4l8bwNWutz+Vo8DUoQKriMmlpBG/GoiM18P0cJRNUHXFg/Inrwk9wZXMEM2zrOInNXKJUpAgx9v90M2ZyRj7uDbW4aP0/HwuReoVbsp7SOHPe7xGwe7ZIt9u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302263; c=relaxed/simple;
	bh=shgFSmcgIB0Rp2AgjgEjRz+TU6yey3stnLrum6lK3Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USezwCH6mYB19IECyqkBoey2n76eLxdqhjMin1sEWIiYpZWQjZsjczV+6MnYGmSFqLVj0lJ2Ltx5o+7rDz7gaZaDbTplgRT4BgIvT7zP7xDuyJtgnQ1EzClI32W/EgKGihs0hmZt3g0QtR/sLwmZNzcRejtP3IAjg2TSPOtKzP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+4VrccN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+4VrccN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF662C116D0;
	Sat, 28 Feb 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302263;
	bh=shgFSmcgIB0Rp2AgjgEjRz+TU6yey3stnLrum6lK3Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+4VrccNu9CWgP95jIBJ7XXogEfRPKqzutqePw49oPAtm5dNLRFeJfZTgWb23BAAO
	 yuqVQrh+i1InrHoHB1o6hW6+1jeN7AwCTUEXxPr0QHq+mv6oZM8YpOVOwI3D6DaQjb
	 olT1EZblFHe7OETos01yCifapkKxa+TuP61DSAGhagwQNMTqMzoxK82ERPChIkZKOb
	 IhSTBc0CJpPAMoNHWgVswO9E3BTFDeRp3H7R3KAJ/4QZiMUyhmh0mTlPMQLagxG/Xt
	 jOk0Upjc95o7BFN1MrrIJQbCK1plRnaTctSmfXhn6VVw+Oo0xqZEUy5HaYuLk6WNvs
	 B4rw4rYGY5XiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/283] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 28 Feb 2026 13:07:01 -0500
Message-ID: <20260228180709.1583486-279-sashal@kernel.org>
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
index 8532d832aad6a..41614e897ec8f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2581,6 +2581,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
-- 
2.51.0

