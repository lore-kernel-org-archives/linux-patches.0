Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D103537D0;
	Tue, 12 May 2026 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609388; cv=none; b=gxo6fLSH0nApAzP3djJi/DF4mW60WwPYUq/WkwnlPzZ+7hRf9y216RHEaeC2JTQYsa+c/tdMslMlcmYAsocukvgIk+n7zM37Ds7MNYquOeG+Wp24nuuJ2AUzxA558VLOaXs58K++gMnSHNQRJyyhELqZTF/qAepbIPnZqiq658g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609388; c=relaxed/simple;
	bh=kLgCiIGnpveX18htEjRaY12cTV1IPP4yGIOiyiQc9VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhXr1pydJGVwOj33a/PURHNh8e9YXbKEG01UQqQKUAGWjfreAdUbCqJccr5CSzFdXvWt2jQ1lKtv5zF5xxPnSQObLOv3Y/KeLyCSsE5LvZRoxKMLKVGftfHMMbYFbNFJEllD7vAVO+sgpWumkgCdHLURoX6tfgJUCj6j2cfDwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgfiLAjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgfiLAjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE22C2BCB0;
	Tue, 12 May 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609388;
	bh=kLgCiIGnpveX18htEjRaY12cTV1IPP4yGIOiyiQc9VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgfiLAjAD0x9og+SmSTQ2X3siDIDbmiROvBT+u6IBIfbBrHf3CCw7QW5mWlqI18bM
	 eKe8OQI1yw94tgLx8gcddiIYKjGKGjCu8+GaOp4rOHmib720pV+nJQVrW2JJ32SQGd
	 uodmWNqMBfcLMAKy2fEiy8Lx+VRKFS0oKk2RBnfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 159/307] spi: topcliff-pch: fix use-after-free on unbind
Date: Tue, 12 May 2026 19:39:14 +0200
Message-ID: <20260512173943.479607966@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


