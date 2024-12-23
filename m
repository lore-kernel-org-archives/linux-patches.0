Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF41B3931;
	Mon, 23 Dec 2024 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969662; cv=none; b=NrZSuTiFkZjfNvY3HEjLPhFl5Sup6sThgpKMSVhmnk7zwNDnK4cTj8z/+E2n2cO6hDr/Dx897h3h40ohtYLyRFUKCKpKObKXow//sGjptsIhHS2vF3BT5lFtfeMyqSlw5vkHZkjHfKYSgQHXgVXgXacrJNRBUjOgt4UHKt11tHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969662; c=relaxed/simple;
	bh=lnuEf17wt8YH5GNBnnJO3to6WvneYzIte3RVCUItOKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTIi7B5OLUo1UN6bWZ9fRWfihKlYmK9ahSORCkQXmNaUwv0UxZ/MD1RbR7YnmRmhWt23q6YQgLzw8Ef/mslxWd7sYWAGZTlRJe+p8L1jUy9cOvV2xNiReIxjGoPdB65I95xTNIiLfsCV4fhWzSvpYDSlEHLKII9quIg4MMb7Bhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8zbtmS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8zbtmS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987EDC4CED4;
	Mon, 23 Dec 2024 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969662;
	bh=lnuEf17wt8YH5GNBnnJO3to6WvneYzIte3RVCUItOKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8zbtmS8iMMvneKNfj1HfjjUPP2UpiQQEEdeOhyZGPOzCkf2JYZ5vDOztfHqo4Yzs
	 WnUwpnN05zPueirCrpelVKFFRw1wT/fCcNhbraNESO+AcNMVgJtpA6AIvQ4VOlfYj6
	 FAPaLS8U5KyMU1koeC0KPeID4SkYhV+cTT4QWnAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/160] erofs: add erofs_sb_free() helper
Date: Mon, 23 Dec 2024 16:57:10 +0100
Message-ID: <20241223155409.393174297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e2de3c1bf6a0c99b089bd706a62da8f988918858 ]

Unify the common parts of erofs_fc_free() and erofs_kill_sb() as
erofs_sb_free().

Thus, fput() in erofs_fc_get_tree() is no longer needed, too.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241212133504.2047178-1-hsiangkao@linux.alibaba.com
Stable-dep-of: 6422cde1b0d5 ("erofs: use buffered I/O for file-backed mounts by default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 2dd7d819572f..c40821346d50 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -718,16 +718,19 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			GET_TREE_BDEV_QUIET_LOOKUP : 0);
 #ifdef CONFIG_EROFS_FS_BACKED_BY_FILE
 	if (ret == -ENOTBLK) {
+		struct file *file;
+
 		if (!fc->source)
 			return invalf(fc, "No source specified");
-		sbi->fdev = filp_open(fc->source, O_RDONLY | O_LARGEFILE, 0);
-		if (IS_ERR(sbi->fdev))
-			return PTR_ERR(sbi->fdev);
+
+		file = filp_open(fc->source, O_RDONLY | O_LARGEFILE, 0);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+		sbi->fdev = file;
 
 		if (S_ISREG(file_inode(sbi->fdev)->i_mode) &&
 		    sbi->fdev->f_mapping->a_ops->read_folio)
 			return get_tree_nodev(fc, erofs_fc_fill_super);
-		fput(sbi->fdev);
 	}
 #endif
 	return ret;
@@ -778,19 +781,24 @@ static void erofs_free_dev_context(struct erofs_dev_context *devs)
 	kfree(devs);
 }
 
-static void erofs_fc_free(struct fs_context *fc)
+static void erofs_sb_free(struct erofs_sb_info *sbi)
 {
-	struct erofs_sb_info *sbi = fc->s_fs_info;
-
-	if (!sbi)
-		return;
-
 	erofs_free_dev_context(sbi->devs);
 	kfree(sbi->fsid);
 	kfree(sbi->domain_id);
+	if (sbi->fdev)
+		fput(sbi->fdev);
 	kfree(sbi);
 }
 
+static void erofs_fc_free(struct fs_context *fc)
+{
+	struct erofs_sb_info *sbi = fc->s_fs_info;
+
+	if (sbi) /* free here if an error occurs before transferring to sb */
+		erofs_sb_free(sbi);
+}
+
 static const struct fs_context_operations erofs_context_ops = {
 	.parse_param	= erofs_fc_parse_param,
 	.get_tree       = erofs_fc_get_tree,
@@ -828,15 +836,9 @@ static void erofs_kill_sb(struct super_block *sb)
 		kill_anon_super(sb);
 	else
 		kill_block_super(sb);
-
-	erofs_free_dev_context(sbi->devs);
 	fs_put_dax(sbi->dax_dev, NULL);
 	erofs_fscache_unregister_fs(sb);
-	kfree(sbi->fsid);
-	kfree(sbi->domain_id);
-	if (sbi->fdev)
-		fput(sbi->fdev);
-	kfree(sbi);
+	erofs_sb_free(sbi);
 	sb->s_fs_info = NULL;
 }
 
-- 
2.39.5



