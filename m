Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF9D15A8;
	Tue, 26 Aug 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215425; cv=none; b=UhGxxAMdCuVugXs/1GAb+RnRrosShr2t31q8vyv/7gKO5XX1TXUnz7IAjImQtc/82ZfDVC7UiQAIMdnxgfqtCmdzAPHqNnZqsW76kqIAvBnyM+FACATkp3Z+tCD7PNXScpDEhtgcs3NZWykzzAU0IqSowzC/cz8iMWWBLBAzBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215425; c=relaxed/simple;
	bh=GzmCeuA2O8aa/0d/8MGm1sYzgxaYlGUmoaAoO+Lo9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdB/en2kW3OuU2KwFUyGgnyeOFYzN0o+7/2eo+YP0fK305ezcAIeGaAQB3OmCBrW8JFxDqF2a+IYJZOnhDXlrwHxRHJ+ocRGolHbCfY3hL8aY3IQIusNiKGsRXxZOrhiHRlD3hZLFepNL9v8nkF+D2aEuYu3zar3TcVD+jMlXLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUusFzWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUusFzWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59FFC4CEF1;
	Tue, 26 Aug 2025 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215425;
	bh=GzmCeuA2O8aa/0d/8MGm1sYzgxaYlGUmoaAoO+Lo9FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUusFzWn+euvOrKSMU+IbJPVDuReGnMrWF31P+riggsK3ZNHYl0ApeoM3DN5lYKCR
	 JzmLuf1dOR8rI1FLPjzyQWKn9gGFMKmMOXe1iBEqYX8YQ4Ir03G8dcWg5LH5H8zbJJ
	 FcaBbs0zjSkdIuLeFKm6coKMYHL5DgtMEV9EgIPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 009/644] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 26 Aug 2025 13:01:40 +0200
Message-ID: <20250826110946.743056198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 6c0e9f05c9d7875995b0e92ace71be947f280bbd upstream.

The dma_sync_sg_for_device() functions should be called with the same
nents as the dma_map_sg(), not the value the map function returned
according to the documentation in Documentation/core-api/dma-api.rst:450:
	With the sync_sg API, all the parameters must be the same
	as those passed into the sg mapping API.

Fixes: da3564ee027e ("pch_uart: add multi-scatter processing")
Cc: stable <stable@kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250701113452.18590-2-fourier.thomas@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1014,7 +1014,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


