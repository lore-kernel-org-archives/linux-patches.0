Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF3E6FAF;
	Tue,  5 Dec 2023 03:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYTo9gFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8338EC433C7;
	Tue,  5 Dec 2023 03:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746953;
	bh=BcbHOeCN6sUyfYw3OIOauTxfcWjvy/48Y2MSJuxubPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYTo9gFgODg6Wg1pBYlhdFHHNIZ3izdvIFuPR5XXhz9NVpmqsD2emiYaPX+5VEl+R
	 oTZTeefoRwMJ7n+hzj7X+pHcQ02kVMungQ882nIBMOBMoEmQP+fwGZWABqP+QD98Ok
	 NUFeCXC3gMbVWiKy0vBuxusQyZIa1ws5iqZ3V7f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 71/71] mmc: block: Retry commands in CQE error recovery
Date: Tue,  5 Dec 2023 12:17:09 +0900
Message-ID: <20231205031521.963623022@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 8155d1fa3a747baad5caff5f8303321d68ddd48c ]

It is important that MMC_CMDQ_TASK_MGMT command to discard the queue is
successful because otherwise a subsequent reset might fail to flush the
cache first.  Retry it and the previous STOP command.

Fixes: 72a5af554df8 ("mmc: core: Add support for handling CQE requests")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103084720.6886-5-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d76184e4377ef..3c299417c4abc 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -571,7 +571,7 @@ int mmc_cqe_recovery(struct mmc_host *host)
 	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC;
 	cmd.flags       &= ~MMC_RSP_CRC; /* Ignore CRC */
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
-	mmc_wait_for_cmd(host, &cmd, 0);
+	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode       = MMC_CMDQ_TASK_MGMT;
@@ -579,10 +579,13 @@ int mmc_cqe_recovery(struct mmc_host *host)
 	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC;
 	cmd.flags       &= ~MMC_RSP_CRC; /* Ignore CRC */
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
-	err = mmc_wait_for_cmd(host, &cmd, 0);
+	err = mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
 	host->cqe_ops->cqe_recovery_finish(host);
 
+	if (err)
+		err = mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
+
 	mmc_retune_release(host);
 
 	return err;
-- 
2.42.0



