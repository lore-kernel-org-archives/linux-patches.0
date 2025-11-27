Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17400334690;
	Thu, 27 Nov 2025 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255636; cv=none; b=g5F4LsshgkUAjLKrJOGBdcrnLQ9K+dW197Er0jI/xc5t3SXpSLB0fNm2YwAs7Hi/2blcvwj4O5LhugDkjK2FsmSXtx8PxdlA4tFsWZc/ldo5W/c8s6nqpVRhCFnt5suQua4/uNcqXwt4SFY3kpYsPiVGRCBWxNC5fVICS8lRRVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255636; c=relaxed/simple;
	bh=J8ZgwcKOdkUtc9HGu4agGwWtQy4i1mtVdke+zoVmJD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1ABgr4xc8P5BGvBbKPEbIaVWQ1oZyOR8+kvfI74Ah0x8a9kmDFhDSbQkpDzaHHSUtQRlRkhZ4JKzLbGvyDw4TCXA29B9N55DMNjFx7z2zW94Huq6rNqCtWSAHJWy/sLfzmrDd8Awzt4jcM2ufJe/dWlW+oV+8zp+mWCM+BJY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9gX7cpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9gX7cpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968BEC113D0;
	Thu, 27 Nov 2025 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255636;
	bh=J8ZgwcKOdkUtc9HGu4agGwWtQy4i1mtVdke+zoVmJD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9gX7cpydKrfvSiJrwYFNnkMFGF75Mr3+EW7rf+1H1UFHq3ru5GWegUaCk94ma8Vr
	 uJy4teXOcy7oRvjlyHTyArrrfj4ofl4z+1j9QoajxhenRHPo8/iyVX6Xe4eY+aGBPf
	 kpffnevf7W9VAlbdvJU7S73nY3Iu/86czGp+/YBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.17 028/175] selinux: move avdcache to per-task security struct
Date: Thu, 27 Nov 2025 15:44:41 +0100
Message-ID: <20251127144043.993581894@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit dde3a5d0f4dce1d1a6095e6b8eeb59b75d28fb3b upstream.

The avdcache is meant to be per-task; move it to a new
task_security_struct that is duplicated per-task.

Cc: stable@vger.kernel.org
Fixes: 5d7ddc59b3d89b724a5aa8f30d0db94ff8d2d93f ("selinux: reduce path walk overhead")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: line length fixes]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c          |   31 ++++++++++++++++++-------------
 security/selinux/include/objsec.h |   14 ++++++++++++--
 2 files changed, 30 insertions(+), 15 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -215,7 +215,7 @@ static void cred_init_security(void)
 	/* NOTE: the lsm framework zeros out the buffer on allocation */
 
 	tsec = selinux_cred(unrcu_pointer(current->real_cred));
-	tsec->osid = tsec->sid = tsec->avdcache.sid = SECINITSID_KERNEL;
+	tsec->osid = tsec->sid = SECINITSID_KERNEL;
 }
 
 /*
@@ -3106,10 +3106,10 @@ static noinline int audit_inode_permissi
  * Clear the task's AVD cache in @tsec and reset it to the current policy's
  * and task's info.
  */
-static inline void task_avdcache_reset(struct cred_security_struct *tsec)
+static inline void task_avdcache_reset(struct task_security_struct *tsec)
 {
 	memset(&tsec->avdcache.dir, 0, sizeof(tsec->avdcache.dir));
-	tsec->avdcache.sid = tsec->sid;
+	tsec->avdcache.sid = current_sid();
 	tsec->avdcache.seqno = avc_policy_seqno();
 	tsec->avdcache.dir_spot = TSEC_AVDC_DIR_SIZE - 1;
 }
@@ -3123,7 +3123,7 @@ static inline void task_avdcache_reset(s
  * Search @tsec for a AVD cache entry that matches @isec and return it to the
  * caller via @avdc.  Returns 0 if a match is found, negative values otherwise.
  */
-static inline int task_avdcache_search(struct cred_security_struct *tsec,
+static inline int task_avdcache_search(struct task_security_struct *tsec,
 				       struct inode_security_struct *isec,
 				       struct avdc_entry **avdc)
 {
@@ -3133,7 +3133,7 @@ static inline int task_avdcache_search(s
 	if (isec->sclass != SECCLASS_DIR)
 		return -ENOENT;
 
-	if (unlikely(tsec->sid != tsec->avdcache.sid ||
+	if (unlikely(current_sid() != tsec->avdcache.sid ||
 		     tsec->avdcache.seqno != avc_policy_seqno())) {
 		task_avdcache_reset(tsec);
 		return -ENOENT;
@@ -3163,7 +3163,7 @@ static inline int task_avdcache_search(s
  * Update the AVD cache in @tsec with the @avdc and @audited info associated
  * with @isec.
  */
-static inline void task_avdcache_update(struct cred_security_struct *tsec,
+static inline void task_avdcache_update(struct task_security_struct *tsec,
 					struct inode_security_struct *isec,
 					struct av_decision *avd,
 					u32 audited)
@@ -3197,7 +3197,8 @@ static int selinux_inode_permission(stru
 {
 	int mask;
 	u32 perms;
-	struct cred_security_struct *tsec;
+	u32 sid = current_sid();
+	struct task_security_struct *tsec;
 	struct inode_security_struct *isec;
 	struct avdc_entry *avdc;
 	int rc, rc2;
@@ -3209,8 +3210,8 @@ static int selinux_inode_permission(stru
 	if (!mask)
 		return 0;
 
-	tsec = selinux_cred(current_cred());
-	if (task_avdcache_permnoaudit(tsec))
+	tsec = selinux_task(current);
+	if (task_avdcache_permnoaudit(tsec, sid))
 		return 0;
 
 	isec = inode_security_rcu(inode, requested & MAY_NOT_BLOCK);
@@ -3230,7 +3231,7 @@ static int selinux_inode_permission(stru
 		struct av_decision avd;
 
 		/* Cache miss. */
-		rc = avc_has_perm_noaudit(tsec->sid, isec->sid, isec->sclass,
+		rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass,
 					  perms, 0, &avd);
 		audited = avc_audit_required(perms, &avd, rc,
 			(requested & MAY_ACCESS) ? FILE__AUDIT_ACCESS : 0,
@@ -3279,11 +3280,11 @@ static int selinux_inode_setattr(struct
 
 static int selinux_inode_getattr(const struct path *path)
 {
-	struct cred_security_struct *tsec;
+	struct task_security_struct *tsec;
 
-	tsec = selinux_cred(current_cred());
+	tsec = selinux_task(current);
 
-	if (task_avdcache_permnoaudit(tsec))
+	if (task_avdcache_permnoaudit(tsec, current_sid()))
 		return 0;
 
 	return path_has_perm(current_cred(), path, FILE__GETATTR);
@@ -4147,7 +4148,10 @@ static int selinux_task_alloc(struct tas
 			      unsigned long clone_flags)
 {
 	u32 sid = current_sid();
+	struct task_security_struct *old_tsec = selinux_task(current);
+	struct task_security_struct *new_tsec = selinux_task(task);
 
+	*new_tsec = *old_tsec;
 	return avc_has_perm(sid, sid, SECCLASS_PROCESS, PROCESS__FORK, NULL);
 }
 
@@ -7170,6 +7174,7 @@ static void selinux_bpf_token_free(struc
 
 struct lsm_blob_sizes selinux_blob_sizes __ro_after_init = {
 	.lbs_cred = sizeof(struct cred_security_struct),
+	.lbs_task = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
 	.lbs_inode = sizeof(struct inode_security_struct),
 	.lbs_ipc = sizeof(struct ipc_security_struct),
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -43,6 +43,9 @@ struct cred_security_struct {
 	u32 create_sid; /* fscreate SID */
 	u32 keycreate_sid; /* keycreate SID */
 	u32 sockcreate_sid; /* fscreate SID */
+} __randomize_layout;
+
+struct task_security_struct {
 #define TSEC_AVDC_DIR_SIZE (1 << 2)
 	struct {
 		u32 sid; /* current SID for cached entries */
@@ -53,10 +56,11 @@ struct cred_security_struct {
 	} avdcache;
 } __randomize_layout;
 
-static inline bool task_avdcache_permnoaudit(struct cred_security_struct *tsec)
+static inline bool task_avdcache_permnoaudit(struct task_security_struct *tsec,
+					     u32 sid)
 {
 	return (tsec->avdcache.permissive_neveraudit &&
-		tsec->sid == tsec->avdcache.sid &&
+		sid == tsec->avdcache.sid &&
 		tsec->avdcache.seqno == avc_policy_seqno());
 }
 
@@ -176,6 +180,12 @@ static inline struct cred_security_struc
 	return cred->security + selinux_blob_sizes.lbs_cred;
 }
 
+static inline struct task_security_struct *
+selinux_task(const struct task_struct *task)
+{
+	return task->security + selinux_blob_sizes.lbs_task;
+}
+
 static inline struct file_security_struct *selinux_file(const struct file *file)
 {
 	return file->f_security + selinux_blob_sizes.lbs_file;


