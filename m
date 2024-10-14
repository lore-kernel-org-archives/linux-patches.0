Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E99D1AB508;
	Mon, 14 Oct 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918730; cv=none; b=lmpRPBjgFr5D21bjiDyF75foeockZpsxVWGH4dS8OovYyB5SMoa19zCqU8ghQHoAmJSZItQDaqk6nubmVXEs4PKwCQDOLynBeKlopJfP1p7MA5Ruv1lbxZIWwPVHMuM014ZgPV1YJht29fo8qsaw14QrvKVZXodW5wCP4zRI+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918730; c=relaxed/simple;
	bh=BN9Qh78EBjBq+RF+eNEEPf6COAkeEUiKSy6er3Udz/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqiWpUAPZ8I5UJdFKLmuHJFftbM2Gwmr7DiGCfw5hXbVzBiH1LtZTjx2lwi8SNy4WJB508/OucRVDisULJXa3LW8IhPn70ZcpJXhFkPGSyWrPEAfxRauPRVW4oqv1CCHsIaxxqK9CJ7S9eUwt0mlMBHc1s9wFNB+EkQQJSoqpIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY/O14yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY/O14yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC67DC4CEC7;
	Mon, 14 Oct 2024 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918730;
	bh=BN9Qh78EBjBq+RF+eNEEPf6COAkeEUiKSy6er3Udz/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY/O14yq9VUCbXKiAxHvTOMyH72AzuLaiXMsziedEPxj9tysZ9SS9fKTj0aC6At83
	 DPWRXuYpoIYvLQEJWHfWG9ynNbpOefSfK2vnjZypQtgm0J0wI8YmSniPLwyQTqGoDZ
	 qNIB/0xFRTvhv1LrP68WQ2n1jZPeIIvBgAP3I0Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/798] loop: dont set QUEUE_FLAG_NOMERGES
Date: Mon, 14 Oct 2024 16:16:01 +0200
Message-ID: <20241014141233.937039841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 12ff6f58b8a90..041d307a2f280 100644
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
@@ -2034,14 +2031,6 @@ static int loop_add(int i)
 
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



