Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C310E2D73B8;
	Tue, 17 Mar 2026 17:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768187; cv=none; b=ZkZKh2GCWNidKGvyzhNRMF1TDLfcjH0wOwSZkEjhr1AxeVaX1EvTq1geYV8qe8/XUyFf/hiIqHtYcQXIke52EabK9O994/BwTaA8/fFVv5GvmcXYvBMrBnbzGdAWhPLQ7b54KxUKkVwBHKwM7UueQHXZeFTTOMNyjdrUn+8z35s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768187; c=relaxed/simple;
	bh=Xj3gR+o2/+yAXjLncW+2cUzFTmd0Lgb7PtLeP0RwJr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4i58qoRuHykiU1styjpkd7UQ+acuaGOgOFMmgGdh9gt0HkeiXlPd2xZ1T5UImXEZ+cnBkT8eMs8WFRyfaK/i5Kyzaw5ClhassPqdars5dOR/riSYixS9aPeRBUMY0KuxNsFUS5AFnhuX7hhG00JjIR0rC10qQnmfyg51cv+OlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UP+suMP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP+suMP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB35C4CEF7;
	Tue, 17 Mar 2026 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768187;
	bh=Xj3gR+o2/+yAXjLncW+2cUzFTmd0Lgb7PtLeP0RwJr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UP+suMP4J4BzJHBe9jorHGWijwSBeVpi/SP+1SF524fMC82E2QldcUfBNHu2Fyjw/
	 7NNZLxLkO5Uv+7knXWQVKsVNjs7vLi/p30hez4NaRbRhAZAWdeHBzJLkaAyd+lI/AH
	 kob0O9Lh9Np3ok2ccVdIu1p+pHsPuzXeRI0BwI1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 244/333] ksmbd: fix use-after-free by using call_rcu() for oplock_info
Date: Tue, 17 Mar 2026 17:34:33 +0100
Message-ID: <20260317163008.412863354@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 1dfd062caa165ec9d7ee0823087930f3ab8a6294 upstream.

ksmbd currently frees oplock_info immediately using kfree(), even
though it is accessed under RCU read-side critical sections in places
like opinfo_get() and proc_show_files().

Since there is no RCU grace period delay between nullifying the pointer
and freeing the memory, a reader can still access oplock_info
structure after it has been freed. This can leads to a use-after-free
especially in opinfo_get() where atomic_inc_not_zero() is called on
already freed memory.

Fix this by switching to deferred freeing using call_rcu().

Fixes: 18b4fac5ef17 ("ksmbd: fix use-after-free in smb_break_all_levII_oplock()")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   29 +++++++++++++++++++++--------
 fs/smb/server/oplock.h |    5 +++--
 2 files changed, 24 insertions(+), 10 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -120,7 +120,7 @@ static void free_lease(struct oplock_inf
 	kfree(lease);
 }
 
-static void free_opinfo(struct oplock_info *opinfo)
+static void __free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
@@ -129,6 +129,18 @@ static void free_opinfo(struct oplock_in
 	kfree(opinfo);
 }
 
+static void free_opinfo_rcu(struct rcu_head *rcu)
+{
+	struct oplock_info *opinfo = container_of(rcu, struct oplock_info, rcu);
+
+	__free_opinfo(opinfo);
+}
+
+static void free_opinfo(struct oplock_info *opinfo)
+{
+	call_rcu(&opinfo->rcu, free_opinfo_rcu);
+}
+
 struct oplock_info *opinfo_get(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
@@ -176,9 +188,9 @@ void opinfo_put(struct oplock_info *opin
 	free_opinfo(opinfo);
 }
 
-static void opinfo_add(struct oplock_info *opinfo)
+static void opinfo_add(struct oplock_info *opinfo, struct ksmbd_file *fp)
 {
-	struct ksmbd_inode *ci = opinfo->o_fp->f_ci;
+	struct ksmbd_inode *ci = fp->f_ci;
 
 	down_write(&ci->m_lock);
 	list_add(&opinfo->op_entry, &ci->m_op_list);
@@ -1279,20 +1291,21 @@ set_lev:
 	set_oplock_level(opinfo, req_op_level, lctx);
 
 out:
-	rcu_assign_pointer(fp->f_opinfo, opinfo);
-	opinfo->o_fp = fp;
-
 	opinfo_count_inc(fp);
-	opinfo_add(opinfo);
+	opinfo_add(opinfo, fp);
+
 	if (opinfo->is_lease) {
 		err = add_lease_global_list(opinfo);
 		if (err)
 			goto err_out;
 	}
 
+	rcu_assign_pointer(fp->f_opinfo, opinfo);
+	opinfo->o_fp = fp;
+
 	return 0;
 err_out:
-	free_opinfo(opinfo);
+	__free_opinfo(opinfo);
 	return err;
 }
 
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -69,8 +69,9 @@ struct oplock_info {
 	struct lease		*o_lease;
 	struct list_head        op_entry;
 	struct list_head        lease_entry;
-	wait_queue_head_t oplock_q; /* Other server threads */
-	wait_queue_head_t oplock_brk; /* oplock breaking wait */
+	wait_queue_head_t	oplock_q; /* Other server threads */
+	wait_queue_head_t	oplock_brk; /* oplock breaking wait */
+	struct rcu_head		rcu;
 };
 
 struct lease_break_info {


