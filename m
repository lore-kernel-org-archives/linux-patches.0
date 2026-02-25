Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC21E2834;
	Wed, 25 Feb 2026 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983595; cv=none; b=OV2t5Ed72f/rzYuv81mjJ97Dd6t10uHkwo0T0Of+Dkb13DF4rgoVZh8cOwAZi+gQ91OECJ6ih2U/+Eqvi2EluEg2Zit0+F8egG1KI3GhsBlnB+jTlLBlurnvALHZ95nPDBUCdzPqc6LcHuoPOV6YMHkZSjz1x7QSSKAo014htyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983595; c=relaxed/simple;
	bh=3EpYHKdjESwTelxEdpwS6Wh3sHBFTYDMv6QIYbkSrGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSYrExw76EW+crz8JkuIGBWuiKVdJ/zImR46oIXKrF3FUdijy2Vo+gCa2/QTx8QFQzsfb8NjPuwS7JDWyVxGTxflld9jyopCWATPlt4NnMKuS8lWd0tYxz2hn3Zy1ADECKjUwzP8ft7n1G5DNfs6pDY1NlDKdwgoL4Xy3Q0siuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTcalbax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTcalbax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A0CC116D0;
	Wed, 25 Feb 2026 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983595;
	bh=3EpYHKdjESwTelxEdpwS6Wh3sHBFTYDMv6QIYbkSrGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTcalbaxB/qvigGwd+5p2eWAvIVf19HvNoO5HCxQTCOxWaOnGVb5yvrIOMdWllgf4
	 krO2W3iBaEaavrMT/YJFJawAqt+010bvewrL9WsKsnTLoTCagSDqVPDun1jX+NvJKZ
	 +/QIi++DfI/27bOIxfpMR5Fe5mXK8jMX+IhIWs6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 668/781] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Tue, 24 Feb 2026 17:22:57 -0800
Message-ID: <20260225012416.169514679@linuxfoundation.org>
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
index f807183235e79..8dae197c7fafb 100644
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



