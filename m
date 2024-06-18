Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D5513C695;
	Tue, 18 Jun 2024 13:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716237; cv=none; b=rFA0w52ikH8ctK2C+jD/XAsPaq53fkAy9uCI1vBBeKQjqE+yob9GYRVhcbmEHmJNrUOgZcumRdgTbI5sKtSk1xa8xxzSqQwLS5MwTla+lBrQIC//xWwWHPh4LecizWslL08vt0NfqVxSArcTddm6R+z1kogIcFzpWqQWbevL+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716237; c=relaxed/simple;
	bh=yosmbGXOsgaV598L+/hkpusFZoi98QezThHjabbMjZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7f3sreBLMG+GYxmmV/W3wQzoaV91wDPoQ1GU+oLQFeOX5BMUZJ6hBm+Pi8A/pMtQex/pyZbfwA8iqzBaO0CYCvHu7Vk6zYypbGsuTNlHmonaMjE+/dnZXyWaoiyCyf5r0otYnJfXjDkD+cHxJwf9OoeoZLkiS2YXDkczVBpQ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEeumz4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEeumz4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5668CC3277B;
	Tue, 18 Jun 2024 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716236;
	bh=yosmbGXOsgaV598L+/hkpusFZoi98QezThHjabbMjZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEeumz4WTX9IYnwWNybtz8G/EQXVZCsEkJKY1DrD6x+76UYvVMubEIKYF4Ga3Xypj
	 vYIO5zECfmVp6BcWWBnZQKyaZRkji51Z9lbMs4uf5no/XMQkxgOPf/LeQBX/BSbleM
	 +Bq5Zy1Ouw0T6fhXAT23rT3lw3qg5HZe5i3O69LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 577/770] NFSD: Replace the "init once" mechanism
Date: Tue, 18 Jun 2024 14:37:10 +0200
Message-ID: <20240618123429.567313975@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c7b824c3d06c85e054caf86e227255112c5e3c38 ]

In a moment, the nfsd_file_hashtbl global will be replaced with an
rhashtable. Replace the one or two spots that need to check if the
hash table is available. We can easily reuse the SHUTDOWN flag for
this purpose.

Document that this mechanism relies on callers to hold the
nfsd_mutex to prevent init, shutdown, and purging to run
concurrently.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 29b1f57692a60..33bb4d31b4972 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -27,7 +27,7 @@
 #define NFSD_FILE_HASH_SIZE                  (1 << NFSD_FILE_HASH_BITS)
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
-#define NFSD_FILE_SHUTDOWN		     (1)
+#define NFSD_FILE_CACHE_UP		     (0)
 
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
@@ -58,7 +58,7 @@ static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
 static struct nfsd_fcache_bucket	*nfsd_file_hashtbl;
 static struct list_lru			nfsd_file_lru;
-static long				nfsd_file_lru_flags;
+static unsigned long			nfsd_file_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
@@ -66,9 +66,8 @@ static struct delayed_work		nfsd_filecache_laundrette;
 static void
 nfsd_file_schedule_laundrette(void)
 {
-	long count = atomic_long_read(&nfsd_filecache_count);
-
-	if (count == 0 || test_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags))
+	if ((atomic_long_read(&nfsd_filecache_count) == 0) ||
+	    test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
 		return;
 
 	queue_delayed_work(system_wq, &nfsd_filecache_laundrette,
@@ -697,9 +696,8 @@ nfsd_file_cache_init(void)
 	int		ret = -ENOMEM;
 	unsigned int	i;
 
-	clear_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
-
-	if (nfsd_file_hashtbl)
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_set_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
 		return 0;
 
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -785,8 +783,8 @@ nfsd_file_cache_init(void)
 /*
  * Note this can deadlock with nfsd_file_lru_cb.
  */
-void
-nfsd_file_cache_purge(struct net *net)
+static void
+__nfsd_file_cache_purge(struct net *net)
 {
 	unsigned int		i;
 	struct nfsd_file	*nf;
@@ -794,9 +792,6 @@ nfsd_file_cache_purge(struct net *net)
 	LIST_HEAD(dispose);
 	bool del;
 
-	if (!nfsd_file_hashtbl)
-		return;
-
 	for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
 		struct nfsd_fcache_bucket *nfb = &nfsd_file_hashtbl[i];
 
@@ -857,6 +852,19 @@ nfsd_file_cache_start_net(struct net *net)
 	return nn->fcache_disposal ? 0 : -ENOMEM;
 }
 
+/**
+ * nfsd_file_cache_purge - Remove all cache items associated with @net
+ * @net: target net namespace
+ *
+ */
+void
+nfsd_file_cache_purge(struct net *net)
+{
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1)
+		__nfsd_file_cache_purge(net);
+}
+
 void
 nfsd_file_cache_shutdown_net(struct net *net)
 {
@@ -869,7 +877,9 @@ nfsd_file_cache_shutdown(void)
 {
 	int i;
 
-	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
+	lockdep_assert_held(&nfsd_mutex);
+	if (test_and_clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
+		return;
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
 	unregister_shrinker(&nfsd_file_shrinker);
@@ -878,7 +888,7 @@ nfsd_file_cache_shutdown(void)
 	 * calling nfsd_file_cache_purge
 	 */
 	cancel_delayed_work_sync(&nfsd_filecache_laundrette);
-	nfsd_file_cache_purge(NULL);
+	__nfsd_file_cache_purge(NULL);
 	list_lru_destroy(&nfsd_file_lru);
 	rcu_barrier();
 	fsnotify_put_group(nfsd_file_fsnotify_group);
@@ -1142,7 +1152,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	 * don't end up racing with server shutdown
 	 */
 	mutex_lock(&nfsd_mutex);
-	if (nfsd_file_hashtbl) {
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 1) {
 		for (i = 0; i < NFSD_FILE_HASH_SIZE; i++) {
 			count += nfsd_file_hashtbl[i].nfb_count;
 			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
-- 
2.43.0



