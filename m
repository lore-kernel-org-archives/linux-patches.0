Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF6943F4C7;
	Thu, 30 Jul 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426903; cv=none; b=aDsUS7qyNc0OGGroyAd7pREAZT1Hqt102dHfAjbu18sA9Hn1YdzaXSgbdZk4QtAijStEE3qnO+MRT8nPBwl4m+oVyjKTDDZsB7n9WGUDX3+CERmxKtbqTbXNbwZ+lidPrmOI1Yp7mhfmuiefrjmqsqjzZpN66ymwSoJGe9G+DMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426903; c=relaxed/simple;
	bh=G3W6uqgTb0Po4wfBRVV72VnDwEVNXWFJ3dS8Mj/TF7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfObLPul8FpoTOZem5Sch7Nm2DaNO7k7FTyp7F+62DHK8QiKf/VPL4ycFFhAc5YfGNjr2IkmpK978otvf9OQUbj7HhFbDWWAFOQtD8KkOAkxECKtv5FIXVw33EHJd+2mOsbhIKcglxtqXsEWO3plolDA45mh/ctrT26jOYjXx/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqjs2XZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqjs2XZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3871F000E9;
	Thu, 30 Jul 2026 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426901;
	bh=4OqhgZuPPo9UayZ+MsEhKByd38Fjg9I8No23aXluDhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqjs2XZg/hhJPt68Q10Px33t/tz3lppw277B4rKJIHtObjSPJ323CDgrMwQD+Gy03
	 09EMbeamMS5chRAv/t4R2IsUfz76ljnKooLFYwI6VpvFPFUrgbSVpp5LKP3CKmIXkR
	 x+/eVYZH2wIZ/mF/84vceDiDWQj81IcSdXKf786k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 582/602] afs: Fix lack of locking around modifications of net->cells_dyn_ino
Date: Thu, 30 Jul 2026 16:16:14 +0200
Message-ID: <20260730141448.284647307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
Stable-dep-of: 26f17ce6fa3f ("afs: Fix premature cell exposure through /afs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cell.c    |    8 +++++++-
 fs/afs/dynroot.c |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -198,8 +198,10 @@ static struct afs_cell *afs_alloc_cell(s
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
@@ -572,7 +574,6 @@ static void afs_cell_destroy(struct rcu_
 	afs_put_vlserverlist(net, rcu_access_pointer(cell->vl_servers));
 	afs_unuse_cell(cell->alias_of, afs_cell_trace_unuse_alias);
 	key_put(cell->anonymous_key);
-	idr_remove(&net->cells_dyn_ino, cell->dynroot_ino);
 	kfree(cell->name - 1);
 	kfree(cell);
 
@@ -587,6 +588,11 @@ static void afs_destroy_cell_work(struct
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
 
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -278,7 +278,7 @@ static struct dentry *afs_lookup_atcell(
 }
 
 /*
- * Transcribe the cell database into readdir content under the RCU read lock.
+ * Transcribe the cell database into readdir content under net->cells_lock.
  * Each cell produces two entries, one prefixed with a dot and one not.
  */
 static int afs_dynroot_readdir_cells(struct afs_net *net, struct dir_context *ctx)


