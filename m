Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2033A9CF;
	Thu, 12 Mar 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347332; cv=none; b=FCmf1RwXRvTRpzP6LQ+VEpnXuEBjwKI9HjP+UDCWjl+cjaD/9hbSDhs4dLQu0NwXI8tr29Ps+gTws4UbUJM8J5UPlkzSv87adMVS2YLCnphcN0LAFRK2or+xxwK6+/7eAFQ4vHdpcBiFp6EXeOtSHsjfuACljeEr8tAvXa04s+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347332; c=relaxed/simple;
	bh=BJhHt+dyswVlePrmqWZhTrlgpL5W+GGZt2ddlMfBtO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xont4ZPsw1HWAakWa8Db5PRBJQjYe3Ed1HnXAxTpzMh8TFJA3QT4/ckgQWXD8i9OumA+swWxQNG47LaG1rU9PjFlKct0V7anOWMnSeBXI/ySvFiGx94WCw6Zy0Aig33MGuCoGzy0Fueu01YGBYNqd4VxXnxEkafJ9p/PI3BOJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGYdLzmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGYdLzmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F9C4CEF7;
	Thu, 12 Mar 2026 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347332;
	bh=BJhHt+dyswVlePrmqWZhTrlgpL5W+GGZt2ddlMfBtO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGYdLzmYOz1Sxaz0TPKx2Nc3Szeh1JoGeiiPBd/kurG+On0c2/lW/IBxx+F0njncl
	 dGLOK3TgDWbno6QakP1CzdHZ/gZHAt0c1EGIf8FYvs7otFcVzKekgtrj1/vWeaiuOB
	 G6TzZFa5+DG8Zz3OUBjM/mqj+Krb1Obuvo2rJm1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 257/265] apparmor: fix unprivileged local user can do privileged policy management
Date: Thu, 12 Mar 2026 21:10:44 +0100
Message-ID: <20260312201027.631677933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 6601e13e82841879406bf9f369032656f441a425 upstream.

An unprivileged local user can load, replace, and remove profiles by
opening the apparmorfs interfaces, via a confused deputy attack, by
passing the opened fd to a privileged process, and getting the
privileged process to write to the interface.

This does require a privileged target that can be manipulated to do
the write for the unprivileged process, but once such access is
achieved full policy management is possible and all the possible
implications that implies: removing confinement, DoS of system or
target applications by denying all execution, by-passing the
unprivileged user namespace restriction, to exploiting kernel bugs for
a local privilege escalation.

The policy management interface can not have its permissions simply
changed from 0666 to 0600 because non-root processes need to be able
to load policy to different policy namespaces.

Instead ensure the task writing the interface has privileges that
are a subset of the task that opened the interface. This is already
done via policy for confined processes, but unconfined can delegate
access to the opened fd, by-passing the usual policy check.

Fixes: b7fd2c0340eac ("apparmor: add per policy ns .load, .replace, .remove interface files")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/apparmorfs.c     |   16 +++++++++-------
 security/apparmor/include/policy.h |    2 +-
 security/apparmor/policy.c         |   34 +++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 9 deletions(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -412,7 +412,8 @@ static struct aa_loaddata *aa_simple_wri
 }
 
 static ssize_t policy_update(u32 mask, const char __user *buf, size_t size,
-			     loff_t *pos, struct aa_ns *ns)
+			     loff_t *pos, struct aa_ns *ns,
+			     const struct cred *ocred)
 {
 	struct aa_loaddata *data;
 	struct aa_label *label;
@@ -423,7 +424,7 @@ static ssize_t policy_update(u32 mask, c
 	/* high level check about policy management - fine grained in
 	 * below after unpack
 	 */
-	error = aa_may_manage_policy(current_cred(), label, ns, mask);
+	error = aa_may_manage_policy(current_cred(), label, ns, ocred, mask);
 	if (error)
 		goto end_section;
 
@@ -444,7 +445,8 @@ static ssize_t profile_load(struct file
 			    loff_t *pos)
 {
 	struct aa_ns *ns = aa_get_ns(f->f_inode->i_private);
-	int error = policy_update(AA_MAY_LOAD_POLICY, buf, size, pos, ns);
+	int error = policy_update(AA_MAY_LOAD_POLICY, buf, size, pos, ns,
+				  f->f_cred);
 
 	aa_put_ns(ns);
 
@@ -462,7 +464,7 @@ static ssize_t profile_replace(struct fi
 {
 	struct aa_ns *ns = aa_get_ns(f->f_inode->i_private);
 	int error = policy_update(AA_MAY_LOAD_POLICY | AA_MAY_REPLACE_POLICY,
-				  buf, size, pos, ns);
+				  buf, size, pos, ns, f->f_cred);
 	aa_put_ns(ns);
 
 	return error;
@@ -487,7 +489,7 @@ static ssize_t profile_remove(struct fil
 	 * below after unpack
 	 */
 	error = aa_may_manage_policy(current_cred(), label, ns,
-				     AA_MAY_REMOVE_POLICY);
+				     f->f_cred, AA_MAY_REMOVE_POLICY);
 	if (error)
 		goto out;
 
@@ -1813,7 +1815,7 @@ static int ns_mkdir_op(struct mnt_idmap
 	int error;
 
 	label = begin_current_label_crit_section();
-	error = aa_may_manage_policy(current_cred(), label, NULL,
+	error = aa_may_manage_policy(current_cred(), label, NULL, NULL,
 				     AA_MAY_LOAD_POLICY);
 	end_current_label_crit_section(label);
 	if (error)
@@ -1863,7 +1865,7 @@ static int ns_rmdir_op(struct inode *dir
 	int error;
 
 	label = begin_current_label_crit_section();
-	error = aa_may_manage_policy(current_cred(), label, NULL,
+	error = aa_may_manage_policy(current_cred(), label, NULL, NULL,
 				     AA_MAY_LOAD_POLICY);
 	end_current_label_crit_section(label);
 	if (error)
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -393,7 +393,7 @@ bool aa_policy_admin_capable(const struc
 			     struct aa_label *label, struct aa_ns *ns);
 int aa_may_manage_policy(const struct cred *subj_cred,
 			 struct aa_label *label, struct aa_ns *ns,
-			 u32 mask);
+			 const struct cred *ocred, u32 mask);
 bool aa_current_policy_view_capable(struct aa_ns *ns);
 bool aa_current_policy_admin_capable(struct aa_ns *ns);
 
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -894,17 +894,44 @@ bool aa_current_policy_admin_capable(str
 	return res;
 }
 
+static bool is_subset_of_obj_privilege(const struct cred *cred,
+				       struct aa_label *label,
+				       const struct cred *ocred)
+{
+	if (cred == ocred)
+		return true;
+
+	if (!aa_label_is_subset(label, cred_label(ocred)))
+		return false;
+	/* don't allow crossing userns for now */
+	if (cred->user_ns != ocred->user_ns)
+		return false;
+	if (!cap_issubset(cred->cap_inheritable, ocred->cap_inheritable))
+		return false;
+	if (!cap_issubset(cred->cap_permitted, ocred->cap_permitted))
+		return false;
+	if (!cap_issubset(cred->cap_effective, ocred->cap_effective))
+		return false;
+	if (!cap_issubset(cred->cap_bset, ocred->cap_bset))
+		return false;
+	if (!cap_issubset(cred->cap_ambient, ocred->cap_ambient))
+		return false;
+	return true;
+}
+
+
 /**
  * aa_may_manage_policy - can the current task manage policy
  * @subj_cred: subjects cred
  * @label: label to check if it can manage policy
  * @ns: namespace being managed by @label (may be NULL if @label's ns)
+ * @ocred: object cred if request is coming from an open object
  * @mask: contains the policy manipulation operation being done
  *
  * Returns: 0 if the task is allowed to manipulate policy else error
  */
 int aa_may_manage_policy(const struct cred *subj_cred, struct aa_label *label,
-			 struct aa_ns *ns, u32 mask)
+			 struct aa_ns *ns, const struct cred *ocred, u32 mask)
 {
 	const char *op;
 
@@ -920,6 +947,11 @@ int aa_may_manage_policy(const struct cr
 		return audit_policy(label, op, NULL, NULL, "policy_locked",
 				    -EACCES);
 
+	if (ocred && !is_subset_of_obj_privilege(subj_cred, label, ocred))
+		return audit_policy(label, op, NULL, NULL,
+				    "not privileged for target profile",
+				    -EACCES);
+
 	if (!aa_policy_admin_capable(subj_cred, label, ns))
 		return audit_policy(label, op, NULL, NULL, "not policy admin",
 				    -EACCES);


