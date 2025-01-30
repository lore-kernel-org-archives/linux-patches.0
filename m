Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0810383;
	Thu, 30 Jan 2025 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246595; cv=none; b=VDiyZXTVAMjknHpyOJSgQF4WWJEW0MbwvMcsnUTY5dTEuwILT5mlzykak4s5lqaI+tyP/hEaEK9CYKbwjDbHA3YAMhxt9+cigdZv9NOfC97G0zsPWk74/V2v1OM8rJryFyh+2fV+Mvnc7nz75GHVAysfXdVEB16eneYFXHlM12M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246595; c=relaxed/simple;
	bh=7QEo35yNbomkeVDI1btvimA9bZ6plkhVFI2LqgkjWdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2PfhsCCGi3L3ZiW51HgTk2oeEolSQExxllpLfax7cSuQtrnZawHACj+BFUvYNECrcatawq3cXhr1Vc3v5jJyt2R9LWni/JoNZarCouPRApzKpyl0ZadKWKh43tc7tepwAh5SesTrehyK32Px75w9XxFsWuf+3lDjYp1ACWmaro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXmARDLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXmARDLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BD1C4CED2;
	Thu, 30 Jan 2025 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246595;
	bh=7QEo35yNbomkeVDI1btvimA9bZ6plkhVFI2LqgkjWdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXmARDLNPRtad1r1XDPJ+/Wqrhaqd7uPqmPNarWh3wwmIe6gHVRWNoXRTSftTE9fc
	 GUUnQLABqg+wCk07MiQMoSiHPLmDYMRRNWSW0Wpp1yd4x1pE8gHh3xuQXKepf+pjC7
	 hTJ2LKa6j9m2nVdpx69ouNmGadJh5dCn4jkAPD1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 19/43] libfs: Add simple_offset_rename() API
Date: Thu, 30 Jan 2025 14:59:26 +0100
Message-ID: <20250130133459.677341659@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5a1a25be995e1014abd01600479915683e356f5c ]

I'm about to fix a tmpfs rename bug that requires the use of
internal simple_offset helpers that are not available in mm/shmem.c

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20240415152057.4605-3-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c         |   21 +++++++++++++++++++++
 include/linux/fs.h |    2 ++
 mm/shmem.c         |    3 +--
 3 files changed, 24 insertions(+), 2 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -357,6 +357,27 @@ int simple_offset_empty(struct dentry *d
 }
 
 /**
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
+/**
  * simple_offset_rename_exchange - exchange rename with directory offsets
  * @old_dir: parent of dentry being moved
  * @old_dentry: dentry being moved
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3198,6 +3198,8 @@ void simple_offset_init(struct offset_ct
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
 int simple_offset_empty(struct dentry *dentry);
+int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
 				  struct inode *new_dir,
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3434,8 +3434,7 @@ static int shmem_rename2(struct mnt_idma
 			return error;
 	}
 
-	simple_offset_remove(shmem_get_offset_ctx(old_dir), old_dentry);
-	error = simple_offset_add(shmem_get_offset_ctx(new_dir), old_dentry);
+	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (error)
 		return error;
 


