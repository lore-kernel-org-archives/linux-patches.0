Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EAC4F68C1;
	Tue, 13 Oct 2026 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894572; cv=none; b=trD6zTFaylfQPg5Uc3QYLallastnHeL9zjTyFjS6TDjBMDuMsQkRXnKIB8KBgIm2sRP7I233u413rNUAMR0z+BbKEWSLAQalv65Mt0+16QGF6eCm3biTu5uwNUOKulXaIK4+P8ad/pWzl52Z3bKvDGQ5elA68RUh1DGFPRpo2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894572; c=relaxed/simple;
	bh=ttZFcw5jBHDbA+MMXyYoKKGbFafqdKJ0d5MSdOOhkYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewrOZ4DGbVaF5l9vHviueeY/HLwcAWcIspKf2o/YluaRHrO+0jURFwrCaqIFUui/70uQNV01i1XSkpjflsN4oqaxW6jpGbltSzyKWJ0G0Ja3aCkehqaI8kUxFPktrpzo5J1Gs+wArC+5m6crtzvVOsiM7HkS/ZzLb05ql2nZzPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OumwqF9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OumwqF9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED03E1F000FF;
	Tue, 13 Oct 2026 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894570;
	bh=3vVGNWQgmhFaUxa9eiW6rY5cUAWEAdZ9111Ta7hWy64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OumwqF9/POdGkR3hqFDvouB5+TRcXJa3B6Oq0FCldHnzhWX2SMIkN+e4D2NPZCwy7
	 n9uwUfO1OSJNmBLStLeJIf0/1uAOxrbLMSmdIA17jPTWPxecixHiv5Z+bProJbv+cL
	 D5TwrY6nZouEUBmIck5YtXjghQJWl7FV6/p89RGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 605/621] cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
Date: Tue, 13 Oct 2026 13:40:00 +0200
Message-ID: <20261013112935.156004568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 0e3ea5445c228048f937ad5a944c27859a78f971 upstream.

The time_last_write stamp was scattered across cifs_close(),
smb2_deferred_work_close(), and the three drain functions in misc.c.
This missed the case where background I/O holds the final reference
after userspace close() returns, and required explicit maintenance at
each close-path site.

Move the smp_store_release() into _cifsFileInfo_put(), immediately
before releasing open_file_lock.  This single location covers all
close paths unconditionally: normal close, background I/O dropping the
final reference, deferred close via timer or external drain.  The
spinlock's store-release/load-acquire pairing with is_inode_writable()
already provides the ordering guarantee documented in
is_size_safe_to_change().

Remove the now-redundant stamps from cifs_close(),
smb2_deferred_work_close(), and all six stamp sites in the misc.c
deferred-close drain functions.

Fixes: e8a8d54c2d50 ("cifs: prevent readdir from changing file size due to stale directory metadata")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |   37 ++++++++++++++++---------------------
 fs/smb/client/misc.c |   51 ++++++---------------------------------------------
 2 files changed, 22 insertions(+), 66 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -906,6 +906,14 @@ void _cifsFileInfo_put(struct cifsFileIn
 		cifs_set_oplock_level(cifsi, 0);
 	}
 
+	if (OPEN_FMODE(cifs_file->f_flags) & FMODE_WRITE) {
+		/* Stamp while open_file_lock is held; covers all close paths
+		 * including background I/O. Pairs with smp_load_acquire() in
+		 * is_size_safe_to_change().
+		 */
+		smp_store_release(&cifsi->time_last_write, jiffies);
+	}
+
 	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
@@ -1420,15 +1428,6 @@ void smb2_deferred_work_close(struct wor
 	cifs_del_deferred_close(cfile);
 	cfile->deferred_close_scheduled = false;
 	spin_unlock(&cinode->deferred_lock);
-	/*
-	 * Refresh time_last_write immediately before the actual server close
-	 * so the protection window is anchored to the real close time, not
-	 * the earlier userspace close time stored by cifs_close().
-	 */
-	if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-		smp_store_release(&cinode->time_last_write, jiffies);
-	}
 	_cifsFileInfo_put(cfile, true, false);
 }
 
@@ -1457,10 +1456,6 @@ int cifs_close(struct inode *inode, stru
 	if (file->private_data != NULL) {
 		cfile = file->private_data;
 		file->private_data = NULL;
-		if (file->f_mode & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&cinode->time_last_write, jiffies);
-		}
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
 		if ((cfile->status_file_deleted == false) &&
 		    (smb2_can_defer_close(inode, dclose))) {
@@ -3171,13 +3166,13 @@ bool is_size_safe_to_change(struct cifsI
 	 * No writable handles open. Check whether we are within the attribute
 	 * cache validity window of a recent local modification.
 	 *
-	 * For the close() path: cifs_close() calls smp_store_release() on
-	 * time_last_write before _cifsFileInfo_put() removes the handle under
-	 * open_file_lock. That spin_unlock() is a store-release that pairs
-	 * with the spin_lock() (load-acquire) in is_inode_writable() above,
-	 * so if is_inode_writable() returned false the smp_load_acquire()
-	 * below is guaranteed to observe any time_last_write update from a
-	 * concurrent close().
+	 * For the close() path: _cifsFileInfo_put() stamps time_last_write
+	 * (via smp_store_release()) before releasing open_file_lock. That
+	 * spin_unlock() is a store-release that pairs with the spin_lock()
+	 * (load-acquire) in is_inode_writable() above, so if
+	 * is_inode_writable() returned false the smp_load_acquire() below is
+	 * guaranteed to observe any time_last_write update from a concurrent
+	 * close(), covering all close paths including background I/O.
 	 *
 	 * For the setattr/truncate paths: those callers use smp_store_release()
 	 * directly; the smp_load_acquire() below pairs with that store. There
@@ -3192,7 +3187,7 @@ bool is_size_safe_to_change(struct cifsI
 	 * jiffies is still close to INITIAL_JIFFIES on 32-bit systems.
 	 */
 	if (from_readdir) {
-		/* Pairs with smp_store_release() at close and truncate sites. */
+		/* Pairs with smp_store_release() in _cifsFileInfo_put() and setattr. */
 		tlw = smp_load_acquire(&cifsInode->time_last_write);
 		if (tlw && time_before(jiffies, tlw + cifs_sb->ctx->acregmax))
 			return false;
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -804,24 +804,11 @@ cifs_close_deferred_file(struct cifsInod
 	}
 	spin_unlock(&cifs_inode->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, false, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, false, false);
+		_cifsFileInfo_put(tmp_list->cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -855,24 +842,11 @@ cifs_close_all_deferred_files(struct cif
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, true, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -942,24 +916,11 @@ void cifs_close_deferred_file_under_dent
 	}
 	spin_unlock(&tcon->open_file_lock);
 
-	if (failed_cfile) {
-		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
-					  jiffies);
-		}
+	if (failed_cfile)
 		_cifsFileInfo_put(failed_cfile, true, false);
-	}
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		struct cifsFileInfo *cfile = tmp_list->cfile;
-
-		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
-			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
-			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
-					  jiffies);
-		}
-		_cifsFileInfo_put(cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}


