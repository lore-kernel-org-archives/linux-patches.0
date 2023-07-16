Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F178F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094AAC433C8;
	Sun, 16 Jul 2023 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540762;
	bh=jeR7zNMeiEkB8qBgww/lkVvvrZLakAhgmJ6UayelPv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL6fQT+d5GdRUjubTa+er29DUg51YkoIYp8MURU8d5MSRo44c+U//BISfw1jPvJFr
	 rXFFQbiAfRCgAsDQ3Ds/ZUkEkAhO4S14zIMNNK0sWrfh1dLldIsHp4xa1kFwH/8H0Y
	 vorTyPyVVEz8mM0gqVw+m4jA2rSEHN7WElZO2ewo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/591] md/raid10: fix the condition to call bio_end_io_acct()
Date: Sun, 16 Jul 2023 21:50:00 +0200
Message-ID: <20230716194935.828235246@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 125bfc7cd750e68c99f1d446e2c22abea08c237f ]

/sys/block/[device]/queue/iostats is used to control whether to count io
stat. Write 0 to it will clear queue_flags QUEUE_FLAG_IO_STAT which means
iostats is disabled. If we disable iostats and later endable it, the io
issued during this period will be counted incorrectly, inflight will be
decreased to -1.

  //T1 set iostats
  echo 0 > /sys/block/md0/queue/iostats
   clear QUEUE_FLAG_IO_STAT

			//T2 issue io
			if (QUEUE_FLAG_IO_STAT) -> false
			 bio_start_io_acct
			  inflight++

  echo 1 > /sys/block/md0/queue/iostats
   set QUEUE_FLAG_IO_STAT

					//T3 io end
					if (QUEUE_FLAG_IO_STAT) -> true
					 bio_end_io_acct
					  inflight--	-> -1

Also, if iostats is enabled while issuing io but disabled while io end,
inflight will never be decreased.

Fix it by checking start_time when io end. If start_time is not 0, call
bio_end_io_acct().

Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230609094320.2397604-1-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ea6228ff3bb5e..d2098fcd6a270 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -325,7 +325,7 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
-	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+	if (r10_bio->start_time)
 		bio_end_io_acct(bio, r10_bio->start_time);
 	bio_endio(bio);
 	/*
-- 
2.39.2



