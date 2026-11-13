Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591142;
	b=EMT+X4Vhqhj9m83Prph4JF2ibEh+meJT1Nlp46wheXT6R6/i676MJOmovxBs+V9whFw7
	 +BPVC30d4vl6ml6a6Zsm/04RNYkIK+QteOYRZ4qC6i1g9q5kt3ev75L5opdwinQxOZmtg
	 r3YvGV4QN3E9xrDZCIZLsPWJI21gJENJtQpiFOkOk6L32gmB6IYsAmr+9WSQXspIEt0i7
	 sTrYoHIr52BQOAljF6cdOFzlEkO0aBqLghSKemrZFSmFlR0OY1+ta3sapGyDYnLGUXT8A
	 ms4ZBSrCqRv8Ro1a0XI/QQJYOlVQ+GwZdY4k2CsGylyoRAbzMJeZzVD1rNVTs4/30Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jbu8nGgnTnibPgZAPYkd3+NdnsULt7KXsg3D9NSiiRg=;
	b=hEb7j3rMagBzVCa3B+T8qpwfywTD3HdDT/eXES3JfBb8jFy5ToRhDuvqvUdcPengrRbI
	 OqDWmxAKsrA966LomjSmtl466koRMJWzm3lpbbUXOJORmVKGoWdzBb0hXCdLgxkiAIiT+
	 An0H08BCtPbuPMlN2DKsAAwSe0pbRWfBbFpLxuMgFzo8s3eOgSM27TQek+jYOFZhdfKjY
	 oh6/K3Z+lRkypXh9yAWbH+JBvsKRpnT1YEwt7hDYNH4k5bGCxuJimPIqI26qPGMoDna73
	 xbY8uqSXE+ZxX98nAEkBCZfxC2yZg6PsN+WB5wevubeiEM39hBL8CGZsV9tm/u/Ks9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVPkFinK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D24606BD1C;
	Fri, 13 Nov 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVPkFinK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470BC1F000C6;
	Fri, 13 Nov 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591142;
	bh=Jbu8nGgnTnibPgZAPYkd3+NdnsULt7KXsg3D9NSiiRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVPkFinKVoZKKcjN7W/OVImHFQjztzbbeja6Eqn6p9rl9oCeijROatmL+MqTwGUFS
	 EjBwdCc2G5MAV6SkNsAoBdMGRvpenppSy22HkvkPXIAODSg3LfNxudGqdWwnyr2eG5
	 FHGE7PXn2raBhhQGTWDbkmsLDmwoq7mM+H0m6zKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/670] ocfs2: find the xattr entry again after converting a block to a bucket
Date: Fri, 13 Nov 2026 10:47:30 -0500
Message-ID: <20261113153821.568870918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 9c191a7a44882487e291e09f095d2ae4d7cca146 ]

ocfs2_xattr_create_index_block() turns a non-indexed xattr block into a
tree by copying it into a bucket, and the copy sorts the entries: a
block holds them in insertion order, a bucket by name hash.
ocfs2_xattr_update_xattr_search() nevertheless relocates the caller's
search by the index the entry had in the block, so unless the two orders
agreed it points at an unrelated entry, and nothing between there and
the write compares that entry's name with the one being set.

Setting an xattr whose new value no longer fits the block arrives here
with xs->not_found clear.  The block gave up because
ocfs2_xa_block_can_reuse() wants an exact namevalue size match, while
ocfs2_xa_bucket_can_reuse() only wants an entry at least as large as the
new one, so the bucket accepts a pair the block rejected and the update
lands on whichever entry the sort left at that index.  Equal padded name
lengths get that other attribute's value replaced in place and its name
left alone, so setxattr returns success while the attribute asked for
keeps its old value.  A longer one trips ocfs2_xa_reuse_entry()'s
BUG_ON, and a shorter one is refused by the bucket as well, so
ocfs2_xa_prepare_entry() wipes the entry and writes the new name over
it, leaving xe_name_hash describing a name that is no longer there.

Find the entry again by the name being set, matching the type as well.
The copy carries every entry and every name over unchanged, and (type,
name) pairs are unique within a block, so the match is exact.  The type
matters because the handlers strip their prefix before calling
ocfs2_xattr_set(), so user.foo and trusted.foo share a stored name, a
stored length and a hash, and both can sit in the same block.

The name has to come from xi rather than from xs->here: a failed set can
remove the entry xs->here names, and only the "growing" caller sets
ctxt->set_abort, which is what stops the conversion.  Scan every entry
rather than narrowing on the hash the way ocfs2_find_xe_in_bucket()
does, since an existing entry keeps the hash it was stored under, which
a kernel that sign-extended the name bytes made different from the one
computed now.  An empty result means the entry did not survive the
failed set and this has become an insert; leaving xs->here alone would
keep it pointing into the block, which is rewritten as a tree root
before the caller reads it again.

Link: https://lore.kernel.org/20261024151012.1059683-4-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 54 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7c611b5d34513..a995b241bbc3d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -256,6 +256,7 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 					size_t buffer_size);
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_info *xi,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt);
 
@@ -3228,7 +3229,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		else if ((ret != -ENOSPC) || ctxt->set_abort)
 			goto end;
 		else {
-			ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
+			ret = ocfs2_xattr_create_index_block(inode, xi, xs, ctxt);
 			if (ret)
 				goto end;
 		}
@@ -4556,13 +4557,10 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
  * real place of the xattr.
  */
 static void ocfs2_xattr_update_xattr_search(struct inode *inode,
-					    struct ocfs2_xattr_search *xs,
-					    struct buffer_head *old_bh)
+					    struct ocfs2_xattr_info *xi,
+					    struct ocfs2_xattr_search *xs)
 {
-	char *buf = old_bh->b_data;
-	struct ocfs2_xattr_block *old_xb = (struct ocfs2_xattr_block *)buf;
-	struct ocfs2_xattr_header *old_xh = &old_xb->xb_attrs.xb_header;
-	int i;
+	int i, count;
 
 	xs->header = bucket_xh(xs->bucket);
 	xs->base = bucket_block(xs->bucket, 0);
@@ -4571,11 +4569,47 @@ static void ocfs2_xattr_update_xattr_search(struct inode *inode,
 	if (xs->not_found)
 		return;
 
-	i = xs->here - old_xh->xh_entries;
-	xs->here = &xs->header->xh_entries[i];
+	/*
+	 * A block holds its entries in insertion order while a bucket holds
+	 * them by name hash, so ocfs2_cp_xattr_block_to_bucket() sorted the
+	 * copies and the index this entry had in the block no longer says
+	 * where it is.  It copied every entry and every name unchanged, and
+	 * (type, name) pairs are unique within a block, so find it again by
+	 * name.
+	 *
+	 * Search for the name being set, not for the name xs->here carries.
+	 * A failed set may have removed that entry, and ocfs2_xa_remove_entry()
+	 * then memmoves its successor into the slot.  Comparing every entry
+	 * rather than narrowing on the hash also finds an entry stored under
+	 * the legacy signed hash, which ocfs2_find_xe_in_bucket() would skip.
+	 */
+	count = le16_to_cpu(xs->header->xh_count);
+	for (i = 0; i < count; i++) {
+		struct ocfs2_xattr_entry *xe = &xs->header->xh_entries[i];
+
+		if (ocfs2_xattr_get_type(xe) != xi->xi_name_index)
+			continue;
+		if (xe->xe_name_len != xi->xi_name_len)
+			continue;
+		if (!memcmp(xs->base + le16_to_cpu(xe->xe_name_offset),
+			    xi->xi_name, xi->xi_name_len)) {
+			xs->here = xe;
+			return;
+		}
+	}
+
+	/*
+	 * The entry did not survive the failed set, so this has become an
+	 * insert.  Point xs->here back inside the bucket: it still refers to
+	 * the block being converted, which is about to be rewritten as a tree
+	 * root.
+	 */
+	xs->not_found = -ENODATA;
+	xs->here = xs->header->xh_entries;
 }
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_info *xi,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt)
 {
@@ -4642,7 +4676,7 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xs->bucket);
 	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
 
-	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh);
+	ocfs2_xattr_update_xattr_search(inode, xi, xs);
 
 	/* Change from ocfs2_xattr_header to ocfs2_xattr_tree_root */
 	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
-- 
2.53.0



