Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB241E522;
	Thu, 30 Jan 2025 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247174; cv=none; b=LYC2Hea8qHBWf7oYbwc+Qeld+A2VZSHf6Y3ok3c/o9WZbOTuw3y3w1xaq8BpxBqG+EzWF7gJzW/6u03ZHDjuG55ILbbLALoNo6s20EbgspM2IpRBHy9HHS0Tz4E3JVWZAIJPBeDrWD7SWNgbb15+U91kKMWeZYb8cqDN2m71xrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247174; c=relaxed/simple;
	bh=eaQNhTVLyWL1kGKzoI0HOZYQR/VlxGurGdEs+X3lSVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGdWVWtHw/nhROqkCHvL5vOoWnhHCsuqESg3BfP3PUCI5GLvV1glH39ezZSSNU/wkZBhEdtd9sbf5RfyK0U+oBqU3DT1ohcamOL2i8F0+Xmjvd3MOIW0Cy/fXAbiJ44li2WMR5ICDwn4rbCIPs9GGvX8YqaYmW2sTmf3FuzPzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACYjC9JK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACYjC9JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57801C4CED2;
	Thu, 30 Jan 2025 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247174;
	bh=eaQNhTVLyWL1kGKzoI0HOZYQR/VlxGurGdEs+X3lSVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACYjC9JK+DWSsyv6l3L4VIcphEM1Pb10I9grnwMJg/XGv2DSqRRqjPPt0g9PdrQtx
	 HwDv3zXor6Qeli9sy5dzfeRihfvAEa+KmZbgT7cXS2zB7thqjcAeoZw84NKxtuO1xo
	 K9VHoN6qS8gPhrJB4bK80NnHcSuNBRaKGDbzagl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youzhong Yang <youzhong@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 108/133] nfsd: add list_head nf_gc to struct nfsd_file
Date: Thu, 30 Jan 2025 15:01:37 +0100
Message-ID: <20250130140146.885376218@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Youzhong Yang <youzhong@gmail.com>

commit 8e6e2ffa6569a205f1805cbaeca143b556581da6 upstream.

nfsd_file_put() in one thread can race with another thread doing
garbage collection (running nfsd_file_gc() -> list_lru_walk() ->
nfsd_file_lru_cb()):

  * In nfsd_file_put(), nf->nf_ref is 1, so it tries to do nfsd_file_lru_add().
  * nfsd_file_lru_add() returns true (with NFSD_FILE_REFERENCED bit set)
  * garbage collector kicks in, nfsd_file_lru_cb() clears REFERENCED bit and
    returns LRU_ROTATE.
  * garbage collector kicks in again, nfsd_file_lru_cb() now decrements nf->nf_ref
    to 0, runs nfsd_file_unhash(), removes it from the LRU and adds to the dispose
    list [list_lru_isolate_move(lru, &nf->nf_lru, head)]
  * nfsd_file_put() detects NFSD_FILE_HASHED bit is cleared, so it tries to remove
    the 'nf' from the LRU [if (!nfsd_file_lru_remove(nf))]. The 'nf' has been added
    to the 'dispose' list by nfsd_file_lru_cb(), so nfsd_file_lru_remove(nf) simply
    treats it as part of the LRU and removes it, which leads to its removal from
    the 'dispose' list.
  * At this moment, 'nf' is unhashed with its nf_ref being 0, and not on the LRU.
    nfsd_file_put() continues its execution [if (refcount_dec_and_test(&nf->nf_ref))],
    as nf->nf_ref is already 0, nf->nf_ref is set to REFCOUNT_SATURATED, and the 'nf'
    gets no chance of being freed.

nfsd_file_put() can also race with nfsd_file_cond_queue():
  * In nfsd_file_put(), nf->nf_ref is 1, so it tries to do nfsd_file_lru_add().
  * nfsd_file_lru_add() sets REFERENCED bit and returns true.
  * Some userland application runs 'exportfs -f' or something like that, which triggers
    __nfsd_file_cache_purge() -> nfsd_file_cond_queue().
  * In nfsd_file_cond_queue(), it runs [if (!nfsd_file_unhash(nf))], unhash is done
    successfully.
  * nfsd_file_cond_queue() runs [if (!nfsd_file_get(nf))], now nf->nf_ref goes to 2.
  * nfsd_file_cond_queue() runs [if (nfsd_file_lru_remove(nf))], it succeeds.
  * nfsd_file_cond_queue() runs [if (refcount_sub_and_test(decrement, &nf->nf_ref))]
    (with "decrement" being 2), so the nf->nf_ref goes to 0, the 'nf' is added to the
    dispose list [list_add(&nf->nf_lru, dispose)]
  * nfsd_file_put() detects NFSD_FILE_HASHED bit is cleared, so it tries to remove
    the 'nf' from the LRU [if (!nfsd_file_lru_remove(nf))], although the 'nf' is not
    in the LRU, but it is linked in the 'dispose' list, nfsd_file_lru_remove() simply
    treats it as part of the LRU and removes it. This leads to its removal from
    the 'dispose' list!
  * Now nf->ref is 0, unhashed. nfsd_file_put() continues its execution and set
    nf->nf_ref to REFCOUNT_SATURATED.

As shown in the above analysis, using nf_lru for both the LRU list and dispose list
can cause the leaks. This patch adds a new list_head nf_gc in struct nfsd_file, and uses
it for the dispose list. This does not fix the nfsd_file leaking issue completely.

Signed-off-by: Youzhong Yang <youzhong@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   18 ++++++++++--------
 fs/nfsd/filecache.h |    1 +
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -218,6 +218,7 @@ nfsd_file_alloc(struct net *net, struct
 		return NULL;
 
 	INIT_LIST_HEAD(&nf->nf_lru);
+	INIT_LIST_HEAD(&nf->nf_gc);
 	nf->nf_birthtime = ktime_get();
 	nf->nf_file = NULL;
 	nf->nf_cred = get_current_cred();
@@ -395,8 +396,8 @@ nfsd_file_dispose_list(struct list_head
 	struct nfsd_file *nf;
 
 	while (!list_empty(dispose)) {
-		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		list_del_init(&nf->nf_lru);
+		nf = list_first_entry(dispose, struct nfsd_file, nf_gc);
+		list_del_init(&nf->nf_gc);
 		nfsd_file_free(nf);
 	}
 }
@@ -413,12 +414,12 @@ nfsd_file_dispose_list_delayed(struct li
 {
 	while(!list_empty(dispose)) {
 		struct nfsd_file *nf = list_first_entry(dispose,
-						struct nfsd_file, nf_lru);
+						struct nfsd_file, nf_gc);
 		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
 		struct nfsd_fcache_disposal *l = nn->fcache_disposal;
 
 		spin_lock(&l->lock);
-		list_move_tail(&nf->nf_lru, &l->freeme);
+		list_move_tail(&nf->nf_gc, &l->freeme);
 		spin_unlock(&l->lock);
 		queue_work(nfsd_filecache_wq, &l->work);
 	}
@@ -475,7 +476,8 @@ nfsd_file_lru_cb(struct list_head *item,
 
 	/* Refcount went to zero. Unhash it and queue it to the dispose list */
 	nfsd_file_unhash(nf);
-	list_lru_isolate_move(lru, &nf->nf_lru, head);
+	list_lru_isolate(lru, &nf->nf_lru);
+	list_add(&nf->nf_gc, head);
 	this_cpu_inc(nfsd_file_evictions);
 	trace_nfsd_file_gc_disposed(nf);
 	return LRU_REMOVED;
@@ -554,7 +556,7 @@ nfsd_file_cond_queue(struct nfsd_file *n
 
 	/* If refcount goes to 0, then put on the dispose list */
 	if (refcount_sub_and_test(decrement, &nf->nf_ref)) {
-		list_add(&nf->nf_lru, dispose);
+		list_add(&nf->nf_gc, dispose);
 		trace_nfsd_file_closing(nf);
 	}
 }
@@ -630,8 +632,8 @@ nfsd_file_close_inode_sync(struct inode
 
 	nfsd_file_queue_for_close(inode, &dispose);
 	while (!list_empty(&dispose)) {
-		nf = list_first_entry(&dispose, struct nfsd_file, nf_lru);
-		list_del_init(&nf->nf_lru);
+		nf = list_first_entry(&dispose, struct nfsd_file, nf_gc);
+		list_del_init(&nf->nf_gc);
 		nfsd_file_free(nf);
 	}
 	flush_delayed_fput();
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -44,6 +44,7 @@ struct nfsd_file {
 
 	struct nfsd_file_mark	*nf_mark;
 	struct list_head	nf_lru;
+	struct list_head	nf_gc;
 	struct rcu_head		nf_rcu;
 	ktime_t			nf_birthtime;
 };


