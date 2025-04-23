Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B14F27CCD7;
	Wed, 23 Apr 2025 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421028; cv=none; b=A/98Pni8E4kpmkFBH9SYOjKRHpEqTTgAyV6ucr/MplYiU1nCpicWqMXlZzSNmDkEzWTLnald+tt8OSNEetX8SNw3amgLJqX6RqeWl6PipHMnDJBwThJpPKqoh5YonSDAwlFEngH6BVBZkHShh9dPaE/NMvyh38O971Rg65N3WMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421028; c=relaxed/simple;
	bh=GmO8jCM8POQ99u0cOoBfuad0Zs7/1Sw63CIwSbzPiUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7PbZ7D2tFMpqwnKxUmLJnR7UPNFTaUqRTcBH9XOWXM1QnrhP5rgAT8ANkAXqdS5zZOD3UGKOZpsJGxH9GrYIc3w9hM/0aLnuZCb87fw9WvLt5lGQvEb+uXzzRP8R60FDPnR7VjEpW6SGaxd45KvDuDIvFqzwl05dxC77v4Lh3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt8s1bwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt8s1bwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2047C4CEE2;
	Wed, 23 Apr 2025 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421028;
	bh=GmO8jCM8POQ99u0cOoBfuad0Zs7/1Sw63CIwSbzPiUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt8s1bwUt6+k7lzOeysohTjYdM29+7GVa+FnGisy83m31xXFd0OdWJl8Uc3vV9hlh
	 2/uKIA0WzeEv+2nwDk0JI5DLXhnsWbw16UJj7KUDSWwnVGerACKkAyQLOzJGaqSn/r
	 VqncoSjHa49sjN4Ly862SD4Ez2+sgPhaIWkqYtng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 145/241] ksmbd: fix use-after-free in smb_break_all_levII_oplock()
Date: Wed, 23 Apr 2025 16:43:29 +0200
Message-ID: <20250423142626.479379381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 18b4fac5ef17f77fed9417d22210ceafd6525fc7 upstream.

There is a room in smb_break_all_levII_oplock that can cause racy issues
when unlocking in the middle of the loop. This patch use read lock
to protect whole loop.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   29 +++++++++--------------------
 fs/smb/server/oplock.h |    1 -
 2 files changed, 9 insertions(+), 21 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -129,14 +129,6 @@ static void free_opinfo(struct oplock_in
 	kfree(opinfo);
 }
 
-static inline void opinfo_free_rcu(struct rcu_head *rcu_head)
-{
-	struct oplock_info *opinfo;
-
-	opinfo = container_of(rcu_head, struct oplock_info, rcu_head);
-	free_opinfo(opinfo);
-}
-
 struct oplock_info *opinfo_get(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
@@ -157,8 +149,8 @@ static struct oplock_info *opinfo_get_li
 	if (list_empty(&ci->m_op_list))
 		return NULL;
 
-	rcu_read_lock();
-	opinfo = list_first_or_null_rcu(&ci->m_op_list, struct oplock_info,
+	down_read(&ci->m_lock);
+	opinfo = list_first_entry(&ci->m_op_list, struct oplock_info,
 					op_entry);
 	if (opinfo) {
 		if (opinfo->conn == NULL ||
@@ -171,8 +163,7 @@ static struct oplock_info *opinfo_get_li
 			}
 		}
 	}
-
-	rcu_read_unlock();
+	up_read(&ci->m_lock);
 
 	return opinfo;
 }
@@ -185,7 +176,7 @@ void opinfo_put(struct oplock_info *opin
 	if (!atomic_dec_and_test(&opinfo->refcount))
 		return;
 
-	call_rcu(&opinfo->rcu_head, opinfo_free_rcu);
+	free_opinfo(opinfo);
 }
 
 static void opinfo_add(struct oplock_info *opinfo)
@@ -193,7 +184,7 @@ static void opinfo_add(struct oplock_inf
 	struct ksmbd_inode *ci = opinfo->o_fp->f_ci;
 
 	down_write(&ci->m_lock);
-	list_add_rcu(&opinfo->op_entry, &ci->m_op_list);
+	list_add(&opinfo->op_entry, &ci->m_op_list);
 	up_write(&ci->m_lock);
 }
 
@@ -207,7 +198,7 @@ static void opinfo_del(struct oplock_inf
 		write_unlock(&lease_list_lock);
 	}
 	down_write(&ci->m_lock);
-	list_del_rcu(&opinfo->op_entry);
+	list_del(&opinfo->op_entry);
 	up_write(&ci->m_lock);
 }
 
@@ -1347,8 +1338,8 @@ void smb_break_all_levII_oplock(struct k
 	ci = fp->f_ci;
 	op = opinfo_get(fp);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(brk_op, &ci->m_op_list, op_entry) {
+	down_read(&ci->m_lock);
+	list_for_each_entry(brk_op, &ci->m_op_list, op_entry) {
 		if (brk_op->conn == NULL)
 			continue;
 
@@ -1358,7 +1349,6 @@ void smb_break_all_levII_oplock(struct k
 		if (ksmbd_conn_releasing(brk_op->conn))
 			continue;
 
-		rcu_read_unlock();
 		if (brk_op->is_lease && (brk_op->o_lease->state &
 		    (~(SMB2_LEASE_READ_CACHING_LE |
 				SMB2_LEASE_HANDLE_CACHING_LE)))) {
@@ -1388,9 +1378,8 @@ void smb_break_all_levII_oplock(struct k
 		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
 next:
 		opinfo_put(brk_op);
-		rcu_read_lock();
 	}
-	rcu_read_unlock();
+	up_read(&ci->m_lock);
 
 	if (op)
 		opinfo_put(op);
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -71,7 +71,6 @@ struct oplock_info {
 	struct list_head        lease_entry;
 	wait_queue_head_t oplock_q; /* Other server threads */
 	wait_queue_head_t oplock_brk; /* oplock breaking wait */
-	struct rcu_head		rcu_head;
 };
 
 struct lease_break_info {


