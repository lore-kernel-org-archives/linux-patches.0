Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA12352F298;
	Thu, 17 Sep 2026 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664870; cv=none; b=IKhsm1wAZunlkgG0daI5XapyzRgRkd4XKL/giiHrm9MRAjZeD+Mzrjv2LV2qIEr3cYFkW1BuGC1HjsukGlVXOWWSl/yUreJ9XxsoKZYYZF+0zoGdROEg6QJq9iSK4QCZN0EdqYDI7Qi4Nmy0VtacghpvYdcidCywWZxX7mCCQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664870; c=relaxed/simple;
	bh=RmHFkSsrvPSLnVinO9Ia2zPICha9AgRO5JMMy7CqoYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD9frioObkxKxg2ZLrhf7gkOExdcCDoVZt7mjG8pxEYRlV/kkANedzDfnzffnjK3Q17pY3vv4jnxqJaDSB9uG4Zp3moqtGMcQN/NKhsztZKc5PSKFGP4qEM8Jn3uAyYS54j6/4LOeScBYL49btXGacEFsd3Iqv4JTuhq1Eyg/30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAUllGvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAUllGvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1ED1F000FF;
	Thu, 17 Sep 2026 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664867;
	bh=cW7PMkpomMm3FEOtiPQYTyXUE5EtJIR1ti4H1jMC8rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAUllGvyO8dbjQEix2EeNSUeN463DPfNeDMNsUsa+cexeF3EEl4q+NXldlFYW9NOT
	 InHTcxYlCnZLCNzA5Bd1fsJLOxYlR8FcVxIwnnvREPvrQBwcvd5kazE+YgdbE66SYS
	 7OUx9RHd6o0LS8cOHM7VZ35P7XV6swmBliou4v0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0477/1250] netfilter: nf_conntrack_expect: zero at allocation time
Date: Thu, 17 Sep 2026 16:04:32 +0100
Message-ID: <20260917151604.897754733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 8e943efbdf0a5..6266d4d2ffca4 100644
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
index 3df7e5fc76c8b..e046281895743 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3559,8 +3559,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3572,8 +3570,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3592,12 +3589,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
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



