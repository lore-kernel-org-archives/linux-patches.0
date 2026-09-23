Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFBB332EC5;
	Wed, 23 Sep 2026 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174956; cv=none; b=T7evh0ig5sFZUDO0+4RQEfX/kVxjZIxllbPitZFSK3iGiM9ThsGexxcRDoZcw8NLIzs07vEipFiFZkaf6qoXnHiR8G9OooFudz1hm0zuPxEA24EBoG1YDjP8p7aBPwVl9pSkJzDrIpbWv9GO+OUZmYxUbxiK1opucmPAOVLkaQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174956; c=relaxed/simple;
	bh=rMM7RHZlYnsE4c3NXn4PtbBb6VRHjTipgThW+JKZxBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M73UlVhSS6t4Ad4qfsYCrAMrlHk599Yh76tIAG9FBS8e6aMP4Ysrljhhdn5T9qi500gG3ulw+zpcNpTETgX/6dTJoo+0j37iv9vS9heVg1UBQ2zOxWtaNencc7F5YWaFoWY9WCLlM6Z8ot3tnCs1DODxpB1/X8wVC2wo9wNJHHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGTnLIS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGTnLIS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BCE1F000FF;
	Wed, 23 Sep 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174954;
	bh=rRjbDHhcMx/NCF4eTowu2Q4aZdN+OTudRIbhoym1ySw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGTnLIS/SY59C+zDgEs2Zsoq1bBegf7+Gb8XLYK8WUMhQoJVncMo+D2Rq0UlcTDDl
	 OcJUQJiWOyCDcwYPr3ciNNgEW1DhJul4veIros05U61vXZJadMfKBXTrU5KGDkNHMT
	 oMXvhKZPR033gVgZCtDk+3R1Rtb2fRw3w43V4eR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 275/398] selinux: recheck intermediate backing files on mprotect()
Date: Wed, 23 Sep 2026 16:05:49 +0200
Message-ID: <20260923140650.545141230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 78fc54b934bfb2c18aad8154c7302067146946f9 upstream.

mprotect() can be used to bypass the SELinux checks that mmap() performs
against the intermediate layers of a stacked filesystem.

mmap() checks every backing layer as the request descends through the
stack.  mprotect() only has the lowest backing file in vma->vm_file, so it
rechecks the top-level user and the lowest mounter, but skips the mounters
of every layer in between.  With two nested overlayfs mounts and a policy
denying mounter_t -> middle_file_t:file { execute }, a direct
mmap(PROT_EXEC) is denied:

  avc:  denied  { execute } for  pid=71 comm="nested_exec"
    path="/payload" dev="overlay" ino=9
    scontext=user_u:base_r:mounter_t
    tcontext=user_u:object_r:middle_file_t tclass=file permissive=0

while mmap(PROT_NONE) followed by mprotect(PROT_EXEC) succeeds.

Preserve each intermediate path, mounter SID and file-description SID in
the backing-file security blob, copying the saved entries when another
backing layer is opened.  Allocate the array only for nested backing files,
and release it and the path references in the backing_file_free hook.

During mprotect(), recheck fd { use } and the requested inode permissions
for every saved mounter, and include the intermediate layers in the execmod
checks.  Policy for nested stacking may then need to grant intermediate
mounters what a direct mmap() already requires, and execmod on intermediate
labels for binaries using text relocations.

Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
SELinux policy, on a mainline tree containing
commit f2381b546e7e ("fs: fix user path of nested backing files").

Cc: stable@vger.kernel.org
Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c          |  141 +++++++++++++++++++++++++++++++++-----
 security/selinux/include/objsec.h |    8 ++
 2 files changed, 133 insertions(+), 16 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1665,26 +1665,32 @@ static int cred_has_capability(const str
 	return rc;
 }
 
-/* Check whether a task has a particular permission to an inode.
-   The 'adp' parameter is optional and allows other audit
-   data to be passed (e.g. the dentry). */
-static int inode_has_perm(const struct cred *cred,
-			  struct inode *inode,
-			  u32 perms,
-			  struct common_audit_data *adp)
+/*
+ * Check whether a SID has a particular permission to an inode.  The 'adp'
+ * parameter is optional and allows other audit data to be passed (e.g. the
+ * dentry).
+ */
+static int inode_sid_has_perm(u32 sid, struct inode *inode, u32 perms,
+			      struct common_audit_data *adp)
 {
 	struct inode_security_struct *isec;
-	u32 sid;
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	sid = cred_sid(cred);
 	isec = selinux_inode(inode);
 
 	return avc_has_perm(sid, isec->sid, isec->sclass, perms, adp);
 }
 
+static int inode_has_perm(const struct cred *cred,
+			  struct inode *inode,
+			  u32 perms,
+			  struct common_audit_data *adp)
+{
+	return inode_sid_has_perm(cred_sid(cred), inode, perms, adp);
+}
+
 /* Same as inode_has_perm, but pass explicit audit data containing
    the dentry to help the auditing code to more easily generate the
    pathname if needed. */
@@ -3833,13 +3839,63 @@ static int selinux_backing_file_alloc(st
 				      const struct file *user_file)
 {
 	struct backing_file_security_struct *bfsec;
+	const struct backing_file_security_struct *ubfsec;
+	struct backing_file_security_layer *layer;
+	u32 i;
 
 	bfsec = selinux_backing_file(backing_file);
 	bfsec->uf_sid = selinux_file_user_sid(user_file);
+	if (!(user_file->f_mode & FMODE_BACKING))
+		return 0;
+
+	ubfsec = selinux_backing_file(user_file);
+	/* a wrapped count would make kmalloc_array() return ZERO_SIZE_PTR */
+	if (unlikely(ubfsec->layer_count == U32_MAX))
+		return -EOVERFLOW;
+
+	/*
+	 * The final VMA only retains the lowest backing file, so record the
+	 * whole chain here rather than in the mmap hook, where concurrent
+	 * mappings would have to be serialized.  Size it dynamically: erofs
+	 * inode sharing adds a backing file without bumping s_stack_depth.
+	 */
+	bfsec->layers = kmalloc_array(ubfsec->layer_count + 1,
+				      sizeof(*bfsec->layers), GFP_KERNEL);
+	if (!bfsec->layers)
+		return -ENOMEM;
+
+	for (i = 0; i < ubfsec->layer_count; i++) {
+		layer = &bfsec->layers[i];
+		*layer = ubfsec->layers[i];
+		path_get(&layer->path);
+	}
+
+	/* f_path, not file_user_path(): this layer, not the top-level file */
+	layer = &bfsec->layers[i];
+	layer->path = user_file->f_path;
+	layer->mounter_sid = cred_sid(user_file->f_cred);
+	layer->fd_sid = selinux_file(user_file)->sid;
+	path_get(&layer->path);
+	bfsec->layer_count = ubfsec->layer_count + 1;
 
 	return 0;
 }
 
+static void selinux_backing_file_free(struct file *backing_file)
+{
+	struct backing_file_security_struct *bfsec;
+
+	/* security_backing_file_free() may be called twice after an error */
+	if (!backing_file_security(backing_file))
+		return;
+
+	bfsec = selinux_backing_file(backing_file);
+	while (bfsec->layer_count)
+		path_put(&bfsec->layers[--bfsec->layer_count].path);
+	kfree(bfsec->layers);
+	bfsec->layers = NULL;
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3957,6 +4013,53 @@ static int selinux_file_ioctl_compat(str
 
 static int default_noexec __ro_after_init;
 
+static u32 file_map_prot_to_av(unsigned long prot, bool shared)
+{
+	u32 av = FILE__READ;
+
+	if (shared && (prot & PROT_WRITE))
+		av |= FILE__WRITE;
+	if (prot & PROT_EXEC)
+		av |= FILE__EXECUTE;
+
+	return av;
+}
+
+static int backing_mounters_has_perm(const struct file *file, u32 av)
+{
+	const struct backing_file_security_struct *bfsec;
+	const struct backing_file_security_layer *layer;
+	struct common_audit_data ad;
+	struct inode *inode;
+	u32 i;
+	int rc;
+
+	if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)))
+		return -EIO;
+
+	bfsec = selinux_backing_file(file);
+	for (i = 0; i < bfsec->layer_count; i++) {
+		layer = &bfsec->layers[i];
+		inode = d_inode(layer->path.dentry);
+
+		ad.type = LSM_AUDIT_DATA_PATH;
+		ad.u.path = layer->path;
+
+		if (layer->mounter_sid != layer->fd_sid) {
+			rc = avc_has_perm(layer->mounter_sid, layer->fd_sid,
+					  SECCLASS_FD, FD__USE, &ad);
+			if (rc)
+				return rc;
+		}
+
+		rc = inode_sid_has_perm(layer->mounter_sid, inode, av, &ad);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int __file_map_prot_check(const struct file *file, unsigned long prot,
 				 bool shared, bool mounter_check,
 				 bool bf_user_file)
@@ -3990,14 +4093,10 @@ static int __file_map_prot_check(const s
 	if (file) {
 		const struct cred *cred = mounter_check ?
 				file->f_cred : current_cred();
-		/* "read" always possible, "write" only if shared */
-		u32 av = FILE__READ;
-		if (shared && prot_write)
-			av |= FILE__WRITE;
-		if (prot_exec)
-			av |= FILE__EXECUTE;
 
-		return __file_has_perm(cred, file, av, bf_user_file);
+		return __file_has_perm(cred, file,
+				       file_map_prot_to_av(prot, shared),
+				       bf_user_file);
 	}
 
 	return 0;
@@ -4092,6 +4191,7 @@ static int selinux_file_mprotect(struct
 	int rc;
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
+	u32 av;
 	const struct file *file = vma->vm_file;
 	bool backing_file;
 	bool shared = vma->vm_flags & VM_SHARED;
@@ -4135,6 +4235,10 @@ static int selinux_file_mprotect(struct
 			if (rc)
 				return rc;
 			if (backing_file) {
+				rc = backing_mounters_has_perm(file,
+							       FILE__EXECMOD);
+				if (rc)
+					return rc;
 				rc = file_has_perm(file->f_cred, file,
 						   FILE__EXECMOD);
 				if (rc)
@@ -4147,6 +4251,10 @@ static int selinux_file_mprotect(struct
 	if (rc)
 		return rc;
 	if (backing_file) {
+		av = file_map_prot_to_av(prot, shared);
+		rc = backing_mounters_has_perm(file, av);
+		if (rc)
+			return rc;
 		rc = file_map_prot_check(file, prot, shared, true);
 		if (rc)
 			return rc;
@@ -7507,6 +7615,7 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
 	LSM_HOOK_INIT(backing_file_alloc, selinux_backing_file_alloc),
+	LSM_HOOK_INIT(backing_file_free, selinux_backing_file_free),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(file_ioctl_compat, selinux_file_ioctl_compat),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -86,8 +86,16 @@ struct file_security_struct {
 	u32 pseqno; /* Policy seqno at the time of file open */
 };
 
+struct backing_file_security_layer {
+	struct path path; /* this layer's real path */
+	u32 mounter_sid; /* SID of the mounter that opened it */
+	u32 fd_sid; /* SID of its open file description */
+};
+
 struct backing_file_security_struct {
 	u32 uf_sid; /* top-level user file fsec->sid */
+	u32 layer_count; /* number of intermediate backing files */
+	struct backing_file_security_layer *layers;
 };
 
 struct superblock_security_struct {


