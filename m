Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE5D1A2389;
	Thu, 15 Jan 2026 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498491; cv=none; b=rcf0E30M9sLyE3ZqAZQpwM99KwoJAVkxUJRhHOZVRclU75SKWwlmhhAPrZn9ZNrZyrLRuEfzgdlhS+WctIx8ollu2WFVtjRdN+XfIORJpWkOu3v3oZdCnGgIR6nfYonBz8n+3MD+O5Jlt5dEab8bw0WYsu0UJ381mVKQTgm3OXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498491; c=relaxed/simple;
	bh=wj0cicjXypxncfDZFEa7AYxCZFB3VUUVWJI+J/VS7Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YucRgUulcXe0zV9z7X7uhxyhQOKrPvnXI3cgOiv493VEUpS0xR6ZciCEYUpcl6kDpiaBq6FKBqjHlSpGZjpoJ49zkImk4Q3gHNYGyMXZSIDQNmdVaJZDSAmRmtzCA0LlErvfp6Cl7kbs4PvoMK1RxSePtilbGOdMq9AQ4pbXlS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU1dRIwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU1dRIwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83626C116D0;
	Thu, 15 Jan 2026 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498490;
	bh=wj0cicjXypxncfDZFEa7AYxCZFB3VUUVWJI+J/VS7Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU1dRIwnljF7JIQ+NIDrVOpmNZoiiDSVqlUmfy0Zk9Yl/CzMDUgXtdK99VHNMkOrg
	 JymfGrHt95jidEWAxuVEYJFixuYK+P5DetLcLVYwhER95B9biFj4AJTbmHgXtv95Cq
	 i6LNfPNFmWLS60ZYwBEToaKuqfR11gwDmB2JmfZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Omar Sandoval <osandov@fb.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/554] fuse: fix readahead reclaim deadlock
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164302.522649673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit bd5603eaae0aabf527bfb3ce1bb07e979ce5bd50 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -112,7 +112,9 @@ static void fuse_file_put(struct fuse_fi
 		struct fuse_args *args = (ra ? &ra->args : NULL);
 
 		if (!args) {
-			/* Do nothing when server does not implement 'open' */
+			/* Do nothing when server does not implement 'opendir' */
+		} else if (args->opcode == FUSE_RELEASE && ff->fm->fc->no_open) {
+			fuse_release_end(ff->fm, args, 0);
 		} else if (sync) {
 			fuse_simple_request(ff->fm, args);
 			fuse_release_end(ff->fm, args, 0);
@@ -133,8 +135,17 @@ struct fuse_file *fuse_file_open(struct
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
 
@@ -153,13 +164,14 @@ struct fuse_file *fuse_file_open(struct
 			fuse_file_free(ff);
 			return ERR_PTR(err);
 		} else {
-			/* No release needed */
-			kfree(ff->release_args);
-			ff->release_args = NULL;
-			if (isdir)
+			if (isdir) {
+				/* No release needed */
+				kfree(ff->release_args);
+				ff->release_args = NULL;
 				fc->no_opendir = 1;
-			else
+			} else {
 				fc->no_open = 1;
+			}
 		}
 	}
 


