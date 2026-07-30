Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD25143F8AD;
	Thu, 30 Jul 2026 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421990; cv=none; b=ExMYaRJIgbAPol2L3YW6pqi1th8uWG+UbwQVLBl9i6lRZmECUqp3YsmtrAdV8hauNUStXOQnZl6n2r1rdM0bkPgUHMIX04TLw239Rf/GzaSUhRXvUrH4thHG1Ik9bX6eqlJRVElMnQSNPtzB2fJSv/RW++BXIeGYRnh/Ca7kVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421990; c=relaxed/simple;
	bh=nOgkhZQNvXcxjTq75aizYu+xfNGZj3dB59RWjEV/8GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxHs+TLxMbjNFhdJJ95IHcKJCfCXkMCCAvZTYN/DQ6cUuvRpvxEvNnvg+Z1VTZVEjVBxTWekhxG3HAsFtpoEwrRldRAVNGLKvCrs8VdheRu5IjsVMOYVMD5FNs1MSnlZGDaE/xFtt8fRk+0j/6s03v01kQe14fGFSHFk8z1nq9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa5KCbD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa5KCbD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F5F1F00A3A;
	Thu, 30 Jul 2026 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421988;
	bh=Jdz2jw8ZJ7m1qkZEgf9ApIWoGsEPLfvb6tRW6zOwH4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa5KCbD34wRBY7il91auYePfdITl+EtiIoIVt6qOXo1ImG1KbwyUK1MbPTXJSkPgN
	 j5x1LyPcEc/nd+ztfRjt0p2LMdPzh6WV4HnqCfXYaXmzZkbunzM7lRsBngaNcg4bWk
	 NNEfIHWs56SLo64ObYCkpYzRW1E+WaKEB7nOwfx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 287/744] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Thu, 30 Jul 2026 16:09:20 +0200
Message-ID: <20260730141450.390000654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8afa746ee19e0d..ce9927b666af7a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -493,7 +493,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -510,8 +510,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 
 				tmp_list = kmalloc_obj(struct file_list,
 						       GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -519,6 +521,15 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
 
@@ -536,7 +547,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -550,8 +561,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 
 				tmp_list = kmalloc_obj(struct file_list,
 						       GFP_ATOMIC);
-				if (tmp_list == NULL)
+				if (tmp_list == NULL) {
+					failed_cfile = cfile;
 					break;
+				}
 				tmp_list->cfile = cfile;
 				list_add_tail(&tmp_list->list, &file_head);
 			}
@@ -559,6 +572,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
 
@@ -614,7 +636,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry)
 {
 	struct file_list *tmp_list, *tmp_next_list;
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
@@ -627,14 +649,25 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 			spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 			tmp_list = kmalloc_obj(struct file_list, GFP_ATOMIC);
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



