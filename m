Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9415FF0A;
	Tue, 13 Feb 2024 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845069; cv=none; b=bE6TqhUppLQT374n/fHuZhlC8W0vTq4q4JO0Xg6oYlJUOnZVPrdQji4UpXoqS80koiYfehbissSd4jrwEVGmAupt/yrkBv/hmWyaWwyv2nXz5S8RnEowsZhReumjD1Ej99ysFjvnRGPDVy8koQciiKIGtj/5suLymk9eG2+SrYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845069; c=relaxed/simple;
	bh=Kfo+f+iiMmga13bkAUgUiAfBD4Y7hMzNfTkIIb6Jii8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5WuLhjFH0hHb+qbntYQG6y9+H+YGBkVBqScs/M6ffHvjIIrvVvZJtlFxHFdw81hPMj3ajogE4tjKHo6OYWJxW179UK4NmXSKg7QZJcQ+Qn576cIaM4yCs/qvlJTRnoaIllk46n5HlGXwDtG6vuYnLy4p/uVREtLlc0jnHivfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVYYKNEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVYYKNEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B093BC433F1;
	Tue, 13 Feb 2024 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845069;
	bh=Kfo+f+iiMmga13bkAUgUiAfBD4Y7hMzNfTkIIb6Jii8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVYYKNEi/VgwK0liFd7x9u4yLLZ6aXHT0Lg/SJNs84cksoo7QxAv8NWHhtGsyJzaJ
	 f9+NpzlxaZ2vaAEAY/yjyv59XzsqhpIiRuECEPEDomztLsvBnrzOttOW/yjY8/TKLX
	 1/sQ2IgY3wYkrP1vT89f+e7dD5hw4sLxB/38o4gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/64] netfilter: nft_set_pipapo: add helper to release pcpu scratch area
Date: Tue, 13 Feb 2024 18:21:24 +0100
Message-ID: <20240213171845.949636198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fbd0dbf9b965..977bf724fb7e 100644
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
 
@@ -1359,7 +1377,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	}
 out_scratch_realloc:
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(new->scratch, i));
+		pipapo_free_scratch(new, i);
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
@@ -1647,7 +1665,7 @@ static void pipapo_free_match(struct nft_pipapo_match *m)
 	int i;
 
 	for_each_possible_cpu(i)
-		kfree(*per_cpu_ptr(m->scratch, i));
+		pipapo_free_scratch(m, i);
 
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(m->scratch_aligned);
@@ -2249,7 +2267,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(m->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(m->scratch, cpu));
+			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
 		pipapo_free_fields(m);
 		kfree(m);
@@ -2266,7 +2284,7 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 		free_percpu(priv->clone->scratch_aligned);
 #endif
 		for_each_possible_cpu(cpu)
-			kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
+			pipapo_free_scratch(priv->clone, cpu);
 		free_percpu(priv->clone->scratch);
 
 		pipapo_free_fields(priv->clone);
-- 
2.43.0



