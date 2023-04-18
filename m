Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D9E2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D03AC433EF;
	Tue, 18 Apr 2023 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821098;
	bh=Lz3GAtyXVPEQvG2nqpcKXPNTuSgCGbOgBffa78fP7A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPacQMvUPg10jyppeuhrq4xJ7HyEs2B2aCcWdbZjOeKjJ7hf5GHmYnjJOqg3M0l1X
	 GnDkbkTuLGlyNRuQVC8ieR3mOiSJ65fAdOlBL8/Y+1sfQMwRNCwYzAE6OcozDuv10J
	 hJ3DBO6C8XiPaSWHShxtqDAKrO8CK0kdDy8W76DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 90/92] xfs: consider shutdown in bmapbt cursor delete assert
Date: Tue, 18 Apr 2023 14:22:05 +0200
Message-Id: <20230418120307.935687569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Foster <bfoster@redhat.com>

commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.

[ Slightly modify fs/xfs/libxfs/xfs_btree.c to resolve merge conflicts ]

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -354,20 +354,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -375,15 +372,10 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
+
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_private.b.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+	       cur->bc_private.b.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	kmem_zone_free(xfs_btree_cur_zone, cur);
 }
 


