Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AAD6A342;
	Mon,  8 Apr 2024 13:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584242; cv=none; b=Ah9WjsyfpDeEukkuHwiWD8wmx6yAHZyknr2Qs/cRLSgeIbIFCXoOAD94GtMhgFO5MVAUNlsshjxirAyOoalQ+RIv/X9tYwxKVQXq6zGDAxQslT84yZYuEzwVQtO0NiSrNZtVRflrh/eHJCfiL6nrY1hDvz37ZMTjifnLvWYL6fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584242; c=relaxed/simple;
	bh=ru0hLlPTKua2QsgVUPYkZrA96apNwLoQ8mwJJAd1IjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CR3FcvlxTwXvz7haPjyqF/hLidMd6kADBqRqrAHhF9Uc/VSgRCyyBQjrwtPjGosnXB3PTk4l8s4Btxp876TZfIKlT/J+6uwUWU+g/tbVwVSbujyQ6fXkK7W75x+dLc+bnqkthl00c//Sx/Uqz2yP9/FpnhJRfRL1xh2cFpP5mhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG0g+CF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG0g+CF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93369C433F1;
	Mon,  8 Apr 2024 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584242;
	bh=ru0hLlPTKua2QsgVUPYkZrA96apNwLoQ8mwJJAd1IjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG0g+CF/pFPKP2d16+++W2cZgy7FSj73y5DWsG+XC14Ikqf+T9pTmpjjwyOBmqMMK
	 u1Cq9/cahPDYSCgIK98LPhHqUERn19TalKu4POuckAxLS/xLJ50hs1sYSPbAjZn7pk
	 AOm6RzJ5e0M+n/sEwTmuFGgH7Aqw//41x1dL0v/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 371/690] NFSD: Clean up unused code after rhashtable conversion
Date: Mon,  8 Apr 2024 14:53:57 +0200
Message-ID: <20240408125413.007301893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0ec8e9d1539a7b8109a554028bbce441052f847e ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 33 +--------------------------------
 fs/nfsd/filecache.h |  1 -
 2 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 45dd4f3fa0905..c6dc55c0f758b 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -21,11 +21,6 @@
 #include "filecache.h"
 #include "trace.h"
 
-#define NFSDDBG_FACILITY	NFSDDBG_FH
-
-/* FIXME: dynamically size this for the machine somehow? */
-#define NFSD_FILE_HASH_BITS                   12
-#define NFSD_FILE_HASH_SIZE                  (1 << NFSD_FILE_HASH_BITS)
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
 #define NFSD_FILE_CACHE_UP		     (0)
@@ -33,13 +28,6 @@
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
 
-struct nfsd_fcache_bucket {
-	struct hlist_head	nfb_head;
-	spinlock_t		nfb_lock;
-	unsigned int		nfb_count;
-	unsigned int		nfb_maxcount;
-};
-
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
@@ -57,7 +45,6 @@ static struct workqueue_struct *nfsd_filecache_wq __read_mostly;
 
 static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
-static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
 static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
@@ -302,7 +289,6 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 
 	nf = kmem_cache_alloc(nfsd_file_slab, GFP_KERNEL);
 	if (nf) {
-		INIT_HLIST_NODE(&nf->nf_node);
 		INIT_LIST_HEAD(&nf->nf_lru);
 		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
@@ -810,8 +796,7 @@ static const struct fsnotify_ops nfsd_file_fsnotify_ops = {
 int
 nfsd_file_cache_init(void)
 {
-	int		ret;
-	unsigned int	i;
+	int ret;
 
 	lockdep_assert_held(&nfsd_mutex);
 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
@@ -826,13 +811,6 @@ nfsd_file_cache_init(void)
 	if (!nfsd_filecache_wq)
 		goto out;
 
-	nfsd_file_hashtbl = kvcalloc(NFSD_FILE_HASH_SIZE,
-				sizeof(*nfsd_file_hashtbl), GFP_KERNEL);
-	if (!nfsd_file_hashtbl) {
-		pr_err("nfsd: unable to allocate nfsd_file_hashtbl\n");
-		goto out_err;
-	}
-
 	nfsd_file_slab = kmem_cache_create("nfsd_file",
 				sizeof(struct nfsd_file), 0, 0, NULL);
 	if (!nfsd_file_slab) {
@@ -876,11 +854,6 @@ nfsd_file_cache_init(void)
 		goto out_notifier;
 	}
 
-	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
-		INIT_HLIST_HEAD(&nfsd_file_hashtbl[i].nfb_head);
-		spin_lock_init(&nfsd_file_hashtbl[i].nfb_lock);
-	}
-
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
 	return ret;
@@ -895,8 +868,6 @@ nfsd_file_cache_init(void)
 	nfsd_file_slab = NULL;
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
@@ -1026,8 +997,6 @@ nfsd_file_cache_shutdown(void)
 	fsnotify_wait_marks_destroyed();
 	kmem_cache_destroy(nfsd_file_mark_slab);
 	nfsd_file_mark_slab = NULL;
-	kvfree(nfsd_file_hashtbl);
-	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
 	rhashtable_destroy(&nfsd_file_rhash_tbl);
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 5cbfc61a7d7d9..ee9ed99d8b8fa 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -30,7 +30,6 @@ struct nfsd_file_mark {
  */
 struct nfsd_file {
 	struct rhash_head	nf_rhash;
-	struct hlist_node	nf_node;
 	struct list_head	nf_lru;
 	struct rcu_head		nf_rcu;
 	struct file		*nf_file;
-- 
2.43.0



