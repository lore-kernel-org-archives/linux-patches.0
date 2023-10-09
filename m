Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6DA3419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbEuhmc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6771C433C7;
	Mon,  9 Oct 2023 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859522;
	bh=HhpA1i7NuNCtikW2S5ksSqQ7HUm5msjY3fCAhg6wg7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbEuhmc6EzyEGx5KgBoh8CO6uDCPPLYFyB3Ax6qlzjGW+Ok0SlMfPnjI80xAtrDox
	 zSjAoQmG6kZxF/LM9xkEYPmr2ODibGheAM8oYXt+gjI8MRXPhp9GRIw1RquJzIsPsU
	 XTSPxyidHRueui7CcXOh3tGd6A8CFMZZfcW8n3C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Munehisa Kamata <kamatam@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/91] smack: Record transmuting in smk_transmuted
Date: Mon,  9 Oct 2023 15:06:20 +0200
Message-ID: <20231009130113.180073982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 2c085f3a8f23c9b444e8b99d93c15d7ce870fc4e upstream.

smack_dentry_create_files_as() determines whether transmuting should occur
based on the label of the parent directory the new inode will be added to,
and not the label of the directory where it is created.

This helps for example to do transmuting on overlayfs, since the latter
first creates the inode in the working directory, and then moves it to the
correct destination.

However, despite smack_dentry_create_files_as() provides the correct label,
smack_inode_init_security() does not know from passed information whether
or not transmuting occurred. Without this information,
smack_inode_init_security() cannot set SMK_INODE_CHANGED in smk_flags,
which will result in the SMACK64TRANSMUTE xattr not being set in
smack_d_instantiate().

Thus, add the smk_transmuted field to the task_smack structure, and set it
in smack_dentry_create_files_as() to smk_task if transmuting occurred. If
smk_task is equal to smk_transmuted in smack_inode_init_security(), act as
if transmuting was successful but without taking the label from the parent
directory (the inode label was already set correctly from the current
credentials in smack_inode_alloc_security()).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
[4.19: adjusted for the lack of helper functions]
Fixes: d6d80cb57be4 ("Smack: Base support for overlayfs")
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h     |  1 +
 security/smack/smack_lsm.c | 41 +++++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index f7db791fb5660..62aa4bc25426c 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -120,6 +120,7 @@ struct inode_smack {
 struct task_smack {
 	struct smack_known	*smk_task;	/* label for access control */
 	struct smack_known	*smk_forked;	/* label when forked */
+	struct smack_known	*smk_transmuted;/* label when transmuted */
 	struct list_head	smk_rules;	/* per task access rules */
 	struct mutex		smk_rules_lock;	/* lock for the rules */
 	struct list_head	smk_relabel;	/* transit allowed labels */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index db729834d8ba9..266eb8ca33818 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1032,8 +1032,9 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     const struct qstr *qstr, const char **name,
 				     void **value, size_t *len)
 {
+	struct task_smack *tsp = current_security();
 	struct inode_smack *issp = inode->i_security;
-	struct smack_known *skp = smk_of_current();
+	struct smack_known *skp = smk_of_task(tsp);
 	struct smack_known *isp = smk_of_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
 	int may;
@@ -1042,20 +1043,34 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		*name = XATTR_SMACK_SUFFIX;
 
 	if (value && len) {
-		rcu_read_lock();
-		may = smk_access_entry(skp->smk_known, dsp->smk_known,
-				       &skp->smk_rules);
-		rcu_read_unlock();
+		/*
+		 * If equal, transmuting already occurred in
+		 * smack_dentry_create_files_as(). No need to check again.
+		 */
+		if (tsp->smk_task != tsp->smk_transmuted) {
+			rcu_read_lock();
+			may = smk_access_entry(skp->smk_known, dsp->smk_known,
+					       &skp->smk_rules);
+			rcu_read_unlock();
+		}
 
 		/*
-		 * If the access rule allows transmutation and
-		 * the directory requests transmutation then
-		 * by all means transmute.
+		 * In addition to having smk_task equal to smk_transmuted,
+		 * if the access rule allows transmutation and the directory
+		 * requests transmutation then by all means transmute.
 		 * Mark the inode as changed.
 		 */
-		if (may > 0 && ((may & MAY_TRANSMUTE) != 0) &&
-		    smk_inode_transmutable(dir)) {
-			isp = dsp;
+		if ((tsp->smk_task == tsp->smk_transmuted) ||
+		    (may > 0 && ((may & MAY_TRANSMUTE) != 0) &&
+		     smk_inode_transmutable(dir))) {
+			/*
+			 * The caller of smack_dentry_create_files_as()
+			 * should have overridden the current cred, so the
+			 * inode label was already set correctly in
+			 * smack_inode_alloc_security().
+			 */
+			if (tsp->smk_task != tsp->smk_transmuted)
+				isp = dsp;
 			issp->smk_flags |= SMK_INODE_CHANGED;
 		}
 
@@ -4677,8 +4692,10 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 		 * providing access is transmuting use the containing
 		 * directory label instead of the process label.
 		 */
-		if (may > 0 && (may & MAY_TRANSMUTE))
+		if (may > 0 && (may & MAY_TRANSMUTE)) {
 			ntsp->smk_task = isp->smk_inode;
+			ntsp->smk_transmuted = ntsp->smk_task;
+		}
 	}
 	return 0;
 }
-- 
2.40.1



