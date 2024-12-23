Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F857E0FF;
	Mon, 23 Dec 2024 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970363; cv=none; b=LEdb9TsB6j53NZ/fL4VQ7oWvYzABy6qTNjF9PxN7ooa8BMMYq+vifORvRy3iIX7u04aQy4hHmGcAipixbqHlvsnHLvG6aok48Jnz2Pno1RK7/AUTT2WzhdTIQjnbu2NCQtT5GYT/m6le6igZQpyL9/gfefrdRlYHO4hrwMFkdgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970363; c=relaxed/simple;
	bh=rHMQIh/UaeHXbfgnbtwKjrxueJJlVuW1JI3mjMKig5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9FGgW7GJXDcYI+XMrTzjP5jDg0fqLwSQsSYem28XQNGJP1MXpSZqx8gvP0MLSQNYkHH9Z21cSWXhRSz9HW/FdcF+CZaFLkdGr1jDa+XqaKP5idgsPPXQJoBbhuyT4FZZCE1cQgIfTnxEyw9cNeeb16CEuGL2lI4y0nYHwkGImo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR0bPpFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR0bPpFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806C4C4CED3;
	Mon, 23 Dec 2024 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970362;
	bh=rHMQIh/UaeHXbfgnbtwKjrxueJJlVuW1JI3mjMKig5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR0bPpFNKfEHUwQqAdnkbWpxy6dHRGKVjgVqG7MBapg9yQInPLqJuBQFdKtxO2L9v
	 wEZ0b0gq1y9IHjfxlZd7aEUOly7TADcY84iJ+NMuFuT6iy2FPPa3HBZ/RlwIyrsx91
	 B10TMekcX4t86U0qfyOanNj1wUeSaalxMdoLcXH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 059/116] mmc: mtk-sd: disable wakeup in .remove() and in the error path of .probe()
Date: Mon, 23 Dec 2024 16:58:49 +0100
Message-ID: <20241223155401.860270567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit f3d87abe11ed04d1b23a474a212f0e5deeb50892 upstream.

Current implementation leaves pdev->dev as a wakeup source. Add a
device_init_wakeup(&pdev->dev, false) call in the .remove() function and
in the error path of the .probe() function.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Fixes: 527f36f5efa4 ("mmc: mediatek: add support for SDIO eint wakup IRQ")
Cc: stable@vger.kernel.org
Message-ID: <20241203023442.2434018-1-joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2862,6 +2862,7 @@ release_clk:
 	msdc_gate_clock(host);
 	platform_set_drvdata(pdev, NULL);
 release_mem:
+	device_init_wakeup(&pdev->dev, false);
 	if (host->dma.gpd)
 		dma_free_coherent(&pdev->dev,
 			2 * sizeof(struct mt_gpdma_desc),
@@ -2895,6 +2896,7 @@ static void msdc_drv_remove(struct platf
 			host->dma.gpd, host->dma.gpd_addr);
 	dma_free_coherent(&pdev->dev, MAX_BD_NUM * sizeof(struct mt_bdma_desc),
 			  host->dma.bd, host->dma.bd_addr);
+	device_init_wakeup(&pdev->dev, false);
 }
 
 static void msdc_save_reg(struct msdc_host *host)


