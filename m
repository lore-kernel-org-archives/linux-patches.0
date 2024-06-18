Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A67156972;
	Tue, 18 Jun 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715600; cv=none; b=rvAYT9Y1LElO9oc8dSv6i3yXhBp7U8gIg2bLO3PLWi7IjkCEnTgLAg0W9/+pilmP1lw8B2+9MfoTpKWNb894hqh+noOUv1Q3ihVghtqZZ4zOjHtlt7OSejGfTmTYiniznBYfFIPrNqhu5NENEvodm2IFAjE0YehpCKLwa+wZEKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715600; c=relaxed/simple;
	bh=5quCdbo7dXCrptNl9rK8PpnzK6lVR8HUP5SRqEuxPmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euMLyOg8P4OmpJojphJCgdQ+UpAK9F8OBXikQ4VveEuLlMCO553PlZP/WO4Y6hXFnN70KKRsgYe1H8KKQlD6cn6w/Q0ddV/9MfSVOWH5/2cgWxhNZU4viTw2PTW1heC6ywSdBMXErm780rMxE9aaEChOoaoQn7QcZ9gE8498eMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TENdqlJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TENdqlJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596F7C3277B;
	Tue, 18 Jun 2024 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715600;
	bh=5quCdbo7dXCrptNl9rK8PpnzK6lVR8HUP5SRqEuxPmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TENdqlJNJ3Lv6Of8jekJEhICDnGa/cKzo/U3TXXeZ1064vMSOEPjY5jUWWd+lWn81
	 mG0dNOQ7PFyPMix53EOiyH4xcbbQkeNLV+Z5cpB2iUBdxc1TNxwnQVOTeH2IjHqJC4
	 7V/IKTiQG37aDPB0T1R4TXnRYjv7e8+mJniHJTuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/770] fsnotify: clarify contract for create event hooks
Date: Tue, 18 Jun 2024 14:33:36 +0200
Message-ID: <20240618123421.281051332@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fsnotify.h | 22 ++++++++++++++++------
 kernel/audit_fsnotify.c  |  3 +--
 kernel/audit_watch.c     |  3 +--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index e969a23f70631..addca4ea56ad9 100644
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
@@ -267,12 +273,16 @@ static inline void fsnotify_unlink(struct inode *dir, struct dentry *dentry)
 
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
index b2ebacd2f3097..76a5925b4e18d 100644
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



