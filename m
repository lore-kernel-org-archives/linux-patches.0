Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213765;
	b=ZQHHzk5oRCYY70RtyaNpmGwaN6vdUeNVRUtjWIQtv0QFFSaViBGUwPEwANfcMy8YoCoy
	 1n/Rrhac0WSjDijBUC6FFPegRUGBU3BylvACFduAJHrboHhZsY1fJbHvUws4xejPiog/Y
	 zriw8xgg1C1K3ua7Tg+9fY4LnVrckMSINigsfnneSCgbD1mzCTlxGxPXXQS1kQ2FK7QsI
	 u0FZxzmxH3y27qNSVs0ahK0ULHbDv5vQjEf6TAGVslRFDm7lYfiblxNdhD56IcOGtPXxw
	 dlBfdUznrxFYL07lUHCseiseQT66CXKDQj2rcc/jmS/ZMliM9KV7vR8jJXgfwgX5qaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HgmcWvu0pXOMhWOZRrXjIKjzXKWSS7CCgtKhn1rQR0k=;
	b=2ZkGJfdGQxUg1wQ46JxFBN42RT8gSySCLKwR1rYJu6foOwObE1MSpySfXpRyroKSweFz
	 VKjmcQxfobdSFl9cQQkSbywJmELCAuPoW3gotFDuaZukDSG4CIsTJp1z6dltR3PqBJE/E
	 LmPFy9HZL8E7iOS1PyFviNzUYAlNl2TzteFmQQghhWbEVTnZtaI0rcHBQyzgNOoiNvtgB
	 aJtHQymc7M7kn/ft0mIvzx8r+7ikP/8mNC2yfkPNvUzJKSHxVIOVyF8tnKh0LQLOJEJQc
	 o1qABfNrA5DO5ZX0adq4Eyv/WFcY6Yfh4YRD9V/mp6yYXsDPyntKhTzQ8w2bPDets/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+ILHK+l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE8C606A31A;
	Wed, 28 Oct 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+ILHK+l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B21F01825;
	Wed, 28 Oct 2026 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213764;
	bh=HgmcWvu0pXOMhWOZRrXjIKjzXKWSS7CCgtKhn1rQR0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+ILHK+l0/nNuvgj/iJIgWTrRL8UKy9NKj68xSzwB3xDdCBGqnmAh460C+9WTXUSy
	 ldX/FueQay0IFXxCWRiqZ6UPtMFjj9PlW6WRcksjYa58s2Z27kleBIk5vobEBsTDUZ
	 u/2pn/fMgYobxvjpVAFImgZcf9ZlaVukZdGNR0mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0619/1887] gfs2: Fix potential glock use-after-free on unmount
Date: Wed, 28 Oct 2026 17:45:15 +0100
Message-ID: <20261028170513.497649269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d98779e687726d8f8860f1c54b5687eec5f63a73 ]

When a DLM lockspace is released and there ares still locks in that
lockspace, DLM will unlock those locks automatically.  Commit
fb6791d100d1b started exploiting this behavior to speed up filesystem
unmount: gfs2 would simply free glocks it didn't want to unlock and then
release the lockspace.  This didn't take the bast callbacks for
asynchronous lock contention notifications into account, which remain
active until until a lock is unlocked or its lockspace is released.

To prevent those callbacks from accessing deallocated objects, put the
glocks that should not be unlocked on the sd_dead_glocks list, release
the lockspace, and only then free those glocks.

As an additional measure, ignore unexpected ast and bast callbacks if
the receiving glock is dead.

Fixes: fb6791d100d1b ("GFS2: skip dlm_unlock calls in unmount")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      | 35 ++++++++++++++++++++++++++++++++---
 fs/gfs2/glock.h      |  1 +
 fs/gfs2/incore.h     |  1 +
 fs/gfs2/lock_dlm.c   | 12 +++++++++++-
 fs/gfs2/ops_fstype.c |  1 +
 fs/gfs2/super.c      |  3 ---
 6 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 428c1db295fa1..d0ec9487e8820 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -167,19 +167,46 @@ static bool glock_blocked_by_withdraw(struct gfs2_glock *gl)
 	return true;
 }
 
-void gfs2_glock_free(struct gfs2_glock *gl)
+static void __gfs2_glock_free(struct gfs2_glock *gl)
 {
-	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
-
 	gfs2_glock_assert_withdraw(gl, atomic_read(&gl->gl_revokes) == 0);
 	rhashtable_remove_fast(&gl_hash_table, &gl->gl_node, ht_parms);
 	smp_mb();
 	wake_up_glock(gl);
 	call_rcu(&gl->gl_rcu, gfs2_glock_dealloc);
+}
+
+void gfs2_glock_free(struct gfs2_glock *gl) {
+	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
+
+	__gfs2_glock_free(gl);
 	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
 		wake_up(&sdp->sd_glock_wait);
 }
 
+void gfs2_glock_free_later(struct gfs2_glock *gl) {
+	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
+
+	spin_lock(&lru_lock);
+	list_add(&gl->gl_lru, &sdp->sd_dead_glocks);
+	spin_unlock(&lru_lock);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
+}
+
+static void gfs2_free_dead_glocks(struct gfs2_sbd *sdp)
+{
+	struct list_head *list = &sdp->sd_dead_glocks;
+
+	while(!list_empty(list)) {
+		struct gfs2_glock *gl;
+
+		gl = list_first_entry(list, struct gfs2_glock, gl_lru);
+		list_del_init(&gl->gl_lru);
+		__gfs2_glock_free(gl);
+	}
+}
+
 /**
  * gfs2_glock_hold() - increment reference count on glock
  * @gl: The glock to hold
@@ -2263,6 +2290,8 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 	wait_event_timeout(sdp->sd_glock_wait,
 			   atomic_read(&sdp->sd_glock_disposal) == 0,
 			   HZ * 600);
+	gfs2_lm_unmount(sdp);
+	gfs2_free_dead_glocks(sdp);
 	glock_hash_walk(dump_glock_func, sdp);
 }
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index f6dd94ce74998..ca1669cf9299e 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -270,6 +270,7 @@ extern void gfs2_gl_dq_holders(struct gfs2_sbd *sdp);
 extern void gfs2_glock_thaw(struct gfs2_sbd *sdp);
 extern void gfs2_glock_add_to_lru(struct gfs2_glock *gl);
 extern void gfs2_glock_free(struct gfs2_glock *gl);
+extern void gfs2_glock_free_later(struct gfs2_glock *gl);
 
 extern int __init gfs2_glock_init(void);
 extern void gfs2_glock_exit(void);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 113aeb5877027..7a630de1c1a0b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -837,6 +837,7 @@ struct gfs2_sbd {
 	struct gfs2_holder sd_freeze_gh;
 	atomic_t sd_freeze_state;
 	struct mutex sd_freeze_mutex;
+	struct list_head sd_dead_glocks;
 
 	char sd_fsname[GFS2_FSNAME_LEN + 3 * sizeof(int) + 2];
 	char sd_table_name[GFS2_FSNAME_LEN];
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 4f44173e8a361..001555ccceebc 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -121,6 +121,11 @@ static void gdlm_ast(void *arg)
 	struct gfs2_glock *gl = arg;
 	unsigned ret = gl->gl_state;
 
+	/* If the glock is dead, we only react to a dlm_unlock() reply. */
+	if (__lockref_is_dead(&gl->gl_lockref) &&
+	    gl->gl_lksb.sb_status != -DLM_EUNLOCK)
+		return;
+
 	gfs2_update_reply_times(gl);
 	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
 
@@ -171,6 +176,9 @@ static void gdlm_bast(void *arg, int mode)
 {
 	struct gfs2_glock *gl = arg;
 
+	if (__lockref_is_dead(&gl->gl_lockref))
+		return;
+
 	switch (mode) {
 	case DLM_LOCK_EX:
 		gfs2_glock_cb(gl, LM_ST_UNLOCKED);
@@ -291,6 +299,8 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
+	BUG_ON(!__lockref_is_dead(&gl->gl_lockref));
+
 	if (gl->gl_lksb.sb_lkid == 0) {
 		gfs2_glock_free(gl);
 		return;
@@ -305,7 +315,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
 	    !gl->gl_lksb.sb_lvbptr) {
-		gfs2_glock_free(gl);
+		gfs2_glock_free_later(gl);
 		return;
 	}
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 26a70b9676d53..ec019e38cf7fa 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -137,6 +137,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	init_waitqueue_head(&sdp->sd_log_flush_wait);
 	atomic_set(&sdp->sd_freeze_state, SFS_UNFROZEN);
 	mutex_init(&sdp->sd_freeze_mutex);
+	INIT_LIST_HEAD(&sdp->sd_dead_glocks);
 
 	return sdp;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 14b3f66938ea8..4b56a163669ca 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -641,10 +641,7 @@ static void gfs2_put_super(struct super_block *sb)
 	gfs2_gl_hash_clear(sdp);
 	truncate_inode_pages_final(&sdp->sd_aspace);
 	gfs2_delete_debugfs_file(sdp);
-	/*  Unmount the locking protocol  */
-	gfs2_lm_unmount(sdp);
 
-	/*  At this point, we're through participating in the lockspace  */
 	gfs2_sys_fs_del(sdp);
 	free_sbd(sdp);
 }
-- 
2.53.0



