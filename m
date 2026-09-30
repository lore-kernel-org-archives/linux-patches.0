Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589A3CC300;
	Wed, 30 Sep 2026 19:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796365; cv=none; b=agC4o8aYfnQequfYC1NR1EzGxHPy5XZvTBRftKLZJHoSSLr3BloJ3CrDHVbg9SoiMscJFfVrxLaK/OTa6VK1y5Tqilk3FTOud7wDl577deisL2kp/Bjpq+MLZ3pHkJ0RvVX2uNO9fidoS7xbnRlvABOwYii8f5cCSiZzn5Jft9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796365; c=relaxed/simple;
	bh=N2EMjOdBaUIxWc8gx7acs0LXGxXCb60QOmbMeFHlNDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjTwfBNnTtWoZt/BFokD+khyTXqpSI3rqALFMB6GgnTwD9330wjKMy1hXHATvIFO9M3W6yBrbk+Vd46zuSNLULwqg3WVb4SlxQv61BpGaqKhpfNKqUJilyO5wXdBU62eTKOESJTW7BQSUI/YPfXh0Ook/DOZ4xGsUnqMVnE4gwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ham4Jd/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ham4Jd/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A7E1F000FF;
	Wed, 30 Sep 2026 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796363;
	bh=NttZ3MHmfrV0T3GKg7Y+DH7d7LzS2//6SZJUTVuXn2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ham4Jd/ecJ4zZrok+Py3pcvKtq5CeGzDQ/9+5C5CForzr9nnCY5jZ5XVM8MYlM5GJ
	 eHzeYDdSy9Db3PhehfoGy83Z1KYc8c0A5nATqnGTy4Bqr1KukJ2k2gFdG04YL7onwI
	 AK2RwHuee17TBZBTSPpZEH0DLg/Tm9yDLZbi3H4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0886/1193] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 30 Sep 2026 17:26:10 +0200
Message-ID: <20260930152453.930897186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1169,6 +1169,10 @@ static void mxcmci_remove(struct platfor
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


