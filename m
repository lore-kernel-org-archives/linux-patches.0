Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585513;
	b=sO+uvrecz17NwcCMx5BNRk941BVX0vGPRLzKrx46EssYPjsMVRStup8eq2hTjyR4ljx6
	 AdVY3PE5now45EujaUh0kG11sF7AZaYoBXuiD0tQEinFS7t0tyZZ4s6/QRvDKwBQ/j0jh
	 JtLe121A2Z/6a14nbp0mxO8CYkTosVobywvSyv/pv/szR2Kx5PPUBl/gry2h4IRF2xIPM
	 riY9NuEKhX7VW5cpkOd/fb6vv9JQjGISydKjhJC5BYfCWUIg1njsWlAvtHTUyV7v9hTcU
	 0AfjA86z1dG3QNPl/1bmyRDj7qjdQljYPQ/OJt5RldOhWkyh22qT3dHGJuSHrq91ovQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yS62f37oOVWvVQOvFwmkuP3ARS0TWSRaB/BstsbmwCE=;
	b=40H0ODBgQ5wvEyttPwefCV48twONYpaaTpxU3BJGiqzXDDJ/ajxF8t8+oZhJ9CrrFDIP
	 P2EyALu0xN6vYv2n2DmqVeChfSyei27y42w16ddOk1kgEnkCvmiPnvdq3pF4lkPY2oiQq
	 Nrtu52PqVsNIbUPAigrehfYwJLAbgCa62lMT+XFAAALaTJKEKtTY7jVOUCOebLBX5m55i
	 U++y5+VGez4zp4n9k7BbjPqzg8T4xuEp3RC1pCvngX15+yYN1MAPeTNErJLX4txvNRcnW
	 hT07jsoiMmTjUEH1ItuSIx8JYcBLzc1+IlqT6ikcR6z3VO0a0Yatz7rGHDLwGnM1rAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OT7gwnf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71509606A33F;
	Fri, 13 Nov 2026 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OT7gwnf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6FC1F000C4;
	Fri, 13 Nov 2026 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585513;
	bh=yS62f37oOVWvVQOvFwmkuP3ARS0TWSRaB/BstsbmwCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OT7gwnf9eMTcBX10fU4VZUKMqR084zPa+EDVDNnFtq1IqTChfYm0QOSChGTA2ENUS
	 qwJqDO35gsCYB+e1dE4oAvYif4iiPA5XRUpSqpefJWTAtqhk2ObXrXsbPYLEoLj+Cl
	 x6pWHYhIn39FckC06A0gLnc7M281+a91y21v3ZEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 159/507] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:47:43 -0500
Message-ID: <20261113153759.890830542@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8120f136af931..cdf660344c281 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -200,12 +200,12 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->restart_bno == NULLAGBLOCK) {
-		/* first time through a by-len starts with max length */
-		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
-		/* nth time through a by-len starts where we left off */
+		/*
+		 * A by-len walk starts at the last record of the longest
+		 * length (restart_bno is NULLAGBLOCK until the first batch
+		 * ends) and then where the previous batch stopped.
+		 */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
 					    tcur->count, &i);
-- 
2.53.0



