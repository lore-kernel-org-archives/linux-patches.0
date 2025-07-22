Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41342EA173;
	Tue, 22 Jul 2025 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192265; cv=none; b=ZNSZvQz1ljCv0B7sSmDmIOLana72eBZgmWfgWCkcJrLhtpVleH7pIU+xnDSXOvi+RNArFALbmANvwWFDP5OpDVldaZaXtu//H1eLT0JXpNfDsxdETg1pzVuMUE0LKPPSMlMT2LEcQ1cLVk/LyQZE3Y6R00z2rZplgYdHjCKJllA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192265; c=relaxed/simple;
	bh=q6KfQeE4rm7QR8Ybvdi7UUIFnrBV93gA+R+VXEZz5qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRYFm4cSF85tXxIcQOMGb+Q58nCnGToK9YY5pOxKn15c/x6bof/GL1+7zsaYwxx/N1v86KDvcYpHgN9tqtDAg0QtPZAL1wlJN08lObX8wpOgu/TTddV7xL7xvy41FEDchJ/DdjJNpeY7h0C+NjkQVS3XdMI1ag5V/KFwH8ZjeW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b06Y6DVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b06Y6DVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221B5C4CEEB;
	Tue, 22 Jul 2025 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192265;
	bh=q6KfQeE4rm7QR8Ybvdi7UUIFnrBV93gA+R+VXEZz5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b06Y6DVg8U8reXbfbn9xWzgIyaapHcoCAR9gOArdQ7t7CzUuhXgVcpohilAoOXuqc
	 nu/Z4H5uX4FUxETQanfRdSuED5MnvY+z2PyM3Jzqm560cBNe1NOar6CdEGPb5F+BcG
	 CrvQFHJt9dt2zvpvjr132Fx/2ggRXy8kX2P3VNSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 014/111] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 22 Jul 2025 15:43:49 +0200
Message-ID: <20250722134333.925073611@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,7 +967,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


