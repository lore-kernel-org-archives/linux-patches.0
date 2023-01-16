Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5FA46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FD3C433EF;
	Mon, 16 Jan 2023 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886493;
	bh=rByWPUYhZaAZwdDPTUtCgCF4SZBKN0twJvNUntKA2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BD/R+7rIrHyL9CZU2vTvR35n8LBK85hIcN7IehUCDUvDqKbfKMbsBJz+f2isqfpl
	 P+WaqtGNZTl3ln+NZ9QKzj5sSbSWwtjvyhvlQw028CzzGZvNzBdZNYsLAFG0fMyDW8
	 7OYQrl1NdMqGSw9of5rbbzDL5gXmkCvQQhTlXA0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 420/658] blk-mq: fix possible memleak when register hctx failed
Date: Mon, 16 Jan 2023 16:48:28 +0100
Message-Id: <20230116154928.801719130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 4b7a21c57b14fbcd0e1729150189e5933f5088e9 ]

There's issue as follows when do fault injection test:
unreferenced object 0xffff888132a9f400 (size 512):
  comm "insmod", pid 308021, jiffies 4324277909 (age 509.733s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 f4 a9 32 81 88 ff ff  ...........2....
    08 f4 a9 32 81 88 ff ff 00 00 00 00 00 00 00 00  ...2............
  backtrace:
    [<00000000e8952bb4>] kmalloc_node_trace+0x22/0xa0
    [<00000000f9980e0f>] blk_mq_alloc_and_init_hctx+0x3f1/0x7e0
    [<000000002e719efa>] blk_mq_realloc_hw_ctxs+0x1e6/0x230
    [<000000004f1fda40>] blk_mq_init_allocated_queue+0x27e/0x910
    [<00000000287123ec>] __blk_mq_alloc_disk+0x67/0xf0
    [<00000000a2a34657>] 0xffffffffa2ad310f
    [<00000000b173f718>] 0xffffffffa2af824a
    [<0000000095a1dabb>] do_one_initcall+0x87/0x2a0
    [<00000000f32fdf93>] do_init_module+0xdf/0x320
    [<00000000cbe8541e>] load_module+0x3006/0x3390
    [<0000000069ed1bdb>] __do_sys_finit_module+0x113/0x1b0
    [<00000000a1a29ae8>] do_syscall_64+0x35/0x80
    [<000000009cd878b0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fault injection context as follows:
 kobject_add
 blk_mq_register_hctx
 blk_mq_sysfs_register
 blk_register_queue
 device_add_disk
 null_add_dev.part.0 [null_blk]

As 'blk_mq_register_hctx' may already add some objects when failed halfway,
but there isn't do fallback, caller don't know which objects add failed.
To solve above issue just do fallback when add objects failed halfway in
'blk_mq_register_hctx'.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20221117022940.873959-1-yebin@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 5dafd7a8ec91..7abd66d1228a 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -250,7 +250,7 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct blk_mq_ctx *ctx;
-	int i, ret;
+	int i, j, ret;
 
 	if (!hctx->nr_ctx)
 		return 0;
@@ -262,9 +262,16 @@ static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
 	hctx_for_each_ctx(hctx, ctx, i) {
 		ret = kobject_add(&ctx->kobj, &hctx->kobj, "cpu%u", ctx->cpu);
 		if (ret)
-			break;
+			goto out;
 	}
 
+	return 0;
+out:
+	hctx_for_each_ctx(hctx, ctx, j) {
+		if (j < i)
+			kobject_del(&ctx->kobj);
+	}
+	kobject_del(&hctx->kobj);
 	return ret;
 }
 
-- 
2.35.1



