Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF85A3CAA39;
	Fri, 15 May 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861213; cv=none; b=jW1PTa2+hdM1eFsxTR96TNZNR7VVrRPp/bbbSmxsJb4CNn7keondocIwTdGFmNz5Sq9hh4UdltMCJIWJGSX7xhmbNuZEBLhtBYUyxLuNLksIqBdi5zyXT80LdtpITOC0DchuVolwovQMIweJzVzog9dpWlrnB50oUoiYMM6KaKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861213; c=relaxed/simple;
	bh=SGh9FpTJSjqv8YIKoBmsDa5DwlhohzlgqSmeQWin9cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn/HvSbWMtQqYT6tcEtQoPTm4Op4RPG7XeTa+RZ7f6+9ZBXJg/QRvzbHQhcvbzBzwzXEG4/anE2aHtj87aPTY+WHEHRQVCJJI+J8SK6zL6gQgyva8KD3+trF/ncPa0TCFGY15e2C5yLC0MzhIIUEYaTdnT7SU0hAOOyBFk1WHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUFWqyUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUFWqyUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4407DC2BCB3;
	Fri, 15 May 2026 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861213;
	bh=SGh9FpTJSjqv8YIKoBmsDa5DwlhohzlgqSmeQWin9cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUFWqyUNZ9fXmGDTodX+1jjafZK5egd3fKEVNwUOetjtidt4fIufYJapppsnDjlxY
	 NT+rKF1k9sbfuhmONgoggXHsziijms1xVZl8TALhMKHA2GIrEQyCSRRSLz3c/b7JgV
	 J6NU5AqCdrbi54IGOVU6EDakf+t3YV73AavAb2HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 240/474] spi: topcliff-pch: fix use-after-free on unbind
Date: Fri, 15 May 2026 17:45:49 +0200
Message-ID: <20260515154720.194947620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 9d72732fe70c11424bc90ed466c7ccfa58b42a9a upstream.

Give the driver a chance to flush its queue before releasing the DMA
buffers on driver unbind

Fixes: c37f3c2749b5 ("spi/topcliff_pch: DMA support")
Cc: stable@vger.kernel.org	# 3.1
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-9-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1406,9 +1406,6 @@ static void pch_spi_pd_remove(struct pla
 	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
 		__func__, plat_dev->id, board_dat->pdev->irq);
 
-	if (use_dma)
-		pch_free_dma_buf(board_dat, data);
-
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
@@ -1432,6 +1429,9 @@ static void pch_spi_pd_remove(struct pla
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	if (use_dma)
+		pch_free_dma_buf(board_dat, data);
+
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
 	spi_unregister_master(data->master);
 }


