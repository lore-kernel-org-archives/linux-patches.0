Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88B168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A79FC433CB;
	Wed, 20 Sep 2023 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214074;
	bh=bdsuqymfEkeTxktq+SWsgeZn4fmnQgXvYep/TmlU0WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfdiSG0zxmEez8naz3qbsRnrJ+MzIK6NVcHLbff7LKujUTSrQAMZaE+HU/BkOACFq
	 LLVRkUpGF7BNORDuOBMcKRcEqbMdXP0sxUkmJDWkwwOWN2X4gMMJCHXE+pB57NF4jF
	 LdMpkfUx7YUJKBYdky245A/Qqq63KRcbk9JtMXco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/110] netfilter: nft_set_hash: mark set element as dead when deleting from packet path
Date: Wed, 20 Sep 2023 13:32:23 +0200
Message-ID: <20230920112833.596386253@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

[ Upstream commit c92db3030492b8ad1d0faace7a93bbcf53850d0c ]

Set on the NFT_SET_ELEM_DEAD_BIT flag on this element, instead of
performing element removal which might race with an ongoing transaction.
Enable gc when dynamic flag is set on since dynset deletion requires
garbage collection after this patch.

Fixes: d0a8d877da97 ("netfilter: nft_dynset: support for element deletion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 960cbd56c0406..8dfa97105d8a3 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -249,7 +249,9 @@ static bool nft_rhash_delete(const struct nft_set *set,
 	if (he == NULL)
 		return false;
 
-	return rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params) == 0;
+	nft_set_elem_dead(&he->ext);
+
+	return true;
 }
 
 static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
@@ -414,7 +416,7 @@ static int nft_rhash_init(const struct nft_set *set,
 		return err;
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rhash_gc);
-	if (set->flags & NFT_SET_TIMEOUT)
+	if (set->flags & (NFT_SET_TIMEOUT | NFT_SET_EVAL))
 		nft_rhash_gc_init(set);
 
 	return 0;
-- 
2.40.1



