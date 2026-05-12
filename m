Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D032EBB84;
	Tue, 12 May 2026 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607983; cv=none; b=tYoK9IcuCQezFOUfsSp62DoIlAwHj+hvIxa67qpJSS8pAWtMhL8rAX0o/5TEszGbcWn0okig1GzUJHUf0ocRXjV1cvc+Ei3KCS5lFK9DiIRuOf/E4AaxjSGCFlLmYPen/r0i6GyX5t3kiWCTqZzufssgW43v7RKu3DQ0g/MQABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607983; c=relaxed/simple;
	bh=z3hcqi63IqS1N3RetUC4bxUb4FbmTuerpSQR4EJsdqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI0KgCTf4SZDjucimGmCZJk0t5fj+1Dq2Bta/Q9si7lAfY2EYR+oScj6gdjZ+Giq8IrcrcR9U7mRe4u87LpJQ9GtmFgbrpoqAAbsX8igAQp/aODpEEXU6KPb/JKP9ke71cAf810C11h3JCYWOnksz+7oyqPLWgpnAwNa9XPrM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAfmAg08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAfmAg08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DEBC2BCB0;
	Tue, 12 May 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607982;
	bh=z3hcqi63IqS1N3RetUC4bxUb4FbmTuerpSQR4EJsdqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAfmAg08kEz0UP5K+nwai1XxqFuWOyNqbXWdYoTtJNZ2AmypgJrE3dbQ3e4biZiAZ
	 Lf0EEEt1nOzY8HECEvwtmX1ADqeXHz3EKQSon2W0DMMWNmSdOV3TRNKyfUf9W3H6h2
	 YRepsxm14kWDrwRGcxG17vKB1h0DGS6V5t2rQio0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 104/206] spi: topcliff-pch: fix use-after-free on unbind
Date: Tue, 12 May 2026 19:39:16 +0200
Message-ID: <20260512173935.060447602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -1410,9 +1410,6 @@ static void pch_spi_pd_remove(struct pla
 
 	spi_unregister_controller(data->host);
 
-	if (use_dma)
-		pch_free_dma_buf(board_dat, data);
-
 	/* check for any pending messages; no action is taken if the queue
 	 * is still full; but at least we tried.  Unload anyway */
 	count = 500;
@@ -1436,6 +1433,9 @@ static void pch_spi_pd_remove(struct pla
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	if (use_dma)
+		pch_free_dma_buf(board_dat, data);
+
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
 
 	spi_controller_put(data->host);


