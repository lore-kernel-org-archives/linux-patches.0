Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E5415484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU7aXUDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DDEC433C7;
	Mon, 23 Oct 2023 11:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059895;
	bh=hiW/Y1KIkHl0HAoWz8sARvzyiHspDX+vHsM73QHYB2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU7aXUDP38exSytM4I3UN7FWMuTMpGUJTZO4OIMXv/DHxhcjshBXEAmy6Obq2bJy0
	 /TGSE6kh7Jt8PRVtR+K3XcFqwZJQzGfqCBC5RQrOnND6yJy6cRENm466Apkh1PvJOD
	 YrQI+JgjCAlfKcGQlKaPizphC8xyWuzvUSe0ZxQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 62/98] netfilter: nft_set_rbtree: .deactivate fails if element has expired
Date: Mon, 23 Oct 2023 12:56:51 +0200
Message-ID: <20231023104815.799881309@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -326,6 +326,8 @@ static void *nft_rbtree_deactivate(const
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
+			} else if (nft_set_elem_expired(&rbe->ext)) {
+				break;
 			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = parent->rb_left;
 				continue;


