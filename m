Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67FF324B1F;
	Wed,  8 Apr 2026 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672525; cv=none; b=SKD+7uE0jQgjUxzaOhtb6tfaOxI+Ajpj+frsN8YAeIkWV0mTwOTvsC0NKcQrZ9D8JKceMxMkHkLKiV739dTiXKGZbjK8l6pBpMWxJ6iVpV5i0QZS2ttRQvw6rxCUFrOzckYzDW6BIe2K/0DBnFPL5n4/gxYyHGNS3KcpxGsDMAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672525; c=relaxed/simple;
	bh=xskJVLFS4wdgL2xJFlXzM7rQyNJg4St0xMHIrLWXp/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftMQOZchVK88F3BacgmWTFZojA14BT4RIp47YsiEWZ4lvyal4tYBTqWaSATFl1pGakfqq9BQGvNk8QiqX1zAKyKqsA1Iyjl/JBIF73WK+PimsyWZcMSNCe2gKxaV5oRVVIDeMHpk+77JC8SNekKNIV0key725dj3NTg8v3M0v4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYjSs/8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYjSs/8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C5C19421;
	Wed,  8 Apr 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672524;
	bh=xskJVLFS4wdgL2xJFlXzM7rQyNJg4St0xMHIrLWXp/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYjSs/8kEsHEBNW7YbJxq+X203izgsmsjHz3iadYutVu5TISYnmKd8xKMoG3Te5nS
	 mvtYnZE5taUQXrIS1+UYVp233N/W+zYLQgCuB5j7N7Xm3if1QMHJuQl8ua1q4VVplL
	 M46a5uPFyCPrjBYll3ZN3SEZMJBxo13tEw11aDQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/160] netfilter: nf_conntrack_expect: use expect->helper
Date: Wed,  8 Apr 2026 20:02:08 +0200
Message-ID: <20260408175914.743632273@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f01794106042ee27e54af6fdf5b319a2fe3df94d ]

Use expect->helper in ctnetlink and /proc to dump the helper name.
Using nfct_help() without holding a reference to the master conntrack
is unsafe.

Use exp->master->helper in ctnetlink path if userspace does not provide
an explicit helper when creating an expectation to retain the existing
behaviour. The ctnetlink expectation path holds the reference on the
master conntrack and nf_conntrack_expect lock and the nfnetlink glue
path refers to the master ct that is attached to the skb.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_expect.c  |  2 +-
 net/netfilter/nf_conntrack_helper.c  |  6 +-----
 net/netfilter/nf_conntrack_netlink.c | 24 ++++++++++--------------
 net/netfilter/nf_conntrack_sip.c     |  2 +-
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 43c6fc0576177..e0eb844c2cdcb 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -670,7 +670,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	if (expect->flags & NF_CT_EXPECT_USERSPACE)
 		seq_printf(s, "%sUSERSPACE", delim);
 
-	helper = rcu_dereference(nfct_help(expect->master)->helper);
+	helper = rcu_dereference(expect->helper);
 	if (helper) {
 		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
 		if (helper->expect_policy[expect->class].name[0])
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index d7bf2fa414a87..7d5e4f67f268c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -400,14 +400,10 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
 static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 {
-	struct nf_conn_help *help = nfct_help(exp->master);
 	const struct nf_conntrack_helper *me = data;
 	const struct nf_conntrack_helper *this;
 
-	if (rcu_access_pointer(exp->helper) == me)
-		return true;
-
-	this = rcu_dereference_protected(help->helper,
+	this = rcu_dereference_protected(exp->helper,
 					 lockdep_is_held(&nf_conntrack_expect_lock));
 	return this == me;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 97d2f5eacbe1e..2a601dc58b856 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2994,7 +2994,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 {
 	struct nf_conn *master = exp->master;
 	long timeout = ((long)exp->timeout.expires - (long)jiffies) / HZ;
-	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
@@ -3039,15 +3039,12 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
-	help = nfct_help(master);
-	if (help) {
-		struct nf_conntrack_helper *helper;
 
-		helper = rcu_dereference(help->helper);
-		if (helper &&
-		    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
-			goto nla_put_failure;
-	}
+	helper = rcu_dereference(exp->helper);
+	if (helper &&
+	    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
+		goto nla_put_failure;
+
 	expfn = nf_ct_helper_expectfn_find_by_symbol(exp->expectfn);
 	if (expfn != NULL &&
 	    nla_put_string(skb, CTA_EXPECT_FN, expfn->name))
@@ -3376,12 +3373,9 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 {
 	struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *m_help;
 	const char *name = data;
 
-	m_help = nfct_help(exp->master);
-
-	helper = rcu_dereference(m_help->helper);
+	helper = rcu_dereference(exp->helper);
 	if (!helper)
 		return false;
 
@@ -3516,9 +3510,9 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
-	u_int32_t class = 0;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
+	u32 class = 0;
 	int err;
 
 	help = nfct_help(ct);
@@ -3555,6 +3549,8 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	if (!helper)
+		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 6ae30a4cf3601..fda6fc1fc4c58 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -924,7 +924,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
 		if (!exp || exp->master == ct ||
-		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
+		    exp->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
 			break;
 #if IS_ENABLED(CONFIG_NF_NAT)
-- 
2.53.0



