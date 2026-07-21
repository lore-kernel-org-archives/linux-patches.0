Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DF13DD870;
	Tue, 21 Jul 2026 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658088; cv=none; b=MBAwDwLr4o2J6dDADdMi5PUKURaLpKP2P299/bMxdbYwwPksiLSaHS1gD4Mz+bQH7zHRzJ0PzPmT3Ax8kzZbPFml78hSxppjHgTntNFFPwF8dsgcXreGT5kX29Ff6YRYdV+REGx/LnirWNiPbzk7POSsQdQaniw+rt3cnM+ArDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658088; c=relaxed/simple;
	bh=/twZcG9JT0oWX1V+d7uZJ9vraWaV/6mg/Kk295YYJbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFE1S9sEQyoDBz+DDDqzS/ZhcWMCqoF9LCxRQmZLLwn5zHGTbkRD+AwtSpA2qQNwssAo/2C3gKzZM1iEvtiimYdYL2EUef/NUpupvHHnmNp289k6LDMksPiyqAPNjGP4+MDqEc6XfCBWUHbgGsBYRbSTUbcnEr5qvPnQYfz387E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYSHTWgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYSHTWgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084521F00A3A;
	Tue, 21 Jul 2026 18:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658087;
	bh=gv+7c0hO0SVpelvqMHFDOGXIJt7316IMVJc2vYhR3Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYSHTWgWYFOgY/yU8xs+4FCpaozOX5hFYLhGk7TBmwuaJhtjzzR9J5ih0IIlUZmqq
	 KeWdFKic1nwCKOUNTIYIj21cjyrdvEEaWP8/atjRrl+ri4LEL3SgDIIounrZfuEXY7
	 XGj+ALB0qPFFYozTKPuypZ56T21g+52Kh/1sXMRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1010/1611] afs: Fix premature cell exposure through /afs
Date: Tue, 21 Jul 2026 17:18:46 +0200
Message-ID: <20260721152538.113164934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 26f17ce6fa3f05cb5965790499c1839094260de4 ]

AFS cell records are prematurely exposured through the /afs dynamic root by
virtue of adding them immediately to the net->cells_dyn_ino IDR when the
cell is allocated rather than when it is added to the lookup tree.  This
allows a candidate record to be accessed, even if it's actually a duplicate
or not published yet.

Fix this by not adding the cell to cells_dyn_ino until it's confirmed
non-duplicate and is being published.  A flag is then used to record
whether it is added to the IDR to make removal from the IDR conditional.

Closes: https://sashiko.dev/#/patchset/20260618155141.2513212-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-20-dhowells@redhat.com
Fixes: 1d0b929fc070 ("afs: Change dynroot to create contents on demand")
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c     | 27 +++++++++++++++++----------
 fs/afs/internal.h |  1 +
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index e85e50716459eb..24b8a05712ca2d 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -205,14 +205,7 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	cell->dns_source = vllist->source;
 	cell->dns_status = vllist->status;
 	smp_store_release(&cell->dns_lookup_count, 1); /* vs source/status */
-	down_write(&net->cells_lock);
-	ret = idr_alloc_cyclic(&net->cells_dyn_ino, cell,
-			       2, INT_MAX / 2, GFP_KERNEL);
-	up_write(&net->cells_lock);
-	if (ret < 0)
-		goto error;
 	atomic_inc(&net->cells_outstanding);
-	cell->dynroot_ino = ret;
 	cell->debug_id = atomic_inc_return(&cell_debug_id);
 
 	trace_afs_cell(cell->debug_id, 1, 0, afs_cell_trace_alloc);
@@ -306,6 +299,13 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 			goto cell_already_exists;
 	}
 
+	ret = idr_alloc_cyclic(&net->cells_dyn_ino, candidate,
+			       2, INT_MAX / 2, GFP_KERNEL);
+	if (ret < 0)
+		goto cant_alloc_ino;
+	candidate->dynroot_ino = ret;
+	set_bit(AFS_CELL_FL_HAVE_INO, &candidate->flags);
+
 	cell = candidate;
 	candidate = NULL;
 	afs_use_cell(cell, trace);
@@ -380,6 +380,11 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	_leave(" = %p [cell]", cell);
 	return cell;
 
+cant_alloc_ino:
+	up_write(&net->cells_lock);
+	afs_put_cell(candidate, afs_cell_trace_put_candidate);
+	goto error_noput;
+
 cell_already_exists:
 	_debug("cell exists");
 	cell = cursor;
@@ -596,9 +601,11 @@ static void afs_destroy_cell_work(struct work_struct *work)
 	timer_delete_sync(&cell->management_timer);
 	cancel_work_sync(&cell->manager);
 
-	down_write(&cell->net->cells_lock);
-	idr_remove(&cell->net->cells_dyn_ino, cell->dynroot_ino);
-	up_write(&cell->net->cells_lock);
+	if (test_bit(AFS_CELL_FL_HAVE_INO, &cell->flags)) {
+		down_write(&cell->net->cells_lock);
+		idr_remove(&cell->net->cells_dyn_ino, cell->dynroot_ino);
+		up_write(&cell->net->cells_lock);
+	}
 
 	call_rcu(&cell->rcu, afs_cell_destroy);
 }
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 009064b8d6616c..bea8aae5364ec7 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -389,6 +389,7 @@ struct afs_cell {
 #define AFS_CELL_FL_NO_GC	0		/* The cell was added manually, don't auto-gc */
 #define AFS_CELL_FL_DO_LOOKUP	1		/* DNS lookup requested */
 #define AFS_CELL_FL_CHECK_ALIAS	2		/* Need to check for aliases */
+#define AFS_CELL_FL_HAVE_INO	3		/* Have dynroot_ino */
 	enum afs_cell_state	state;
 	short			error;
 	enum dns_record_source	dns_source:8;	/* Latest source of data from lookup */
-- 
2.53.0



