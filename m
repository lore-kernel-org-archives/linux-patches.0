Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86634328B7B;
	Thu, 28 May 2026 20:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001118; cv=none; b=qs8b0fGMiu3aoiW5aDy03GymH5kpCrPNM3VRFBJSX0YfD/i1LUrbfd+BVM1RtG1oPoAPj5PSNs/Ptjxu9599D+PEViNBmz29iviiSnkGEN4F/QsoB3Y8EykQWH+y6jzA5gYxlotuMvle5Xsaex5xDa+Gm7B30PcZHJ7RNVJrL+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001118; c=relaxed/simple;
	bh=AtSGbTj1L1t6R93qZtxfRm5FYRc98xmTn01iIDIG6Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBxqBCj6D8kueqGMOdCR8FbD50/LUcYxNLJToJvyNuyx8HQRit3AB0M5zLpMNE8kl9bQsq7edWu2g8bVnWUhQLFrKa9JG3JLIwC3rcTJxBJXizCQbiMD7rViv/PYV3PhhlSnID4oaH3bZka1A2imyMy5eUpmqgMnlHMZVM+YYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEKQXbVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEKQXbVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50361F000E9;
	Thu, 28 May 2026 20:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001117;
	bh=+N3Dimkg5O2YqNpcmgBJGxsSZNx4KnfNWGBjCkjdFBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEKQXbVPLj53jVgemsD71Ej8yxD/pCCeNA8QNZFv91oAEU/JF1MtOItFrSYC+FMqm
	 7OFX5Grsr95b41eGjvShyaMHkk19xomFzjcjcCe9Twuc0/+hU+P4o9qZHmpOVGbBUU
	 W0jI0UNd6l4HbE7NuAtR9sRjKbp0pQs44ElcgK+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/186] ksmbd: close durable scavenger races against m_fp_list lookups
Date: Thu, 28 May 2026 21:48:14 +0200
Message-ID: <20260528194929.339752676@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit bf736184d063da1a552ffeff0481813599a182cc ]

ksmbd_durable_scavenger() has two related races against any walker
that iterates f_ci->m_fp_list, including ksmbd_lookup_fd_inode()
(used by ksmbd_vfs_rename) and the share-mode checks in
fs/smb/server/smb_common.c.

(1) fp->node list-head reuse.  Durable-preserved handles can remain
linked on f_ci->m_fp_list after session teardown so share-mode checks
still see them while the handle is reconnectable.  The scavenger
collected expired handles by adding fp->node to a local
scavenger_list after removing them from the global durable idr.
Because fp->node is the same list_head used by m_fp_list,
list_add(&fp->node, &scavenger_list) overwrites the m_fp_list links
and corrupts both lists.  CONFIG_DEBUG_LIST can report this on the
share-mode walk path.

(2) Refcount race against m_fp_list walkers.  The scavenger qualifies
an expired durable handle with atomic_read(&fp->refcount) > 1 and
fp->conn under global_ft.lock, removes fp from global_ft, then drops
global_ft.lock before unlinking fp from m_fp_list and freeing it.
During that gap fp is still linked on m_fp_list with f_state ==
FP_INITED.  ksmbd_lookup_fd_inode() under m_lock read calls
ksmbd_fp_get() (atomic_inc_not_zero on refcount that is still 1) and
takes a live reference; the scavenger then unlinks and frees fp
while the holder owns a reference, leading to UAF on the holder's
subsequent ksmbd_fd_put() and on any field reads performed by a
concurrent share-mode walker that iterates m_fp_list without taking
ksmbd_fp_get() (smb_check_perm_dleases-like paths).

Fix both:

  * Stop reusing fp->node as a scavenger-private list node.  Remove
    one expired handle from global_ft under global_ft.lock, take an
    explicit transient reference, drop the lock, unlink fp->node
    from m_fp_list under f_ci->m_lock, then drop both the durable
    lifetime and transient references with atomic_sub_and_test(2,
    &fp->refcount).  If the scavenger is the last putter the close
    runs there; otherwise an in-flight holder that already raced
    through the m_fp_list lookup owns the final close via its
    ksmbd_fd_put() path.  The one-at-a-time disposal can rescan the
    durable idr when multiple handles expire in the same pass, but
    durable scavenging is a background expiration path and the final
    full scan recomputes min_timeout before the next wait.

  * Clear fp->persistent_id inside __ksmbd_remove_durable_fd() right
    after idr_remove(), so a delayed final close from a holder that
    snatched fp does not re-issue idr_remove() on a persistent id
    that idr_alloc_cyclic() in ksmbd_open_durable_fd() may have
    already handed out to a brand-new durable handle.

  * Bypass the per-conn open_files_count decrement in
    __put_fd_final() when fp is detached from any session table
    (fp->conn cleared by session_fd_check() at durable preserve --
    paired with the volatile_id clear at unpublish, so checking
    fp->conn alone is sufficient).  The walker that owns the final
    close runs from an unrelated work->conn whose
    stats.open_files_count never tracked this durable fp; without
    this guard the holder would underflow that unrelated counter.

The two races are folded into one patch because patch (1) alone
cleans up the corrupted list but leaves a deterministic UAF window
for m_fp_list walkers that the transient-reference and
persistent_id discipline in (2) close; bisecting onto an
intermediate state would land on a UAF that pre-patch chaos merely
made less reproducible.

Validation:
  * CONFIG_DEBUG_LIST coverage for the list_head reuse path.
  * KASAN-enabled direct SMB2 durable-handle coverage that exercised
    ksmbd_durable_scavenger() and non-NULL ksmbd_lookup_fd_inode()
    returns while durable handles expired under concurrent rename
    lookups, with no KASAN, UAF, list-corruption, ODEBUG, or WARNING
    reports.
  * checkpatch --strict
  * make -j$(nproc) M=fs/smb/server

Fixes: d484d621d40f ("ksmbd: add durable scavenger timer")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 104 ++++++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 544387c9a6f4b..8faa5d97f7e1e 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -325,6 +325,14 @@ static void __ksmbd_remove_durable_fd(struct ksmbd_file *fp)
 		return;
 
 	idr_remove(global_ft.idr, fp->persistent_id);
+	/*
+	 * Clear persistent_id so a later __ksmbd_close_fd() that runs from a
+	 * delayed putter (e.g. when a concurrent ksmbd_lookup_fd_inode()
+	 * walker held the final reference) does not re-issue idr_remove() on
+	 * an id that idr_alloc_cyclic() may have already handed out to a new
+	 * durable handle.
+	 */
+	fp->persistent_id = KSMBD_NO_FID;
 }
 
 static void ksmbd_remove_durable_fd(struct ksmbd_file *fp)
@@ -417,6 +425,20 @@ static struct ksmbd_file *__ksmbd_lookup_fd(struct ksmbd_file_table *ft,
 
 static void __put_fd_final(struct ksmbd_work *work, struct ksmbd_file *fp)
 {
+	/*
+	 * Detached durable fp -- session_fd_check() cleared fp->conn at
+	 * preserve, so this fp is no longer tracked by any conn's
+	 * stats.open_files_count.  This happens when
+	 * ksmbd_scavenger_dispose_dh() hands the final close off to an
+	 * m_fp_list walker (e.g. ksmbd_lookup_fd_inode()) whose work->conn
+	 * is unrelated to the conn that originally opened the handle; close
+	 * via the NULL-ft path so we do not underflow that unrelated
+	 * counter.
+	 */
+	if (!fp->conn) {
+		__ksmbd_close_fd(NULL, fp);
+		return;
+	}
 	__ksmbd_close_fd(&work->sess->file_table, fp);
 	atomic_dec(&work->conn->stats.open_files_count);
 }
@@ -792,24 +814,37 @@ static bool ksmbd_durable_scavenger_alive(void)
 	return true;
 }
 
-static void ksmbd_scavenger_dispose_dh(struct list_head *head)
+static void ksmbd_scavenger_dispose_dh(struct ksmbd_file *fp)
 {
-	while (!list_empty(head)) {
-		struct ksmbd_file *fp;
+	/*
+	 * Durable-preserved fp can remain linked on f_ci->m_fp_list for
+	 * share-mode checks.  Unlink it before final close; fp->node is not
+	 * available as a scavenger-private list node because re-adding it to
+	 * another list corrupts m_fp_list.
+	 */
+	down_write(&fp->f_ci->m_lock);
+	list_del_init(&fp->node);
+	up_write(&fp->f_ci->m_lock);
 
-		fp = list_first_entry(head, struct ksmbd_file, node);
-		list_del_init(&fp->node);
+	/*
+	 * Drop both the durable lifetime reference and the transient reference
+	 * taken by the scavenger under global_ft.lock.  If a concurrent
+	 * ksmbd_lookup_fd_inode() (or any other m_fp_list walker) snatched fp
+	 * before the unlink above, that holder owns the final close via
+	 * ksmbd_fd_put() -> __ksmbd_close_fd().  Otherwise the scavenger is
+	 * the last putter and finalises fp here.
+	 */
+	if (atomic_sub_and_test(2, &fp->refcount))
 		__ksmbd_close_fd(NULL, fp);
-	}
 }
 
 static int ksmbd_durable_scavenger(void *dummy)
 {
 	struct ksmbd_file *fp = NULL;
+	struct ksmbd_file *expired_fp;
 	unsigned int id;
 	unsigned int min_timeout = 1;
 	bool found_fp_timeout;
-	LIST_HEAD(scavenger_list);
 	unsigned long remaining_jiffies;
 
 	__module_get(THIS_MODULE);
@@ -819,8 +854,6 @@ static int ksmbd_durable_scavenger(void *dummy)
 		if (try_to_freeze())
 			continue;
 
-		found_fp_timeout = false;
-
 		remaining_jiffies = wait_event_timeout(dh_wq,
 				   ksmbd_durable_scavenger_alive() == false,
 				   __msecs_to_jiffies(min_timeout));
@@ -829,23 +862,39 @@ static int ksmbd_durable_scavenger(void *dummy)
 		else
 			min_timeout = DURABLE_HANDLE_MAX_TIMEOUT;
 
-		write_lock(&global_ft.lock);
-		idr_for_each_entry(global_ft.idr, fp, id) {
-			if (!fp->durable_timeout)
-				continue;
-
-			if (atomic_read(&fp->refcount) > 1 ||
-			    fp->conn)
-				continue;
-
-			found_fp_timeout = true;
-			if (fp->durable_scavenger_timeout <=
-			    jiffies_to_msecs(jiffies)) {
-				__ksmbd_remove_durable_fd(fp);
-				list_add(&fp->node, &scavenger_list);
-			} else {
+		do {
+			expired_fp = NULL;
+			found_fp_timeout = false;
+
+			write_lock(&global_ft.lock);
+			idr_for_each_entry(global_ft.idr, fp, id) {
 				unsigned long durable_timeout;
 
+				if (!fp->durable_timeout)
+					continue;
+
+				if (atomic_read(&fp->refcount) > 1 ||
+				    fp->conn)
+					continue;
+
+				found_fp_timeout = true;
+				if (fp->durable_scavenger_timeout <=
+				    jiffies_to_msecs(jiffies)) {
+					__ksmbd_remove_durable_fd(fp);
+					/*
+					 * Take a transient reference so fp
+					 * cannot be freed by an in-flight
+					 * ksmbd_lookup_fd_inode() that found
+					 * it through f_ci->m_fp_list while we
+					 * drop global_ft.lock and reach the
+					 * m_fp_list unlink in
+					 * ksmbd_scavenger_dispose_dh().
+					 */
+					atomic_inc(&fp->refcount);
+					expired_fp = fp;
+					break;
+				}
+
 				durable_timeout =
 					fp->durable_scavenger_timeout -
 						jiffies_to_msecs(jiffies);
@@ -853,10 +902,11 @@ static int ksmbd_durable_scavenger(void *dummy)
 				if (min_timeout > durable_timeout)
 					min_timeout = durable_timeout;
 			}
-		}
-		write_unlock(&global_ft.lock);
+			write_unlock(&global_ft.lock);
 
-		ksmbd_scavenger_dispose_dh(&scavenger_list);
+			if (expired_fp)
+				ksmbd_scavenger_dispose_dh(expired_fp);
+		} while (expired_fp);
 
 		if (found_fp_timeout == false)
 			break;
-- 
2.53.0



