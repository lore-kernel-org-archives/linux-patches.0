Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B3195FEC;
	Mon, 21 Oct 2024 10:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507615; cv=none; b=IfiF8cJlhrj7m6kry5/pHJQbaggxKNkM5ra8Y29Br+aZZMmKa3WbSFgABUjg/Ok2bxO6KQ4KAriVsnCzVAAhnPCC1GNmbp19cT8qB6C9s690k69Vfxfmf6FR4CjgCL/jfUfIvU51bIbtg4LpoTOp7inqWrU+6cMUGojdhiNNqXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507615; c=relaxed/simple;
	bh=Fu63ExRNxcTO+9bynOxhxctXBxo03ipb3khbMJpHudE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOPb16oiZ3yxyEhaPPwxaIFzy/DGpXgI6Zo1/X+eF4c5jW7b6hJlfKzqJS0AKDBJKxdhpyw+KGfA+Kvo07gWSnYq8NXBX8eccplTjgoxDWR1Y6fhIQ+8+DkR4pvGZmnEv3t3Vxvujz3B0m1Vl0rTHm/5pW6k3k3w91II6n5zlEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE1/dQOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE1/dQOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4090EC4CEC3;
	Mon, 21 Oct 2024 10:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507615;
	bh=Fu63ExRNxcTO+9bynOxhxctXBxo03ipb3khbMJpHudE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE1/dQOBxpssdFbMMWvdJCL3iC/6oF5MqPrqc7chmgjYKhvhAOJlVJBAflUo0S8kx
	 7Jgi0kwifR/TgD7NC9L0ldZ7E5lHBnyHPDLqiuTV5W4b3SJDr90Ut/LVU4s3NxlmzT
	 oc9eG2hW/v7NoiGdWeViBF1QrINUiF4tVkzDzxA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 13/82] udf: Convert udf_unlink() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:54 +0200
Message-ID: <20241021102247.754378226@linuxfoundation.org>
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

[ Upstream commit 6ec01a8020b54e278fecd1efe8603f8eb38fed84 ]

Convert udf_unlink() to new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -933,24 +933,17 @@ out:
 
 static int udf_unlink(struct inode *dir, struct dentry *dentry)
 {
-	int retval;
+	int ret;
 	struct inode *inode = d_inode(dentry);
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc *fi;
-	struct fileIdentDesc cfi;
+	struct udf_fileident_iter iter;
 	struct kernel_lb_addr tloc;
 
-	retval = -ENOENT;
-	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
-
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
 		goto end_unlink;
 
@@ -959,22 +952,16 @@ static int udf_unlink(struct inode *dir,
 			  inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
-	retval = udf_delete_entry(dir, fi, &fibh, &cfi);
-	if (retval)
-		goto end_unlink;
+	udf_fiiter_delete_entry(&iter);
 	dir->i_ctime = dir->i_mtime = current_time(dir);
 	mark_inode_dirty(dir);
 	inode_dec_link_count(inode);
 	inode->i_ctime = dir->i_ctime;
-	retval = 0;
-
+	ret = 0;
 end_unlink:
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-
+	udf_fiiter_release(&iter);
 out:
-	return retval;
+	return ret;
 }
 
 static int udf_symlink(struct user_namespace *mnt_userns, struct inode *dir,


