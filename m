Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22271187331;
	Fri, 27 Sep 2024 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440356; cv=none; b=L/f3W0RLOzdky9PlLBLCZaGuluanFILOejxyJIXsgXQvujKpNqV9K5a6XhQsnI7/lHaxfoEFfwoXJENB2aWxJXuaJQNpzyfwLj8ahMlmoAjodbBrsciHtv1HQbHi3Dt9NeTRhK4SEso/o7mPonGrCzi0AA/03KILxcQSR1E+2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440356; c=relaxed/simple;
	bh=20WVRRzAz9JtmHFgVBUdNzSR3pTSDBak0/UPdpWqFu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=capoPn4TbO+6Kz0azx6uiTggVkNwyo9qYGgu5KI7thYNqEvZUkp6CcUaXvpSIhnQvpqHZx/zFPktioPbhhM/lDVfILlDPiAeaAFQPjsYSqotaPsdArmum5U0d7tdNjShooFZ8VU3ZoVdQE64jmcoUAxvBfc1wS3Dd6CxvX8zwYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE+xtFzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE+xtFzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F6CC4CEC4;
	Fri, 27 Sep 2024 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440356;
	bh=20WVRRzAz9JtmHFgVBUdNzSR3pTSDBak0/UPdpWqFu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE+xtFzjivVPZB+3jda4eprCeeCVpq5D2D1iwLxAjQ5u/eceuBFlRD/j+tXG3GbIa
	 anb6yge8wpOl+/eoIooT9vaosfopS0qMpErUnRrYX/+ftBTPyp98AKOBTaOrkFIp/o
	 zunc5fEwSCZ9FyCdotRd2LQWNcIDJWlLhtbXmRa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 52/73] xfs: correct calculation for agend and blockcount
Date: Fri, 27 Sep 2024 14:24:03 +0200
Message-ID: <20240927121722.020860390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit 3c90c01e49342b166e5c90ec2c85b220be15a20e ]

The agend should be "start + length - 1", then, blockcount should be
"end + 1 - start".  Correct 2 calculation mistakes.

Also, rename "agend" to "range_agend" because it's not the end of the AG
per se; it's the end of the dead region within an AG's agblock space.

Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -126,8 +126,8 @@ xfs_dax_notify_ddev_failure(
 		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
 		struct xfs_agf		*agf;
-		xfs_agblock_t		agend;
 		struct xfs_perag	*pag;
+		xfs_agblock_t		range_agend;
 
 		pag = xfs_perag_get(mp, agno);
 		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
@@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
 			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
 
 		agf = agf_bp->b_addr;
-		agend = min(be32_to_cpu(agf->agf_length),
+		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
 				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = agend - ri_low.rm_startblock;
+		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);


