Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523CF4E1C81;
	Tue, 13 Oct 2026 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895804; cv=none; b=JNgGOFQIVhRXC1eVjqngzvgTqqnAUd42iehg0YTVE0oyAIg7Z7v+2fBkZjOcq+2Pcd2RIBrZLOCw002mabQq17NNOUL1K9PvlJmwOAV0oqOVTPH9RCYX2RYwflCZwFErbt8fiNjFU8rAFW4hQkWznXDzBKZaY5UVCbRRu6lliL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895804; c=relaxed/simple;
	bh=QuornfreRw29BuRU+WX10skBnIN7he7Yj+ipDAuEo3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lURZZpLH+Kj6JUhJM+9zrCTgQo7p6+HiTfQwId0//QOef/fBVbx41rgb2GC7d2Kb4b2/z1sH9kdb/Dac8EJ5YThEoi5m6qCPZRkW+t/4+4t2tEYRM28vtlqmDQS+klZTRgdu0q4GL9jU9hW5gxM+lZuxKRBBeYwXH+HLK+l9n4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cc/gEdTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc/gEdTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C991F000FF;
	Tue, 13 Oct 2026 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895803;
	bh=bXVEOo5Ak8bh438yjbJPKwiFixaOQ4MtteuFIST7tDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc/gEdTVQhgY7bM1DNVQ24bnFlzaBW2FNujDxSvsb0XrWtMvCWx0a1L/fkqCFCTql
	 r7rmZAgkdlkEbT1+cgMzt/pcgJ4OnqbNo1p62Gmf8nGy4qU8EAHCC3F8QdqkLPm/pv
	 fy3BPjgs+43ipThAP6yV92dCYRguexPI4rkfttyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 397/497] mmc: mtk-sd: Cancel request timeout work on remove
Date: Tue, 13 Oct 2026 13:39:24 +0200
Message-ID: <20261013112917.314538981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

commit b38af5386a74416e898955443f2e26547b358cb2 upstream.

The driver queues req_timeout while a request is active.
msdc_request_done() uses cancel_delayed_work(), which does not wait for
a timeout callback that has already started.

The timeout callback calls mmc_request_done(), which wakes the request
waiter, and then continues to use host->dev_comp and check the SDIO IRQ.
During unbind, msdc_drv_remove() can return and the managed mmc_host can
be freed before the callback finishes.

KASAN reported use-after-free accesses in msdc_request_done() and
msdc_recheck_sdio_irq() in each of three unbind tests.  The same tests
completed without a kernel diagnostic after this change.

Call cancel_delayed_work_sync() after mmc_remove_host() has stopped new
requests and before the driver releases the host resources.

Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2974,6 +2974,7 @@ static void msdc_drv_remove(struct platf
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


