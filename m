Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070402C08D0;
	Sat, 12 Sep 2026 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222349; cv=none; b=HqnPKgh4YogrF8rMZMxOPbjuhwMxwTaK/2JocgiqCI1B1zLIH8ZaWHZxxodLJFujJrYBjeAdVIRPEJv5f49ERPLsZ6JwDZIxucMi3PwPocs9zqRZLmm0lg0QsbCQaHbTkzNHBbFxSV79W+qU4S4lYpqz7gwSsA6yUXM6AjC9IKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222349; c=relaxed/simple;
	bh=Rp8s+YRgS8QKyzsg5c0FJHR1unBgT4x1zJhq11g6aVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRP25KBB+kQnm/X7mwt7Qz2Uo/xVOxxaeLzdVsoAc82POlT52A4yw1UTF/EEBn/UF+TiexHvEbFSUOTrgLxCTXKs5xsIKEr3CRcp4Y3rV2xE6XMLbXicgX8KlmmeROs4ZdH6ZJ5EdXwVANKHyyXvPDR0o1DKzwvauKaID7CW6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2cNLuMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2cNLuMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E991F000FF;
	Sat, 12 Sep 2026 14:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222347;
	bh=ie11M6zE6yhz8FzpgsBuU+zzWhnDe5kjEF4ZiJiuJDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2cNLuMDjX4yjT8eu+cL1SPcdM8qnHFA/beKQd24sbW7lX2A4T9uukH2eWiJ4DZil
	 N05u7fguI9QcDv1uxiuKkn0HpmF4oIkEqie2xNCE0zVfdnjgFwysdcViK4NE0uiZlq
	 w4VmUQu/mL9W+Sei9sfkztLKLkSK/pquMqh8XHh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0567/1424] smack: deduplicate smackfs/{direct,mapped} file_operations
Date: Sat, 12 Sep 2026 08:49:59 +0200
Message-ID: <20260912065620.002072106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 577dc3b6a8cf200e6e27b2d9967cac14a1fed2f3 ]

The file_operations for smackfs/direct and smackfs/mapped are
identical up to a textual replacement of "direct" with "mapped"

This patch combines two instances of file_operations into one,
handling both files.

Fixes: f7112e6c9abf ("Smack: allow for significantly longer Smack labels v4")
Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h   |   5 +-
 security/smack/smackfs.c | 133 ++++++++++++---------------------------
 2 files changed, 42 insertions(+), 96 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index aac0574cdfad3..96a4a92ac0932 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -299,8 +299,9 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled __initdata;
-extern int smack_cipso_direct;
-extern int smack_cipso_mapped;
+extern int smack_cipso_auto_level[2];
+#define smack_cipso_direct (+smack_cipso_auto_level[0])
+#define smack_cipso_mapped (+smack_cipso_auto_level[1])
 extern struct smack_known *smack_net_ambient;
 extern struct smack_known *smack_syslog_label;
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index dd44d254c300c..ab472058d2e43 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -81,18 +81,27 @@ static DEFINE_MUTEX(smk_net6addr_lock);
 struct smack_known *smack_net_ambient;
 
 /*
- * This is the level in a CIPSO header that indicates a
+ * Sensitivity levels for automatically created CIPSO labels.
+ * See smack_access.c`smack_populate_secattr()
+ *
+ * [0] "direct" labeling, label length < SMK_CIPSOLEN(24):
  * smack label is contained directly in the category set.
  * It can be reset via smackfs/direct
- */
-int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
-
-/*
- * This is the level in a CIPSO header that indicates a
+ *
+ * [1] "mapped" labeling, label length >= SMK_CIPSOLEN(24):
  * secid is contained directly in the category set.
  * It can be reset via smackfs/mapped
  */
-int smack_cipso_mapped = SMACK_CIPSO_MAPPED_DEFAULT;
+int smack_cipso_auto_level[2] = {
+	SMACK_CIPSO_DIRECT_DEFAULT,
+	SMACK_CIPSO_MAPPED_DEFAULT,
+};
+
+static int
+smk_cipso_auto_level_idx(const struct file *file)
+{
+	return (file_inode(file)->i_ino != SMK_DIRECT);
+}
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 /*
@@ -1639,15 +1648,15 @@ static const struct file_operations smk_doi_ops = {
 };
 
 /**
- * smk_read_direct - read() for /smack/direct
- * @filp: file pointer, not actually used
+ * smk_read_cipso_auto_level - read() for smackfs/direct and smackfs/mapped
+ * @filp: file pointer
  * @buf: where to put the result
  * @count: maximum to send along
  * @ppos: where to start
  *
  * Returns number of bytes read or error code, as appropriate
  */
-static ssize_t smk_read_direct(struct file *filp, char __user *buf,
+static ssize_t smk_read_cipso_auto_level(struct file *filp, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	char temp[80];
@@ -1656,26 +1665,28 @@ static ssize_t smk_read_direct(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smack_cipso_direct);
+	sprintf(temp, "%d", smack_cipso_auto_level[
+			      smk_cipso_auto_level_idx(filp)]);
 	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
 
 	return rc;
 }
 
 /**
- * smk_write_direct - write() for /smack/direct
- * @file: file pointer, not actually used
+ * smk_write_cipso_auto_level - write() for smackfs/direct and smackfs/mapped
+ * @filp: file pointer
  * @buf: where to get the data from
  * @count: bytes sent
  * @ppos: where to start
  *
  * Returns number of bytes written or error code, as appropriate
  */
-static ssize_t smk_write_direct(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t
+smk_write_cipso_auto_level(struct file *filp, const char __user *buf,
+			   size_t count, loff_t *ppos)
 {
 	struct smack_known *skp;
-	int i, ret;
+	int i, ret, idx, old_lvl;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1687,94 +1698,28 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 	/*
 	 * Don't do anything if the value hasn't actually changed.
 	 * If it is changing reset the level on entries that were
-	 * set up to be direct when they were created.
+	 * set up to be "auto" level when they were created.
 	 */
-	if (smack_cipso_direct != i) {
-		mutex_lock(&smack_known_lock);
-		list_for_each_entry_rcu(skp, &smack_known_list, list)
-			if (skp->smk_netlabel.attr.mls.lvl ==
-			    smack_cipso_direct)
-				skp->smk_netlabel.attr.mls.lvl = i;
-		smack_cipso_direct = i;
-		mutex_unlock(&smack_known_lock);
-	}
-
-	return count;
-}
+	idx = smk_cipso_auto_level_idx(filp);
+	old_lvl = smack_cipso_auto_level[idx];
 
-static const struct file_operations smk_direct_ops = {
-	.read		= smk_read_direct,
-	.write		= smk_write_direct,
-	.llseek		= default_llseek,
-};
-
-/**
- * smk_read_mapped - read() for /smack/mapped
- * @filp: file pointer, not actually used
- * @buf: where to put the result
- * @count: maximum to send along
- * @ppos: where to start
- *
- * Returns number of bytes read or error code, as appropriate
- */
-static ssize_t smk_read_mapped(struct file *filp, char __user *buf,
-			       size_t count, loff_t *ppos)
-{
-	char temp[80];
-	ssize_t rc;
-
-	if (*ppos != 0)
-		return 0;
-
-	sprintf(temp, "%d", smack_cipso_mapped);
-	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
-
-	return rc;
-}
-
-/**
- * smk_write_mapped - write() for /smack/mapped
- * @file: file pointer, not actually used
- * @buf: where to get the data from
- * @count: bytes sent
- * @ppos: where to start
- *
- * Returns number of bytes written or error code, as appropriate
- */
-static ssize_t smk_write_mapped(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct smack_known *skp;
-	int i, ret;
-
-	if (!smack_privileged(CAP_MAC_ADMIN))
-		return -EPERM;
-
-	ret = kstrtos32_from_user(buf, count, 10, &i);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * Don't do anything if the value hasn't actually changed.
-	 * If it is changing reset the level on entries that were
-	 * set up to be mapped when they were created.
-	 */
-	if (smack_cipso_mapped != i) {
+	if (old_lvl != i) {
 		mutex_lock(&smack_known_lock);
 		list_for_each_entry_rcu(skp, &smack_known_list, list)
 			if (skp->smk_netlabel.attr.mls.lvl ==
-			    smack_cipso_mapped)
+			    old_lvl)
 				skp->smk_netlabel.attr.mls.lvl = i;
-		smack_cipso_mapped = i;
+		smack_cipso_auto_level[idx] = i;
 		mutex_unlock(&smack_known_lock);
 	}
 
 	return count;
 }
 
-static const struct file_operations smk_mapped_ops = {
-	.read		= smk_read_mapped,
-	.write		= smk_write_mapped,
+static const struct file_operations
+smk_cipso_auto_level_ops = {
+	.read		= smk_read_cipso_auto_level,
+	.write		= smk_write_cipso_auto_level,
 	.llseek		= default_llseek,
 };
 
@@ -2867,7 +2812,7 @@ static int smk_fill_super(struct super_block *sb, struct fs_context *fc)
 		[SMK_DOI] = {
 			"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
 		[SMK_DIRECT] = {
-			"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
+			"direct", &smk_cipso_auto_level_ops, 0644},
 		[SMK_AMBIENT] = {
 			"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
 		[SMK_NET4ADDR] = {
@@ -2881,7 +2826,7 @@ static int smk_fill_super(struct super_block *sb, struct fs_context *fc)
 		[SMK_ACCESSES] = {
 			"access", &smk_access_ops, S_IRUGO|S_IWUGO},
 		[SMK_MAPPED] = {
-			"mapped", &smk_mapped_ops, S_IRUGO|S_IWUSR},
+			"mapped", &smk_cipso_auto_level_ops, 0644},
 		[SMK_LOAD2] = {
 			"load2", &smk_load2_ops, S_IRUGO|S_IWUSR},
 		[SMK_LOAD_SELF2] = {
-- 
2.53.0



