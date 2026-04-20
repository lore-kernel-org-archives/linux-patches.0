Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23A33260F;
	Mon, 20 Apr 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700561; cv=none; b=raT/aicC4ZOXwo/wt5dfvyKGatDNTGIDdF3Oz53iZuWu+DYNZpViRzYGhy4NnONYvmzK/anUP5MIOYmlxNDoN9GdSQL9k2TzaYuLMDZY5zV4UM7g+SIykH8VjGd/dsuYcCxT+qp+x8SpuF2QLF8hfXCJm/lD1+iE4+olMq7xs0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700561; c=relaxed/simple;
	bh=c/zTMQRuodoFCcyYn4QoaAELmJgOtE/SyyTTVjdO90M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXQ0pq/TWxb1QHQLm6ZVA91F7MXhtJMnwb43nDEODdsh0d3vdlQYmbC/qHU1qZES/DDiG1k5tJhqXcDvvVlBUsF3uRjbPyDHHaXzuU8DGbbQ4ik7meHBATfl9D2mUlsrqBfl3pfT0aq8dQHo8iRhFFw5xNozhyc1PwMym08HiHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzybFIuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzybFIuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8F3C19425;
	Mon, 20 Apr 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700561;
	bh=c/zTMQRuodoFCcyYn4QoaAELmJgOtE/SyyTTVjdO90M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzybFIuknrwGWRbMDGMyRHZFRyR2pnTpXhmAlX8qI3kMaSIaKn4/df4bNp5f6c8FT
	 zeuaxpZfAQLtKDoPm1grJWRBYAM4fjgb1zQNBh0z3VomFVYWiz0QZwhwVK/0N2Qd/l
	 y1QFoo+O6yM+H+yDD+fnBSsHTnm5f2MBL+jKgKLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 212/220] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Mon, 20 Apr 2026 17:42:33 +0200
Message-ID: <20260420153941.660299502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit fec114a98b8735ee89c75216c45a78e28be0f128 upstream.

In our production environment, we have received multiple crash reports
regarding libceph, which have caught our attention:

```
[6888366.280350] Call Trace:
[6888366.280452]  blk_update_request+0x14e/0x370
[6888366.280561]  blk_mq_end_request+0x1a/0x130
[6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
[6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
[6888366.280903]  __complete_request+0x22/0x70 [libceph]
[6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
[6888366.281164]  ? inet_recvmsg+0x5b/0xd0
[6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
[6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
[6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
[6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
```

After analyzing the coredump file, we found that the address of
dc->sb_bio has been freed. We know that cached_dev is only freed when it
is stopped.

Since sb_bio is a part of struct cached_dev, rather than an alloc every
time.  If the device is stopped while writing to the superblock, the
released address will be accessed at endio.

This patch hopes to wait for sb_write to complete in cached_dev_free.

It should be noted that we analyzed the cause of the problem, then tell
all details to the QWEN and adopted the modifications it made.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Fixes: cafe563591446 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Coly Li <colyli@fnnas.com>
Link: https://patch.msgid.link/20260322134102.480107-1-colyli@fnnas.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1373,6 +1373,13 @@ static CLOSURE_CALLBACK(cached_dev_free)
 
 	mutex_unlock(&bch_register_lock);
 
+	/*
+	 * Wait for any pending sb_write to complete before free.
+	 * The sb_bio is embedded in struct cached_dev, so we must
+	 * ensure no I/O is in progress.
+	 */
+	closure_sync(&dc->sb_write);
+
 	if (dc->sb_disk)
 		folio_put(virt_to_folio(dc->sb_disk));
 


