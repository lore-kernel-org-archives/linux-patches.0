Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56538146A64;
	Thu, 11 Apr 2024 10:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831034; cv=none; b=qZZfDeEC98pAzYo4FgajkI9SvsrYLYRTTsWYCLEaRa4rfKu64FNme/baFLjuQHIOu2Xna0UOVA7jCp/CfxZbvoNhtxu8Zi6yDkZlwxtMyTT667Q2YDsEYplU/WmguMGSKci4zJvjqb7IMRySSh7YtDRAYoj2nzYV9mzkUk8fHHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831034; c=relaxed/simple;
	bh=fSAXaUo0l0NsWcJ9YSBEb0i2CUN6pYDGVqlOAS6O+T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu0NOjWxSVjYXGVGQ0zAfmkgUGCbQI01vMuq6FZ9oZa7jzAN7ogGxxDaYWbyKD/6j8Ybm6LBlPXsBgdcMDRTbUFXU1+FIej5EtaR8ts/PotzpwAfskuh+xHc+ym5ofZBq86tK1XvmCjFP/zeC3D+bci6AqmG/vZTkvxoELMgWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rngwmlw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rngwmlw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA32C433F1;
	Thu, 11 Apr 2024 10:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831034;
	bh=fSAXaUo0l0NsWcJ9YSBEb0i2CUN6pYDGVqlOAS6O+T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rngwmlw3cCz+IDK8kgM13PfUWb3fudjrf7HjotCWz3oqSR1X12enDnz2F8SUW1GwK
	 BnywMOcPjsdgahHmRhVv3saKNrkEA/e9NgLv7kf64WAtOpuZHbWsHDNIO9zOhcUQrD
	 YVMQFncBweDb3OkCyzBbw5Mi5kSjxhswjDHYv3jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/215] netfilter: nf_tables: release batch on table validation from abort path
Date: Thu, 11 Apr 2024 11:56:51 +0200
Message-ID: <20240411095430.929370795@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit a45e6889575c2067d3c0212b6bc1022891e65b91 upstream.

Unlike early commit path stage which triggers a call to abort, an
explicit release of the batch is required on abort, otherwise mutex is
released and commit_list remains in place.

Add WARN_ON_ONCE to ensure commit_list is empty from the abort path
before releasing the mutex.

After this patch, commit_list is always assumed to be empty before
grabbing the mutex, therefore

  03c1f1ef1584 ("netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()")

only needs to release the pending modules for registration.

Cc: stable@vger.kernel.org
Fixes: c0391b6ab810 ("netfilter: nf_tables: missing validation from the abort path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f4821d64c2fd8..b719f3517caf1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7564,10 +7564,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
+	int err = 0;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
-		return -EAGAIN;
+		err = -EAGAIN;
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
@@ -7700,7 +7701,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	else
 		nf_tables_module_autoload_cleanup(net);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
@@ -7714,6 +7715,8 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -8400,8 +8403,11 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nft_net->commit_list))
-		__nf_tables_abort(net, NFNL_ABORT_NONE);
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
+	if (!list_empty(&nft_net->module_list))
+		nf_tables_module_autoload_cleanup(net);
+
 	__nft_release_tables(net);
 
 	nft_gc_seq_end(nft_net, gc_seq);
-- 
2.43.0



