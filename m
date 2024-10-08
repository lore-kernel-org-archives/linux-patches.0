Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636C11DED60;
	Tue,  8 Oct 2024 13:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393064; cv=none; b=UKryu0mrVmRnMJuLG1RKw0YU4YNxATpR6FREkXBk6RQqLANj6/HoMPog8XvajuMMIfO7SmD6D19/pLBWgy8Y2fJ/Y6RTl0gaom9ktrAf7ycYdVQwGMThu1OzxGJXFJk8KUe2UI1n9pxxgmB7AP5aYXXD8Eg1/yDAGy+wc3Scvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393064; c=relaxed/simple;
	bh=fvWklU6EeBtYvAH5Lgcmo7GAwGLxzzwewyFlT1eb6Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBzmXYqkvGQSGenSABNUwpNbVSlk5bZDNR+q7uCcsYz+FcIkX6HXdwjdKxXlrk16G99S99U8kJGCwrAZV3zYf/y2uO/HeQN22aSAnZt+NoC2okTRzoX8x6FCwNp/EVG28Re6q+1LA7XWhqK4b8AJhONafKx28bwLJr7uFDm41Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doQ+Jsqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doQ+Jsqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05F0C4CEC7;
	Tue,  8 Oct 2024 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393064;
	bh=fvWklU6EeBtYvAH5Lgcmo7GAwGLxzzwewyFlT1eb6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doQ+Jsqe2COgbqxOtmAFQH5nsAd9Ksz9Seff/tLiU+rjhAZpO5SOt40ytxy3GPnZ3
	 PHFiXeh02/fCAX1Vh3zknmG98LYXmesGi1nYfFrzoQGMS8J0M9UyRmtSSlE78bkRhb
	 cCmh/AL7GukOftSMvgXkmn4wkyquZENhs3mocun0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/386] loop: dont set QUEUE_FLAG_NOMERGES
Date: Tue,  8 Oct 2024 14:04:46 +0200
Message-ID: <20241008115631.090771300@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

[ Upstream commit 667ea36378cf7f669044b27871c496e1559c872a ]

QUEUE_FLAG_NOMERGES isn't really a driver interface, but a user tunable.
There also isn't any good reason to set it in the loop driver.

The original commit adding it (5b5e20f421c0b6d "block: loop: set
QUEUE_FLAG_NOMERGES for request queue of loop") claims that "It doesn't
make sense to enable merge because the I/O submitted to backing file is
handled page by page."  which of course isn't true for multi-page bvec
now, and it never has been for direct I/O, for which commit 40326d8a33d
("block/loop: allow request merge for directio mode") alredy disabled
the nomerges flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240627124926.512662-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 552f56a84a7eb..886c635990377 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -211,13 +211,10 @@ static void __loop_update_dio(struct loop_device *lo, bool dio)
 	if (lo->lo_state == Lo_bound)
 		blk_mq_freeze_queue(lo->lo_queue);
 	lo->use_dio = use_dio;
-	if (use_dio) {
-		blk_queue_flag_clear(QUEUE_FLAG_NOMERGES, lo->lo_queue);
+	if (use_dio)
 		lo->lo_flags |= LO_FLAGS_DIRECT_IO;
-	} else {
-		blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
+	else
 		lo->lo_flags &= ~LO_FLAGS_DIRECT_IO;
-	}
 	if (lo->lo_state == Lo_bound)
 		blk_mq_unfreeze_queue(lo->lo_queue);
 }
@@ -2038,14 +2035,6 @@ static int loop_add(int i)
 
 	blk_queue_max_hw_sectors(lo->lo_queue, BLK_DEF_MAX_SECTORS);
 
-	/*
-	 * By default, we do buffer IO, so it doesn't make sense to enable
-	 * merge because the I/O submitted to backing file is handled page by
-	 * page. For directio mode, merge does help to dispatch bigger request
-	 * to underlayer disk. We will enable merge once directio is enabled.
-	 */
-	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, lo->lo_queue);
-
 	/*
 	 * Disable partition scanning by default. The in-kernel partition
 	 * scanning can be requested individually per-device during its
-- 
2.43.0



