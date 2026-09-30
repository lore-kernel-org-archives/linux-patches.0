Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E0A5111B7;
	Wed, 30 Sep 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786077; cv=none; b=sqyWPm2kh3MZxdNObWauDzoGoop3jmaSFMlo2KiV/ZnhlQe7qyPl/Qtt+a4GcefJM1u52GvQyay7SUroQrC054GFx5EFYaxxsmws/dSwm+gKLsbJKFlpnR+7+cIBMkq7NiCXwhgXoul4YxqLPOXwJmJeFXh5xqfxRPQBYxIvArQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786077; c=relaxed/simple;
	bh=zLEfxhmVrmnOfv0n1qaVfKixvHOGWwLV9diz7Xa8S2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlKdZwR3fq6jYwdYJFoEivzBlcfZUUAyZ1zWPMi8foQcupj+gxQJ+F3mr1m2qmdEiBQyukwbWCxciUgNaehKeZIdiNauFDbsl5UzO9padEHprY4Y4bhyi1G+aC2wnRM1LxEDviy2uVI/NWrBQLnwHBmz9G0MiafbxiQp4r+BhYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DACu/bY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DACu/bY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0BF1F000FF;
	Wed, 30 Sep 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786076;
	bh=zSWfSuaR1XHGpmrTxRvP11r8+LrWREdpRDQgmWdEi7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DACu/bY2j+4Hrok1NdghwfU0j2GbSfTrkiM8HrjgcvaDJjCVmQGuwu/Wd5eSImrAk
	 TSQTp+f/s+b7BiFB5cW1l7iPZDeXVxD6gHk+24U4Cgjh6Y1mAKG3kLo3ctsW4Y668+
	 BfdIsl5e8I0+XwNKfEAjWLHsFmPrzyd+Lu6SCSOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 732/982] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 30 Sep 2026 17:24:28 +0200
Message-ID: <20260930152432.477646238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit d3a421c82412344022982d5b91ba23194a0a6f29 upstream.

mxcmci_remove() frees the host through the devm tail, but neither it nor
mmc_remove_host() drains the driver's own asynchronous state.
host->watchdog, a 10 s timer armed on the DMA path in mxcmci_setup_data(),
is deleted only by the DMA- and IRQ-complete paths, which the remove path
does not explicitly drain; it can therefore fire after the host is freed
and dereference it in mxcmci_watchdog().  host->datawork, armed from the
IRQ handler on the PIO path, is not cancelled by the remove path either.

Free the devm-registered IRQ, then cancel datawork and delete the watchdog
in mxcmci_remove(), before dma_release_channel().  Freeing the IRQ first
keeps a trailing handler from re-arming datawork between the cancel and
the host free.  Both callbacks are non-self-rearming.

This issue was found by an in-house static analysis tool.

Fixes: f6ad0a481342 ("mmc: mxcmmc: fix bug that may block a data transfer forever")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mxcmmc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1171,6 +1171,10 @@ static int mxcmci_remove(struct platform
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


