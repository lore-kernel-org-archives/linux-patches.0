Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E031472525;
	Tue, 21 Jul 2026 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664508; cv=none; b=PLcnFTkZk/+yLKjxyR7yirOY1n2QUxaHXLZ7Jg6zfud73mwZp+DuQeMmlDpVdY31jTNhPIhG21ZpDKwiYoOL0loG3la1bETNWibHB8GoU45KxNpriEloPyLIOtwnjw+rBMCIFUNuZZYyZf5QT5hFuv2vaf/XkjT7u3AzyEKyibU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664508; c=relaxed/simple;
	bh=//fS10t7Satm9N7JmeXolPLvGpg5axATNvdxsLQg5Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu1ZGJ7PcdEABT4vVpiHtc5rVG3dv20sMDE6JW+vpehtV5RA+2ONsNIwp/6trlopC6vYBIclHQ/1unSTq4xSp5IiJnonhuFkGqrmdPOT0OB7WU7bMgXxHxpLqilDCEXr/Am8uIEGjoRR9nzrb6ZRg/PgPSiMD54p9U8qEJjhPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWbgSySh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWbgSySh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B61D1F000E9;
	Tue, 21 Jul 2026 20:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664506;
	bh=fqXbq3hjCEJA0tEpOt4pUEHXIyNEYov5QBNzBRxGAKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWbgSyShRWED3lhtnR21Lgj2FRau6FDGv+jWO9i8ac84Z6zFZF61Dg2EWNzD+CdsF
	 Gw9BpZvaS5nUmMToEr33dw4cwWv9JPidQtVRrkzxKsCtX3p+LfckPBucr0Iv7qFOyt
	 TWWHZ3oIPd6jPnzV70xT4kcoJp4Mh7CbqP+l9TdI=
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
Subject: [PATCH 6.12 1226/1276] exfat: remove unnecessary read entry in __exfat_rename()
Date: Tue, 21 Jul 2026 17:27:49 +0200
Message-ID: <20260721152513.514335027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 fs/exfat/namei.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1145,17 +1145,12 @@ static int __exfat_rename(struct inode *
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
 	struct exfat_inode_info *new_ei = NULL;
-	unsigned int new_entry_type = TYPE_UNUSED;
-	int new_entry = 0;
-	struct buffer_head *new_bh = NULL;
 
 	/* check the validity of pointer parameters */
 	if (new_path == NULL || strlen(new_path) == 0)
@@ -1181,17 +1176,8 @@ static int __exfat_rename(struct inode *
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
@@ -1223,6 +1209,8 @@ static int __exfat_rename(struct inode *
 
 	if (!ret && new_inode) {
 		struct exfat_entry_set_cache es;
+		struct exfat_chain *p_dir = &(new_ei->dir);
+		int new_entry = new_ei->entry;
 
 		/* delete entries of new_dir */
 		ret = exfat_get_dentry_set(&es, sb, p_dir, new_entry,
@@ -1239,7 +1227,7 @@ static int __exfat_rename(struct inode *
 			goto del_out;
 
 		/* Free the clusters if new_inode is a dir(as if exfat_rmdir) */
-		if (new_entry_type == TYPE_DIR &&
+		if (S_ISDIR(new_inode->i_mode) &&
 		    new_ei->start_clu != EXFAT_EOF_CLUSTER) {
 			/* new_ei, new_clu_to_free */
 			struct exfat_chain new_clu_to_free;


