Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8F22DFA7;
	Tue, 26 Aug 2025 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217150; cv=none; b=q4/vRTZ6i84IQhaeLr8LttELj35F1TVq3YxWAsy8GS+kpFVTlq0m+TAmM76naYJk+zh3O0U6T4i3VtpP3quLJjC0HasKxrNDu9fRJQDmtYnQatuv2V7Ms+A43K90tW6ee+w2pSrAGSS8jNrs4T7zhnl7hYR/UTRQoKNq97PZ8hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217150; c=relaxed/simple;
	bh=a87FbD+mwRrrnnctClYEhYfT6wxIHq4pDOa3hf52ZLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1s0vCElZnYEr6ZmnRz1TymC94CglBSZbW+RR0koaG0OlWsSK8+DJNe//07HQtZyXbnyuUMzypwaedp3Vuw1JH7KDhhPybfy49ZVCnFvdN3BtQU/2qrIWlFqdTS8pZ7h2tbA0SZJ9/ckVlbaYDN1R0SPK+bkGrz8vbBJrXES4Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBFR2ctO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBFR2ctO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FAFC113D0;
	Tue, 26 Aug 2025 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217150;
	bh=a87FbD+mwRrrnnctClYEhYfT6wxIHq4pDOa3hf52ZLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBFR2ctOjjNp4YsfL8PSA/Rj3oZGvNJo08dKmmKrgIm0pkGZd7F14bQPW1lLPOU22
	 bRWouiEs2l1kT8jSwoa2J7YvfJ+mHJOXC76IVUK+JCBEYPoPizSqpV8scYXTZXP3VE
	 FmEHYUwEpSl3IUlWv+AsonomCUMD9IiNAExsah5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 009/523] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 26 Aug 2025 13:03:39 +0200
Message-ID: <20250826110924.808691838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1018,7 +1018,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


