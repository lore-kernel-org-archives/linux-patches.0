Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E28418040;
	Tue, 18 Jun 2024 12:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715523; cv=none; b=ZUVoDlhopQEQvGgCqiCZqUlI7EvxkF86K5CCXu/+6TPLHE5fk2mZB2zdU/24m7NVY/R0sK+sGEnSVuKhCHXHJ8kDO6OG6eFOe5/IPqSqTDJsyDVvEOcGUnWRtxWSLNLOAteKI9kFw3vqpORqX5EYz68LzvpSu14UhcEXgR0Vdyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715523; c=relaxed/simple;
	bh=HYrjqZ//ZGSHOjeDKCNwSYV1I7KVULO/U5KlLDZKF1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Bowi7v4PCc+2s1GZ7YoL4lKPz+CSpmv4Kt6lJ3ldYkM/qNxFNUjukYCIx3/cuFE7pCX4pxy5g6fEFcaeN+vgyPlXyRl8yK8TVUz17uLL7De5kVp1oSkH5qBnMJIH+MO2pPiGk0hCjDCHlUtLOfYbLnBAVEAGorXx6Otmn2tpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/UehwH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/UehwH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A08C3277B;
	Tue, 18 Jun 2024 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715523;
	bh=HYrjqZ//ZGSHOjeDKCNwSYV1I7KVULO/U5KlLDZKF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/UehwH7PMUb7K1gqz5KCEduu779vc2Xx0MWrm62yJpsY5pzhbzCgiteEanDy1Piq
	 rkPA9struEuqWHwuOxlMLJ5DB4fMCBHLMilgnNeJ7FPCCrbPunfB0WXGdR2uB0ZxO8
	 fw8O9nF+vXDcLBlK4mIBG1L3cvj7ViN3kQuteiy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/770] fsnotify: count s_fsnotify_inode_refs for attached connectors
Date: Tue, 18 Jun 2024 14:33:10 +0200
Message-ID: <20240618123420.275803276@linuxfoundation.org>
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

[ Upstream commit 11fa333b58ba1518e7c69fafb6513a0117f8fe33 ]

Instead of incrementing s_fsnotify_inode_refs when detaching connector
from inode, increment it earlier when attaching connector to inode.
Next patch is going to use s_fsnotify_inode_refs to count all objects
with attached connectors.

Link: https://lore.kernel.org/r/20210810151220.285179-3-amir73il@gmail.com
Reviewed-by: Matthew Bobrowski <repnop@google.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/mark.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 3c8fc77d3f072..f6d1ad3ecca2a 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -169,6 +169,21 @@ static void fsnotify_connector_destroy_workfn(struct work_struct *work)
 	}
 }
 
+static void fsnotify_get_inode_ref(struct inode *inode)
+{
+	ihold(inode);
+	atomic_long_inc(&inode->i_sb->s_fsnotify_inode_refs);
+}
+
+static void fsnotify_put_inode_ref(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	iput(inode);
+	if (atomic_long_dec_and_test(&sb->s_fsnotify_inode_refs))
+		wake_up_var(&sb->s_fsnotify_inode_refs);
+}
+
 static void *fsnotify_detach_connector_from_object(
 					struct fsnotify_mark_connector *conn,
 					unsigned int *type)
@@ -182,7 +197,6 @@ static void *fsnotify_detach_connector_from_object(
 	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE) {
 		inode = fsnotify_conn_inode(conn);
 		inode->i_fsnotify_mask = 0;
-		atomic_long_inc(&inode->i_sb->s_fsnotify_inode_refs);
 	} else if (conn->type == FSNOTIFY_OBJ_TYPE_VFSMOUNT) {
 		fsnotify_conn_mount(conn)->mnt_fsnotify_mask = 0;
 	} else if (conn->type == FSNOTIFY_OBJ_TYPE_SB) {
@@ -209,19 +223,12 @@ static void fsnotify_final_mark_destroy(struct fsnotify_mark *mark)
 /* Drop object reference originally held by a connector */
 static void fsnotify_drop_object(unsigned int type, void *objp)
 {
-	struct inode *inode;
-	struct super_block *sb;
-
 	if (!objp)
 		return;
 	/* Currently only inode references are passed to be dropped */
 	if (WARN_ON_ONCE(type != FSNOTIFY_OBJ_TYPE_INODE))
 		return;
-	inode = objp;
-	sb = inode->i_sb;
-	iput(inode);
-	if (atomic_long_dec_and_test(&sb->s_fsnotify_inode_refs))
-		wake_up_var(&sb->s_fsnotify_inode_refs);
+	fsnotify_put_inode_ref(objp);
 }
 
 void fsnotify_put_mark(struct fsnotify_mark *mark)
@@ -495,7 +502,7 @@ static int fsnotify_attach_connector_to_object(fsnotify_connp_t *connp,
 	}
 	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE) {
 		inode = fsnotify_conn_inode(conn);
-		ihold(inode);
+		fsnotify_get_inode_ref(inode);
 	}
 
 	/*
@@ -505,7 +512,7 @@ static int fsnotify_attach_connector_to_object(fsnotify_connp_t *connp,
 	if (cmpxchg(connp, NULL, conn)) {
 		/* Someone else created list structure for us */
 		if (inode)
-			iput(inode);
+			fsnotify_put_inode_ref(inode);
 		kmem_cache_free(fsnotify_mark_connector_cachep, conn);
 	}
 
-- 
2.43.0



