Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8BC423A89;
	Tue, 31 Mar 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976083; cv=none; b=oX1xf4/iH0W6IGWVJdd2e3zM2zTABTER9ALp6ssTTHDSdb6GjYDt9c2EMa1QQ/8vBWMCD1vZgimX0jFKknTeP6k+pUmdjBZAD8hrE//Y+9SQ8BS/d0BS7rsN2kGItKNv8RC6lhSEfKC4YcSSzKf72wPbCgVdIW4++jKSBVI/wnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976083; c=relaxed/simple;
	bh=F1qPdp6WK7HdgYw1ualLGZLWWm9RezKgv6bamZgVYCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVF3GXGPfjghs6TbS//RqdTpDVnZa8+PxZo2nXP4P9Ok7CSEfPXjBCgz76h9iBLcDk75AWysMQdwHJBSg/KUyBkvshcMHOszAyUQEHStqzGgfleUP7p38CvfZ3syhLEXkW1EKfgUzjck0v1DWY7q2FYVQ90EK79OG1k6FkcQXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qozfQk4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qozfQk4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A69C19423;
	Tue, 31 Mar 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976083;
	bh=F1qPdp6WK7HdgYw1ualLGZLWWm9RezKgv6bamZgVYCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qozfQk4+iVB2nmFqLtxru5iWJR9tfCLGJHj3l1UFjmsEWxQELITfubaNJa1k3WyPX
	 LA1MqMuB7CMqivXQSnC92y457rzzHJoyZUT91QxeQHgvp2eR8/G5d1FLXg7MRcMI3S
	 shtVTQdEc5Qv85FvWxjk+bHMx6eKO+QWUp+2+BjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Kasselman <werner@verivus.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/244] ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()
Date: Tue, 31 Mar 2026 18:22:30 +0200
Message-ID: <20260331161749.134631928@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Werner Kasselman <werner@verivus.com>

[ Upstream commit 48623ec358c1c600fa1e38368746f933e0f1a617 ]

smb_grant_oplock() has two issues in the oplock publication sequence:

1) opinfo is linked into ci->m_op_list (via opinfo_add) before
   add_lease_global_list() is called.  If add_lease_global_list()
   fails (kmalloc returns NULL), the error path frees the opinfo
   via __free_opinfo() while it is still linked in ci->m_op_list.
   Concurrent m_op_list readers (opinfo_get_list, or direct iteration
   in smb_break_all_levII_oplock) dereference the freed node.

2) opinfo->o_fp is assigned after add_lease_global_list() publishes
   the opinfo on the global lease list.  A concurrent
   find_same_lease_key() can walk the lease list and dereference
   opinfo->o_fp->f_ci while o_fp is still NULL.

Fix by restructuring the publication sequence to eliminate post-publish
failure:

- Set opinfo->o_fp before any list publication (fixes NULL deref).
- Preallocate lease_table via alloc_lease_table() before opinfo_add()
  so add_lease_global_list() becomes infallible after publication.
- Keep the original m_op_list publication order (opinfo_add before
  lease list) so concurrent opens via same_client_has_lease() and
  opinfo_get_list() still see the in-flight grant.
- Use opinfo_put() instead of __free_opinfo() on err_out so that
  the RCU-deferred free path is used.

This also requires splitting add_lease_global_list() to take a
preallocated lease_table and changing its return type from int to void,
since it can no longer fail.

Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for oplock_info")
Cc: stable@vger.kernel.org
Signed-off-by: Werner Kasselman <werner@verivus.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adapted kmalloc_obj() macro to kmalloc(sizeof()) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   72 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 27 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -82,11 +82,19 @@ static void lease_del_list(struct oplock
 	spin_unlock(&lb->lb_lock);
 }
 
-static void lb_add(struct lease_table *lb)
+static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
 {
-	write_lock(&lease_list_lock);
-	list_add(&lb->l_entry, &lease_table_list);
-	write_unlock(&lease_list_lock);
+	struct lease_table *lb;
+
+	lb = kmalloc(sizeof(struct lease_table), KSMBD_DEFAULT_GFP);
+	if (!lb)
+		return NULL;
+
+	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
+	       SMB2_CLIENT_GUID_SIZE);
+	INIT_LIST_HEAD(&lb->lease_list);
+	spin_lock_init(&lb->lb_lock);
+	return lb;
 }
 
 static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
@@ -1042,34 +1050,27 @@ static void copy_lease(struct oplock_inf
 	lease2->version = lease1->version;
 }
 
-static int add_lease_global_list(struct oplock_info *opinfo)
+static void add_lease_global_list(struct oplock_info *opinfo,
+				  struct lease_table *new_lb)
 {
 	struct lease_table *lb;
 
-	read_lock(&lease_list_lock);
+	write_lock(&lease_list_lock);
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
 		if (!memcmp(lb->client_guid, opinfo->conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			opinfo->o_lease->l_lb = lb;
 			lease_add_list(opinfo);
-			read_unlock(&lease_list_lock);
-			return 0;
+			write_unlock(&lease_list_lock);
+			kfree(new_lb);
+			return;
 		}
 	}
-	read_unlock(&lease_list_lock);
 
-	lb = kmalloc(sizeof(struct lease_table), KSMBD_DEFAULT_GFP);
-	if (!lb)
-		return -ENOMEM;
-
-	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
-	       SMB2_CLIENT_GUID_SIZE);
-	INIT_LIST_HEAD(&lb->lease_list);
-	spin_lock_init(&lb->lb_lock);
-	opinfo->o_lease->l_lb = lb;
+	opinfo->o_lease->l_lb = new_lb;
 	lease_add_list(opinfo);
-	lb_add(lb);
-	return 0;
+	list_add(&new_lb->l_entry, &lease_table_list);
+	write_unlock(&lease_list_lock);
 }
 
 static void set_oplock_level(struct oplock_info *opinfo, int level,
@@ -1189,6 +1190,7 @@ int smb_grant_oplock(struct ksmbd_work *
 	int err = 0;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
+	struct lease_table *new_lb = NULL;
 	bool prev_op_has_lease;
 	__le32 prev_op_state = 0;
 
@@ -1291,21 +1293,37 @@ set_lev:
 	set_oplock_level(opinfo, req_op_level, lctx);
 
 out:
-	opinfo_count_inc(fp);
-	opinfo_add(opinfo, fp);
-
+	/*
+	 * Set o_fp before any publication so that concurrent readers
+	 * (e.g. find_same_lease_key() on the lease list) that
+	 * dereference opinfo->o_fp don't hit a NULL pointer.
+	 *
+	 * Keep the original publication order so concurrent opens can
+	 * still observe the in-flight grant via ci->m_op_list, but make
+	 * everything after opinfo_add() no-fail by preallocating any new
+	 * lease_table first.
+	 */
+	opinfo->o_fp = fp;
 	if (opinfo->is_lease) {
-		err = add_lease_global_list(opinfo);
-		if (err)
+		new_lb = alloc_lease_table(opinfo);
+		if (!new_lb) {
+			err = -ENOMEM;
 			goto err_out;
+		}
 	}
 
+	opinfo_count_inc(fp);
+	opinfo_add(opinfo, fp);
+
+	if (opinfo->is_lease)
+		add_lease_global_list(opinfo, new_lb);
+
 	rcu_assign_pointer(fp->f_opinfo, opinfo);
-	opinfo->o_fp = fp;
 
 	return 0;
 err_out:
-	__free_opinfo(opinfo);
+	kfree(new_lb);
+	opinfo_put(opinfo);
 	return err;
 }
 


