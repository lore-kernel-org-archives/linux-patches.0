Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43982611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC9EC433EF;
	Sun, 28 May 2023 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301592;
	bh=Cc1VnL6Phn3nTT6nMn48qDkdPiRcIU1+m86pS5D0sxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwSStuLAhZqJ4Hx3XQKoJcbsRj5IKJGT9hpxkA5++5z7fgnD4l/4zY0PY/p3NXsG/
	 l14to51mVdYulOemvkXHteU1bsADJRShjJqoxzwH1KnRFYA3GUb+4J2QWaBr3KhO35
	 mKFVF6xsHCWRy9dS3df3R6SaV8uuWlGBXQrkQvSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/132] netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
Date: Sun, 28 May 2023 20:10:22 +0100
Message-Id: <20230528190836.088879002@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 5a2f3dc31811e93be15522d9eb13ed61460b76c8 ]

If the NFTA_SET_ELEM_OBJREF netlink attribute is present and
NFT_SET_OBJECT flag is set on, report EINVAL.

Move existing sanity check earlier to validate that NFT_SET_OBJECT
requires NFTA_SET_ELEM_OBJREF.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ab1e0f0962a2b..5cafa90f9d807 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4440,6 +4440,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (set->flags & NFT_SET_OBJECT) {
+		if (!nla[NFTA_SET_ELEM_OBJREF] &&
+		    !(flags & NFT_SET_ELEM_INTERVAL_END))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_OBJREF])
+			return -EINVAL;
+	}
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -4474,10 +4483,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
-		if (!(set->flags & NFT_SET_OBJECT)) {
-			err = -EINVAL;
-			goto err2;
-		}
 		obj = nft_obj_lookup(ctx->table, nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);
 		if (IS_ERR(obj)) {
-- 
2.39.2



