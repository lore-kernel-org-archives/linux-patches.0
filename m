Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAAF30F7ED;
	Mon, 13 Oct 2025 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368866; cv=none; b=IccmKE3ibzV+b1iNI1RnMvpY+gy8RXuZbAdV9nG9e9JeQNqfqZgtcozxW2ip/JZu8I/ChOSPndqlpbROTnAjEPuhT6U/ueD6PiPv28PL6fRVf2sg712oExqhKIFxZWbWGDiW6nOLGY/bcp1JaJOXsBs+6A4mTo3BkpqqDsuQUUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368866; c=relaxed/simple;
	bh=zNBag5aX+0AAyAez4VoEUL5J6b8fZqwwdIuOWGYMEPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBINlWldJShGh3Cd7/tk+S1in+dq3JdSs+KlwdBnEs1/am5WelF5au/hS7WmAMKgUzAh354lElUhOcAqwRkdGm5jYaMDvZGx4NFR9XEn9XskK7nT1t8tE1aR/i4tQTr/4qCIffnUYwNXeCt9bfQiaBoiT1uwGk6RAjwLrUo+niE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g13aPm8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g13aPm8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54885C4CEE7;
	Mon, 13 Oct 2025 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368866;
	bh=zNBag5aX+0AAyAez4VoEUL5J6b8fZqwwdIuOWGYMEPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g13aPm8L259VjQ7PXk9Hsf7Q2Kcnh+VV9a32+WCxk9jU0UXexhCiTTzzuV2Z2ttZ2
	 GDzxbYsRI7VjGtRzFJL3KfxrTJu+VQY1ydXCJXxkCottHedtUonP6kAkFqEgqwCh4e
	 kydYe9AqOJiOCbKZ5aLZ347izfhhv2EwPRbQ5+xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 019/563] gfs2: Add proper lockspace locking
Date: Mon, 13 Oct 2025 16:38:00 +0200
Message-ID: <20251013144411.986387117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 6ab26555c9ffef96c56ca16356e55ac5ab61ec93 ]

GFS2 has been calling functions like dlm_lock() even after the lockspace
that these functions operate on has been released with
dlm_release_lockspace().  It has always assumed that those functions
would return -EINVAL in that case, but that was never guaranteed, and it
certainly is no longer the case since commit 4db41bf4f04f ("dlm: remove
ls_local_handle from struct dlm_ls").

To fix that, add proper lockspace locking.

Fixes: 3e11e5304150 ("GFS2: ignore unlock failures after withdraw")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c     | 23 +++++++++++++++--------
 fs/gfs2/glock.c    |  5 ++---
 fs/gfs2/incore.h   |  2 ++
 fs/gfs2/lock_dlm.c | 46 +++++++++++++++++++++++++++++++++++++---------
 4 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 72d95185a39f6..bc67fa058c845 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1442,6 +1442,7 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	int ret;
 
 	if (!(fl->c.flc_flags & FL_POSIX))
 		return -ENOLCK;
@@ -1450,14 +1451,20 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 			locks_lock_file_wait(file, fl);
 		return -EIO;
 	}
-	if (cmd == F_CANCELLK)
-		return dlm_posix_cancel(ls->ls_dlm, ip->i_no_addr, file, fl);
-	else if (IS_GETLK(cmd))
-		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
-	else if (lock_is_unlock(fl))
-		return dlm_posix_unlock(ls->ls_dlm, ip->i_no_addr, file, fl);
-	else
-		return dlm_posix_lock(ls->ls_dlm, ip->i_no_addr, file, cmd, fl);
+	down_read(&ls->ls_sem);
+	ret = -ENODEV;
+	if (likely(ls->ls_dlm != NULL)) {
+		if (cmd == F_CANCELLK)
+			ret = dlm_posix_cancel(ls->ls_dlm, ip->i_no_addr, file, fl);
+		else if (IS_GETLK(cmd))
+			ret = dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
+		else if (lock_is_unlock(fl))
+			ret = dlm_posix_unlock(ls->ls_dlm, ip->i_no_addr, file, fl);
+		else
+			ret = dlm_posix_lock(ls->ls_dlm, ip->i_no_addr, file, cmd, fl);
+	}
+	up_read(&ls->ls_sem);
+	return ret;
 }
 
 static void __flock_holder_uninit(struct file *file, struct gfs2_holder *fl_gh)
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 54c011ff00ddc..a6535413a0b46 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -800,9 +800,8 @@ __acquires(&gl->gl_lockref.lock)
 		}
 		clear_bit(GLF_PENDING_REPLY, &gl->gl_flags);
 
-		if (ret == -EINVAL && gl->gl_target == LM_ST_UNLOCKED &&
-		    target == LM_ST_UNLOCKED &&
-		    test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
+		if (ret == -ENODEV && gl->gl_target == LM_ST_UNLOCKED &&
+		    target == LM_ST_UNLOCKED) {
 			/*
 			 * The lockspace has been released and the lock has
 			 * been unlocked implicitly.
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c390f208654c1..3fcb7ab198d47 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -657,6 +657,8 @@ struct lm_lockstruct {
 	struct completion ls_sync_wait; /* {control,mounted}_{lock,unlock} */
 	char *ls_lvb_bits;
 
+	struct rw_semaphore ls_sem;
+
 	spinlock_t ls_recover_spin; /* protects following fields */
 	unsigned long ls_recover_flags; /* DFL_ */
 	uint32_t ls_recover_mount; /* gen in first recover_done cb */
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 5daaeaaaf18dd..6db37c20587d1 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -329,8 +329,13 @@ static int gdlm_lock(struct gfs2_glock *gl, unsigned int req_state,
 	 */
 
 again:
-	error = dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, strname,
-			GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
+	down_read(&ls->ls_sem);
+	error = -ENODEV;
+	if (likely(ls->ls_dlm != NULL)) {
+		error = dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, strname,
+				GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
+	}
+	up_read(&ls->ls_sem);
 	if (error == -EBUSY) {
 		msleep(20);
 		goto again;
@@ -379,8 +384,13 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 		flags |= DLM_LKF_VALBLK;
 
 again:
-	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, flags,
-			   NULL, gl);
+	down_read(&ls->ls_sem);
+	error = -ENODEV;
+	if (likely(ls->ls_dlm != NULL)) {
+		error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, flags,
+				   NULL, gl);
+	}
+	up_read(&ls->ls_sem);
 	if (error == -EBUSY) {
 		msleep(20);
 		goto again;
@@ -396,7 +406,12 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 static void gdlm_cancel(struct gfs2_glock *gl)
 {
 	struct lm_lockstruct *ls = &gl->gl_name.ln_sbd->sd_lockstruct;
-	dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_CANCEL, NULL, gl);
+
+	down_read(&ls->ls_sem);
+	if (likely(ls->ls_dlm != NULL)) {
+		dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_CANCEL, NULL, gl);
+	}
+	up_read(&ls->ls_sem);
 }
 
 /*
@@ -577,7 +592,11 @@ static int sync_unlock(struct gfs2_sbd *sdp, struct dlm_lksb *lksb, char *name)
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	int error;
 
-	error = dlm_unlock(ls->ls_dlm, lksb->sb_lkid, 0, lksb, ls);
+	down_read(&ls->ls_sem);
+	error = -ENODEV;
+	if (likely(ls->ls_dlm != NULL))
+		error = dlm_unlock(ls->ls_dlm, lksb->sb_lkid, 0, lksb, ls);
+	up_read(&ls->ls_sem);
 	if (error) {
 		fs_err(sdp, "%s lkid %x error %d\n",
 		       name, lksb->sb_lkid, error);
@@ -604,9 +623,14 @@ static int sync_lock(struct gfs2_sbd *sdp, int mode, uint32_t flags,
 	memset(strname, 0, GDLM_STRNAME_BYTES);
 	snprintf(strname, GDLM_STRNAME_BYTES, "%8x%16x", LM_TYPE_NONDISK, num);
 
-	error = dlm_lock(ls->ls_dlm, mode, lksb, flags,
-			 strname, GDLM_STRNAME_BYTES - 1,
-			 0, sync_wait_cb, ls, NULL);
+	down_read(&ls->ls_sem);
+	error = -ENODEV;
+	if (likely(ls->ls_dlm != NULL)) {
+		error = dlm_lock(ls->ls_dlm, mode, lksb, flags,
+				 strname, GDLM_STRNAME_BYTES - 1,
+				 0, sync_wait_cb, ls, NULL);
+	}
+	up_read(&ls->ls_sem);
 	if (error) {
 		fs_err(sdp, "%s lkid %x flags %x mode %d error %d\n",
 		       name, lksb->sb_lkid, flags, mode, error);
@@ -1333,6 +1357,7 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 	 */
 
 	INIT_DELAYED_WORK(&sdp->sd_control_work, gfs2_control_func);
+	ls->ls_dlm = NULL;
 	spin_lock_init(&ls->ls_recover_spin);
 	ls->ls_recover_flags = 0;
 	ls->ls_recover_mount = 0;
@@ -1367,6 +1392,7 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 	 * create/join lockspace
 	 */
 
+	init_rwsem(&ls->ls_sem);
 	error = dlm_new_lockspace(fsname, cluster, flags, GDLM_LVB_SIZE,
 				  &gdlm_lockspace_ops, sdp, &ops_result,
 				  &ls->ls_dlm);
@@ -1446,10 +1472,12 @@ static void gdlm_unmount(struct gfs2_sbd *sdp)
 
 	/* mounted_lock and control_lock will be purged in dlm recovery */
 release:
+	down_write(&ls->ls_sem);
 	if (ls->ls_dlm) {
 		dlm_release_lockspace(ls->ls_dlm, 2);
 		ls->ls_dlm = NULL;
 	}
+	up_write(&ls->ls_sem);
 
 	free_recover_size(ls);
 }
-- 
2.51.0



