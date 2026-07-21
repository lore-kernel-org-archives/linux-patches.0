Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A37284662;
	Tue, 21 Jul 2026 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663209; cv=none; b=j+plAYZ4j30KLl8y/rC7SbZIJJ/PFXOUGV73hEEl6b1m5NW03CAkNX9cDqKHtItOzErues+lPVG4AZY+eGVu9izrdJvpnr1zFz9EZqPHSBvKvNSRznw8PJV71VgHCWTjkKg6ejAkU0bjdHfD7kEed0RCn/1vBmaz/0inpLAaxbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663209; c=relaxed/simple;
	bh=35tjIfFXJZCglrubPg0K7RxThWswcxJKZdtYusKMq5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU5uXty0xBwr9pDCYJtpN7ZdEJ+IKvjaGoSDrm6Js6kNhl5Mfwv3vGA+tf+ASv/QtKQMBsaA/4A3TM/fApIzXcJUGRuKJay22NLoSJSf/aSQ7LRc8HcFK5mH1UyElVOzvrMkibt9qEahhBqw1g1ZDvg0BKfwYPTl6Gk04ry1WlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaGIzVwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaGIzVwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC421F000E9;
	Tue, 21 Jul 2026 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663208;
	bh=rlA532Yxt0nA/uF5h86pqGCTiY/MJiHnHkqTTHUp6b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaGIzVwUb4NAT/0ZtBZezUDsNWRTBUnKvPoEMdqKMRjDX2aRmsqHc30iBpCM4SW6m
	 YBO50b86w4Ucah3Pv6Y/8bmSxtvrc9Qd9/8x8inKq9Qdfcx/mAJjiZlfKvrMMmhqCn
	 7RyUMWnrYrLRItHBfOv8PBEgKg7s9ZVxGMdUJ1YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0734/1276] afs: Fix afs_atcell_get_link() to handle RCU pathwalk
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152502.506827046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 823869e1e61607ab0d433de3c8abed221dc80a5e ]

The ->get_link() method may be entered under RCU pathwalk conditions (in
which case, the dentry pointer is NULL).  This is not taken account of by
afs_atcell_get_link() and lockdep will complain when it tries to lock an
rwsem.

Fix this by marking net->ws_cell as __rcu and using RCU access macros on it
and by making afs_atcell_get_link() just return a pointer to the name in
RCU pathwalk without taking net->cells_lock or a ref on the cell as RCU
will protect the name storage (the cell is already freed via call_rcu()).

Fixes: 30bca65bbbae ("afs: Make /afs/@cell and /afs/.@cell symlinks")
Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20250310094206.801057-2-dhowells@redhat.com/ # v4
Stable-dep-of: c9c3b615a462 ("afs: Fix misplaced inc of net->cells_outstanding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c     | 11 ++++++-----
 fs/afs/dynroot.c  | 15 +++++++++++++--
 fs/afs/internal.h |  2 +-
 fs/afs/proc.c     |  4 ++--
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index cee42646736c86..96a6781f365303 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -64,7 +64,8 @@ static struct afs_cell *afs_find_cell_locked(struct afs_net *net,
 		return ERR_PTR(-ENAMETOOLONG);
 
 	if (!name) {
-		cell = net->ws_cell;
+		cell = rcu_dereference_protected(net->ws_cell,
+						 lockdep_is_held(&net->cells_lock));
 		if (!cell)
 			return ERR_PTR(-EDESTADDRREQ);
 		goto found;
@@ -388,8 +389,8 @@ int afs_cell_init(struct afs_net *net, const char *rootcell)
 	/* install the new cell */
 	down_write(&net->cells_lock);
 	afs_see_cell(new_root, afs_cell_trace_see_ws);
-	old_root = net->ws_cell;
-	net->ws_cell = new_root;
+	old_root = rcu_replace_pointer(net->ws_cell, new_root,
+				       lockdep_is_held(&net->cells_lock));
 	up_write(&net->cells_lock);
 
 	afs_unuse_cell(net, old_root, afs_cell_trace_unuse_ws);
@@ -945,8 +946,8 @@ void afs_cell_purge(struct afs_net *net)
 	_enter("");
 
 	down_write(&net->cells_lock);
-	ws = net->ws_cell;
-	net->ws_cell = NULL;
+	ws = rcu_replace_pointer(net->ws_cell, NULL,
+				 lockdep_is_held(&net->cells_lock));
 	up_write(&net->cells_lock);
 	afs_unuse_cell(net, ws, afs_cell_trace_unuse_ws);
 
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index d8bf52f77d9302..008698d706caa4 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -314,12 +314,23 @@ static const char *afs_atcell_get_link(struct dentry *dentry, struct inode *inod
 	const char *name;
 	bool dotted = vnode->fid.vnode == 3;
 
-	if (!net->ws_cell)
+	if (!dentry) {
+		/* We're in RCU-pathwalk. */
+		cell = rcu_dereference(net->ws_cell);
+		if (dotted)
+			name = cell->name - 1;
+		else
+			name = cell->name;
+		/* Shouldn't need to set a delayed call. */
+		return name;
+	}
+
+	if (!rcu_access_pointer(net->ws_cell))
 		return ERR_PTR(-ENOENT);
 
 	down_read(&net->cells_lock);
 
-	cell = net->ws_cell;
+	cell = rcu_dereference_protected(net->ws_cell, lockdep_is_held(&net->cells_lock));
 	if (dotted)
 		name = cell->name - 1;
 	else
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index d9760b2a8d8de4..18f410559fe87b 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -302,7 +302,7 @@ struct afs_net {
 
 	/* Cell database */
 	struct rb_root		cells;
-	struct afs_cell		*ws_cell;
+	struct afs_cell __rcu	*ws_cell;
 	struct work_struct	cells_manager;
 	struct timer_list	cells_timer;
 	atomic_t		cells_outstanding;
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index e7614f4f30c21e..12c88d8be3fe8b 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -206,7 +206,7 @@ static int afs_proc_rootcell_show(struct seq_file *m, void *v)
 
 	net = afs_seq2net_single(m);
 	down_read(&net->cells_lock);
-	cell = net->ws_cell;
+	cell = rcu_dereference_protected(net->ws_cell, lockdep_is_held(&net->cells_lock));
 	if (cell)
 		seq_printf(m, "%s\n", cell->name);
 	up_read(&net->cells_lock);
@@ -242,7 +242,7 @@ static int afs_proc_rootcell_write(struct file *file, char *buf, size_t size)
 
 	ret = -EEXIST;
 	inode_lock(file_inode(file));
-	if (!net->ws_cell)
+	if (!rcu_access_pointer(net->ws_cell))
 		ret = afs_cell_init(net, buf);
 	else
 		printk("busy\n");
-- 
2.53.0



