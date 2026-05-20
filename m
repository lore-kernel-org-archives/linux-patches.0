Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AA52F363F;
	Wed, 20 May 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300849; cv=none; b=Dog+YrZiQfxkF+/YZw4MEYuaZVvMTVSGHanV8pmzcVQ8Eb733epedsloc4ceQ4cUJcM8G3dwHx0+dgpw/RSSw+E/Gc+iUvKwlFdMFFQ1s2K4sVhdR0JoGItTDBPC4TVMd1NXAzdXIRgc+TOHU/T05J0s5rLz6j5TerMBun8Dx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300849; c=relaxed/simple;
	bh=MlK+VbtkMGHHk9Md7q0q0yjecTY1YbWWwtFzaWhQiHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNkv6VtuJIQ8Ojj+3ztBLIETfu/udtDwLiN1CLpCIQyKkf1ivHqwxTyaVK1CRBxjiHxSTm30ZEKVv9XIBLqMb+40va2u4UYKcHYLW06sWMRQCX5LtLyaF1nSSrcrG/ybBiHlxENwuVSDBfJn7/tpPCH4eQ+ESqv/XOd0hR0YzCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIB+5Gyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIB+5Gyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994AE1F00893;
	Wed, 20 May 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300848;
	bh=6fJM+WokW1dgw5dIXVp5mqLajrU9GiQSwmdat0w0dkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIB+5Gyzs1Yw53G6mRqerDmFoSqLcYNaMPpPsQ2NkpCFyHW2XS2iBBLhoUgg0v0h0
	 ygJyZGo1hqoOvEJzX6GscLM5761zYJuch5PvLppmhagp3mvyaOSSrJGMrBfNDtPO4R
	 9x3S1q9Q+EFJGWRUo81m784bE2QHIJoQJ6k7ZhJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mimi Zohar <zohar@linux.ibm.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/666] ima_fs: dont bother with removal of files in directory well be removing
Date: Wed, 20 May 2026 18:19:01 +0200
Message-ID: <20260520162118.381657216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 22260a99d791163f7697a240dfc48e4e5a91ecfe ]

removal of parent takes all children out

Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: d7bd8cf0b348 ("ima_fs: Correctly create securityfs files for unsupported hash algos")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_fs.c | 57 +++++++++++----------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index e4a79a9b2d588..88421e8895c44 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -396,11 +396,6 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
 
 static struct dentry *ima_dir;
 static struct dentry *ima_symlink;
-static struct dentry *binary_runtime_measurements;
-static struct dentry *ascii_runtime_measurements;
-static struct dentry *runtime_measurements_count;
-static struct dentry *violations;
-static struct dentry *ima_policy;
 
 enum ima_fs_flags {
 	IMA_FS_BUSY,
@@ -419,14 +414,7 @@ static const struct seq_operations ima_policy_seqops = {
 
 static void __init remove_securityfs_measurement_lists(struct dentry **lists)
 {
-	int i;
-
-	if (lists) {
-		for (i = 0; i < securityfs_measurement_list_count; i++)
-			securityfs_remove(lists[i]);
-
-		kfree(lists);
-	}
+	kfree(lists);
 }
 
 static int __init create_securityfs_measurement_lists(void)
@@ -533,8 +521,7 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 
 	ima_update_policy();
 #if !defined(CONFIG_IMA_WRITE_POLICY) && !defined(CONFIG_IMA_READ_POLICY)
-	securityfs_remove(ima_policy);
-	ima_policy = NULL;
+	securityfs_remove(file->f_path.dentry);
 #elif defined(CONFIG_IMA_WRITE_POLICY)
 	clear_bit(IMA_FS_BUSY, &ima_fs_flags);
 #elif defined(CONFIG_IMA_READ_POLICY)
@@ -553,6 +540,7 @@ static const struct file_operations ima_measure_policy_ops = {
 
 int __init ima_fs_init(void)
 {
+	struct dentry *dentry;
 	int ret;
 
 	ascii_securityfs_measurement_lists = NULL;
@@ -573,54 +561,45 @@ int __init ima_fs_init(void)
 	if (ret != 0)
 		goto out;
 
-	binary_runtime_measurements =
-	    securityfs_create_symlink("binary_runtime_measurements", ima_dir,
+	dentry = securityfs_create_symlink("binary_runtime_measurements", ima_dir,
 				      "binary_runtime_measurements_sha1", NULL);
-	if (IS_ERR(binary_runtime_measurements)) {
-		ret = PTR_ERR(binary_runtime_measurements);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto out;
 	}
 
-	ascii_runtime_measurements =
-	    securityfs_create_symlink("ascii_runtime_measurements", ima_dir,
+	dentry = securityfs_create_symlink("ascii_runtime_measurements", ima_dir,
 				      "ascii_runtime_measurements_sha1", NULL);
-	if (IS_ERR(ascii_runtime_measurements)) {
-		ret = PTR_ERR(ascii_runtime_measurements);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto out;
 	}
 
-	runtime_measurements_count =
-	    securityfs_create_file("runtime_measurements_count",
+	dentry = securityfs_create_file("runtime_measurements_count",
 				   S_IRUSR | S_IRGRP, ima_dir, NULL,
 				   &ima_measurements_count_ops);
-	if (IS_ERR(runtime_measurements_count)) {
-		ret = PTR_ERR(runtime_measurements_count);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto out;
 	}
 
-	violations =
-	    securityfs_create_file("violations", S_IRUSR | S_IRGRP,
+	dentry = securityfs_create_file("violations", S_IRUSR | S_IRGRP,
 				   ima_dir, NULL, &ima_htable_violations_ops);
-	if (IS_ERR(violations)) {
-		ret = PTR_ERR(violations);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto out;
 	}
 
-	ima_policy = securityfs_create_file("policy", POLICY_FILE_FLAGS,
+	dentry = securityfs_create_file("policy", POLICY_FILE_FLAGS,
 					    ima_dir, NULL,
 					    &ima_measure_policy_ops);
-	if (IS_ERR(ima_policy)) {
-		ret = PTR_ERR(ima_policy);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto out;
 	}
 
 	return 0;
 out:
-	securityfs_remove(ima_policy);
-	securityfs_remove(violations);
-	securityfs_remove(runtime_measurements_count);
-	securityfs_remove(ascii_runtime_measurements);
-	securityfs_remove(binary_runtime_measurements);
 	remove_securityfs_measurement_lists(ascii_securityfs_measurement_lists);
 	remove_securityfs_measurement_lists(binary_securityfs_measurement_lists);
 	securityfs_measurement_list_count = 0;
-- 
2.53.0



