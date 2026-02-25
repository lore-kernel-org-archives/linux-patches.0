Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22112D3EEE;
	Wed, 25 Feb 2026 06:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002731; cv=none; b=j1Pb0y0YPAUHcRWXoIBGEgR4N+jQozTVMyX7nwY6X4Ww5VVALAcETUXd3CaQ/7Ub5D/dGO6aKIkvL6DhaZoxALTK26e0Bo0SivjRu9kwtY+RZwPYVWKmu/Ik0887Rys843BBilibDaXHC5UVuNxfXpIsEQ5kJL70arkXVAO8ilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002731; c=relaxed/simple;
	bh=4tcr6VaAJZOdEtnun6EIYrrQTuGBI2S8opnD5uquvpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTT/WhCC1PnvIC/Vi7LBbaybsMD3d5jqIbZMtLPK9oKk/RDA51ObMOQIfIl/fAlj9pw2hn1DKVpaj2gU5Q+CSHJaK0m44nWEgReF3nf9qgUfBQuRM8IJtVaPmoQZ0mj41ntAldS0wQ8JlzuuO1KBoW+R3s+xUvkyS/8eupFS5MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT8xWhQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT8xWhQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3EBC116D0;
	Wed, 25 Feb 2026 06:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002730;
	bh=4tcr6VaAJZOdEtnun6EIYrrQTuGBI2S8opnD5uquvpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fT8xWhQjEMsH0V+f7CPNy4G2q9VKeQdvAX5lMfIb6KOtB/0joVTw/VbuV4M7ZPmRT
	 BT6HKy3uXNu2HgiN2Ff7Uux7oVv6duazTiHvi6pT7/aADWaPYDVaRo9ZhYGJ1cmK4b
	 +8wXzN2H/NexdP5MZp+hIc4JrBbEGyNJI2ZcQb+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/641] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Tue, 24 Feb 2026 17:24:30 -0800
Message-ID: <20260225012401.711267622@linuxfoundation.org>
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
index 9051f2c3595a2..df367638cdef0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2822,6 +2822,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
 
 err_register_hook:
 	nft_chain_del(chain);
+	synchronize_rcu();
 err_chain_add:
 	nft_trans_destroy(trans);
 err_trans:
-- 
2.51.0



