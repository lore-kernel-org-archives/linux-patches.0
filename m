Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177A04C10EC;
	Thu, 17 Sep 2026 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660690; cv=none; b=MyGZqwOWbHtAvfpdebiQFfQkq9ZfvA4HjIrYC+yyscq7HoGhtIazaULX+s1h5IWWprApl7a2Ex0t/o1qln8nm6nEDCwbz2EdDEkqEXDlEYx29Q3AMpkOJ1niSukly8DxXxCCbRWGD+rzWzs5EW+OOUisFOydNItehUsK0qSQRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660690; c=relaxed/simple;
	bh=uOnLNvKnL+DaC9JxqNgjjF1O3aeWhQ8NwRXX5JofdMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h70sS3AN58uusGxRxt5lyW60STppfkRLXUz3Ijqlp02n7iCcL0cRiCfGN+5eBs4+h6v1LqD9E0AXmLhkTeLL6sSvRam7JZ/gz1mzXaJ+CQhRUjNYdXNnUmlrgySgYMJ3xkb7DuWfv6yqpDxgPbvadDTUjoz5LD/ml7o9PRzmLJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTdfo1Zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTdfo1Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD7B1F000FF;
	Thu, 17 Sep 2026 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660688;
	bh=2etyC5+5U+V2+LrSk1aNwdkk7P35ipNtl0cMWbrOMPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTdfo1Zxft7ZuPE31aE1gt0gvU+Jf5bALH5YAI0rdIwzIo/4e3f3YwdUEipfWFTJI
	 FGm43hOxA68ExU1A+UQmbKHk4lmQSBn8LAD81phflJb78IvuFHceyAHPRo2vzBOsv/
	 qOVSCdBHhDV3gOQLnlGR+EGiuGQJkPFZ6/YdcbH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	floss@jetm.me,
	dgc@kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 659/733] xfs: fix under-reservation of blocks when repairing sf directories
Date: Thu, 17 Sep 2026 16:16:07 +0100
Message-ID: <20260917151409.086710967@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 4d3c07591534517c633945c8d8e6526f10e3fabc upstream.

Whilst running QA on XFS for-next as of 7.3-rc2 with MKFS_OPTIONS="-n
size=8192", I observed the following (trimmed) dmesg splat:

 XFS: Assertion failed: args->total >= dp->i_nblocks - nblks, file: fs/xfs/libxfs/xfs_da_btree.c, line: 2387
 WARNING: fs/xfs/xfs_message.c:104 at assfail+0x46/0x4a [xfs], CPU#0: xfs_scrub/1426511
 CPU: 0 UID: 0 PID: 1426511 Comm: xfs_scrub Tainted: G        W           7.3.0-rc2-djwx #rc2 PREEMPT(lazy)  6e418570b606a39783b0e7e7b30dc407b965f9e8
 Tainted: [W]=WARN
 RIP: 0010:assfail+0x46/0x4a [xfs]
 RSP: 0018:ffffc900010d7890 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffd1
 RDX: 0000000000000000 RSI: 0000000000000021 RDI: ffffffffa059fd38
 RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
 R10: 000000000000000a R11: 000000007fffffff R12: ffffc900010d7940
 R13: ffff888368d8f980 R14: ffffc900010d7a48 R15: ffffc900010d78d0
 FS:  00007f445c5ce680(0000) GS:ffff8884a97ea000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f443803b9a8 CR3: 0000000107a4b000 CR4: 00000000003506f0
 Call Trace:
  <TASK>
  xfs_da_grow_inode_int+0x2e0/0x300 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xfs_dir2_grow_inode+0x6e/0x150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xfs_dir2_sf_to_block+0x149/0x870 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xrep_dir_swap_prep+0xe2/0x110 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xrep_dir_swap+0xfb/0x2f0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xrep_dir_rebuild_tree+0x99/0x100 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xrep_directory+0x83/0x1c0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xrep_attempt+0x4f/0x1e0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xfs_scrub_metadata+0x393/0x5b0 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xfs_ioc_scrubv_metadata+0x306/0x570 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  xfs_file_ioctl+0xa4f/0x1150 [xfs 5de2257e14108c136f11317e6bbb8ac77efd392c]
  __x64_sys_ioctl+0x76/0xc0
  do_syscall_64+0x7a/0x3b0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

This is a consequence of commit 0fe77e57588b98, which added the
following assertion to xfs_da_grow_inode_int:

 ASSERT(args->total >= dp->i_nblocks - nblks);

Tracing this back to xrep_dir_swap_prep, I noticed that the xfs_da_args
object that's passed to xfs_dir2_sf_to_block sets args->total to 1.
This is incorrect because mkfs set the directory block size to 8k and
the filesystem block size to 4k.  In other words, args->total should be
2 here, not 1.

Dave Chinner tripped over the same problem with the same branch through
a different channel -- his test setup set the fs block size to 1k, in
which case the directory block size is still set to 4k.  Here,
args->total should be 4.

Changing the assignment of args->total to sc->mp->m_dir_geo->fsbcount
makes the assertion go away, but that isn't a complete fix.  In
xrep_tempexch_estimate, we also incorrectly assume that a shortform
conversion requires 1 fsblock when it should be m_dir_geo->fsbcount.
Without that, we can under-reserve space in the transaction and cause a
filesystem shutdown.

Note that the xfs_dabuf_nfsb helper will compute the correct value for
directories and xattr, so we use that instead of open-coding the logic.
Also fix xrep_xattr_swap_prep to assign args->total via xfs_dabuf_nfsb
to avoid one logic bomb if we ever support multi-fsblock attrs.

Cc: stable@vger.kernel.org # v6.10
Cc: floss@jetm.me
Reported-by: dgc@kernel.org
Fixes: 629fdaf5f5b1b7 ("xfs: use atomic extent swapping to fix user file fork data")
Tripped-by: 0fe77e57588b98 ("xfs: assert the reservation covers each da fork growth")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h |    2 ++
 fs/xfs/scrub/attr_repair.c   |    2 +-
 fs/xfs/scrub/dir_repair.c    |    2 +-
 fs/xfs/scrub/tempfile.c      |   29 ++++++++++++++++++++++-------
 5 files changed, 27 insertions(+), 10 deletions(-)

--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -130,7 +130,7 @@ xfs_da_state_reset(
 	state->mp = state->args->dp->i_mount;
 }
 
-static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
+inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK)
 		return mp->m_dir_geo->fsbcount;
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -244,4 +244,6 @@ xfs_failaddr_t xfs_da3_node_header_check
 
 extern struct kmem_cache	*xfs_da_state_cache;
 
+int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork);
+
 #endif	/* __XFS_DA_BTREE_H__ */
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1294,7 +1294,7 @@ xrep_xattr_swap_prep(
 			.geo		= sc->mp->m_attr_geo,
 			.whichfork	= XFS_ATTR_FORK,
 			.trans		= sc->tp,
-			.total		= 1,
+			.total		= xfs_dabuf_nfsb(sc->mp, XFS_ATTR_FORK),
 			.owner		= I_INO(sc->ip),
 		};
 
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1467,7 +1467,7 @@ xrep_dir_swap_prep(
 			.geo		= sc->mp->m_dir_geo,
 			.whichfork	= XFS_DATA_FORK,
 			.trans		= sc->tp,
-			.total		= 1,
+			.total		= xfs_dabuf_nfsb(sc->mp, XFS_DATA_FORK),
 			.owner		= I_INO(sc->ip),
 		};
 
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -649,6 +649,19 @@ xrep_tempexch_prep_request(
 	return 0;
 }
 
+static inline unsigned int
+xrep_tempexch_estimate_sf_resblks(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	/* repairing a symlink target */
+	if (S_ISLNK(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
+		return 1;
+
+	/* everything else is a directory or an xattr structure */
+	return xfs_dabuf_nfsb(sc->mp, whichfork);
+}
+
 /*
  * Fill out the mapping exchange resource estimation structures in preparation
  * for exchanging the contents of a metadata file that we've rebuilt in the
@@ -663,6 +676,8 @@ xrep_tempexch_estimate(
 	struct xfs_ifork	*ifp;
 	struct xfs_ifork	*tifp;
 	int			whichfork = xfs_exchmaps_reqfork(req);
+	unsigned int		sf_resblks =
+		xrep_tempexch_estimate_sf_resblks(sc, whichfork);
 	int			state = 0;
 
 	/*
@@ -693,9 +708,9 @@ xrep_tempexch_estimate(
 		 * plus the block we converted.
 		 */
 		req->ip1_bcount = sc->tempip->i_nblocks;
-		req->ip2_bcount = 1;
+		req->ip2_bcount = sf_resblks;
 		req->nr_exchanges = 1 + tifp->if_nextents;
-		req->resblks = 1;
+		req->resblks = sf_resblks;
 		break;
 	case 2:
 		/*
@@ -707,10 +722,10 @@ xrep_tempexch_estimate(
 		 * is (worst case) the extent count of the file being repaired
 		 * plus the block we converted.
 		 */
-		req->ip1_bcount = 1;
+		req->ip1_bcount = sf_resblks;
 		req->ip2_bcount = sc->ip->i_nblocks;
 		req->nr_exchanges = 1 + ifp->if_nextents;
-		req->resblks = 1;
+		req->resblks = sf_resblks;
 		break;
 	case 3:
 		/*
@@ -722,10 +737,10 @@ xrep_tempexch_estimate(
 		 * fileoff 0.  Presumably, the caller could not exchange the
 		 * two inode fork areas directly.
 		 */
-		req->ip1_bcount = 1;
-		req->ip2_bcount = 1;
+		req->ip1_bcount = sf_resblks;
+		req->ip2_bcount = sf_resblks;
 		req->nr_exchanges = 1;
-		req->resblks = 2;
+		req->resblks = 2 * sf_resblks;
 		break;
 	}
 


