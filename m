Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA93769FB;
	Wed, 30 Sep 2026 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788720; cv=none; b=ozmcjNYn7FzIZKk9hmXmpwKJ4wkmvaTpkzYgMCaSrpGQtxjTKNOAeVw2qqyTW3rEkYpp9+PHWsF6h9dO+9bml+buO4TpQSPgtEpDUGn6hwB7X4okIt/v8YKSElznWNlXKr4hWM4VdfurfBUxEQwyvHrjUpaNew1d0lnquxqU6fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788720; c=relaxed/simple;
	bh=Y1fBKkV8rRQ3oRwXyW1h7Zb5M/u0cyc0ciu21T47aEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m37drRf8bbJ4i15uztyydBgnSyboqlXD6ecr/ptYnedKFbzhK6UgDBzybWWfbnC7kYTqVIAeGJdhG0Y1ESF7lGP5vugmQPwg87e0jI2RAQ+7pExS6URVoxAi2rc9jPi82DNEv4XRZy8iw3SdZlKqtz9T6vsmFcY8t9u7Z9haMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfJayC76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfJayC76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B506E1F000FF;
	Wed, 30 Sep 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788719;
	bh=8u5cxSgnrtUzJpKNrKQLhRzbNnmlw4pTcza6EunxGMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfJayC76mmcA9+tUDt2ddtmWR4xlHvN/qdhcdrAKpXxl/37doUJAjStAWzNajt6C2
	 nLm5NqkSkthfXg4KkmAe2ICIWxRbXvkgwMg+p/B5y0CVf37XhFnuopp+LFB6pbKHSG
	 QPsuzxuPtVApXlg8aPt5NoEzfnV++nRHpwLU6gnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 225/877] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 30 Sep 2026 17:18:56 +0200
Message-ID: <20260930152419.583474945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1182,6 +1182,10 @@ static void mxcmci_remove(struct platfor
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


