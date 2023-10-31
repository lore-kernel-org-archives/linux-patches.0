Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329701DFC4
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aX1OwtLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463F5C433C8;
	Tue, 31 Oct 2023 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771758;
	bh=lT9xX85WsZLKa+SWzr+yXApbNFUM3AT5jOO93U8sJmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aX1OwtLx9EnYtG7MOgXmRoFvt9s2Wl+RzB+NqYzODFLkXBRqSda4fHSQKYuPEJk3a
	 BE2n1UveiGKz2yD2n7TmxzcD1xCO74UJRheV1tPn30OD0wbEYmzQZBELZV4x2HLlr6
	 qj62/uc6/J18ZOCZXv5xPZAXTQs2ZhwiwZOk0Ogg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/86] mmc: block: ioctl: do write error check for spi
Date: Tue, 31 Oct 2023 18:00:28 +0100
Message-ID: <20231031165918.715359623@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <CLoehle@hyperstone.com>

[ Upstream commit 568898cbc8b570311b3b94a3202b8233f4168144 ]

SPI doesn't have the usual PROG path we can check for error bits
after moving back to TRAN. Instead it holds the line LOW until
completion. We can then check if the card shows any errors or
is in IDLE state, indicating the line is no longer LOW because
the card was reset.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/55920f880c9742f486f64aa44e25508e@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: f19c5a73e6f7 ("mmc: core: Fix error propagation for some ioctl commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index baefe2886f0b2..1aab4f47eab98 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -180,6 +180,7 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 			       int recovery_mode,
 			       struct mmc_queue *mq);
 static void mmc_blk_hsq_req_done(struct mmc_request *mrq);
+static int mmc_spi_err_check(struct mmc_card *card);
 
 static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 {
@@ -623,6 +624,11 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
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
-- 
2.42.0



