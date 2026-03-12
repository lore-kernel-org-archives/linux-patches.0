Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D82C17A0;
	Thu, 12 Mar 2026 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345848; cv=none; b=tZsImd+ov3jkKZYdoqhpTky5GMPIjLaG0EXp0qLJJhc6p5au59jgBPlKJxCdG3A0kSsycRjyNDwD6I9tu64CfSFS9DwQFx1IX3rIyzN6G09z0AR2MREIHCUW8cPAAS/lRlQs8N5BdJQNxuGdQPTxyBmIlQCVGDzc9YMKlj+U7Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345848; c=relaxed/simple;
	bh=HXWVuKchCOj74HRFcP5cE5SAyeMBPWCl6wOzIidMBXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4R030s5n4cLp50PoC1EQu0lM8XRXybgt/PZ6d7FTQNqEVG5fD8EMpAvRXqRLJh91FRoVz1koeHtGFyWYT6KZK3MGWt7BDZSLVMmpwtuoZEU6seQKlJy/IbwkUrzCqykpQAGYM05zQiKlRB/L0ztBtfnRHqXBxWFN+xjKKnBOQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J92Nx5YR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J92Nx5YR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19188C4CEF7;
	Thu, 12 Mar 2026 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345847;
	bh=HXWVuKchCOj74HRFcP5cE5SAyeMBPWCl6wOzIidMBXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J92Nx5YRW1/QiPt2KOJeVaRfDYKawYMZF3JsNW/QS1/kFabnd/UkwnJbyRPXSL7uO
	 IFSg5yaM1XABghxEf5ncrdBNEmxLplBxc2sv1VZsR7ZnpDJPrIKkdzqwPqa9ncluxG
	 kzPA2i1nt3dijTGqn5D9TzJdHhOQvBmGLysNdDqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.19 10/13] apparmor: fix unprivileged local user can do privileged policy management
Date: Thu, 12 Mar 2026 21:03:42 +0100
Message-ID: <20260312200322.050323410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -417,7 +417,8 @@ static struct aa_loaddata *aa_simple_wri
 }
 
 static ssize_t policy_update(u32 mask, const char __user *buf, size_t size,
-			     loff_t *pos, struct aa_ns *ns)
+			     loff_t *pos, struct aa_ns *ns,
+			     const struct cred *ocred)
 {
 	struct aa_loaddata *data;
 	struct aa_label *label;
@@ -428,7 +429,7 @@ static ssize_t policy_update(u32 mask, c
 	/* high level check about policy management - fine grained in
 	 * below after unpack
 	 */
-	error = aa_may_manage_policy(current_cred(), label, ns, mask);
+	error = aa_may_manage_policy(current_cred(), label, ns, ocred, mask);
 	if (error)
 		goto end_section;
 
@@ -449,7 +450,8 @@ static ssize_t profile_load(struct file
 			    loff_t *pos)
 {
 	struct aa_ns *ns = aa_get_ns(f->f_inode->i_private);
-	int error = policy_update(AA_MAY_LOAD_POLICY, buf, size, pos, ns);
+	int error = policy_update(AA_MAY_LOAD_POLICY, buf, size, pos, ns,
+				  f->f_cred);
 
 	aa_put_ns(ns);
 
@@ -467,7 +469,7 @@ static ssize_t profile_replace(struct fi
 {
 	struct aa_ns *ns = aa_get_ns(f->f_inode->i_private);
 	int error = policy_update(AA_MAY_LOAD_POLICY | AA_MAY_REPLACE_POLICY,
-				  buf, size, pos, ns);
+				  buf, size, pos, ns, f->f_cred);
 	aa_put_ns(ns);
 
 	return error;
@@ -492,7 +494,7 @@ static ssize_t profile_remove(struct fil
 	 * below after unpack
 	 */
 	error = aa_may_manage_policy(current_cred(), label, ns,
-				     AA_MAY_REMOVE_POLICY);
+				     f->f_cred, AA_MAY_REMOVE_POLICY);
 	if (error)
 		goto out;
 
@@ -1826,7 +1828,7 @@ static struct dentry *ns_mkdir_op(struct
 	int error;
 
 	label = begin_current_label_crit_section();
-	error = aa_may_manage_policy(current_cred(), label, NULL,
+	error = aa_may_manage_policy(current_cred(), label, NULL, NULL,
 				     AA_MAY_LOAD_POLICY);
 	end_current_label_crit_section(label);
 	if (error)
@@ -1876,7 +1878,7 @@ static int ns_rmdir_op(struct inode *dir
 	int error;
 
 	label = begin_current_label_crit_section();
-	error = aa_may_manage_policy(current_cred(), label, NULL,
+	error = aa_may_manage_policy(current_cred(), label, NULL, NULL,
 				     AA_MAY_LOAD_POLICY);
 	end_current_label_crit_section(label);
 	if (error)
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -419,7 +419,7 @@ bool aa_policy_admin_capable(const struc
 			     struct aa_label *label, struct aa_ns *ns);
 int aa_may_manage_policy(const struct cred *subj_cred,
 			 struct aa_label *label, struct aa_ns *ns,
-			 u32 mask);
+			 const struct cred *ocred, u32 mask);
 bool aa_current_policy_view_capable(struct aa_ns *ns);
 bool aa_current_policy_admin_capable(struct aa_ns *ns);
 
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -925,17 +925,44 @@ bool aa_current_policy_admin_capable(str
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
 
@@ -951,6 +978,11 @@ int aa_may_manage_policy(const struct cr
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


