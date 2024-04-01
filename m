Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429343AD6;
	Mon,  1 Apr 2024 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986795; cv=none; b=WtbK4DTsyRIHKEwFg9UBMgRBUWxS3SR/Sn0rux14VbYUXt/8yNYoxmPTnsEYwAjtvApKUTBzNmFM/9gT5G1I8Ul0x0Fl7Ze5LQ5FHCEA35R8gik+dbLtuOE+CE4GMS218XSmF7Y9Pl1B5sRVUwsksVdiqofxq4Xm8fFxG/UtFUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986795; c=relaxed/simple;
	bh=HuArS19Wa/ETtVtsMvRHcpCiGUdU2l0Cr4LhoKXuodI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeF3lqUrDqyF62SoW1d7z5Fk3P+/oZp9VRrP0z6MheHbRLqr1iC99N/rKgSPK6E4WlqTzpjXSCWrWj2PFtLGhjp7FltaKpv/wIGpEEIaC+rKcUf92Mz4h6KABLx/UQtvowfDbfCBUyjstmf5fDmm+gyMUVL9w2cJtYrOMyF3d0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=104Mtlft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="104Mtlft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA310C433F1;
	Mon,  1 Apr 2024 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986795;
	bh=HuArS19Wa/ETtVtsMvRHcpCiGUdU2l0Cr4LhoKXuodI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=104MtlftbMP1+7arbYPVSRt8hBl1fgLM2ZN009apNzMAtJCBeP3hREQQeAAR5YBv2
	 ZV5PnGA2ZbrdjYplQrz0xHSns8j3tbbVZo6xNUyNCfB0F8KuSh8R0mU40fwbmbcNjK
	 zaik3Xn55UnEA4vwfjbx40HVliYJpSCNtzm86ap8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/399] mmc: tmio: avoid concurrent runs of mmc_request_done()
Date: Mon,  1 Apr 2024 17:40:53 +0200
Message-ID: <20240401152551.776267580@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit e8d1b41e69d72c62865bebe8f441163ec00b3d44 ]

With the to-be-fixed commit, the reset_work handler cleared 'host->mrq'
outside of the spinlock protected critical section. That leaves a small
race window during execution of 'tmio_mmc_reset()' where the done_work
handler could grab a pointer to the now invalid 'host->mrq'. Both would
use it to call mmc_request_done() causing problems (see link below).

However, 'host->mrq' cannot simply be cleared earlier inside the
critical section. That would allow new mrqs to come in asynchronously
while the actual reset of the controller still needs to be done. So,
like 'tmio_mmc_set_ios()', an ERR_PTR is used to prevent new mrqs from
coming in but still avoiding concurrency between work handlers.

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Closes: https://lore.kernel.org/all/20240220061356.3001761-1-dirk.behme@de.bosch.com/
Fixes: df3ef2d3c92c ("mmc: protect the tmio_mmc driver against a theoretical race")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Dirk Behme <dirk.behme@de.bosch.com>
Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
Cc: stable@vger.kernel.org # 3.0+
Link: https://lore.kernel.org/r/20240305104423.3177-2-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/tmio_mmc_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index be7f18fd4836a..c253d176db691 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -259,6 +259,8 @@ static void tmio_mmc_reset_work(struct work_struct *work)
 	else
 		mrq->cmd->error = -ETIMEDOUT;
 
+	/* No new calls yet, but disallow concurrent tmio_mmc_done_work() */
+	host->mrq = ERR_PTR(-EBUSY);
 	host->cmd = NULL;
 	host->data = NULL;
 
-- 
2.43.0



