Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D9C403B13;
	Tue, 21 Jul 2026 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665609; cv=none; b=TdJ4+2Wuc24Ka+bA+3SsBkQlR9EmfGT25TgX0UJqeqv+WVKeUC+z1BygwajgP3DHot0BWl+YWYnBuaFT40ksmHyWFn0JYHEcl7kRhwjhgL937AS6fd2b5uttrquu0MZb77+q1nK1YGdmbrxb+euyu4nUyr6XmoHiTdgWpErTOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665609; c=relaxed/simple;
	bh=cMOqVaK28+Qybd2g1I1OYvvyU/Ic6XriOrocnSssy4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mnk79f1sD2iK8tx2FdGOWtClPpBOSWuqBB/uZUF/aK5axWjbp5FQyPNmW2/d+asanoCjbQLQrjj8rKGEhtz/sJ7/O7fDes1NnE5m8jxOZEfk0bJDGSmPb+y7d7dPkNablZUGNWBad/ruIJICzjQZ8hOCZeoKGq+LiOSqfQVaZf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTi4AvEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTi4AvEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA131F000E9;
	Tue, 21 Jul 2026 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665607;
	bh=P2lkvXvsShhklrsluvm86UHJqu2DAUK9WseRpD2Ay4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTi4AvEUXo34mb348/MPJNrq3dfgRPbO9qOfmfgx7krvEL+UeppPPthGC/hSNA0kF
	 9q1JvHIrwuZVeGBXI3Fk0BYnBVP7pu6817+2ymiiK9hE76K1hA9lQq6q53iG+IJjTu
	 ovDq6eJh/LioUYVXaQVYBW8QplJEvv4MBXpywR9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hch@lst.de,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0325/1266] xfs: resample the data fork mapping after cycling ILOCK
Date: Tue, 21 Jul 2026 17:12:42 +0200
Message-ID: <20260721152449.107011585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2f4acd0fcd862e22eab45690ec2c08c80b6ef2e7 upstream.

xfs_reflink_fill_{cow_hole,delalloc} are both presented with an inode,
a data fork mapping, and a cow fork mapping.  Unfortunately, these two
helpers cycle the ILOCK to grab a transaction, which means that the
mappings are stale as soon as we reacquire the ILOCK.  Currently we
refresh the cow fork mapping by re-calling xfs_find_trim_cow_extent, but
we don't refresh the data fork mapping beforehand, which means that the
xfs_bmap_trim_cow in that function queries the refcount btree about the
wrong physical blocks and returns an inaccurate value in *shared.

If *shared is now false, the directio write proceeds with a stale data
fork mapping.  Fix this by querying the data fork mapping if the
sequence counter changes across the ILOCK cycle.

Cc: hch@lst.de
Cc: stable@vger.kernel.org # v4.11
Fixes: 3c68d44a2b49a0 ("xfs: allocate direct I/O COW blocks in iomap_begin")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -389,6 +389,7 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks;
+	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
 	int			nimaps;
 	int			error;
 	bool			found;
@@ -407,6 +408,22 @@ xfs_reflink_fill_cow_hole(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
+	/*
+	 * The data fork mapping may have changed while we dropped the ILOCK
+	 * (a racing O_DIRECT writer under IOLOCK_SHARED can complete a full
+	 * CoW cycle including xfs_reflink_end_cow(), which remaps this offset
+	 * and drops the refcount of the old shared block).  Re-read it so the
+	 * shared-status recheck below and the caller's in-place iomap both
+	 * operate on the current mapping rather than a stale physical block.
+	 */
+	if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, imap->br_startoff,
+				imap->br_blockcount, imap, &nimaps, 0);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
 		goto out_trans_cancel;
@@ -453,6 +470,8 @@ xfs_reflink_fill_delalloc(
 	bool			found;
 
 	do {
+		unsigned int	seq_before = READ_ONCE(ip->i_df.if_seq);
+
 		xfs_iunlock(ip, *lockmode);
 		*lockmode = 0;
 
@@ -463,6 +482,23 @@ xfs_reflink_fill_delalloc(
 
 		*lockmode = XFS_ILOCK_EXCL;
 
+		/*
+		 * The data fork mapping may have changed while we dropped the
+		 * ILOCK (a racing O_DIRECT writer under IOLOCK_SHARED can
+		 * complete a full CoW cycle including xfs_reflink_end_cow(),
+		 * which remaps this offset and drops the refcount of the old
+		 * shared block).  Re-read it so the shared-status recheck
+		 * below and the caller's in-place iomap both operate on the
+		 * current mapping rather than a stale physical block.
+		 */
+		if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
+			nimaps = 1;
+			error = xfs_bmapi_read(ip, imap->br_startoff,
+					imap->br_blockcount, imap, &nimaps, 0);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
 				&found);
 		if (error || !*shared)


