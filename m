Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A0F8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB152C433C7;
	Sun, 16 Jul 2023 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537779;
	bh=cdv6WKnYuq2BQjMKw+QxvX9rFXewCiWva3HnxacZfBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poFBk/EFD7XnHk00haa2rMSHcz7Pyg7L1qZ2FeKWGXQaQC3Mf40am7vIJw3dF0VdS
	 Y83LtvM0Vns30X2qVJSd5xs4cxGLJDEcY7vIqeXcSJzo/SWMm1oLZgvznRY02vk+Wu
	 6w88jKVFyH4pdVco0yPji7EXxtEYlq3EvdXCoahI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 218/800] netfilter: nf_tables: fix underflow in chain reference counter
Date: Sun, 16 Jul 2023 21:41:11 +0200
Message-ID: <20230716194954.158040836@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit b389139f12f287b8ed2e2628b72df89a081f0b59 ]

Set element addition error path decrements reference counter on chains
twice: once on element release and again via nft_data_release().

Then, d6b478666ffa ("netfilter: nf_tables: fix underflow in object
reference counter") incorrectly fixed this by removing the stateful
object reference count decrement.

Restore the stateful object decrement as in b91d90368837 ("netfilter:
nf_tables: fix leaking object reference count") and let
nft_data_release() decrement the chain reference counter, so this is
done only once.

Fixes: d6b478666ffa ("netfilter: nf_tables: fix underflow in object reference counter")
Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d64c163076a1..c742918f22a4a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6771,7 +6771,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_element_clash:
 	kfree(trans);
 err_elem_free:
-	nft_set_elem_destroy(set, elem.priv, true);
+	nf_tables_set_elem_destroy(ctx, set, elem.priv);
+	if (obj)
+		obj->use--;
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&elem.data.val, desc.type);
-- 
2.39.2



