Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015733DA5A8;
	Tue, 16 Jun 2026 19:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636741; cv=none; b=SH3kxhUOw3ETqjqT1AxQN4JXXIFkHJz3ts4yCFnoJor33kBk+4GkHGQk08HIuqYYYIV8YNOhv1Ik0rH6P2gG9OrzqVUfd6Aajylalgb/vW8304c1niKLy6TsHFPdr8ScDvPll+Jief9hsWgOC+1zZse/qGgsjh5Q98bLG20XXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636741; c=relaxed/simple;
	bh=pxDheUAPQtNCkvYSwTsvS0SPOQk3hfK60+heqBDPZd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNCqkrIoav2btQC2ahY/JzGM9Ny0SJCiAlsAsjVnrlWnxntiwJ7k1kUYxPtNHxlsK785vXhv8jNOvuDzyHvpl0VFRYp6EKxzIBlX8jUfuy8VLmZLGJw04wtoZnvtr7Mau2Zqr1VdNvfNpHsM2ARF4dPnqt3iT5NI/dQwfW07Szo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oTnVS9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oTnVS9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EF31F000E9;
	Tue, 16 Jun 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636740;
	bh=5KHscalTWFaUlRnLKvr4xXeKcv4Nw2my2orZW0MALO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oTnVS9GzO6HjBH/LNCxg9DDY468ulF49V9Jhz9OUil+f7f9JQVVOCMe8gCI4mcv1
	 fz9kCyoEMehqzovCw+UFATTw6+xA3u4vXA5wDFBgKN5Rd5GyIewnZ6GWHN9iCtHiz9
	 GNzWiUf99lso+aUypnjPiwbwnWe3KCDfyP/fjqHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/342] spi: qup: fix error pointer deref after DMA setup failure
Date: Tue, 16 Jun 2026 20:29:53 +0530
Message-ID: <20260616145102.267366649@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

[ Upstream commit a7e8f3efd50a165ba0189f6dc57f7e51a7d149db ]

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to the clear the DMA channel pointers on setup failure to
avoid dereferencing an error pointer (or attempting to release a channel
a second time) on later probe errors or driver unbind.

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 612762e82ae6 ("spi: qup: Add DMA capabilities")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=4
Cc: stable@vger.kernel.org	# 4.1
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074334.914735-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -969,8 +969,11 @@ static int spi_qup_init_dma(struct spi_c
 
 err:
 	dma_release_channel(host->dma_tx);
+	host->dma_tx = NULL;
 err_tx:
 	dma_release_channel(host->dma_rx);
+	host->dma_rx = NULL;
+
 	return ret;
 }
 


