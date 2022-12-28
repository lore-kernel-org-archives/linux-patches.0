Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05CB1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EB4C433EF;
	Wed, 28 Dec 2022 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241732;
	bh=BcKOSF9KUH7jqEHC5T+Ui9snrAEMXYhLeDuhHo/HnNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLLK75XBwDcsKnSUsagpO00D9bxcTQ0K9AV0t0PtUdxgTqsKLjxUx6gsDbcy1reKo
	 vKE4squd0Vm6+FYsQTXUPIrKNW0MMN9tLVdlSSZ7b8ia15rS+ZCM3QeybvawH+lGT5
	 DJFWS87lFAixMOjVVF2JwIQ68ieoV5pUOzeDiYQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khazhismel Kumykov <khazhy@google.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0306/1073] bfq: fix waker_bfqq inconsistency crash
Date: Wed, 28 Dec 2022 15:31:34 +0100
Message-Id: <20221228144336.321469973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Khazhismel Kumykov <khazhy@chromium.org>

[ Upstream commit a1795c2ccb1e4c49220d2a0d381540024d71647c ]

This fixes crashes in bfq_add_bfqq_busy due to waker_bfqq being NULL,
but woken_list_node still being hashed. This would happen when
bfq_init_rq() expects a brand new allocated queue to be returned from
bfq_get_bfqq_handle_split() and unconditionally updates waker_bfqq
without resetting woken_list_node. Since we can always return oom_bfqq
when attempting to allocate, we cannot assume waker_bfqq starts as NULL.

Avoid setting woken_bfqq for oom_bfqq entirely, as it's not useful.

Crashes would have a stacktrace like:
[160595.656560]  bfq_add_bfqq_busy+0x110/0x1ec
[160595.661142]  bfq_add_request+0x6bc/0x980
[160595.666602]  bfq_insert_request+0x8ec/0x1240
[160595.671762]  bfq_insert_requests+0x58/0x9c
[160595.676420]  blk_mq_sched_insert_request+0x11c/0x198
[160595.682107]  blk_mq_submit_bio+0x270/0x62c
[160595.686759]  __submit_bio_noacct_mq+0xec/0x178
[160595.691926]  submit_bio+0x120/0x184
[160595.695990]  ext4_mpage_readpages+0x77c/0x7c8
[160595.701026]  ext4_readpage+0x60/0xb0
[160595.705158]  filemap_read_page+0x54/0x114
[160595.711961]  filemap_fault+0x228/0x5f4
[160595.716272]  do_read_fault+0xe0/0x1f0
[160595.720487]  do_fault+0x40/0x1c8

Tested by injecting random failures into bfq_get_queue, crashes go away
completely.

Fixes: 8ef3fc3a043c ("block, bfq: make shared queues inherit wakers")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221108181030.1611703-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index c740b41fe0a4..68872a61706a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6786,6 +6786,12 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 				bfqq = bfq_get_bfqq_handle_split(bfqd, bic, bio,
 								 true, is_sync,
 								 NULL);
+				if (unlikely(bfqq == &bfqd->oom_bfqq))
+					bfqq_already_existing = true;
+			} else
+				bfqq_already_existing = true;
+
+			if (!bfqq_already_existing) {
 				bfqq->waker_bfqq = old_bfqq->waker_bfqq;
 				bfqq->tentative_waker_bfqq = NULL;
 
@@ -6799,8 +6805,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 				if (bfqq->waker_bfqq)
 					hlist_add_head(&bfqq->woken_list_node,
 						       &bfqq->waker_bfqq->woken_list);
-			} else
-				bfqq_already_existing = true;
+			}
 		}
 	}
 
-- 
2.35.1



