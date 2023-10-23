Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D515E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfYFqYkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE3CC433C7;
	Mon, 23 Oct 2023 11:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061130;
	bh=b7WwGh4NQo71ilbX8bni3P+E7hxj0EEhlruMerrF72A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfYFqYkw4ffF7Q+l/4uAFC7II0nc+/vmmU/1m3vKko28iMZa28pcqHSF78pDvwXCT
	 v3Q5VRRzxGhlr5gnWhYHpIwL8cScXvJ8LiZnorxDqPPMfA3gA+OPKq58OqelVFY6jQ
	 tkoYo6o6s3Y6ZDGO7+/R3JnI0+JLBlsZ6Y5ILx/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 045/137] netfilter: nft_set_rbtree: .deactivate fails if element has expired
Date: Mon, 23 Oct 2023 12:56:42 +0200
Message-ID: <20231023104822.546736921@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit d111692a59c1470ae530cbb39bcf0346c950ecc7 upstream.

This allows to remove an expired element which is not possible in other
existing set backends, this is more noticeable if gc-interval is high so
expired elements remain in the tree. On-demand gc also does not help in
this case, because this is delete element path. Return NULL if element
has expired.

Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_rbtree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -568,6 +568,8 @@ static void *nft_rbtree_deactivate(const
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
+			} else if (nft_set_elem_expired(&rbe->ext)) {
+				break;
 			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;
 				continue;


