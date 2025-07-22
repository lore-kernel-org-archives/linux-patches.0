Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11E1433A8;
	Tue, 22 Jul 2025 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192123; cv=none; b=W4r5OghhhNoFJMlzia2NQDcnvGtnMJsP9ULn7gBxR1Itr8S9rQc4wrgVNYA1eHW3AYBbnk1NW2CiYa4pkBahET0hg4NsaqEaPmyjlMBs9nCnWvHlhZcmi2GZmaLoAOcDj9lalTA+rFIA+SI2+64lM5enzH/Duu4rtzR47liOHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192123; c=relaxed/simple;
	bh=g7bFYv3vu6r0YIboeHmbyt776P5sLk0sipb4d7d1eKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVYrUKjvORN5msDtn+JzobqaacWEcPb7HQb9xsRH0hroihFxUajgTDL2DNvCE2LUsNHiAbZ1vA+u0hibrtotXeqmQLQiHv4V3kfGOWoctS2KAIl5k40NnRAKAbD3iN6+lrIhlHAPIYHmS9gZU9+Qprs0oVuOLEZuxgOorvp0UdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpq5jfuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpq5jfuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C36FC4CEEB;
	Tue, 22 Jul 2025 13:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192123;
	bh=g7bFYv3vu6r0YIboeHmbyt776P5sLk0sipb4d7d1eKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpq5jfuFfLWyKcOAI0HJa4lUVIqYb7BrLtWE7cOYSRxM/pqidAbqV/WSsQ8G2X71K
	 w/yMZuUmJAe1l32Zyv3nmj6R4wZIjAJHR8ZuDQopr3q4hbkPOv2dopfobcDEwIbNvZ
	 pQ8rFYpZqMFzg7ZubyQbd3lpxCYNInTAhXwRJhAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 09/79] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 22 Jul 2025 15:44:05 +0200
Message-ID: <20250722134328.721900871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -971,7 +971,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


