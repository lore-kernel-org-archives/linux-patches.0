Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079BF535FBB;
	Wed, 23 Sep 2026 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174375; cv=none; b=OVoNfK36Ck3jxmdiiQs2CRF0fK3avXVnLyZ3Z9QxcqFE88BVXMLAHHH7T6qdbw02NP5GkVrPUhp5WJpWiEdNQh6aTGRaZMJ/StUWkA8k43sJ4beH4T+BM3MsqGdDQAlrJVX4sZXGpUbU/fVC+siexgGxBLS1SZ/LSCND0lhHj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174375; c=relaxed/simple;
	bh=bakQTiDcdVnux9rtYqBwizQb61QE+kS2uljXLkcUqj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG7n8kAhZUXJWxKytAr1RgIf5GXqvD1zcEmxzXA3Fhopzfhnhq3yae38uSREyj0XKhzJ2rkplCN4n8sjVdcVKJS3aOFYP/1c+gnLtWYQpc6twCz2i+xgp0gSIhDDQ9rpvbcHQWYofyjD4VRDzVyVHmtRcEavefHG27K6KWQuQVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULngKkvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULngKkvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588121F000FF;
	Wed, 23 Sep 2026 14:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174373;
	bh=6dt7DpmBFHMK9aPXJf7YEY2k4Ce2KL6Td3zzs7K6gTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULngKkvyw3EjjfQVF7KTDXnE/TajBFHNiYouziyqEvPAR77BEDFw6Ng6OUsNPMPx8
	 QtXvkLF6XFW2eBNzrIaW8fC3LIeG7MulHSpl4z2Wu7b2GE6LlA6bsZdmlp0ZeDiuJm
	 er7GZofCZafcmvV7RVl5YQiZs6KCPqDF0J/dp0Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <void0red@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/398] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Wed, 23 Sep 2026 16:02:47 +0200
Message-ID: <20260923140645.849734859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 444e4c88c9c62a3d823069006563513fe7d5aa66 ]

Currently, a netdev chain or flowtable hooked to a device prefix can be
unintentionally deleted by a control-plane request targeting an exact
device name or even a shorter one due to the usage of min() to calculate
the length to match.

Fix this by making sure an exact device match never matches a prefix and
that both the target and the candidate have the same length during
delete operation. The add and update paths retain the existing overlap
matching to prevent a single device from matching multiple hooks.

Reported-by: Wei Fang <void0red@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3a66b6268cd6..321a0dd92178b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2343,11 +2343,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 }
 
 static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
-					   const struct nft_hook *this)
+					   const struct nft_hook *this,
+					   bool strict)
 {
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, hook_list, list) {
+		if (strict && hook->ifnamelen != this->ifnamelen)
+			continue;
 		if (!strncmp(hook->ifname, this->ifname,
 			     min(hook->ifnamelen, this->ifnamelen)))
 			return hook;
@@ -2385,7 +2388,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
-		if (nft_hook_list_find(hook_list, hook)) {
+		if (nft_hook_list_find(hook_list, hook, false)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			nft_netdev_hook_free(hook);
 			err = -EEXIST;
@@ -2842,7 +2845,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					ops->hook	= basechain->ops.hook;
 				}
 
-				if (nft_hook_list_find(&basechain->hook_list, h)) {
+				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
 					list_del(&h->list);
 					nft_netdev_hook_free(h);
 					continue;
@@ -2855,7 +2858,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					    !nft_trans_chain_update(trans))
 						continue;
 
-					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans),
+							       h, false)) {
 						nft_chain_release_hook(&hook);
 						return -EEXIST;
 					}
@@ -3130,7 +3134,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &chain_hook.list, list) {
-		hook = nft_hook_list_find(&basechain->hook_list, this);
+		hook = nft_hook_list_find(&basechain->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_chain_del_hook;
@@ -8921,7 +8925,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			if (nft_hook_list_find(&ft->hook_list, hook)) {
+			if (nft_hook_list_find(&ft->hook_list, hook, false)) {
 				err = -EEXIST;
 				goto err_unregister_net_hooks;
 			}
@@ -8980,7 +8984,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		return err;
 
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
-		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
+		if (nft_hook_list_find(&flowtable->hook_list, hook, false)) {
 			list_del(&hook->list);
 			nft_netdev_hook_free(hook);
 			continue;
@@ -8993,7 +8997,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 			    !nft_trans_flowtable_update(trans))
 				continue;
 
-			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook, false)) {
 				err = -EEXIST;
 				goto err_flowtable_update_hook;
 			}
@@ -9213,7 +9217,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 		return err;
 
 	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		hook = nft_hook_list_find(&flowtable->hook_list, this, true);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
-- 
2.53.0



