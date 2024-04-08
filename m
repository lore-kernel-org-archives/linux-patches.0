Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20106D1A9;
	Mon,  8 Apr 2024 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582471; cv=none; b=jqXLdSVSOvDCmDOOiw5wXNSH9mmUtrHvt4npdaa5YfSd26TYPyA2AN7w23eD9XscjSBKNe5/J7IuQiWjsthwlYRfWmZ8HL/FHMok3/uUWmXhz/lVgiHTEvAG176GDC9+l9uPm4x5dEn5E/tNRjrbOfMjxPdg158fF0z6vZDx3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582471; c=relaxed/simple;
	bh=QWIcRRJKa9GEFEjpT0+OlPcCrE8uZgJzuu0ro3Iqb0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY9UxJfCwVNi5BgMQmePGwoZsvzznSvwWvyGnYdlqv/cjyaQAeeGQIRCZ2QKOZVFyZ+ty1TTxQhoLbMENSimWgTC8JKg+baQeeP6PREitaHESNDTuhU9BKWRosgRStTXA1xCwhIkSBUGavrqPOdyyZ02LUo3gIudg8xKSutxrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsDRtzrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsDRtzrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548BAC43394;
	Mon,  8 Apr 2024 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582471;
	bh=QWIcRRJKa9GEFEjpT0+OlPcCrE8uZgJzuu0ro3Iqb0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsDRtzrmYa6hUv3mbeLIKga5wOja/0aghEHV+TRYyCyWNJFsavgTo9qVpeRkeV5Un
	 FLGQ8zQa5vF1sYVJlbFx6+aHuvjnMSyBo+AvoLusy/UsJXmYGiB8F7O4KvRiFoCoCl
	 SiDs+2g/VRODEXOQ+PBYRim47NspbKx8zidhwlkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.8 079/273] netfilter: nf_tables: release batch on table validation from abort path
Date: Mon,  8 Apr 2024 14:55:54 +0200
Message-ID: <20240408125311.756004480@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10451,10 +10451,11 @@ static int __nf_tables_abort(struct net
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
@@ -10647,7 +10648,7 @@ static int __nf_tables_abort(struct net
 	else
 		nf_tables_module_autoload_cleanup(net);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
@@ -10660,6 +10661,9 @@ static int nf_tables_abort(struct net *n
 	gc_seq = nft_gc_seq_begin(nft_net);
 	ret = __nf_tables_abort(net, action);
 	nft_gc_seq_end(nft_net, gc_seq);
+
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -11461,9 +11465,10 @@ static void __net_exit nf_tables_exit_ne
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nft_net->commit_list) ||
-	    !list_empty(&nft_net->module_list))
-		__nf_tables_abort(net, NFNL_ABORT_NONE);
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+
+	if (!list_empty(&nft_net->module_list))
+		nf_tables_module_autoload_cleanup(net);
 
 	__nft_release_tables(net);
 


