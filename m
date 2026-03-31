Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC113AA4FD;
	Tue, 31 Mar 2026 10:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774954521; cv=none; b=UI7u+TAgvIG/bNL5WuekPhWtk+u5b0yKeCKxkhhcaVjT4iDclgxVw6az98f/EPCtOtzoN4E0Z4PBw+PTzxCjjEKcwXw5/avRULGPI035I1xPZsSUmi4DrWOXnEOunUY0x1DfVklTgtvOD68QsgZwKNBtw8pmCc9jvwoAiF+LFAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774954521; c=relaxed/simple;
	bh=o6dj+O3A9GpRqO7ShnOEb2mcQxz5sY6aPop8aqa/vOI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=dLtbWh7F6fXc+e22G6sQ4Q4T7NC3L3nxCb0Afz++263gb8fS5/pypRyxTqx6uqgkPOZ8AsjvsRic7pNbAzyqCX+McT/RO1Gp1MId4QoHJdp7z74bGRiiqB1sWg0A5Wra+kUYXZWFCs5iduK/2ryawWx23Z3HAKATHQAnP3eXrP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcxbr5Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcxbr5Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F35C19423;
	Tue, 31 Mar 2026 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774954520;
	bh=o6dj+O3A9GpRqO7ShnOEb2mcQxz5sY6aPop8aqa/vOI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=kcxbr5HnXpxSOdHA0d7mOCigpL1NZwvr5dFSiTcEycCchr+RAHW+O6qWxDFZJQecu
	 a8oFiwfGPqS5aSFTQHfdT4y4afNDSclT7b49o9TqfMAVRPuhN2AdDkh0ySSt4aACUM
	 eNlcRMiFaXEDnLT7SU91sX+W0x+OYMfNZWOyTyew=
Subject: Patch "spi: tegra210-quad: Protect curr_xfer check in IRQ handler" has been added to the 6.12-stable tree
To: broonie@kernel.org,gregkh@linuxfoundation.org,jianqkang@sina.cn,jonathanh@nvidia.com,ldewangan@nvidia.com,leitao@debian.org,patches@lists.linux.dev,skomatineni@nvidia.com,thierry.reding@gmail.com,treding@nvidia.com,va@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 31 Mar 2026 12:55:00 +0200
In-Reply-To: <20260324060832.724228-1-jianqkang@sina.cn>
Message-ID: <2026033100-strongly-boggle-9122@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    spi: tegra210-quad: Protect curr_xfer check in IRQ handler

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     spi-tegra210-quad-protect-curr_xfer-check-in-irq-handler.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From jianqkang@sina.cn Tue Mar 24 07:08:53 2026
From: Jianqiang kang <jianqkang@sina.cn>
Date: Tue, 24 Mar 2026 14:08:32 +0800
Subject: spi: tegra210-quad: Protect curr_xfer check in IRQ handler
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, leitao@debian.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com, skomatineni@nvidia.com, ldewangan@nvidia.com, treding@nvidia.com, broonie@kernel.org, va@nvidia.com, linux-tegra@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20260324060832.724228-1-jianqkang@sina.cn>

From: Breno Leitao <leitao@debian.org>

[ Upstream commit edf9088b6e1d6d88982db7eb5e736a0e4fbcc09e ]

Now that all other accesses to curr_xfer are done under the lock,
protect the curr_xfer NULL check in tegra_qspi_isr_thread() with the
spinlock. Without this protection, the following race can occur:

  CPU0 (ISR thread)              CPU1 (timeout path)
  ----------------               -------------------
  if (!tqspi->curr_xfer)
    // sees non-NULL
                                 spin_lock()
                                 tqspi->curr_xfer = NULL
                                 spin_unlock()
  handle_*_xfer()
    spin_lock()
    t = tqspi->curr_xfer  // NULL!
    ... t->len ...        // NULL dereference!

With this patch, all curr_xfer accesses are now properly synchronized.

Although all accesses to curr_xfer are done under the lock, in
tegra_qspi_isr_thread() it checks for NULL, releases the lock and
reacquires it later in handle_cpu_based_xfer()/handle_dma_based_xfer().
There is a potential for an update in between, which could cause a NULL
pointer dereference.

To handle this, add a NULL check inside the handlers after acquiring
the lock. This ensures that if the timeout path has already cleared
curr_xfer, the handler will safely return without dereferencing the
NULL pointer.

Fixes: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-6-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra210-quad.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1351,6 +1351,11 @@ static irqreturn_t handle_cpu_based_xfer
 	spin_lock_irqsave(&tqspi->lock, flags);
 	t = tqspi->curr_xfer;
 
+	if (!t) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
+		return IRQ_HANDLED;
+	}
+
 	if (tqspi->tx_status ||  tqspi->rx_status) {
 		tegra_qspi_handle_error(tqspi);
 		complete(&tqspi->xfer_completion);
@@ -1419,6 +1424,11 @@ static irqreturn_t handle_dma_based_xfer
 	spin_lock_irqsave(&tqspi->lock, flags);
 	t = tqspi->curr_xfer;
 
+	if (!t) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
+		return IRQ_HANDLED;
+	}
+
 	if (err) {
 		tegra_qspi_dma_unmap_xfer(tqspi, t);
 		tegra_qspi_handle_error(tqspi);
@@ -1457,6 +1467,7 @@ exit:
 static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 {
 	struct tegra_qspi *tqspi = context_data;
+	unsigned long flags;
 	u32 status;
 
 	/*
@@ -1474,7 +1485,9 @@ static irqreturn_t tegra_qspi_isr_thread
 	 * If no transfer is in progress, check if this was a real interrupt
 	 * that the timeout handler already processed, or a spurious one.
 	 */
+	spin_lock_irqsave(&tqspi->lock, flags);
 	if (!tqspi->curr_xfer) {
+		spin_unlock_irqrestore(&tqspi->lock, flags);
 		/* Spurious interrupt - transfer not ready */
 		if (!(status & QSPI_RDY))
 			return IRQ_NONE;
@@ -1491,7 +1504,14 @@ static irqreturn_t tegra_qspi_isr_thread
 		tqspi->rx_status = tqspi->status_reg & (QSPI_RX_FIFO_OVF | QSPI_RX_FIFO_UNF);
 
 	tegra_qspi_mask_clear_irq(tqspi);
+	spin_unlock_irqrestore(&tqspi->lock, flags);
 
+	/*
+	 * Lock is released here but handlers safely re-check curr_xfer under
+	 * lock before dereferencing.
+	 * DMA handler also needs to sleep in wait_for_completion_*(), which
+	 * cannot be done while holding spinlock.
+	 */
 	if (!tqspi->is_curr_dma_xfer)
 		return handle_cpu_based_xfer(tqspi);
 


Patches currently in stable-queue which might be from jianqkang@sina.cn are

queue-6.12/spi-tegra210-quad-protect-curr_xfer-check-in-irq-handler.patch
