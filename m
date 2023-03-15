Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026D4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C641C433EF;
	Wed, 15 Mar 2023 12:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883145;
	bh=YCaXQSHiK/uRjonLu3ZR09pYSWFIdjlAbzfrWJxkeY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPphHsjkHpflKuEZ2XqWKL6yxzPvKvoo7f0dZyDnGmXeL/4om9otYuq/6yEr7rNqn
	 9QO18N1FsfbcE9Fsrndd6n8ypCu9Wm1aHNJ6nTbjRbX/MIojY41XCxyThnjQ6i7DMn
	 LEnqnxrRSanwPUlSqrcQmZky2IpEgzIhpCDambTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/145] block/brd: add error handling support for add_disk()
Date: Wed, 15 Mar 2023 13:11:38 +0100
Message-Id: <20230315115740.106826747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit e1528830bd4ebf435d91c154e309e6e028336210 ]

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20211015235219.2191207-2-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 67205f80be99 ("brd: mark as nowait compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/brd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2427b2261e516..63ac5cd523408 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -370,6 +370,7 @@ static int brd_alloc(int i)
 	struct brd_device *brd;
 	struct gendisk *disk;
 	char buf[DISK_NAME_LEN];
+	int err = -ENOMEM;
 
 	mutex_lock(&brd_devices_mutex);
 	list_for_each_entry(brd, &brd_devices, brd_list) {
@@ -420,16 +421,20 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
 
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_free_dev:
 	mutex_lock(&brd_devices_mutex);
 	list_del(&brd->brd_list);
 	mutex_unlock(&brd_devices_mutex);
 	kfree(brd);
-	return -ENOMEM;
+	return err;
 }
 
 static void brd_probe(dev_t dev)
-- 
2.39.2



