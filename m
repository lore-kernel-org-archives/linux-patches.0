Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C49443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB97C433C8;
	Sun, 13 Aug 2023 21:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962128;
	bh=kkJeiYHMZW6Tugf3zjNiLrMoS/tlMeAhg3bf+65P61g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9AwN5jqlpqUqkafeVN39WiuzdBYTIkckTxmJlt+tXQvdW4B3ctZs/TWXbVPg5gHm
	 M3H8cmtWIt96/9ymsK0ElVi3m6tsB/RrCGorXOKKPFAMQTCGsjVS+XZKo2SiBKrd6y
	 lrP2XTDlNUxt3GGpE7sV9xiUp2KfXCtn/jsYiU7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.4 093/206] netfilter: nft_set_hash: mark set element as dead when deleting from packet path
Date: Sun, 13 Aug 2023 23:17:43 +0200
Message-ID: <20230813211727.729864308@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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

commit c92db3030492b8ad1d0faace7a93bbcf53850d0c upstream.

Set on the NFT_SET_ELEM_DEAD_BIT flag on this element, instead of
performing element removal which might race with an ongoing transaction.
Enable gc when dynamic flag is set on since dynset deletion requires
garbage collection after this patch.

Fixes: d0a8d877da97 ("netfilter: nft_dynset: support for element deletion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_hash.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -249,7 +249,9 @@ static bool nft_rhash_delete(const struc
 	if (he == NULL)
 		return false;
 
-	return rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params) == 0;
+	nft_set_elem_dead(&he->ext);
+
+	return true;
 }
 
 static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
@@ -412,7 +414,7 @@ static int nft_rhash_init(const struct n
 		return err;
 
 	INIT_DEFERRABLE_WORK(&priv->gc_work, nft_rhash_gc);
-	if (set->flags & NFT_SET_TIMEOUT)
+	if (set->flags & (NFT_SET_TIMEOUT | NFT_SET_EVAL))
 		nft_rhash_gc_init(set);
 
 	return 0;


