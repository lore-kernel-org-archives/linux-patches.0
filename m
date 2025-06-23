Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C12018DB1A;
	Mon, 23 Jun 2025 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714239; cv=none; b=FSqpZHQ7MVLWpkE/yVU+gxb0CsY1lvsjVknOLf3LV5CbjZ92DFACS8FxpOLXWD4la+b8ps57vhihPAlXVwk2dgDOGzJyUjx9KUTopmosPLEIwGKKPXIJkVn7C6JOyugQ2heZyvPZ2frK/rIbWMW613/piqCbkUHQZXp9GOwWI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714239; c=relaxed/simple;
	bh=hCczS7OQutslTLIjf71cbAGPsUBPVZ4R6n4a4alOdfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+A//zrcknT9UXM6HcJgScmHyn0gBwndTauIhlXx2N/sIzmbe+aTVC+70yXkYBmQkzBK4qliwTR/gCykqrodTJkk+kIANz/JyXrZjSmWG0ZtdX8Ocpc/vMw/a/TQNg76RBGSaNtlBHgZxj4Bao6NNJ8lyElgeIub9oWFfiSikDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYtv5Hke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYtv5Hke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2EC4CEEA;
	Mon, 23 Jun 2025 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714238;
	bh=hCczS7OQutslTLIjf71cbAGPsUBPVZ4R6n4a4alOdfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYtv5HkeVGmRCXgW0VxA34FI2FqHyIqPRj8HzqvKXai9ZYtl0J8Ok2mwrBqiruZ4z
	 1pMjPh3Qw1EIBDjdduh0RG/ENxBdswKqU3mpp6iCcLE4ZnNTLvnFeKP9w3OE6lmOCv
	 gCN7+Y/ly9T9UEXhk4TreBmFQHTnS9itn3gKm/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 378/592] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Mon, 23 Jun 2025 15:05:36 +0200
Message-ID: <20250623130709.428758436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b85e3367a5716ed3662a4fe266525190d2af76df ]

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 0529e4ef75207..c5855069bdaba 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -1499,6 +1502,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.39.5



