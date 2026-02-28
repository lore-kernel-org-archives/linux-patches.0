Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46493344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301814; cv=none; b=oWqhciEXc/jXsgaSN2lLIpCYrLx+GE3vYNT7uxjnpDIkXzjDtCXj4ybxZPTm6wZaodxkNPRqYt8MbcyNEiTegYPUU8WSmppvyc2zGXbZAJTLUaaHiJIIkzphjSv6YHX1vHT/6yfAn/p8ZNvPkpqWfCROuOapAjFuej1DQit8FTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301814; c=relaxed/simple;
	bh=BXJsYS8N/J/G4fVQA9stNTSbGvz4kE2fJK+9w3n26As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMnjYUR5GOTPmp29pD1P79SMsVVsHUAOi2Kdz7R7iDH6uQmBNGVhSOcbC3WJmc3bR7NIbjboS1TcK7ggylyIg6Zz8lRreMo5G9JV2F3uzc63cPSRzYX1ndvnOuGmY5TlALD7HTBC0fMuRj+9MO1XIyY0ly40Ui2sYBf0R+DoTMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r65b9uVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r65b9uVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836F8C116D0;
	Sat, 28 Feb 2026 18:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301814;
	bh=BXJsYS8N/J/G4fVQA9stNTSbGvz4kE2fJK+9w3n26As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r65b9uVyqKOn9Xl8O+jBt/A0Quv56Zz398nx7+MUTycurXsSSUw2opgE1L6OtnQWA
	 7FL0ccNFX287cbEyP58PkZzGWZ3GcVF0k1r4SYvLPtTV0HS7VVD/lFgeoTWvo4Nxk3
	 Zw9lbWI0T/6F5pGv5xJrNUJLcaCHSlM1i0lb7Mftyzmj1dut8BmLmvZvjjRyO3HUi8
	 7GJNUM7rVaiPo9rMb6GiE7ootIPU2oqD3X/eDsq+MFQEOqjdy58vKo18AhBaZlFQe1
	 whmd1kcp8atZpB+JTn0UW5O2uZ1A1j8qnOILxVMGdNxzco9geGjfT4dHcqGmpr2uP4
	 ji41rdq85/wvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/385] netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
Date: Sat, 28 Feb 2026 12:57:30 -0500
Message-ID: <20260228180011.1568201-228-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7f9203f41aae8eea74fba6a3370da41332eabcda ]

Userspace adds a non-matching null element to the kernel for historical
reasons. This null element is added when the set is populated with
elements. Inclusion of this element is conditional, therefore,
userspace needs to dump the set content to check for its presence.

If the NLM_F_CREATE flag is turned on, this becomes an issue because
kernel bogusly reports EEXIST.

Add special case to ignore NLM_F_CREATE in this case, therefore,
re-adding the nul-element never fails.

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c  |  5 +++++
 net/netfilter/nft_set_rbtree.c | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42105628d4b98..f10be72021ddd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7322,6 +7322,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			 * and an existing one.
 			 */
 			err = -EEXIST;
+		} else if (err == -ECANCELED) {
+			/* ECANCELED reports an existing nul-element in
+			 * interval sets.
+			 */
+			err = 0;
 		}
 		goto err_element_clash;
 	}
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b1f04168ec937..0bbce4505b977 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -39,6 +39,13 @@ static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
 	return !nft_rbtree_interval_end(rbe);
 }
 
+static bool nft_rbtree_interval_null(const struct nft_set *set,
+				     const struct nft_rbtree_elem *rbe)
+{
+	return (!memchr_inv(nft_set_ext_key(&rbe->ext), 0, set->klen) &&
+		nft_rbtree_interval_end(rbe));
+}
+
 static int nft_rbtree_cmp(const struct nft_set *set,
 			  const struct nft_rbtree_elem *e1,
 			  const struct nft_rbtree_elem *e2)
@@ -431,6 +438,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 */
 	if (rbe_le && !nft_rbtree_cmp(set, new, rbe_le) &&
 	    nft_rbtree_interval_end(rbe_le) == nft_rbtree_interval_end(new)) {
+		/* - ignore null interval, otherwise NLM_F_CREATE bogusly
+		 *   reports EEXIST.
+		 */
+		if (nft_rbtree_interval_null(set, new))
+			return -ECANCELED;
+
 		*elem_priv = &rbe_le->priv;
 		return -EEXIST;
 	}
-- 
2.51.0

