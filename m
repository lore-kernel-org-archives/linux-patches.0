Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6ED2882CE;
	Tue, 12 Aug 2025 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025349; cv=none; b=MfYxsqSz5h+2w6YHRMeDeJV9x8AfEoF7x1mgKKFyPkYEiwYnU+wiug3vFSKWySY/hPDJ7KEk+9kGemcA1P8dbcFIynKuxeyhjntHynDYC2D1QkNYsodZCF1B3ZoivPjs9QZCjUxl8MSkcrVvfwLMxnFgWMYpknRvrQEFWeZZtao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025349; c=relaxed/simple;
	bh=wsYnFEuHI9R8AEHkegVq7i/6mI2efz+W+l3Va7sBy4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1q07rMLVjmu2PkQPjpQ6p9QBZBSTiP5T5FZ5jUM0nDf7n2AZOe653ZMAIqsifcnQE758emv0r356CDtjte5P/zgkAgOEywawWKzE6mIgHNXdPV9zxUjlk8kn4BaJlv0zi6lThw+bUoBim6QRCFKKTZkPB8OcNQv2IC3wxRrgQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtZEUAiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtZEUAiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA3C4CEF0;
	Tue, 12 Aug 2025 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025348;
	bh=wsYnFEuHI9R8AEHkegVq7i/6mI2efz+W+l3Va7sBy4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtZEUAiWXxmmTfLWZJnGnZAfzxBsfoUPlSgZ1yTQt5nBzHTEx9QbsYSJkP2xCKuuB
	 1BPnfkaHAB+YZHtn/Q36Nh00UuWXQ9IRxFtbYQMoK4/5tAco5gDMRYsKtB1Nm1SB5q
	 HI99qVTBfZBduyXNWrzpQRu/yFmyEQlb2OW1T+lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 016/480] ublk: use vmalloc for ublk_devices __queues
Date: Tue, 12 Aug 2025 19:43:44 +0200
Message-ID: <20250812174357.978619500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit c2f48453b7806d41f5a3270f206a5cd5640ed207 ]

struct ublk_device's __queues points to an allocation with up to
UBLK_MAX_NR_QUEUES (4096) queues, each of which have:
- struct ublk_queue (48 bytes)
- Tail array of up to UBLK_MAX_QUEUE_DEPTH (4096) struct ublk_io's,
  32 bytes each
This means the full allocation can exceed 512 MB, which may well be
impossible to service with contiguous physical pages. Switch to
kvcalloc() and kvfree(), since there is no need for physically
contiguous memory.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250620151008.3976463-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0e017eae97fb..066231e66f03 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2373,7 +2373,7 @@ static void ublk_deinit_queues(struct ublk_device *ub)
 
 	for (i = 0; i < nr_queues; i++)
 		ublk_deinit_queue(ub, i);
-	kfree(ub->__queues);
+	kvfree(ub->__queues);
 }
 
 static int ublk_init_queues(struct ublk_device *ub)
@@ -2384,7 +2384,7 @@ static int ublk_init_queues(struct ublk_device *ub)
 	int i, ret = -ENOMEM;
 
 	ub->queue_size = ubq_size;
-	ub->__queues = kcalloc(nr_queues, ubq_size, GFP_KERNEL);
+	ub->__queues = kvcalloc(nr_queues, ubq_size, GFP_KERNEL);
 	if (!ub->__queues)
 		return ret;
 
-- 
2.39.5



