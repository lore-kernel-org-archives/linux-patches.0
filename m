Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8614312831;
	Tue, 25 Aug 2026 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666494; cv=none; b=mQ1oyhJ/Oo7NcjXDKcXHe0yoj+Lc9ifA7+yaAknf4t0sZ6JSGPX0OqPVdKduy1hgzw9EkFASWodOPoKcxT6+/b0HyIDdukqJj9TpoISGaZjpmNw323G971LUe/3pc3nIhg4q3ZNJ9vUHmvdwcPV5slAvfBKIumvVJiVndSt3X9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666494; c=relaxed/simple;
	bh=Kpstku6TqD6phCMvd9bTfbFq8pd+sAXMdLJY7R6YVPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ba4StOYgGF6qLjM0USlTmlIfWBypU/0mS0hYrEWL7W7nuEMim1+yulaTJebYQ9OSIVGpa65JIrBIqp35ZhY9S73Hl0gk4LXF9Ky+yzO6WUc3PU9Xz3DU6HbRJME94KU+1I87Q/oyxmW6svDTZ1/w7YtF5a+FLFT7umrOrbLklp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eok0XTuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eok0XTuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2175E1F000E9;
	Tue, 25 Aug 2026 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666493;
	bh=dA1FPQwycExnVOTzMIGFv6+HfC/SMv1BMQGGnlaaEOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eok0XTuPtIcEK2Py8A2nXQqvzbb1bEW/miJbKi65DHlVMS4grnN+J/dyIuRK4iMPi
	 HSj5401CUCImohEqCcfTT+tcM2oFawpMmoqHr0wgV+Fzd4tJO9hHVZCwdogJkMfrVG
	 0M8tXaBkDhGja0KOERUYkqGvqjnGq8q7wZdgvzp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/57] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Tue, 25 Aug 2026 15:26:48 +0200
Message-ID: <20260825132542.332236156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/atmel-mci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2629,6 +2629,8 @@ static int atmci_remove(struct platform_
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	tasklet_kill(&host->tasklet);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(&pdev->dev);


