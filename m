Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8914B940;
	Thu, 23 May 2024 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470403; cv=none; b=qWED2uZEf7rggM+Zl0nztfG25bOz8IBDF9mXQVD+DBZaDiogKYI9bAwIEUoBGPQjQEantq/epFWp9xE2h9sUdOOraQ9nOfHG0XTEJnUxp4smZHDVUj5uBnhEQ5k1b5liPZ/VsQ87Tt4hDupS0/iAJsLKpgn0pt4jBExlRUt5juA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470403; c=relaxed/simple;
	bh=vASYo/Ei8QHhM/j6yWD7TK/zR3f3NB3I34y6O7O61Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpFn668wQgh8z+NQiv2m48zlgU+aDb8UMJ32aQAZL9XXlWPSPrDvTC9Bd7csyxjoVylMLhjqZbdNJ5fF89fiGYY/SuwfzA03PErF7Egi4glo04z4U3gM4RLwSE4mhgNozt3O1ugLOw8lg2G0X/jq+6hyruBrtmY0ECpkJcaC5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajeN29eN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajeN29eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B53C32782;
	Thu, 23 May 2024 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470403;
	bh=vASYo/Ei8QHhM/j6yWD7TK/zR3f3NB3I34y6O7O61Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajeN29eNxaynueoyWnjVyUNDnR1S3dMBN2c1ZxbP5xO/otmxpv5EzxzkJcNfk75Xk
	 yetf/CMKaR9MMLf8nVqQQsJct1rGXSdVjsbK3DngV+iAOsqxv1a9K+aXHmmbvhD+OX
	 MAUdc8ZXAAdCGC2KBFmLdaHms06UDMB/x3r7T88M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 24/45] xfs: attach dquots to inode before reading data/cow fork mappings
Date: Thu, 23 May 2024 15:13:15 +0200
Message-ID: <20240523130333.409174044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 4c6dbfd2756bd83a0085ed804e2bb7be9cc16bc5 ]

I've been running near-continuous integration testing of online fsck,
and I've noticed that once a day, one of the ARM VMs will fail the test
with out of order records in the data fork.

xfs/804 races fsstress with online scrub (aka scan but do not change
anything), so I think this might be a bug in the core xfs code.  This
also only seems to trigger if one runs the test for more than ~6 minutes
via TIME_FACTOR=13 or something.
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf

I added a debugging patch to the kernel to check the data fork extents
after taking the ILOCK, before dropping ILOCK, and before and after each
bmapping operation.  So far I've narrowed it down to the delalloc code
inserting a record in the wrong place in the iext tree:

xfs_bmap_add_extent_hole_delay, near line 2691:

	case 0:
		/*
		 * New allocation is not contiguous with another
		 * delayed allocation.
		 * Insert a new entry.
		 */
		oldlen = newlen = 0;
		xfs_iunlock_check_datafork(ip);		<-- ok here
		xfs_iext_insert(ip, icur, new, state);
		xfs_iunlock_check_datafork(ip);		<-- bad here
		break;
	}

I recorded the state of the data fork mappings and iext cursor state
when a corrupt data fork is detected immediately after the
xfs_bmap_add_extent_hole_delay call in xfs_bmapi_reserve_delalloc:

ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
    ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
    ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
    ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0

Here we see that a delalloc extent was inserted into the wrong position
in the iext leaf, same as all the other times.  The extra trace data I
collected are as follows:

ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
    ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
    ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
    ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
    ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
    ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
    ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
    ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
    ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00

The first line shows that xfs_bmapi_reserve_delalloc was called with
whichfork=XFS_DATA_FORK, off=0xe6, len=0x4, prealloc=6.

The second line ("oldgot") shows the contents of @got at the beginning
of the call, which are the results of the first iext lookup in
xfs_buffered_write_iomap_begin.

Line 3 ("crapgot") is the result of duplicating the cursor at the start
of the body of xfs_bmapi_reserve_delalloc and performing a fresh lookup
at @off.

Line 4 ("freshgot") is the result of a new xfs_iext_get_extent right
before the call to xfs_bmap_add_extent_hole_delay.  Totally garbage.

Line 5 ("nowgot") is contents of @got after the
xfs_bmap_add_extent_hole_delay call.

Line 6 is the contents of @icur at the beginning fo the call.  Lines 7-9
are the contents of the iext cursors at the point where the block
mappings were sampled.

I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
didn't find anything, so we filled in imap with "fake hole until the
end".  At the time of the first lookup, I suspect that there's only one
32-block unwritten extent in the mapping (hence oldicurpos==1) but by
the time we get to recording crapgot, crapicurpos==2.

Dave then added:

Ok, that's much simpler to reason about, and implies the smoke is
coming from xfs_buffered_write_iomap_begin() or
xfs_bmapi_reserve_delalloc(). I suspect the former - it does a lot
of stuff with the ILOCK_EXCL held.....

.... including calling xfs_qm_dqattach_locked().

xfs_buffered_write_iomap_begin
  ILOCK_EXCL
  look up icur
  xfs_qm_dqattach_locked
    xfs_qm_dqattach_one
      xfs_qm_dqget_inode
        dquot cache miss
        xfs_iunlock(ip, XFS_ILOCK_EXCL);
        error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
        xfs_ilock(ip, XFS_ILOCK_EXCL);
  ....
  xfs_bmapi_reserve_delalloc(icur)

Yup, that's what is letting the magic smoke out -
xfs_qm_dqattach_locked() can cycle the ILOCK. If that happens, we
can pass a stale icur to xfs_bmapi_reserve_delalloc() and it all
goes downhill from there.

Back to Darrick now:

So.  Fix this by moving the dqattach_locked call up before we take the
ILOCK, like all the other callers in that file.

Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -968,6 +968,10 @@ xfs_buffered_write_iomap_begin(
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -1071,10 +1075,6 @@ xfs_buffered_write_iomap_begin(
 			allocfork = XFS_COW_FORK;
 	}
 
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_unlock;
-
 	if (eof && offset + count > XFS_ISIZE(ip)) {
 		/*
 		 * Determine the initial size of the preallocation.


