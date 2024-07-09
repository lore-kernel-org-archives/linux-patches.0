Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF314F138;
	Tue,  9 Jul 2024 11:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524284; cv=none; b=ZgQk6RZ5XIfmYklW77HEEgjDIjV8UU3ogWsLPwLaQv0sPeqRjtrMMG8TMeNn8ina4OkK1FCdGtH+TLrpQSqle+T+3gUdb5asN21UOqGuEMa+zXjq6bS874SiBMy/kSTfIO2/ATM0e/jqd2AaOjtwqGjaa0lqzjzWkn9CLrztX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524284; c=relaxed/simple;
	bh=54V43o+bxg8gc96H0D8h9eh+Kzwrf0I1zer0qEtSYbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXf0uDR+tkApaQm0CZlxh8iENjR7Vi5jrAJERqfZ/bZC2oW9h2q1Apv+BDl2nPk7U7Shd7syMR5l9OZk2SZFRlD/dZ95PaNqaqmkw/BbFy88zxBpiOMMxLc9VnYAk9jtyCC8OUoJrpZj8FplaMjsfWXH9fOtuC8Iua6AnQbBrmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLSSMrkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLSSMrkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39BFC3277B;
	Tue,  9 Jul 2024 11:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524284;
	bh=54V43o+bxg8gc96H0D8h9eh+Kzwrf0I1zer0qEtSYbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLSSMrkQuYMnT6ADTOADqBpIgLrXUSYuL7i/N9wgr+JlL17Yo18fe5mCwLTFCILuJ
	 lPf5fzrPdH8le8ntowvZfEb/bygG7VRHO7k4azhdWYZv7C6g1IGuhK4iltgN4HgX0y
	 wkSLbYUNAh73uUQ3iC2D+cBSHeqoHJya2oa3Kr5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/197] net: allow skb_datagram_iter to be called from any context
Date: Tue,  9 Jul 2024 13:09:16 +0200
Message-ID: <20240709110712.905963511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit d2d30a376d9cc94c6fb730c58b3e5b7426ecb6de ]

We only use the mapping in a single context, so kmap_local is sufficient
and cheaper. Make sure to use skb_frag_foreach_page as skb frags may
contain compound pages and we need to map page by page.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406161539.b5ff7b20-oliver.sang@intel.com
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://patch.msgid.link/20240626100008.831849-1-sagi@grimberg.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/datagram.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index a8b625abe242c..cb72923acc21c 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -435,15 +435,22 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 		end = start + skb_frag_size(frag);
 		if ((copy = end - offset) > 0) {
-			struct page *page = skb_frag_page(frag);
-			u8 *vaddr = kmap(page);
+			u32 p_off, p_len, copied;
+			struct page *p;
+			u8 *vaddr;
 
 			if (copy > len)
 				copy = len;
-			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
-					vaddr + skb_frag_off(frag) + offset - start,
-					copy, data, to);
-			kunmap(page);
+
+			skb_frag_foreach_page(frag,
+					      skb_frag_off(frag) + offset - start,
+					      copy, p, p_off, p_len, copied) {
+				vaddr = kmap_local_page(p);
+				n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+					vaddr + p_off, p_len, data, to);
+				kunmap_local(vaddr);
+			}
+
 			offset += n;
 			if (n != copy)
 				goto short_copy;
-- 
2.43.0



