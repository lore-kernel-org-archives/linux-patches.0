Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C7D3E49C6;
	Tue, 21 Jul 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653661; cv=none; b=Ad5nTgcLWbOQVl2Rdl121TKRklIxevITvshFUybFa7v0HQxMXxHyj2A3O9AjF6Olnz9Bw8ZpJ6P3sPZ/KD4UnPe2uI8SsVKTbz/6elpoMdvDaAySwwgUCfNEPw8lHWOdxxvanZd9BUHZN55M/OzDd90v04zOVOsdZ16D/nBBcLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653661; c=relaxed/simple;
	bh=VFrVPDDicJmFil4cijh9y0zlBxsdZvQ82qokhaGNw9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPDc8J6MMI42GmgpZZk+5tnFv08GxxDPkeuD4INaCumSFgolQ7vvAfQc09CYnpPgVGQm0toW5AYx0dkCNhFbw2MY3zgHHKob+tlzQoBkzO5L7C3kbu37n8H3o0EZUbYEunMn9qp/TPoXsvaxuenIDThqNyY4c/XVkXzsLOv7O7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJelcoiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJelcoiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A4D1F000E9;
	Tue, 21 Jul 2026 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653660;
	bh=+bKJ2CAK/zhNsKbJPrO91GyVuDKRNgA9V2AqEVGhUIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJelcoiVJl6uLJHs6HBhLsKAFHQkR9NeytAUGzEgyph1QQ3CCaaNloe7qjUZLgiWR
	 dq4LCwHbWETCsZ1cTOPsTwzKJVwIu39L/Jw8bJS7TGVtls07k+uab1qj0y76QAJeVn
	 W1aVrjZuLIENxJQEFVeeUlN3qKqDt4fKTk2dbxBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1384/2077] afs: Fix lack of locking around modifications of net->cells_dyn_ino
Date: Tue, 21 Jul 2026 17:17:37 +0200
Message-ID: <20260721152625.460406388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 55e841836c6f4646490f7b0347192b7a92d431ba ]

Fix the lack of locking around modifications of net->cells_dyn_ino by
taking net->cells_lock exclusively.  This also requires to cell to be
removed from net->cells_dyn_ino in afs_destroy_cell_work() rather than in
afs_cell_destroy() as the latter runs in RCU cleanup context and sleeping
locks cannot be taken there.

Fixes: 1d0b929fc070 ("afs: Change dynroot to create contents on demand")
Closes: https://sashiko.dev/#/patchset/20260618074903.2374756-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-19-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c    | 8 +++++++-
 fs/afs/dynroot.c | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index fbb8a43aa7cd9a..9d8937ae24e219 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -205,8 +205,10 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	cell->dns_source = vllist->source;
 	cell->dns_status = vllist->status;
 	smp_store_release(&cell->dns_lookup_count, 1); /* vs source/status */
+	down_write(&net->cells_lock);
 	ret = idr_alloc_cyclic(&net->cells_dyn_ino, cell,
 			       2, INT_MAX / 2, GFP_KERNEL);
+	up_write(&net->cells_lock);
 	if (ret < 0)
 		goto error;
 	atomic_inc(&net->cells_outstanding);
@@ -579,7 +581,6 @@ static void afs_cell_destroy(struct rcu_head *rcu)
 	afs_put_vlserverlist(net, rcu_access_pointer(cell->vl_servers));
 	afs_unuse_cell(cell->alias_of, afs_cell_trace_unuse_alias);
 	key_put(cell->anonymous_key);
-	idr_remove(&net->cells_dyn_ino, cell->dynroot_ino);
 	kfree(cell->name - 1);
 	kfree(cell);
 
@@ -594,6 +595,11 @@ static void afs_destroy_cell_work(struct work_struct *work)
 	afs_see_cell(cell, afs_cell_trace_destroy);
 	timer_delete_sync(&cell->management_timer);
 	cancel_work_sync(&cell->manager);
+
+	down_write(&cell->net->cells_lock);
+	idr_remove(&cell->net->cells_dyn_ino, cell->dynroot_ino);
+	up_write(&cell->net->cells_lock);
+
 	call_rcu(&cell->rcu, afs_cell_destroy);
 }
 
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 1d5e33bc750224..6e3c8c691ba97f 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -278,7 +278,7 @@ static struct dentry *afs_lookup_atcell(struct inode *dir, struct dentry *dentry
 }
 
 /*
- * Transcribe the cell database into readdir content under the RCU read lock.
+ * Transcribe the cell database into readdir content under net->cells_lock.
  * Each cell produces two entries, one prefixed with a dot and one not.
  */
 static int afs_dynroot_readdir_cells(struct afs_net *net, struct dir_context *ctx)
-- 
2.53.0



