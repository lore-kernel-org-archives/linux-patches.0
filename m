Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829080;
	b=wo69gzy6+ZfSHsWwFYeUbfyXkG1ZX5zKozigNsdMdNFrYN+lUkLhHtbZ9AqbjfdXmng0
	 YoUgpETyqkygiz2+EWovVaHBIIcGzed15rr819sPcAVy/T9PYIvlY1H9xDNbJR3sSEX/V
	 45sWbkbD1gETJAmltooHrZDPKX2M0DPXZG7XDyQQK4Ff/ut/EMD6x+xkDFdXalpf69Cmq
	 mSo1DD+/jNP0d1TO0cIWZRoNw3sib3vaQcACDvCH/sUDX8I3XchT1HqKmNDz99N/IvyDf
	 DrEk6izWb5GctMZBCvwxam0/GIVIzjJB2UyySU4ylekZLbZ0WnggReQf+73lhWJ13gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BTmh8lFuutGcLwIuVmaIrhrsPv5NeGRum5L9swwpFOw=;
	b=z0a8lfKWmpkVaDq+SQ3tj9q86jzYofKsKFh2pmh+jTlcLhbFKmBGtUH1x2zcOirw23M0
	 KDo5CXjxfhXV8s0R6EXiumXh1T+lZClOmLccXJNWEeOS54LrkLKw3xd5rpfns7uOvb/mG
	 WobWxeVwZYWJ6p7CCyZ2J6C8+xQmbI2ab910OCMpQX2Y0K4lJl2AW5eo0/tROEifAjHYm
	 V1pybpqINiRf2I9+fAqbJw2zZ4ZnZoJCnHvd3D+Nif6fEtyGmos+rwgptbklitVnzG0zD
	 WPtt01sPm4imhT58gwl1OpmU1cf36e5yea2cE9/Uw8mxPsMzrX5L5e1wl0jurW7mFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Tgn/jMC0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01E607032D;
	Wed,  4 Nov 2026 21:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tgn/jMC0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E007C1F000C1;
	Wed,  4 Nov 2026 21:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829080;
	bh=BTmh8lFuutGcLwIuVmaIrhrsPv5NeGRum5L9swwpFOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tgn/jMC0wBhJl/X+qaC/xWFw5g8UnDTbQ82IrGYYIh73Zzr6ODHNwAcESg70BiCGS
	 jt0wU2l3jCNIc2nU7PP5Y2dZkfDbRI3H75zYjydMvlpAEtZoztRT3yygfZ6icTmEIY
	 VGbM3Mazfr9w/x08CnpltnHZuMulpNPmaP7tiMPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 392/547] xfs: map pNFS layouts to the end of the extent again
Date: Wed,  4 Nov 2026 16:09:36 -0500
Message-ID: <20261104211049.435292282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

commit e3c682dd11303a95ff82ea63b9172dce788578d4 upstream.

Since commit 36ca6f11424a ("xfs: fix overlapping extents returned for
pNFS LAYOUTGET"), xfs_fs_map_blocks() maps only the range that nfsd asks
for.  For O_DIRECT, the Linux block layout client asks for the range of
the I/O at hand, so it now needs a LAYOUTGET for every O_DIRECT read or
write to a part of a file it has no layout for yet, where the first
LAYOUTGET used to return the whole extent.  Each LAYOUTGET is a round
trip, and xfs_fs_map_blocks() takes the iolock exclusively and writes
back and invalidates the page cache of the file for it.

On three QEMU VMs (an NVMe/TCP target, the server with nfsd and XFS, and
a client) running the same kernel without KASAN or lock debugging, a
client doing O_DIRECT I/O over the block layout of NFSv4.2 for 30
seconds to a 1 GiB file of one written extent, in order unless noted and
with an fsync every 16 MiB written, gets this many I/Os done (and
LAYOUTGETs counted at the server), one run each:

                       unpatched   ENTIRE, no trim      this patch
  4 KiB reads      41207 (41207)        334931 (1)      343749 (1)
  4 KiB random     36670 (34148)        259527 (1)     263829 (15)
  4 KiB overwrite  38556 (38556)        325533 (1)      307105 (1)
  64 KiB reads     70241 (16384)         80829 (1)       91196 (1)
  1 MiB reads       6857 (1024)           6759 (1)        6706 (1)

"ENTIRE, no trim" is a test kernel that maps with XFS_BMAPI_ENTIRE and
does not trim.  The random reads need a LAYOUTGET each time they go
before the lowest offset read so far, as the part of the extent before
the offset asked for is not mapped.  1 MiB overwrites and writes to an
unwritten extent also go from 1024 LAYOUTGETs to 1, with no clear change
in I/Os done.  Appending to a new file needs a LAYOUTGET per 1 MiB
appended either way, as XFS allocates only the range asked for on a
filesystem without a stripe unit or an extent size hint.

The overlap fixed by that commit comes from XFS_BMAPI_ENTIRE reaching
back.  nfsd4_block_proc_layoutget() calls ->map_blocks once per extent
of a LAYOUTGET, each time for the range left after the previous extent.
An allocation in one call can merge the extent that the next call starts
in with the extents before it, and the whole extent then starts before
the offset of that call and overlaps extents already in the layout.  The
Linux client rejects such a layout (verify_extent() returns -EIO), and
the I/O that needed it fails.

In the thread of that commit, Christoph Hellwig asked for
XFS_BMAPI_ENTIRE to be dropped to stop the overlap, Darrick J. Wong
agreed, and it was said that the flag makes no difference on the first
call, which is for the whole range the client asked for.  The difference
is past that range: the Linux client asks for the range of each O_DIRECT
I/O and uses the rest of a longer layout for the I/Os that follow, which
RFC 8881 allows (Table 22 sets only a minimum length).  A client could
ask for more for a read layout, but for a write layout
xfs_fs_map_blocks() allocates any hole in the range asked for.

Dave Chinner suggested keeping the flag for the first call and trimming
the mappings of the calls that follow.  ->map_blocks cannot tell the
first call from the others, and Christoph preferred to keep such a
choice out of that interface, so trim every mapping to start at the
offset asked for instead.  No mapping can then overlap the one before
it, since each call starts where the previous extent ended.  Unlike
Dave's suggestion, the first mapping loses the part of the extent before
the offset, and the last mapping keeps the part past the end of the
range, which the loop in nfsd4_block_proc_layoutget() already handles.
Trimming in that loop instead would keep his suggestion exactly, but
would change nfsd as well, while trimming in XFS keeps every mapping it
returns free of overlap whatever the caller does.

Unlike before that commit, don't let the mapping reach past EOF beyond
the range asked for.  On an inode without XFS_DIFLAG_PREALLOC or
XFS_DIFLAG_APPEND, xfs_free_eofblocks() can free blocks past EOF, such
as speculative preallocation, without breaking the layout, so a client
that did not ask for them should not get them.  What a client gets for a
range past EOF that it asks for does not change.

The aio group, the fsx tests and generic/013 (fsstress) of fstests over
the block layout, and the fsx tests and generic/013 over the SCSI
layout, give the same results with and without this patch.  generic/091
and 263 fail with the ENTIRE, no trim kernel and pass with this patch,
and so does the pynfs test BLOCK5, which checks a write layout over a
hole between two allocated blocks against three rules of RFC 5663
section 2.3.1.

Fixes: 36ca6f11424a ("xfs: fix overlapping extents returned for pNFS LAYOUTGET")
Cc: stable@vger.kernel.org
Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ageSguSyf2kBY33a@dread
Link: https://lore.kernel.org/r/agwDhixPAAA0-cTa@infradead.org
Link: https://lore.kernel.org/r/agqfBPRWXQDR2ImG@infradead.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_pnfs.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f8535ecde21a..ab385617003a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -183,13 +183,28 @@ xfs_fs_map_blocks(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
 	lock_flags = xfs_ilock_data_map_shared(ip);
-	/* request mappings for the specified range only */
+	/*
+	 * Map to the end of the extent that covers the start of the range,
+	 * so that a client doing I/O in pieces gets a layout it can use for
+	 * the pieces that follow.  Never map anything before the start of
+	 * the range: nfsd calls in here once per extent of a LAYOUTGET, for
+	 * the range that is left after the previous extent, and the mapping
+	 * can change in between, so a mapping that reaches back can overlap
+	 * one already in the layout.  Don't extend the mapping past EOF
+	 * beyond the range either: xfs_free_eofblocks() can free blocks past
+	 * EOF without breaking the layout.
+	 */
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, 0);
+				&imap, &nimaps, XFS_BMAPI_ENTIRE);
 	if (error) {
 		xfs_iunlock(ip, lock_flags);
 		goto out_unlock;
 	}
+	if (nimaps)
+		xfs_trim_extent(&imap, offset_fsb,
+				max_t(xfs_fileoff_t, end_fsb,
+				      XFS_B_TO_FSB(mp, XFS_ISIZE(ip))) -
+				offset_fsb);
 	seq = xfs_iomap_inode_sequence(ip, 0);
 
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
-- 
2.56.0



