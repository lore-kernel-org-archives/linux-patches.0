Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A232874F6;
	Fri, 21 Nov 2025 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731835; cv=none; b=f+fojR8T95zgoxCvO+0AZ5skhZvHOV+vHvVkq7iYd1mOiR0bgSUbGV8j2cRC8qN0XfkWwmLgVr/gm90JrVmpkLdC/unMALn39qn3DNA7VvYfUBca82jvxAkmosu6okOfkmLkr2Zp0raZxe3RVWBJKqluGkYpW3Mb74IGrSgGRqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731835; c=relaxed/simple;
	bh=fcVY611J2w+qIu86AGzFMzUKWQ9pRpWWNAkNOuV5UBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oENk8DagtsPNfHhVhwiMZ3AIGAVEidiMfiVdoIBtd+KQ9bQ+kpo7lDZERkaIfTlXgAbsrIC0Y1h8uNqDJdosOoVsOls1rCZV1/DDIa81ZOgbHKwCGgWIjfy+7DS8JAypFbtAqUjhGtf07SiaxEpCRHK+IQDeV/6V/rvS6bc6aew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2MDst2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2MDst2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BB5C4CEF1;
	Fri, 21 Nov 2025 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731835;
	bh=fcVY611J2w+qIu86AGzFMzUKWQ9pRpWWNAkNOuV5UBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2MDst2k4hAr+aK22EyWQrxp43O7fF+uCmyH1tR7m3wsYI6gON909N+0BceNW72C2
	 ud+U8lEU/67j0iUk8tXmiaIMT/zwREQ/RX4zW2G+sezzy6/Xv8BHI09Y5ZfxPCKLmD
	 aWgWp3PuX+RjntQUh/CZrIEG+gPj8Kzt3vE0yiLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/185] netfilter: nf_tables: reject duplicate device on updates
Date: Fri, 21 Nov 2025 14:12:05 +0100
Message-ID: <20251121130147.409867053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f3684dcbef8c..e1c617b488889 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2642,6 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2682,6 +2683,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
 					kfree(h);
+					continue;
+				}
+
+				nft_net = nft_pernet(ctx->net);
+				list_for_each_entry(trans, &nft_net->commit_list, list) {
+					if (trans->msg_type != NFT_MSG_NEWCHAIN ||
+					    trans->table != ctx->table ||
+					    !nft_trans_chain_update(trans))
+						continue;
+
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+						nft_chain_release_hook(&hook);
+						return -EEXIST;
+					}
 				}
 			}
 		} else {
@@ -8686,6 +8701,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8701,6 +8717,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = nft_pernet(ctx->net);
+		list_for_each_entry(trans, &nft_net->commit_list, list) {
+			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
+			    trans->table != ctx->table ||
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



