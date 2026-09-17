Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DDF4E36C7;
	Thu, 17 Sep 2026 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668403; cv=none; b=t0kDXRENAU+vD6AKE9K7aJBMVJbPCFZkJCol53WKXG0yjwA6vkGUcDuoAI2M7SdTYHSfe63t7juk5k0UQxyxKAZVgiKxawPjXbl8XWozhhrq04wEBuG6guSqmstQ82yBCbDgBqMigibBmwuVk6wHkmA6WxdegGortlJM2lAmlEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668403; c=relaxed/simple;
	bh=axsDxjWOztsI5prHaopqFjSnTo4C14mkAfPuwsO6W78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2PgeI47+2pFoBnCrU2HATAgNhz9Fbm5DvQUxVoN9MPckePdiGX9OpBIWU7iaB4DVRhZVZz8sW082MaY9qIP19HEZRk/ciUXsoKYtujyH/bhwRzUJCu2154f2qCU9XUb8HNI7nADNCMpld3YpPfEWr/tv2VZkTBawddilkL9kfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnAt2kH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnAt2kH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2191F1F000FF;
	Thu, 17 Sep 2026 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668401;
	bh=sXT02V5XoPwDD1JOGaZ8xjs41abNbClzgfAP7FV0w8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnAt2kH+0Kg3hnARqykScJBFX1XjkbsDjhGkIjrsQf9q16A8uJfRp5JSXILEnFu1z
	 R6OxBOqzeleEbsqadxkXnOiWtRKOmbFwceU/PpftIrlCN2BSA8/5yXnnUPvRcP3ORv
	 9O9lMa1SDRTORIV18XO7iwlRQzowx8p0Bxk7Q7+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0373/1102] netfilter: nf_conntrack_expect: zero at allocation time
Date: Thu, 17 Sep 2026 16:05:16 +0100
Message-ID: <20260917151549.017034369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index a8929885485b6..a45288fcb0419 100644
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
index 80fdb875c9771..1f9f0e7daa765 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3554,8 +3554,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3567,8 +3565,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3587,12 +3584,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
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



