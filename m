Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410AA1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8534C433C9;
	Wed,  4 Oct 2023 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442667;
	bh=Yrdvh45jvHb8nlqnc1stXGzZUgBiLpU7j1IiPxRtHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdR8mYLklplWZId4d7T1YNo/7Xw4nEuhibF3+l5p6Uvx/cpfhb9uu0yfrvuNXMgUM
	 fDwKgkEsVgLTxatGlBNdMtPH4ADV5mBaiD8jD4xIc/9G6VFIdcRqmogDBLVMHDLq46
	 nAhcWL1tPjp/s7Rd7j+PAd88IWudOvBV+85+hQt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/183] netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
Date: Wed,  4 Oct 2023 19:54:19 +0200
Message-ID: <20231004175205.143585335@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

commit 2ee52ae94baabf7ee09cf2a8d854b990dac5d0e4 upstream.

New elements in this transaction might expired before such transaction
ends. Skip sync GC for such elements otherwise commit path might walk
over an already released object. Once transaction is finished, async GC
will collect such expired element.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index c6435e7092319..f250b5399344a 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -312,6 +312,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
+	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	int d, err;
 
@@ -357,8 +358,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		if (!nft_set_elem_active(&rbe->ext, genmask))
 			continue;
 
-		/* perform garbage collection to avoid bogus overlap reports. */
-		if (nft_set_elem_expired(&rbe->ext)) {
+		/* perform garbage collection to avoid bogus overlap reports
+		 * but skip new elements in this transaction.
+		 */
+		if (nft_set_elem_expired(&rbe->ext) &&
+		    nft_set_elem_active(&rbe->ext, cur_genmask)) {
 			err = nft_rbtree_gc_elem(set, priv, rbe, genmask);
 			if (err < 0)
 				return err;
-- 
2.40.1



