Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38426F08E;
	Mon,  8 Apr 2024 13:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581756; cv=none; b=OPnIHO1Oz4MQnDYboCDqF+hB5MlFtdZUdsj9oKNC4dFKW8MjRqNsLrJQ5vvrVRhmkBP/FeUqWRBALeNdJiMCkVna4vnG9im+/US1CwRG2X4hPUCsNY3NhJuxV5FxPInX/NoAY744sDfMMr3Y6mF8B9NfFyAT/8lj2/71ex86+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581756; c=relaxed/simple;
	bh=sMXx4vtjYbaBJN+68n9CR6w9sLVlTb9BjdnaTtoD13c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLLRDtJ901P1QS0L+/tppNMs3Zx1VVlf1NdJsCdmBNvnPFZGkh+1B03V5pBgA1PcXDfeaHzWGN0/Tw6oBsuGIBTxwYBSXtGsOyc+yXa1Sv1CROFxCAMKNbhkiprsN4Rv1bh/X9oMWJk47yELnOhM8th6x+WfTvBWKZP6/yVBgkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO0Sr0Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO0Sr0Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD90C433F1;
	Mon,  8 Apr 2024 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581755;
	bh=sMXx4vtjYbaBJN+68n9CR6w9sLVlTb9BjdnaTtoD13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO0Sr0Y0GnWiBOKtm3H5kgIl9J2Xs5ySa1c2j6kPxAMqq124k5mfWhU/WG6k8Oxer
	 zAazwfV7pM8berLYiO7koO0cHhEtMf5t0crlvvmwZHpb4t/uDjMDUhY4+KQq1xfaBO
	 syd0TMcllk3VSPtjYbiZdyD2/XzUb56XzpEDtQFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/252] netfilter: nf_tables: skip netdev hook unregistration if table is dormant
Date: Mon,  8 Apr 2024 14:55:36 +0200
Message-ID: <20240408125307.793454498@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

[ Upstream commit 216e7bf7402caf73f4939a8e0248392e96d7c0da ]

Skip hook unregistration when adding or deleting devices from an
existing netdev basechain. Otherwise, commit/abort path try to
unregister hooks which not enabled.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6e4e22a10a826..b2ef7e37f11cd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10083,9 +10083,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+					nft_netdev_unregister_hooks(net,
+								    &nft_trans_chain_hooks(trans),
+								    true);
+				}
 			} else {
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
@@ -10357,9 +10359,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+					nft_netdev_unregister_hooks(net,
+								    &nft_trans_chain_hooks(trans),
+								    true);
+				}
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.43.0



