Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590052;
	b=C187jTVc4v6gjIlg1+NL214UWBE6eL2Mn7t6Qmk8fpxTumC4Hy7Cp36/DBV/J9RSM0JG
	 /WJ3zdbeSKI4QOm6NDbbSbcYYRkrxEznV7iJ14LE3GTOjx8hCCgDK7Godgoagmn4MsPlJ
	 vQmiec+nZX71IXvUx188Y8WWzlMpe/YTBzZ3x458Hg9+RojxfVNCRz+coib47h7QtfgHt
	 Qf03DpkBrpIouW4v14Qjcj+8unlOne/8rmqp9w/wQfb8tJIn+vEeHIAP+/WPM5CbBZCNq
	 5yRmOM/b10Vo/R8GVjXdx/ItziJOccFECjQ/ukBcO3W1eBhzLCz2bWgH+5dxh74Kipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oSKKDJoKGn7VUAvPK7WUQi4p4lolUKAKMOQLPMgr2c8=;
	b=b1UAiUbtwyHrfSqTa9zTrt7MGTrgSmgvM5Wnet9qrKCxgVsoeSWNpFInD7elcgt7eaNX
	 RS6Y4XumxlTLxaOkX8c5nITUMMJ3xTrbTqowYeZd3RRF6ZZSfX7hi3RF12z94sG+K7Ngl
	 /YRHeZE3pib9IxCptEvKeTotVR4TkOpQdVBINQYbsDJKkBNNOEQ0IkyXTGXA4T+WMfSEE
	 npsdzn4dVNt4p6mLRDPA4S5+xF1ScoCDWILZLUzcEK6cDqV7XZT3uDzmzTlts6LEZXUjU
	 /m4SmmNNCgYIXMBp5ovR3bg3MBUYZkGYrY9APNlagD6wT+dYUCC1bM/co62Y+MgEusg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b2uk/rpw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43648606A89A;
	Fri, 13 Nov 2026 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2uk/rpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E276F1F000C6;
	Fri, 13 Nov 2026 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590052;
	bh=oSKKDJoKGn7VUAvPK7WUQi4p4lolUKAKMOQLPMgr2c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2uk/rpweqpEQkss8OBFIav8378lzo9/1pTzSkw38uXfgOv/yVJ77ehA5dhHPCBb5
	 xzTYzxpjDLAfnoVC9ywVWxtZ85N+Gz+epNeLKOejTzA8CcIhFDkKVWra62N7Mj33uO
	 CplgvkdmcpyJejcvQBXzT6d/n99GC/AkOoJdCyRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/686] xfs: reinitialize dquot block if non-first dquot cant load
Date: Fri, 13 Nov 2026 10:43:37 -0500
Message-ID: <20261113153823.728781410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index baf77a158eac8..cf17d35b70cce 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -299,7 +299,6 @@ xrep_quota_block(
 	xfs_dqid_t		id)
 {
 	struct xfs_dqblk	*dqblk;
-	struct xfs_disk_dquot	*ddq;
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_def_quota	*defq = xfs_get_defquota(qi, dqtype);
 	struct xfs_buf		*bp = NULL;
@@ -321,14 +320,21 @@ xrep_quota_block(
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
@@ -341,7 +347,7 @@ xrep_quota_block(
 	dqblk = bp->b_addr;
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
-		ddq = &dqblk->dd_diskdq;
+		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
-- 
2.53.0



