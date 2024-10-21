Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A311E9098;
	Mon, 21 Oct 2024 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507601; cv=none; b=mA8FYNeBuzAXEzafZY1CsaB6x5zwknoc782Qkl/8i252zXsmBDdW71z72oYb2fVHWpwZrdqiqp1NSjMgFpNHvnQr/Ga0mI52tDhXfRLkEepOP+kDzWZSuHK4mBmSTk4h6clQk1kLOntsYaxuJxYQRFhMXrlKynO9oHMSgNPRv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507601; c=relaxed/simple;
	bh=9ZB53HRF3NOI7tXWfncb0YTE1fXNfvH8pLZnvbgfZAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVyCvP19R/9oIPoZKyMDHP3IQdwda08u0OH6xgd1oB/dv9f1ZsMH3DsZpFvZzR25H2EYoaEDQmGj5gHO6gHMh5WF/xfs97nepxzhZqJMAgQBv1+HO8o984vCQCD8rOaU4u5efEh/Li6UNDgZjRyWzmWjBXsqfHyCNAZFYqCoXgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCqX5iSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCqX5iSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA3C4CEC3;
	Mon, 21 Oct 2024 10:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507600;
	bh=9ZB53HRF3NOI7tXWfncb0YTE1fXNfvH8pLZnvbgfZAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCqX5iSzdGWAMYJWQbaRztUz3kX8jHD6nLjx4ESRD9/5I4N/yPfdsw1385UdyfQa0
	 JOuW+Ij7buqVAwGNmkessPN2iN84cYK9fSmS2fCH13GWEVmmyfpQhvZ2J6hNYhE+bU
	 SzQ3UKLRwuca0JmqEbEHQcmLEvXppVgnh7nGj3Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 12/82] udf: Convert udf_rmdir() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:53 +0200
Message-ID: <20241021102247.715374616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


