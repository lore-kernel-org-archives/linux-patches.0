Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985F1CB9F0;
	Wed, 19 Feb 2025 08:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954118; cv=none; b=OEHn7Xu7RrtNfFh7ZKkAsdfRKMxxRAsgxlULm1UfIaCP8H5MkldhSRHK5oRU68b1MQUCcOj6vQwEYkYhA5oFb+sLPzKK06Hn+9WChrzo3Frnu3tq6m6XSJtzN+dB+aUgE1Y1ISE6ZQ8/52dHQwdiSX9c0mOj7XHvXO/CVhzDO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954118; c=relaxed/simple;
	bh=iMorHAaznu9z2LB8TKES790hLGx//NjTr8C0c3Hnw1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv5iYupiNxPm7NNylGai0rTvokWk1YmtJjopqn8jD9LyqFwVZCu1VObgjRIBjbX2a8c/iNeXZ+dJAWQp7yBkjWBAhMgAgL9rzrIBgej0cXxgCGpj1WDTHEFWRvDpWHExDpef+oTOrWlJLM3AIOAUzsuXx2fgfzAfGCix71g6v6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeRJAcir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeRJAcir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F715C4CED1;
	Wed, 19 Feb 2025 08:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954118;
	bh=iMorHAaznu9z2LB8TKES790hLGx//NjTr8C0c3Hnw1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeRJAcirtL+oN1npYh8TT+Nw5F9QYHONE0nDqxFu/3kJYvzxEGd+Rd9cGU3Lhdjeq
	 HWY5F14u1tW+BtweYJHQFI5UMZWhURPrXdwBJkCloE56PLU3hNpTaaCcUHgICUQRYk
	 XLlG2JpjKOIqbKqFTYNkRbvgfOLSLIVZS3X6oWu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 101/274] fs/ntfs3: Unify inode corruption marking with _ntfs_bad_inode()
Date: Wed, 19 Feb 2025 09:25:55 +0100
Message-ID: <20250219082613.571773198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 55ad333de0f80bc0caee10c6c27196cdcf8891bb ]

Also reworked error handling in a couple of places.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c  |  4 ++--
 fs/ntfs3/dir.c     |  2 +-
 fs/ntfs3/frecord.c | 12 +++++++-----
 fs/ntfs3/fsntfs.c  |  6 +++++-
 fs/ntfs3/index.c   |  6 ++----
 fs/ntfs3/inode.c   |  3 +++
 6 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 795cf8e75d2ea..af94e3737470d 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1407,7 +1407,7 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	 */
 	if (!attr->non_res) {
 		if (vbo[1] + bytes_per_off > le32_to_cpu(attr->res.data_size)) {
-			ntfs_inode_err(&ni->vfs_inode, "is corrupted");
+			_ntfs_bad_inode(&ni->vfs_inode);
 			return -EINVAL;
 		}
 		addr = resident_data(attr);
@@ -2588,7 +2588,7 @@ int attr_force_nonresident(struct ntfs_inode *ni)
 
 	attr = ni_find_attr(ni, NULL, &le, ATTR_DATA, NULL, 0, NULL, &mi);
 	if (!attr) {
-		ntfs_bad_inode(&ni->vfs_inode, "no data attribute");
+		_ntfs_bad_inode(&ni->vfs_inode);
 		return -ENOENT;
 	}
 
diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index fc6a8aa29e3af..b6da80c69ca63 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -512,7 +512,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos = pos;
 	} else if (err < 0) {
 		if (err == -EINVAL)
-			ntfs_inode_err(dir, "directory corrupted");
+			_ntfs_bad_inode(dir);
 		ctx->pos = eod;
 	}
 
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b9d6cb1fb54f4..f66186dbeda9d 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -148,8 +148,10 @@ int ni_load_mi_ex(struct ntfs_inode *ni, CLST rno, struct mft_inode **mi)
 		goto out;
 
 	err = mi_get(ni->mi.sbi, rno, &r);
-	if (err)
+	if (err) {
+		_ntfs_bad_inode(&ni->vfs_inode);
 		return err;
+	}
 
 	ni_add_mi(ni, r);
 
@@ -239,8 +241,7 @@ struct ATTRIB *ni_find_attr(struct ntfs_inode *ni, struct ATTRIB *attr,
 	return attr;
 
 out:
-	ntfs_inode_err(&ni->vfs_inode, "failed to parse mft record");
-	ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+	_ntfs_bad_inode(&ni->vfs_inode);
 	return NULL;
 }
 
@@ -332,6 +333,7 @@ struct ATTRIB *ni_load_attr(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	    vcn <= le64_to_cpu(attr->nres.evcn))
 		return attr;
 
+	_ntfs_bad_inode(&ni->vfs_inode);
 	return NULL;
 }
 
@@ -1607,8 +1609,8 @@ int ni_delete_all(struct ntfs_inode *ni)
 		roff = le16_to_cpu(attr->nres.run_off);
 
 		if (roff > asize) {
-			_ntfs_bad_inode(&ni->vfs_inode);
-			return -EINVAL;
+			/* ni_enum_attr_ex checks this case. */
+			continue;
 		}
 
 		/* run==1 means unpack and deallocate. */
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 03471bc9371cd..938d351ebac72 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -908,7 +908,11 @@ void ntfs_bad_inode(struct inode *inode, const char *hint)
 
 	ntfs_inode_err(inode, "%s", hint);
 	make_bad_inode(inode);
-	ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
+	/* Avoid recursion if bad inode is $Volume. */
+	if (inode->i_ino != MFT_REC_VOL &&
+	    !(sbi->flags & NTFS_FLAGS_LOG_REPLAYING)) {
+		ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
+	}
 }
 
 /*
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 9089c58a005ce..7eb9fae22f8da 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1094,8 +1094,7 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
 
 ok:
 	if (!index_buf_check(ib, bytes, &vbn)) {
-		ntfs_inode_err(&ni->vfs_inode, "directory corrupted");
-		ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+		_ntfs_bad_inode(&ni->vfs_inode);
 		err = -EINVAL;
 		goto out;
 	}
@@ -1117,8 +1116,7 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
 
 out:
 	if (err == -E_NTFS_CORRUPT) {
-		ntfs_inode_err(&ni->vfs_inode, "directory corrupted");
-		ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+		_ntfs_bad_inode(&ni->vfs_inode);
 		err = -EINVAL;
 	}
 
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index be04d2845bb7b..a1e11228dafd0 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -410,6 +410,9 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	if (!std5)
 		goto out;
 
+	if (is_bad_inode(inode))
+		goto out;
+
 	if (!is_match && name) {
 		err = -ENOENT;
 		goto out;
-- 
2.39.5



