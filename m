Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFB324EF62;
	Mon, 24 Feb 2025 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407833; cv=none; b=VpMaqxibNqe8XbkyNOqbPplB8Kb9qoF4c31TJldMO23BwyzkKNHMNJUBOGwP81XaqmQxKyAzUr8yWnK0VOdZQqPMhsi5sfAc11ur9ZOmYJlqVtVgv/EP8RjVQsebhcPSfcBwDHPRHA3igjdkv13W0Z317S2m2Tddb58xfADGACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407833; c=relaxed/simple;
	bh=+HFCLuVqoyAcc1QqGS+nZX41lencjJX6ayIKLb5LPX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQv7Vcini7nzLo7tuj2xdIKdPOFv17ItLtGw8/4LLijtoNEISzCf8jwnmg3n0MUnhW4V1uDoo2uZ3CQLV1yv9Q/prFYpyf0yJanJPBhqy5dXJ9q6ISbDVJmNzzXaRYkqbPSn9mPYgGcwaS9PmB6hwA3z/rPpkxnWclCCIz9pa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8AkHI3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8AkHI3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D5AC4CED6;
	Mon, 24 Feb 2025 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407833;
	bh=+HFCLuVqoyAcc1QqGS+nZX41lencjJX6ayIKLb5LPX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8AkHI3BF6grQoQuXm+5E9vYfW/Bxg4LoAUXlirjNFzGynY7G5T4+ozsgC02vsK2u
	 kZBLGFVM2ZgU0nF2GxZ1PlrF+p6VtAH3Yy3X2CNk6dslL/nWf7WDokCpHH7ZMQXwtD
	 UmQynz57Ws/N1Ve3xOIlNjCwiKlwrRFYeotUnpMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.6 022/140] xfs: update the pag for the last AG at recovery time
Date: Mon, 24 Feb 2025 15:33:41 +0100
Message-ID: <20250224142603.876690896@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 4a201dcfa1ff0dcfe4348c40f3ad8bd68b97eb6c upstream.

Currently log recovery never updates the in-core perag values for the
last allocation group when they were grown by growfs.  This leads to
btree record validation failures for the alloc, ialloc or finotbt
trees if a transaction references this new space.

Found by Brian's new growfs recovery stress test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c        |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |    1 +
 fs/xfs/xfs_buf_item_recover.c |   19 ++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -358,6 +358,23 @@ xfs_free_unused_perag_range(
 }
 
 int
+xfs_update_last_ag_size(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		prev_agcount)
+{
+	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
+
+	if (!pag)
+		return -EFSCORRUPTED;
+	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
+	xfs_perag_rele(pag);
+	return 0;
+}
+
+int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		old_agcount,
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -140,6 +140,7 @@ int xfs_initialize_perag(struct xfs_moun
 		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
+int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -708,6 +708,11 @@ xlog_recover_do_primary_sb_buffer(
 
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 
+	if (orig_agcount == 0) {
+		xfs_alert(mp, "Trying to grow file system without AGs");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Update the in-core super block from the freshly recovered on-disk one.
 	 */
@@ -719,14 +724,22 @@ xlog_recover_do_primary_sb_buffer(
 	}
 
 	/*
+	 * Growfs can also grow the last existing AG.  In this case we also need
+	 * to update the length in the in-core perag structure and values
+	 * depending on it.
+	 */
+	error = xfs_update_last_ag_size(mp, orig_agcount);
+	if (error)
+		return error;
+
+	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
 	 * Because of the latter this also needs to happen if the agcount did
 	 * not change.
 	 */
-	error = xfs_initialize_perag(mp, orig_agcount,
-			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
 		return error;


