Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DC479FD;
	Thu, 11 Apr 2024 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832502; cv=none; b=KqJWaiuQGgh5bVC5waSDeh+stMb0uxcqoXrmUoz+hGtcS1VxFe1TwH3w9fTJtbXdPijEFegTvHOEyYEMvrnggiXIkooOCuwG7DnuSbPO/Ddl2O6Kz7z9pX7BzzPNS3svGHsE5Fn66Neh1Je1b6bY1gDd+4mNJb7+nUcajPCL8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832502; c=relaxed/simple;
	bh=hzo6dXJDSplKMfcS7JGhL9HqzaCxh5H8I2+JpghInkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s51YnD2KFBQUhTvMeDokmhq993Wq7Ub+z56xiinJniLWB0RNez0XItKkM6lRMeME4HyLXsAKJ4j7z++k0IszbwgDVos8QvVw6dDOyuh4GbvEraChW8eIkFbcXlbIlcqcDeukv4+4+IxZbBUQE1No2V1H+Ony+7DKxx7przCmwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qarViO1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qarViO1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8443C433F1;
	Thu, 11 Apr 2024 10:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832502;
	bh=hzo6dXJDSplKMfcS7JGhL9HqzaCxh5H8I2+JpghInkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qarViO1WhLaCqvGrr0TAF10nagsvXzwPPgB4QRlvZYMidpTPQAadgCp7Xm2mGxXCJ
	 HNrF46uMt0WMLhHMF1KTtCQDT3ZrFC5TTA/nueswXmgG7Ro9yDXHGhMTmOvtc2XdwH
	 nJVxHqu8jWsWBH7jW4bf2Y8OWFBDRXvWSsHx/NLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 69/83] netfilter: nf_tables: release batch on table validation from abort path
Date: Thu, 11 Apr 2024 11:57:41 +0200
Message-ID: <20240411095414.762308749@linuxfoundation.org>
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
 net/netfilter/nf_tables_api.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8d38cd5047692..6b032a90e2b15 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9902,10 +9902,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nft_trans *trans, *next;
 	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
+	int err = 0;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
-		return -EAGAIN;
+		err = -EAGAIN;
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
@@ -10081,7 +10082,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	else
 		nf_tables_module_autoload_cleanup(net);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
@@ -10095,6 +10096,8 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
 
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -10892,9 +10895,10 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nft_net->commit_list) ||
-	    !list_empty(&nft_net->module_list))
-		__nf_tables_abort(net, NFNL_ABORT_NONE);
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
+	if (!list_empty(&nft_net->module_list))
+		nf_tables_module_autoload_cleanup(net);
 
 	__nft_release_tables(net);
 
-- 
2.43.0



