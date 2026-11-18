Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059969;
	b=CPR1xuM5BZ/yPenQSshRFwAsOKGK/tSi61XJah8+KN/xqKYTlLi8+LNQTr4QdVZyLFO/
	 i4ldOdRRgKped8Rls0iLFS1U/kcRF15LrcIR9+sPJGRyLSGSX3CJj21z3t2d4AsgA+Vwi
	 ebwJBz+6OB+/t3+OxRtcXAWoanKAluNptu6UKkUyZq4hw9x4gEPOtTzcvcE2HxSgYtvnL
	 eeqa9yqdQl1h36DF+lPbw5bh5Ql6ngAMCk1+G/7yz6hNI8U+m1dYHIrNX3xXn/y11gpRn
	 CHetPyRKtjN2ROXINi5U80LsYRN9QRBZk8SOyg+RYbAPstAlBro6zQBMyYpeY4lRg1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pXWriRUtg7GduRWX6V2B5IzKKxBCB7O7WZAV9aFfOZU=;
	b=dYQb76d2XWV2mMWkd5ASnJELUYWPYcqOIgqerg39e05HDaOb8km+QRY4sTz/OQh2spHG
	 nK+szi3zsFp2gw/dyVP/D0SMGCownCbrD8e7RLoF3Ee91aKju6h793zRc958CB0IDTT+W
	 1hUO2j1OEwCbbKKKiZsQyVbXkeokYcG4qSBac+z2ByqaGoUIqP/Gc6VEtggOJwE/oVZQ5
	 W3O6xC/6GZnPZM4mHKNB3qv8xJuHHFqLZCi//YLFqeyQs1o4nKGF87CqJZtWcliMhq9Fz
	 avWjx31zkRDqR216aSmmCwzHxiJl3XtEHPEbKg76BeAEQXNR7xTNORal+d5WY76ENfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9Gofqyp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9B606A325;
	Thu, 19 Nov 2026 03:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9Gofqyp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921D81F000C4;
	Thu, 19 Nov 2026 03:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059969;
	bh=pXWriRUtg7GduRWX6V2B5IzKKxBCB7O7WZAV9aFfOZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9GofqypPzgubJCrxq6Upg6Ito1s6IQ/ukb5GvP+6LQnxwx2k+vbewqZMQOpnQWci
	 cz9PDgtKRksysMgKw1v+5qukVYCpMwrpLtGGohsv26gk23p/+sLnVA21g5LSq9iSnG
	 KqxfLkkWdWpa6LzfMVku3m4WtldWSqVhWOEqY+rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1032/1848] switch procfs from d_set_d_op() to d_splice_alias_ops()
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150000.586159532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b4e58fb07f484..7a54625bc35f2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2685,8 +2685,7 @@ static struct dentry *proc_pident_instantiate(struct dentry *dentry,
 		inode->i_fop = p->fop;
 	ei->op = p->op;
 	pid_update_inode(task, inode);
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 static struct dentry *proc_pident_lookup(struct inode *dir, 
@@ -3422,8 +3421,7 @@ static struct dentry *proc_pid_instantiate(struct dentry * dentry,
 	set_nlink(inode, nlink_tgid);
 	pid_update_inode(task, inode);
 
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
@@ -3719,8 +3717,7 @@ static struct dentry *proc_task_instantiate(struct dentry *dentry,
 	set_nlink(inode, nlink_tid);
 	pid_update_inode(task, inode);
 
-	d_set_d_op(dentry, &pid_dentry_operations);
-	return d_splice_alias(inode, dentry);
+	return d_splice_alias_ops(inode, dentry, &pid_dentry_operations);
 }
 
 static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ab9f499fc749f..98d88b504478d 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -262,10 +262,10 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
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
index 56fc4197d92b8..cda48c98ec8cd 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -339,7 +339,6 @@ static inline void pde_force_lookup(struct proc_dir_entry *pde)
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
index b7e3d36737cfe..2b233e04f53b8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -524,9 +524,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 	}
 
-	d_set_d_op(dentry, &proc_sys_dentry_operations);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	err = d_splice_alias(inode, dentry);
+	err = d_splice_alias_ops(inode, dentry, &proc_sys_dentry_operations);
 
 out:
 	if (h)
@@ -683,9 +682,9 @@ static bool proc_sys_fill_cache(struct file *file,
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



