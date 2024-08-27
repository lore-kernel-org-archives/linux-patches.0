Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B8C1C57BC;
	Tue, 27 Aug 2024 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770689; cv=none; b=h91Go94/npzYW4yogGDYFNt8xj6ALibAb9iWrIG9jxC8DwdPLHRzn43M3OwCUpSphwJp2GfQf7mmBvSVwlV4+fMwXDJcWIPaUxD4oZ58V82M2hg8wzT48zZ0nPlC9VSI2mUHFsClZVpUm68f738tUUwWCZisuzGtQNcVpQ/g61M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770689; c=relaxed/simple;
	bh=6jDfW4Csqf9qmEG06euRkFvHKOixTBew3lmAWpfPT0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfV8lT+O9PDxDWLKaxkz/7rZ3yVmgAq/fZRLeU+B+yqMImppsz6shcXri5R7Of/Btrm3DQX3rKx87oSAXtKnZV7iUGWNLwncC25t0G20QUIPIrptwtY+U7yP2J96ZDS0uqsvwZRFEdw47UCllDYC8FLhWEHSJhzk7WIdHFePGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eptRqwbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eptRqwbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381A1C6107B;
	Tue, 27 Aug 2024 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770689;
	bh=6jDfW4Csqf9qmEG06euRkFvHKOixTBew3lmAWpfPT0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eptRqwbUvAkOSm1r4sXeklg697HWdxy4f46w0pivHv5iezRPqbpowGJ1DEyt8BrAc
	 LJrIfsrAon70Qhi2MARdSvoK4lfvJERpMPn0BRqOPcIQL9bj8Nluft7TZJvF1g1c7l
	 yE9DJE0ujgW/4NtMD7Xi++tLUKFQIEnngoPrhpIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengqi Zhang <mengqi.zhang@mediatek.com>,
	stable@vger.stable.com,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 305/341] mmc: mtk-sd: receive cmd8 data when hs400 tuning fail
Date: Tue, 27 Aug 2024 16:38:56 +0200
Message-ID: <20240827143854.995313695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Mengqi Zhang <mengqi.zhang@mediatek.com>

commit 9374ae912dbb1eed8139ed75fd2c0f1b30ca454d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1222,7 +1222,7 @@ static bool msdc_cmd_done(struct msdc_ho
 	}
 
 	if (!sbc_error && !(events & MSDC_INT_CMDRDY)) {
-		if (events & MSDC_INT_CMDTMO ||
+		if ((events & MSDC_INT_CMDTMO && !host->hs400_tuning) ||
 		    (!mmc_op_tuning(cmd->opcode) && !host->hs400_tuning))
 			/*
 			 * should not clear fifo/interrupt as the tune data
@@ -1315,9 +1315,9 @@ static void msdc_start_command(struct ms
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


