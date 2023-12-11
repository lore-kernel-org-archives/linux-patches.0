Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D05101A;
	Mon, 11 Dec 2023 18:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhTOp7G+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EE5C433C7;
	Mon, 11 Dec 2023 18:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319329;
	bh=wuqT2vIC/WUMx2FV1kTmhJUBTJk7wfRuSQ6Zdu2XedI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhTOp7G+buzF7s6aJ/RxZlxVofTeZ/oKmTFXDdZNN8YY32whJqMjyWjpEh5UCgl5B
	 2ZT+EepQOZyPa7jnpdKHIndyuqBt4VrhLQitnWEu09cnWdbAYoeiZzIga1n5GKvkwV
	 Zz7JYO0wel346JZid/oKzgpj4927XGryx2tVeVec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/244] netfilter: nf_tables: bail out on mismatching dynset and set expressions
Date: Mon, 11 Dec 2023 19:19:17 +0100
Message-ID: <20231211182048.655543919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3701cd390fd731ee7ae8b8006246c8db82c72bea ]

If dynset expressions provided by userspace is larger than the declared
set expressions, then bail out.

Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_dynset.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 5c5cc01c73c5a..629a91a8c6141 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -279,10 +279,15 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			priv->expr_array[i] = dynset_expr;
 			priv->num_exprs++;
 
-			if (set->num_exprs &&
-			    dynset_expr->ops != set->exprs[i]->ops) {
-				err = -EOPNOTSUPP;
-				goto err_expr_free;
+			if (set->num_exprs) {
+				if (i >= set->num_exprs) {
+					err = -EINVAL;
+					goto err_expr_free;
+				}
+				if (dynset_expr->ops != set->exprs[i]->ops) {
+					err = -EOPNOTSUPP;
+					goto err_expr_free;
+				}
 			}
 			i++;
 		}
-- 
2.42.0



