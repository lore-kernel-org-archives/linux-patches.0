Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B82D207A38;
	Tue, 16 Dec 2025 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883819; cv=none; b=Iggn/eAQ/CTZZ41FxkOTd5RfN1pkJBp7ci+ZhUb4yLycDKKFpYQRcW0TPuK+Gb0P+uIt4XFOdFWvizCrE0PP0SKgNtALCGzfiHyprgL95fZypI+hAuEvhYVZ++vRRLfMwut0gTcUkV5GjMUnn/JbJXaCXT42mtCpmusteyEphD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883819; c=relaxed/simple;
	bh=n4wEs1gRlM0L0bUOPU5EZ2mgYPWtQfPfD4YRVulAqdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPvtYjueTgNKaEY+/yOpUzh3gMTXajvuu6mkzi61WEcmF7XGlsQkunCmvLm4lpsT7wLpEfruo7IZxI1s4jLRVJ7guTiNFoZeq7FxC3H+dr3URCaSb39N5qQxVRFCfvDI/1yewVQbPBQ+Z0K71bU9JmqFC1FyvvaTql7vFSxBjzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdzDaRuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdzDaRuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DDC4CEF1;
	Tue, 16 Dec 2025 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883818;
	bh=n4wEs1gRlM0L0bUOPU5EZ2mgYPWtQfPfD4YRVulAqdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdzDaRuBDWxPGJlgaTjPTqSBboRoKM3FHZ9qqW/ZgUtW76r0qCIWKk5494aRu9EZw
	 d/RcC7RmVoIPbPpsipVv2ae9GK+Djv77tvCMLxMe7emzxeZiLAarjaSsfUGM1IjL6W
	 Xeit4KuLj4o+Y5ZdPAf7s2XZyhlbQUhZcTOwDiLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/354] smack: deduplicate "does access rule request transmutation"
Date: Tue, 16 Dec 2025 12:09:28 +0100
Message-ID: <20251216111320.955809796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 9e13fd3920630..18e15585dce41 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -979,6 +979,24 @@ static int smack_inode_alloc_security(struct inode *inode)
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
@@ -994,23 +1012,19 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
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
@@ -1018,9 +1032,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	 * requests transmutation then by all means transmute.
 	 * Mark the inode as changed.
 	 */
-	if ((tsp->smk_task == tsp->smk_transmuted) ||
-	    (may > 0 && ((may & MAY_TRANSMUTE) != 0) &&
-	     smk_inode_transmutable(dir))) {
+	if (trans_cred || (trans_rule && smk_inode_transmutable(dir))) {
 		struct xattr *xattr_transmute;
 
 		/*
@@ -1029,8 +1041,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		 * inode label was already set correctly in
 		 * smack_inode_alloc_security().
 		 */
-		if (tsp->smk_task != tsp->smk_transmuted)
-			isp = issp->smk_inode = dsp;
+		if (!trans_cred)
+			issp->smk_inode = dsp;
 
 		issp->smk_flags |= SMK_INODE_TRANSMUTE;
 		xattr_transmute = lsm_get_xattr_slot(xattrs,
@@ -1050,11 +1062,13 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
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
 
@@ -4904,7 +4918,6 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	struct task_smack *otsp = smack_cred(old);
 	struct task_smack *ntsp = smack_cred(new);
 	struct inode_smack *isp;
-	int may;
 
 	/*
 	 * Use the process credential unless all of
@@ -4918,18 +4931,12 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
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



