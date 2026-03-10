Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1C389116;
	Tue, 10 Mar 2026 11:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141285; cv=none; b=DIKVTTPqYuvoTNkgNstsJeCOvEw+HwhgQd6y5ExlB43CLS/WvnRKe1izHRyhlqrlZ+8ARW0UB6RfnOGdUZL/hW/evWf7KuCUu5aY8T1jFbvPFGIkOVLDsfaBZOtUMQYO+rdATqmGvwAj8E6ttWjMDM96uGHEoFIqD/TTBBqdGn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141285; c=relaxed/simple;
	bh=H/RE/5RIhe1hzdfRK17NMrFfy4YfDKXbR/EcExGJINA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDT3JizeoVFHuWHThosqcTdWMTb4EEI8MWYbZMMHtExcHGio21AR+3Th+yCp6wq6/2kC7JplVKyN1CFXjOk3Bf91J94+1UAf1AvkuAhDqqjWqoTbsPidOMmqzy9F+DyJKjB2U5nK9idTtkYikYH9WkpWyLXzYU6ipt0xEHmtKrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nv0pUE4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nv0pUE4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46A9C19423;
	Tue, 10 Mar 2026 11:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141285;
	bh=H/RE/5RIhe1hzdfRK17NMrFfy4YfDKXbR/EcExGJINA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nv0pUE4ugWjbzG/N78OZSIzmMtt7Ko3lTjeRP8Cht+rmPvJgJU9LhGTCqIxNK9S94
	 zpgawTJ1Q1Hh74xW1xf7YduIrhMEvtqtbux1eP0OGqFAnLYGnIGhvhwARGBz9DcO2v
	 uvsbeBpcJLETJr5zZnOtLsgSbfXqXYmiNQ+Qwosc/Ugm/tI/AT5L0lJRv+oVVqoNhv
	 2c/YoMAFHz54yFezxrkok2Oc9x6KSQ6H7LYzNGtR4AHPhq3DK7JoK0IW+oVFAhFRft
	 v0DafjSeM/b/sVvPutKmRtbbmDUstsMoOlfD2fyhBwuT1g2Fxy8ffdWXcok+EDGmfu
	 NF+D2dMRfrWdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 289/311] netfilter: nf_tables: clone set on flush only
Date: Tue, 10 Mar 2026 07:05:36 -0400
Message-ID: <f38eec2ca188f814f42ed7f552956fff6e3936e5.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit fb7fb4016300ac622c964069e286dc83166a5d52 ]

Syzbot with fault injection triggered a failing memory allocation with
GFP_KERNEL which results in a WARN splat:

iter.err
WARNING: net/netfilter/nf_tables_api.c:845 at nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845, CPU#0: syz.0.17/5992
Modules linked in:
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845
Code: 8b 05 86 5a 4e 09 48 3b 84 24 a0 00 00 00 75 62 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 63 6d fa f7 90 <0f> 0b 90 43
+80 7c 35 00 00 0f 85 23 fe ff ff e9 26 fe ff ff 89 d9
RSP: 0018:ffffc900045af780 EFLAGS: 00010293
RAX: ffffffff89ca45bd RBX: 00000000fffffff4 RCX: ffff888028111e40
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
RBP: ffffc900045af870 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d141db R12: ffffc900045af7e0
R13: 1ffff920008b5f24 R14: dffffc0000000000 R15: ffffc900045af920
FS:  000055557a6a5500(0000) GS:ffff888125496000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5ea271fc0 CR3: 000000003269e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __nft_release_table+0xceb/0x11f0 net/netfilter/nf_tables_api.c:12115
 nft_rcv_nl_event+0xc25/0xdb0 net/netfilter/nf_tables_api.c:12187
 notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455

Restrict set clone to the flush set command in the preparation phase.
Add NFT_ITER_UPDATE_CLONE and use it for this purpose, update the rbtree
and pipapo backends to only clone the set when this iteration type is
used.

As for the existing NFT_ITER_UPDATE type, update the pipapo backend to
use the existing set clone if available, otherwise use the existing set
representation. After this update, there is no need to clone a set that
is being deleted, this includes bound anonymous set.

An alternative approach to NFT_ITER_UPDATE_CLONE is to add a .clone
interface and call it from the flush set path.

Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com
Fixes: 3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++++-
 net/netfilter/nft_set_hash.c      |  1 +
 net/netfilter/nft_set_pipapo.c    | 11 +++++++++--
 net/netfilter/nft_set_rbtree.c    |  8 +++++---
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f1b67b40dd4de..077d3121cc9f1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -317,11 +317,13 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
  * @NFT_ITER_UNSPEC: unspecified, to catch errors
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ * @NFT_ITER_UPDATE_CLONE: clone set before iteration under mutex to update element
  */
 enum nft_iter_type {
 	NFT_ITER_UNSPEC,
 	NFT_ITER_READ,
 	NFT_ITER_UPDATE,
+	NFT_ITER_UPDATE_CLONE,
 };
 
 struct nft_set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 92fed8723b8f9..7b357a2a871ed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -832,6 +832,11 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 	}
 }
 
+/* Use NFT_ITER_UPDATE iterator even if this may be called from the preparation
+ * phase, the set clone might already exist from a previous command, or it might
+ * be a set that is going away and does not require a clone. The netns and
+ * netlink release paths also need to work on the live set.
+ */
 static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
@@ -7891,9 +7896,12 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
+	/* The set backend might need to clone the set, do it now from the
+	 * preparation phase, use NFT_ITER_UPDATE_CLONE iterator type.
+	 */
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
-		.type		= NFT_ITER_UPDATE,
+		.type		= NFT_ITER_UPDATE_CLONE,
 		.fn		= nft_setelem_flush,
 	};
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 739b992bde591..b0e571c8e3f38 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -374,6 +374,7 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 {
 	switch (iter->type) {
 	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		/* only relevant for netlink dumps which use READ type */
 		WARN_ON_ONCE(iter->skip != 0);
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 18e1903b1d3d0..cd0d2d4ae36bf 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2145,13 +2145,20 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_match *m;
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		m = pipapo_maybe_clone(set);
 		if (!m) {
 			iter->err = -ENOMEM;
 			return;
 		}
-
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		break;
+	case NFT_ITER_UPDATE:
+		if (priv->clone)
+			m = priv->clone;
+		else
+			m = rcu_dereference_protected(priv->match,
+						      nft_pipapo_transaction_mutex_held(set));
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a4fb5b517d9de..5d91b7d08d33a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -810,13 +810,15 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 	struct nft_rbtree *priv = nft_set_priv(set);
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
-		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
-
+	case NFT_ITER_UPDATE_CLONE:
 		if (nft_array_may_resize(set) < 0) {
 			iter->err = -ENOMEM;
 			break;
 		}
+		fallthrough;
+	case NFT_ITER_UPDATE:
+		lockdep_assert_held(&nft_pernet(ctx->net)->commit_mutex);
+
 		nft_rbtree_do_walk(ctx, set, iter);
 		break;
 	case NFT_ITER_READ:
-- 
2.51.0

