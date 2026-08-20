Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886737EFFE;
	Thu, 20 Aug 2026 15:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238876; cv=none; b=u6GGCDSXtropGVct3xJcLkvj4zat5y2OfUAetKKZyGAXDNrHWycbQ9MiFmPg/Ub1mxqm/GsrA06E0B1DuE8k5/1JfYSZsn/55Uq4+pi0lXMzkZdVqG/isEUyisngHfMyA0u/ZgznyAAr05NfrQHSBNWWzzJ6ElcCwgCgmonLoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238876; c=relaxed/simple;
	bh=8aaJNAe/qG06ugJWpyUz1SKSFktiFUsjJhYbm7X0vNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayJKVlh0Fvv+HVrmo0ErIg0dMXmUw6l/41crXtD2EkJhWJl3LDIvShtmWNJs6kCtDP0vol5ApW3FBaYm4lKLK0RDpfTObcXxraM7vMR3GwmmdDuuPCGmbOZzAQimF82kG8UdBuk8CrIAEqm5hUrZspgzp1sy7GtJEk+US71Lsuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRl9IyPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRl9IyPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FC31F000E9;
	Thu, 20 Aug 2026 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238874;
	bh=HtuA8aAryDezd1B+AgET+hifZqRS7V1azqqm9gWeXgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRl9IyPXWImfUZpX5Oy3EI/vk5WEQblR/g5gXuuBqY/D3GH1/rGAPDcZgsBtDfxoL
	 3b4MXoGWyZYG8oNJz5gVuhyGdwcMIWiTkTSGoEFlowAp4lsctfYAawvOiXLY0QjF0O
	 LXX8gyeUY8Tf8CDJJ6evXhfuC7pht4fNLSTwtiSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 070/217] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Thu, 20 Aug 2026 16:53:58 +0200
Message-ID: <20260820145239.728958689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit c125ee35a49a0518521b52b27631eef061b8719a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/atmel-mci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2616,6 +2616,8 @@ static void atmci_remove(struct platform
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	cancel_work_sync(&host->bh_work);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(dev);


