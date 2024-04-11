Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E1D624;
	Thu, 11 Apr 2024 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832508; cv=none; b=SGa0BnUYsaOI7XAqwrhK/Hm0tt02/Bhei05pADMRL7sae8AbhMCDwd0f4EvcMVa+tvH1QFxXbFTErfV3c91yo2CB6NAFzHALKWpuIX4nLRzyRhMClaqjt+sfj9HjGpNCT3f+r5dsTq04Agx9mC579F/ZpJWxicwAVSsSDJv3GiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832508; c=relaxed/simple;
	bh=9hAm9kmSVvTGTfq9K+U2ZCCTp50CYnCh50JWJMp6zbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfKMRqBub1ndKKfLqsgcfsfkftZgmNQxn2IaaHnKO/q2bwBQYIii0QG48cQfbo3X458CTr/42bK9cgk9RBy/xsBf1wwT813Td7qL4srY8xm21dZ1EyYQSaObA5by1gPd8t7ODt6KyLjL+Bi4Fsm2okZErWtKZuw9QejHPqvlW9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lFHrHbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lFHrHbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E534C433F1;
	Thu, 11 Apr 2024 10:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832508;
	bh=9hAm9kmSVvTGTfq9K+U2ZCCTp50CYnCh50JWJMp6zbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lFHrHbbhEjKRJwZDceMvOd8Hng4Ju/8ILhJ9cR+GdhD3lIirt40/ofC0CZzU7eB9
	 TIkUJer0lqG6YDTeUf7Iqzja8Cd+V32GRf9Sc89HtAKa9PS3g1eGczD/Jp7v31Dwo8
	 iOfW6g88TvlXGJOy9z1TkQ2FzBdROC/8vNIrTuWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 71/83] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Thu, 11 Apr 2024 11:57:43 +0200
Message-ID: <20240411095414.822712877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 1bc83a019bbe268be3526406245ec28c2458a518 upstream.

Hook unregistration is deferred to the commit phase, same occurs with
hook updates triggered by the table dormant flag. When both commands are
combined, this results in deleting a basechain while leaving its hook
still registered in the core.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e7b31c2c92df2..8152a69d82681 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1192,6 +1192,24 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	struct nft_trans *trans;
+
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return true;
+
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
+		if (trans->ctx.table == ctx->table &&
+		    trans->msg_type == NFT_MSG_DELCHAIN &&
+		    nft_is_base_chain(trans->ctx.chain))
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
@@ -1215,7 +1233,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return -EOPNOTSUPP;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
-- 
2.43.0



