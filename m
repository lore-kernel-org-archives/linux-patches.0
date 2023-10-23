Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06C14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkfVl1aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5617BC433C8;
	Mon, 23 Oct 2023 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059450;
	bh=B9o7X4HPgmQAGZDdEBs7ZtceVpLfdp6/e7SkUhahtxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkfVl1aL8GxY12DzAYyUtDhCdLEyASmXQSm2eG8r5AW1U9YWI3qlnrhGD4H/IwwEY
	 0goFJtlmS49tgkFh22Zz6v/zM2TxUWqsY0UPgSPCa5ddgOI0T+NYqAgP7O5kT4+eOi
	 Q4M59rDQT5guBTBdHphBKRhVcQIEms8g39ARNeG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 174/241] mmc: core: Fix error propagation for some ioctl commands
Date: Mon, 23 Oct 2023 12:56:00 +0200
Message-ID: <20231023104838.127524822@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit f19c5a73e6f78d69efce66cfdce31148c76a61a6 upstream.

Userspace has currently no way of checking the internal R1 response error
bits for some commands. This is a problem for some commands, like RPMB for
example. Typically, we may detect that the busy completion has successfully
ended, while in fact the card did not complete the requested operation.

To fix the problem, let's always poll with CMD13 for these commands and
during the polling, let's also aggregate the R1 response bits. Before
completing the ioctl request, let's propagate the R1 response bits too.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Co-developed-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230913112921.553019-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -179,6 +179,7 @@ static void mmc_blk_rw_rq_prep(struct mm
 			       struct mmc_queue *mq);
 static void mmc_blk_hsq_req_done(struct mmc_request *mrq);
 static int mmc_spi_err_check(struct mmc_card *card);
+static int mmc_blk_busy_cb(void *cb_data, bool *busy);
 
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
@@ -470,7 +471,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	struct mmc_data data = {};
 	struct mmc_request mrq = {};
 	struct scatterlist sg;
-	bool r1b_resp, use_r1b_resp = false;
+	bool r1b_resp;
 	unsigned int busy_timeout_ms;
 	int err;
 	unsigned int target_part;
@@ -551,8 +552,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	busy_timeout_ms = idata->ic.cmd_timeout_ms ? : MMC_BLK_TIMEOUT_MS;
 	r1b_resp = (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B;
 	if (r1b_resp)
-		use_r1b_resp = mmc_prepare_busy_cmd(card->host, &cmd,
-						    busy_timeout_ms);
+		mmc_prepare_busy_cmd(card->host, &cmd, busy_timeout_ms);
 
 	mmc_wait_for_req(card->host, &mrq);
 	memcpy(&idata->ic.response, cmd.resp, sizeof(cmd.resp));
@@ -605,19 +605,28 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if (idata->ic.postsleep_min_us)
 		usleep_range(idata->ic.postsleep_min_us, idata->ic.postsleep_max_us);
 
-	/* No need to poll when using HW busy detection. */
-	if ((card->host->caps & MMC_CAP_WAIT_WHILE_BUSY) && use_r1b_resp)
-		return 0;
-
 	if (mmc_host_is_spi(card->host)) {
 		if (idata->ic.write_flag || r1b_resp || cmd.flags & MMC_RSP_SPI_BUSY)
 			return mmc_spi_err_check(card);
 		return err;
 	}
-	/* Ensure RPMB/R1B command has completed by polling with CMD13. */
-	if (idata->rpmb || r1b_resp)
-		err = mmc_poll_for_busy(card, busy_timeout_ms, false,
-					MMC_BUSY_IO);
+
+	/*
+	 * Ensure RPMB, writes and R1B responses are completed by polling with
+	 * CMD13. Note that, usually we don't need to poll when using HW busy
+	 * detection, but here it's needed since some commands may indicate the
+	 * error through the R1 status bits.
+	 */
+	if (idata->rpmb || idata->ic.write_flag || r1b_resp) {
+		struct mmc_blk_busy_data cb_data = {
+			.card = card,
+		};
+
+		err = __mmc_poll_for_busy(card->host, 0, busy_timeout_ms,
+					  &mmc_blk_busy_cb, &cb_data);
+
+		idata->ic.response[0] = cb_data.status;
+	}
 
 	return err;
 }


