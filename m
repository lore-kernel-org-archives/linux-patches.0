Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107103446C7;
	Tue, 16 Dec 2025 11:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885002; cv=none; b=DV+m2b8iG04b1K9qScO/3l5emjAd+3F5TcXaqSAzNHFtObtYEvXd2BgjS07hhn1uTw84DgpNyZY9gCsiiQJoVGulXlOtsBAwGkPSmT8x1E3+yBNwTspTlh2SPxyDNEagOit+f2TC0sP6sbpiu1/99EuNLh95T4Poh7JwE2v0k68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885002; c=relaxed/simple;
	bh=PH8l/L5AcARdvoBF9w3Ga+Z8WJviEA9DiGe6jHG/OdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzj/+/XsOYjwWYnmqYrxJuVm4oSUhEP0PKPMZIgNisA6P9kqXYeBVKj52EoLqn/SnyVeisFaRPH0ZERy3MeTb6uMILsMAZ8Ue9UOEoFt9BrwVc6kdllUKeimfiOKHkSwN2Ub3EuED5YAvBzKAT6mF9p6ciYHiKsc7oD/x5D+zak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqSU78jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqSU78jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A82C4CEF1;
	Tue, 16 Dec 2025 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885001;
	bh=PH8l/L5AcARdvoBF9w3Ga+Z8WJviEA9DiGe6jHG/OdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqSU78jTahdCfgIhMAWcOTSjAy/ACgOWeAK9uCs15ZNG+fGkPmxtY9lK2nqbVnPUZ
	 MZLTvMMeKgGJwmKYv5EOgwYzbudzb9eNzYRaMD35oBVhG7Zv3P9tBvdPvqPKIdwdZJ
	 u+UeJSjBww6JZdg975SIBfNo3HW60u/TcGgcxbwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 001/507] smack: deduplicate "does access rule request transmutation"
Date: Tue, 16 Dec 2025 12:07:22 +0100
Message-ID: <20251216111345.582159663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 635a01da8385fc00a144ec24684100bd1aa9db11 ]

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 78fc6a94be25 ("smack: fix bug: invalid label of unix socket file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 57 +++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fc340a6f0ddea..8629e58ea4fa1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -962,6 +962,24 @@ static int smack_inode_alloc_security(struct inode *inode)
 	return 0;
 }
 
+/**
+ * smk_rule_transmutes - does access rule for (subject,object) contain 't'?
+ * @subject: a pointer to the subject's Smack label entry
+ * @object: a pointer to the object's Smack label entry
+ */
+static bool
+smk_rule_transmutes(struct smack_known *subject,
+	      const struct smack_known *object)
+{
+	int may;
+
+	rcu_read_lock();
+	may = smk_access_entry(subject->smk_known, object->smk_known,
+			       &subject->smk_rules);
+	rcu_read_unlock();
+	return (may > 0) && (may & MAY_TRANSMUTE);
+}
+
 /**
  * smack_inode_init_security - copy out the smack from an inode
  * @inode: the newly created inode
@@ -977,23 +995,19 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     struct xattr *xattrs, int *xattr_count)
 {
 	struct task_smack *tsp = smack_cred(current_cred());
-	struct inode_smack *issp = smack_inode(inode);
-	struct smack_known *skp = smk_of_task(tsp);
-	struct smack_known *isp = smk_of_inode(inode);
+	struct inode_smack * const issp = smack_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
 	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
-	int may;
+	bool trans_cred;
+	bool trans_rule;
 
 	/*
 	 * If equal, transmuting already occurred in
 	 * smack_dentry_create_files_as(). No need to check again.
 	 */
-	if (tsp->smk_task != tsp->smk_transmuted) {
-		rcu_read_lock();
-		may = smk_access_entry(skp->smk_known, dsp->smk_known,
-				       &skp->smk_rules);
-		rcu_read_unlock();
-	}
+	trans_cred = (tsp->smk_task == tsp->smk_transmuted);
+	if (!trans_cred)
+		trans_rule = smk_rule_transmutes(smk_of_task(tsp), dsp);
 
 	/*
 	 * In addition to having smk_task equal to smk_transmuted,
@@ -1001,9 +1015,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	 * requests transmutation then by all means transmute.
 	 * Mark the inode as changed.
 	 */
-	if ((tsp->smk_task == tsp->smk_transmuted) ||
-	    (may > 0 && ((may & MAY_TRANSMUTE) != 0) &&
-	     smk_inode_transmutable(dir))) {
+	if (trans_cred || (trans_rule && smk_inode_transmutable(dir))) {
 		struct xattr *xattr_transmute;
 
 		/*
@@ -1012,8 +1024,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		 * inode label was already set correctly in
 		 * smack_inode_alloc_security().
 		 */
-		if (tsp->smk_task != tsp->smk_transmuted)
-			isp = issp->smk_inode = dsp;
+		if (!trans_cred)
+			issp->smk_inode = dsp;
 
 		issp->smk_flags |= SMK_INODE_TRANSMUTE;
 		xattr_transmute = lsm_get_xattr_slot(xattrs,
@@ -1033,11 +1045,13 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	issp->smk_flags |= SMK_INODE_INSTANT;
 
 	if (xattr) {
-		xattr->value = kstrdup(isp->smk_known, GFP_NOFS);
+		const char *inode_label = issp->smk_inode->smk_known;
+
+		xattr->value = kstrdup(inode_label, GFP_NOFS);
 		if (!xattr->value)
 			return -ENOMEM;
 
-		xattr->value_len = strlen(isp->smk_known);
+		xattr->value_len = strlen(inode_label);
 		xattr->name = XATTR_SMACK_SUFFIX;
 	}
 
@@ -4915,7 +4929,6 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	struct task_smack *otsp = smack_cred(old);
 	struct task_smack *ntsp = smack_cred(new);
 	struct inode_smack *isp;
-	int may;
 
 	/*
 	 * Use the process credential unless all of
@@ -4929,18 +4942,12 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	isp = smack_inode(d_inode(dentry->d_parent));
 
 	if (isp->smk_flags & SMK_INODE_TRANSMUTE) {
-		rcu_read_lock();
-		may = smk_access_entry(otsp->smk_task->smk_known,
-				       isp->smk_inode->smk_known,
-				       &otsp->smk_task->smk_rules);
-		rcu_read_unlock();
-
 		/*
 		 * If the directory is transmuting and the rule
 		 * providing access is transmuting use the containing
 		 * directory label instead of the process label.
 		 */
-		if (may > 0 && (may & MAY_TRANSMUTE)) {
+		if (smk_rule_transmutes(otsp->smk_task, isp->smk_inode)) {
 			ntsp->smk_task = isp->smk_inode;
 			ntsp->smk_transmuted = ntsp->smk_task;
 		}
-- 
2.51.0



