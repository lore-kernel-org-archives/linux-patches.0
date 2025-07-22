Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA46528BAB0;
	Tue, 22 Jul 2025 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192651; cv=none; b=dVu2JgK0hbXu/9izzwpg/cIWuySpIbaVkefEEmYPbZ6QFzE/yQH5pJGlysmqt8JCkZjUeeHKIzI78JEYbTZoUEp+CRL3W35pklnUkFCr/HgNQVSRsDaPqEqcwQ0yjp21EmLZR2ncdCkS0PrSNNlCGx9b8eOSTyvcfUF/RlUeR1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192651; c=relaxed/simple;
	bh=F0YczdXaN92Vxsvp1tT3hmp14LXyh/J9JZYFX3ipJmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlydVWkUapDC3EJFr0I9OwYSYsjDlLOeplAxbECWmOl+/w3CarY7e4xqje5+5KnpP8S34/Ku5Bo2ORMdV9PK5INqHy6o/gKbeZPUHArsv10I2plGQlzIFZlz24mVIm6TfqfpC95NunHeG3sISUalj0xuYaQqyRTpPgxD/gFyXu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGLN4PMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGLN4PMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D45C4CEEB;
	Tue, 22 Jul 2025 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192651;
	bh=F0YczdXaN92Vxsvp1tT3hmp14LXyh/J9JZYFX3ipJmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGLN4PMn1vBnomqLR5Qn12S3OtTImLkwIb2V+Wid5nbicSrAcgsLwzQdqIM6SuwW9
	 fEKUL/Kl1/OrljXQ00jIHO9OFJjSVHgR7kidgKQXaR+0ed/3eFPNcrGJI0hdXcQ+Xp
	 5Ra4w09jVZ2YtuwQ7/WmD8QT249oIpMMURHcodN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 018/158] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 22 Jul 2025 15:43:22 +0200
Message-ID: <20250722134341.408697158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -954,7 +954,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


