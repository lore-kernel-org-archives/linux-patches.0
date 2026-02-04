Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1841B41B37C;
	Wed,  4 Feb 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218734; cv=none; b=crS39VeLc9/E+jdT7Vtruu+qyUXo4gfnTXJ8WPE3aixy0CVS3HndgLEzCyOdyzK1gwGS0UGlQgqdsdoIRdGO8qZooMLgzAzirq6XZRQJxJ1ZfKQ3zzJDfxl2G/3Xs0vxPNZFXrFA0PZj/vWw+urJigAX+saok3URKAaS8CObRh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218734; c=relaxed/simple;
	bh=jSXh/I9L2B+lGjuvmADad/vOi5Dw/ppLRHD/7gFuUGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aqvi4AG3tZjYiui3fOIKt5QyEsiNzYNff8mm3YPvTQUg6S8gDVjLHUxzlwEz24f7io3Usw3fjfIc0JTyPrUTON+iao4FHa28wQCdXk3pVR2tTW9EEh36o29kMmQJhiqFYbTvGYt0sEgf1vjpG68sXxvDbtkbVGz8WFI9Wx7i36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlIn7ZZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlIn7ZZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F864C4CEF7;
	Wed,  4 Feb 2026 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218734;
	bh=jSXh/I9L2B+lGjuvmADad/vOi5Dw/ppLRHD/7gFuUGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlIn7ZZi4qfUhbtX7TOOk6fac8BG6p76oDLu0wQMVa5ji5NmBHGw2d95pEj/dOqWo
	 KfbbfDF5SNzIM9Bv42xxb9ri4Xxauj1/FYYRyJHi1KxipS/FNxWAJs3cf41+u2XU6L
	 1wUbK6xBqI8qOu9RrZXUwMAZL+5nXTDaKXsK2P6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 44/87] nvmet: fix race in nvmet_bio_done() leading to NULL pointer dereference
Date: Wed,  4 Feb 2026 15:40:42 +0100
Message-ID: <20260204143848.500885527@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 0fcee2cfc4b2e16e62ff8e0cc2cd8dd24efad65e upstream.

There is a race condition in nvmet_bio_done() that can cause a NULL
pointer dereference in blk_cgroup_bio_start():

1. nvmet_bio_done() is called when a bio completes
2. nvmet_req_complete() is called, which invokes req->ops->queue_response(req)
3. The queue_response callback can re-queue and re-submit the same request
4. The re-submission reuses the same inline_bio from nvmet_req
5. Meanwhile, nvmet_req_bio_put() (called after nvmet_req_complete)
   invokes bio_uninit() for inline_bio, which sets bio->bi_blkg to NULL
6. The re-submitted bio enters submit_bio_noacct_nocheck()
7. blk_cgroup_bio_start() dereferences bio->bi_blkg, causing a crash:

  BUG: kernel NULL pointer dereference, address: 0000000000000028
  #PF: supervisor read access in kernel mode
  RIP: 0010:blk_cgroup_bio_start+0x10/0xd0
  Call Trace:
   submit_bio_noacct_nocheck+0x44/0x250
   nvmet_bdev_execute_rw+0x254/0x370 [nvmet]
   process_one_work+0x193/0x3c0
   worker_thread+0x281/0x3a0

Fix this by reordering nvmet_bio_done() to call nvmet_req_bio_put()
BEFORE nvmet_req_complete(). This ensures the bio is cleaned up before
the request can be re-submitted, preventing the race condition.

Fixes: 190f4c2c863a ("nvmet: fix memory leak of bio integrity")
Cc: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: stable@vger.kernel.org
Cc: Guangwu Zhang <guazhang@redhat.com>
Link: http://www.mail-archive.com/debian-kernel@lists.debian.org/msg146238.html
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/io-cmd-bdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -176,9 +176,10 @@ u16 blk_to_nvme_status(struct nvmet_req
 static void nvmet_bio_done(struct bio *bio)
 {
 	struct nvmet_req *req = bio->bi_private;
+	blk_status_t blk_status = bio->bi_status;
 
-	nvmet_req_complete(req, blk_to_nvme_status(req, bio->bi_status));
 	nvmet_req_bio_put(req, bio);
+	nvmet_req_complete(req, blk_to_nvme_status(req, blk_status));
 }
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY


