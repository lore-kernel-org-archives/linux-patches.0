Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A534F48A;
	Tue, 26 Aug 2025 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218476; cv=none; b=kQriDqTOKEk7r0jHyjyM3Xwc/m+GH4fkLZNrUfe0wKCNOJCA9kZkVjPcYrX/Vxu1vjQxySrX+3UPfw216QM7lQbC+YTFo93ylxpjP9FGQr0HzY1Wfj/oYwoNzQpt7XkNteKxyqelqROalA9Q5PtH9nAX4sXo1p3/xM+6gFac5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218476; c=relaxed/simple;
	bh=JrHrZgMoBvwEDgjyQNG3x8BKPq4cG8vIh6rInZpjeA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+dOmIn/WZ/szJBZhZLRGkja5r9WGOjVKC2AP4+gAZF81KHJhTIEKjqwXCgQMm1IW/SSwBLO+eI5Yb6M6mYgcM3B0iHzWd8Cl504FOwtXjpr3asiKu9RhSg1+/NXmydyZjWTnRvacgP/qvoEkSYRZnAyxtXFvc1dZpjvsLxFmFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJNcFeun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJNcFeun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F847C4CEF1;
	Tue, 26 Aug 2025 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218475;
	bh=JrHrZgMoBvwEDgjyQNG3x8BKPq4cG8vIh6rInZpjeA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJNcFeunHZbOJCzgHOlXvyr/4MBwcsPi61/oJSMdPrg9uMFM/FLvE2PjE/3LQ3LAD
	 D4xISC68dZSowv2z7KNOcYYu6cGGVlxaJsDWMhsYXbES6uJgjAQDBSvWsvx0yS+4g4
	 tInaQGCBcYQixKAjOjOFE22gzWmJbbKEgE0hbNjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 007/403] pch_uart: Fix dma_sync_sg_for_device() nents value
Date: Tue, 26 Aug 2025 13:05:33 +0200
Message-ID: <20250826110905.844039095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1025,7 +1025,7 @@ static unsigned int dma_handle_tx(struct
 			__func__);
 		return 0;
 	}
-	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, num, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;


