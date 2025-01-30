Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E588BFF;
	Thu, 30 Jan 2025 14:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247484; cv=none; b=TZo9KrzhaMnlAjxvp7IZsKQH35Acusmzo2ACfENAbshHpehGEWryfnYItzYTwBjzh8q3CAp8DgGYiSGWv732l+GCMCcfqDsVv79rzlOdJkWjj50s5HptpGCDKX9tc/fzaBqVIuGblSDElX8BrxzFDBEnJHeF/5FJgepf0DDnkeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247484; c=relaxed/simple;
	bh=iSWflRQ7Q8OwwqCSaVFTsFGgO7Rn+ARO7NJlk90MzE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3Y5FqL/0z2PXI9nE4doJ8rEwOcFtkGs7CRoHnEX1ufKAz0RIrLKgfYRMbZtPYRa5zjvwJ2cClpe/qvSOIVsl6eYpOfcmovdRUc+S9gXyIviAA6w2rBOOrT+Pqc8NoS5MNP7qGweknowkQk4jq3KjIoRn3z+P3kgnx0aemoxXrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12O7Vw1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12O7Vw1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA5C4CED2;
	Thu, 30 Jan 2025 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247483;
	bh=iSWflRQ7Q8OwwqCSaVFTsFGgO7Rn+ARO7NJlk90MzE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12O7Vw1PXm4uitoUBoV0/aDlGEc67cZi6E4H7mOP+J5mYWaBnYTF+U3tWiAHrDCgc
	 mQjbcS9quxchELL0jyJRak0vLVTk/T9ZMCo9/LoyNDtGhn4jKwwKLgFZ3BY0zTjWlU
	 twLbiR2RYpAeunXprNO86ZCgJm2qUYV49gseghXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 27/49] xfs: clean up dqblk extraction
Date: Thu, 30 Jan 2025 15:02:03 +0100
Message-ID: <20250130140134.929409829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ed17f7da5f0c8b65b7b5f7c98beb0aadbc0546ee ]

Since the introduction of xfs_dqblk in V5, xfs really ought to find the
dqblk pointer from the dquot buffer, then compute the xfs_disk_dquot
pointer from the dqblk pointer.  Fix the open-coded xfs_buf_offset calls
and do the type checking in the correct order.

Note that this has made no practical difference since the start of the
xfs_disk_dquot is coincident with the start of the xfs_dqblk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c              |    5 +++--
 fs/xfs/xfs_dquot_item_recover.c |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -562,7 +562,8 @@ xfs_dquot_from_disk(
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+	struct xfs_dqblk	*dqb = xfs_buf_offset(bp, dqp->q_bufoffset);
+	struct xfs_disk_dquot	*ddqp = &dqb->dd_diskdq;
 
 	/*
 	 * Ensure that we got the type and ID we were looking for.
@@ -1250,7 +1251,7 @@ xfs_qm_dqflush(
 	}
 
 	/* Flush the incore dquot to the ondisk buffer. */
-	dqblk = bp->b_addr + dqp->q_bufoffset;
+	dqblk = xfs_buf_offset(bp, dqp->q_bufoffset);
 	xfs_dquot_to_disk(&dqblk->dd_diskdq, dqp);
 
 	/*
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -65,6 +65,7 @@ xlog_recover_dquot_commit_pass2(
 {
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
+	struct xfs_dqblk		*dqb;
 	struct xfs_disk_dquot		*ddq, *recddq;
 	struct xfs_dq_logformat		*dq_f;
 	xfs_failaddr_t			fa;
@@ -130,14 +131,14 @@ xlog_recover_dquot_commit_pass2(
 		return error;
 
 	ASSERT(bp);
-	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	dqb = xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = &dqb->dd_diskdq;
 
 	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
 	 * than the lsn of the transaction we are replaying.
 	 */
 	if (xfs_has_crc(mp)) {
-		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
 		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
 
 		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
@@ -147,7 +148,7 @@ xlog_recover_dquot_commit_pass2(
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 	if (xfs_has_crc(mp)) {
-		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
 


