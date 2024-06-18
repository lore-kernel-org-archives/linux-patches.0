Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C626178373;
	Tue, 18 Jun 2024 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715529; cv=none; b=mWrxaOXOLYzP9/LLp9KNfVt+Qm+DYfTdjZwHF/vbtpbB/VywaORVJguBsxiZ1hWmlljB7M9rSgbZejv0Kmz/vhENNrdZFLnA2bO4WObmbNbw954UE8D9TuivMcwOzSiuEmFZ9SBK9v59hKW122jItwMAXeg+FyfXmo5sDC+U6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715529; c=relaxed/simple;
	bh=S0rhNw7wt5iyuD9VA2LyfKeoKWq75Tkq1E4cCL/tSHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTl9Urok+rmcVCdmph5wz5iiCVvH76UfOUMxn2lH9iiF/1C2XGOsGaLM862LQpQ6Yrx3jSx0Vyft81PrWiAdok6lLJUG85s6ouJZIRjK7HSwe575y93kVWRdhUXKdujMGsK7z6C3C4swHMndfMEq6b2gRnbnRs2kY50sxQYsS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeYUdoQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeYUdoQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6F7C4AF1D;
	Tue, 18 Jun 2024 12:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715529;
	bh=S0rhNw7wt5iyuD9VA2LyfKeoKWq75Tkq1E4cCL/tSHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeYUdoQZ7bUNStOoyaRMvcZrjmMuv3KPZA1Q54Dl3mB2kcHXnFSb63WsxfXV/bAQN
	 34c9gGfcTXZBKdpLtoi+r/5RT8hnDwM8jGs1lH1CfhQsrUy/0nEmtjMrFPEqNmBbmH
	 sC+/wQRGVcY09IppylXy3UbVFcs8js5+vBYy9Jzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Matthew Bobrowski <repnop@google.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/770] fsnotify: count all objects with attached connectors
Date: Tue, 18 Jun 2024 14:33:11 +0200
Message-ID: <20240618123420.314663216@linuxfoundation.org>
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

[ Upstream commit ec44610fe2b86daef70f3f53f47d2a2542d7094f ]

Rename s_fsnotify_inode_refs to s_fsnotify_connectors and count all
objects with attached connectors, not only inodes with attached
connectors.

This will be used to optimize fsnotify() calls on sb without any
type of marks.

Link: https://lore.kernel.org/r/20210810151220.285179-4-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Matthew Bobrowski <repnop@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c |  6 +++---
 fs/notify/fsnotify.h | 15 +++++++++++++++
 fs/notify/mark.c     | 24 +++++++++++++++++++++---
 include/linux/fs.h   |  7 +++++--
 4 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 30d422b8c0fc7..963e6ce75b961 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -87,15 +87,15 @@ static void fsnotify_unmount_inodes(struct super_block *sb)
 
 	if (iput_inode)
 		iput(iput_inode);
-	/* Wait for outstanding inode references from connectors */
-	wait_var_event(&sb->s_fsnotify_inode_refs,
-		       !atomic_long_read(&sb->s_fsnotify_inode_refs));
 }
 
 void fsnotify_sb_delete(struct super_block *sb)
 {
 	fsnotify_unmount_inodes(sb);
 	fsnotify_clear_marks_by_sb(sb);
+	/* Wait for outstanding object references from connectors */
+	wait_var_event(&sb->s_fsnotify_connectors,
+		       !atomic_long_read(&sb->s_fsnotify_connectors));
 }
 
 /*
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index ff2063ec6b0f3..87d8a50ee8038 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -27,6 +27,21 @@ static inline struct super_block *fsnotify_conn_sb(
 	return container_of(conn->obj, struct super_block, s_fsnotify_marks);
 }
 
+static inline struct super_block *fsnotify_connector_sb(
+				struct fsnotify_mark_connector *conn)
+{
+	switch (conn->type) {
+	case FSNOTIFY_OBJ_TYPE_INODE:
+		return fsnotify_conn_inode(conn)->i_sb;
+	case FSNOTIFY_OBJ_TYPE_VFSMOUNT:
+		return fsnotify_conn_mount(conn)->mnt.mnt_sb;
+	case FSNOTIFY_OBJ_TYPE_SB:
+		return fsnotify_conn_sb(conn);
+	default:
+		return NULL;
+	}
+}
+
 /* destroy all events sitting in this groups notification queue */
 extern void fsnotify_flush_notify(struct fsnotify_group *group);
 
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index f6d1ad3ecca2a..796946eb0c2e2 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -172,7 +172,7 @@ static void fsnotify_connector_destroy_workfn(struct work_struct *work)
 static void fsnotify_get_inode_ref(struct inode *inode)
 {
 	ihold(inode);
-	atomic_long_inc(&inode->i_sb->s_fsnotify_inode_refs);
+	atomic_long_inc(&inode->i_sb->s_fsnotify_connectors);
 }
 
 static void fsnotify_put_inode_ref(struct inode *inode)
@@ -180,8 +180,24 @@ static void fsnotify_put_inode_ref(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 
 	iput(inode);
-	if (atomic_long_dec_and_test(&sb->s_fsnotify_inode_refs))
-		wake_up_var(&sb->s_fsnotify_inode_refs);
+	if (atomic_long_dec_and_test(&sb->s_fsnotify_connectors))
+		wake_up_var(&sb->s_fsnotify_connectors);
+}
+
+static void fsnotify_get_sb_connectors(struct fsnotify_mark_connector *conn)
+{
+	struct super_block *sb = fsnotify_connector_sb(conn);
+
+	if (sb)
+		atomic_long_inc(&sb->s_fsnotify_connectors);
+}
+
+static void fsnotify_put_sb_connectors(struct fsnotify_mark_connector *conn)
+{
+	struct super_block *sb = fsnotify_connector_sb(conn);
+
+	if (sb && atomic_long_dec_and_test(&sb->s_fsnotify_connectors))
+		wake_up_var(&sb->s_fsnotify_connectors);
 }
 
 static void *fsnotify_detach_connector_from_object(
@@ -203,6 +219,7 @@ static void *fsnotify_detach_connector_from_object(
 		fsnotify_conn_sb(conn)->s_fsnotify_mask = 0;
 	}
 
+	fsnotify_put_sb_connectors(conn);
 	rcu_assign_pointer(*(conn->obj), NULL);
 	conn->obj = NULL;
 	conn->type = FSNOTIFY_OBJ_TYPE_DETACHED;
@@ -504,6 +521,7 @@ static int fsnotify_attach_connector_to_object(fsnotify_connp_t *connp,
 		inode = fsnotify_conn_inode(conn);
 		fsnotify_get_inode_ref(inode);
 	}
+	fsnotify_get_sb_connectors(conn);
 
 	/*
 	 * cmpxchg() provides the barrier so that readers of *connp can see
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cc3b6ddf58223..a9ac60d3be1d6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1512,8 +1512,11 @@ struct super_block {
 	/* Number of inodes with nlink == 0 but still referenced */
 	atomic_long_t s_remove_count;
 
-	/* Pending fsnotify inode refs */
-	atomic_long_t s_fsnotify_inode_refs;
+	/*
+	 * Number of inode/mount/sb objects that are being watched, note that
+	 * inodes objects are currently double-accounted.
+	 */
+	atomic_long_t s_fsnotify_connectors;
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
-- 
2.43.0



