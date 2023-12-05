Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA308BF7;
	Tue,  5 Dec 2023 03:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdWQI5ST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD34C433C7;
	Tue,  5 Dec 2023 03:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748073;
	bh=Z47cTPYl54M5Z3qofX3pU1ekJKqLTlMMF7DSOxSigKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdWQI5STxL8Dav3GqwLdJbFYtEj3iQ2nxeBfrpa0PB9afAl8WllGlTcLGPjY3JEUQ
	 IK6LC0cMp08WxRZxYcFd7YVgMPEP8IBX3NJlIAttg5tpd3LL7dQkwB6Lba45jOkLb3
	 tRnkR39bxDMk/WSy07PR0NKbzXNNzosf10/CR4io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 94/94] mmc: block: Retry commands in CQE error recovery
Date: Tue,  5 Dec 2023 12:18:02 +0900
Message-ID: <20231205031528.044108471@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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
index c88e991f787be..67c0d1378747d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -568,7 +568,7 @@ int mmc_cqe_recovery(struct mmc_host *host)
 	cmd.flags        = MMC_RSP_R1B | MMC_CMD_AC;
 	cmd.flags       &= ~MMC_RSP_CRC; /* Ignore CRC */
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
-	mmc_wait_for_cmd(host, &cmd, 0);
+	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode       = MMC_CMDQ_TASK_MGMT;
@@ -576,10 +576,13 @@ int mmc_cqe_recovery(struct mmc_host *host)
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



