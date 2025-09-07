Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03C14BFA2;
	Sun,  7 Sep 2025 20:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276256; cv=none; b=cQxFe1Fq4tsiGJf3dFApsTRNYjtlulzAGK7yh/zCYRyBTeQCUTWL0/aJq2nTFqe+4WylfBJkngfx8rmoRvvEdDSuCtlPT0bAszlCBNzZig567TPpU6uhLATHEwMweJICn8aPHUQ/K7LDkwdQSmelxHbJ+204OiaoPX61fAnJIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276256; c=relaxed/simple;
	bh=GCqteRMXE2XlQgSY266vW29RlDxDbA/b9UkwPm5n5D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmlWRnNyqSGS6ZLE/iJjCAHcdruy9O7ueE/+w/JOACh/sKT7l3FfjUiKE8n8KpEbRIdo04CHo9GxRbG8SBKvRB/xVYuuemFGuWpJ2oEQtV5895pOOshR8OYqGKXNyEjbGHcIkZu1BRzvX/y7DnNI9cKWgvR0uht2Ndf7gGiphNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZyOSjbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZyOSjbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69C7C4CEF0;
	Sun,  7 Sep 2025 20:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276256;
	bh=GCqteRMXE2XlQgSY266vW29RlDxDbA/b9UkwPm5n5D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZyOSjbLKEP6QsCxHeC5rCqG8KKle6QdyqQBJJ4tOM26Zy9BvTrof7D2sHpt9PJo8
	 aLguobTK4UZfgWsD1m25L34sP6yxw64kiyGes4nBPPganp2lLAVxSvP0SUm4GlE3Ja
	 rm4MWesl0Qu4BWE5n4A4dBWlE7kZj4jrj3cbyHdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Lars Wendler <polynomial-c@gmx.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <pv@excello.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	"Kirill A. Shutemov" <k.shutemov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 046/104] proc: fix missing pde_set_flags() for net proc files
Date: Sun,  7 Sep 2025 21:58:03 +0200
Message-ID: <20250907195608.887605172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangzijie <wangzijie1@honor.com>

commit 2ce3d282bd5050fca8577defeff08ada0d55d062 upstream.

To avoid potential UAF issues during module removal races, we use
pde_set_flags() to save proc_ops flags in PDE itself before
proc_register(), and then use pde_has_proc_*() helpers instead of directly
dereferencing pde->proc_ops->*.

However, the pde_set_flags() call was missing when creating net related
proc files.  This omission caused incorrect behavior which FMODE_LSEEK was
being cleared inappropriately in proc_reg_open() for net proc files.  Lars
reported it in this link[1].

Fix this by ensuring pde_set_flags() is called when register proc entry,
and add NULL check for proc_ops in pde_set_flags().

[wangzijie1@honor.com: stash pde->proc_ops in a local const variable, per Christian]
  Link: https://lkml.kernel.org/r/20250821105806.1453833-1-wangzijie1@honor.com
Link: https://lkml.kernel.org/r/20250818123102.959595-1-wangzijie1@honor.com
Link: https://lore.kernel.org/all/20250815195616.64497967@chagall.paradoxon.rec/ [1]
Fixes: ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Lars Wendler <polynomial-c@gmx.de>
Tested-by: Stefano Brivio <sbrivio@redhat.com>
Tested-by: Petr Vaněk <pv@excello.cz>
Tested by: Lars Wendler <polynomial-c@gmx.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: wangzijie <wangzijie1@honor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/generic.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -363,6 +363,25 @@ static const struct inode_operations pro
 	.setattr	= proc_notify_change,
 };
 
+static void pde_set_flags(struct proc_dir_entry *pde)
+{
+	const struct proc_ops *proc_ops = pde->proc_ops;
+
+	if (!proc_ops)
+		return;
+
+	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
+		pde->flags |= PROC_ENTRY_PERMANENT;
+	if (proc_ops->proc_read_iter)
+		pde->flags |= PROC_ENTRY_proc_read_iter;
+#ifdef CONFIG_COMPAT
+	if (proc_ops->proc_compat_ioctl)
+		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
+#endif
+	if (proc_ops->proc_lseek)
+		pde->flags |= PROC_ENTRY_proc_lseek;
+}
+
 /* returns the registered entry, or frees dp and returns NULL on failure */
 struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 		struct proc_dir_entry *dp)
@@ -370,6 +389,8 @@ struct proc_dir_entry *proc_register(str
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
+	pde_set_flags(dp);
+
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
 	if (pde_subdir_insert(dir, dp) == false) {
@@ -558,20 +579,6 @@ struct proc_dir_entry *proc_create_reg(c
 	return p;
 }
 
-static void pde_set_flags(struct proc_dir_entry *pde)
-{
-	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
-		pde->flags |= PROC_ENTRY_PERMANENT;
-	if (pde->proc_ops->proc_read_iter)
-		pde->flags |= PROC_ENTRY_proc_read_iter;
-#ifdef CONFIG_COMPAT
-	if (pde->proc_ops->proc_compat_ioctl)
-		pde->flags |= PROC_ENTRY_proc_compat_ioctl;
-#endif
-	if (pde->proc_ops->proc_lseek)
-		pde->flags |= PROC_ENTRY_proc_lseek;
-}
-
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 		struct proc_dir_entry *parent,
 		const struct proc_ops *proc_ops, void *data)
@@ -582,7 +589,6 @@ struct proc_dir_entry *proc_create_data(
 	if (!p)
 		return NULL;
 	p->proc_ops = proc_ops;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_data);
@@ -633,7 +639,6 @@ struct proc_dir_entry *proc_create_seq_p
 	p->proc_ops = &proc_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_seq_private);
@@ -664,7 +669,6 @@ struct proc_dir_entry *proc_create_singl
 		return NULL;
 	p->proc_ops = &proc_single_ops;
 	p->single_show = show;
-	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_single_data);


