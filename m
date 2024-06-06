Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F1C1990B7;
	Thu,  6 Jun 2024 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683538; cv=none; b=IPT4UVwS0aF5ieEZoVx9P529lGx64bybElebL+mx1TyjDFknfGh1eLhbtFjLH5eARKF7x28OID/r2WNl7H00jRaAQy9R9CB9pp7v4I1jmhb1U3V0LrgskoLyu3r3s533UZ/cjTVu37ldQ/TIDAYbXTjMO0qLZro1TwRTRBtDLLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683538; c=relaxed/simple;
	bh=qCCpJ2AOCwL9L20BCFr0qr02C5XET9qRiEoxW3wx8iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWgW8Vp4G9qMvyYesEzFbSGSZsBv0AXIw3aoIpR97DStqw2DVdwl04ean51V75lgV755NBgmzG2ndPyP9h2nB0Qt92vjSfSLtO11FG49cPeVIOnigl8nKyrDzubJvBj+5qTzdRymQBtPGMt0H+6zoYAZly2qmER2NLejV2RhVuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcy1oqUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcy1oqUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96071C2BD10;
	Thu,  6 Jun 2024 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683538;
	bh=qCCpJ2AOCwL9L20BCFr0qr02C5XET9qRiEoxW3wx8iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcy1oqUU8FW3W1BcGko827mO8yx9+mbdrqFOCEUXTFsOTVbAGDBq3T01ZIGufIHIC
	 HS1xcGXXEQpLzs/rG/0ypjGJWBkYYPSIpUlzhmP0A8wtLiPRDn8Feh+QhCuUQWaEG5
	 RlAyhSIZjONr7z9G9ulF0At0d0U4nRq1wt3fZFPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 478/744] xfs: upgrade the extent counters in xfs_reflink_end_cow_extent later
Date: Thu,  6 Jun 2024 16:02:30 +0200
Message-ID: <20240606131747.793582150@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 99fb6b7ad1f2fb83d8df2c1382be63a1f50b1ae0 ]

Defer the extent counter size upgrade until we know we're going to
modify the extent mapping.  This also defers dirtying the transaction
and will allow us safely back out later in the function in later
changes.

Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc284664..2322d45ac5e78 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -750,14 +750,6 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
-			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error)
-		goto out_cancel;
-
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
@@ -786,6 +778,14 @@ xfs_reflink_end_cow_extent(
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
 	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
-- 
2.43.0



