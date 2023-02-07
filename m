Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A83212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79762C433D2;
	Tue,  7 Feb 2023 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774839;
	bh=1fAa6k1mwQRSnOZe31Kzo8oKONdjGcfLHZhM9nThEpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eX4O693kYgkLIHoGar1da3IeGyJKqeXhD/ihfLU/WVAMeDHWANfXQ0ia4qFjN6Fg+
	 t+gwH2lMkEI7Bwt+8MdA3xquqA/SvuBZualt7KS8Rg1U7SFCmr47QqCaw3XtMnY6F4
	 6zj02/vDZyNfhCDI9alYar4dDhIPraKKytugaR30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/208] block, bfq: replace 0/1 with false/true in bic apis
Date: Tue,  7 Feb 2023 13:55:03 +0100
Message-Id: <20230207125636.502515863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 337366e02b370d2800110fbc99940f6ddddcbdfa ]

Just to make the code a litter cleaner, there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221214033155.3455754-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b600de2d7d3a ("block, bfq: fix uaf for bfqq in bic_set_bfqq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  | 8 ++++----
 block/bfq-iosched.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 7d624a3a3f0f..dfb6d1d8bd46 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -718,15 +718,15 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				     struct bfq_io_cq *bic,
 				     struct bfq_group *bfqg)
 {
-	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
-	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
+	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, false);
+	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, true);
 	struct bfq_entity *entity;
 
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
 		if (entity->sched_data != &bfqg->sched_data) {
-			bic_set_bfqq(bic, NULL, 0);
+			bic_set_bfqq(bic, NULL, false);
 			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
@@ -762,7 +762,7 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 */
 				bfq_put_cooperator(sync_bfqq);
 				bfq_release_process_ref(bfqd, sync_bfqq);
-				bic_set_bfqq(bic, NULL, 1);
+				bic_set_bfqq(bic, NULL, true);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7b894df32e32..917939b60ef8 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3180,7 +3180,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	/*
 	 * Merge queues (that is, let bic redirect its requests to new_bfqq)
 	 */
-	bic_set_bfqq(bic, new_bfqq, 1);
+	bic_set_bfqq(bic, new_bfqq, true);
 	bfq_mark_bfqq_coop(new_bfqq);
 	/*
 	 * new_bfqq now belongs to at least two bics (it is a shared queue):
@@ -6627,7 +6627,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 		return bfqq;
 	}
 
-	bic_set_bfqq(bic, NULL, 1);
+	bic_set_bfqq(bic, NULL, true);
 
 	bfq_put_cooperator(bfqq);
 
-- 
2.39.0



