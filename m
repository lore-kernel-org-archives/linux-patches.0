Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C3525485E;
	Mon, 24 Feb 2025 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407861; cv=none; b=c4e22A2ALWLbWEaY/2qQ+f+54rAQsmCNRcZkK6fl4d8FPgqehQSkBPvpumJORekMEdswELelkd3P2OlHzmM0IEcuRCy6kLAL9BLUsIjufjqzgEL1whx38QHoJgU7xE/uD2xF333sfkwsmGT+l7Clqg1g6LZOoM7pkQuSjJTf2Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407861; c=relaxed/simple;
	bh=HWhFcce8SQTtmANeSH7RJK44JIJ2AY66UW8BSG2uv4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYWvNd378wtYcAKxMqbvt1RMHmECmA7RhA4/b8wJ2VTPXgBo/GRpHzWzaL+5rfmcNkQYq6kLVB0xA9Bx95GD2lic9Rt8uKtQH+msVOV289pr40aWVPSCn2iCJLoUSYm+5imhGmQsBnBtfnBCQRGVHvFQ7Xo68m+5G07wUHlNre8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdrqvROK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdrqvROK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4860C4CED6;
	Mon, 24 Feb 2025 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407861;
	bh=HWhFcce8SQTtmANeSH7RJK44JIJ2AY66UW8BSG2uv4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdrqvROK9vUscuD14LK3EvWgenpDFXmdqrf6xzCKHbNZVm+GXUAmieY5vGIXSwkHs
	 W3CoPvpwOOkQnzkGytoLmiXBv8Qby45SsyWfT3zFMJ7sCJWn9GgyZ8+Pmc0EQF/21o
	 KkyfzOgkPCkQ0kyrCkawGmzqBBuGkmciZYmqL2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 007/140] xfs: dont free cowblocks from under dirty pagecache on unshare
Date: Mon, 24 Feb 2025 15:33:26 +0100
Message-ID: <20250224142603.295057663@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit 4390f019ad7866c3791c3d768d2ff185d89e8ebe upstream.

fallocate unshare mode explicitly breaks extent sharing. When a
command completes, it checks the data fork for any remaining shared
extents to determine whether the reflink inode flag and COW fork
preallocation can be removed. This logic doesn't consider in-core
pagecache and I/O state, however, which means we can unsafely remove
COW fork blocks that are still needed under certain conditions.

For example, consider the following command sequence:

xfs_io -fc "pwrite 0 1k" -c "reflink <file> 0 256k 1k" \
	-c "pwrite 0 32k" -c "funshare 0 1k" <file>

This allocates a data block at offset 0, shares it, and then
overwrites it with a larger buffered write. The overwrite triggers
COW fork preallocation, 32 blocks by default, which maps the entire
32k write to delalloc in the COW fork. All but the shared block at
offset 0 remains hole mapped in the data fork. The unshare command
redirties and flushes the folio at offset 0, removing the only
shared extent from the inode. Since the inode no longer maps shared
extents, unshare purges the COW fork before the remaining 28k may
have written back.

This leaves dirty pagecache backed by holes, which writeback quietly
skips, thus leaving clean, non-zeroed pagecache over holes in the
file. To verify, fiemap shows holes in the first 32k of the file and
reads return different data across a remount:

$ xfs_io -c "fiemap -v" <file>
<file>:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   ...
   1: [8..511]:        hole               504
   ...
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  cd cd cd cd cd cd cd cd  ........
$ umount <mnt>; mount <dev> <mnt>
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  00 00 00 00 00 00 00 00  ........

To avoid this problem, make unshare follow the same rules used for
background cowblock scanning and never purge the COW fork for inodes
with dirty pagecache or in-flight I/O.

Fixes: 46afb0628b86347 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c  |    8 +-------
 fs/xfs/xfs_reflink.c |    3 +++
 fs/xfs/xfs_reflink.h |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1271,13 +1271,7 @@ xfs_prep_free_cowblocks(
 	 */
 	if (!sync && inode_is_open_for_write(VFS_I(ip)))
 		return false;
-	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
-	    atomic_read(&VFS_I(ip)->i_dio_count))
-		return false;
-
-	return true;
+	return xfs_can_free_cowblocks(ip);
 }
 
 /*
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1600,6 +1600,9 @@ xfs_reflink_clear_inode_flag(
 
 	ASSERT(xfs_is_reflink_inode(ip));
 
+	if (!xfs_can_free_cowblocks(ip))
+		return 0;
+
 	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
 	if (error || needs_flag)
 		return error;
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -16,6 +16,25 @@ static inline bool xfs_is_cow_inode(stru
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
 
+/*
+ * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
+ * to do so when an inode has dirty cache or I/O in-flight, even if no shared
+ * extents exist in the data fork, because outstanding I/O may target blocks
+ * that were speculatively allocated to the COW fork.
+ */
+static inline bool
+xfs_can_free_cowblocks(struct xfs_inode *ip)
+{
+	struct inode *inode = VFS_I(ip);
+
+	if ((inode->i_state & I_DIRTY_PAGES) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    atomic_read(&inode->i_dio_count))
+		return false;
+	return true;
+}
+
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,


