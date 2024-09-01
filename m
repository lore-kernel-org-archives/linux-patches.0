Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E81E87B;
	Sun,  1 Sep 2024 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209271; cv=none; b=HsEWU0De7CfukiV4mz3dZnFazO3bAK6+Vianh4p12IkDRRTp5S+OJ+cCQrOy5/ph+kJyV2nAPFAGM9LTi5DYP2rRqrFMUOEMcem8h9SHNSxIFbzn9drv9A6u3WJ24rEZtgw+7OYmJ6nUGym2mDcV18EWqQfMnL4E0Mw2aUBDkbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209271; c=relaxed/simple;
	bh=pXhxTJRmCl0tPES5ETHnGIYTrV0BhdABM003MDgS2aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGaHSEcUaue2tD78or953rL8cu1E3+LijXVtn93Fe8U9FP1sAJC2XsVxDrjovqP8DYuwRp9iixObXcPDRvrmTcnvJfRZV6PrcX8r8GU2sab1aRhoU3PlS6ttSCWexhVpwcOG7MUDBHqhk02I3Kj6F7ljU28iNEabndjC8tQ5Y5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM7H/fhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM7H/fhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE7BC4CEC3;
	Sun,  1 Sep 2024 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209271;
	bh=pXhxTJRmCl0tPES5ETHnGIYTrV0BhdABM003MDgS2aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RM7H/fhzSDox2sqlMszSs0L1BP4WR1dcb2wD0HsE/EvEbC9fxpVfOffvokHDne3xZ
	 t8UTocGKiQalviPoDTsOfE8ldKhiFBEDqdSsEqXmJQuKQpBwd/W8uDkMhgXk50LziM
	 eMz1/Rxf2DothRSN5pIuiJEQYOmo7HR1bzL2XLbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengqi Zhang <mengqi.zhang@mediatek.com>,
	stable@vger.stable.com,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/71] mmc: mtk-sd: receive cmd8 data when hs400 tuning fail
Date: Sun,  1 Sep 2024 18:17:28 +0200
Message-ID: <20240901160802.763517117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Mengqi Zhang <mengqi.zhang@mediatek.com>

[ Upstream commit 9374ae912dbb1eed8139ed75fd2c0f1b30ca454d ]

When we use cmd8 as the tuning command in hs400 mode, the command
response sent back by some eMMC devices cannot be correctly sampled
by MTK eMMC controller at some weak sample timing. In this case,
command timeout error may occur. So we must receive the following
data to make sure the next cmd8 send correctly.

Signed-off-by: Mengqi Zhang <mengqi.zhang@mediatek.com>
Fixes: c4ac38c6539b ("mmc: mtk-sd: Add HS400 online tuning support")
Cc: stable@vger.stable.com
Link: https://lore.kernel.org/r/20240716013704.10578-1-mengqi.zhang@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index efd2af2d36862..ba18e9fa64b15 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1206,7 +1206,7 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 	}
 
 	if (!sbc_error && !(events & MSDC_INT_CMDRDY)) {
-		if (events & MSDC_INT_CMDTMO ||
+		if ((events & MSDC_INT_CMDTMO && !host->hs400_tuning) ||
 		    (!mmc_op_tuning(cmd->opcode) && !host->hs400_tuning))
 			/*
 			 * should not clear fifo/interrupt as the tune data
@@ -1299,9 +1299,9 @@ static void msdc_start_command(struct msdc_host *host,
 static void msdc_cmd_next(struct msdc_host *host,
 		struct mmc_request *mrq, struct mmc_command *cmd)
 {
-	if ((cmd->error &&
-	    !(cmd->error == -EILSEQ &&
-	      (mmc_op_tuning(cmd->opcode) || host->hs400_tuning))) ||
+	if ((cmd->error && !host->hs400_tuning &&
+	     !(cmd->error == -EILSEQ &&
+	     mmc_op_tuning(cmd->opcode))) ||
 	    (mrq->sbc && mrq->sbc->error))
 		msdc_request_done(host, mrq);
 	else if (cmd == mrq->sbc)
-- 
2.43.0



