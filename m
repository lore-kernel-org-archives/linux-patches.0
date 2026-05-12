Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374A3955EF;
	Tue, 12 May 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608407; cv=none; b=MCwLtjqby/3+Fk5UQhA8hbTnFjM0GNq7xsKLZhdTyJ3XT8SauiyZ21Ul4jy2+MHwsqDRhtpUcIRx5cWQsuLrWFbuWdAlotTMmEGkzQZnqiL3dSY4B/Oy8h/ujrDEWoFmaSaR5Wz7UTeCPCEeqD/Erw7JUbfG2iff+Hz29aWgkxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608407; c=relaxed/simple;
	bh=+Lxrlb9WzL/LrZiJ8NTdLrSA0WaXM1AHo4J/f9ArJYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCdc17wQbDlPEwKhaT/BcfIxGeKgCqdTCZB7FQgN9sXyxWh1RSPyJajtHNZSoKXos5lFdDqTPdWpoO6q/pTX2hIjUkFpmAS2CKFGQrhX/ky2ZutXIjDukACv5lIG6NYNcIz2hJinY2paookXIo8bRbRjqLmFfT7BG+TlFFP1bvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vodwju3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vodwju3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5FAC2BCB0;
	Tue, 12 May 2026 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608407;
	bh=+Lxrlb9WzL/LrZiJ8NTdLrSA0WaXM1AHo4J/f9ArJYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vodwju3rDrLdLCop+JyO3IKS9w26G5/KoJyxi8ooA/XlKdIS7FFffigReVBjA6spZ
	 8fx+hACMqT869lH8PUM8SiS0QghhZwddi2n2x7+Ob/coz9AQdNt6yb08WW37XSGJp4
	 yhkT2SeXY4vKGyMhV5uAhkz33+y0u7x5owBMUsP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 066/270] selinux: prune /sys/fs/selinux/user
Date: Tue, 12 May 2026 19:37:47 +0200
Message-ID: <20260512173939.840575522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit ad1ac3d740cc6b858a99ab9c45c8c0574be7d1d3 upstream.

Remove the previously deprecated /sys/fs/selinux/user interface aside
from a residual stub for userspace compatibility.

Commit d7b6918e22c7 ("selinux: Deprecate /sys/fs/selinux/user") started
the deprecation process for /sys/fs/selinux/user:

    The selinuxfs "user" node allows userspace to request a list
    of security contexts that can be reached for a given SELinux
    user from a given starting context. This was used by libselinux
    when various login-style programs requested contexts for
    users, but libselinux stopped using it in 2020.
    Kernel support will be removed no sooner than Dec 2025.

A pr_warn() message has been in place since Linux v6.13, and a 5
second sleep was introduced since Linux v6.17 to help make it more
noticeable.

We are now past the stated deadline of Dec 2025, so remove the
underlying functionality and replace it with a stub that returns a
'0\0' buffer to avoid breaking userspace. This also avoids a local DoS
from logspam and an uninterruptible sleep delay.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../{obsolete => removed}/sysfs-selinux-user  |   0
 Documentation/ABI/obsolete/sysfs-selinux-user |   12 --
 Documentation/ABI/removed/sysfs-selinux-user  |   12 ++
 security/selinux/include/security.h           |    2 
 security/selinux/selinuxfs.c                  |   68 +-------------
 security/selinux/ss/services.c                |  125 --------------------------
 5 files changed, 17 insertions(+), 202 deletions(-)
 rename Documentation/ABI/{obsolete => removed}/sysfs-selinux-user (100%)

--- a/Documentation/ABI/obsolete/sysfs-selinux-user
+++ /dev/null
@@ -1,12 +0,0 @@
-What:		/sys/fs/selinux/user
-Date:		April 2005 (predates git)
-KernelVersion:	2.6.12-rc2 (predates git)
-Contact:	selinux@vger.kernel.org
-Description:
-
-	The selinuxfs "user" node allows userspace to request a list
-	of security contexts that can be reached for a given SELinux
-	user from a given starting context. This was used by libselinux
-	when various login-style programs requested contexts for
-	users, but libselinux stopped using it in 2020.
-	Kernel support will be removed no sooner than Dec 2025.
--- /dev/null
+++ b/Documentation/ABI/removed/sysfs-selinux-user
@@ -0,0 +1,12 @@
+What:		/sys/fs/selinux/user
+Date:		April 2005 (predates git)
+KernelVersion:	2.6.12-rc2 (predates git)
+Contact:	selinux@vger.kernel.org
+Description:
+
+	The selinuxfs "user" node allows userspace to request a list
+	of security contexts that can be reached for a given SELinux
+	user from a given starting context. This was used by libselinux
+	when various login-style programs requested contexts for
+	users, but libselinux stopped using it in 2020.
+	Kernel support will be removed no sooner than Dec 2025.
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -301,8 +301,6 @@ int security_context_to_sid_default(cons
 int security_context_to_sid_force(const char *scontext, u32 scontext_len,
 				  u32 *sid);
 
-int security_get_user_sids(u32 fromsid, const char *username, u32 **sids, u32 *nel);
-
 int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
 int security_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1005,69 +1005,11 @@ out:
 
 static ssize_t sel_write_user(struct file *file, char *buf, size_t size)
 {
-	char *con = NULL, *user = NULL, *ptr;
-	u32 sid, *sids = NULL;
-	ssize_t length;
-	char *newcon;
-	int rc;
-	u32 i, len, nsids;
-
-	pr_warn_ratelimited("SELinux: %s (%d) wrote to /sys/fs/selinux/user!"
-		" This will not be supported in the future; please update your"
-		" userspace.\n", current->comm, current->pid);
-	ssleep(5);
-
-	length = avc_has_perm(current_sid(), SECINITSID_SECURITY,
-			      SECCLASS_SECURITY, SECURITY__COMPUTE_USER,
-			      NULL);
-	if (length)
-		goto out;
-
-	length = -ENOMEM;
-	con = kzalloc(size + 1, GFP_KERNEL);
-	if (!con)
-		goto out;
-
-	length = -ENOMEM;
-	user = kzalloc(size + 1, GFP_KERNEL);
-	if (!user)
-		goto out;
-
-	length = -EINVAL;
-	if (sscanf(buf, "%s %s", con, user) != 2)
-		goto out;
-
-	length = security_context_str_to_sid(con, &sid, GFP_KERNEL);
-	if (length)
-		goto out;
-
-	length = security_get_user_sids(sid, user, &sids, &nsids);
-	if (length)
-		goto out;
-
-	length = sprintf(buf, "%u", nsids) + 1;
-	ptr = buf + length;
-	for (i = 0; i < nsids; i++) {
-		rc = security_sid_to_context(sids[i], &newcon, &len);
-		if (rc) {
-			length = rc;
-			goto out;
-		}
-		if ((length + len) >= SIMPLE_TRANSACTION_LIMIT) {
-			kfree(newcon);
-			length = -ERANGE;
-			goto out;
-		}
-		memcpy(ptr, newcon, len);
-		kfree(newcon);
-		ptr += len;
-		length += len;
-	}
-out:
-	kfree(sids);
-	kfree(user);
-	kfree(con);
-	return length;
+	pr_err_once("SELinux: %s (%d) wrote to user. This is no longer supported.\n",
+		    current->comm, current->pid);
+	buf[0] = '0';
+	buf[1] = 0;
+	return 2;
 }
 
 static ssize_t sel_write_member(struct file *file, char *buf, size_t size)
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2746,131 +2746,6 @@ out:
 	return rc;
 }
 
-#define SIDS_NEL 25
-
-/**
- * security_get_user_sids - Obtain reachable SIDs for a user.
- * @fromsid: starting SID
- * @username: username
- * @sids: array of reachable SIDs for user
- * @nel: number of elements in @sids
- *
- * Generate the set of SIDs for legal security contexts
- * for a given user that can be reached by @fromsid.
- * Set *@sids to point to a dynamically allocated
- * array containing the set of SIDs.  Set *@nel to the
- * number of elements in the array.
- */
-
-int security_get_user_sids(u32 fromsid,
-			   const char *username,
-			   u32 **sids,
-			   u32 *nel)
-{
-	struct selinux_policy *policy;
-	struct policydb *policydb;
-	struct sidtab *sidtab;
-	struct context *fromcon, usercon;
-	u32 *mysids = NULL, *mysids2, sid;
-	u32 i, j, mynel, maxnel = SIDS_NEL;
-	struct user_datum *user;
-	struct role_datum *role;
-	struct ebitmap_node *rnode, *tnode;
-	int rc;
-
-	*sids = NULL;
-	*nel = 0;
-
-	if (!selinux_initialized())
-		return 0;
-
-	mysids = kcalloc(maxnel, sizeof(*mysids), GFP_KERNEL);
-	if (!mysids)
-		return -ENOMEM;
-
-retry:
-	mynel = 0;
-	rcu_read_lock();
-	policy = rcu_dereference(selinux_state.policy);
-	policydb = &policy->policydb;
-	sidtab = policy->sidtab;
-
-	context_init(&usercon);
-
-	rc = -EINVAL;
-	fromcon = sidtab_search(sidtab, fromsid);
-	if (!fromcon)
-		goto out_unlock;
-
-	rc = -EINVAL;
-	user = symtab_search(&policydb->p_users, username);
-	if (!user)
-		goto out_unlock;
-
-	usercon.user = user->value;
-
-	ebitmap_for_each_positive_bit(&user->roles, rnode, i) {
-		role = policydb->role_val_to_struct[i];
-		usercon.role = i + 1;
-		ebitmap_for_each_positive_bit(&role->types, tnode, j) {
-			usercon.type = j + 1;
-
-			if (mls_setup_user_range(policydb, fromcon, user,
-						 &usercon))
-				continue;
-
-			rc = sidtab_context_to_sid(sidtab, &usercon, &sid);
-			if (rc == -ESTALE) {
-				rcu_read_unlock();
-				goto retry;
-			}
-			if (rc)
-				goto out_unlock;
-			if (mynel < maxnel) {
-				mysids[mynel++] = sid;
-			} else {
-				rc = -ENOMEM;
-				maxnel += SIDS_NEL;
-				mysids2 = kcalloc(maxnel, sizeof(*mysids2), GFP_ATOMIC);
-				if (!mysids2)
-					goto out_unlock;
-				memcpy(mysids2, mysids, mynel * sizeof(*mysids2));
-				kfree(mysids);
-				mysids = mysids2;
-				mysids[mynel++] = sid;
-			}
-		}
-	}
-	rc = 0;
-out_unlock:
-	rcu_read_unlock();
-	if (rc || !mynel) {
-		kfree(mysids);
-		return rc;
-	}
-
-	rc = -ENOMEM;
-	mysids2 = kcalloc(mynel, sizeof(*mysids2), GFP_KERNEL);
-	if (!mysids2) {
-		kfree(mysids);
-		return rc;
-	}
-	for (i = 0, j = 0; i < mynel; i++) {
-		struct av_decision dummy_avd;
-		rc = avc_has_perm_noaudit(fromsid, mysids[i],
-					  SECCLASS_PROCESS, /* kernel value */
-					  PROCESS__TRANSITION, AVC_STRICT,
-					  &dummy_avd);
-		if (!rc)
-			mysids2[j++] = mysids[i];
-		cond_resched();
-	}
-	kfree(mysids);
-	*sids = mysids2;
-	*nel = j;
-	return 0;
-}
-
 /**
  * __security_genfs_sid - Helper to obtain a SID for a file in a filesystem
  * @policy: policy


