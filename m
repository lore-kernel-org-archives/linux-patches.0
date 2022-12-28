Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84B1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CCCC433D2;
	Wed, 28 Dec 2022 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243152;
	bh=JYNMgYr1uiS2PGSjM4RIyuhqaeX8EwuHEPm5BgNNkrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA8IjWHwJyDklvlAjZ1QRkep9ARSJZQILvsaanrMZ33dg+oBFpQnBO7LcpnNWJpoH
	 kHfzUlWm/fgNkneVLSBCfkutU5VzPJ9FIdV2aVe1mKwuK5RT6yibY+lPO1yO2gwiDE
	 w5ivhuZ6bzjtE4zZ/LoCFhob0P4hUywNGmKtOdKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0495/1073] memstick/ms_block: Add check for alloc_ordered_workqueue
Date: Wed, 28 Dec 2022 15:34:43 +0100
Message-Id: <20221228144341.481819125@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 4f431a047a5c8698ed4b67e2760cfbeb5fffb69d ]

As the alloc_ordered_workqueue may return NULL pointer, it should be better
to add check for the return value. Moreover, the msb->io_queue should be
freed if error occurs later.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221126012558.34374-1-jiasheng@iscas.ac.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index ba8414519515..04115cd92433 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2116,6 +2116,11 @@ static int msb_init_disk(struct memstick_dev *card)
 	dbg("Set total disk size to %lu sectors", capacity);
 
 	msb->io_queue = alloc_ordered_workqueue("ms_block", WQ_MEM_RECLAIM);
+	if (!msb->io_queue) {
+		rc = -ENOMEM;
+		goto out_cleanup_disk;
+	}
+
 	INIT_WORK(&msb->io_work, msb_io_work);
 	sg_init_table(msb->prealloc_sg, MS_BLOCK_MAX_SEGS+1);
 
@@ -2125,10 +2130,12 @@ static int msb_init_disk(struct memstick_dev *card)
 	msb_start(card);
 	rc = device_add_disk(&card->dev, msb->disk, NULL);
 	if (rc)
-		goto out_cleanup_disk;
+		goto out_destroy_workqueue;
 	dbg("Disk added");
 	return 0;
 
+out_destroy_workqueue:
+	destroy_workqueue(msb->io_queue);
 out_cleanup_disk:
 	put_disk(msb->disk);
 out_free_tag_set:
-- 
2.35.1



