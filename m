Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173EF1F4738;
	Mon, 21 Oct 2024 10:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507361; cv=none; b=cf1KGTTKyMBD81CmiAGM192EsAgav1lGlzQ7bq83/iIwVEiVRHya3iN7OZfGn5TeH+LcI5FBd2dDl/L/rgVFNQAHdCtG7y9R85yQ8ovI2C+GJqRWNi3DM2TXUbIRWfQcunKXFK7GYXffyRUVO+tk1vOKBXmd+MnIBrngDrWt6Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507361; c=relaxed/simple;
	bh=+Saikuje5t57GItr0gcG9HpyVvddOKZb0oqlhRxqzew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsRoive3rtxwI2HbSznXGzHjZ/2zDoYmClat74zZ2sQtPTMMV8UqU286qxzBfnYhZ28uXiwGlR7n/GKIyDj7OOa+esFdIDE2sMRsd2thjj5q+u0CpyyWvry0kRCEEJdLT2he3sX/PyFEw1RSW9hsY3pd0fZdUt1s2JJQzPt1KHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKa7cOsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKa7cOsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0B7C4CEC3;
	Mon, 21 Oct 2024 10:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507360;
	bh=+Saikuje5t57GItr0gcG9HpyVvddOKZb0oqlhRxqzew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKa7cOscXp3aYnmysiU4HcxLv+xu2358/wgYwlrhMXib4ttaXrB6Hmf+ZiSAh+WVm
	 mxmzP2cXuYbbPXr+XD6zhWMG8Q/4JYnBvMghLWdjboLJqIL+BUnsXWzSv2diFHWAyH
	 Bi8TSzExPwilgelThbJobb8agCs0KNl2bPazqLXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 24/91] udf: Dont return bh from udf_expand_dir_adinicb()
Date: Mon, 21 Oct 2024 12:24:38 +0200
Message-ID: <20241021102250.768225945@linuxfoundation.org>
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

[ Upstream commit f386c802a6fda8f9fe4a5cf418c49aa84dfc52e4 ]

Nobody uses the bh returned from udf_expand_dir_adinicb(). Don't return
it.

Signed-off-by: Jan Kara <jack@suse.cz>
[cascardo: skip backport of 101ee137d32a ("udf: Drop VARCONV support")]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -136,8 +136,7 @@ static struct dentry *udf_lookup(struct
 	return d_splice_alias(inode, dentry);
 }
 
-static struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
-					udf_pblk_t *block, int *err)
+static int udf_expand_dir_adinicb(struct inode *inode, udf_pblk_t *block)
 {
 	udf_pblk_t newblock;
 	struct buffer_head *dbh = NULL;
@@ -157,23 +156,23 @@ static struct buffer_head *udf_expand_di
 	if (!inode->i_size) {
 		iinfo->i_alloc_type = alloctype;
 		mark_inode_dirty(inode);
-		return NULL;
+		return 0;
 	}
 
 	/* alloc block, and copy data to it */
 	*block = udf_new_block(inode->i_sb, inode,
 			       iinfo->i_location.partitionReferenceNum,
-			       iinfo->i_location.logicalBlockNum, err);
+			       iinfo->i_location.logicalBlockNum, &ret);
 	if (!(*block))
-		return NULL;
+		return ret;
 	newblock = udf_get_pblock(inode->i_sb, *block,
 				  iinfo->i_location.partitionReferenceNum,
 				0);
-	if (!newblock)
-		return NULL;
+	if (newblock == 0xffffffff)
+		return -EFSCORRUPTED;
 	dbh = udf_tgetblk(inode->i_sb, newblock);
 	if (!dbh)
-		return NULL;
+		return -ENOMEM;
 	lock_buffer(dbh);
 	memcpy(dbh->b_data, iinfo->i_data, inode->i_size);
 	memset(dbh->b_data + inode->i_size, 0,
@@ -195,9 +194,9 @@ static struct buffer_head *udf_expand_di
 	ret = udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
 	brelse(epos.bh);
 	if (ret < 0) {
-		*err = ret;
+		brelse(dbh);
 		udf_free_blocks(inode->i_sb, inode, &eloc, 0, 1);
-		return NULL;
+		return ret;
 	}
 	mark_inode_dirty(inode);
 
@@ -213,6 +212,7 @@ static struct buffer_head *udf_expand_di
 			impuse = NULL;
 		udf_fiiter_write_fi(&iter, impuse);
 	}
+	brelse(dbh);
 	/*
 	 * We don't expect the iteration to fail as the directory has been
 	 * already verified to be correct
@@ -220,7 +220,7 @@ static struct buffer_head *udf_expand_di
 	WARN_ON_ONCE(ret);
 	udf_fiiter_release(&iter);
 
-	return dbh;
+	return 0;
 }
 
 static int udf_fiiter_add_entry(struct inode *dir, struct dentry *dentry,
@@ -266,17 +266,10 @@ static int udf_fiiter_add_entry(struct i
 	}
 	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
 	    blksize - udf_ext0_offset(dir) - iter->pos < nfidlen) {
-		struct buffer_head *retbh;
-
 		udf_fiiter_release(iter);
-		/*
-		 * FIXME: udf_expand_dir_adinicb does not need to return bh
-		 * once other users are gone
-		 */
-		retbh = udf_expand_dir_adinicb(dir, &block, &ret);
-		if (!retbh)
+		ret = udf_expand_dir_adinicb(dir, &block);
+		if (ret)
 			return ret;
-		brelse(retbh);
 		ret = udf_fiiter_init(iter, dir, dir->i_size);
 		if (ret < 0)
 			return ret;


