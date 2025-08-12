Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FCB2C15B5;
	Tue, 12 Aug 2025 17:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020722; cv=none; b=gW7EwzbCMHclA6KZRQtQPuKimtX4otJX68zrld1YFRvm+NNNGAV5mHYfzPlER9SOHQWeO4SfP1QQZRPWssqBI7E8TqdorM64VEraps1YxeW5zfe/cO6EdzfQW9BrPlyHjjPIeGKPn+nrNuyapOkzvA/FqQ99Dex9TmaYnd0WRRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020722; c=relaxed/simple;
	bh=8Wc6suO/uQ/CVTjpYCt/tgzUyhJqAWynmU1YgcGOJO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUDOy1zM6QVm8YvFbcqql7hXknx23NSEvcs9yEmBybgvjhEFGWtIj25PCsNe7JiM30EuAOLwKvKe37qxDZ6EDKR8Yrf/8mHepDGCoPu7cXdYYV3/Co+1rQxyGWkgxtCRPxCpVNo4J2hYWo7+svdcFrlWKqTSwC5e9ubmi6GnY6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=minNelY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="minNelY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35834C4CEF1;
	Tue, 12 Aug 2025 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020722;
	bh=8Wc6suO/uQ/CVTjpYCt/tgzUyhJqAWynmU1YgcGOJO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=minNelY5UkloDM22dX8zjsAp5BPijqMyzfHggMyjp5Opue6lDfUYYFxGL16Fu7JGw
	 1nIpVS/fGulBt+mD5wIv5iKqexg2SSQR0R+RQj2tLLyyuK+fW59DdRdDgpQoHVd9xE
	 v2zeHWRo5QbzABFhXvAsvP9fXXvyREmulTrAl9tI=
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
Subject: [PATCH 6.1 158/253] proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al
Date: Tue, 12 Aug 2025 19:29:06 +0200
Message-ID: <20250812172955.442719222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b721bb88b4a6..c3a809e1d719 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -568,6 +568,8 @@ static void pde_set_flags(struct proc_dir_entry *pde)
 	if (pde->proc_ops->proc_compat_ioctl)
 		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
 #endif
+	if (pde->proc_ops->proc_lseek)
+		pde->flags |= PROC_ENTRY_proc_lseek;
 }
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index bc4011901c90..623aa0d97a6d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -494,7 +494,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	typeof_member(struct proc_ops, proc_release) release;
 	struct pde_opener *pdeo;
 
-	if (!pde->proc_ops->proc_lseek)
+	if (!pde_has_proc_lseek(pde))
 		file->f_mode &= ~FMODE_LSEEK;
 
 	if (pde_is_permanent(pde)) {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d115d22c01d4..019137261a03 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -98,6 +98,11 @@ static inline bool pde_has_proc_compat_ioctl(const struct proc_dir_entry *pde)
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
index 39532c19aa28..ca9cd8a2569e 100644
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



