Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D7F47D46A;
	Thu, 20 Aug 2026 16:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244044; cv=none; b=HLROa+EHk+krsI6bXi+ZVQCBolC4icJy2mhtxwJcHLuW3PDBTyQhN9dWxqKMqP12axmm/Lf5M5mfBCkMLnVXGTW0h6R2v0+gnqvtR9dOGcsu+W+Wo0XfsDmXg64tcUMA2AC9/PAoCD2fE9z7mDCkr+r8i+ozwMk/0xfz0xRxDyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244044; c=relaxed/simple;
	bh=d36LuzScmqEfiXvt21BnoODWsjKK60WHGm+M1YDPFQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW/yEFf8ntQj4flPza20TAgz4GrhhBtEc+G6Y3yhSPpo8g2bQdD9INfdgxa1Injyz069FBqlqRWYzCf+5Vz3i1X2SayzKf03T7255IbPwwDGmono5SCBhDzuYKGuc5Tmr3Ohwb6tSWlBlPsaa/QluC5AdsL/4x/16zvm/TRZVao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyq4Dalu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyq4Dalu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41CF1F000E9;
	Thu, 20 Aug 2026 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244043;
	bh=yQoi3X3ggXwoLLIXuaWB/+FlpwUwcUkzWxv4kAJw9hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyq4DaluhBJwrSE3m8MTHfB7g1zskbTSUWtgpzS9amyNa9A5urOBJXGARWHfU9ks9
	 LprYQQpR+y0X+AqN6R6YRf1mZYr9KWNozg9xQ2kejhIKBGaV7y2m+spowR3TWAQvAb
	 vjgtiXq1PXf0PDbHOmGi3KGS6s3i6Yz3UtzhxBks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 032/235] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Thu, 20 Aug 2026 16:54:28 +0200
Message-ID: <20260820145217.409503756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -2629,6 +2629,8 @@ static int atmci_remove(struct platform_
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	cancel_work_sync(&host->bh_work);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(&pdev->dev);


