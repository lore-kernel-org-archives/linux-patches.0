Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804E91ED3A
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D18C433C8;
	Tue, 25 Jul 2023 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282723;
	bh=x3shIIGvGstVJyoHIehJ7TDYf4It8ylxyEPNu7fg2M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELXRjpQKBnZH2VvHTqYNduTt3Xp8OKilXWe5VMo/5Mp04O1AadSiMaGreNGYtuSOX
	 GBTsXYlovehQ9u3aB9RmIuUv8Vj2nVmakpmFtZJ+aWWplhohAhkZ1+imUFefxCuEpF
	 bGHdd6lZWGVyZ2yI8iMLg+8pR5Ug56zSGHK487oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 224/227] scsi/sg: dont grab scsi host module reference
Date: Tue, 25 Jul 2023 12:46:31 +0200
Message-ID: <20230725104523.983367634@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

commit fcaa174a9c995cf0af3967e55644a1543ea07e36 upstream.

In order to prevent request_queue to be freed before cleaning up
blktrace debugfs entries, commit db59133e9279 ("scsi: sg: fix blktrace
debugfs entries leakage") use scsi_device_get(), however,
scsi_device_get() will also grab scsi module reference and scsi module
can't be removed.

It's reported that blktests can't unload scsi_debug after block/001:

blktests (master) # ./check block
block/001 (stress device hotplugging) [failed]
     +++ /root/blktests/results/nodev/block/001.out.bad 2023-06-19
      Running block/001
      Stressing sd
     +modprobe: FATAL: Module scsi_debug is in use.

Fix this problem by grabbing request_queue reference directly, so that
scsi host module can still be unloaded while request_queue will be
pinged by sg device.

Reported-by: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Link: https://lore.kernel.org/all/1760da91-876d-fc9c-ab51-999a6f66ad50@nvidia.com/
Fixes: db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230621160111.1433521-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1496,7 +1496,7 @@ sg_add_device(struct device *cl_dev)
 	int error;
 	unsigned long iflags;
 
-	error = scsi_device_get(scsidp);
+	error = blk_get_queue(scsidp->request_queue);
 	if (error)
 		return error;
 
@@ -1557,7 +1557,7 @@ cdev_add_err:
 out:
 	if (cdev)
 		cdev_del(cdev);
-	scsi_device_put(scsidp);
+	blk_put_queue(scsidp->request_queue);
 	return error;
 }
 
@@ -1574,7 +1574,7 @@ sg_device_destroy(struct kref *kref)
 	 */
 
 	blk_trace_remove(q);
-	scsi_device_put(sdp->device);
+	blk_put_queue(q);
 
 	write_lock_irqsave(&sg_index_lock, flags);
 	idr_remove(&sg_index_idr, sdp->index);


