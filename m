Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14CB16CD3C;
	Tue, 18 Jun 2024 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715662; cv=none; b=G9/69TMqq0J/NgnZw7C9FNBYUPPh1lgNqmmQSOSLSJJXaKpq4F7tJCub+5NXo/c7p333MMmoQFUuuqZaXN8RtIMh0ZaGRD06dUEJHaBchtLtKzCbb6WW08D9b5piK2Q/d3pn+4qOdxKH0oP1+25tPU0rC48u5tY2KRPJOMrUi18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715662; c=relaxed/simple;
	bh=vpUfHnwEkgiKItFzu1qOCuLTOm5nxpV5e9bpJJUv02k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWRXAvqUgt9XDzckA8DAy+unBRoheJY6dvuNnI2AUGOq25LkG3jrQzm9wgMULD4xdFGmHqMxlLqauvtwc6D9xvL03k/4UHqF3B/rmM4F8/rITfgflRmN92Ib5+v1u6G2PQv0PtIEn1HDwJtuq3Z1jDUDbqjZrJBYjN5wRcMg77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWkH/gnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWkH/gnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE98AC3277B;
	Tue, 18 Jun 2024 13:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715662;
	bh=vpUfHnwEkgiKItFzu1qOCuLTOm5nxpV5e9bpJJUv02k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWkH/gnxA9c4axZ1T/6Sg0wfeYZxXv2zLI6YWkK18R+mmP++AZMPGRxVVJCimeVgj
	 sAZJi/RH56mh+z4sxxcyqkZ2yJ81FbNwPI8yDnrHMQLtDRv99R9uABBI/VL5wvOPWE
	 V8LanMMsmwkq7vpYlS4gZ0KY/ZZ7tlMfo2Yy9zQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 377/770] fsnotify: Support FS_ERROR event type
Date: Tue, 18 Jun 2024 14:33:50 +0200
Message-ID: <20240618123421.821738005@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 9daa811073fa19c08e8aad3b90f9235fed161acf ]

Expose a new type of fsnotify event for filesystems to report errors for
userspace monitoring tools.  fanotify will send this type of
notification for FAN_FS_ERROR events.  This also introduce a helper for
generating the new event.

Link: https://lore.kernel.org/r/20211025192746.66445-18-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fsnotify.h         | 13 +++++++++++++
 include/linux/fsnotify_backend.h | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index addca4ea56ad9..bec1e23ecf787 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -376,4 +376,17 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 		fsnotify_dentry(dentry, mask);
 }
 
+static inline int fsnotify_sb_error(struct super_block *sb, struct inode *inode,
+				    int error)
+{
+	struct fs_error_report report = {
+		.error = error,
+		.inode = inode,
+		.sb = sb,
+	};
+
+	return fsnotify(FS_ERROR, &report, FSNOTIFY_EVENT_ERROR,
+			NULL, NULL, NULL, 0);
+}
+
 #endif	/* _LINUX_FS_NOTIFY_H */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3a7c314361824..00dbaafbcf953 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -42,6 +42,12 @@
 
 #define FS_UNMOUNT		0x00002000	/* inode on umount fs */
 #define FS_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
+#define FS_ERROR		0x00008000	/* Filesystem Error (fanotify) */
+
+/*
+ * FS_IN_IGNORED overloads FS_ERROR.  It is only used internally by inotify
+ * which does not support FS_ERROR.
+ */
 #define FS_IN_IGNORED		0x00008000	/* last inotify event here */
 
 #define FS_OPEN_PERM		0x00010000	/* open event in an permission hook */
@@ -95,7 +101,8 @@
 #define ALL_FSNOTIFY_EVENTS (ALL_FSNOTIFY_DIRENT_EVENTS | \
 			     FS_EVENTS_POSS_ON_CHILD | \
 			     FS_DELETE_SELF | FS_MOVE_SELF | FS_DN_RENAME | \
-			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED)
+			     FS_UNMOUNT | FS_Q_OVERFLOW | FS_IN_IGNORED | \
+			     FS_ERROR)
 
 /* Extra flags that may be reported with event or control handling of events */
 #define ALL_FSNOTIFY_FLAGS  (FS_EXCL_UNLINK | FS_ISDIR | FS_IN_ONESHOT | \
@@ -250,6 +257,13 @@ enum fsnotify_data_type {
 	FSNOTIFY_EVENT_PATH,
 	FSNOTIFY_EVENT_INODE,
 	FSNOTIFY_EVENT_DENTRY,
+	FSNOTIFY_EVENT_ERROR,
+};
+
+struct fs_error_report {
+	int error;
+	struct inode *inode;
+	struct super_block *sb;
 };
 
 static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
@@ -261,6 +275,8 @@ static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
 		return d_inode(data);
 	case FSNOTIFY_EVENT_PATH:
 		return d_inode(((const struct path *)data)->dentry);
+	case FSNOTIFY_EVENT_ERROR:
+		return ((struct fs_error_report *)data)->inode;
 	default:
 		return NULL;
 	}
@@ -300,6 +316,20 @@ static inline struct super_block *fsnotify_data_sb(const void *data,
 		return ((struct dentry *)data)->d_sb;
 	case FSNOTIFY_EVENT_PATH:
 		return ((const struct path *)data)->dentry->d_sb;
+	case FSNOTIFY_EVENT_ERROR:
+		return ((struct fs_error_report *) data)->sb;
+	default:
+		return NULL;
+	}
+}
+
+static inline struct fs_error_report *fsnotify_data_error_report(
+							const void *data,
+							int data_type)
+{
+	switch (data_type) {
+	case FSNOTIFY_EVENT_ERROR:
+		return (struct fs_error_report *) data;
 	default:
 		return NULL;
 	}
-- 
2.43.0



