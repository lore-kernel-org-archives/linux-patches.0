Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FDB2EF652;
	Sat, 30 May 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166121; cv=none; b=kGNlhOY7oyb/3PA/01aWmV7Cr2YmGxwPzR1dzLbAZtTNCfC4943/C5xeNsqODockK9YlPmTWv5O5qeJwx0TSyHfxzCKRjo0uFwr0u1gYE4Te4AW7obhHC8UEXy2O0P3ABAvY+WN3W++tNoF1FviX0DGDvgwvtncJ2phTQXlJs24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166121; c=relaxed/simple;
	bh=Kgod9urKiV8JdnvTKm0lMOr/km27qtuCVmuC0RvOG5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkyGv8DJXHdAP+DEcT9CC2wRExF3H6OpQZ5lvfGRKbf7kAoKc2jGTXPcUXIIEc6O40Z4lFiKvKyUSNOOO/qwMVS8Kvpl5AEMEWcO8U2sMC2x5ge/EThkR22aMtgyqbAstDrEjea2WE++V2r84Q+4hr+bcv8YymEPYKjJ+ylHMb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOzVXMG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOzVXMG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A71F00893;
	Sat, 30 May 2026 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166115;
	bh=7xoiUtlQgKW4fWryIi3OHbDEaxAqmaWKDTeqDjzDB78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOzVXMG2g8rqQ5mrSa5yvRvu0SMZNhfMMvmVyj6Z+M+vQCX2I/jhLTFreCcis0wMl
	 XWHRJQ5nFlr8AesUdbxg8l/WnKDbjG8S+OfxjybEjpTJ/c1rLwUrZcSTAoOP+xbu1J
	 M69us1aBgj3sj6wdhGiQBkyl2X+4NwEm/p15qvhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 244/589] spi: topcliff-pch: fix use-after-free on unbind
Date: Sat, 30 May 2026 18:02:05 +0200
Message-ID: <20260530160231.411962903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -1426,9 +1426,6 @@ static int pch_spi_pd_remove(struct plat
 	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=%d\n",
 		__func__, plat_dev->id, board_dat->pdev->irq);
 
-	if (use_dma)
-		pch_free_dma_buf(board_dat, data);
-
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
@@ -1452,6 +1449,9 @@ static int pch_spi_pd_remove(struct plat
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	if (use_dma)
+		pch_free_dma_buf(board_dat, data);
+
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
 	spi_unregister_master(data->master);
 


