Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046091;
	b=yUKs1x4nftHMe89421Of5xGJkwe5iGs9PbwPGBhfXt+bSST9QQQ9uxQc1NW9+vhqE21k
	 j5Cu32J1snMJIG6j8qK89yNm7OLOStvuQiU0be4s/Lh2SO5KwZKmCZtrbbDrl06fDLcdY
	 2R9muiSLjDV6zZlAZqYp1ssSbjtk5AArXSnQFRU2WSGpMmsNZdJMp4YzLKBlJwZBZKjip
	 JMpjl6V67eFrEaCI5sfkWltZFFeynIo8UgvirWrfBTSXVSZyF2h3K/XcWcUO86bx7APvL
	 oVVsNLxKCiCWV5ntT1AIQjLfc6q4qGXci7W60GAehyYoG8fDhU1np7soljnIHEuww6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9VmsQSmJFeK9TKm6O5AX9ojvpGccywoeFeAFpbAdu8=;
	b=VLadY0INhV18l4NgQUXsqXcYdnBJWJveNgLdnXUnkQCbyEsIu9A4/K8IipuiKJ1AKZ/+
	 sAszZwYtmjHuZ++wq+HEbmsU2ERnBboWSf9Zf4+IDUbjQs767NeKUftrLrrwZHj7hOXmc
	 BnlasHavFaVyj9tEP1lRQbLdSBMANj3mr4YSBAwYCSbLocHp5/OLCwSfoGke8RHk2lFao
	 dM64V3COBW5vxjKCJMnJQvLC3NnkvgLW2PcWb7rrim7+4BTdv7DbVtuNtmkNtj7KGRCj9
	 nImNm/ZfgJ28ohbCr0LaDd4dyYHUCD32U3rkTwXI76WfD71qU2LXBXTiQfN7UPzKPyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUbB1GLN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF20F606A31C;
	Wed, 18 Nov 2026 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUbB1GLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4031F000C4;
	Wed, 18 Nov 2026 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046091;
	bh=O9VmsQSmJFeK9TKm6O5AX9ojvpGccywoeFeAFpbAdu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUbB1GLN4oM3Ud5AcRzLPKUnrNldNevBEOrB/gcQNTx0cT7LXYT7cXwn20ix6OP8O
	 Dxrqd2HReZGVbutVHxyncu+g+arY+aUMyDaf/g1+d7VXSXkQFaCRmtq1aDDwyV0cMg
	 ajz9niB+9VcZu9ekkwIkD+cbCkMf3uva+ctw9V3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1155/2857] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed, 18 Nov 2026 15:36:29 +0100
Message-ID: <20261118150243.172584288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 342c2e00b3a99099a7088f7b8c8f075670c603a9 ]

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: stable@vger.kernel.org # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: omitted the quota repair changes in xrep_quota_item() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 21b4c90068591..172cd3792afb9 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -102,21 +102,21 @@ xchk_quota_item(
 	 * suspect, which is why we flag it for review.
 	 *
 	 * Complain about corruption if the soft limit is greater than
-	 * the hard limit.
+	 * the hard limit and there's a hard limit set.
 	 */
 	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
-- 
2.53.0



