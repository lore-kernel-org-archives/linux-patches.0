Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08983905EB;
	Sat, 17 Oct 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254265; cv=none; b=Hf+IQPMf0S3RrOoCal1qbbR+lG6NHLPs7p5LxoH55irXd7waKKsQIFeXgwgZVVVcqMBjbKrH1xp0G4hjdM/zzm00OS1EP2iDW+IC0cq7/H23XkKbJauEK/CJ5xL2po5faBjeohxrAncpCqew1WX2Nznhq2OHGkg+s1eKDSU5+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254265; c=relaxed/simple;
	bh=ZQTz3f1FBhKB9XugRF4qcxw8zzoTJa49qVzgAB3rm4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHp6w578Y3ZsdFylTAeCtiO3RCdrLFumy0vTV6+Qynp7s7GZByEgVdKsWfo5dwPP3qyFVIXUXfXR2pgy2juIYjS7rMz+8CKVtlBLFXT5rQjK0pnpbbg64une+xkCDCUE9539GX1o8aSsUBZHiO78USrIczLi7+xrWgdwReSXw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huvX4VTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huvX4VTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E61F000C4;
	Sat, 17 Oct 2026 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254264;
	bh=yg4l+p+jS7D+IM0eNyISYROJfwg+VWSh8/l1TNskask=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huvX4VTBkbRqeJjc7EmGCXYk49tOSwkYTa6/4cQBuvANGe4Ii0epcZ7Gmr3/zc/3f
	 avPdHMhJ+0XNzxP2XE5F7SogDBudeyNz2IHIi9Z+Wei22JYt7WhQ7xwVsqmsfu3NRg
	 s6CfjwFp6IoozWgnwSIBDR3+AXm1KE6zCVNibdFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/869] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Sat, 17 Oct 2026 17:53:52 +0200
Message-ID: <20261017160047.141273221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index edfe24392bbdc..41c1c18fb0f17 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -772,7 +772,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -788,8 +788,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
@@ -797,6 +799,15 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
 
@@ -814,7 +825,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -827,8 +838,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
@@ -836,6 +849,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
 
@@ -891,7 +913,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry)
 {
 	struct file_list *tmp_list, *tmp_next_list;
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
@@ -904,14 +926,25 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 			tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
-			if (tmp_list == NULL)
+			if (tmp_list == NULL) {
+				failed_cfile = cfile;
 				break;
+			}
 			tmp_list->cfile = cfile;
 			list_add_tail(&tmp_list->list, &file_head);
 		}
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



