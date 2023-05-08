Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85473168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEFFC433EF;
	Mon,  8 May 2023 09:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539681;
	bh=W5b+sfXG6vdvGdFoAhDY6Q/wLz64qFKhxa/mkAulGxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzDJIw1mIQozKzZhMsHfX/XpRINoUcvbqfre4DxRy6UyleMpOHwfZKWuta9bI4nY0
	 8J/C8UcGE3jAp9Fr6JVLwBIkA+ZoWLImwV8gkBleSAaawULHSsG0xi/ryxcIeQRrWW
	 tTmgDNQTFPhnykogkaPcvdeEyf3JMjRiyY/kqGts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 102/611] ubifs: Fix memleak when insert_old_idx() failed
Date: Mon,  8 May 2023 11:39:04 +0200
Message-Id: <20230508094425.543256659@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit b5fda08ef213352ac2df7447611eb4d383cce929 upstream.

Following process will cause a memleak for copied up znode:

dirty_cow_znode
  zn = copy_znode(c, znode);
  err = insert_old_idx(c, zbr->lnum, zbr->offs);
  if (unlikely(err))
     return ERR_PTR(err);   // No one refers to zn.

Fetch a reproducer in [Link].

Function copy_znode() is split into 2 parts: resource allocation
and znode replacement, insert_old_idx() is split in similar way,
so resource cleanup could be done in error handling path without
corrupting metadata(mem & disk).
It's okay that old index inserting is put behind of add_idx_dirt(),
old index is used in layout_leb_in_gaps(), so the two processes do
not depend on each other.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216705
Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/tnc.c |  137 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 50 deletions(-)

--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -44,6 +44,33 @@ enum {
 	NOT_ON_MEDIA = 3,
 };
 
+static void do_insert_old_idx(struct ubifs_info *c,
+			      struct ubifs_old_idx *old_idx)
+{
+	struct ubifs_old_idx *o;
+	struct rb_node **p, *parent = NULL;
+
+	p = &c->old_idx.rb_node;
+	while (*p) {
+		parent = *p;
+		o = rb_entry(parent, struct ubifs_old_idx, rb);
+		if (old_idx->lnum < o->lnum)
+			p = &(*p)->rb_left;
+		else if (old_idx->lnum > o->lnum)
+			p = &(*p)->rb_right;
+		else if (old_idx->offs < o->offs)
+			p = &(*p)->rb_left;
+		else if (old_idx->offs > o->offs)
+			p = &(*p)->rb_right;
+		else {
+			ubifs_err(c, "old idx added twice!");
+			kfree(old_idx);
+		}
+	}
+	rb_link_node(&old_idx->rb, parent, p);
+	rb_insert_color(&old_idx->rb, &c->old_idx);
+}
+
 /**
  * insert_old_idx - record an index node obsoleted since the last commit start.
  * @c: UBIFS file-system description object
@@ -69,35 +96,15 @@ enum {
  */
 static int insert_old_idx(struct ubifs_info *c, int lnum, int offs)
 {
-	struct ubifs_old_idx *old_idx, *o;
-	struct rb_node **p, *parent = NULL;
+	struct ubifs_old_idx *old_idx;
 
 	old_idx = kmalloc(sizeof(struct ubifs_old_idx), GFP_NOFS);
 	if (unlikely(!old_idx))
 		return -ENOMEM;
 	old_idx->lnum = lnum;
 	old_idx->offs = offs;
+	do_insert_old_idx(c, old_idx);
 
-	p = &c->old_idx.rb_node;
-	while (*p) {
-		parent = *p;
-		o = rb_entry(parent, struct ubifs_old_idx, rb);
-		if (lnum < o->lnum)
-			p = &(*p)->rb_left;
-		else if (lnum > o->lnum)
-			p = &(*p)->rb_right;
-		else if (offs < o->offs)
-			p = &(*p)->rb_left;
-		else if (offs > o->offs)
-			p = &(*p)->rb_right;
-		else {
-			ubifs_err(c, "old idx added twice!");
-			kfree(old_idx);
-			return 0;
-		}
-	}
-	rb_link_node(&old_idx->rb, parent, p);
-	rb_insert_color(&old_idx->rb, &c->old_idx);
 	return 0;
 }
 
@@ -199,23 +206,6 @@ static struct ubifs_znode *copy_znode(st
 	__set_bit(DIRTY_ZNODE, &zn->flags);
 	__clear_bit(COW_ZNODE, &zn->flags);
 
-	ubifs_assert(c, !ubifs_zn_obsolete(znode));
-	__set_bit(OBSOLETE_ZNODE, &znode->flags);
-
-	if (znode->level != 0) {
-		int i;
-		const int n = zn->child_cnt;
-
-		/* The children now have new parent */
-		for (i = 0; i < n; i++) {
-			struct ubifs_zbranch *zbr = &zn->zbranch[i];
-
-			if (zbr->znode)
-				zbr->znode->parent = zn;
-		}
-	}
-
-	atomic_long_inc(&c->dirty_zn_cnt);
 	return zn;
 }
 
@@ -234,6 +224,42 @@ static int add_idx_dirt(struct ubifs_inf
 }
 
 /**
+ * replace_znode - replace old znode with new znode.
+ * @c: UBIFS file-system description object
+ * @new_zn: new znode
+ * @old_zn: old znode
+ * @zbr: the branch of parent znode
+ *
+ * Replace old znode with new znode in TNC.
+ */
+static void replace_znode(struct ubifs_info *c, struct ubifs_znode *new_zn,
+			  struct ubifs_znode *old_zn, struct ubifs_zbranch *zbr)
+{
+	ubifs_assert(c, !ubifs_zn_obsolete(old_zn));
+	__set_bit(OBSOLETE_ZNODE, &old_zn->flags);
+
+	if (old_zn->level != 0) {
+		int i;
+		const int n = new_zn->child_cnt;
+
+		/* The children now have new parent */
+		for (i = 0; i < n; i++) {
+			struct ubifs_zbranch *child = &new_zn->zbranch[i];
+
+			if (child->znode)
+				child->znode->parent = new_zn;
+		}
+	}
+
+	zbr->znode = new_zn;
+	zbr->lnum = 0;
+	zbr->offs = 0;
+	zbr->len = 0;
+
+	atomic_long_inc(&c->dirty_zn_cnt);
+}
+
+/**
  * dirty_cow_znode - ensure a znode is not being committed.
  * @c: UBIFS file-system description object
  * @zbr: branch of znode to check
@@ -265,21 +291,32 @@ static struct ubifs_znode *dirty_cow_zno
 		return zn;
 
 	if (zbr->len) {
-		err = insert_old_idx(c, zbr->lnum, zbr->offs);
-		if (unlikely(err))
-			return ERR_PTR(err);
+		struct ubifs_old_idx *old_idx;
+
+		old_idx = kmalloc(sizeof(struct ubifs_old_idx), GFP_NOFS);
+		if (unlikely(!old_idx)) {
+			err = -ENOMEM;
+			goto out;
+		}
+		old_idx->lnum = zbr->lnum;
+		old_idx->offs = zbr->offs;
+
 		err = add_idx_dirt(c, zbr->lnum, zbr->len);
-	} else
-		err = 0;
+		if (err) {
+			kfree(old_idx);
+			goto out;
+		}
 
-	zbr->znode = zn;
-	zbr->lnum = 0;
-	zbr->offs = 0;
-	zbr->len = 0;
+		do_insert_old_idx(c, old_idx);
+	}
+
+	replace_znode(c, zn, znode, zbr);
 
-	if (unlikely(err))
-		return ERR_PTR(err);
 	return zn;
+
+out:
+	kfree(zn);
+	return ERR_PTR(err);
 }
 
 /**


