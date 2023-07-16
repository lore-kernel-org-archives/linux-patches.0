Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00888F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACB4C433C7;
	Sun, 16 Jul 2023 20:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538996;
	bh=k0TOuhxos0JrL/VOJne01SVXGH/erMui/Lzn2RLo0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAPPmht9IpLooesr2w7YBqYxg62S0K269d9C8VtNpKIRIwqAIEoaD8InIP9pBAl0E
	 im2kutERchQAuU2HCh9qUBqB1ylBSae82kM4rbhAKdJ97nkHu3odtuEHAOa6xXw2fc
	 DoHkLZJiscp1gaZRNaBqakxOW2O5+J5EuE50TY8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 650/800] md/raid10: fix the condition to call bio_end_io_acct()
Date: Sun, 16 Jul 2023 21:48:23 +0200
Message-ID: <20230716195004.212411239@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 9d11a52367d17..9d23963496194 100644
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



