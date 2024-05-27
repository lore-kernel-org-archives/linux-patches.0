Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1CD262BE;
	Mon, 27 May 2024 19:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837866; cv=none; b=eIa8wAZbzg63PQrNDC8Mhegn/8+uYsiEJ3JE2OPOEEaMjTcOlh57GqIIcmaIl5EPJcCchGeO0tJBMxC+QoltTW2MIYPUbmZypfJ6ZaGMKa7pyJXKo+fraAZt2S0VWbGYIb2B+9a9XZb94LiKsLEbkrjEnU8F/z3vN5HdPg+54o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837866; c=relaxed/simple;
	bh=FBsz68IHjCAhmBPKQs4+mmBcmNYjbSeUsVB7blP5Ckc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHOgIiOfhg9qnv0xDviEOo7Xls0YyZuLuqfgF+Z1tlJv4OkQ9XyQHE7Nicphyss6driMkzWShg6pwcuWeZ2ug9l6051ssP3rUKx49K/60392NC6aSWsStrzw072Q8qKK/XAqLgVmdc3aiugdaVbf6ds3QNNVMFDfx3lDzwELKBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRJ1bpw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRJ1bpw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AEEC2BBFC;
	Mon, 27 May 2024 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837866;
	bh=FBsz68IHjCAhmBPKQs4+mmBcmNYjbSeUsVB7blP5Ckc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRJ1bpw3ukLVOqzYy0Q+slQk8oLxfMeWhDjRFfwezbBTbu2idrxvihmpDKZBGJjTI
	 DJXqU7taa9XJu96gaTxMKzk/ZnlNZgbMU5O8K5gkn7EMg+Kwzi1Tu7ZjxP5Ct1O/56
	 BnX1j+S7rGL47E+LRAHQ4q5E744A5CT+FRX4t324=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 134/493] libfs: Add simple_offset_rename() API
Date: Mon, 27 May 2024 20:52:16 +0200
Message-ID: <20240527185634.851133262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5a1a25be995e1014abd01600479915683e356f5c ]

I'm about to fix a tmpfs rename bug that requires the use of
internal simple_offset helpers that are not available in mm/shmem.c

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20240415152057.4605-3-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: ad191eb6d694 ("shmem: Fix shmem_rename2()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c         | 21 +++++++++++++++++++++
 include/linux/fs.h |  2 ++
 mm/shmem.c         |  3 +--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index c9516f3e14bb7..bb6731fa63059 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -356,6 +356,27 @@ int simple_offset_empty(struct dentry *dentry)
 	return ret;
 }
 
+/**
+ * simple_offset_rename - handle directory offsets for rename
+ * @old_dir: parent directory of source entry
+ * @old_dentry: dentry of source entry
+ * @new_dir: parent_directory of destination entry
+ * @new_dentry: dentry of destination
+ *
+ * Caller provides appropriate serialization.
+ *
+ * Returns zero on success, a negative errno value on failure.
+ */
+int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
+	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
+
+	simple_offset_remove(old_ctx, old_dentry);
+	return simple_offset_add(new_ctx, old_dentry);
+}
+
 /**
  * simple_offset_rename_exchange - exchange rename with directory offsets
  * @old_dir: parent of dentry being moved
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3350f875ca91c..10e32c8ef1e9c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3268,6 +3268,8 @@ void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
 int simple_offset_empty(struct dentry *dentry);
+int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
 				  struct inode *new_dir,
diff --git a/mm/shmem.c b/mm/shmem.c
index 0e951fe9f44cc..935f3647bb3a1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3434,8 +3434,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 			return error;
 	}
 
-	simple_offset_remove(shmem_get_offset_ctx(old_dir), old_dentry);
-	error = simple_offset_add(shmem_get_offset_ctx(new_dir), old_dentry);
+	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (error)
 		return error;
 
-- 
2.43.0



