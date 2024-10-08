Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CCD1CF297;
	Tue,  8 Oct 2024 12:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389667; cv=none; b=uWA2VBYcJm6iRfPglYVr/M/usf8g6tcQMQ1bPE9KhvRyjOF+m6avwfsAo5bsbDTfOwDCTcLXMnd77oneO17aWfEGyGB03Ks1Ns2dLpb2RFiJZJ08O0tPZfOf2NsIddoWNZWYIuYVjXRoS0wgJnPm88sSNgt83xt7xYx6kkxbC84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389667; c=relaxed/simple;
	bh=sofhwFYUmRs049iK8MkTYk28Yd7aOmWOL+SXs0heUNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXfd+PdJdNt7fybrq6sqrQmJtcPmcR9bZseTVGTS9Wy5bCjFo643M5rDtodwSluo36KHhd3euf7vzK/m72ldNGeN6n6VFnASr2GeMmVz/v5JYSL+tuSjzCQWcU+5l07jXBF5FYN7XnKM0HYmx47kgpY8rhdBtGIyOW07glS5wDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM9NuxPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM9NuxPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96874C4CEC7;
	Tue,  8 Oct 2024 12:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389667;
	bh=sofhwFYUmRs049iK8MkTYk28Yd7aOmWOL+SXs0heUNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM9NuxPdArhy412KVJhbgasaNUebSLY5OxIuUm8cBiUJ9CwhIoXqHgiqW3tCjPt9f
	 FZN9Slev49CH5fDOe5ahd1xSF5dXAzz848/Erg9nai+E7UEKu+WSk4Yx+bqmTHfiq+
	 SWgHJVAipg/KIV5pRlqv/HRjCklAkKY8GoFuIh08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 053/482] loop: dont set QUEUE_FLAG_NOMERGES
Date: Tue,  8 Oct 2024 14:01:56 +0200
Message-ID: <20241008115650.393159380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1153721bc7c25..41cfcf9efcfc5 100644
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
@@ -2059,14 +2056,6 @@ static int loop_add(int i)
 	}
 	lo->lo_queue = lo->lo_disk->queue;
 
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



