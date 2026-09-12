Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E413148DA;
	Sat, 12 Sep 2026 07:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199699; cv=none; b=OTWdLuKkosi4/Jxk3ZVZOQPZSx2VeHwpBESoZK1AsNX6R3126OzCHkduHXWHllDO8dEdAwATBBtWtA25XWqBdgz65LOuQ7OG/dG6S0Z1HuPEinH9EeNq2T4LfjSSpmkxT2EZ8rkn+xu0QztRfvk5C73YeG3wRvMbtvpupNG+Jmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199699; c=relaxed/simple;
	bh=MvgKEbdQ4KkjGukug/7AAZwmhl3tJeggEVRrqE3DZJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI/4FvfaOmwKgY1CmPl6CxfJCw52EUcCc3WsRM6ES105IX/jPYIQPMm4/wky4qlp5Ev1X3HTGSNJKCMPm1S4lFoWzQSt7RKNffZRDnONFal4byVbf9yTMrvQAilH1GzrLmhzq9bxWXa9oSU5HuDLHqEAlbQr37tFnqEvHgrIF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYIFSvXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYIFSvXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5991F1F000FF;
	Sat, 12 Sep 2026 07:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199697;
	bh=wgr0n/IqTFomg9Zj4bKcZgh7B1AGpvnfHIolIYgYKAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYIFSvXnCWpBeUyN1Z1ZoQDoOyeCQT+HwPVGJMYpinqclwK136lHmAywwyJSFq2R/
	 GMnFNdwrg/oWadOlWn7ebajTPOOhCJACyNfXvI+VPOQLKz3NwLIlJ8SNLmu40ex79A
	 1bImyfc6/nikp1juWbt/u69j8LBFDm32AMp6ZKEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0596/1815] ext4: use fsdata to track inline data write state and fix race
Date: Sat, 12 Sep 2026 08:39:06 +0200
Message-ID: <20260912065702.875681355@linuxfoundation.org>
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

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

[ Upstream commit 7edbb323bab2b2a609016014caafdb651c898249 ]

Instead of checking the live inode state (ext4_has_inline_data(inode)
and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
write_end handlers, use the fsdata parameter of the address space
operations to explicitly pass down the state in which write_begin
prepared the write.

A concurrent thread (such as ext4_page_mkwrite()) can convert the
inline data to an extent between write_begin and write_end. If this
happens, the write_end handlers would previously miss the inline
write_end path and fall through to extent-based write_end logic.
However, since block buffers were never allocated in write_begin,
this resulted in NULL pointer dereferences or data loss because
folio_buffers(folio) was NULL.

Define EXT4_WRITE_DATA_INLINE (4) as a bit flag (Bit 2), treating
fsdata as bitwise flags rather than mutually exclusive enums to keep
states of the write path independent. Communicate this state via
fsdata:
1) ext4_write_begin() and ext4_da_write_begin() set the
   EXT4_WRITE_DATA_INLINE bit in *fsdata via bitwise OR when an inline
   write is successfully prepared.
2) On entry, ext4_write_begin() clears the EXT4_WRITE_DATA_INLINE bit
   to safely handle VFS retries (where generic_perform_write() bypasses
   the fsdata initialization on its retry jump).
3) The write_end handlers perform a bitwise AND to check if the
   EXT4_WRITE_DATA_INLINE bit is set and invoke the inline write_end
   helper accordingly.

Furthermore, during a buffered write, ext4_write_inline_data_end()
acquires the xattr lock after preparing the write. If a concurrent
page fault (ext4_page_mkwrite()) converts the inline data to an extent
after the write_end handlers check the state but before
ext4_write_inline_data_end() acquires the xattr write lock, the
subsequent check will trigger a kernel panic via
BUG_ON(!ext4_has_inline_data(inode)).

To keep git history working and bisectability clean, replace the
BUG_ON check in ext4_write_inline_data_end() with a graceful error-
handling retry path in this same commit. If the inline data is cleared
after locking the xattr, we safely release all resources (releasing
iloc.bh, unlocking/putting the folio, stopping the active journal
transaction handle) and return 0 (VFS retry) to let the generic write
path retry the operation safely.

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260703045414.1768-1-aditya.ansh182@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h   |  1 +
 fs/ext4/inline.c | 14 +++++++++++++-
 fs/ext4/inode.c  | 24 +++++++++++++-----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c76dd0bdd3d86..8bf6272c485dc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
+#define EXT4_WRITE_DATA_INLINE	 4
 
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f1f7104d3dac7..7bb28735de911 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			goto out;
 		}
 		ext4_write_lock_xattr(inode, &no_expand);
-		BUG_ON(!ext4_has_inline_data(inode));
+		/*
+		 * We could have raced with ext4_page_mkwrite() converting
+		 * the inode and clearing the inline data flag, so we just
+		 * release resources and retry the whole write.
+		 */
+		if (unlikely(!ext4_has_inline_data(inode))) {
+			ext4_write_unlock_xattr(inode, &no_expand);
+			brelse(iloc.bh);
+			folio_unlock(folio);
+			folio_put(folio);
+			ext4_journal_stop(handle);
+			return 0;
+		}
 
 		/*
 		 * ei->i_inline_off may have changed since
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 61c3fce38d889..c4eb8171a6444 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1303,6 +1303,8 @@ static int ext4_write_begin(const struct kiocb *iocb,
 	if (unlikely(ret))
 		return ret;
 
+	*fsdata = (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);
+
 	trace_ext4_write_begin(inode, pos, len);
 	/*
 	 * Reserve one block more for addition to orphan list in case
@@ -1317,8 +1319,10 @@ static int ext4_write_begin(const struct kiocb *iocb,
 						    foliop);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
 			return 0;
+		}
 	}
 
 	/*
@@ -1451,8 +1455,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -1561,8 +1564,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -3174,8 +3176,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 						     foliop, fsdata, true);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
 			return 0;
+		}
 	}
 
 retry:
@@ -3304,17 +3308,15 @@ static int ext4_da_write_end(const struct kiocb *iocb,
 			     struct folio *folio, void *fsdata)
 {
 	struct inode *inode = mapping->host;
-	int write_mode = (int)(unsigned long)fsdata;
+	unsigned long write_mode = (unsigned long)fsdata;
 
-	if (write_mode == FALL_BACK_TO_NONDELALLOC)
+	if (write_mode & FALL_BACK_TO_NONDELALLOC)
 		return ext4_write_end(iocb, mapping, pos,
 				      len, copied, folio, fsdata);
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
 
-	if (write_mode != CONVERT_INLINE_DATA &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
-	    ext4_has_inline_data(inode))
+	if (write_mode & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.53.0



