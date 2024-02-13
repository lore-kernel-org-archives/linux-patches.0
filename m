Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0195F54E;
	Tue, 13 Feb 2024 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845548; cv=none; b=eM+jTvxPF3476Ofz4DkRZM64pqGy8XpzOtwH8CHte2/okrMzraPNEjYfpBNx1XZoqdAjHp1NEZQ+TzBhx7S8QGyDq1aZ7X62ikOiEYJwVgaFnR/aHM6nELvByoBH/x/byPIn06VcpjgHh1wB9pvzaxedgNnrH0oNpx0Wwlkp3Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845548; c=relaxed/simple;
	bh=MNZIiiX3wpBkMFYJNkrHxZFB5SbRZJkRrAL0UL0UjBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpA1jXIhm6Jh/BDHqTM+Xk49ZDBPc1LEJtqamtrEhG/Wa1LxQc6dcRMwbvvZVBd3w9+a1Zugzmw/Y1vFG/UtUY+t9VUfITDBHnHbVoiIvcPgWX2VbhJdCL48yrvdx9p3iVBIw0/ehCOOdNz4B5MrlS72zuOdNVZqky6++qaphMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=texWPkua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="texWPkua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99397C433F1;
	Tue, 13 Feb 2024 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845548;
	bh=MNZIiiX3wpBkMFYJNkrHxZFB5SbRZJkRrAL0UL0UjBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=texWPkuaQwNTAPQvZFZSJ6mURnPEkO4OaVEUm9nLZZd2uCj89UvNB4DtN7kFUM76e
	 dwJm9BgpW8Z/acYB8LvSqAYWOJQpEVhgu9OQ5IR0FTP6j51bOHgZ7BVKJevOZ07I5W
	 b/4E7RbPXMJK3pu5byeS7u50tbPK2wDHGpT+FMJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/121] netfilter: nft_set_pipapo: add helper to release pcpu scratch area
Date: Tue, 13 Feb 2024 18:21:31 +0100
Message-ID: <20240213171855.383381029@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 47b1c03c3c1a119435480a1e73f27197dc59131d ]

After next patch simple kfree() is not enough anymore, so add
a helper for it.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 5a8cdf6fd860 ("netfilter: nft_set_pipapo: remove scratch_aligned pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 58e595a84cd0..b6bca59b7ba6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1101,6 +1101,24 @@ static void pipapo_map(struct nft_pipapo_match *m,
 		f->mt[map[i].to + j].e = e;
 }
 
+/**
+ * pipapo_free_scratch() - Free per-CPU map at original (not aligned) address
+ * @m:		Matching data
+ * @cpu:	CPU number
+ */
+static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int cpu)
+{
+	struct nft_pipapo_scratch *s;
+	void *mem;
+
+	s = *per_cpu_ptr(m->scratch, cpu);
+	if (!s)
+		return;
+
+	mem = s;
+	kfree(mem);
+}
+
 /**
  * pipapo_realloc_scratch() - Reallocate scratch maps for partial match results
  * @clone:	Copy of matching data with pending insertions and deletions
@@ -1133,7 +1151,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 			return -ENOMEM;
 		}
 
-		kfree(*per_cpu_ptr(clone->scratch, i));
+		pipapo_free_scratch(clone, i);
 
 		*per_cpu_ptr(clone->scratch, i) = scratch;
 
@@ -1358,7 +1376,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	}
 out_scratch_realloc:
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(new->scratch, i));
+		pipapo_free_scratch(new, i);
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
@@ -1646,7 +1664,7 @@ static void pipapo_free_match(struct nft_pipapo_match *m)
 	int i;
 
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(m->scratch, i));
+		pipapo_free_scratch(m, i);
 
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(m->scratch_aligned);
@@ -2247,7 +2265,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(m->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(m->scratch, cpu));
+			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
 		pipapo_free_fields(m);
 		kfree(m);
@@ -2264,7 +2282,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(priv->clone->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
+			pipapo_free_scratch(priv->clone, cpu);
 		free_percpu(priv->clone->scratch);
 
 		pipapo_free_fields(priv->clone);
-- 
2.43.0



