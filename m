Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D9C2C9A;
	Tue, 22 Jul 2025 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193201; cv=none; b=PK5TJ3NNZFiSPgNUtOOs18bF4DuMOyVdX+REB4plWdGpr/WXh4f9lHip319Kb6OmqWUtUhzcD3LXs0+VlVlDRlF5iNFRRu9ucJNGc+51elxOsTPrSTdKkH0ZoNl3gbPyCOhkR0KReG5XKasVUuX/1uWuxchrM8DYi7YLd21dUCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193201; c=relaxed/simple;
	bh=8pAZ5nLlINwQc9DCcDkOAlf+MzaiwfYMA4i/+1jbWXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOhWIlo3puGOudORFuB+3JTL/UpG+LLj8z31MoDhSYgQJ4OsFOJry0wns/JyZnKpA6hXWNdbDd7uDIGCGbRgoSQjMmnD0pfWONFaDvClOzNR4QOmSXHFRAjZ7ekg1Ba0o2koFwfo6HQhuR+xkgjbcyHxEJn4cgwsK9xtQTpTWmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHC6Puao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHC6Puao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB0C4CEEB;
	Tue, 22 Jul 2025 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193201;
	bh=8pAZ5nLlINwQc9DCcDkOAlf+MzaiwfYMA4i/+1jbWXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHC6PuaoxYz9RpV4VS8BwuaYrJ8CjqPL8JWjHAFR5P/0dPN/8PjV8016b0lGrsf5o
	 8aOBvXL9HJ0EMieNKIuLj6hxkS4iU25BrqBno0Y7e1lRHRjRvGQRs1gHg/9eCr7mui
	 1j/9KwbUnC8bqCmFpPXr+PSKpIjM6yhua/aT2zik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.15 021/187] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 22 Jul 2025 15:43:11 +0200
Message-ID: <20250722134346.548822011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


