Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4701F15574C;
	Thu,  5 Sep 2024 09:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530314; cv=none; b=o8Famjst84mydixRhFrn67PIU7gWyNj0g2n0RfHjj9FRyCG8Abvni4joH7WTet5YACu9YFo0fTuysJKTGkAzwYeqePo9n1zr13Bn0BRc8T15iJtnUCFZsMB53WytInD1TtkLMXPIlRn/J7xBiheNuHp1i16bmBudHhbwCimvSrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530314; c=relaxed/simple;
	bh=cbzyQ8d69isIHtAU3JHD8SUTMLHjgiul7+DrN2gx8c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9ht0xPvqQM+uCDhrrBoBP0erMVPmMolda7abm7RfQMCYUwEGXPufgMpOsikr/QWfHYclEuSK/QV8DFOKFSC+gtWVk6on71vrB8jLtn9EDM95VjGBdQm4fl2uHIuMZrudwvr4VN2Zp1317+lG0P3KaRaHs/3gFsh/LzF96W7Gyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPzsLNIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPzsLNIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DF8C4CEC6;
	Thu,  5 Sep 2024 09:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530314;
	bh=cbzyQ8d69isIHtAU3JHD8SUTMLHjgiul7+DrN2gx8c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPzsLNIT+P8ufd4L3hapvNAbdonD1/EOZuk/0CTAZfF+lnm0Z2Z7P5qpS3Tad4rMn
	 crdgpBcKSIrtP1jpcEnVpDAwtEJd0/L5T08gLffGWnK52GxFBN32hCQOiXFF3KyWDY
	 XGbYWvge4lAMY17Ck/UwaohMAfCk9a1y/IOM6AH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/132] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Thu,  5 Sep 2024 11:41:46 +0200
Message-ID: <20240905093726.848723868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit e8bc14d116aeac8f0f133ec8d249acf4e0658da7 ]

Now that there are no indirect calls for PI processing there is no
way to dereference a NULL pointer here.  Additionally drivers now always
freeze the queue (or in case of stacking drivers use their internal
equivalent) around changing the integrity profile.

This is effectively a revert of commit 3df49967f6f1 ("block: flush the
integrity workqueue in blk_integrity_unregister").

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240613084839.1044015-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index d4e9b4556d14..5276c556a9df 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -396,8 +396,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->profile)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0



