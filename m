Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A431448C8;
	Thu, 11 Apr 2024 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832260; cv=none; b=p8F6U+I1iiqpLJMa1Rw/cqQgEpmkhJCbZECanAeyfcQwyL+aISn45kkvGYv8bewEpJ1ch6lO8iYJnr6NzoW8b/JoEDMfekfKKRB2BeaomnP1cUG2JJUz7cWMr0Ij/rb4t0HAEVuzIhD23syftP2gykTYK/Go7xXcr2mbUY6W3ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832260; c=relaxed/simple;
	bh=lE+KimLROdpJh55G1IyNff9LFxHjn62OKHfy26o0ZrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enLteI+QYKYb6APZuXsH7EEdgwoT0gWHo4+XPIGtZlcvXfvSeqgsYhl6wSXATToBXbdDMsSRklBMaBWKEyDj+LRJtv/4C9wkS6hoU0H7wHzO6JODzXPTy21fwvIRlH/5LY5bgoQ5pssYH4OQKQz01hf+b2hUmyf/zUHMYnNtFrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGZsfM1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGZsfM1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D723AC433F1;
	Thu, 11 Apr 2024 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832260;
	bh=lE+KimLROdpJh55G1IyNff9LFxHjn62OKHfy26o0ZrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGZsfM1wLtnZ+chp99bc/vIHtpikJ/D+1hUKZLH2f3wn92C9Mo8iwGuKJjQtxQuIA
	 C29cwFaWHsOkYEDVvCTIuBTSinAJbw4U2Zoeyq2Y4pnRZ0u2CQgPrO6ZCn/1focU3C
	 yFs56j2pldXSsj1CWUQa5f2P4eDdqNO2JPXcHAu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/294] netfilter: nf_tables: discard table flag update with pending basechain deletion
Date: Thu, 11 Apr 2024 11:57:27 +0200
Message-ID: <20240411095444.085346905@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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
index ef271628975a9..ab7f7e45b9846 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1084,6 +1084,24 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
 					 __NFT_TABLE_F_WAS_AWAKEN)
 
+static bool nft_table_pending_update(const struct nft_ctx *ctx)
+{
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
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
@@ -1101,7 +1119,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		return 0;
 
 	/* No dormant off/on/off/on games in single transaction */
-	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+	if (nft_table_pending_update(ctx))
 		return -EINVAL;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
-- 
2.43.0



