Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590053;
	b=2YVY2GXMFqrw2x3AedOCoWBOn0ToWuX1xk0pD71ItpvIhhydfn2VmJHx0KOmAQ7CPQAY
	 Vp0k3BLYgAPR6c6ej3x3vMvgbi54+68ka6k5oJKQGZJhUvD92nQpvQDxErzXwAWwjekrB
	 WzxphTfp/ThjCI91xjrrPfwWMCfpMSntFvBIC4m2DTDzIuhIP04EFaC8eM+vJT9BQmfEm
	 l+euAQNwILsU8ycp0kYvvyD7U3wOczYsbzUlUUY1SKhtBsfhwtFzibyLG3V1Ob7l1yMOY
	 8u+i3tGDzvxyfL69oPTu0El0+Jsm+EKmMGy7Jf6pDim50Ls7UynQLBAh621sUALHEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdtyv+xzYENv3qblXz1ABfCYfYdyBIYA42aRqPxxpVQ=;
	b=vopjE6Gt2KSmyCgLPV3JEZKYXJ1lCvlxS7Vyktzx3wwGstUbi3wQggy8y4c1BhK6OReN
	 UVvd8zdd2kB8iYAPWuZGNSYn2uUn/+svMxB/aRZ7+Xt7hu7Ov+BtUNXgC72iZ50chPeVU
	 sEJ5rYVJjy3qM1VivHYXW6jAX2T9lWdMGD9E9buigrVVeRUeQAmzE4GzEavutW+lKSMFU
	 6Q9gRHIwlWSM03p36GNXd1ul14W2SAcAwTZKWGMkL+QNLgz0Kmu56MxZVSlZrco4CNiqn
	 HVa6QrRsFRkhoTp247r5vpgSCq/QxSmyx9s1k03XA3IUD6Xxe22ZdyKwxJPZKl0s+WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLvPZCwC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8646606A8AA;
	Fri, 13 Nov 2026 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLvPZCwC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2523A1F000C6;
	Fri, 13 Nov 2026 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590053;
	bh=kdtyv+xzYENv3qblXz1ABfCYfYdyBIYA42aRqPxxpVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLvPZCwCLdRxHf110GBQRa7T1+UTmdh7PvXDyApIvj7LtiNpQR5U4dn1yiFu1aaue
	 Z33sFNaU6fg0uJ1DUcFig2cxrnzXo3vpSh2eDJk4Jnpc58Z+HJsIdWRGN9Sc4RsZuZ
	 zu/BcpKoJ3O/7ZYTvNmURZh1+mHUxuWsQWj8YTuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/686] xfs: forcibly reset quota timers when upgrading to bigtime during repair
Date: Fri, 13 Nov 2026 10:43:38 -0500
Message-ID: <20261113153823.758182188@linuxfoundation.org>
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

[ Upstream commit 780212c8d8105eadb5f56b4c7aafb94937755582 ]

If we decide to upgrade a dquot to BIGTIME as part of repairing it, we
should zero out the timer fields so that they are re-evaluated and reset
in bigtime format instead of letting through whatever was in there
before.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota_repair.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index cf17d35b70cce..44806ce8c0bf4 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -348,6 +348,8 @@ xrep_quota_block(
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
 		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+		bool			was_bigtime =
+				!!(ddq->d_type & XFS_DQTYPE_BIGTIME);
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
@@ -356,8 +358,21 @@ xrep_quota_block(
 		ddq->d_type = dqtype;
 		ddq->d_id = cpu_to_be32(id + i);
 
-		if (xfs_has_bigtime(sc->mp) && ddq->d_id)
+		if (xfs_has_bigtime(sc->mp) && ddq->d_id) {
+			/*
+			 * If something was broken with this dquot and it was a
+			 * non-bigtime dquot, we'll grant everyone a fresh
+			 * grace period by zeroing the timer field rather than
+			 * try to interpret what might be garbage.
+			 */
+			if (!was_bigtime) {
+				ddq->d_btimer = 0;
+				ddq->d_itimer = 0;
+				ddq->d_rtbtimer = 0;
+			}
+
 			ddq->d_type |= XFS_DQTYPE_BIGTIME;
+		}
 
 		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_blk_softlimit,
 				ddq->d_bcount, &ddq->d_btimer,
-- 
2.53.0



