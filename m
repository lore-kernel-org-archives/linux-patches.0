Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1FE47A64;
	Mon,  1 Apr 2024 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990785; cv=none; b=Y4llUR4B+o7KyfxjbW7n4nRAeNFPkq8nqwzHdon1Ld/OovgY4F679OHGHOnLmVuzzqWyA/CVfFwYf3GqMASeADDxyvhGnggz8cekZhk8wLcp7CLZC7M7EX1Uqr9k/D+ZTYDVm4g+J2uWFdA9ybrFHUtUMZEzYwxnojOvkBd8/wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990785; c=relaxed/simple;
	bh=Af6UDBI4l/bDbsmmmae6g6t/CYd9P8w7wzE2+0kJp3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5G0iI+fHedMPBax1BLmwHEHyDxDxq6VMquT6AdubrZB1GVVUjoQjQkkM4JwE5pmfqXL4xaWgkbQ0i0mwYLv9YjfrHlQ28sZRqa3VYlKaRrvikWFK6z8ClfP5Ze6khM3A8IYlcME2FDfdoU6porlqae+w070bTYMyyFhouUy8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO4Xakd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO4Xakd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B71C433F1;
	Mon,  1 Apr 2024 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990785;
	bh=Af6UDBI4l/bDbsmmmae6g6t/CYd9P8w7wzE2+0kJp3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZO4Xakd3r523UUemXW7Si79FKZ2oIroNhW1sBXxHRpPp7NKQ043hs4xIZITUDJQYq
	 ClqngPgfkOuJjdiQdYN5W8/CZdxmYP1W2mNvqoNEgD4nBnEt20xpU6LJ2ujVQKWNq/
	 k+Q6XAZf95m+E0c3RBOEG8D52zP/cms37r1wuyDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/272] mmc: tmio: avoid concurrent runs of mmc_request_done()
Date: Mon,  1 Apr 2024 17:44:16 +0200
Message-ID: <20240401152532.615681663@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 437048bb80273..5024cae411d3a 100644
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



