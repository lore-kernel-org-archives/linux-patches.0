Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B791FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ED0C433C8;
	Tue,  1 Aug 2023 09:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883154;
	bh=C8CPlToll0mO6Xsty4yPamI+ndE0Kmvq9Rp7Mpadweo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaTQwcstw3sYdDVZ1HuM9YOcSorNgH9w/fwbO0yBzpZ8OOK3GF4YtOpvD1rMwwASt
	 DQF5V4/rkOW7K9IPTKM+Ammew+bu2H5+40eb6bqNnGxj0GB2g+2SlaChBQCEzKvigx
	 CyVrUM8TQ2pzFrDujH4QfQcFz9GvcovviN3PixCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 135/239] ublk: fail to recover device if queue setup is interrupted
Date: Tue,  1 Aug 2023 11:19:59 +0200
Message-ID: <20230801091930.560422205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 0c0cbd4ebc375ceebc75c89df04b74f215fab23a ]

In ublk_ctrl_end_recovery(), if wait_for_completion_interruptible() is
interrupted by signal, queues aren't setup successfully yet, so we
have to fail UBLK_CMD_END_USER_RECOVERY, otherwise kernel oops can be
triggered.

Fixes: c732a852b419 ("ublk_drv: add START_USER_RECOVERY and END_USER_RECOVERY support")
Reported-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20230726144502.566785-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index dc2856d1241fc..bf0711894c0a2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2107,7 +2107,9 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	pr_devel("%s: Waiting for new ubq_daemons(nr: %d) are ready, dev id %d...\n",
 			__func__, ub->dev_info.nr_hw_queues, header->dev_id);
 	/* wait until new ubq_daemon sending all FETCH_REQ */
-	wait_for_completion_interruptible(&ub->completion);
+	if (wait_for_completion_interruptible(&ub->completion))
+		return -EINTR;
+
 	pr_devel("%s: All new ubq_daemons(nr: %d) are ready, dev id %d\n",
 			__func__, ub->dev_info.nr_hw_queues, header->dev_id);
 
-- 
2.40.1



