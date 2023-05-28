Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBD611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AECEC433EF;
	Sun, 28 May 2023 19:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302489;
	bh=axy+H+F2WHwmOB61QmoJgbJuD3hVk1Yo7kakkRMSKVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA873vZZDOfvffJBm40z2IHH09ZwaJ5BxnJNf6pylIop5fk3zVWU4T5xqi9oHT6jP
	 EtqM0vI5BHlAgQAS2tm+O3TIWirdiwrTYIYVCh0iC5Cw+UZe/AQ7jJ/JayzJHskSgI
	 A0R50a8htbF/Kp4XS/3DyY1dHMO7RsnLtp5FZ97A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 024/119] mmc: block: ensure error propagation for non-blk
Date: Sun, 28 May 2023 20:10:24 +0100
Message-Id: <20230528190836.150791727@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Loehle <CLoehle@hyperstone.com>

commit 003fb0a51162d940f25fc35e70b0996a12c9e08a upstream.

Requests to the mmc layer usually come through a block device IO.
The exceptions are the ioctl interface, RPMB chardev ioctl
and debugfs, which issue their own blk_mq requests through
blk_execute_rq and do not query the BLK_STS error but the
mmcblk-internal drv_op_result. This patch ensures that drv_op_result
defaults to an error and has to be overwritten by the operation
to be considered successful.

The behavior leads to a bug where the request never propagates
the error, e.g. by directly erroring out at mmc_blk_mq_issue_rq if
mmc_blk_part_switch fails. The ioctl caller of the rpmb chardev then
can never see an error (BLK_STS_IOERR, but drv_op_result is unchanged)
and thus may assume that their call executed successfully when it did not.

While always checking the blk_execute_rq return value would be
advised, let's eliminate the error by always setting
drv_op_result as -EIO to be overwritten on success (or other error)

Fixes: 614f0388f580 ("mmc: block: move single ioctl() commands to block requests")
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/59c17ada35664b818b7bd83752119b2d@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -266,6 +266,7 @@ static ssize_t power_ro_lock_store(struc
 		goto out_put;
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_BOOT_WP;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	blk_execute_rq(req, false);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	blk_mq_free_request(req);
@@ -657,6 +658,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_
 	idatas[0] = idata;
 	req_to_mmc_queue_req(req)->drv_op =
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = idatas;
 	req_to_mmc_queue_req(req)->ioc_count = 1;
 	blk_execute_rq(req, false);
@@ -728,6 +730,7 @@ static int mmc_blk_ioctl_multi_cmd(struc
 	}
 	req_to_mmc_queue_req(req)->drv_op =
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = idata;
 	req_to_mmc_queue_req(req)->ioc_count = n;
 	blk_execute_rq(req, false);
@@ -2812,6 +2815,7 @@ static int mmc_dbg_card_status_get(void
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_CARD_STATUS;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	blk_execute_rq(req, false);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	if (ret >= 0) {
@@ -2850,6 +2854,7 @@ static int mmc_ext_csd_open(struct inode
 		goto out_free;
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_EXT_CSD;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = &ext_csd;
 	blk_execute_rq(req, false);
 	err = req_to_mmc_queue_req(req)->drv_op_result;


