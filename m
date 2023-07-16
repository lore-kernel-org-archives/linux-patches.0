Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2FF8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E8DC433C8;
	Sun, 16 Jul 2023 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538764;
	bh=upnEBz1ZGhx67M8PPI0EKNw8HzMCoyrFtjSApqaDWcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTprwubtBpvJIoK1jXWUjLO61rmU9/twfJQzPUviZmY6QtqqWfBhui1RW7lig3Ade
	 SX1UHUS/ItMmrf72j4txH7tmD2dB9kyx8Z3A6sBzALaGaQfqmwdG/9TDQLw143vOSW
	 ERnrBudHaRPDFG/ZCnO2WQxptOGt8E3AxjG92vbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.4 528/800] mmc: block: ioctl: do write error check for spi
Date: Sun, 16 Jul 2023 21:46:21 +0200
Message-ID: <20230716195001.358024018@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

commit 568898cbc8b570311b3b94a3202b8233f4168144 upstream.

SPI doesn't have the usual PROG path we can check for error bits
after moving back to TRAN. Instead it holds the line LOW until
completion. We can then check if the card shows any errors or
is in IDLE state, indicating the line is no longer LOW because
the card was reset.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/55920f880c9742f486f64aa44e25508e@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -178,6 +178,7 @@ static void mmc_blk_rw_rq_prep(struct mm
 			       int recovery_mode,
 			       struct mmc_queue *mq);
 static void mmc_blk_hsq_req_done(struct mmc_request *mrq);
+static int mmc_spi_err_check(struct mmc_card *card);
 
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
@@ -608,6 +609,11 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if ((card->host->caps & MMC_CAP_WAIT_WHILE_BUSY) && use_r1b_resp)
 		return 0;
 
+	if (mmc_host_is_spi(card->host)) {
+		if (idata->ic.write_flag || r1b_resp || cmd.flags & MMC_RSP_SPI_BUSY)
+			return mmc_spi_err_check(card);
+		return err;
+	}
 	/* Ensure RPMB/R1B command has completed by polling with CMD13. */
 	if (idata->rpmb || r1b_resp)
 		err = mmc_poll_for_busy(card, busy_timeout_ms, false,


