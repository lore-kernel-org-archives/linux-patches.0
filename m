Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B622BF3E2;
	Tue, 10 Mar 2026 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141080; cv=none; b=NqIUDaTbn/TFjuWCVTSGv4+aSn3NS+kBV9J4I+IcbmaeUHYa1ZyamHU8vlrniIVT68dIYDEIIr0qOyFywceAGCaNuDlLS1DfGzlQdU9rMSSOg5t4vkxjj+yxOh2QAATXH30BLc9frTVGYfLMc2HWVsDZ78EOUukHm6flakuGOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141080; c=relaxed/simple;
	bh=jqf7/qLX9U5APWKsGf8/pfELpobv0EkK+qCk3MQqkog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwbaEwql/aJjFBPRfJhziKqTwUQBLrY0eUxOYjR1Fzhaa56/kCF2ykurcAQ9c+Zqja6cH72uxkTOOmxRs706gZgKdsOpfVZ8SVC9wg1/sfgW371odyl4QseuMmDXUc3cEdmhyL4Cge6zDd3bxM/BnVA15VHCgylF62ctZ3DYCag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2TgovUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2TgovUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A4DC2BC9E;
	Tue, 10 Mar 2026 11:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141080;
	bh=jqf7/qLX9U5APWKsGf8/pfELpobv0EkK+qCk3MQqkog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2TgovUomUjxJgjeifI1Qyhkcjn6ai1RPO0s7TVk7TvA2diQdxdW3qK639WRpeBWN
	 dQUCbr3Ph/a0s6CoJWCr8m51B8HP+wBpA6yKLdVt3pw8nNh6lQYjFfO+8ci80VqmOG
	 RvspI8WZ4UXww0+dKjGZEfz04wibodublwaqqS3v60zm2dd0KB2RrzwzLQeVejcb21
	 i3lXOfM81ZiZbwFWq/8tKq//3OXmzsSYWSHu7vUXhtS7t6nzs97rHZ20EE37XgkXeA
	 dqX3QTnv7NM5UcKXXxam0FjeWJfjCDo7H48urtns2Oa2D3xUbEATN+kXO54JXsCSwp
	 qnCwbynOaC7DQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 080/311] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback is available
Date: Tue, 10 Mar 2026 07:02:07 -0400
Message-ID: <5c45fb8347c5ead932dac1c5f9a430e7474829d9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit 021ca6b670bebebc409d43845efcfe8c11c1dd54 ]

When refill_sheaf() is called, failing to refill the sheaf doesn't
necessarily mean the allocation will fail because a fallback path
might be available and serve the allocation request.

Suppress spurious warnings by passing __GFP_NOWARN along with
__GFP_NOMEMALLOC whenever a fallback path is available.

When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
the kernel always falls back to the slowpath (__slab_alloc_node()).
For __prefill_sheaf_pfmemalloc(), the fallback path is available
only when gfp_pfmemalloc_allowed() returns true.

Reported-and-tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260223133322.16705-1-harry.yoo@oracle.com
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 889c2804bbfeb..b68db0f5a6374 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2715,7 +2715,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (!sheaf)
 		return NULL;
 
-	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
+	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -5092,7 +5092,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (empty) {
-		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC)) {
+		if (!refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 			full = empty;
 		} else {
 			/*
@@ -5395,9 +5395,14 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 				      struct slab_sheaf *sheaf, gfp_t gfp)
 {
-	int ret = 0;
+	gfp_t gfp_nomemalloc;
+	int ret;
+
+	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
+	if (gfp_pfmemalloc_allowed(gfp))
+		gfp_nomemalloc |= __GFP_NOWARN;
 
-	ret = refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC);
+	ret = refill_sheaf(s, sheaf, gfp_nomemalloc);
 
 	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
 		return ret;
-- 
2.51.0

