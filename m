Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9B6AA0;
	Tue,  5 Dec 2023 03:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OahUYqPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B3DC433C7;
	Tue,  5 Dec 2023 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746414;
	bh=msGutHJywZ9BwiTfLjeIR6rQHFSm5hhNQogzSe/T2UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OahUYqPxJna3FOTGsAmBp93R/TmnoEgCDLz1ywv6Qe6coguJm6EZlZi/XPagmWw2i
	 k78ZAMhM2A+Lg49EKxlEV6x8l4HZrJkXEr84bacXOgwKIB8H0rkxGQYpKUs5GG2UZ7
	 e/F9K+qrXd5CtNt6GPYmW9zSuB3DL2+Nwul1E97o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 016/134] mmc: block: Be sure to wait while busy in CQE error recovery
Date: Tue,  5 Dec 2023 12:14:48 +0900
Message-ID: <20231205031536.347128498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -553,6 +553,8 @@ int mmc_cqe_recovery(struct mmc_host *ho
 	cmd.busy_timeout = MMC_CQE_RECOVERY_TIMEOUT;
 	mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
 
+	mmc_poll_for_busy(host->card, MMC_CQE_RECOVERY_TIMEOUT, true, MMC_BUSY_IO);
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode       = MMC_CMDQ_TASK_MGMT;
 	cmd.arg          = 1; /* Discard entire queue */


