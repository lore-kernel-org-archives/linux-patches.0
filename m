Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215370;
	b=slLg8obaUoNQF91gBYRBSn5v/+qCm1rLuGWtKUsLt4PROl3kdh85UMwoihhWw0nmpmw1
	 5jc9SNArwwzIFv6YKRxvaQsS2z4EFDgEMoRJJ2sN5VQgbUyqt0kWMm1/yHxmGFsUDDEXJ
	 hAmCRY+bcdsfxYZzM1Plrzh++GHUYFXK39bDzrhcCJbhLoWqq4Z43uAMhCNuyLQKs56Vd
	 TMDLJh+g3ZwY+iwsjCFpMwOEZeIvjJZNWxRABK+pgHc76w7wDkuSGa+e6o+sjjS3lcJk7
	 PdcMYGnxDnOrNjp+6dQgOlg6wPhJi/cedHZbl7SVmR34k1DavGqVH4treG/FLrkjlDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=txZaihOmiwU5P/pN5RLMwlWu3yU3xZpPICRouy/evPI=;
	b=CyvHyqjR51BHZndCVY/ZYM4vkfKbLhPSVpuT96hPOoFEn2c473G1L2J64YTpRf28eE88
	 7wiCMyz/EzessC6WwErCm7LSaTtaw2K52CmLSpM7FBSa1P9SGcIrgtEm4KPZmzNU2I1HQ
	 GLmMyHmEVcY+5mmqaa9zGhZYjfveQPVEy9RwR68FOmGrsNLYAI5DilO2yXti7t2VQTXHC
	 ubtX0wDjDFp9Krn7QwEoIN5qfsoJJzL4q3ZgJWxAMYW2iHSLo44aAlnpVrjpMZTAz03qO
	 f6AXTWyrakcHmD+b6UhsIC/ijOvCXOLDiY6eeKu4N/r7rGuuFTOpvCoDCx7/hxD+XfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqvOe1OT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1132606A31A;
	Wed, 28 Oct 2026 19:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqvOe1OT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17781F01825;
	Wed, 28 Oct 2026 19:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215369;
	bh=txZaihOmiwU5P/pN5RLMwlWu3yU3xZpPICRouy/evPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqvOe1OThEOngzGcWOjfJIflrFzjbiL9SamPmB0IyikThK2PjUkSJpxnwUr9FxiFa
	 td5bb4kYP0U3AEWXjIG5gwYUsSL2vf/bXrUQwbj7EO7/J3DYkYgmE29pUPmGBLLSIy
	 bao3QTc3H+p2SltY8Vby3oPk7vbWCHyo86gOSevA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1180/1887] cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths
Date: Wed, 28 Oct 2026 17:54:36 +0100
Message-ID: <20261028170526.258704223@linuxfoundation.org>
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
index 6942253def3b0..fb841235617c1 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -757,7 +757,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 void
 cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
-	struct cifsFileInfo *cfile = NULL;
+	struct cifsFileInfo *cfile = NULL, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 
@@ -774,8 +774,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
@@ -783,6 +785,15 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
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
 
@@ -800,7 +811,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 
@@ -814,8 +825,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
@@ -823,6 +836,15 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
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
 
@@ -875,7 +897,7 @@ void cifs_close_all_deferred_files_sb(struct cifs_sb_info *cifs_sb)
 void
 cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 {
-	struct cifsFileInfo *cfile;
+	struct cifsFileInfo *cfile, *failed_cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
 	struct list_head file_head;
 	void *page;
@@ -894,8 +916,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
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
@@ -904,6 +928,15 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
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



