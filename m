Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69054F4CEB;
	Tue, 13 Oct 2026 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893544; cv=none; b=Ay2mk01gLKydRFYbduI12RaOxGTOEMaIs8OuxPpoZEXxSZFCADNhykHT2ZnMLg90ImIMtpnpADbX0T9y09KQEuMHTdhecnmU1lc2OUnZ5TiQmkpKAHAoMW8u+tDMLwR2NdEVllmBt2qoYOm4owD2zXKO2dcsyJ2JRJ8jG76h2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893544; c=relaxed/simple;
	bh=q3Rzsbv8QB/teit0KL+8teTAWYCt4cZFGemxd1/u1dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlYS/5qGQEtQkvQGUYZu/D2yLhmKpU5O93FDJscxdQf3TVQg6IVbMtJOGiYbkgujAvY7hjOcS/5liEaWiyKxuiNhYAXGX2LQEMY620Tx6p+L95aP9jIuDoFR034qldWMM1DBTt5ojLeXnOv/EHZXlMahH1jxvhtEU4Xud1NLmA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGFd/a+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGFd/a+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA081F000FF;
	Tue, 13 Oct 2026 12:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893543;
	bh=8H/Md9VXboRyydBYj2nYIyrwefImg3JWwtnTtcXfC1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGFd/a+BiY4c1CpWzRo/YOI9+oiS6zHnFHlzR/VQH1nKb9KSxSOLa70NUYTA/8L0A
	 aNf+56HN9xoFfX+qOAcNzLXOKZg/RgCk0/N3Qkhhv6XDWHnKLF4C8B8r4PtImGkTtw
	 +yI1PIdDS8cmvRwmAtqYx9nViCB54ag35gndsbgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/621] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Tue, 13 Oct 2026 13:34:17 +0200
Message-ID: <20261013112927.077919159@linuxfoundation.org>
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
index 0703e06aba1ed..cbbd7ac83c5f7 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -776,7 +776,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -793,8 +793,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 
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
@@ -802,6 +804,15 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
 
@@ -819,7 +830,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	LIST_HEAD(file_head);
 
@@ -833,8 +844,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 
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
@@ -842,6 +855,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
 
@@ -897,7 +919,7 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 					   struct dentry *dentry)
 {
 	struct file_list *tmp_list, *tmp_next_list;
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	LIST_HEAD(file_head);
 
 	spin_lock(&tcon->open_file_lock);
@@ -910,14 +932,25 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
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



