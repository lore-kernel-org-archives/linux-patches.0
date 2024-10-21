Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ACF1E32D7;
	Mon, 21 Oct 2024 10:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507252; cv=none; b=HxSs/qe9llN9PpdiReaQ0wUfVeMUeDvaz5YdnwA4OzJRE65T6UWAWiac0QtIihxnVyHSV7cNbqNQVsN2Tn0dTTYD+2yaPakfbDiguufnEdK4592QaoU/fTPJ0frR5YOBnVemU8/+X2UOgQ7U3Dep6uTeHVUjQUs0XTW5U54/j7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507252; c=relaxed/simple;
	bh=X49FKIVj8EWAU22ak197tv7LOChsDuv8GzCo8GNDt5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wqmtv3RD4mayi3zVW4JxWY7ZYzZqZjCgA+7pgbid1sauODAGQj4a4xxsXqRAXM4xiV6lrI4r5GImsI4oEITeTisuJcZHsot1gyDX9w5dkY1v56VLcm6msgamKO7i2lKcuAez6tAks4bLQr6BHk6hOMVQ9/nswPpq1eZiJWQW/f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/wyt39h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/wyt39h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233BCC4CEC7;
	Mon, 21 Oct 2024 10:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507252;
	bh=X49FKIVj8EWAU22ak197tv7LOChsDuv8GzCo8GNDt5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/wyt39h28ae5IfYkrG5cwFllDhfL15qCvNMJEt3IdzDqTkfxqlTd8gIbDWHraCWW
	 UgWrbnQk0MbGMinK/lVk58iDCvh5zaFJSKSxvHvKscjj8ky28GKswbAkRk+OboL3mC
	 aAz5gwQe6Xij/s/4cGizFF8QEsq5AYtRHBqkAvfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 16/91] udf: Convert udf_rmdir() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:30 +0200
Message-ID: <20241021102250.445351839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit d11ffa8d3ec11fdb665f12f95d58d74673051a93 ]

Convert udf_rmdir() to use new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -898,30 +898,23 @@ static int empty_dir(struct inode *dir)
 
 static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	int retval;
+	int ret;
 	struct inode *inode = d_inode(dentry);
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc *fi, cfi;
+	struct udf_fileident_iter iter;
 	struct kernel_lb_addr tloc;
 
-	retval = -ENOENT;
-	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
-	if (IS_ERR_OR_NULL(fi)) {
-		if (fi)
-			retval = PTR_ERR(fi);
+	ret = udf_fiiter_find_entry(dir, &dentry->d_name, &iter);
+	if (ret)
 		goto out;
-	}
 
-	retval = -EIO;
-	tloc = lelb_to_cpu(cfi.icb.extLocation);
+	ret = -EFSCORRUPTED;
+	tloc = lelb_to_cpu(iter.fi.icb.extLocation);
 	if (udf_get_lb_pblock(dir->i_sb, &tloc, 0) != inode->i_ino)
 		goto end_rmdir;
-	retval = -ENOTEMPTY;
+	ret = -ENOTEMPTY;
 	if (!empty_dir(inode))
 		goto end_rmdir;
-	retval = udf_delete_entry(dir, fi, &fibh, &cfi);
-	if (retval)
-		goto end_rmdir;
+	udf_fiiter_delete_entry(&iter);
 	if (inode->i_nlink != 2)
 		udf_warn(inode->i_sb, "empty directory has nlink != 2 (%u)\n",
 			 inode->i_nlink);
@@ -931,14 +924,11 @@ static int udf_rmdir(struct inode *dir,
 	inode->i_ctime = dir->i_ctime = dir->i_mtime =
 						current_time(inode);
 	mark_inode_dirty(dir);
-
+	ret = 0;
 end_rmdir:
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-
+	udf_fiiter_release(&iter);
 out:
-	return retval;
+	return ret;
 }
 
 static int udf_unlink(struct inode *dir, struct dentry *dentry)


