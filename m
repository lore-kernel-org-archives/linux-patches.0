Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C62367DF;
	Sat, 30 May 2026 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167162; cv=none; b=KDk9Uwbu42K4zxFGBX3VdwsIhbuD4BckisUfVoXvf25BiP1zTvw2rMKnr69y2D1ILApXa6AlTCVqn/VVT8R1tj7lE97Ts1xKo61jRwayCI/v2K21mnChEhBQ7XSY2zt4RKRVExY8qUfcE3L25nyaDzLMoLu15gYVQuaGTEfHDWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167162; c=relaxed/simple;
	bh=OyvJL6im/TBQ0Le65ZAS3PscCva7xOgYQVVXg18Em4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZC+hQMRHcbILJmYsouCTwtKyqWfPkZ9L3YF65sL+9gLu6pR6L1miXp9HuqTAOvcL3ME3VvfvRvL5uHpEKZSShv6RlmSW1ia21aJ9u1wze2GRVWpGpP2+cg+E/dzMQTKzRn3H3WVnHGPcB1YuApdc8qlNINW5w7JAgVa5feI+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyrKt5LF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyrKt5LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193051F00893;
	Sat, 30 May 2026 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167161;
	bh=supnPoYcu5h6bbykFrSK1LPVN382y9TQzaqffemKPCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyrKt5LFCEXr1gGjva5CI2dpG9/OYCmzMtm6rqlpiRCZ208OdZTpw+GNBJvPU1oMk
	 lEXZo/NB93dqcV34o5YsOWtqU9YeyyDmCLg5iAsgeD2rfeJ10qwg6ZmoHdDEq4TMKv
	 65K4YRy6dKlpo8YYN5/UXOi1v/vELsmr7mJc5M/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh R <vigneshr@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 546/589] spi: ti-qspi: fix use-after-free after DMA setup failure
Date: Sat, 30 May 2026 18:07:07 +0200
Message-ID: <20260530160239.025432763@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

commit ea6ec3343e05f7937a53eb6d7617b3abdb4abc19 upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to clear the DMA channel pointer also if buffer allocation
fails to avoid passing a pointer to the released channel to the DMA
engine (or trying to free the channel a second time on late probe errors
or driver unbind).

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: c687c46e9e45 ("spi: spi-ti-qspi: Use bounce buffer if read buffer is not DMA'ble")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=17
Cc: stable@vger.kernel.org	# 4.12
Cc: Vignesh R <vigneshr@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074809.915084-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -873,6 +873,7 @@ static int ti_qspi_probe(struct platform
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
 		dma_release_channel(qspi->rx_chan);
+		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
 	master->dma_rx = qspi->rx_chan;


