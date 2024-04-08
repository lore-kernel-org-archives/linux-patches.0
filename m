Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16911823A3;
	Mon,  8 Apr 2024 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582110; cv=none; b=C9OHN923KQs7NuIDWaZQbgODpVPw+uWq/MqGOLzJ4Y9c3y8cZN6V7TSO53pWwdITLuo4ejzNreKf6KIRqdvByFkfRSPwmgZNbsWOIPOGMy21Z1YbecQ06HyDg1ecxxgZXc6PIJotzCHPX0XKnWWE8djEMyPTK8uIMP+6EdmmoTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582110; c=relaxed/simple;
	bh=NJcp3wkZPWKmrioYreNtnjGKbtwaCM6ROaZmEj3gNI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuCzPVnFhVrSPivea4z6D0I9PqysMIbQlDlqnvYQa02efjIC3DB25lOYPsBus6VsoH8u8Ks4ALyRuiAe4IVwsejStEXwEb8uX60dJ6MrPLT0Dha5YFMM7YYUJ/xBZfvwB7uJlsYlYt1V9GrLLauXwW0ABwHgHKiFV03hoOwf4lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+vWQwgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+vWQwgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6DEC433F1;
	Mon,  8 Apr 2024 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582110;
	bh=NJcp3wkZPWKmrioYreNtnjGKbtwaCM6ROaZmEj3gNI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+vWQwgkLhVwSx3Tl6SJx1MqS0yWbr5/2Z664Un58Wh6IGu71HXgeOMC0le51IujC
	 bIqRVT3N120bXLQy6gvcvrWOpvMKjRWfbFsCxpqmsNSCDYjQlscoZhZ8Qs9SlsXNce
	 Lp4f/bdF1hqcLo79Qv2EkTpHHvQRdh5T6AmjMcE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/273] netfilter: nf_tables: skip netdev hook unregistration if table is dormant
Date: Mon,  8 Apr 2024 14:55:22 +0200
Message-ID: <20240408125310.757757801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index db233965631bb..8ccda4af3f80d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10208,9 +10208,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -10482,9 +10484,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
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



