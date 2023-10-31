Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F969208C6
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pzxyh9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBC8C433C7;
	Tue, 31 Oct 2023 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774377;
	bh=ezG9K89cdxBietHEYFVvvsb0V/jy3TYVlgsW8ZiOkYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pzxyh9fcqGvaQ+unrouLX1F8/TDCNCKqSvj2tlo6VsLR3NHoEoVxbJcbtS1QIwI7
	 QID9khKTpYD1XusnPyIETH8Gp/6g2k0C36KG7TYNtTaSC88IY3ZGnM5q2HKrv/ld5B
	 JTvuF6xmZ68lC+G6PnXPDoNILzuUQcL68B1IFL/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 007/112] smb: client: make laundromat a delayed worker
Date: Tue, 31 Oct 2023 18:00:08 +0100
Message-ID: <20231031165901.550890151@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit e95f3f74465072c2545d8e65a3c3a96e37129cf8 ]

By having laundromat kthread processing cached directories on every
second turned out to be overkill, especially when having multiple SMB
mounts.

Relax it by using a delayed worker instead that gets scheduled on
every @dir_cache_timeout (default=30) seconds per tcon.

This also fixes the 1s delay when tearing down tcon.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 89 +++++++++++++++-----------------------
 fs/smb/client/cached_dir.h |  2 +-
 2 files changed, 36 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index e2be8aedb26e3..a9e5d3b7e9a05 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -15,6 +15,7 @@
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
+static void cfids_laundromat_worker(struct work_struct *work);
 
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
@@ -572,53 +573,46 @@ static void free_cached_dir(struct cached_fid *cfid)
 	kfree(cfid);
 }
 
-static int
-cifs_cfids_laundromat_thread(void *p)
+static void cfids_laundromat_worker(struct work_struct *work)
 {
-	struct cached_fids *cfids = p;
+	struct cached_fids *cfids;
 	struct cached_fid *cfid, *q;
-	struct list_head entry;
+	LIST_HEAD(entry);
 
-	while (!kthread_should_stop()) {
-		ssleep(1);
-		INIT_LIST_HEAD(&entry);
-		if (kthread_should_stop())
-			return 0;
-		spin_lock(&cfids->cfid_list_lock);
-		list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-			if (time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
-				list_del(&cfid->entry);
-				list_add(&cfid->entry, &entry);
-				cfids->num_entries--;
-			}
+	cfids = container_of(work, struct cached_fids, laundromat_work.work);
+
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		if (time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
+			list_move(&cfid->entry, &entry);
+			cfids->num_entries--;
 		}
-		spin_unlock(&cfids->cfid_list_lock);
+	}
+	spin_unlock(&cfids->cfid_list_lock);
 
-		list_for_each_entry_safe(cfid, q, &entry, entry) {
-			cfid->on_list = false;
-			list_del(&cfid->entry);
+	list_for_each_entry_safe(cfid, q, &entry, entry) {
+		cfid->on_list = false;
+		list_del(&cfid->entry);
+		/*
+		 * Cancel and wait for the work to finish in case we are racing
+		 * with it.
+		 */
+		cancel_work_sync(&cfid->lease_break);
+		if (cfid->has_lease) {
 			/*
-			 * Cancel, and wait for the work to finish in
-			 * case we are racing with it.
+			 * Our lease has not yet been cancelled from the server
+			 * so we need to drop the reference.
 			 */
-			cancel_work_sync(&cfid->lease_break);
-			if (cfid->has_lease) {
-				/*
-				 * We lease has not yet been cancelled from
-				 * the server so we need to drop the reference.
-				 */
-				spin_lock(&cfids->cfid_list_lock);
-				cfid->has_lease = false;
-				spin_unlock(&cfids->cfid_list_lock);
-				kref_put(&cfid->refcount, smb2_close_cached_fid);
-			}
+			spin_lock(&cfids->cfid_list_lock);
+			cfid->has_lease = false;
+			spin_unlock(&cfids->cfid_list_lock);
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
 	}
-
-	return 0;
+	queue_delayed_work(cifsiod_wq, &cfids->laundromat_work,
+			   dir_cache_timeout * HZ);
 }
 
-
 struct cached_fids *init_cached_dirs(void)
 {
 	struct cached_fids *cfids;
@@ -629,19 +623,10 @@ struct cached_fids *init_cached_dirs(void)
 	spin_lock_init(&cfids->cfid_list_lock);
 	INIT_LIST_HEAD(&cfids->entries);
 
-	/*
-	 * since we're in a cifs function already, we know that
-	 * this will succeed. No need for try_module_get().
-	 */
-	__module_get(THIS_MODULE);
-	cfids->laundromat = kthread_run(cifs_cfids_laundromat_thread,
-				  cfids, "cifsd-cfid-laundromat");
-	if (IS_ERR(cfids->laundromat)) {
-		cifs_dbg(VFS, "Failed to start cfids laundromat thread.\n");
-		kfree(cfids);
-		module_put(THIS_MODULE);
-		return NULL;
-	}
+	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
+	queue_delayed_work(cifsiod_wq, &cfids->laundromat_work,
+			   dir_cache_timeout * HZ);
+
 	return cfids;
 }
 
@@ -657,11 +642,7 @@ void free_cached_dirs(struct cached_fids *cfids)
 	if (cfids == NULL)
 		return;
 
-	if (cfids->laundromat) {
-		kthread_stop(cfids->laundromat);
-		cfids->laundromat = NULL;
-		module_put(THIS_MODULE);
-	}
+	cancel_delayed_work_sync(&cfids->laundromat_work);
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index a82ff2cea789c..81ba0fd5cc16d 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -57,7 +57,7 @@ struct cached_fids {
 	spinlock_t cfid_list_lock;
 	int num_entries;
 	struct list_head entries;
-	struct task_struct *laundromat;
+	struct delayed_work laundromat_work;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
-- 
2.42.0



