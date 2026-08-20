Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE682931C0;
	Thu, 20 Aug 2026 17:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247439; cv=none; b=fk8wTd6HxCb2zkskdzlVzqXDkd+p95M3/iDD5Q2Og0H8B14Odi7+0DrFieZ4/3PInUOIPlyqR0NB6cEhEC7FyCtlK6uqBKHdzhzQTehCUP5D2jIeL87hai+ahUQxloPZZUlosLpcH1GVWipBSQ+RtNa5Lin1TICAEFAU1skXHq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247439; c=relaxed/simple;
	bh=vc1i0gEigr7ZomkjQiQdeGMuoNI70v/mVInARZmgqEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFl7Ay1+CtqVvdpXO7S97vSeZKJb7fxOoptDrvgXMiDVv13MnF+ZZsaFpFoouG+uZKDVBArFe6BDeZMey3tGuofRhADn+F4l3XIoGpBKRqF0cxo5m8gB57X5IgNXgVMYEDYlI9P8agBkLmlU6COceoXshXp+iIUeXa88P8Ri2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skByNMqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skByNMqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375F81F000E9;
	Thu, 20 Aug 2026 17:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247437;
	bh=+LsMva9JfldiJc1A8iTKvSEmM1i9PuhBE9lSfLevNOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skByNMqGUCE9QF5gAxqtrV3Hg2ZRJl0eIkqPf4/oapZtREkhUwdeBvxuOvfgj82vH
	 v47GDxadEl75tXhJ3N4xZDgduBGsxx1DNUMA7BIyBrOeb6iZw7WJuhKKPhAeFFEMPh
	 KACKTgNbFbL54YGRPPPSZ3cYVm7/QazMZjgTF0bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 047/166] mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition
Date: Thu, 20 Aug 2026 16:55:06 +0200
Message-ID: <20260820145212.581371072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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
@@ -2658,6 +2658,8 @@ static void atmci_remove(struct platform
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	cancel_work_sync(&host->bh_work);
+
 	clk_disable_unprepare(host->mck);
 
 	pm_runtime_disable(&pdev->dev);


