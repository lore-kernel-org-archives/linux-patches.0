Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32413C3F7C;
	Sat, 17 Oct 2026 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259432; cv=none; b=D/AiWrAZ59RXa4zrmLH6aXW55Gy05f6qTMRuIMKbhZcmzvEKQSmIWZZyg8FzRLu3sCnHgxLbAQPTtDemZQdqQtFnJQn0oArYD5QqZuI9BSUJ4QpiJ1ClUMAoNoirvbCBjVra0X5a4u/0mQ2xhgHMG7bSWfu6yzUz6IMnF/+2fDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259432; c=relaxed/simple;
	bh=DqHh2PWOCsMCSadK9zhmMhM56wCnrzMhUdokUCHE2cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V53pc4EVIFthhcNv0AJPk8acqj5F6vX6Wkv15x5bERXn3jDJB7KPlabpIcI7l9Xxnppll25zJv4hWHKcdX/OcEZyC9L9yBobi1zgreq5E5iwcnwdLsG6jKzg0Jpmn4F/fQ6a+I8FI1OBNK4xV6DtVKLziniLe1jxp8MDtjTYfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bud+zEbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bud+zEbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261641F000C4;
	Sat, 17 Oct 2026 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259431;
	bh=9I8hyRNzhL1rJmA4DSvP6nau6VvbDWqE6/warXaR538=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bud+zEbl4B75RgaHHJ47pciVvDkP7oLI1qEIVjYUkFpipgkFSNrPdaJ/VQPc2aBVg
	 BkR5NFyEpOrFe86K30WYhn9ec4VdDV6jut610ZI20Fw7JUKXoItiNMi5t+862/XjCk
	 CtZnMkBbXZsrGsBOuNBn7pho9rVoT/hfNozWSQcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1212/1674] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Sat, 17 Oct 2026 17:58:04 +0200
Message-ID: <20261017160502.246869347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit c125ee35a49a0518521b52b27631eef061b8719a ]

In atmci_probe, &host->bh_work is bound with atmci_work_func, and
atmci_interrupt, atmci_timeout_timer and atmci_dma_complete can all
queue this work on system_bh_wq.

If we remove the module, atmci_remove makes cleanup and the memory
allocated for host with devm_kzalloc() is released after the remove
callback returns, while the work mentioned above may still be pending
or running. The sequence of operations that may lead to a UAF bug is
as follows:

CPU0                                      CPU1

                                          | atmci_interrupt
                                          | queue_work(system_bh_wq,
                                          |            &host->bh_work)
atmci_remove                              |
atmci_cleanup_slot(...)                   |
atmci_writel(host, ATMCI_IDR, ~0UL)       |
timer_delete_sync(&host->timer)           |
dma_release_channel(host->dma.chan)       |
free_irq(platform_get_irq(pdev, 0), host) |
                                          | atmci_work_func
                                          | // use host
// devm resources released after          |
// remove returns, host is freed          |
                                          | // use host (use-after-free)

Fix it by canceling the work after all the sources that can schedule
it (IRQ handler, timeout timer and DMA completion callback) have been
stopped, and before proceeding with the remaining cleanup in
atmci_remove.

Fixes: 7d2be0749a59 ("atmel-mci: Driver for Atmel on-chip MMC controllers")
Assisted-by: Codex:deepseek-v4-flash
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/atmel-mci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 45cda1248816c..8953244a4aea6 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2658,6 +2658,8 @@ static void atmci_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	cancel_work_sync(&host->bh_work);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



