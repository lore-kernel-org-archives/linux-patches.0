Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392A2DF73;
	Mon,  8 Apr 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582781; cv=none; b=qy0KdLmyTAso13Fpze0x3bLg5SMOi9FE94uj0WEbXpfAjBtV1uOW7qQOrjekeCB/btzjOCNd3RXb+/6lUIOYyGMLX1QX6ybfZD+LdwQxXEf7YVRRH+Kuy0vkNobOeT7TPg8lnn1PWIkpCGtv9a1i4KoYz5vZXbFujQVSXijDNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582781; c=relaxed/simple;
	bh=v3HrEXbDqkM7qYYDrXTNypfWv13JMaLyhE79JE24H+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiGgs+IlJsBllkMQOlTc/yYNKxu+PwKNpO69yq91pspXhSu+Yu2GBI42/MCcaGmIn0zUl6buo64jNV/H+ArZj1CkrH7X3nP72j+ZneZ5tWjs0DGx6Qyrpp4zCmfIcDtknypa5tc3/DqymjpREvEAKLdesw3XUiMcieHpjL9eMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI1zNnWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI1zNnWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF04C433C7;
	Mon,  8 Apr 2024 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582781;
	bh=v3HrEXbDqkM7qYYDrXTNypfWv13JMaLyhE79JE24H+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI1zNnWXfLQsOzWC0dYD7SjcfPJVeMD1uT7MLz8yy5VtT3u+2JcPSirVdTWKFOiK6
	 coXrVEoxZWTjJDOmKQgGWODklYDHT6geoii+JPNLlSiTKm80hUdk7MGnhzfZXnGW6N
	 tQ9QBYvR+xy82ruMcNAtC8vSUYzNuQw76Y90lDL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 175/690] fsnotify: Retrieve super block from the data field
Date: Mon,  8 Apr 2024 14:50:41 +0200
Message-ID: <20240408125405.902604582@linuxfoundation.org>
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

[ Upstream commit 29335033c574a15334015d8c4e36862cff3d3384 ]

Some file system events (i.e. FS_ERROR) might not be associated with an
inode or directory.  For these, we can retrieve the super block from the
data field.  But, since the super_block is available in the data field
on every event type, simplify the code to always retrieve it from there,
through a new helper.

Link: https://lore.kernel.org/r/20211025192746.66445-11-krisman@collabora.com
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fsnotify.c             |  7 +++----
 include/linux/fsnotify_backend.h | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 963e6ce75b961..fde3a1115a170 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -455,16 +455,16 @@ static void fsnotify_iter_next(struct fsnotify_iter_info *iter_info)
  *		@file_name is relative to
  * @file_name:	optional file name associated with event
  * @inode:	optional inode associated with event -
- *		either @dir or @inode must be non-NULL.
- *		if both are non-NULL event may be reported to both.
+ *		If @dir and @inode are both non-NULL, event may be
+ *		reported to both.
  * @cookie:	inotify rename cookie
  */
 int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 	     const struct qstr *file_name, struct inode *inode, u32 cookie)
 {
 	const struct path *path = fsnotify_data_path(data, data_type);
+	struct super_block *sb = fsnotify_data_sb(data, data_type);
 	struct fsnotify_iter_info iter_info = {};
-	struct super_block *sb;
 	struct mount *mnt = NULL;
 	struct inode *parent = NULL;
 	int ret = 0;
@@ -483,7 +483,6 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 		 */
 		parent = dir;
 	}
-	sb = inode->i_sb;
 
 	/*
 	 * Optimization: srcu_read_lock() has a memory barrier which can
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b323d0c4b9671..035438fe4a435 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -289,6 +289,21 @@ static inline const struct path *fsnotify_data_path(const void *data,
 	}
 }
 
+static inline struct super_block *fsnotify_data_sb(const void *data,
+						   int data_type)
+{
+	switch (data_type) {
+	case FSNOTIFY_EVENT_INODE:
+		return ((struct inode *)data)->i_sb;
+	case FSNOTIFY_EVENT_DENTRY:
+		return ((struct dentry *)data)->d_sb;
+	case FSNOTIFY_EVENT_PATH:
+		return ((const struct path *)data)->dentry->d_sb;
+	default:
+		return NULL;
+	}
+}
+
 enum fsnotify_obj_type {
 	FSNOTIFY_OBJ_TYPE_INODE,
 	FSNOTIFY_OBJ_TYPE_PARENT,
-- 
2.43.0



