Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3EA143C47;
	Tue, 18 Jun 2024 12:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714893; cv=none; b=o+2/l+bd3povENJwAfIL7UTHV+J/qR78aJ0y5W4LMCxn9PsB1EZCfdi6TAfhexbNjs03SpP8lNT1rIa16sJfwKBKl+zYfLV5ruclvyTju14Enq5XGPyJ3UN4EUXhlcYBHwwvKTFASd+jui/8Xw45tcAo4ecd13BkUoC70xJFQBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714893; c=relaxed/simple;
	bh=reRDxVQlBh2eVMy5DV+CLx3TMlPBmvPVKXTMSNLCc/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNfQ+Xj/MBoQAEfM1aAqiGfVIKDLdbrhgjSmhyaNp1jmMfNQMK3hVneTH57oN6L+JtjNTT2nX9cHLswx2Kg+fRV2uDfZuO45cRfL2Z0ObAQiXLAIxhmcnbeioxViHU5lVC24c3bBU/Wc65F16eEZ7kIB9dDGUDNOmrURYLMWusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4M4TopP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4M4TopP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F59C3277B;
	Tue, 18 Jun 2024 12:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714893;
	bh=reRDxVQlBh2eVMy5DV+CLx3TMlPBmvPVKXTMSNLCc/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4M4TopPINb4LhQRO+HOPqy18AGhcZcFlVzlpXRH2xhjqRrVYrHbK9P/79cG5ZCJe
	 dF2G15dlmAMBavXjjuY/ZyYEp8Ln1IEqC6rwzSqegj0QPBiEL1NjKr/3P3YKVj4KfS
	 Oa/u0EKdpyEcK/9GZgBGPg8ta+S75Nz94oR80b9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/770] file: Merge __fd_install into fd_install
Date: Tue, 18 Jun 2024 14:29:37 +0200
Message-ID: <20240618123412.057748086@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit d74ba04d919ebe30bf47406819c18c6b50003d92 ]

The function __fd_install was added to support binder[1].  With binder
fixed[2] there are no more users.

As fd_install just calls __fd_install with "files=current->files",
merge them together by transforming the files parameter into a
local variable initialized to current->files.

[1] f869e8a7f753 ("expose a low-level variant of fd_install() for binder")
[2] 44d8047f1d87 ("binder: use standard functions to allocate fds")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-14-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-18-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 25 ++++++-------------------
 include/linux/fdtable.h |  2 --
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 9fa49e6298fba..a80deabe7f7dc 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -175,7 +175,7 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
 	spin_unlock(&files->file_lock);
 	new_fdt = alloc_fdtable(nr);
 
-	/* make sure all __fd_install() have seen resize_in_progress
+	/* make sure all fd_install() have seen resize_in_progress
 	 * or have finished their rcu_read_lock_sched() section.
 	 */
 	if (atomic_read(&files->count) > 1)
@@ -198,7 +198,7 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
 	rcu_assign_pointer(files->fdt, new_fdt);
 	if (cur_fdt != &files->fdtab)
 		call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
-	/* coupled with smp_rmb() in __fd_install() */
+	/* coupled with smp_rmb() in fd_install() */
 	smp_wmb();
 	return 1;
 }
@@ -613,17 +613,13 @@ EXPORT_SYMBOL(put_unused_fd);
  * It should never happen - if we allow dup2() do it, _really_ bad things
  * will follow.
  *
- * NOTE: __fd_install() variant is really, really low-level; don't
- * use it unless you are forced to by truly lousy API shoved down
- * your throat.  'files' *MUST* be either current->files or obtained
- * by get_files_struct(current) done by whoever had given it to you,
- * or really bad things will happen.  Normally you want to use
- * fd_install() instead.
+ * This consumes the "file" refcount, so callers should treat it
+ * as if they had called fput(file).
  */
 
-void __fd_install(struct files_struct *files, unsigned int fd,
-		struct file *file)
+void fd_install(unsigned int fd, struct file *file)
 {
+	struct files_struct *files = current->files;
 	struct fdtable *fdt;
 
 	rcu_read_lock_sched();
@@ -645,15 +641,6 @@ void __fd_install(struct files_struct *files, unsigned int fd,
 	rcu_read_unlock_sched();
 }
 
-/*
- * This consumes the "file" refcount, so callers should treat it
- * as if they had called fput(file).
- */
-void fd_install(unsigned int fd, struct file *file)
-{
-	__fd_install(current->files, fd, file);
-}
-
 EXPORT_SYMBOL(fd_install);
 
 static struct file *pick_file(struct files_struct *files, unsigned fd)
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index b0c6a959c6a00..6e8743a4c9d31 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -126,8 +126,6 @@ int iterate_fd(struct files_struct *, unsigned,
 
 extern int __alloc_fd(struct files_struct *files,
 		      unsigned start, unsigned end, unsigned flags);
-extern void __fd_install(struct files_struct *files,
-		      unsigned int fd, struct file *file);
 extern int __close_fd(struct files_struct *files,
 		      unsigned int fd);
 extern int __close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
-- 
2.43.0



