Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCCE1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CC3C433C1;
	Wed, 23 Nov 2022 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197475;
	bh=fvi7DgZsAFoziIzV1E5G1QMyu9rduF3TerUbwBtOGFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMhpH+de8R/fbUILrYW9ZLjWT4PPufnEG3SQeR94nBducGRDlbHPbFQ8NSrWBaPOB
	 9KHR47M8kB93G/BJ6ffyhsX+o/r3Yq9W7XnBGBOYMpqHt4zzTy29j2QPfrmvA6Wvds
	 henOofR4CEWFPVeV9m5t/eaSFAQjOjn0DXuAmSw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.0 274/314] s390/dcssblk: fix deadlock when adding a DCSS
Date: Wed, 23 Nov 2022 09:51:59 +0100
Message-Id: <20221123084637.952977398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit a41a11b4009580edb6e2b4c76e5e2ee303f87157 upstream.

After the rework from commit 1ebe2e5f9d68 ("block: remove
GENHD_FL_EXT_DEVT"), when calling device_add_disk(), dcssblk will end up
in disk_scan_partitions(), and not break out early w/o GENHD_FL_NO_PART.
This will trigger implicit open/release via blkdev_get/put_whole()
later. dcssblk_release() will then deadlock on dcssblk_devices_sem
semaphore, which is already held from dcssblk_add_store() when calling
device_add_disk().

dcssblk does not support partitions (DCSSBLK_MINORS_PER_DISK == 1), and
never scanned partitions before. Therefore restore the previous
behavior, and explicitly disallow partition scanning by setting the
GENHD_FL_NO_PART flag. This will also prevent this deadlock scenario.

Fixes: 1ebe2e5f9d68 ("block: remove GENHD_FL_EXT_DEVT")
Cc: <stable@vger.kernel.org> # 5.17+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dcssblk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 93b80da60277..b392b9f5482e 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -636,6 +636,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->minors = DCSSBLK_MINORS_PER_DISK;
 	dev_info->gd->fops = &dcssblk_devops;
 	dev_info->gd->private_data = dev_info;
+	dev_info->gd->flags |= GENHD_FL_NO_PART;
 	blk_queue_logical_block_size(dev_info->gd->queue, 4096);
 	blk_queue_flag_set(QUEUE_FLAG_DAX, dev_info->gd->queue);
 
-- 
2.38.1



