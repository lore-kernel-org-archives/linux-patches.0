Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282943A6B6D;
	Wed, 20 May 2026 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300852; cv=none; b=mxbwTkEAd4SZorcS1r2iKW65zobMWCQW9ulcTimEh3XBJB/hUXuRobLWqgNTEANqU6oH3SwF5bf+KW5hq4k51+Fz7J+EMiHhCmPDfDHb5qpwkhMJtyIyNGKA6xL0Dis37TUmjlElcLWQI9Fzo0v+qgOn1fcjymjj0Juiq2F6mXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300852; c=relaxed/simple;
	bh=3K97AO9+2bMQC8m8l30SgXHpsdS9vyHKi2JxIg0GbrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSmvR4nTCNAEgW8BFJmw0n5rmoROBrb0yYuBOLK6cbyXyB9wX8qIhQ7Uxrz0gz+NuCaJccPSgVvGoyG20hbm19lHy17Avx3HRPc6jx3Nj79VYYHRSPOOs51Dtcv6dckXlq76NfuMjRxNT6uS1K7vIK40MyBnG7m8cSL9jnM3Ozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXb6yY0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXb6yY0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419981F000E9;
	Wed, 20 May 2026 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300850;
	bh=7bCN2JZnZaUfQDrEKIxNGR8bNmguvA2Rh5np0/Dizgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXb6yY0+d1wdwRMdAW+gSc3y08fvpZ4HRvtKlbyOhjnftwVtPhC56BT+rA3gpYOsR
	 yOvmIXIHbz/NLDXQabhA+EKC/Vrc2w5VgtGvuuDMdXSQMmhIQimIwL9v99LflbwpGi
	 rDjYXlibK1UJh6IuD2kcQrzoH3zd9Q2lMFWpeBS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mimi Zohar <zohar@linux.ibm.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/666] ima_fs: get rid of lookup-by-dentry stuff
Date: Wed, 20 May 2026 18:19:02 +0200
Message-ID: <20260520162118.404032891@linuxfoundation.org>
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

[ Upstream commit d15ffbbf4d32a9007c4a339a9fecac90ce30432a ]

lookup_template_data_hash_algo() machinery is used to locate the
matching ima_algo_array[] element at read time; securityfs
allows to stash that into inode->i_private at object creation
time, so there's no need to bother

Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: d7bd8cf0b348 ("ima_fs: Correctly create securityfs files for unsupported hash algos")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_fs.c | 82 +++++++--------------------------
 1 file changed, 16 insertions(+), 66 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 88421e8895c44..87045b09f1206 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -116,28 +116,6 @@ void ima_putc(struct seq_file *m, void *data, int datalen)
 		seq_putc(m, *(char *)data++);
 }
 
-static struct dentry **ascii_securityfs_measurement_lists __ro_after_init;
-static struct dentry **binary_securityfs_measurement_lists __ro_after_init;
-static int securityfs_measurement_list_count __ro_after_init;
-
-static void lookup_template_data_hash_algo(int *algo_idx, enum hash_algo *algo,
-					   struct seq_file *m,
-					   struct dentry **lists)
-{
-	struct dentry *dentry;
-	int i;
-
-	dentry = file_dentry(m->file);
-
-	for (i = 0; i < securityfs_measurement_list_count; i++) {
-		if (dentry == lists[i]) {
-			*algo_idx = i;
-			*algo = ima_algo_array[i].algo;
-			break;
-		}
-	}
-}
-
 /* print format:
  *       32bit-le=pcr#
  *       char[n]=template digest
@@ -160,9 +138,10 @@ int ima_measurements_show(struct seq_file *m, void *v)
 	algo_idx = ima_sha1_idx;
 	algo = HASH_ALGO_SHA1;
 
-	if (m->file != NULL)
-		lookup_template_data_hash_algo(&algo_idx, &algo, m,
-					       binary_securityfs_measurement_lists);
+	if (m->file != NULL) {
+		algo_idx = (unsigned long)file_inode(m->file)->i_private;
+		algo = ima_algo_array[algo_idx].algo;
+	}
 
 	/* get entry */
 	e = qe->entry;
@@ -256,9 +235,10 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 	algo_idx = ima_sha1_idx;
 	algo = HASH_ALGO_SHA1;
 
-	if (m->file != NULL)
-		lookup_template_data_hash_algo(&algo_idx, &algo, m,
-					       ascii_securityfs_measurement_lists);
+	if (m->file != NULL) {
+		algo_idx = (unsigned long)file_inode(m->file)->i_private;
+		algo = ima_algo_array[algo_idx].algo;
+	}
 
 	/* get entry */
 	e = qe->entry;
@@ -412,57 +392,33 @@ static const struct seq_operations ima_policy_seqops = {
 };
 #endif
 
-static void __init remove_securityfs_measurement_lists(struct dentry **lists)
-{
-	kfree(lists);
-}
-
 static int __init create_securityfs_measurement_lists(void)
 {
-	char file_name[NAME_MAX + 1];
-	struct dentry *dentry;
-	u16 algo;
-	int i;
-
-	securityfs_measurement_list_count = NR_BANKS(ima_tpm_chip);
+	int count = NR_BANKS(ima_tpm_chip);
 
 	if (ima_sha1_idx >= NR_BANKS(ima_tpm_chip))
-		securityfs_measurement_list_count++;
+		count++;
 
-	ascii_securityfs_measurement_lists =
-	    kcalloc(securityfs_measurement_list_count, sizeof(struct dentry *),
-		    GFP_KERNEL);
-	if (!ascii_securityfs_measurement_lists)
-		return -ENOMEM;
-
-	binary_securityfs_measurement_lists =
-	    kcalloc(securityfs_measurement_list_count, sizeof(struct dentry *),
-		    GFP_KERNEL);
-	if (!binary_securityfs_measurement_lists)
-		return -ENOMEM;
-
-	for (i = 0; i < securityfs_measurement_list_count; i++) {
-		algo = ima_algo_array[i].algo;
+	for (int i = 0; i < count; i++) {
+		u16 algo = ima_algo_array[i].algo;
+		char file_name[NAME_MAX + 1];
+		struct dentry *dentry;
 
 		sprintf(file_name, "ascii_runtime_measurements_%s",
 			hash_algo_name[algo]);
 		dentry = securityfs_create_file(file_name, S_IRUSR | S_IRGRP,
-						ima_dir, NULL,
+						ima_dir, (void *)(uintptr_t)i,
 						&ima_ascii_measurements_ops);
 		if (IS_ERR(dentry))
 			return PTR_ERR(dentry);
 
-		ascii_securityfs_measurement_lists[i] = dentry;
-
 		sprintf(file_name, "binary_runtime_measurements_%s",
 			hash_algo_name[algo]);
 		dentry = securityfs_create_file(file_name, S_IRUSR | S_IRGRP,
-						ima_dir, NULL,
+						ima_dir, (void *)(uintptr_t)i,
 						&ima_measurements_ops);
 		if (IS_ERR(dentry))
 			return PTR_ERR(dentry);
-
-		binary_securityfs_measurement_lists[i] = dentry;
 	}
 
 	return 0;
@@ -543,9 +499,6 @@ int __init ima_fs_init(void)
 	struct dentry *dentry;
 	int ret;
 
-	ascii_securityfs_measurement_lists = NULL;
-	binary_securityfs_measurement_lists = NULL;
-
 	ima_dir = securityfs_create_dir("ima", integrity_dir);
 	if (IS_ERR(ima_dir))
 		return PTR_ERR(ima_dir);
@@ -600,9 +553,6 @@ int __init ima_fs_init(void)
 
 	return 0;
 out:
-	remove_securityfs_measurement_lists(ascii_securityfs_measurement_lists);
-	remove_securityfs_measurement_lists(binary_securityfs_measurement_lists);
-	securityfs_measurement_list_count = 0;
 	securityfs_remove(ima_symlink);
 	securityfs_remove(ima_dir);
 
-- 
2.53.0



