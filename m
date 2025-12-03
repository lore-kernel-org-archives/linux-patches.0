Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700363081DF;
	Wed,  3 Dec 2025 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778189; cv=none; b=XxcoRQvaqaODI6s2nLrXDC+HQCr9yOd2jGUxTD/SanB/ClRyOGfoQohE3EVBHF6mR3au6sm26ZuqHU3FTMb5SOcQ/vcKOeKiQAZGIdYJdLq7gQMShGK6BsKXqOvcX94CA6toK8qXtQZO8KoDlvyDxr2X16ef6aDhn5vRx7cEoPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778189; c=relaxed/simple;
	bh=fwwxUPhe+hlrtOynBG0qI5xQfJybzoVlFQNhRrHr50o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilS6vXdbJJs+I5F9A81DsxHoX0b+9FDeoJMVOhuIpoKiuDJEoobXzdZ4+TshS2dRNNzcvdUjT91s6cHX99QoAJl53wp8vm4ejCGHP4ifanXpghI2ra18YO7PQkuh8xh0Zv4GykUK/nzMhK2Hq38iY3BDXvBCJI4Brvo/QaxSRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAFVtzxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAFVtzxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FACAC116B1;
	Wed,  3 Dec 2025 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778189;
	bh=fwwxUPhe+hlrtOynBG0qI5xQfJybzoVlFQNhRrHr50o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAFVtzxSBONy+hz3G+TOksS9EGotp2N1Xi2mzrQDXYaU20r5BPdpGMGSmwK9C/iXU
	 EYnQIcBm4cDEqKRVkW4my/rWV1WHhGJQSZyg68pYpWMhC4kZ1GlQR8Sjos7b0Ic3pr
	 UtD6kjM3a6SPdDuVk7YTuA08fstLrH83ElYbEAYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/392] netfilter: nf_tables: reject duplicate device on updates
Date: Wed,  3 Dec 2025 16:26:59 +0100
Message-ID: <20251203152424.063304207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 33d03340d9fc8..91b012e476be6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7893,6 +7893,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -7908,6 +7909,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
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



