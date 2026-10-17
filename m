Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BE3C13E0;
	Sat, 17 Oct 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259063; cv=none; b=KLU4eNMwQMYnMIc9TuxDd4QlwlWZK5btDMWYhmWI7LgcZqrI0HDDbhZoAb8CYmcI+pWER/mCXBrW1o/KJ0PkwImvmiqkSU0W/WkCfNyjTFNfZLGeTRFfc+30zIUVoZbXJ5DabK95bNFeWWs1WF0VZKvdjAj2dacr2ZoFOLnqB1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259063; c=relaxed/simple;
	bh=N9C05W0p+wYw7iiExXhJ3X+9o0DALkPedxUZ8Sn/mgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxtJlNN3y7rnRUQzy13+IAL8extoG9DVWZRtYwuqQJpr3SpIux4hpu1sCRY9wJVgxA9sih/ZiW7O5NLOaOw2L35pYujmCjEAvIkUmAHxpGAVfj7NGuovv6KNu+iKz2Y31ewDwHm/jbH880w8D0Bj1D5acJLt/5HLOeFBoRTUXg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HH8QYo2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HH8QYo2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25A41F000C4;
	Sat, 17 Oct 2026 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259060;
	bh=Ze0SCdWh1mTzD5Bs6CLxfwJ/5hqqTRVIfliD3lNPoqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH8QYo2nu17S9euQU9npxmvpFoiY9oj+PMIjIld+AAvUs0hyIPVjHuQQ8BwddaJku
	 EMb62ABN5CH9fFh29nu6zRm7Y6oTX106k9wToq4LAq323rUjgJ6vz8l+kKqk3NuQHU
	 uGQLP2Cs1ouF/2Dk7+foTZOv99Ky+A4qw753CWpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1088/1674] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Sat, 17 Oct 2026 17:56:00 +0200
Message-ID: <20261017160459.058164680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit c2f2e83e3bbc5483730fd4ee903182761f1ae50f ]

In cifs_close_deferred_file(), cifs_close_all_deferred_files(), and
cifs_close_deferred_file_under_dentry(), when a pending deferred close
is cancelled via cancel_delayed_work(), the subsequent kmalloc_obj() to
add the file to the local processing list may fail under memory pressure.
The loop breaks immediately, but the cancelled work is no longer pending
(it would have called _cifsFileInfo_put()), and the cfile is never added
to file_head for processing.  The cifsFileInfo reference and the open
server handle both leak.

Fix by saving the cfile that failed allocation in a local variable,
breaking as before, and calling _cifsFileInfo_put() on it after
releasing the lock.  Any files later in the iteration are unaffected
since their deferred work is still pending and will fire normally.

Fixes: e3fc065682eb ("cifs: Deferred close performance improvements")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/misc.c | 45 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 991e960e16b0c..8937095184ca6 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -772,7 +772,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 
@@ -789,8 +789,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 				spin_unlock(&cifs_inode->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -798,6 +800,15 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	}
 	spin_unlock(&cifs_inode->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, false, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 
@@ -815,7 +826,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 
@@ -829,8 +840,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 				spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -838,6 +851,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, true, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 
@@ -892,7 +914,7 @@ void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb)
 void
 cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 	void *page;
@@ -911,8 +933,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-					if (tmp_list == NULL)
+					if (tmp_list == NULL) {
+						failed_cfile = cfile;
 						break;
+					}
 					tmp_list->cfile = cfile;
 					list_add_tail(&tmp_list->list, &file_head);
 				}
@@ -921,6 +945,15 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 	}
 	spin_unlock(&tcon->open_file_lock);
 
+	if (failed_cfile) {
+		if (OPEN_FMODE(failed_cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(failed_cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(failed_cfile, true, false);
+	}
+
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		struct cifsFileInfo *cfile = tmp_list->cfile;
 
-- 
2.53.0



