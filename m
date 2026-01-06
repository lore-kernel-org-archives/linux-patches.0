Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BCE1D6AA;
	Tue,  6 Jan 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720622; cv=none; b=kGh3ZUMHNuL4N3YMYwY92sAp0jBsm63K/gDAjFILBDKRemq2/PhqKHZQE7MiGN27vB9jdR9ONM52ESQgeRtbqfEFppihwAEvdOsbYBA0gupmSxhOjLTaBtMor/1256/I6hQaF48BiJGY5T16EsD2PHnt5wQbp4d454YnH5QA/Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720622; c=relaxed/simple;
	bh=wWFN5meBKByaU6pUjVUBurXyyEZYv7qfJhkoqqcXLAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfGOrsdYqrP+H+Ujo4Ijwg56n6jn9nL5Yxy3k11l55TFgB3cuDu9t0aSlkcJdo4K1XGC7fGE7HJvMN+SOk4ZoDBcTYJ0xPBm74sPZlphbb1q/bEfhHNY1oA4C41eDoPe3tK/X37VKuphZmho+50j7iEMcD60HpEUUlftOYv7Zpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYl3vKp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYl3vKp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CF4C116C6;
	Tue,  6 Jan 2026 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720621;
	bh=wWFN5meBKByaU6pUjVUBurXyyEZYv7qfJhkoqqcXLAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYl3vKp4Yz/Vo/Ggy3fI0YSF6IUIXyYK40p342Cbnw1cRxWdjMPIKXPOyL+FqqB4L
	 8Z5lfzT7PuFj0oVbZWqkdyXizVoL1ogw0WMH3kL6MWkdmuDk91gWaWpYMygGqcc86l
	 LPkX/qbVpnbq0bQJ9DEaVwC4zQAEJ0S95mIauUOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Omar Sandoval <osandov@fb.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 293/567] fuse: fix readahead reclaim deadlock
Date: Tue,  6 Jan 2026 18:01:15 +0100
Message-ID: <20260106170502.172577661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit bd5603eaae0aabf527bfb3ce1bb07e979ce5bd50 upstream.

Commit e26ee4efbc79 ("fuse: allocate ff->release_args only if release is
needed") skips allocating ff->release_args if the server does not
implement open. However in doing so, fuse_prepare_release() now skips
grabbing the reference on the inode, which makes it possible for an
inode to be evicted from the dcache while there are inflight readahead
requests. This causes a deadlock if the server triggers reclaim while
servicing the readahead request and reclaim attempts to evict the inode
of the file being read ahead. Since the folio is locked during
readahead, when reclaim evicts the fuse inode and fuse_evict_inode()
attempts to remove all folios associated with the inode from the page
cache (truncate_inode_pages_range()), reclaim will block forever waiting
for the lock since readahead cannot relinquish the lock because it is
itself blocked in reclaim:

>>> stack_trace(1504735)
 folio_wait_bit_common (mm/filemap.c:1308:4)
 folio_lock (./include/linux/pagemap.h:1052:3)
 truncate_inode_pages_range (mm/truncate.c:336:10)
 fuse_evict_inode (fs/fuse/inode.c:161:2)
 evict (fs/inode.c:704:3)
 dentry_unlink_inode (fs/dcache.c:412:3)
 __dentry_kill (fs/dcache.c:615:3)
 shrink_kill (fs/dcache.c:1060:12)
 shrink_dentry_list (fs/dcache.c:1087:3)
 prune_dcache_sb (fs/dcache.c:1168:2)
 super_cache_scan (fs/super.c:221:10)
 do_shrink_slab (mm/shrinker.c:435:9)
 shrink_slab (mm/shrinker.c:626:10)
 shrink_node (mm/vmscan.c:5951:2)
 shrink_zones (mm/vmscan.c:6195:3)
 do_try_to_free_pages (mm/vmscan.c:6257:3)
 do_swap_page (mm/memory.c:4136:11)
 handle_pte_fault (mm/memory.c:5562:10)
 handle_mm_fault (mm/memory.c:5870:9)
 do_user_addr_fault (arch/x86/mm/fault.c:1338:10)
 handle_page_fault (arch/x86/mm/fault.c:1481:3)
 exc_page_fault (arch/x86/mm/fault.c:1539:2)
 asm_exc_page_fault+0x22/0x27

Fix this deadlock by allocating ff->release_args and grabbing the
reference on the inode when preparing the file for release even if the
server does not implement open. The inode reference will be dropped when
the last reference on the fuse file is dropped (see fuse_file_put() ->
fuse_release_end()).

Fixes: e26ee4efbc79 ("fuse: allocate ff->release_args only if release is needed")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reported-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -109,7 +109,9 @@ static void fuse_file_put(struct fuse_fi
 			fuse_file_io_release(ff, ra->inode);
 
 		if (!args) {
-			/* Do nothing when server does not implement 'open' */
+			/* Do nothing when server does not implement 'opendir' */
+		} else if (args->opcode == FUSE_RELEASE && ff->fm->fc->no_open) {
+			fuse_release_end(ff->fm, args, 0);
 		} else if (sync) {
 			fuse_simple_request(ff->fm, args);
 			fuse_release_end(ff->fm, args, 0);
@@ -130,8 +132,17 @@ struct fuse_file *fuse_file_open(struct
 	struct fuse_file *ff;
 	int opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 	bool open = isdir ? !fc->no_opendir : !fc->no_open;
+	bool release = !isdir || open;
 
-	ff = fuse_file_alloc(fm, open);
+	/*
+	 * ff->args->release_args still needs to be allocated (so we can hold an
+	 * inode reference while there are pending inflight file operations when
+	 * ->release() is called, see fuse_prepare_release()) even if
+	 * fc->no_open is set else it becomes possible for reclaim to deadlock
+	 * if while servicing the readahead request the server triggers reclaim
+	 * and reclaim evicts the inode of the file being read ahead.
+	 */
+	ff = fuse_file_alloc(fm, release);
 	if (!ff)
 		return ERR_PTR(-ENOMEM);
 
@@ -151,13 +162,14 @@ struct fuse_file *fuse_file_open(struct
 			fuse_file_free(ff);
 			return ERR_PTR(err);
 		} else {
-			/* No release needed */
-			kfree(ff->args);
-			ff->args = NULL;
-			if (isdir)
+			if (isdir) {
+				/* No release needed */
+				kfree(ff->args);
+				ff->args = NULL;
 				fc->no_opendir = 1;
-			else
+			} else {
 				fc->no_open = 1;
+			}
 		}
 	}
 


