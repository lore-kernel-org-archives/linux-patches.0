Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F411E507;
	Fri, 27 Sep 2024 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440383; cv=none; b=psZroH6e4hifJHgvw3wJDlvleTEziPGXe1Vf0rmJX7cK3SbH/zmm/cCZ/EJ+oh1Ie+PevG9efYGLvU+cdbxCXlbfWzYtNj2A2/oxGETD9aJSQW4APFbFCshXSfQrurd77Rrq6Kz5j1Az+TykxTs1u+4sz9UsOjhgsMi9FOsWRfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440383; c=relaxed/simple;
	bh=ZsFV+plJ5d4VtN7tBtYUc8y8D2NkgsLmnlOPWRzr1Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1dCjzX6zEvvOxbHU/66oIWI7l+59fcYY+gbMDpKFw6f/UskLsDDGBUQYFpR+b9+s7XAkn9I9YjsFA8X1bp6EFcdU0yCgAm/pmn9JpyjeaHhWrpHTrc/5tvzRjWhVFfiNHajE3Zobl62yVbOse5S1l/BwQWHVgqYxo6WaTF9i0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEwhP0vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEwhP0vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F68C4CEC4;
	Fri, 27 Sep 2024 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440383;
	bh=ZsFV+plJ5d4VtN7tBtYUc8y8D2NkgsLmnlOPWRzr1Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEwhP0vmp7JbetzSLRXe+sIZsR/8VZH6yB2eykf3H66Gm0xuUqAE4wJ4pWToQzefe
	 NYWYMQcYRDOOvt6ztomGhdonnn7o/69YT83Kw4tDkCmyijgrvJAlcd04EhSl0mHLXz
	 GZiqPXHUvQzfx/LQmNGgoNqaOBF56QblV3anaejA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 37/73] xfs: prefer free inodes at ENOSPC over chunk allocation
Date: Fri, 27 Sep 2024 14:23:48 +0200
Message-ID: <20240927121721.418832829@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f08f984c63e9980614ae3a0a574b31eaaef284b2 ]

When an XFS filesystem has free inodes in chunks already allocated
on disk, it will still allocate new inode chunks if the target AG
has no free inodes in it. Normally, this is a good idea as it
preserves locality of all the inodes in a given directory.

However, at ENOSPC this can lead to using the last few remaining
free filesystem blocks to allocate a new chunk when there are many,
many free inodes that could be allocated without consuming free
space. This results in speeding up the consumption of the last few
blocks and inode create operations then returning ENOSPC when there
free inodes available because we don't have enough block left in the
filesystem for directory creation reservations to proceed.

Hence when we are near ENOSPC, we should be attempting to preserve
the remaining blocks for directory block allocation rather than
using them for unnecessary inode chunk creation.

This particular behaviour is exposed by xfs/294, when it drives to
ENOSPC on empty file creation whilst there are still thousands of
free inodes available for allocation in other AGs in the filesystem.

Hence, when we are within 1% of ENOSPC, change the inode allocation
behaviour to prefer to use existing free inodes over allocating new
inode chunks, even though it results is poorer locality of the data
set. It is more important for the allocations to be space efficient
near ENOSPC than to have optimal locality for performance, so lets
modify the inode AG selection code to reflect that fact.

This allows generic/294 to not only pass with this allocator rework
patchset, but to increase the number of post-ENOSPC empty inode
allocations to from ~600 to ~9080 before we hit ENOSPC on the
directory create transaction reservation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1737,6 +1737,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
+	bool			low_space = false;
 	int			flags;
 	xfs_ino_t		ino;
 
@@ -1768,6 +1769,20 @@ xfs_dialloc(
 	}
 
 	/*
+	 * If we are near to ENOSPC, we want to prefer allocation from AGs that
+	 * have free inodes in them rather than use up free space allocating new
+	 * inode chunks. Hence we turn off allocation for the first non-blocking
+	 * pass through the AGs if we are near ENOSPC to consume free inodes
+	 * that we can immediately allocate, but then we allow allocation on the
+	 * second pass if we fail to find an AG with free inodes in it.
+	 */
+	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
+		ok_alloc = false;
+		low_space = true;
+	}
+
+	/*
 	 * Loop until we find an allocation group that either has free inodes
 	 * or in which we can allocate some inodes.  Iterate through the
 	 * allocation groups upward, wrapping at the end.
@@ -1795,6 +1810,8 @@ xfs_dialloc(
 				break;
 			}
 			flags = 0;
+			if (low_space)
+				ok_alloc = true;
 		}
 		xfs_perag_put(pag);
 	}


