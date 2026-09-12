Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC01EB5FD;
	Sat, 12 Sep 2026 07:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197582; cv=none; b=hn6EPSDvB6vEgWSqIHHC7HcyO9td72nOsoe7UA3II8dvZXfaBoMvt6ud7ACRT3ub2Gw6I1fRD9WGoX1mgZYjYTBfOoH0uEiimaMFNsmRmtPYEhPrtrND7hHj+5t9uCu+4Qp9VwAEviaEZqKiEInk9+FpJ0RWKR/EUv/3Mn1oyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197582; c=relaxed/simple;
	bh=yexz8F+5HydFw7jw6U/3aW29KJExjg/UfWWF7vxWxGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s17q4IkROZYsTNJ3xxnp66bqSJMIkEfaRhi5xxBOQnDn5BlFi0+YmBt77pDdCHph/6W7zOUTlEd24q1nGogQIBReIucL6lb2zbfKoG7l60SEJk6wZtnY8g9hYAl+iUFJbEIq/vC8Nct2ecvchUhuSqR1IO5yuGJ6Kj/oqaSgC7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oduuIeBD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oduuIeBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE521F000FF;
	Sat, 12 Sep 2026 07:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197580;
	bh=lXI8SKypSUswtOyP0vHKaGwJrgrEI7f/FSZIE0QIFZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oduuIeBD8uhOYHxGcsV7NFDWI+LaqWI2uRg8Bav2oGl8lnPFExmtny9t7o06dEija
	 hI74g2WMl2Nbw8ymNOqBZjIoBd/5ivWwArj2Nl6Eq7051KDPkDqJ5qWhtGehBQPtKV
	 CCaJ1xMR7ILVddhSMhs96Z86NcRT90VFrkHiQ3Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0204/1815] fuse: move "epoch" from dentry.d_time to fuse_dentry.epoch
Date: Sat, 12 Sep 2026 08:32:34 +0200
Message-ID: <20260912065653.790898650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 6648f54f3459c5d069b7ce294170d721ce9bac2f ]

...in hope of removing d_time one day.

Fixes: 2396356a945b ("fuse: add more control over cache invalidation behaviour")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c     | 23 ++++++++++++++++-------
 fs/fuse/fuse_i.h  |  2 ++
 fs/fuse/readdir.c |  2 +-
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 48763bc192f3c..4466db3e38274 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -96,6 +96,7 @@ static void fuse_advise_use_readdirplus(struct inode *dir)
 
 struct fuse_dentry {
 	u64 time;
+	u64 epoch;
 	union {
 		struct rcu_head rcu;
 		struct rb_node node;
@@ -236,6 +237,13 @@ void fuse_dentry_tree_cleanup(void)
 		WARN_ON_ONCE(!RB_EMPTY_ROOT(&dentry_hash[i].tree));
 }
 
+void fuse_dentry_set_epoch(struct dentry *dentry, u64 epoch)
+{
+	struct fuse_dentry *fd = dentry->d_fsdata;
+
+	fd->epoch = epoch;
+}
+
 static inline void __fuse_dentry_settime(struct dentry *dentry, u64 time)
 {
 	((struct fuse_dentry *) dentry->d_fsdata)->time = time;
@@ -387,10 +395,11 @@ static int fuse_dentry_revalidate(struct inode *dir, const struct qstr *name,
 	struct fuse_mount *fm;
 	struct fuse_conn *fc;
 	struct fuse_inode *fi;
+	struct fuse_dentry *fd = entry->d_fsdata;
 	int ret;
 
 	fc = get_fuse_conn_super(dir->i_sb);
-	if (entry->d_time < atomic_read(&fc->epoch))
+	if (fd->epoch < atomic_read(&fc->epoch))
 		goto invalid;
 
 	inode = d_inode_rcu(entry);
@@ -480,10 +489,10 @@ static int fuse_dentry_init(struct dentry *dentry)
 	RB_CLEAR_NODE(&fd->node);
 	dentry->d_fsdata = fd;
 	/*
-	 * Initialising d_time (epoch) to '0' ensures the dentry is invalid
+	 * Initialising epoch to '0' ensures the dentry is invalid
 	 * if compared to fc->epoch, which is initialized to '1'.
 	 */
-	dentry->d_time = 0;
+	fuse_dentry_set_epoch(dentry, 0);
 
 	return 0;
 }
@@ -641,7 +650,7 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 		goto out_err;
 
 	entry = newent ? newent : entry;
-	entry->d_time = epoch;
+	fuse_dentry_set_epoch(entry, epoch);
 	if (outarg_valid)
 		fuse_change_entry_timeout(entry, &outarg);
 	else
@@ -898,7 +907,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	kfree(forget);
 	d_instantiate(entry, inode);
-	entry->d_time = epoch;
+	fuse_dentry_set_epoch(entry, epoch);
 	fuse_change_entry_timeout(entry, &outentry);
 	fuse_dir_changed(dir);
 	err = generic_file_open(inode, file);
@@ -1028,10 +1037,10 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 		return d;
 
 	if (d) {
-		d->d_time = epoch;
+		fuse_dentry_set_epoch(d, epoch);
 		fuse_change_entry_timeout(d, &outarg);
 	} else {
-		entry->d_time = epoch;
+		fuse_dentry_set_epoch(entry, epoch);
 		fuse_change_entry_timeout(entry, &outarg);
 	}
 	fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 85f738c531225..c8d4c5f3af7e8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1054,6 +1054,8 @@ u64 fuse_time_to_jiffies(u64 sec, u32 nsec);
 
 void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
 
+void fuse_dentry_set_epoch(struct dentry *dentry, u64 epoch);
+
 /*
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 0e13214917473..5ca87151d70d9 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -260,7 +260,7 @@ static int fuse_direntplus_link(struct file *file,
 	}
 	if (fc->readdirplus_auto)
 		set_bit(FUSE_I_INIT_RDPLUS, &get_fuse_inode(inode)->state);
-	dentry->d_time = epoch;
+	fuse_dentry_set_epoch(dentry, epoch);
 	fuse_change_entry_timeout(dentry, o);
 
 	dput(dentry);
-- 
2.53.0



