Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714FC3A2AE9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302671; cv=none; b=ggFbH7nIE5/DsWntPfUud/WuhDVpUzzDcNR9ssNChlyidzun4dOO/m000PfPrRjN8L+NnmuhY1Rql/BbzpViNxslIvnEoct7a3xmPS9lJowzOngZ/K/dEacs3BugH5/eKAEgs16Q9h4jTxxvqIKAOkAJAD40Zm7OuonkY7wQU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302671; c=relaxed/simple;
	bh=PyUxnUpIDVZ0ri3Hyil9ZT8xATzesu+FvyoCn/sCqDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUtlk/WH4dUj/U+TWMNCED1jux1RIoQZr3RkY5VNReH3OtF3LUKhMU3KMiJI59dw95PMW/vCua5h5yZ9lDow4z7j1q9YUSaqS/B5BLkHrpRxRGZpodo/UCNgYCdx5/eaa2J+KsTXQ50PBMdz5NzsGpERKKuCtQKQm2B1+Sdz0zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruLxJEKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruLxJEKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED6C116D0;
	Sat, 28 Feb 2026 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302671;
	bh=PyUxnUpIDVZ0ri3Hyil9ZT8xATzesu+FvyoCn/sCqDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruLxJEKbUZjkP1uGmgJAyaI9wtjVlSwsfBGz0z4465W5GOIIPyTx/xikRQt4OLHxL
	 JbNmX+S+q4hG3EcnMXv1BJ0c47oV+vax6PbiNCysYWnJRCmX7480IeZMhbpU83ISE4
	 oDHliHsy2lYNMQx+xJiQwwnRKr93A46wJraLPgLw699SlEe/qGGXYUUVxTSlBfn7C7
	 TPP2mSlWSskXfRC7r9x6XfuAMy9vA1vu/lIdCvAc/ohjBVyJ5VrennSTg/csocJrCR
	 GgTde669HybAJRBPhiF4CTJhpnk4NxGAucqO5GognwMY29vQ2CbhGclVFz46XSdRTv
	 jzZUdcrzRNDng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/147] iomap: fix submission side handling of completion side errors
Date: Sat, 28 Feb 2026 13:15:27 -0500
Message-ID: <20260228181736.1605592-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4ad357e39b2ecd5da7bcc7e840ee24d179593cd5 ]

The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
more bios when a completion already return an error.  Commit cfe057f7db1f
("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
"copied", which is very wrong given that we've already consumed that
range and submitted a bio for it.

Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8a49c0d3a7b46..d3aa7ddbd0774 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -267,9 +267,13 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 	do {
 		size_t n;
-		if (dio->error) {
-			iov_iter_revert(dio->submit.iter, copied);
-			copied = ret = 0;
+
+		/*
+		 * If completions already occurred and reported errors, give up now and
+		 * don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(dio->error))) {
+			ret = 0;
 			goto out;
 		}
 
-- 
2.51.0

