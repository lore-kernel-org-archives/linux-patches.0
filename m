Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDDD5111AE;
	Wed, 30 Sep 2026 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783572; cv=none; b=SR+ZVW3Gj2TiHzrH/TN9mvP2tuG+/2TGNJ6hg6qdX4oi/n8ddCX1jM4sIFzRXtVCs76JIbeorX5I/xEIhjCIXyYxQp6isVnzqc/6W2n40wo94CMw0aVK0+csiKZ0aBkkg29Ei2KqN7WJBIPgWDIKNKtp52S51VNBRvHnyC9/cI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783572; c=relaxed/simple;
	bh=LitCqbM2BTyE05G4VfdQXoe8tkjfTe8KppqgnFGvJk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teOr9k04GQk2oU7d2LCp+pzO4/JgaYewAddNKV4DuT+wkqFFPFknXT+FpvpCg5FZPrJCB20J24qNWKy9g7E2p8grnLWCNwoQhiYxJrzKqjR659TGv870vQi6Jp9Ei9F263yawWTdnDQ8NFBp3hGGXOm/Wl+S8xtj9dNc1pb5KSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL1i+N79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL1i+N79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525361F00893;
	Wed, 30 Sep 2026 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783565;
	bh=GFI01457dPrZnZKUCnd7E/B+0YfB7KcEFNCbmLFkICI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WL1i+N79AzZYqoeqhFK1z59m5obkbcG0OExn32UFEieU0VIDZOzGHx/O2N87mZ6uL
	 xU/PO5i8Mh9wew4asZHMu/+KvEpnyVJQNg+tTY7pVHfuuOonPn+BBhtSPL3ZNlNEwF
	 PK43rZtJmnfG65pS0Mau/ONe1162oB/sNXAfCFFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 442/595] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 30 Sep 2026 17:25:35 +0200
Message-ID: <20260930152357.188051204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
@@ -1195,6 +1195,10 @@ static int mxcmci_remove(struct platform
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


