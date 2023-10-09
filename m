Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285D818E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiQCabYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97217C433C9;
	Mon,  9 Oct 2023 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858535;
	bh=TZ33Q7Ai15Qy2mhya9GfDtEoCNtOLmqfLsSQW1wDLnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiQCabYRGE2wrFoCV0yjk6e7MMRZ8dFh4V78C6P5pylzO0ZftNWxFSq3AnNglw2no
	 LM+XZb/iU/Ng0VYrnJs0uiy/AQY/i4WRRr6+8tVfFlJsc6Ni0MlBv1kiCCnL7GLBim
	 77N8iJuDA9sfAPnTCBNge76r8gElz4RJhlUYC9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/226] netfilter: nft_set_hash: mark set element as dead when deleting from packet path
Date: Mon,  9 Oct 2023 14:59:41 +0200
Message-ID: <20231009130127.267928602@linuxfoundation.org>
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

commit c92db3030492b8ad1d0faace7a93bbcf53850d0c upstream.

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
index 6ae99b3107bc9..9cdf348b048a4 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -251,7 +251,9 @@ static bool nft_rhash_delete(const struct nft_set *set,
 	if (he == NULL)
 		return false;
 
-	return rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params) == 0;
+	nft_set_elem_dead(&he->ext);
+
+	return true;
 }
 
 static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
@@ -398,7 +400,7 @@ static int nft_rhash_init(const struct nft_set *set,
 		return err;
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rhash_gc);
-	if (set->flags & NFT_SET_TIMEOUT)
+	if (set->flags & (NFT_SET_TIMEOUT | NFT_SET_EVAL))
 		nft_rhash_gc_init(set);
 
 	return 0;
-- 
2.40.1



