Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2961B87F2;
	Tue, 12 Aug 2025 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022573; cv=none; b=j8nhrsFj1O006xi4tHJXNST+0iUoVZpbGHLBgy3043ft+lDnDvMYjLQm2RnfnKdGIVvXtiiMQYvQ10OpUR52kVLsag3lBn4xAQmgH1enbQorvsqPtYto1v5I1BtIX5JifF7tOuy/9/MeH2CvZLpek0mJo709ynrsqUIDZSsBx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022573; c=relaxed/simple;
	bh=WSxo0+v8URCe+Zkl3rv3decIhmlxl2NF5SAtCrCNv4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfM27IJL5DOSjfV0OaGGYLaiTKnaGtfMMHtoIXWs6nn0fqnOw/VLFyJOlWCN+bd28ujyezlVFpsl3fzFSemWC9kweeleH9SjZBsRLXwkMfNxr+quea7E6LS2pNdJQbtuc1nJomrvkxR4b4uaUJPnCSS/+6wQY5xwpocedhsi7UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hU6v+wjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hU6v+wjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64009C4CEF1;
	Tue, 12 Aug 2025 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022572;
	bh=WSxo0+v8URCe+Zkl3rv3decIhmlxl2NF5SAtCrCNv4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU6v+wjz/sqvrL/2CR3dfyhuWZrY7sLld2CJCZcYeCsvJnZED0P7VDL2shYXVz/76
	 NTksk7zUiN9TR8dRspmupxhfLa4FzExJwKXo7aIRT2ADDr02xVblsjzS/9HE3+uUaw
	 8yHCp3AXlm1zeC0JEevX6zeoOdynXmRNl4GkiUcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Kirill A. Shuemov" <kirill.shutemov@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/369] proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al
Date: Tue, 12 Aug 2025 19:28:11 +0200
Message-ID: <20250812173022.061079386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit ff7ec8dc1b646296f8d94c39339e8d3833d16c05 ]

Check pde->proc_ops->proc_lseek directly may cause UAF in rmmod scenario.
It's a gap in proc_reg_open() after commit 654b33ada4ab("proc: fix UAF in
proc_get_inode()").  Followed by AI Viro's suggestion, fix it in same
manner.

Link: https://lkml.kernel.org/r/20250607021353.1127963-1-wangzijie1@honor.com
Fixes: 3f61631d47f1 ("take care to handle NULL ->proc_lseek()")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c       | 2 ++
 fs/proc/inode.c         | 2 +-
 fs/proc/internal.h      | 5 +++++
 include/linux/proc_fs.h | 1 +
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 3431b083f7d0..e21d99fa9263 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -567,6 +567,8 @@ static void pde_set_flags(struct proc_dir_entry *pde)
 	if (pde->proc_ops->proc_compat_ioctl)
 		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
 #endif
+	if (pde->proc_ops->proc_lseek)
+		pde->flags |= PROC_ENTRY_proc_lseek;
 }
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 3604b616311c..129490151be1 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -473,7 +473,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	typeof_member(struct proc_ops, proc_open) open;
 	struct pde_opener *pdeo;
 
-	if (!pde->proc_ops->proc_lseek)
+	if (!pde_has_proc_lseek(pde))
 		file->f_mode &= ~FMODE_LSEEK;
 
 	if (pde_is_permanent(pde)) {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 4e0c5b57ffdb..edd4eb6fa12a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -99,6 +99,11 @@ static inline bool pde_has_proc_compat_ioctl(const struct proc_dir_entry *pde)
 #endif
 }
 
+static inline bool pde_has_proc_lseek(const struct proc_dir_entry *pde)
+{
+	return pde->flags & PROC_ENTRY_proc_lseek;
+}
+
 extern struct kmem_cache *proc_dir_entry_cache;
 void pde_free(struct proc_dir_entry *pde);
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index ea62201c74c4..703d0c76cc9a 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -27,6 +27,7 @@ enum {
 
 	PROC_ENTRY_proc_read_iter	= 1U << 1,
 	PROC_ENTRY_proc_compat_ioctl	= 1U << 2,
+	PROC_ENTRY_proc_lseek		= 1U << 3,
 };
 
 struct proc_ops {
-- 
2.39.5



