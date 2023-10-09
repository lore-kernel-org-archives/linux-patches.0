Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226B62E649
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/nKy3m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9289CC433CA;
	Mon,  9 Oct 2023 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858665;
	bh=DFGWLGhlp1gr2W8EIRrGtyoLymBpppgv1jEz6uBq8eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/nKy3m7dGIKauk1zmvhYIBOyyd9v/8zu9etmBGLwvf78oGnr1BCjGNBMf/2h9Yt7
	 0DQDoDpWQ7fqs2i6NdEQiu21R/ZTV2oYKJxqFiSwsI3XxqEX6dwXk+hyJV08f+IKkU
	 wOHmixRiGX+WpAQXHGEEmvVgXVwTypo57lKdrtw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/226] netfilter: nf_tables: disallow element removal on anonymous sets
Date: Mon,  9 Oct 2023 14:59:55 +0200
Message-ID: <20231009130127.669930322@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 23a3bfd4ba7acd36abf52b78605f61b21bdac216 ]

Anonymous sets need to be populated once at creation and then they are
bound to rule since 938154b93be8 ("netfilter: nf_tables: reject unbound
anonymous set before commit phase"), otherwise transaction reports
EINVAL.

Userspace does not need to delete elements of anonymous sets that are
not yet bound, reject this with EOPNOTSUPP.

>From flush command path, skip anonymous sets, they are expected to be
bound already. Otherwise, EINVAL is hit at the end of this transaction
for unbound sets.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 32c97cc87ddc2..52c776b5967ef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1267,8 +1267,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 
-		if (nft_set_is_anonymous(set) &&
-		    !list_empty(&set->bindings))
+		if (nft_set_is_anonymous(set))
 			continue;
 
 		err = nft_delset(ctx, set);
@@ -5922,8 +5921,10 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (!list_empty(&set->bindings) &&
-	    (set->flags & (NFT_SET_CONSTANT | NFT_SET_ANONYMOUS)))
+	if (nft_set_is_anonymous(set))
+		return -EOPNOTSUPP;
+
+	if (!list_empty(&set->bindings) && (set->flags & NFT_SET_CONSTANT))
 		return -EBUSY;
 
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
-- 
2.40.1



