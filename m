Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1BC78286;
	Mon,  8 Apr 2024 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582895; cv=none; b=Z36kIQFi21rPm5ZzkQye6XXH42autihqUOlm7tkbG4+iDoBXj5lZkzo6WBkWqq4lVKJ542ka/2AdsJNJOUKVthEZySDKG185WYFpAFN+JbMEi0ZfSxlvgF2VWR3cgVTG9hnGr8d7TlA+xOtUJ6LU/aRmxkF9dALdw4A4ZvNYCGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582895; c=relaxed/simple;
	bh=CjXwFn1cl35r8jpMEQt6o0kIVEhmY1lUacymVU1oEoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYt83n8bhtTJBG7rArspbFqcEwSEy2zD3jJLcTZjTDQwkFdt/Rj3Ybg8WLlh1rJSkTOguWmqZDUtNSBIEkH6TrHKz9NHDruEDXACtL1Oj1CCUSTXnH6ISgIrX4dCfehYcy5EJKlidIBc4LIAWmKUXFT5ONDapVSIQZjC6CaRt+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odw8yzQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odw8yzQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A203C433C7;
	Mon,  8 Apr 2024 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582895;
	bh=CjXwFn1cl35r8jpMEQt6o0kIVEhmY1lUacymVU1oEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odw8yzQIWtoBN6JwIAG7uWmMCokwKZrnqT0WciFpWObDDZkQB2qe/Ef8Y9E7qhd24
	 lDxRd6cFL+bQDOJw3MCYFVTkbI2Z/B9zGkfIrfQwif0y8Ep6paP3x8gPcQIot/CHJR
	 NdeQv5xhLWFQJLA3ndzNXfclBB5/a9ohrP+r8QkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 168/690] fsnotify: clarify contract for create event hooks
Date: Mon,  8 Apr 2024 14:50:34 +0200
Message-ID: <20240408125405.653551146@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit dabe729dddca550446e9cc118c96d1f91703345b ]

Clarify argument names and contract for fsnotify_create() and
fsnotify_mkdir() to reflect the anomaly of kernfs, which leaves dentries
negavite after mkdir/create.

Remove the WARN_ON(!inode) in audit code that were added by the Fixes
commit under the wrong assumption that dentries cannot be negative after
mkdir/create.

Fixes: aa93bdc5500c ("fsnotify: use helpers to access data by data_type")
Link: https://lore.kernel.org/linux-fsdevel/87mtp5yz0q.fsf@collabora.com/
Link: https://lore.kernel.org/r/20211025192746.66445-4-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/fsnotify.h | 22 ++++++++++++++++------
 kernel/audit_fsnotify.c  |  3 +--
 kernel/audit_watch.c     |  3 +--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 70e6b147a76ad..a327a95fa68f1 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -192,16 +192,22 @@ static inline void fsnotify_inoderemove(struct inode *inode)
 
 /*
  * fsnotify_create - 'name' was linked in
+ *
+ * Caller must make sure that dentry->d_name is stable.
+ * Note: some filesystems (e.g. kernfs) leave @dentry negative and instantiate
+ * ->d_inode later
  */
-static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
+static inline void fsnotify_create(struct inode *dir, struct dentry *dentry)
 {
-	audit_inode_child(inode, dentry, AUDIT_TYPE_CHILD_CREATE);
+	audit_inode_child(dir, dentry, AUDIT_TYPE_CHILD_CREATE);
 
-	fsnotify_dirent(inode, dentry, FS_CREATE);
+	fsnotify_dirent(dir, dentry, FS_CREATE);
 }
 
 /*
  * fsnotify_link - new hardlink in 'inode' directory
+ *
+ * Caller must make sure that new_dentry->d_name is stable.
  * Note: We have to pass also the linked inode ptr as some filesystems leave
  *   new_dentry->d_inode NULL and instantiate inode pointer later
  */
@@ -266,12 +272,16 @@ static inline void fsnotify_unlink(struct inode *dir, struct dentry *dentry)
 
 /*
  * fsnotify_mkdir - directory 'name' was created
+ *
+ * Caller must make sure that dentry->d_name is stable.
+ * Note: some filesystems (e.g. kernfs) leave @dentry negative and instantiate
+ * ->d_inode later
  */
-static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
+static inline void fsnotify_mkdir(struct inode *dir, struct dentry *dentry)
 {
-	audit_inode_child(inode, dentry, AUDIT_TYPE_CHILD_CREATE);
+	audit_inode_child(dir, dentry, AUDIT_TYPE_CHILD_CREATE);
 
-	fsnotify_dirent(inode, dentry, FS_CREATE | FS_ISDIR);
+	fsnotify_dirent(dir, dentry, FS_CREATE | FS_ISDIR);
 }
 
 /*
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index c428312938e95..7a506b65e8630 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -161,8 +161,7 @@ static int audit_mark_handle_event(struct fsnotify_mark *inode_mark, u32 mask,
 
 	audit_mark = container_of(inode_mark, struct audit_fsnotify_mark, mark);
 
-	if (WARN_ON_ONCE(inode_mark->group != audit_fsnotify_group) ||
-	    WARN_ON_ONCE(!inode))
+	if (WARN_ON_ONCE(inode_mark->group != audit_fsnotify_group))
 		return 0;
 
 	if (mask & (FS_CREATE|FS_MOVED_TO|FS_DELETE|FS_MOVED_FROM)) {
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index edbeffee64b8e..fd7b30a2d9a4b 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -472,8 +472,7 @@ static int audit_watch_handle_event(struct fsnotify_mark *inode_mark, u32 mask,
 
 	parent = container_of(inode_mark, struct audit_parent, mark);
 
-	if (WARN_ON_ONCE(inode_mark->group != audit_watch_group) ||
-	    WARN_ON_ONCE(!inode))
+	if (WARN_ON_ONCE(inode_mark->group != audit_watch_group))
 		return 0;
 
 	if (mask & (FS_CREATE|FS_MOVED_TO) && inode)
-- 
2.43.0



