Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585356;
	b=kbZNpUq7gNUddXZYUcE50c3vP5z1eoPwogA4HYXFGgu6lw1VTZaEdi4wf8qZNPxyjdEj
	 S9dA+eU2aOASkGGSkbqOigkwEu9g3BmwZ8rhF/zAle0lHTU9ImXalGlEmIvcS2CQh9V2B
	 d+JWB1wm8uz4gDYkWkidJ95pGsB32CMisDU10T5NPXWDKYnEg9/19P3QuxhGoNVIShTxE
	 8Alyls/wiS2IBK2+rJqyoSnSctJMLJB7KZc3oHtgEzRdq6zEJ3yW7PcH0x/QTy9tsT3D5
	 4canBMG9omXNbl8LV8eQCtSCLsIg6OgWMW81JHE0tIaspcFibtUE09yGi8Zp0W2IhIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H92F7EkA5zjG8oxcdjPYB9caPuDSxsmTMC+/HdJdj2w=;
	b=EIU37g089B3fjEz+2Fy3Am5jtAvVmrO9F/8lQh1LNNvXetE8jTt7ZgF9X6rtToUfECnj
	 i5kvodGLl5ct7wlSbrK0awCYpnsJ8V2qx4SY8DROTSQfgpao/1KiEmiC+jJQV5YxYX8pB
	 0PXlYpPFljHgKgOThU3/Y08VNF2ds1ZWoqg9U4ts/2ugtgKNW7teVF+xqhjKls76aqxVe
	 PBty/r6T4K0eChX6uXecrFenNikss9nF8yp8yQz/Q0TlwxAxQqULM1pXreihK39wzfXLH
	 p4DMTU1wRUD7R3zghH6wahvP5UzWJa0K9H5IHjyX3HAwj+7k667Rg0j/cXvzWsHWT1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7WzzNA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961DB606A8B0;
	Fri, 13 Nov 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7WzzNA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4106E1F00ADB;
	Fri, 13 Nov 2026 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585356;
	bh=H92F7EkA5zjG8oxcdjPYB9caPuDSxsmTMC+/HdJdj2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7WzzNA2P1ZlEGtAptiUygxvIx2NRjJMDAhDXOZioj+OBxCfgKxUnoa1jcz8TvCL7
	 OHO6iJ/InynwQHcxw3S2lhKn7zPpLs7K8cWza3k+eiRLBhrNiF0nIl4nJI+4kPQZ2m
	 sCnByRC2MZCXKBI62pk1Cx6FS7VRNQt0GAmw8Lb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 036/507] xfs: reinitialize dquot block if non-first dquot cant load
Date: Fri, 13 Nov 2026 10:45:40 -0500
Message-ID: <20261113153754.770000773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit faa9aa9e846332aaad78096a2cebfeafe68a7776 ]

LOLLM noticed that the early exit logic in xrep_quota_block is defective
because it only looks in the first ondisk dquot for corruption that
would prevent dquots from loading.  We need to scan all the dquots in
the block, not just the first one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 780212c8d810 ("xfs: forcibly reset quota timers when upgrading to bigtime during repair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota_repair.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index b4f33f432b12a..b6a270010b8b6 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -297,7 +297,6 @@ xrep_quota_block(
 	xfs_dqid_t		id)
 {
 	struct xfs_dqblk	*dqblk;
-	struct xfs_disk_dquot	*ddq;
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_def_quota	*defq = xfs_get_defquota(qi, dqtype);
 	struct xfs_buf		*bp = NULL;
@@ -319,14 +318,21 @@ xrep_quota_block(
 		break;
 	case 0:
 		dqblk = bp->b_addr;
-		ddq = &dqblk[0].dd_diskdq;
+		error = 0;
 
 		/*
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
-		    id == be32_to_cpu(ddq->d_id)) {
+		for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
+			struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+
+			if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+			    id + i != be32_to_cpu(ddq->d_id))
+				error++;
+		}
+
+		if (!error) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;
 		}
@@ -339,7 +345,7 @@ xrep_quota_block(
 	dqblk = bp->b_addr;
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
-		ddq = &dqblk->dd_diskdq;
+		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
-- 
2.53.0



