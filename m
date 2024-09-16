Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D6158DD0;
	Mon, 16 Sep 2024 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488279; cv=none; b=rDZQzbzs3l9sZWH3Xtzs+WUHebt44J9wb4TmhDdHqdrjLrp4nXU+dRgX3WXN3z5TgVBrVG503nzBLlea3GBzcpqJbQbrv3a7GEcSIWCeRltW5S/wO+u+pf4ozsjIQjw10N+q2ZFJlNAYXEttFdkJhRQG80JeGrhcBNwamoDub/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488279; c=relaxed/simple;
	bh=+SwOM4Nsa6OyG9ScwqesdNIs7SKBj9TBPx2NZ7LIO44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDuz8+3/f90a/3JckYI1EGeQVNLzzrVFY9wqqlUZkA8wCCK+auosaHMKoft+Ya5V3X+c1DgDTBQqfBr9Fg3l1bi7KbM1QBNy+27OpQ59PBH8OIK2YQEMiruAg03kjxuxhBb/tKmu5u2u6AMSO07tut1wkzLJojRgulcFwPt026U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioANzqLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioANzqLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B438DC4CEC4;
	Mon, 16 Sep 2024 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488279;
	bh=+SwOM4Nsa6OyG9ScwqesdNIs7SKBj9TBPx2NZ7LIO44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioANzqLuVzrnpK3cjDqJAJGb+K7YYCOGpVQ+FBOgdtZ4X1MHuMI9BE19LjMC02f1a
	 J23wXEbxdcLjKOoNfCnGgG6dvHrbHAU/yswZnYq1Oyr9CKY7USbVUGDoUNXpOIrLHI
	 xESjgYCnvm0q45K1AGUt5Oj6NHPuboZwlj6t4FBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.10 057/121] bcachefs: Revert lockless buffered IO path
Date: Mon, 16 Sep 2024 13:43:51 +0200
Message-ID: <20240916114231.040118064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit  e3e6940940910c2287fe962bdf72015efd4fee81 ]

We had a report of data corruption on nixos when building installer
images.

https://github.com/NixOS/nixpkgs/pull/321055#issuecomment-2184131334

It seems that writes are being dropped, but only when issued by QEMU,
and possibly only in snapshot mode. It's undetermined if it's write
calls are being dropped or dirty folios.

Further testing, via minimizing the original patch to just the change
that skips the inode lock on non appends/truncates, reveals that it
really is just not taking the inode lock that causes the corruption: it
has nothing to do with the other logic changes for preserving write
atomicity in corner cases.

It's also kernel config dependent: it doesn't reproduce with the minimal
kernel config that ktest uses, but it does reproduce with nixos's distro
config. Bisection the kernel config initially pointer the finger at page
migration or compaction, but it appears that was erroneous; we haven't
yet determined what kernel config option actually triggers it.

Sadly it appears this will have to be reverted since we're getting too
close to release and my plate is full, but we'd _really_ like to fully
debug it.

My suspicion is that this patch is exposing a preexisting bug - the
inode lock actually covers very little in IO paths, and we have a
different lock (the pagecache add lock) that guards against races with
truncate here.

Fixes: 7e64c86cdc6c ("bcachefs: Buffered write path now can avoid the inode lock")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-io-buffered.c |  149 +++++++++++--------------------------------
 1 file changed, 40 insertions(+), 109 deletions(-)

--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -802,8 +802,7 @@ static noinline void folios_trunc(folios
 static int __bch2_buffered_write(struct bch_inode_info *inode,
 				 struct address_space *mapping,
 				 struct iov_iter *iter,
-				 loff_t pos, unsigned len,
-				 bool inode_locked)
+				 loff_t pos, unsigned len)
 {
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	struct bch2_folio_reservation res;
@@ -828,15 +827,6 @@ static int __bch2_buffered_write(struct
 
 	BUG_ON(!fs.nr);
 
-	/*
-	 * If we're not using the inode lock, we need to lock all the folios for
-	 * atomiticity of writes vs. other writes:
-	 */
-	if (!inode_locked && folio_end_pos(darray_last(fs)) < end) {
-		ret = -BCH_ERR_need_inode_lock;
-		goto out;
-	}
-
 	f = darray_first(fs);
 	if (pos != folio_pos(f) && !folio_test_uptodate(f)) {
 		ret = bch2_read_single_folio(f, mapping);
@@ -931,10 +921,8 @@ static int __bch2_buffered_write(struct
 	end = pos + copied;
 
 	spin_lock(&inode->v.i_lock);
-	if (end > inode->v.i_size) {
-		BUG_ON(!inode_locked);
+	if (end > inode->v.i_size)
 		i_size_write(&inode->v, end);
-	}
 	spin_unlock(&inode->v.i_lock);
 
 	f_pos = pos;
@@ -978,68 +966,12 @@ static ssize_t bch2_buffered_write(struc
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct bch_inode_info *inode = file_bch_inode(file);
-	loff_t pos;
-	bool inode_locked = false;
-	ssize_t written = 0, written2 = 0, ret = 0;
-
-	/*
-	 * We don't take the inode lock unless i_size will be changing. Folio
-	 * locks provide exclusion with other writes, and the pagecache add lock
-	 * provides exclusion with truncate and hole punching.
-	 *
-	 * There is one nasty corner case where atomicity would be broken
-	 * without great care: when copying data from userspace to the page
-	 * cache, we do that with faults disable - a page fault would recurse
-	 * back into the filesystem, taking filesystem locks again, and
-	 * deadlock; so it's done with faults disabled, and we fault in the user
-	 * buffer when we aren't holding locks.
-	 *
-	 * If we do part of the write, but we then race and in the userspace
-	 * buffer have been evicted and are no longer resident, then we have to
-	 * drop our folio locks to re-fault them in, breaking write atomicity.
-	 *
-	 * To fix this, we restart the write from the start, if we weren't
-	 * holding the inode lock.
-	 *
-	 * There is another wrinkle after that; if we restart the write from the
-	 * start, and then get an unrecoverable error, we _cannot_ claim to
-	 * userspace that we did not write data we actually did - so we must
-	 * track (written2) the most we ever wrote.
-	 */
-
-	if ((iocb->ki_flags & IOCB_APPEND) ||
-	    (iocb->ki_pos + iov_iter_count(iter) > i_size_read(&inode->v))) {
-		inode_lock(&inode->v);
-		inode_locked = true;
-	}
-
-	ret = generic_write_checks(iocb, iter);
-	if (ret <= 0)
-		goto unlock;
-
-	ret = file_remove_privs_flags(file, !inode_locked ? IOCB_NOWAIT : 0);
-	if (ret) {
-		if (!inode_locked) {
-			inode_lock(&inode->v);
-			inode_locked = true;
-			ret = file_remove_privs_flags(file, 0);
-		}
-		if (ret)
-			goto unlock;
-	}
-
-	ret = file_update_time(file);
-	if (ret)
-		goto unlock;
-
-	pos = iocb->ki_pos;
+	loff_t pos = iocb->ki_pos;
+	ssize_t written = 0;
+	int ret = 0;
 
 	bch2_pagecache_add_get(inode);
 
-	if (!inode_locked &&
-	    (iocb->ki_pos + iov_iter_count(iter) > i_size_read(&inode->v)))
-		goto get_inode_lock;
-
 	do {
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		unsigned bytes = iov_iter_count(iter);
@@ -1064,17 +996,12 @@ again:
 			}
 		}
 
-		if (unlikely(bytes != iov_iter_count(iter) && !inode_locked))
-			goto get_inode_lock;
-
 		if (unlikely(fatal_signal_pending(current))) {
 			ret = -EINTR;
 			break;
 		}
 
-		ret = __bch2_buffered_write(inode, mapping, iter, pos, bytes, inode_locked);
-		if (ret == -BCH_ERR_need_inode_lock)
-			goto get_inode_lock;
+		ret = __bch2_buffered_write(inode, mapping, iter, pos, bytes);
 		if (unlikely(ret < 0))
 			break;
 
@@ -1095,46 +1022,50 @@ again:
 		}
 		pos += ret;
 		written += ret;
-		written2 = max(written, written2);
-
-		if (ret != bytes && !inode_locked)
-			goto get_inode_lock;
 		ret = 0;
 
 		balance_dirty_pages_ratelimited(mapping);
-
-		if (0) {
-get_inode_lock:
-			bch2_pagecache_add_put(inode);
-			inode_lock(&inode->v);
-			inode_locked = true;
-			bch2_pagecache_add_get(inode);
-
-			iov_iter_revert(iter, written);
-			pos -= written;
-			written = 0;
-			ret = 0;
-		}
 	} while (iov_iter_count(iter));
-	bch2_pagecache_add_put(inode);
-unlock:
-	if (inode_locked)
-		inode_unlock(&inode->v);
 
-	iocb->ki_pos += written;
+	bch2_pagecache_add_put(inode);
 
-	ret = max(written, written2) ?: ret;
-	if (ret > 0)
-		ret = generic_write_sync(iocb, ret);
-	return ret;
+	return written ? written : ret;
 }
 
-ssize_t bch2_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t bch2_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	ssize_t ret = iocb->ki_flags & IOCB_DIRECT
-		? bch2_direct_write(iocb, iter)
-		: bch2_buffered_write(iocb, iter);
+	struct file *file = iocb->ki_filp;
+	struct bch_inode_info *inode = file_bch_inode(file);
+	ssize_t ret;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		ret = bch2_direct_write(iocb, from);
+		goto out;
+	}
 
+	inode_lock(&inode->v);
+
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto unlock;
+
+	ret = file_remove_privs(file);
+	if (ret)
+		goto unlock;
+
+	ret = file_update_time(file);
+	if (ret)
+		goto unlock;
+
+	ret = bch2_buffered_write(iocb, from);
+	if (likely(ret > 0))
+		iocb->ki_pos += ret;
+unlock:
+	inode_unlock(&inode->v);
+
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+out:
 	return bch2_err_class(ret);
 }
 


