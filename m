Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAC03212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF959C4339B;
	Tue,  7 Feb 2023 13:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774950;
	bh=9551nfSjoAQUelc5g87KgOc0DOK8kmWO0QAwaI8l6ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQrHnNZCqSQ8VTxGkbd18u6S4LUhb731w/MtTYgafPCy+9LyaDPEI9cp1aDSHM+hu
	 Gz6jo+1gEwwTl28qiPjQtfuBtRvBFAY3rFWOxh1Rca58uvnQlmmv+1X+t6wEWaBDIq
	 nc6gVgngt5plhDQ686AZKnb0RnkisFyOceXyfNLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 6.1 050/208] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Tue,  7 Feb 2023 13:55:04 +0100
Message-Id: <20230207125636.535523454@linuxfoundation.org>
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

[ Upstream commit b600de2d7d3a16f9007fad1bdae82a3951a26af2 ]

After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
bic->bfqq will be freed, and bic_set_bfqq() is called with the freed
bic->bfqq.

Fix the problem by always freeing bfqq after bic_set_bfqq().

Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230130014136.591038-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index dfb6d1d8bd46..60b4299bec8e 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -761,8 +761,8 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 * request from the old cgroup.
 				 */
 				bfq_put_cooperator(sync_bfqq);
-				bfq_release_process_ref(bfqd, sync_bfqq);
 				bic_set_bfqq(bic, NULL, true);
+				bfq_release_process_ref(bfqd, sync_bfqq);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 917939b60ef8..ff9d23889415 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5491,9 +5491,11 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		bfq_release_process_ref(bfqd, bfqq);
+		struct bfq_queue *old_bfqq = bfqq;
+
 		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
+		bfq_release_process_ref(bfqd, old_bfqq);
 	}
 
 	bfqq = bic_to_bfqq(bic, true);
-- 
2.39.0



