Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037300;
	b=PnfLd7f21CR+ZSuS9P0OSq1kD8TRM3jhyY7uloQVZlufrWhY1ptXB2Q3ikU8JzV66L6f
	 khz6sZ5x1S/LKGCXf60OJp3qlDMg5ky72W9gHr0RpPR808G8VX4DUcQGS7nlnWFsriL8C
	 vGrJFF5gKsNeOT0IGlcXZG8hykekNax0TLWGO2kSoaDEKCnDZBQxY9RMqAbP7SA0lMWzv
	 +rtuyk1Rty/BIQ5hDFSo/oVKT0nqOTqZodnBb6/OxNEbV686Qxngcx+vdrESHmxR/gbnF
	 Iad/SEct4dVXxR+0vvigxzkFoA46XFWAxcrTyrxUB1vG6Hhc3+bv1UJ6Jc2fv4dihXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+x4A89NaM9QDG7MrBiLVe10t7IoV43wX+stG2mG27g=;
	b=j5jaw4UwJsnuCmUs/zXwxUmYSHlSrA4OZmufnSZpBT8zu8ZpmU13T0nNueXJ/MzG9ujj
	 MrPNaWXcvyod0OK2C5imOJwiiUEc15uOWxyQom5tSkuNbaLxL/Y9TZo2+67cmSngssW1X
	 IRzIawQBW52dr6VXdpuyoZiGxMuHY2R+JO2nKpF8bnTI/x2z/3qqnvib5xZsjX7ef9fx6
	 csDyJ7D0TmJxOiF/nApLygEDKhlfWTWOISng8JQY5fiSfRLdDc7YKOve36v3D0y25tgCo
	 fbbWcfeoBOZLjSFD8IdU8Imxpsq2ZxhlJvmJtimcT655ibmvUeyZDwQWm3sQLcdiAdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb39NqkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01D606A31C;
	Wed, 18 Nov 2026 21:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb39NqkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C8D1F000C4;
	Wed, 18 Nov 2026 21:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037300;
	bh=s+x4A89NaM9QDG7MrBiLVe10t7IoV43wX+stG2mG27g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lb39NqkI6ET+A9hcCxAGFysCvyQUJADW3f3zzBCJMhhKmQqO6xHYRLyvk4Hvdt2c4
	 qVpZ3lOd5VU6Y4skQor/G6b/QO4ZA6/Zap/OIekR4iYccTMUzfNZsuyQuoBgh0KWGd
	 H71WFvPiZrD/y5aLUC+7tF/S+WshUXqcVH1/Jmaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1358/3318] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed, 18 Nov 2026 15:33:00 +0100
Message-ID: <20261118150401.183618119@linuxfoundation.org>
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

[ Upstream commit 47b1e941bb55f735d82ba2649412260da78b98f8 ]

LOLLM complains that percpu_counter_sum can return a negative number but
we instead misinterpret that into a huge unsigned value and do bad
things to fdblocks.  It shouldn't do that, so let's add a retry loop and
an attempt to freeze the filesystem to (hopefully) zero out the incore
delalloc counter.  It probably won't work, but at least failing the
repair beats doing the wrong thing.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: retained existing pag and agno declarations while omitting realtime-counter hunks because the delayed realtime counters are absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 9aca5c82a3c51..e8d90b674d944 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -299,7 +299,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
-	uint64_t		delayed;
+	int64_t			delayed;
 	xfs_agnumber_t		agno;
 	int			tries = 8;
 	int			error = 0;
@@ -362,6 +362,11 @@ xchk_fscount_aggregate_agcounts(
 	 * of the computation.
 	 */
 	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
 	fsc->fdblocks -= delayed;
 
 	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
-- 
2.53.0



