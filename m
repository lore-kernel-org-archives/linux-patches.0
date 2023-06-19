Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B55381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25786C433C8;
	Mon, 19 Jun 2023 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171350;
	bh=au3L0gv9ya6iFAYqsIbyad3Hm1RDLShwKOns8thGmZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eg6kPfRBBzl2A0KwaDr9mPby6nUxJgMPoOSiX86KEgCJjiNQizUAdxWWnqKajaj7J
	 MTPvJNgvGIJhxlsIhyXjCZtNhULZk7uaatTYcRhP1Nb7gygMNzbjgUWFWlvCEf+xSY
	 pdThG0pTJPwpHURUaALDW+y+gpaE2FkOkDPSiSDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 49/49] mmc: block: ensure error propagation for non-blk
Date: Mon, 19 Jun 2023 12:30:27 +0200
Message-ID: <20230619102132.476456630@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
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
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -250,6 +250,7 @@ static ssize_t power_ro_lock_store(struc
 		goto out_put;
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_BOOT_WP;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	blk_execute_rq(mq->queue, NULL, req, 0);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	blk_put_request(req);
@@ -689,6 +690,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_
 	idatas[0] = idata;
 	req_to_mmc_queue_req(req)->drv_op =
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = idatas;
 	req_to_mmc_queue_req(req)->ioc_count = 1;
 	blk_execute_rq(mq->queue, NULL, req, 0);
@@ -758,6 +760,7 @@ static int mmc_blk_ioctl_multi_cmd(struc
 	}
 	req_to_mmc_queue_req(req)->drv_op =
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = idata;
 	req_to_mmc_queue_req(req)->ioc_count = num_of_cmds;
 	blk_execute_rq(mq->queue, NULL, req, 0);
@@ -2748,6 +2751,7 @@ static int mmc_dbg_card_status_get(void
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_CARD_STATUS;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	blk_execute_rq(mq->queue, NULL, req, 0);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	if (ret >= 0) {
@@ -2786,6 +2790,7 @@ static int mmc_ext_csd_open(struct inode
 		goto out_free;
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_EXT_CSD;
+	req_to_mmc_queue_req(req)->drv_op_result = -EIO;
 	req_to_mmc_queue_req(req)->drv_op_data = &ext_csd;
 	blk_execute_rq(mq->queue, NULL, req, 0);
 	err = req_to_mmc_queue_req(req)->drv_op_result;


