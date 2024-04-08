Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBDC7EF1F;
	Mon,  8 Apr 2024 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582869; cv=none; b=B++NcSHZkCPe8JTf3bvQER3l2gSBcGbNLDONBKBmqIIjcADb+cECW1c536JwBqEVMbXtvYSl8tysjho7yrQsdgiH7njf4lkjUFyAizwl4ewmB4Bk2xK2VeW734YhrJ/mwpHhvckXLdJRWyfbYE8/KoyS1dSLLqtlmdWpmABcC3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582869; c=relaxed/simple;
	bh=Kz1g8AvD2axPeBN9UcMurfBm3GeXmMgV7ztFXp7vNqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwDOyFJ8Agm+TF3k3hXyyOh4nNIgZs1Cg1RulVaddqAzRK9C0rXpdh2tmM0p8HFnFCC2iiAVU8WLoIPnyjh0W9QKR4oNqVqLsxkrPvAuAhpYtZP3j6taEKxzNOEPZY6Ld4nyR+b7nGHZCVr2MNVHakbiXt+nmFTdMBUQZ8CdTgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCCyJQfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCCyJQfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95055C433F1;
	Mon,  8 Apr 2024 13:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582869;
	bh=Kz1g8AvD2axPeBN9UcMurfBm3GeXmMgV7ztFXp7vNqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCCyJQfVWzWl9KWM6T6y923gHzMw8ay2C1wPKwIV+uRUge0KcAKPnH6WtSfad1yXG
	 3QJklnIIFP1xxopXUAEy3qh2CEraWepu0Jgw36YJpeh/E7+HclpCOdOxUk/PjGvjAd
	 Bv1rxfTujP0aqEN5XpZXY97v54PZh0LkL/uefw08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 182/690] fsnotify: Support FS_ERROR event type
Date: Mon,  8 Apr 2024 14:50:48 +0200
Message-ID: <20240408125406.143642307@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
---
 include/linux/fsnotify.h         | 13 +++++++++++++
 include/linux/fsnotify_backend.h | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index a327a95fa68f1..67d6db6c8df8f 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -375,4 +375,17 @@ static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
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



