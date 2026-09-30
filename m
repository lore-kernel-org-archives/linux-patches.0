Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9713A6B7F;
	Wed, 30 Sep 2026 18:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794621; cv=none; b=OnavP+LR5PkWbMe58PqDRVUfaksalNuZXYV9jSXXQQkXKtuRfagGuwn3pNqKSZlG14TVMmWl7/djitU/Lq1e0mmkf757oZukoldDjDETE4jx2XqRj9S9Sp+KoJ1N8dqXd3HVA1MDWblesjCSECGz5AGwd/ebsLCchV04WGD7Eu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794621; c=relaxed/simple;
	bh=O6eMXQExkJhuSya1hUbc/eeS5DM6prZRrA9EHa6qMWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwrfIgju0zhOGjDe2m0a8AftuYll5paIIQVa1G5Z0nBmmUkhIwzT2wr5HbIZCypl3WZlOm6ucZ+2jaHiOuVba3FVMrESPssqlq3Fe/ssteXOVXwNcps+6WQDyky+Tf4S19BiuUTxNq0rj/og7jt1RvfHQ3q9+CPhjQvotkbsH9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNLGF3Bq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNLGF3Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77401F000FF;
	Wed, 30 Sep 2026 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794620;
	bh=4FLo5IgZ6C3cyuBE8xLg8sqeod2dyHzIdqcoPJUDCOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNLGF3BqHMgEkKCsSxh9S4RmdEYTFiuRPobrSBj+W/7672/zqOMmMU5EDUGsYnaEc
	 d1szhCrJlcAp8Z8bdrgG+K0cPcxn+VdSwftJCKOcXLDHNt+YxSsNVNgQJJGtBqc3e9
	 cnbmb3Le2EOedYiK1g1/sDpSR9VQB8J+XXrcTS2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0273/1193] netfilter: nf_conntrack_expect: zero at allocation time
Date: Wed, 30 Sep 2026 17:15:57 +0200
Message-ID: <20260930152440.231164892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 241ccd2fed9051db443aadce248fc0ab30f55e97 ]

There are occasional LLM hints wrt. leaking uninitialized data to
userspace via ctnetlink.  Just zero at allocation time,
expectations are not frequently used these days.

Intentionally keeps _init as-is because we could theoretically
support re-init, so add the missing exp->dir there.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_expect.c  |  3 ++-
 net/netfilter/nf_conntrack_netlink.c | 11 +----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 34324dece89df..70d06ae0a3795 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -304,7 +304,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
-	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
+	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
@@ -386,6 +386,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 #if IS_ENABLED(CONFIG_NF_NAT)
 	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
 	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+	exp->dir = 0;
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9bbe25f2d679..be435865de4b6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3548,8 +3548,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3561,8 +3559,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3581,12 +3578,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
-#if IS_ENABLED(CONFIG_NF_NAT)
-	} else {
-		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
-		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
-		exp->dir = 0;
-#endif
 	}
 	return exp;
 err_out:
-- 
2.53.0



