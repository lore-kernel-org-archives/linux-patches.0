Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552E07497
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEE5C433C0;
	Mon, 19 Jun 2023 10:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171878;
	bh=Lywwh3EPaCstIYAatUsPtyUgRXtfA4tOs+aHlj3GKP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmBsyCw+Rx7Mx4ZYYcUEM32XcGSsNmK6YnJiWT/De+0yD1DsFtrnTvyIer39CTC/e
	 svNOqGDE591vo9TkSTtIt0LA/Zx4XO0JrzbLVngI7HI157RCevquyeqTxwfcK+Orxn
	 bkmVqTrEIi4Rb92A7YXDbx9RyY5nnqjFtJwiZtJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/64] s390/dasd: Use correct lock while counting channel queue length
Date: Mon, 19 Jun 2023 12:30:00 +0200
Message-ID: <20230619102133.040489421@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Höppner <hoeppner@linux.ibm.com>

[ Upstream commit ccc45cb4e7271c74dbb27776ae8f73d84557f5c6 ]

The lock around counting the channel queue length in the BIODASDINFO
ioctl was incorrectly changed to the dasd_block->queue_lock with commit
583d6535cb9d ("dasd: remove dead code"). This can lead to endless list
iterations and a subsequent crash.

The queue_lock is supposed to be used only for queue lists belonging to
dasd_block. For dasd_device related queue lists the ccwdev lock must be
used.

Fix the mentioned issues by correctly using the ccwdev lock instead of
the queue lock.

Fixes: 583d6535cb9d ("dasd: remove dead code")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20230609153750.1258763-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 9b7782395c379..d7aed832910c4 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -509,10 +509,10 @@ static int __dasd_ioctl_information(struct dasd_block *block,
 
 	memcpy(dasd_info->type, base->discipline->name, 4);
 
-	spin_lock_irqsave(&block->queue_lock, flags);
+	spin_lock_irqsave(get_ccwdev_lock(base->cdev), flags);
 	list_for_each(l, &base->ccw_queue)
 		dasd_info->chanq_len++;
-	spin_unlock_irqrestore(&block->queue_lock, flags);
+	spin_unlock_irqrestore(get_ccwdev_lock(base->cdev), flags);
 	return 0;
 }
 
-- 
2.39.2



