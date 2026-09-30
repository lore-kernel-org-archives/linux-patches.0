Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60651FCB2;
	Wed, 30 Sep 2026 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791222; cv=none; b=mcdrchyNKSrZ7/WwqkY0SOKIPTiXfHool5A+Rdg1xOMfOUyvqDfGZX+zYrBzSS8ITdq7Ir2CHHi64W/U5+H9e7aH/ClEQNlcNiNx/mzr1ERuRSeyht4uiMzNg+kAguHyUxfc7he+JFDAj76sOihhj3f2qNaHZLlduc2+Gvprjp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791222; c=relaxed/simple;
	bh=ws+CeLjp8EKjdvN8DYDUJw4dg03lKTWEPdEKoitKJC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGYgYgVj/Nbj93x7vNv1GSYkiLH0OYNYRxEVCpFXfbdcScLCwZ3YZksq3KnESrvkmQ7VLhkmVMkXtnzKKj43c+dWTZ2mfKZ3wtU3X2Vowffb2EJumXEptSvOf+UTyZLvxuNHl1++QaAbmYvbhmaT1HfonyqZRJZJwjotF/zclJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVkQWNX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVkQWNX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCCD1F000FF;
	Wed, 30 Sep 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791221;
	bh=ac32ZeFFucnFX0C0Vqr4ihPnV2WbpSnc9A+L8eiX67Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVkQWNX3eqdSuG/A+XZEIHgiyCDhNdWHSt+RUFPNVP16RJkKP5FORW05hxEpgM2G6
	 2Pe3S6ibAfZlsr/VAdGSCXxdShsS/Hrhn0Zt/kij6vKItSkd2tDK0JgAPfTqZ0Z7SX
	 SvNzvAsCjLcIuQjlEg9qelWoYB9TSK89CY99Aqtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/752] netfilter: nf_conntrack_expect: zero at allocation time
Date: Wed, 30 Sep 2026 17:20:51 +0200
Message-ID: <20260930152402.121052064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 6d056ebba57c6..fd83dbfccaced 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -299,7 +299,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
 	struct nf_conntrack_expect *new;
 
-	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
+	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
@@ -363,6 +363,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 #if IS_ENABLED(CONFIG_NF_NAT)
 	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
 	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+	exp->dir = 0;
 #endif
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index da00a770ca6d6..699668d1fdb26 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3552,8 +3552,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (cda[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
 		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-	} else {
-		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
@@ -3565,8 +3563,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 			goto err_out;
 		}
 		exp->expectfn = expfn->expectfn;
-	} else
-		exp->expectfn = NULL;
+	}
 
 	exp->class = class;
 	exp->master = ct;
@@ -3580,12 +3577,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
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



