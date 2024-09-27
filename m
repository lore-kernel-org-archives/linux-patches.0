Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE533C3C;
	Fri, 27 Sep 2024 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440359; cv=none; b=abrRvDWM/pkY0J7sfeQfged6CTLudcC7eDTfPpDSLzG4h4Z8RruOd9Q2AZsMv8R1PluNrwvMJ2/tfFxJicvu4zazT4+cEDXK39a1VQ1S5lO/t5EAse+dhQ2YJXTbJUN2JdSj4/hcqJZUw1QIA15388ecU2jNM3fx5arGChV743c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440359; c=relaxed/simple;
	bh=6VsPjgI5wi/eZFjQ5G6rXVqVdV/UcxKWbLVS2PTtUBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmAkCEb1NwGKe0qpdS2cxYHioNEyVXLbuqvhiHFrcCRb1gXQyI5OA+PHh3KxHEtOnVO9qk9AQVskNSqcHWwDEXXyTeQx0q8DKMF40Lp31PiarUaKLqybPwpHhEw/rdPR7K9iLzYnU+nKr+hWoAtgGdJshNQl7mXvwYpH6r69ijM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJb+mLBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJb+mLBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AD3C4CEC4;
	Fri, 27 Sep 2024 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440358;
	bh=6VsPjgI5wi/eZFjQ5G6rXVqVdV/UcxKWbLVS2PTtUBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJb+mLBFUMuwk6I+sQgbmgPLO8u1H3IznEf4fToh7C2i5uD+/VPcfhkaDB/ci5u9D
	 CZftYU1+bBxw+uDgzmmr4Cm7dDA7WcbE/kWIDYN2SEqJzupdiaKLFN6GQvPPH6puEq
	 tyDCfXzVspm8LSK6EjlrUjrkdrUc5I+l3OqpKk4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 53/73] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
Date: Fri, 27 Sep 2024 14:24:04 +0200
Message-ID: <20240927121722.061843050@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit f12b96683d6976a3a07fdf3323277c79dbe8f6ab ]

Alter the definition of i_prev_unlinked slightly to make it more obvious
when an inode with 0 link count is not part of the iunlink bucket lists
rooted in the AGI.  This distinction is necessary because it is not
sufficient to check inode.i_nlink to decide if an inode is on the
unlinked list.  Updates to i_nlink can happen while holding only
ILOCK_EXCL, but updates to an inode's position in the AGI unlinked list
(which happen after the nlink update) requires both ILOCK_EXCL and the
AGI buffer lock.

The next few patches will make it possible to reload an entire unlinked
bucket list when we're walking the inode table or performing handle
operations and need more than the ability to iget the last inode in the
chain.

The upcoming directory repair code also needs to be able to make this
distinction to decide if a zero link count directory should be moved to
the orphanage or allowed to inactivate.  An upcoming enhancement to the
online AGI fsck code will need this distinction to check and rebuild the
AGI unlinked buckets.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |    3 ++-
 fs/xfs/xfs_inode.h  |   20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -113,7 +113,7 @@ xfs_inode_alloc(
 	INIT_LIST_HEAD(&ip->i_ioend_list);
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 
 	return ip;
 }
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2015,6 +2015,7 @@ xfs_iunlink_insert_inode(
 	}
 
 	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
 	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
 }
 
@@ -2117,7 +2118,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
 	return error;
 }
 
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,8 +68,21 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 
-	/* unlinked list pointers */
+	/*
+	 * Unlinked list pointers.  These point to the next and previous inodes
+	 * in the AGI unlinked bucket list, respectively.  These fields can
+	 * only be updated with the AGI locked.
+	 *
+	 * i_next_unlinked caches di_next_unlinked.
+	 */
 	xfs_agino_t		i_next_unlinked;
+
+	/*
+	 * If the inode is not on an unlinked list, this field is zero.  If the
+	 * inode is the first element in an unlinked list, this field is
+	 * NULLAGINO.  Otherwise, i_prev_unlinked points to the previous inode
+	 * in the unlinked list.
+	 */
 	xfs_agino_t		i_prev_unlinked;
 
 	/* VFS inode */
@@ -81,6 +94,11 @@ typedef struct xfs_inode {
 	struct list_head	i_ioend_list;
 } xfs_inode_t;
 
+static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
+{
+	return ip->i_prev_unlinked != 0;
+}
+
 static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
 {
 	return ip->i_forkoff > 0;


