Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C359398B8A;
	Tue, 16 Dec 2025 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888590; cv=none; b=JCTQ0HMvKaqcX5nOtLk7PLp3rVZMhFTId9rYfKtUBLnXes3INsA/TWJyl1joCf4M6riKo5rNX9jVzVQ/x577SDySfoPAQVv82hTVEbEbYzv0OwXmg/1oHdcaU12AFYCOLiZZJDhk7rSSyvNhbuDUIclar8hk3uE/kBvxM4mlWkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888590; c=relaxed/simple;
	bh=8hAcI1XjLNVVtUgCA/8XlWmPbL4QeYAkDLFOLIHWeek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKmP6skeiaOGyP9QzQmSO4/jSfWbBh12CFNfGMMI9TC5P7Fr7jJEcI9b/gSmp4fkApCfoDTS8/Jt5hZF2wGhMvyPJtdXVbN9Glti8PJ2IwTBRxk4eovjBj7Ndw3YpyBzW60UahQetuIsoTjf4NztEXQ90bS9uuqmm2tIYwYBUGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwFz1aGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwFz1aGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C14C4CEF1;
	Tue, 16 Dec 2025 12:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888589;
	bh=8hAcI1XjLNVVtUgCA/8XlWmPbL4QeYAkDLFOLIHWeek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwFz1aGfDWLfLMMi1l16z00vBIwntNKkVhChawbTufi0ok8JaEqzqMP8S6itxt2rD
	 a6fCg/upSIRA2WSlg2m1ojl3F8/0XAsK1qPMVfW0DLnqL7nUwn5ZADbj0LEusdsePJ
	 rnXRwTmsY8A+6Lea4nDXpy6pswHaZLssdgC3wjkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/614] block: fix memory leak in __blkdev_issue_zero_pages
Date: Tue, 16 Dec 2025 12:15:29 +0100
Message-ID: <20251216111421.746131948@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit f7e3f852a42d7cd8f1af2c330d9d153e30c8adcf ]

Move the fatal signal check before bio_alloc() to prevent a memory
leak when BLKDEV_ZERO_KILLABLE is set and a fatal signal is pending.

Previously, the bio was allocated before checking for a fatal signal.
If a signal was pending, the code would break out of the loop without
freeing or chaining the just-allocated bio, causing a memory leak.

This matches the pattern already used in __blkdev_issue_write_zeroes()
where the signal check precedes the allocation.

Fixes: bf86bcdb4012 ("blk-lib: check for kill signal in ioctl BLKZEROOUT")
Reported-by: syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=527a7e48a3d3d315d862
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Tested-by: syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa0..352e3c0f8a7d7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -202,13 +202,13 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
 
-		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-
 		if ((flags & BLKDEV_ZERO_KILLABLE) &&
 		    fatal_signal_pending(current))
 			break;
 
+		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
+		bio->bi_iter.bi_sector = sector;
+
 		do {
 			unsigned int len;
 
-- 
2.51.0



