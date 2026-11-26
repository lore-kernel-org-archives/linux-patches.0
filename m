Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704169;
	b=DN8AoKlX1LCQtGTUK7kjpuZbeSGA1KUmH5N5vl3bJKW6fopRdTbvYlg/R+i0hQ54NtaN
	 rQc+EN8b1EH1Skef744YikWdjbmylhM88touPg2qsrb2W/tfRcm2cpz83e2m5r3i37zSB
	 K2oU/ldgGEHc36l6X32F9gQz4qb9niFVf6PfHbxfb8Kf1yIUvZ8h4JNO1HkVE3BrKSlBx
	 WYUtNZyDwFL+QRVJvU04kurdaGPEwBNEf+/lDsaoHWSjcYvw9yX/cAwPoRlDRL32ZQBgi
	 /5tr6MvoyZ19q2cwWfArlk/b1Hswlt5jZ93bhX54NEHuhQnK5BP8ou+sKkrMpV6zcfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCwln80JPs7ZYeia0Ft7xQ+wlZrWqMXZ1bDS5jBL0us=;
	b=rdM4xY4tS/qvvP9F/TP7wwytXVxBkwIoGxQMc6VOkHFyIzMncvsClzqK5cynZIwRxjem
	 Hax0GxEUZjOnyRaDN7nnYxPerCAA9vSrCRKYxoMs+d07fTlyx2mc5AQu6XuutjEe2eq/i
	 tW9WYUfmVwaOZpjZNm8z7Hv2a1ZIpXmDho1tP40KgAckIf23AOiVXa4FmlswJGPZ2+NIP
	 QNkUpXjvBBSau8uU/75B0DTXS41AagrR2FRahrHJhwBoqqeM0mpQPJn1H5Bza5a8H55Sq
	 myIF22A6G1yECWn1MihZ4MuF6CpVHUicOJHKehtKkN+uvH3Fnt3Am6W/t/jagfotGSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIG5jEEH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CCA606A31C;
	Thu, 26 Nov 2026 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIG5jEEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DFF1F000CF;
	Thu, 26 Nov 2026 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704169;
	bh=LCwln80JPs7ZYeia0Ft7xQ+wlZrWqMXZ1bDS5jBL0us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIG5jEEHjzx5tMGlxQi17mrIpH0MfyvHI6YZPUEl/4lLGfypSz0+cYFvj0EtvFYF0
	 jOZPJxSqFhbtI6pndpt+SLt+YVns0Qz4Iy6++BEzvPAh5QALpfeXhzp+TeUjSmmlcl
	 M+YbXdkCFR61X23AZYi5jBHM/3RZ+KR2tSEP6VPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyeong Lee <iostreampy@proton.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Mark Bundschuh <mkbund@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/265] netfilter: nft_ct: move custom expectation support to helper
Date: Thu, 26 Nov 2026 15:35:33 +0100
Message-ID: <20261126143605.306529453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3679da4ad8be84cddaf40bc307fef1fe13e051ff ]

Originally, the ct expectation support called nf_ct_helper_ext_add() for
confirmed conntracks, which is invalid, triggering a splat. This was
fixed by commit 1710eb913bdc ("netfilter: nft_ct: skip expectations for
confirmed conntrack") which restricted it to unconfirmed conntracks.

However, early insertion of expectations into the expectations list when
the conntrack is unconfirmed leads to stale entries pointing to the
wrong hlist_head through .pprev due to ct extension reallocation.

Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
the nat hlist_head to nf_conn for this reason:

     1. ...
     2. When reallocation of extension area occurs we need to fixup the
        bysource hash head via hlist_replace_rcu.

I'd rather not increase the size of the struct nf_conn for this feature
has very limited scope: only one expectation can be created at a time
given expect_clash() will make nf_ct_expect_related() reports EBUSY.
For this reason, relax nf_ct_expect_related() not to drop packets in
case expectation creation fails, therefore, expectation creation becomes
best effort.

To address this issue, add an internal ct helper and attach it to the
conntrack entry to streamline the custom ct expectation support with
existing ct helpers.

Expose a new nf_conntrack_helper_release() function to release the
internal helper that is allocated and attached to the conntrack entry to
create the custom expectations. The nft_ct module removal always waits
for rcu grace period, then the NULL helper callback is observed after
this.

This patch also restricts the creation of expectations to different
helpers other than this custom helper that is created for this type of
expectations.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ - ac46f3f35b6e ("netfilter: nf_conntrack_helper: add refcounting from
    datapath") is not backported because it reworks helper lifetime
    around a datapath ct_refcnt in 9 files, so one static nft_ct_expect
    helper is unhelped at nft_ct module exit.
  - d4beefc90a66 ("netfilter: nft_ct: support expectation creation for
    natted flows") is not backported because it adds expectation support
    for NATed flows, so the moved expectation code has no NAT
    follow-master part.
  - b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to
    reap expectations") is not backported because it replaces the
    expectation timer with GC reaping in 9 files, so timer_list expires
    is set, and mod_timer_pending() after insert.
  - ace53fdc262f ("netfilter: conntrack: remove
    __nf_ct_unconfirmed_destroy") is not backported because it reworks
    unconfirmed conntrack teardown in conntrack core, so the release
    helper keeps this branch's final synchronize_rcu().
  - Context differs due to commit: 6031487d4e27 ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_helper.h |   1 +
 net/netfilter/nf_conntrack_helper.c         |  20 ++--
 net/netfilter/nft_ct.c                      | 107 +++++++++++++++-----
 3 files changed, 96 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 37f0fbefb060f..a85c1a80f1090 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -105,6 +105,7 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
+void nf_conntrack_helper_release(struct nf_conntrack_helper *);
 
 int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int);
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 24f3f8d5e6998..5ce70eb904d22 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,6 +456,18 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	return this == me;
 }
 
+void nf_conntrack_helper_release(struct nf_conntrack_helper *me)
+{
+	nf_ct_expect_iterate_destroy(expect_iter_me, me);
+	nf_ct_iterate_destroy(unhelp, me);
+
+	/* Maybe someone has gotten the helper already when unhelp above.
+	 * So need to wait it.
+	 */
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_release);
+
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	mutex_lock(&nf_ct_helper_mutex);
@@ -468,13 +480,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	nf_ct_expect_iterate_destroy(expect_iter_me, me);
-	nf_ct_iterate_destroy(unhelp, me);
-
-	/* Maybe someone has gotten the helper already when unhelp above.
-	 * So need to wait it.
-	 */
-	synchronize_rcu();
+	nf_conntrack_helper_release(me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a17357e4a59a5..f947c95b6b220 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1192,6 +1192,72 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
 	return 0;
 }
 
+struct nft_ct_expect_data {
+	struct nft_ct_expect_obj	obj;
+	enum ip_conntrack_dir		dir;
+};
+
+static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
+			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct nft_ct_expect_data *expect_data;
+	struct nf_conntrack_expect *exp;
+	int ret = NF_ACCEPT;
+	u16 l3num;
+
+	if (nf_ct_is_confirmed(ct))
+		return NF_ACCEPT;
+
+	expect_data = nfct_help_data(ct);
+	if (!expect_data)
+		return NF_ACCEPT;
+
+	if (expect_data->dir != dir)
+		return NF_ACCEPT;
+
+	exp = nf_ct_expect_alloc(ct);
+	if (!exp)
+		return NF_DROP;
+
+	if (expect_data->obj.l3num == NFPROTO_INET)
+		l3num = nf_ct_l3num(ct);
+	else
+		l3num = expect_data->obj.l3num;
+
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
+	/* nf_ct_expect_insert() arms the timer from the helper policy,
+	 * whose timeout is zero. Set the object's timeout once inserted,
+	 * with BH off so the timer cannot fire on this CPU in between.
+	 */
+	local_bh_disable();
+	if (nf_ct_expect_related(exp, 0) != 0)
+		ret = NF_ACCEPT;
+	else
+		mod_timer_pending(&exp->timeout,
+				  jiffies + expect_data->obj.timeout);
+	local_bh_enable();
+
+	nf_ct_expect_put(exp);
+
+	return ret;
+}
+
+static const struct nf_conntrack_expect_policy nft_ct_expect_helper_policy = {
+	.max_expected	= NF_CT_EXPECT_MAX_CNT,
+};
+
+/* No need to register this helper, this is internal. */
+static struct nf_conntrack_helper nft_ct_expect_helper = {
+	.name		= "nft_ct_expect",
+	.me		= THIS_MODULE,
+	.expect_policy	= &nft_ct_expect_helper_policy,
+	.help		= ct_expect_help,
+};
+
 static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
@@ -1199,6 +1265,8 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
 	int err;
 
+	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nft_ct_expect_data));
+
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
 	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
@@ -1244,7 +1312,7 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 }
 
 static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
-				       struct nft_object *obj)
+				      struct nft_object *obj)
 {
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
@@ -1269,11 +1337,9 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
-	struct nf_conntrack_expect *exp;
+	struct nft_ct_expect_data *expect_data;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
-	enum ip_conntrack_dir dir;
-	u16 l3num = priv->l3num;
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
@@ -1281,38 +1347,28 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	dir = CTINFO2DIR(ctinfo);
 
 	help = nfct_help(ct);
-	if (!help)
-		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-	if (!help) {
-		regs->verdict.code = NF_DROP;
-		return;
-	}
-
-	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
+	if (help) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	if (l3num == NFPROTO_INET)
-		l3num = nf_ct_l3num(ct);
 
-	exp = nf_ct_expect_alloc(ct);
-	if (exp == NULL) {
+	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	if (!help) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
-		          &ct->tuplehash[!dir].tuple.src.u3,
-		          &ct->tuplehash[!dir].tuple.dst.u3,
-		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout.expires = jiffies + priv->timeout;
 
-	if (nf_ct_expect_related(exp, 0) != 0)
-		regs->verdict.code = NF_DROP;
+	expect_data = nfct_help_data(ct);
+	if (!expect_data) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	expect_data->obj = *priv;
+	expect_data->dir = CTINFO2DIR(ctinfo);
 
-	nf_ct_expect_put(exp);
+	rcu_assign_pointer(help->helper, &nft_ct_expect_helper);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
@@ -1392,6 +1448,7 @@ static void __exit nft_ct_module_exit(void)
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
+	nf_conntrack_helper_release(&nft_ct_expect_helper);
 }
 
 module_init(nft_ct_module_init);
-- 
2.53.0



