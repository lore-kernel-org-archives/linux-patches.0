Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4D440A16;
	Wed, 23 Sep 2026 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175095; cv=none; b=iHMpYcck6uSyNCaYnHlZZyl7D3xDPHh//ld48PgxuI8Bp1Ww2eWvC/2dFp5Gh7r1R4spV/lh4BnBWoyq7aVyab4HN0J160VaNc1Ec8OOjG19WrOniTsBB21Wbc3y76CByUBCJ0GiCRSyTyAkboxvaUdlqsaHRAJOcycQnHafVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175095; c=relaxed/simple;
	bh=pMU7Ic4tzUeoUfXzIHEB08cJaaEIAWT8VsCVeCMDDwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi6b7cXvi6Mf5dLY4BKVx7XO/Lw/JCs0jzvFJvmUnBLBVgleJhnoKa2y2XqlaleSl/xocShnpsaEeQv/9xy0hV14/CZ40Nl0jvKXY3EhVxR7DqC0+YkSGuHnoebPQwHc7buTyLzDXfQzh0P3qjWaXHrCSpWSEyT7CDAcIHBuXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myNZoUab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myNZoUab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834221F000FF;
	Wed, 23 Sep 2026 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175093;
	bh=8RFTf8Y+PdtxLNv5PxSrdzGRlT6p+TRRVaE45klBi/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myNZoUabRFnTfpq4R7zy+47R5NUNfbzs48F/mlogOoQXWL3d6LFoV2v8UF6nlzyNF
	 e6fpLeRnIz1drT+xyXOo7qogkM1xXvrBRMnDpFRS7Ue0K0xLuAuFpfzpQ15DLOuJBP
	 +i7v/7bMSExvWzMxyAoJXiDhshM1TLiJu7Z0segQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 284/398] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 23 Sep 2026 16:05:58 +0200
Message-ID: <20260923140650.779056030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -1173,6 +1173,10 @@ static void mxcmci_remove(struct platfor
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


