Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B41115CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E100C433D7;
	Tue,  8 Nov 2022 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916190;
	bh=HapeRK6WkRCyD2HT4KFEXZB8QThrsn4Pj6XJfZncKMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrwhaLXdmdV1NzfFUkVYVZkMF1o4P7ofuNK86YJsRXyb6vOViCTXKcgpY83B+AEII
	 8wwRF0/JI88PWp0MrJFt61odI+J2a8XQX/GN3t9luLbqSaYRGPBMEYTsfNtENglrjf
	 YugzAs+jSSAR8i1cjrVXpnCzwFnJHXOImjO/0gQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/144] block: Fix possible memory leak for rq_wb on add_disk failure
Date: Tue,  8 Nov 2022 14:39:27 +0100
Message-Id: <20221108133349.062005201@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit fa81cbafbf5764ad5053512152345fab37a1fe18 ]

kmemleak reported memory leaks in device_add_disk():

kmemleak: 3 new suspected memory leaks

unreferenced object 0xffff88800f420800 (size 512):
  comm "modprobe", pid 4275, jiffies 4295639067 (age 223.512s)
  hex dump (first 32 bytes):
    04 00 00 00 08 00 00 00 01 00 00 00 00 00 00 00  ................
    00 e1 f5 05 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d3662699>] kmalloc_trace+0x26/0x60
    [<00000000edc7aadc>] wbt_init+0x50/0x6f0
    [<0000000069601d16>] wbt_enable_default+0x157/0x1c0
    [<0000000028fc393f>] blk_register_queue+0x2a4/0x420
    [<000000007345a042>] device_add_disk+0x6fd/0xe40
    [<0000000060e6aab0>] nbd_dev_add+0x828/0xbf0 [nbd]
    ...

It is because the memory allocated in wbt_enable_default() is not
released in device_add_disk() error path.
Normally, these memory are freed in:

del_gendisk()
  rq_qos_exit()
    rqos->ops->exit(rqos);
      wbt_exit()

So rq_qos_exit() is called to free the rq_wb memory for wbt_init().
However in the error path of device_add_disk(), only
blk_unregister_queue() is called and make rq_wb memory leaked.

Add rq_qos_exit() to the error path to fix it.

Fixes: 83cbce957446 ("block: add error handling for device_add_disk / add_disk")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221029071355.35462-1-chenzhongjin@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/genhd.c b/block/genhd.c
index 74e19d67ceab..68065189ca17 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -527,6 +527,7 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 		bdi_unregister(disk->bdi);
 out_unregister_queue:
 	blk_unregister_queue(disk);
+	rq_qos_exit(disk->queue);
 out_put_slave_dir:
 	kobject_put(disk->slave_dir);
 out_put_holder_dir:
-- 
2.35.1



