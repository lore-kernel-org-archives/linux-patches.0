Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE996FB1;
	Tue,  5 Dec 2023 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdPhShPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D59BC433C7;
	Tue,  5 Dec 2023 03:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747040;
	bh=ctRONOS0brVrOLzY/0bDIWf//tlJ622M5u7DTIk9Kjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdPhShPRlu6c8r7n8aLfSb/P2MLbc0kx/GKn/EZGiXSfrGAn/DK0+4yJpp+40LjQQ
	 9p9oOt8PXdL72oScvk1BrLzn4JKIO9jpuxTPsSR2AG/Ik/GtWACGItgw1UVX2DQJG3
	 Bi+hfbVZE2UiyLWtKbVbjTquMklI6PPOgOi7s6y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 012/107] mmc: block: Be sure to wait while busy in CQE error recovery
Date: Tue,  5 Dec 2023 12:15:47 +0900
Message-ID: <20231205031532.356996598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -554,6 +554,8 @@ int mmc_cqe_recovery(struct mmc_host *ho
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
 	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
+	mmc_poll_for_busy(host->card, MMC_CQE_RECOVERY_TIMEOUT, true, MMC_BUSY_IO);
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode       = MMC_CMDQ_TASK_MGMT;
 	cmd.arg          = 1; /* Discard entire queue */


