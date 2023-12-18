Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5691D122;
	Mon, 18 Dec 2023 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIOxhIJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0080C433C7;
	Mon, 18 Dec 2023 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908689;
	bh=7FRUCdXn/Hy8VPYagjtNnp7jUnbQIXHjlzTpob+ogWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIOxhIJpvmi0OnAghCINeMflIZpa90JNr85TEPKJyx8rKx/Y2cyUlebV1I7QYQJvZ
	 E3hMeKLiGXa4ftKJE1oGZHrJOIzx1u+IjHJUHkr2izaeHesO/FEitoIKTEeE335wo8
	 1Tugv+xcRfjTv2u0Zc3JQum/DYCW59gxBqwpLEd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 38/40] mmc: block: Be sure to wait while busy in CQE error recovery
Date: Mon, 18 Dec 2023 14:52:33 +0100
Message-ID: <20231218135044.217362346@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135042.748715259@linuxfoundation.org>
References: <20231218135042.748715259@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit c616696a902987352426fdaeec1b0b3240949e6b upstream.

STOP command does not guarantee to wait while busy, but subsequent command
MMC_CMDQ_TASK_MGMT to discard the queue will fail if the card is busy, so
be sure to wait by employing mmc_poll_for_busy().

Fixes: 72a5af554df8 ("mmc: core: Add support for handling CQE requests")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://lore.kernel.org/r/20231103084720.6886-4-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c    |    2 ++
 drivers/mmc/core/mmc_ops.c |    5 +++--
 drivers/mmc/core/mmc_ops.h |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -570,6 +570,8 @@ int mmc_cqe_recovery(struct mmc_host *ho
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
 	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
+	mmc_poll_for_busy(host->card, MMC_CQE_RECOVERY_TIMEOUT, true, true);
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode       = MMC_CMDQ_TASK_MGMT;
 	cmd.arg          = 1; /* Discard entire queue */
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -450,8 +450,8 @@ int mmc_switch_status(struct mmc_card *c
 	return __mmc_switch_status(card, true);
 }
 
-static int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
-			bool send_status, bool retry_crc_err)
+int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
+		      bool send_status, bool retry_crc_err)
 {
 	struct mmc_host *host = card->host;
 	int err;
@@ -504,6 +504,7 @@ static int mmc_poll_for_busy(struct mmc_
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mmc_poll_for_busy);
 
 /**
  *	__mmc_switch - modify EXT_CSD register
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -31,6 +31,8 @@ int mmc_can_ext_csd(struct mmc_card *car
 int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd);
 int mmc_switch_status(struct mmc_card *card);
 int __mmc_switch_status(struct mmc_card *card, bool crc_err_fatal);
+int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
+		      bool send_status, bool retry_crc_err);
 int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		unsigned int timeout_ms, unsigned char timing,
 		bool use_busy_signal, bool send_status,	bool retry_crc_err);


