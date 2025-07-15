Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C02EA726;
	Tue, 15 Jul 2025 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587371; cv=none; b=GsL/kfip71327vLy1BWlLorSMHNu9x8qkFSyPc9ls2jDC+YxTV1h9x6V2Hvb4WLShh+QsqWs+BMs785eLsIkat76/5MU+RVfo84H/I+fj4HLUJdzHuNeRGvwaAyo0eA7SXuABXqn85/tcjKwE5Bk9QrUP1MfO33U5M1EUF9AZm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587371; c=relaxed/simple;
	bh=mratpHpOT+qmnEBUC7VAhyZSZ5dR0e3fPWnTWBcamcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNulMCroxVoL81e4Ungoghn5NasiHUBUshB0iA1y/Asw7VtAhumImVrpZ/oLjsUQ9O8LaO9CepnQkZhTPvbpPWJx5FanNTkXojVNd7sR1cFSPVAUAKmpzs9WlXJMHAy7FLEP89ENAIWLMICS7S5u1G+yIYRveEpfNXwhdQyXwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuqN9lNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuqN9lNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CA6C4CEE3;
	Tue, 15 Jul 2025 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587371;
	bh=mratpHpOT+qmnEBUC7VAhyZSZ5dR0e3fPWnTWBcamcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuqN9lNuA8mtYANqfufTFPU+CWywrkg7c8s0q05sQ8ekaNa286ZP1MhnpggJkCTvj
	 Sr74F0s99bC2CGFLbjqtDjgpMd99KiNtNpJ6qmIr7mno+AVdj6u/jmRcxmwBN8UXq9
	 +UPZ7JNE2VWmOhfcvnhGcC/3AcvgDrcXd6dNujMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shivank Garg <shivankg@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/88] fs: export anon_inode_make_secure_inode() and fix secretmem LSM bypass
Date: Tue, 15 Jul 2025 15:14:20 +0200
Message-ID: <20250715130756.300047477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit cbe4134ea4bc493239786220bd69cb8a13493190 ]

Export anon_inode_make_secure_inode() to allow KVM guest_memfd to create
anonymous inodes with proper security context. This replaces the current
pattern of calling alloc_anon_inode() followed by
inode_init_security_anon() for creating security context manually.

This change also fixes a security regression in secretmem where the
S_PRIVATE flag was not cleared after alloc_anon_inode(), causing
LSM/SELinux checks to be bypassed for secretmem file descriptors.

As guest_memfd currently resides in the KVM module, we need to export this
symbol for use outside the core kernel. In the future, guest_memfd might be
moved to core-mm, at which point the symbols no longer would have to be
exported. When/if that happens is still unclear.

Fixes: 2bfe15c52612 ("mm: create security context for memfd_secret inodes")
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Link: https://lore.kernel.org/20250620070328.803704-3-shivankg@amd.com
Acked-by: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/anon_inodes.c   | 23 ++++++++++++++++++-----
 include/linux/fs.h |  2 ++
 mm/secretmem.c     | 11 +----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24192a7667edf..7a9b1ce9c98a1 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -55,15 +55,26 @@ static struct file_system_type anon_inode_fs_type = {
 	.kill_sb	= kill_anon_super,
 };
 
-static struct inode *anon_inode_make_secure_inode(
-	const char *name,
-	const struct inode *context_inode)
+/**
+ * anon_inode_make_secure_inode - allocate an anonymous inode with security context
+ * @sb:		[in]	Superblock to allocate from
+ * @name:	[in]	Name of the class of the newfile (e.g., "secretmem")
+ * @context_inode:
+ *		[in]	Optional parent inode for security inheritance
+ *
+ * The function ensures proper security initialization through the LSM hook
+ * security_inode_init_security_anon().
+ *
+ * Return:	Pointer to new inode on success, ERR_PTR on failure.
+ */
+struct inode *anon_inode_make_secure_inode(struct super_block *sb, const char *name,
+					   const struct inode *context_inode)
 {
 	struct inode *inode;
 	const struct qstr qname = QSTR_INIT(name, strlen(name));
 	int error;
 
-	inode = alloc_anon_inode(anon_inode_mnt->mnt_sb);
+	inode = alloc_anon_inode(sb);
 	if (IS_ERR(inode))
 		return inode;
 	inode->i_flags &= ~S_PRIVATE;
@@ -74,6 +85,7 @@ static struct inode *anon_inode_make_secure_inode(
 	}
 	return inode;
 }
+EXPORT_SYMBOL_GPL(anon_inode_make_secure_inode);
 
 static struct file *__anon_inode_getfile(const char *name,
 					 const struct file_operations *fops,
@@ -88,7 +100,8 @@ static struct file *__anon_inode_getfile(const char *name,
 		return ERR_PTR(-ENOENT);
 
 	if (secure) {
-		inode =	anon_inode_make_secure_inode(name, context_inode);
+		inode =	anon_inode_make_secure_inode(anon_inode_mnt->mnt_sb,
+						     name, context_inode);
 		if (IS_ERR(inode)) {
 			file = ERR_CAST(inode);
 			goto err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 08fba309ddc78..1a619b681bccb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3469,6 +3469,8 @@ extern int simple_write_begin(struct file *file, struct address_space *mapping,
 extern const struct address_space_operations ram_aops;
 extern int always_delete_dentry(const struct dentry *);
 extern struct inode *alloc_anon_inode(struct super_block *);
+struct inode *anon_inode_make_secure_inode(struct super_block *sb, const char *name,
+					   const struct inode *context_inode);
 extern int simple_nosetlease(struct file *, long, struct file_lock **, void **);
 extern const struct dentry_operations simple_dentry_operations;
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index c6006d765bbd2..18954eae995fc 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -193,19 +193,10 @@ static struct file *secretmem_file_create(unsigned long flags)
 	struct file *file = ERR_PTR(-ENOMEM);
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
-	const struct qstr qname = QSTR_INIT(anon_name, strlen(anon_name));
-	int err;
 
-	inode = alloc_anon_inode(secretmem_mnt->mnt_sb);
+	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
-
-	err = security_inode_init_security_anon(inode, &qname, NULL);
-	if (err) {
-		file = ERR_PTR(err);
-		goto err_free_inode;
-	}
-
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR, &secretmem_fops);
 	if (IS_ERR(file))
-- 
2.39.5



