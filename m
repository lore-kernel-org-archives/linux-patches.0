Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5392502568;
	Wed, 30 Sep 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782737; cv=none; b=ile21fp433CtU5/fyRffiAmm/m2jqt9HzAmlSwUCmDmMlq8vibiE2cYeG4Og8dD88wvXir7488qBYr45WyFeMGfym+pWaHQJt9jLywzKCFnTIEj88MUpRrEAAZLHRRqBHK4XbHyJN8l2tBii2Fzx4rpdE/9ZXC7dI+WtLWVpCFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782737; c=relaxed/simple;
	bh=anhpjOEmyAuz1Wtfmb/uboPq9cfoptc6zBF5Iq/6fG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btcXCI7Y6W3+x9vDDnNUYYCA5lSZ6kxAswROnMyuho6yeCTxSJUhNpzDzfjAg9+x9FMBmSfcPrg1E1UzZbuMwa8/FHZxnaCizKCm6Ix3jmELTOXaDLt08jB+PfMyso0zo5ZyOTLhkFHrv+NisqaiIGL0aqfaD8IzfhVeETNm5dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/mXqiWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/mXqiWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FF11F000FF;
	Wed, 30 Sep 2026 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782732;
	bh=pd3kcSQl9Fzw0HQ2EY6JgcOvp7dDRFME2NBCx1YVVEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/mXqiWD2ByFKGi1nfdi5UGohclUPo4XoJnbgcZ+tLdIUUf7QdAoNFdH0CpnljE9v
	 cJJk/ekG1CKbkP70XojoiPSeiYAv640N+Mr9lq87yS8QoKAKHeTSKmlUgNdLdygSCu
	 MgB2vFpCcAfADqm27KFe8S1XgGnUVZzS7szR40AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/595] netfilter: nf_conntrack_expect: zero at allocation time
Date: Wed, 30 Sep 2026 17:20:42 +0200
Message-ID: <20260930152350.939517048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 516a9f05a87a7..3ea601a090e5d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -283,7 +283,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
-	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
+	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
@@ -347,6 +347,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 #if IS_ENABLED(CONFIG_NF_NAT)
 	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
 	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+	exp->dir = 0;
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 46bdc38081164..2acfdf019bf0b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3540,8 +3540,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3553,8 +3551,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3568,12 +3565,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
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



