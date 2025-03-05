Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DC6481DD;
	Wed,  5 Mar 2025 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197268; cv=none; b=A3B+vF151xNQP8FEKHgh1GerrFrAsjCyYwFkqsoLNoTZOQ0oIVMdn7X2zA9rqU8FVm6jpSGJJEJRkEDnAHlnTY3O8sXxmoMrCUZvEOsuT9AYo9jkF0Nb8N2MVil70KFQKx05nFdewK8LY3+oS9FgmIdzZXR1rQaUwyETB+kPmLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197268; c=relaxed/simple;
	bh=Br8bwubP9IGwdhDFfun0AFMeybdO3UeEQqakFGqFPTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A77SIdIZx5ZHBSwXQ4ema6i+sv1PTT7GFy1Unhfu5qyFAH7astmaldWYQiFvtY4V4HfCx7LD1EPqYiHTBLTE/Ze+y7U7g8shw86i/EJIZf4ADBvf5x4W7nHNKJ8ud/L41oj7DcRHDG/O7nirxneItVN5vaHWgSznSaBJMryCb+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMhKI+1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMhKI+1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAFBC4CED1;
	Wed,  5 Mar 2025 17:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197268;
	bh=Br8bwubP9IGwdhDFfun0AFMeybdO3UeEQqakFGqFPTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMhKI+1mzr+UNN8i8dkb7aue90/50xaO2k5ZicL2CZuzCUdULEAlkG2SkmiKqeQss
	 iMAsZyPuHJMkwtvFtfTUnS1OCK6dYwsOzztiYD7Ibc+tfJuAwHYX7l+wj5vyTbxNhg
	 RnNYioOCp97o0Fyc7oq2sbtj+hGr/Nb3JnOD0Wc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 096/176] netfilter: allow exp not to be removed in nf_ct_find_expectation
Date: Wed,  5 Mar 2025 18:47:45 +0100
Message-ID: <20250305174509.316626694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit 4914109a8e1e494c6aa9852f9e84ec77a5fc643f upstream.

Currently nf_conntrack_in() calling nf_ct_find_expectation() will
remove the exp from the hash table. However, in some scenario, we
expect the exp not to be removed when the created ct will not be
confirmed, like in OVS and TC conntrack in the following patches.

This patch allows exp not to be removed by setting IPS_CONFIRMED
in the status of the tmpl.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack_expect.h |    2 +-
 net/netfilter/nf_conntrack_core.c           |    2 +-
 net/netfilter/nf_conntrack_expect.c         |    4 ++--
 net/netfilter/nft_ct.c                      |    2 ++
 4 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -100,7 +100,7 @@ nf_ct_expect_find_get(struct net *net,
 struct nf_conntrack_expect *
 nf_ct_find_expectation(struct net *net,
 		       const struct nf_conntrack_zone *zone,
-		       const struct nf_conntrack_tuple *tuple);
+		       const struct nf_conntrack_tuple *tuple, bool unlink);
 
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 				u32 portid, int report);
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1770,7 +1770,7 @@ init_conntrack(struct net *net, struct n
 	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
 		spin_lock_bh(&nf_conntrack_expect_lock);
-		exp = nf_ct_find_expectation(net, zone, tuple);
+		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
 		if (exp) {
 			pr_debug("expectation arrives ct=%p exp=%p\n",
 				 ct, exp);
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -171,7 +171,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_find_get)
 struct nf_conntrack_expect *
 nf_ct_find_expectation(struct net *net,
 		       const struct nf_conntrack_zone *zone,
-		       const struct nf_conntrack_tuple *tuple)
+		       const struct nf_conntrack_tuple *tuple, bool unlink)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct nf_conntrack_expect *i, *exp = NULL;
@@ -211,7 +211,7 @@ nf_ct_find_expectation(struct net *net,
 		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
-	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
+	if (exp->flags & NF_CT_EXPECT_PERMANENT || !unlink) {
 		refcount_inc(&exp->use);
 		return exp;
 	} else if (del_timer(&exp->timeout)) {
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -272,6 +272,7 @@ static void nft_ct_set_zone_eval(const s
 			regs->verdict.code = NF_DROP;
 			return;
 		}
+		__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	}
 
 	nf_ct_set(skb, ct, IP_CT_NEW);
@@ -378,6 +379,7 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 			return false;
 		}
 
+		__set_bit(IPS_CONFIRMED_BIT, &tmp->status);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
 


