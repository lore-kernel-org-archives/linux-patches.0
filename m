Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE214746B9;
	Tue, 21 Jul 2026 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667919; cv=none; b=XzTPJf+bBiqZZuaEFF+sK+HayTrz2L31JOiYVWF7tX2if85L+T+0o7LStMmtcXIr2rMYzIlPxHt4ZtF4Cmz5axnodt1q7FB30J6NpOQoiL7NBVUZlYUIKVWGxReMdJ2PWpJ4a7t4Wr+j7mW6wvoZlM5wH13ZZVKp2t/0o4py6nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667919; c=relaxed/simple;
	bh=LbK5SLDbIvCY3eAyza8DV5Y3p4XI0sUr4LrY5eFNT5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5oCGSqE/uuwT32FrgKHnX8QlmsN2yi+EhNfvjmCAGBozuFKrv5nRRLRKPLY5QbKwYjoTRQez3iC7CyljHOvPe50vg42zFzRLi6YePzHv8Ewnl+NEKXu3vhnlgyZqGWzW35eUNtUzxdlRQch+ryrBj9eJMJLJv4UMXjRiBgRv3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHwM0vO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHwM0vO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E8C1F00A3A;
	Tue, 21 Jul 2026 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667917;
	bh=EVixvH03A/S7Mcpi6y/m33A0D9XlJJ9gx04iTTqfyxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHwM0vO1nA+Sk1nK2SlPRqyua4oTNaWBy0A7u+JzQgGyBDgPeCTZI7YrWGwK//wOd
	 XeSLnceUdRLgv+GltE1kCR441Dmv7DMm9r5q/aZYG9ua1QjELiuNL/vbqZZiu2HRLi
	 DbLggFK6rgoCBtJFF+5DJX+MUgO8IGK42vQWIR9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1240/1266] exfat: remove unnecessary read entry in __exfat_rename()
Date: Tue, 21 Jul 2026 17:27:57 +0200
Message-ID: <20260721152509.565136019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 30ef0e0d7ff5b6dceda19d18a85d9d72a4909784 ]

To determine whether it is a directory, there is no need to read its
directory entry, just use S_ISDIR(inode->i_mode).

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 942296784b2a ("exfat: preserve benign secondary entries during rename and move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1177,18 +1177,13 @@ static int __exfat_rename(struct inode *
 	int ret;
 	int dentry;
 	struct exfat_chain olddir, newdir;
-	struct exfat_chain *p_dir = NULL;
 	struct exfat_uni_name uni_name;
-	struct exfat_dentry *ep;
 	struct super_block *sb = old_parent_inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	const unsigned char *new_path = new_dentry->d_name.name;
 	struct inode *new_inode = new_dentry->d_inode;
 	int num_entries;
 	struct exfat_inode_info *new_ei = NULL;
-	unsigned int new_entry_type = TYPE_UNUSED;
-	int new_entry = 0;
-	struct buffer_head *new_bh = NULL;
 
 	/* check the validity of pointer parameters */
 	if (new_path == NULL || strlen(new_path) == 0)
@@ -1214,17 +1209,8 @@ static int __exfat_rename(struct inode *
 			goto out;
 		}
 
-		p_dir = &(new_ei->dir);
-		new_entry = new_ei->entry;
-		ep = exfat_get_dentry(sb, p_dir, new_entry, &new_bh);
-		if (!ep)
-			goto out;
-
-		new_entry_type = exfat_get_entry_type(ep);
-		brelse(new_bh);
-
 		/* if new_inode exists, update ei */
-		if (new_entry_type == TYPE_DIR) {
+		if (S_ISDIR(new_inode->i_mode)) {
 			struct exfat_chain new_clu;
 
 			new_clu.dir = new_ei->start_clu;
@@ -1255,6 +1241,11 @@ static int __exfat_rename(struct inode *
 				&newdir, &uni_name, ei);
 
 	if (!ret && new_inode) {
+		struct exfat_chain *p_dir = &(new_ei->dir);
+		int new_entry = new_ei->entry;
+		struct exfat_dentry *ep;
+		struct buffer_head *new_bh = NULL;
+
 		/* delete entries of new_dir */
 		ep = exfat_get_dentry(sb, p_dir, new_entry, &new_bh);
 		if (!ep) {
@@ -1276,7 +1267,7 @@ static int __exfat_rename(struct inode *
 		}
 
 		/* Free the clusters if new_inode is a dir(as if exfat_rmdir) */
-		if (new_entry_type == TYPE_DIR &&
+		if (S_ISDIR(new_inode->i_mode) &&
 		    new_ei->start_clu != EXFAT_EOF_CLUSTER) {
 			/* new_ei, new_clu_to_free */
 			struct exfat_chain new_clu_to_free;


