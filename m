Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654FB1A072D;
	Tue, 27 Aug 2024 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771626; cv=none; b=rlP+W2G8LPev4cTWVd4Pg0DA4PlOv7AiEBM72rqVn4Mfl+roR9Eg9wyy78hIVb2UsE32mT43k/r6au4jAcsgm2zJdbC4nj4RyQKN2FJxNe5RbOB4dpitoCe9K7IPRKKjpkQ4vGoNa8WycGzbfL4C0QH1CcO2Oq5c0qC7T6d8a0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771626; c=relaxed/simple;
	bh=8pSx9FrY4vV0MXxEi7SztM2F7cCdpK3M+bnUVISUv58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmIE85fAyHeIEPex7IGXkQwrRMpe2VxsB7tKlknIegu+i7NU4RCQxmgCV5rxd0A4+0wZ4sGzD/qNJBo+5M1NYCZ8bIDLgP5LsQGtRlkR5cMNhR0oTewqzteciqHqqOgufggYu0cOUG89HPV5dmftJKT73MxTuKcIAHjot9eiQS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCTBIAKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCTBIAKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C572FC61064;
	Tue, 27 Aug 2024 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771626;
	bh=8pSx9FrY4vV0MXxEi7SztM2F7cCdpK3M+bnUVISUv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCTBIAKF9Qc3dkUWbvZ8osSdMQ/M48Fs9uS9uId47Y4LqmXBR6w1NIrmalcl/hJ+L
	 UwTT93gtdITLaQ1sSSXnWlEDILi3/Pe06vtTZdzSo1xdqWUk0EhXzG4rU6795Cwdid
	 EZ4/Q9Oy8MM0u2q+YNBj0+Uh7ZztUcXveGZmDjfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengqi Zhang <mengqi.zhang@mediatek.com>,
	stable@vger.stable.com,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 246/273] mmc: mtk-sd: receive cmd8 data when hs400 tuning fail
Date: Tue, 27 Aug 2024 16:39:30 +0200
Message-ID: <20240827143842.765652097@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1230,7 +1230,7 @@ static bool msdc_cmd_done(struct msdc_ho
 	}
 
 	if (!sbc_error && !(events & MSDC_INT_CMDRDY)) {
-		if (events & MSDC_INT_CMDTMO ||
+		if ((events & MSDC_INT_CMDTMO && !host->hs400_tuning) ||
 		    (!mmc_op_tuning(cmd->opcode) && !host->hs400_tuning))
 			/*
 			 * should not clear fifo/interrupt as the tune data
@@ -1323,9 +1323,9 @@ static void msdc_start_command(struct ms
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


