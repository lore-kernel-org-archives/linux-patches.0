Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED591484884;
	Thu, 17 Sep 2026 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660421; cv=none; b=dH33hKRqIx+68FDoIgU/cm5/mcl+jve/Z4vp4NfRN3b+vty2jjiYFQtrj7Mx90TYRTkX1OFouvE0F7nuQ5YeIXCsqvxF6Ukg3GxudajMqMh8nW60pmJI80dKd4JBW9GuAdotRlGz7McvJeBZeJaCXaTQfru/b+nRzYqo2q/YMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660421; c=relaxed/simple;
	bh=9wTxwbwV5auCLO5+iLEWf+i/pXMRvHeA13VGyc0MG1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkVO/vam9zvTebR0UmsfoRnHpyyr4AleN8jWk5px/NG0jwwSAAFsLD/xd6pQnwRw9M0NW+ZjJx7/oNfQ3RH7+I3XwRdUh1X2yjree920eqID5IKZtglVQnyhEQYpJeIE83r+wegYTOFYFQwTArIpPs0gzhMekwO9vxoZotUretk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixj3p3Xx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixj3p3Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198011F000FF;
	Thu, 17 Sep 2026 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660419;
	bh=sKG9AH5Rwo/977B22Z3zFdq+cpWP8/c9IodHJs0lGjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixj3p3Xx9tRxuMqYi4Y4VWN/RyRTiA1mNSO8moKQWJANlqwof+8FfO+i0IxEVQ4Og
	 GZZEA9wejW1I/22eY7QA+uY/zvw1/Ux2f43Ff+gDIO51YoXyiosb/c0mI0GwaIabV2
	 fUhzTjPYwB073Y6oQeaVaMBXzf+jlP0kJVz2FVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 587/733] afs: Fix double-unmap of directory block
Date: Thu, 17 Sep 2026 16:14:55 +0100
Message-ID: <20260917151407.049452956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit e3cfd3eb7d5be7787cc69530b423f788f14d084f upstream.

Fix afs_edit_dir_remove() to use a cleanup function to unmap the block
pointed to by afs_dir_iter::block if it's left pointing to something rather
than manually kunmapping the blocks.  Manually kunmapping without clearing
iter.blocks can result in a double-kunmap if afs_dir_find_block() is called
twice in a row (which would be the case if the block being modified is not
first in the hash chain).

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260716103030.3065561-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260902121024.3328255-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir_edit.c   |    9 ++-------
 fs/afs/dir_search.c |   10 ++--------
 fs/afs/internal.h   |    8 ++++++++
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -442,7 +442,7 @@ void afs_edit_dir_remove(struct afs_vnod
 	/* Check and clear the entry. */
 	de = &block->dirents[slot];
 	if (de->u.valid != 1)
-		goto error_unmap;
+		goto error;
 
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_delete, b, slot,
 			   ntohl(de->u.vnode), ntohl(de->u.unique),
@@ -458,7 +458,6 @@ void afs_edit_dir_remove(struct afs_vnod
 	/* Clear the constituent entries. */
 	next = de->u.hash_next;
 	memset(de, 0, sizeof(*de) * iter.nr_slots);
-	kunmap_local(block);
 
 	/* Adjust the hash chain: if iter->prev_entry is 0, the hashtable head
 	 * index is previous; otherwise it's slot number of the previous entry.
@@ -485,7 +484,6 @@ void afs_edit_dir_remove(struct afs_vnod
 		pde = &pblock->dirents[ps];
 		prev_next = pde->u.hash_next;
 		if (prev_next != htons(entry)) {
-			kunmap_local(pblock);
 			pr_warn("%llx:%llx:%x: not prev in chain b=%x p=%x,%x e=%x %*s",
 				vnode->fid.vid, vnode->fid.vnode, vnode->fid.unique,
 				iter.bucket, iter.prev_entry, prev_next, entry,
@@ -493,7 +491,6 @@ void afs_edit_dir_remove(struct afs_vnod
 			goto error;
 		}
 		pde->u.hash_next = next;
-		kunmap_local(pblock);
 	}
 
 	netfs_single_mark_inode_dirty(&vnode->netfs.inode);
@@ -503,18 +500,16 @@ void afs_edit_dir_remove(struct afs_vnod
 	_debug("Remove %s from %u[%u]", name->name, b, slot);
 
 out_unmap:
+	afs_dir_end_iter(&iter);
 	kunmap_local(meta);
 	_leave("");
 	return;
 
 already_invalidated:
-	kunmap_local(block);
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_delete_inval,
 			   0, 0, 0, 0, name->name);
 	goto out_unmap;
 
-error_unmap:
-	kunmap_local(block);
 error:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_delete_error,
 			   0, 0, 0, 0, name->name);
--- a/fs/afs/dir_search.c
+++ b/fs/afs/dir_search.c
@@ -75,10 +75,7 @@ union afs_xdr_dir_block *afs_dir_find_bl
 
 	_enter("%zx,%d", block, slot);
 
-	if (iter->block) {
-		kunmap_local(iter->block);
-		iter->block = NULL;
-	}
+	afs_dir_end_iter(iter);
 
 	if (dvnode->directory_size < blend)
 		goto fail;
@@ -174,10 +171,7 @@ int afs_dir_search_bucket(struct afs_dir
 	ret = -ENOENT;
 found:
 bad:
-	if (iter->block) {
-		kunmap_local(iter->block);
-		iter->block = NULL;
-	}
+	afs_dir_end_iter(iter);
 	if (ret == -ESTALE)
 		afs_invalidate_dir(iter->dvnode, afs_dir_invalid_iter_stale);
 	_leave(" = %d", ret);
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1133,6 +1133,14 @@ int afs_dir_search_bucket(struct afs_dir
 int afs_dir_search(struct afs_vnode *dvnode, const struct qstr *name,
 		   struct afs_fid *_fid, afs_dataversion_t *_dir_version);
 
+static inline void afs_dir_end_iter(struct afs_dir_iter *iter)
+{
+	if (iter->block) {
+		kunmap_local(iter->block);
+		iter->block = NULL;
+	}
+}
+
 /*
  * dir_silly.c
  */


