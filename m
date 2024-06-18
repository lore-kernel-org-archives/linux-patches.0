Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC70D13D528;
	Tue, 18 Jun 2024 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716619; cv=none; b=N+GmfkXVyR7dxajrDF2ELMNiAS5Ft6jY1y8pFqcezNohn+jAgo34qo0qPtOEgUy6864kTqFn0XU3XsLoapTCfxE04P9gYx5nyzflUglaWTzQ8hMWmw0zHbgBq3qNB1LPZXs6vz+R6e8dDDxi5QfgjbZtLC14NUXAf7FmPoRX1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716619; c=relaxed/simple;
	bh=gH1I4qyXBppcyueRwo4cQJI/nL1V/kTJcHZRHDsb6bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcgMtnozBnODYnJHVNsM+MUi4mOXPaiiW791UWC5bMRDUQcYi//CUIZpDkNYd7sfv/z43Bqvy7n4h4CYirOOuJ8/rwiPVeQ5OkbOgpqL2etY7b0jSHndLqO/0JCt3yXX5JHu22qJM+V8fSzAPpdkyiCbjgOziUh0xt8tFU4rp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhbqCzYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhbqCzYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E22C3277B;
	Tue, 18 Jun 2024 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716619;
	bh=gH1I4qyXBppcyueRwo4cQJI/nL1V/kTJcHZRHDsb6bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhbqCzYxHMWVqaFTFNHCjQ1zPZJzEmNZ5Cv8wgsm0eUWZBh5oFJv+MS5qTCJOiLOF
	 LXDF6eLsw44UTokIb4TCcfeMTYoSeszv7bs8zZBZKK8e4kDSrtAPrHQX84xMaZx4E7
	 tBTFpzQyGXnAWdqPJm8V1biXRnkCP+5QPLQyVuzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 706/770] nfsd: reorganize filecache.c
Date: Tue, 18 Jun 2024 14:39:19 +0200
Message-ID: <20240618123434.523331609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8214118589881b2d390284410c5ff275e7a5e03c ]

In a coming patch, we're going to rework how the filecache refcounting
works. Move some code around in the function to reduce the churn in the
later patches, and rename some of the functions with (hopefully) clearer
names: nfsd_file_flush becomes nfsd_file_fsync, and
nfsd_file_unhash_and_dispose is renamed to nfsd_file_unhash_and_queue.

Also, the nfsd_file_put_final tracepoint is renamed to nfsd_file_free,
to better match the name of the function from which it's called.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 111 ++++++++++++++++++++++----------------------
 fs/nfsd/trace.h     |   4 +-
 2 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b95b1be5b2e43..fb7ada3f7410e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -334,16 +334,59 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 	return nf;
 }
 
+static void
+nfsd_file_fsync(struct nfsd_file *nf)
+{
+	struct file *file = nf->nf_file;
+
+	if (!file || !(file->f_mode & FMODE_WRITE))
+		return;
+	if (vfs_fsync(file, 1) != 0)
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
+}
+
+static int
+nfsd_file_check_write_error(struct nfsd_file *nf)
+{
+	struct file *file = nf->nf_file;
+
+	if (!file || !(file->f_mode & FMODE_WRITE))
+		return 0;
+	return filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err));
+}
+
+static void
+nfsd_file_hash_remove(struct nfsd_file *nf)
+{
+	trace_nfsd_file_unhash(nf);
+
+	if (nfsd_file_check_write_error(nf))
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
+	rhashtable_remove_fast(&nfsd_file_rhash_tbl, &nf->nf_rhash,
+			       nfsd_file_rhash_params);
+}
+
+static bool
+nfsd_file_unhash(struct nfsd_file *nf)
+{
+	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
+		nfsd_file_hash_remove(nf);
+		return true;
+	}
+	return false;
+}
+
 static bool
 nfsd_file_free(struct nfsd_file *nf)
 {
 	s64 age = ktime_to_ms(ktime_sub(ktime_get(), nf->nf_birthtime));
 	bool flush = false;
 
+	trace_nfsd_file_free(nf);
+
 	this_cpu_inc(nfsd_file_releases);
 	this_cpu_add(nfsd_file_total_age, age);
 
-	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
 		nfsd_file_mark_put(nf->nf_mark);
 	if (nf->nf_file) {
@@ -377,27 +420,6 @@ nfsd_file_check_writeback(struct nfsd_file *nf)
 		mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 }
 
-static int
-nfsd_file_check_write_error(struct nfsd_file *nf)
-{
-	struct file *file = nf->nf_file;
-
-	if (!file || !(file->f_mode & FMODE_WRITE))
-		return 0;
-	return filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err));
-}
-
-static void
-nfsd_file_flush(struct nfsd_file *nf)
-{
-	struct file *file = nf->nf_file;
-
-	if (!file || !(file->f_mode & FMODE_WRITE))
-		return;
-	if (vfs_fsync(file, 1) != 0)
-		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-}
-
 static void nfsd_file_lru_add(struct nfsd_file *nf)
 {
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
@@ -411,31 +433,18 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
 		trace_nfsd_file_lru_del(nf);
 }
 
-static void
-nfsd_file_hash_remove(struct nfsd_file *nf)
-{
-	trace_nfsd_file_unhash(nf);
-
-	if (nfsd_file_check_write_error(nf))
-		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-	rhashtable_remove_fast(&nfsd_file_rhash_tbl, &nf->nf_rhash,
-			       nfsd_file_rhash_params);
-}
-
-static bool
-nfsd_file_unhash(struct nfsd_file *nf)
+struct nfsd_file *
+nfsd_file_get(struct nfsd_file *nf)
 {
-	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
-		nfsd_file_hash_remove(nf);
-		return true;
-	}
-	return false;
+	if (likely(refcount_inc_not_zero(&nf->nf_ref)))
+		return nf;
+	return NULL;
 }
 
 static void
-nfsd_file_unhash_and_dispose(struct nfsd_file *nf, struct list_head *dispose)
+nfsd_file_unhash_and_queue(struct nfsd_file *nf, struct list_head *dispose)
 {
-	trace_nfsd_file_unhash_and_dispose(nf);
+	trace_nfsd_file_unhash_and_queue(nf);
 	if (nfsd_file_unhash(nf)) {
 		/* caller must call nfsd_file_dispose_list() later */
 		nfsd_file_lru_remove(nf);
@@ -473,7 +482,7 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_unhash_and_put(nf);
 
 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
-		nfsd_file_flush(nf);
+		nfsd_file_fsync(nf);
 		nfsd_file_put_noref(nf);
 	} else if (nf->nf_file && test_bit(NFSD_FILE_GC, &nf->nf_flags)) {
 		nfsd_file_put_noref(nf);
@@ -482,14 +491,6 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_put_noref(nf);
 }
 
-struct nfsd_file *
-nfsd_file_get(struct nfsd_file *nf)
-{
-	if (likely(refcount_inc_not_zero(&nf->nf_ref)))
-		return nf;
-	return NULL;
-}
-
 static void
 nfsd_file_dispose_list(struct list_head *dispose)
 {
@@ -498,7 +499,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del_init(&nf->nf_lru);
-		nfsd_file_flush(nf);
+		nfsd_file_fsync(nf);
 		nfsd_file_put_noref(nf);
 	}
 }
@@ -512,7 +513,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del_init(&nf->nf_lru);
-		nfsd_file_flush(nf);
+		nfsd_file_fsync(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;
 		if (nfsd_file_free(nf))
@@ -712,7 +713,7 @@ __nfsd_file_close_inode(struct inode *inode, struct list_head *dispose)
 				       nfsd_file_rhash_params);
 		if (!nf)
 			break;
-		nfsd_file_unhash_and_dispose(nf, dispose);
+		nfsd_file_unhash_and_queue(nf, dispose);
 		count++;
 	} while (1);
 	rcu_read_unlock();
@@ -914,7 +915,7 @@ __nfsd_file_cache_purge(struct net *net)
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
 			if (!net || nf->nf_net == net)
-				nfsd_file_unhash_and_dispose(nf, &dispose);
+				nfsd_file_unhash_and_queue(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 191b206379b76..5faec08ac7cf7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -819,10 +819,10 @@ DEFINE_EVENT(nfsd_file_class, name, \
 	TP_PROTO(struct nfsd_file *nf), \
 	TP_ARGS(nf))
 
-DEFINE_NFSD_FILE_EVENT(nfsd_file_put_final);
+DEFINE_NFSD_FILE_EVENT(nfsd_file_free);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
-DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
+DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_queue);
 
 TRACE_EVENT(nfsd_file_alloc,
 	TP_PROTO(
-- 
2.43.0



