Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883D1A680B;
	Mon, 23 Mar 2026 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275650; cv=none; b=h9h15aU9Iu4RIuG5s1lFBu8GNJt2q8EeIAWl8uKJpyB4Kq6nRjkPtK40cx4Q90REsVpvK8pNDiEhHiX3sSlDbJ5xrFB92pBQdvDgMkP2B6x2zmWAxFVmaG9cnfZs4QvLweHOD7ATKLu3wJCLyUbBG7SleEzdAm13mTzLf+Lb86Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275650; c=relaxed/simple;
	bh=Y2g9dBfX25Jl58lytbW2cf8CNMtUg7fBRbN36SJuHpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1SZVkkEgl3poGs95s8kXTiSSMVuN5RPZvYY21qLWJNldC1mz196uEnKIWlEW1N9wDFMPvpJGtWQ1vlnnwu2be0gECNA8zLqE/aRwRcBXtBcsURsskBJ95UXZGg62PTUD6UcIEPEblENZipKtAHLmUP7btMgrp0RsoebNIJ6nh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzBNvu63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzBNvu63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA3CC4CEF7;
	Mon, 23 Mar 2026 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275649;
	bh=Y2g9dBfX25Jl58lytbW2cf8CNMtUg7fBRbN36SJuHpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzBNvu635UKkoAfVHtGI42TAVpDbzslb++EK6O0mwZD95b4JvhfNl+WzuXUP597bY
	 gaMu7A8iSo3JUknDU8b6s+zEDGnIpmrL0n8xBRAy7CiLND2rT7O44IVwxI5eA0/oYp
	 6ns0LM/7UhBGEbV/aMKri1VWv8p5UCVKO1HXN0cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 172/460] ksmbd: fix use-after-free by using call_rcu() for oplock_info
Date: Mon, 23 Mar 2026 14:42:48 +0100
Message-ID: <20260323134530.764490484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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


