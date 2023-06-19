Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3C6FAD
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FEC433C8;
	Mon, 19 Jun 2023 10:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171875;
	bh=bsx0pDijI2UiyIllwZzFkWcQOIJQPeZhNFtfchrVIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mRD+9CfKjznlN85t7sLOKFS4Y4gistXlkIksD6VWNah1nn6CF8CiRipG4EjBy6eW
	 FwZh0Go0f220cWcY1sGp5muL+Ks5JDzbmpMGn0SU4Q2nvqSl+4TpcsLR/RqgIBXvW6
	 RIttu8lfF8IGZwaWZeLWl+3rBkDOwUUixj2ZMMSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Stefan Haberland <sth@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/64] dasd: refactor dasd_ioctl_information
Date: Mon, 19 Jun 2023 12:29:59 +0200
Message-ID: <20230619102132.998127767@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9353848c6589ffe6373d03f3a58feaeda1009641 ]

Prepare for in-kernel callers of this functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[sth@de.ibm.com: remove leftover kfree]
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ccc45cb4e727 ("s390/dasd: Use correct lock while counting channel queue length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_ioctl.c | 42 ++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 9a5f3add325fc..9b7782395c379 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -457,10 +457,9 @@ static int dasd_ioctl_read_profile(struct dasd_block *block, void __user *argp)
 /*
  * Return dasd information. Used for BIODASDINFO and BIODASDINFO2.
  */
-static int dasd_ioctl_information(struct dasd_block *block,
-				  unsigned int cmd, void __user *argp)
+static int __dasd_ioctl_information(struct dasd_block *block,
+		struct dasd_information2_t *dasd_info)
 {
-	struct dasd_information2_t *dasd_info;
 	struct subchannel_id sch_id;
 	struct ccw_dev_id dev_id;
 	struct dasd_device *base;
@@ -473,15 +472,9 @@ static int dasd_ioctl_information(struct dasd_block *block,
 	if (!base->discipline || !base->discipline->fill_info)
 		return -EINVAL;
 
-	dasd_info = kzalloc(sizeof(struct dasd_information2_t), GFP_KERNEL);
-	if (dasd_info == NULL)
-		return -ENOMEM;
-
 	rc = base->discipline->fill_info(base, dasd_info);
-	if (rc) {
-		kfree(dasd_info);
+	if (rc)
 		return rc;
-	}
 
 	cdev = base->cdev;
 	ccw_device_get_id(cdev, &dev_id);
@@ -520,15 +513,24 @@ static int dasd_ioctl_information(struct dasd_block *block,
 	list_for_each(l, &base->ccw_queue)
 		dasd_info->chanq_len++;
 	spin_unlock_irqrestore(&block->queue_lock, flags);
+	return 0;
+}
 
-	rc = 0;
-	if (copy_to_user(argp, dasd_info,
-			 ((cmd == (unsigned int) BIODASDINFO2) ?
-			  sizeof(struct dasd_information2_t) :
-			  sizeof(struct dasd_information_t))))
-		rc = -EFAULT;
+static int dasd_ioctl_information(struct dasd_block *block, void __user *argp,
+		size_t copy_size)
+{
+	struct dasd_information2_t *dasd_info;
+	int error;
+
+	dasd_info = kzalloc(sizeof(*dasd_info), GFP_KERNEL);
+	if (!dasd_info)
+		return -ENOMEM;
+
+	error = __dasd_ioctl_information(block, dasd_info);
+	if (!error && copy_to_user(argp, dasd_info, copy_size))
+		error = -EFAULT;
 	kfree(dasd_info);
-	return rc;
+	return error;
 }
 
 /*
@@ -622,10 +624,12 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 		rc = dasd_ioctl_check_format(bdev, argp);
 		break;
 	case BIODASDINFO:
-		rc = dasd_ioctl_information(block, cmd, argp);
+		rc = dasd_ioctl_information(block, argp,
+				sizeof(struct dasd_information_t));
 		break;
 	case BIODASDINFO2:
-		rc = dasd_ioctl_information(block, cmd, argp);
+		rc = dasd_ioctl_information(block, argp,
+				sizeof(struct dasd_information2_t));
 		break;
 	case BIODASDPRRD:
 		rc = dasd_ioctl_read_profile(block, argp);
-- 
2.39.2



