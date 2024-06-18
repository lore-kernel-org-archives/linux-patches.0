Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2658156F39;
	Tue, 18 Jun 2024 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715796; cv=none; b=C+8TWWN7Lxw4llSAAI8TP68jiaz85ONoa/+hWz2yKqeGU2qaa9K4n3aveKeNTFVBeeVtXC7SVif31D8rx4L8VcuMTXeWp4IFsuRdUPh8AKWnJQnyiL0xYPyzyH7eGSyW0TPSrLgEs1zTOJt6ysi39XEeT2qDI/EdlDZ9zVzt0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715796; c=relaxed/simple;
	bh=8P65SD5xEbefaxqwbKzgh6ezde6AmI+P0uHvbzBTKNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxCuw/eopj3ojpZjVm08r0Kljs5Hv6UWvlkkfZjbPuT8Qs+WXFVxPPjvNGgKl6JLKeR6lVrnMmAJLr3vMqp4e/p195CeJh7s5rWF7tCcBZCG/7a4UsXXEAVmR1iuVXF+uFgTsnP7pvIP1sELCUy12f1nKhNEZQgc5jPHrj0JlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUDGwzrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUDGwzrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45619C3277B;
	Tue, 18 Jun 2024 13:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715796;
	bh=8P65SD5xEbefaxqwbKzgh6ezde6AmI+P0uHvbzBTKNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUDGwzrO2PasAXF6IF2bTXIvnt4hzT7Dodae78vIlwq6oFTdk60CozLfDrJi6q/Fn
	 sM4/c0S+MgeeSsDkQ3yI1Xayo0t4TcRm+gzVUsEq/tlbctH5G/U4a8v8qoFC9MKOpy
	 KMdA+8J7ifccqEppV8gfJAuRn3TbZQwtf3QVuBDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/770] fanotify: record old and new parent and name in FAN_RENAME event
Date: Tue, 18 Jun 2024 14:34:25 +0200
Message-ID: <20240618123423.187774488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 3982534ba5ce45e890b2f5ef5e7372c1accd14c7 ]

In the special case of FAN_RENAME event, we record both the old
and new parent and name.

Link: https://lore.kernel.org/r/20211129201537.1932819-9-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 42 +++++++++++++++++++++++++++++++----
 include/uapi/linux/fanotify.h |  2 ++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 5f184b2d6ea7c..db81eab905442 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -592,21 +592,28 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 							__kernel_fsid_t *fsid,
 							const struct qstr *name,
 							struct inode *child,
+							struct dentry *moved,
 							unsigned int *hash,
 							gfp_t gfp)
 {
 	struct fanotify_name_event *fne;
 	struct fanotify_info *info;
 	struct fanotify_fh *dfh, *ffh;
+	struct inode *dir2 = moved ? d_inode(moved->d_parent) : NULL;
+	const struct qstr *name2 = moved ? &moved->d_name : NULL;
 	unsigned int dir_fh_len = fanotify_encode_fh_len(dir);
+	unsigned int dir2_fh_len = fanotify_encode_fh_len(dir2);
 	unsigned int child_fh_len = fanotify_encode_fh_len(child);
 	unsigned long name_len = name ? name->len : 0;
+	unsigned long name2_len = name2 ? name2->len : 0;
 	unsigned int len, size;
 
 	/* Reserve terminating null byte even for empty name */
-	size = sizeof(*fne) + name_len + 1;
+	size = sizeof(*fne) + name_len + name2_len + 2;
 	if (dir_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + dir_fh_len;
+	if (dir2_fh_len)
+		size += FANOTIFY_FH_HDR_LEN + dir2_fh_len;
 	if (child_fh_len)
 		size += FANOTIFY_FH_HDR_LEN + child_fh_len;
 	fne = kmalloc(size, gfp);
@@ -623,6 +630,11 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 		len = fanotify_encode_fh(dfh, dir, dir_fh_len, hash, 0);
 		fanotify_info_set_dir_fh(info, len);
 	}
+	if (dir2_fh_len) {
+		dfh = fanotify_info_dir2_fh(info);
+		len = fanotify_encode_fh(dfh, dir2, dir2_fh_len, hash, 0);
+		fanotify_info_set_dir2_fh(info, len);
+	}
 	if (child_fh_len) {
 		ffh = fanotify_info_file_fh(info);
 		len = fanotify_encode_fh(ffh, child, child_fh_len, hash, 0);
@@ -632,11 +644,22 @@ static struct fanotify_event *fanotify_alloc_name_event(struct inode *dir,
 		fanotify_info_copy_name(info, name);
 		*hash ^= full_name_hash((void *)name_len, name->name, name_len);
 	}
+	if (name2_len) {
+		fanotify_info_copy_name2(info, name2);
+		*hash ^= full_name_hash((void *)name2_len, name2->name,
+					name2_len);
+	}
 
 	pr_debug("%s: size=%u dir_fh_len=%u child_fh_len=%u name_len=%u name='%.*s'\n",
 		 __func__, size, dir_fh_len, child_fh_len,
 		 info->name_len, info->name_len, fanotify_info_name(info));
 
+	if (dir2_fh_len) {
+		pr_debug("%s: dir2_fh_len=%u name2_len=%u name2='%.*s'\n",
+			 __func__, dir2_fh_len, info->name2_len,
+			 info->name2_len, fanotify_info_name2(info));
+	}
+
 	return &fne->fae;
 }
 
@@ -692,6 +715,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	struct inode *dirid = fanotify_dfid_inode(mask, data, data_type, dir);
 	const struct path *path = fsnotify_data_path(data, data_type);
 	struct mem_cgroup *old_memcg;
+	struct dentry *moved = NULL;
 	struct inode *child = NULL;
 	bool name_event = false;
 	unsigned int hash = 0;
@@ -727,6 +751,15 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		} else if ((mask & ALL_FSNOTIFY_DIRENT_EVENTS) || !ondir) {
 			name_event = true;
 		}
+
+		/*
+		 * In the special case of FAN_RENAME event, we record both
+		 * old and new parent+name.
+		 * 'dirid' and 'file_name' are the old parent+name and
+		 * 'moved' has the new parent+name.
+		 */
+		if (mask & FAN_RENAME)
+			moved = fsnotify_data_dentry(data, data_type);
 	}
 
 	/*
@@ -748,9 +781,9 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	} else if (fanotify_is_error_event(mask)) {
 		event = fanotify_alloc_error_event(group, fsid, data,
 						   data_type, &hash);
-	} else if (name_event && (file_name || child)) {
-		event = fanotify_alloc_name_event(id, fsid, file_name, child,
-						  &hash, gfp);
+	} else if (name_event && (file_name || moved || child)) {
+		event = fanotify_alloc_name_event(dirid, fsid, file_name, child,
+						  moved, &hash, gfp);
 	} else if (fid_mode) {
 		event = fanotify_alloc_fid_event(id, fsid, &hash, gfp);
 	} else {
@@ -860,6 +893,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_OPEN_EXEC != FS_OPEN_EXEC);
 	BUILD_BUG_ON(FAN_OPEN_EXEC_PERM != FS_OPEN_EXEC_PERM);
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
+	BUILD_BUG_ON(FAN_RENAME != FS_RENAME);
 
 	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 20);
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 60f73639a896a..9d0e2dc5767b5 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -28,6 +28,8 @@
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* Interested in child events */
 
+#define FAN_RENAME		0x10000000	/* File was renamed */
+
 #define FAN_ONDIR		0x40000000	/* Event occurred against dir */
 
 /* helper events */
-- 
2.43.0



