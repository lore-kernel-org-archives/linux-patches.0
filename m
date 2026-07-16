Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CF43876DE;
	Thu, 16 Jul 2026 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210271; cv=none; b=RRy1XKXq5CChngyfF/XBpelpiiG5HVQE0FREL3VoDi13V5QmXn8jHTyIhT82DKHIhg5i7wKUxQcw752G8uoKvvC68W21epC56geMw0e0t5mJx/CPCfQXRwsUddVNv5ZFo9ScI5oxDfde0c9avEpBi5ssYGpdGqcIbu/5eKGOV1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210271; c=relaxed/simple;
	bh=K/4P7H+WbZPsgqK9e9YHhSodNvezWIbgfu86Z74mPC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FevRzw5klx2rgr1q321pQM9cb+Nn9m/9re5mfhuJnCtxkMmrVCpqhrofRoWUTtTryy4qxJv1zz0bZuVNNXXW8r4Xf47Fc3j/EkW+BG8kuvh6DZf7U5c+VpFZXUsHf/njSqTEmD2vRWJImKAghXrmIhLb4xjJLFtXV9XWb3kfXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHJgrnVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHJgrnVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42B91F000E9;
	Thu, 16 Jul 2026 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210269;
	bh=nTh9MWN2iFCPdH6TJ9wP8O1Y2ry153sDPHo6bpERB8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHJgrnVLssDbbxcMs9V2i2sm6l/ye2YT1moTMD+84PVazEDuEkJUDl5Yf+sO8wbWX
	 pKY6U45MOt1rnINeDlb/AdHb81BvK0Lw2MFz85bbgZC10v9Pw0Bd6xpZKVgzUdATRX
	 a1DENXrJwC3w6vEr1mjVd/IiWbKTPxcTVu2LOhqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=90=D1=80=D1=82=D0=B5=D0=BC=20=D0=9B=D0=B0=D0=B1=D0=B0=D0=B7=D0=BE=D0=B2?= <123321artyom@gmail.com>,
	NeilBrown <neilb@ownmail.net>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 503/518] fuse: do not use start_removing_noperm()
Date: Thu, 16 Jul 2026 15:32:51 +0200
Message-ID: <20260716133058.846673195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 6e1b235627bb1172d27c1b2ea7bf53e67dbced8d upstream.

Revert the fuse part of commit c9ba789dad15 ("VFS: introduce
start_creating_noperm() and start_removing_noperm()").

Commit c9ba789dad15 ("VFS: introduce start_creating_noperm() and
start_removing_noperm()") caused a regression in FUSE_NOTIFY_INVAL_ENTRY,
which failed to invalidate negative dentries.

This manifests in the filesystem returning -ENOENT for operations on an
existing file.

Fixing it properly while still keeping the start_removing* infrastructure
would add much additional complexity.

Instead revert to the original simple implementation.

The start_removing* infrastructure is needed in VFS to abstract the
filesystem locking.  However filesystem code can still safely use the raw
locking primitives without affacting other filesystems.

This is part two of the revert.

Reported-by: Артем Лабазов <123321artyom@gmail.com>
Closes: https://lore.kernel.org/all/CAFbF8N7++zopZuEcsKRxBV_sgOGCbzCY0hOyMw1SiGAtuzGhyQ@mail.gmail.com/
Fixes: c9ba789dad15 ("VFS: introduce start_creating_noperm() and start_removing_noperm()")
Cc: stable@vger.kernel.org # 6.19
Cc: NeilBrown <neilb@ownmail.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 6b05846c9bed..97751bacb79c 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1594,25 +1594,27 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 	if (!parent)
 		return -ENOENT;
 
+	inode_lock_nested(parent, I_MUTEX_PARENT);
 	if (!S_ISDIR(parent->i_mode))
-		goto put_parent;
+		goto unlock;
 
 	err = -ENOENT;
 	dir = d_find_alias(parent);
 	if (!dir)
-		goto put_parent;
+		goto unlock;
 
-	entry = start_removing_noperm(dir, name);
+	name->hash = full_name_hash(dir, name->name, name->len);
+	entry = d_lookup(dir, name);
 	dput(dir);
-	if (IS_ERR(entry))
-		goto put_parent;
+	if (!entry)
+		goto unlock;
 
 	fuse_dir_changed(parent);
 	if (!(flags & FUSE_EXPIRE_ONLY))
 		d_invalidate(entry);
 	fuse_invalidate_entry_cache(entry);
 
-	if (child_nodeid != 0) {
+	if (child_nodeid != 0 && d_really_is_positive(entry)) {
 		inode_lock(d_inode(entry));
 		if (get_node_id(d_inode(entry)) != child_nodeid) {
 			err = -ENOENT;
@@ -1640,9 +1642,10 @@ int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 	} else {
 		err = 0;
 	}
+	dput(entry);
 
-	end_removing(entry);
- put_parent:
+ unlock:
+	inode_unlock(parent);
 	iput(parent);
 	return err;
 }
-- 
2.55.0



