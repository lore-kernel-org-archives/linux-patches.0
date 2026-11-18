Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054297;
	b=HjVuOOa1UEJ+EeCCFjqpHpXCsBV2vWS3OSpGZWl3XzhvbIsAh1hIEJbcYDYdv8bW9gi+
	 dEa0ESBGKZtLSVEkboie5Cg8X3oMx0rChJtSecv0XsigDsJDIV+QkfbZG4MMBTiz/QF26
	 k3cwvetOs6DZ+D8g1FkVJQSfdVeoeKSIcuwoevSbhtT3VmI+1DaY/oFGyl4YK8vk87z0Q
	 yt6fyUEjWD0M4jnZPSHz7K3rhn8c0AtUwB0F6CaPBIaj4LeJOuxDUUsyhP3a71qLx7+DT
	 eoNw58+uGIVnOY8m47jMsmm/Za8qduJXG6WVo+IYlM+LJy4ysBbzlu7SHOYzYH3oVHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2p9xPwSh7aQaMi6+Jgoo64d2qtMQsmz+Souo6zOBWvc=;
	b=b6sOSVXlq1tUQoYhY7uVvzKgY65sFxg89zMYsT3EPE7rvXZudjYR3CYuSyO8jLneGh3Y
	 yFw3dfp3bwjCKdFiWCsWPKw2+h1+NSKaablZ6cjhM/nSsUZWCCdQJefj88vCJk7xNnHtC
	 OIlkNxTb1g9Li57aQ3ulKLKuzaYG8tWDPbHaThSMFhr8kvZUdN8BrL7GAXsxg3X5hIUH0
	 xPR8DBUHtxKkF/Zk55ArhOWNOeB/yBWP9vy5/u0WfDVRbnty3gHEUWedYlIDlykWe5eL+
	 Cig9/xB9dP3PcJBzlu6hfc3x4VreR0Zzl7+jl3BO5cOYib8nVZDqTqfMu2ux/xmaZsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KBLtQcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2116606A320;
	Thu, 19 Nov 2026 02:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KBLtQcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFDA1F000C4;
	Thu, 19 Nov 2026 02:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054297;
	bh=2p9xPwSh7aQaMi6+Jgoo64d2qtMQsmz+Souo6zOBWvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KBLtQcM7OM4HDtFB6BJ64OwxzWZmAFUEU+PleaMDJmrmplbCcMjC66Yp6v2gzWyK
	 sNggaV3qRUUzcTDFS9mmIrePJq8yLAFXiOKrhsWB5Q13Y4j31GttHP7plHBXrqhIy/
	 smQNLoZHICvCOCiewRPgUbjLN3SeU1roQTosEFmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1225/2214] switch procfs from d_set_d_op() to d_splice_alias_ops()
Date: Wed, 18 Nov 2026 15:48:21 +0100
Message-ID: <20261118150100.773602602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ec169ef86ba45389b353189cf1fc06461163f667 ]

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c        | 9 +++------
 fs/proc/generic.c     | 8 ++++----
 fs/proc/internal.h    | 3 +--
 fs/proc/namespaces.c  | 3 +--
 fs/proc/proc_sysctl.c | 7 +++----
 5 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index b0b99219a2ad0..015db2b964b7d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2690,8 +2690,7 @@ static struct dentry *proc_pident_instantiate(struct dentry *dentry,
 		inode->i_fop = p->fop;
 	ei->op = p->op;
 	pid_update_inode(task, inode);
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 static struct dentry *proc_pident_lookup(struct inode *dir, 
@@ -3430,8 +3429,7 @@ static struct dentry *proc_pid_instantiate(struct dentry * dentry,
 	set_nlink(inode, nlink_tgid);
 	pid_update_inode(task, inode);
 
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
@@ -3731,8 +3729,7 @@ static struct dentry *proc_task_instantiate(struct dentry *dentry,
 	set_nlink(inode, nlink_tid);
 	pid_update_inode(task, inode);
 
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4a438f1f318d1..e88a274269cbb 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -257,10 +257,10 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
 		if (!inode)
 			return ERR_PTR(-ENOMEM);
 		if (de->flags & PROC_ENTRY_FORCE_LOOKUP)
-			d_set_d_op(dentry, &proc_net_dentry_ops);
-		else
-			d_set_d_op(dentry, &proc_misc_dentry_ops);
-		return d_splice_alias(inode, dentry);
+			return d_splice_alias_ops(inode, dentry,
+						  &proc_net_dentry_ops);
+		return d_splice_alias_ops(inode, dentry,
+					  &proc_misc_dentry_ops);
 	}
 	read_unlock(&proc_subdir_lock);
 	return ERR_PTR(-ENOENT);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index a51ff1a60e804..49e34d94b9c64 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -340,7 +340,6 @@ static inline void pde_force_lookup(struct proc_dir_entry *pde)
 static inline struct dentry *proc_splice_unmountable(struct inode *inode,
 		struct dentry *dentry, const struct dentry_operations *d_ops)
 {
-	d_set_d_op(dentry, d_ops);
 	dont_mount(dentry);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, d_ops);
 }
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 203d3363e3d5a..9f4bb90a536e6 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -125,8 +125,7 @@ static struct dentry *proc_ns_instantiate(struct dentry *dentry,
 	ei->ns_ops = ns_ops;
 	pid_update_inode(task, inode);
 
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7f7ffbc9276c5..780d182d75425 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -522,9 +522,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 	}
 
-	d_set_d_op(dentry, &proc_sys_dentry_operations);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	err = d_splice_alias(inode, dentry);
+	err = d_splice_alias_ops(inode, dentry, &proc_sys_dentry_operations);
 
 out:
 	if (h)
@@ -681,9 +680,9 @@ static bool proc_sys_fill_cache(struct file *file,
 			return false;
 		if (d_in_lookup(child)) {
 			struct dentry *res;
-			d_set_d_op(child, &proc_sys_dentry_operations);
 			inode = proc_sys_make_inode(dir->d_sb, head, table);
-			res = d_splice_alias(inode, child);
+			res = d_splice_alias_ops(inode, child,
+						 &proc_sys_dentry_operations);
 			d_lookup_done(child);
 			if (unlikely(res)) {
 				if (IS_ERR(res)) {
-- 
2.53.0



