Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5076A342;
	Mon,  8 Apr 2024 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584236; cv=none; b=q9CX3H3YRqzsAz6dlh+ypt80ZppSvze2vOyXJKYSW20ldV9htLkHDFipiixOQfG+oQ+Br2vCMWZZHlEd64xD2Z2vbg+388opmrY7ofypOKrqz6Hl9GnAGa3Lgy3KOIZJAnWAzaY6BLjMufZOcxzb1R+5wRzdTL6K0TZ1Wk/XhRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584236; c=relaxed/simple;
	bh=udZJTwFAMYec0q4F1DljPF+wXYwAA4lsQrejiMEGiXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7taQswAnyaPkMR9M+x0p5rtHRh9Rv59KLGVldCi68n0M5RrtOE4QSLt17GVOXUlKyIQpAhUIzodiHhL7jB+sZ4JaZMpV46FZWszfY1QT7LJK7lGjNqD9lQrc7swNxhQYhswAFm/FGydoJ8I6CSBqUA7kx76k0ATr4gCJnB58bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgDtmJLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgDtmJLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8980DC433F1;
	Mon,  8 Apr 2024 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584236;
	bh=udZJTwFAMYec0q4F1DljPF+wXYwAA4lsQrejiMEGiXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgDtmJLcO0nqEn46P30eqzmK3P36tvuDfx4rspsMe0kKruzmARMTZy/cQ0v7303Jl
	 XzQzXza589wcSQnEwppg6hX1fOKLPjpifybOTMOhytvAfaWuqUE0irZvQqNiyqynYa
	 gIJzMhACl4qPtAOxIzYeWT5BVCHDBXPxaU5XZ68c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 369/690] NFSD: Set up an rhashtable for the filecache
Date: Mon,  8 Apr 2024 14:53:55 +0200
Message-ID: <20240408125412.940285408@linuxfoundation.org>
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

[ Upstream commit fc22945ecc2a0a028f3683115f98a922d506c284 ]

Add code to initialize and tear down an rhashtable. The rhashtable
is not used yet.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 160 ++++++++++++++++++++++++++++++++++++++------
 fs/nfsd/filecache.h |   1 +
 2 files changed, 140 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 33bb4d31b4972..95e7e15b567e2 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -12,6 +12,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/rhashtable.h>
 
 #include "vfs.h"
 #include "nfsd.h"
@@ -62,6 +63,136 @@ static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
+static struct rhashtable		nfsd_file_rhash_tbl
+						____cacheline_aligned_in_smp;
+
+enum nfsd_file_lookup_type {
+	NFSD_FILE_KEY_INODE,
+	NFSD_FILE_KEY_FULL,
+};
+
+struct nfsd_file_lookup_key {
+	struct inode			*inode;
+	struct net			*net;
+	const struct cred		*cred;
+	unsigned char			need;
+	enum nfsd_file_lookup_type	type;
+};
+
+/*
+ * The returned hash value is based solely on the address of an in-code
+ * inode, a pointer to a slab-allocated object. The entropy in such a
+ * pointer is concentrated in its middle bits.
+ */
+static u32 nfsd_file_inode_hash(const struct inode *inode, u32 seed)
+{
+	unsigned long ptr = (unsigned long)inode;
+	u32 k;
+
+	k = ptr >> L1_CACHE_SHIFT;
+	k &= 0x00ffffff;
+	return jhash2(&k, 1, seed);
+}
+
+/**
+ * nfsd_file_key_hashfn - Compute the hash value of a lookup key
+ * @data: key on which to compute the hash value
+ * @len: rhash table's key_len parameter (unused)
+ * @seed: rhash table's random seed of the day
+ *
+ * Return value:
+ *   Computed 32-bit hash value
+ */
+static u32 nfsd_file_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct nfsd_file_lookup_key *key = data;
+
+	return nfsd_file_inode_hash(key->inode, seed);
+}
+
+/**
+ * nfsd_file_obj_hashfn - Compute the hash value of an nfsd_file
+ * @data: object on which to compute the hash value
+ * @len: rhash table's key_len parameter (unused)
+ * @seed: rhash table's random seed of the day
+ *
+ * Return value:
+ *   Computed 32-bit hash value
+ */
+static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct nfsd_file *nf = data;
+
+	return nfsd_file_inode_hash(nf->nf_inode, seed);
+}
+
+static bool
+nfsd_match_cred(const struct cred *c1, const struct cred *c2)
+{
+	int i;
+
+	if (!uid_eq(c1->fsuid, c2->fsuid))
+		return false;
+	if (!gid_eq(c1->fsgid, c2->fsgid))
+		return false;
+	if (c1->group_info == NULL || c2->group_info == NULL)
+		return c1->group_info == c2->group_info;
+	if (c1->group_info->ngroups != c2->group_info->ngroups)
+		return false;
+	for (i = 0; i < c1->group_info->ngroups; i++) {
+		if (!gid_eq(c1->group_info->gid[i], c2->group_info->gid[i]))
+			return false;
+	}
+	return true;
+}
+
+/**
+ * nfsd_file_obj_cmpfn - Match a cache item against search criteria
+ * @arg: search criteria
+ * @ptr: cache item to check
+ *
+ * Return values:
+ *   %0 - Item matches search criteria
+ *   %1 - Item does not match search criteria
+ */
+static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
+			       const void *ptr)
+{
+	const struct nfsd_file_lookup_key *key = arg->key;
+	const struct nfsd_file *nf = ptr;
+
+	switch (key->type) {
+	case NFSD_FILE_KEY_INODE:
+		if (nf->nf_inode != key->inode)
+			return 1;
+		break;
+	case NFSD_FILE_KEY_FULL:
+		if (nf->nf_inode != key->inode)
+			return 1;
+		if (nf->nf_may != key->need)
+			return 1;
+		if (nf->nf_net != key->net)
+			return 1;
+		if (!nfsd_match_cred(nf->nf_cred, key->cred))
+			return 1;
+		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0)
+			return 1;
+		break;
+	}
+	return 0;
+}
+
+static const struct rhashtable_params nfsd_file_rhash_params = {
+	.key_len		= sizeof_field(struct nfsd_file, nf_inode),
+	.key_offset		= offsetof(struct nfsd_file, nf_inode),
+	.head_offset		= offsetof(struct nfsd_file, nf_rhash),
+	.hashfn			= nfsd_file_key_hashfn,
+	.obj_hashfn		= nfsd_file_obj_hashfn,
+	.obj_cmpfn		= nfsd_file_obj_cmpfn,
+	/* Reduce resizing churn on light workloads */
+	.min_size		= 512,		/* buckets */
+	.automatic_shrinking	= true,
+};
 
 static void
 nfsd_file_schedule_laundrette(void)
@@ -693,13 +824,18 @@ static const struct fsnotify_ops nfsd_file_fsnotify_ops = {
 int
 nfsd_file_cache_init(void)
 {
-	int		ret = -ENOMEM;
+	int		ret;
 	unsigned int	i;
 
 	lockdep_assert_held(&nfsd_mutex);
 	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
 		return 0;
 
+	ret = rhashtable_init(&nfsd_file_rhash_tbl, &nfsd_file_rhash_params);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
 	if (!nfsd_filecache_wq)
 		goto out;
@@ -777,6 +913,7 @@ nfsd_file_cache_init(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+	rhashtable_destroy(&nfsd_file_rhash_tbl);
 	goto out;
 }
 
@@ -902,6 +1039,7 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+	rhashtable_destroy(&nfsd_file_rhash_tbl);
 
 	for_each_possible_cpu(i) {
 		per_cpu(nfsd_file_cache_hits, i) = 0;
@@ -913,26 +1051,6 @@ nfsd_file_cache_shutdown(void)
 	}
 }
 
-static bool
-nfsd_match_cred(const struct cred *c1, const struct cred *c2)
-{
-	int i;
-
-	if (!uid_eq(c1->fsuid, c2->fsuid))
-		return false;
-	if (!gid_eq(c1->fsgid, c2->fsgid))
-		return false;
-	if (c1->group_info == NULL || c2->group_info == NULL)
-		return c1->group_info == c2->group_info;
-	if (c1->group_info->ngroups != c2->group_info->ngroups)
-		return false;
-	for (i = 0; i < c1->group_info->ngroups; i++) {
-		if (!gid_eq(c1->group_info->gid[i], c2->group_info->gid[i]))
-			return false;
-	}
-	return true;
-}
-
 static struct nfsd_file *
 nfsd_file_find_locked(struct inode *inode, unsigned int may_flags,
 			unsigned int hashval, struct net *net)
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 82051e1b8420d..5cbfc61a7d7d9 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -29,6 +29,7 @@ struct nfsd_file_mark {
  * never be dereferenced, only used for comparison.
  */
 struct nfsd_file {
+	struct rhash_head	nf_rhash;
 	struct hlist_node	nf_node;
 	struct list_head	nf_lru;
 	struct rcu_head		nf_rcu;
-- 
2.43.0



