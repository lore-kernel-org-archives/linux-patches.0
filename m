Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037294;
	b=AUmmWE5QAIZ6p5mqRvS59ZKm3yC0ZlwFgGHz1mSHTFVjbsHu284wWkp9Zuf00fByxnXW
	 GcislWvoncinGXjk561ZqAQdzPMpY6GmKj0mARc+WRulYirsJZoEDuJy6f3X0fn3FTIfO
	 VNwYKoNsqanDFULGgmyDofmWRDtMLGXiCZgXEBvEnEcwUddaXjnNU/kCwVQ5YXfEeBx7o
	 N2RDtRMp8yzH4kfdcUZ6NP5JwckJQUW8cBZ4EpD1ukJEiLZbuID9TifY3r7fHIA6LKc0+
	 Teu2GGjovLvGh1K5sULtQXTxIwURmtJO45B41/zWY+p7jz3nnzbIzlsri283IXZstsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7taMNCvnuC30+Zh62uv7bCs+ERmhHdcAXa5j3ih2w7U=;
	b=Xd+WFICBtjZh3MebA6wv3CbRpSCtBy7ksQBjDp3GGb6mJ/B5DomK4Dv76mvGRov86nfy
	 vcmbo29iDCOvYphxod9yddksuWA0uzB2TPiEqKIXgnTNZIOSTLs3G7BeaIbNayh6/Wwkw
	 oeM8rFs5mD3BnSv3xvps4OvR89L9CN4HoBJGAEyx3McRji5qWWv79ZxtDDG71vCWqLoRh
	 g4GcuQ2ptpo/bQwI5u36sovuUOVuzSfsfJAjEoz3AiAHze5eQ5Lsbid0/4tcW+62Uv1US
	 7stZXbcv3Wm+v81jk1zoXNdJi0jFylF0SJr/Op85W6QT/TO6MAZ7U7meerJZ0JHL7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lTH5I8gq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E7606A31C;
	Wed, 18 Nov 2026 21:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lTH5I8gq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665CA1F000C4;
	Wed, 18 Nov 2026 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037294;
	bh=7taMNCvnuC30+Zh62uv7bCs+ERmhHdcAXa5j3ih2w7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTH5I8gqUMEOzPUPeOp9hIPDEj3KC++ykEhmFl58TUrwnNQHLIvWsQhqywDtEqa34
	 iHg4RBU9rbTnMUMDaE7sk4SdsEZFpUoiHyH1SzEturVVMCuPKUO7swG5dyTqLKznjN
	 Zq6kxLjPqpFr1EKirquF/nPwNxE2eZYqn36i5RnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1356/3318] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed, 18 Nov 2026 15:32:58 +0100
Message-ID: <20261118150401.114890069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted quota repair changes because quota repair support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5671c81534335..a2eb19ef72218 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -109,21 +109,21 @@ xchk_quota_item(
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



