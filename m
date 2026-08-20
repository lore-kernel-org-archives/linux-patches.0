Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4F352019;
	Thu, 20 Aug 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238257; cv=none; b=csAEi+mzp+g7YoZ23kDuU1DX2P8yputt13je9I0uol0k6XAgUBe/tpOoVPpJ5QdtFpIvHPntEyMa4UYnhnGgbpj9mdMGrphsYpisec4w+/hKTgc8taTOKpf+d4m5LmpOf7XLKvYSTgSmFWq/4SFZXb5qU4wnxXqBXUs83mwuhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238257; c=relaxed/simple;
	bh=a96NDKCMWodOGIuF2yCwgkvBi2S1LDYGtoDx1g/3l4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8zJTHdjhSscYL38sYAHiTXttgwnVv8a0rJkRb3QjVc/JzKzKeReGdY5SB6ZhfW+7pe90Ge7VtPnvtOGHNR9GRCBqF8WhMYRko+SwrbsxDFE4Oe32GxyZtwfZplo9Mk+6KGEVFbGqwN9HSG9a6hdid4Gfp+J9TeV/X6ysJ9+OVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNoOaVCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNoOaVCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D534D1F000E9;
	Thu, 20 Aug 2026 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238256;
	bh=Yl59gZc9aAbVy25iKbuJXjLuTgSXu/3Pb1wSiIftVB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNoOaVCb6uGhxtXSS4AJ1GjxiX7v/B2tLGmJtqB86X1kEAlEz0hBHKf34Bmf6OMfe
	 8p81IEO1G5UbYDjSX/Ai9b83f1N9eVyw5RCyzYtcVMqkg47Rl6lLJcdPJOXGFfPQpA
	 8hoKqgFAUm+R3v+RwoXEeGno8Ag58mKvhxvDhvDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 084/228] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Thu, 20 Aug 2026 16:53:46 +0200
Message-ID: <20260820145247.199507663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2610,6 +2610,8 @@ static void atmci_remove(struct platform
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	cancel_work_sync(&host->bh_work);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(dev);


