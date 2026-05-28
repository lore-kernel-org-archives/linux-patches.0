Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC7815B998;
	Thu, 28 May 2026 19:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998386; cv=none; b=m03kI1zRvSfx1YPgKCFmF6q7kmNmF7k8mL37QihjV/uuYf+DJSbjcRpZt5vV0v38asvSpg67puotykJnRiZxMzFm9C+PPJWkGrhAlvxSuWKiatrZveBaPhrLjWh6M1zJdu5RUvhUI4Lwb9ikpgHA721R0er0FOWFzeA5BFVVNm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998386; c=relaxed/simple;
	bh=gOZhcaL9ob2Sj36RsfLSCwq6jTEKHcvnREWoqOkETIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0ziJGFpHqYm//1BmyxwHY+7H0eLXXppBEE245i0tyj94Ay8pJAW9cp2NW74oQkTSL9Llfcdy8gO1pvtEcbDIxmJQreKq+6SButsqwNaX3TDWfr5EgLwghYu2BVGngOVruBbo+jdP+C5fdr+9YZ7wiwJ3thMPYflOofNDy8JrQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3lhTWB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3lhTWB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496381F000E9;
	Thu, 28 May 2026 19:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998385;
	bh=GV3du2oK390Pw0NrKGMJzqmES79puzkkeHpe8KGRS8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3lhTWB908ArXnk/DCn66So6WcyFTf6goa9B3NXLzsHjwjr9+ry6s95AwIFvvLjqk
	 r9gY47ep9CZql6Ol3llmNQzRoJuWQ/nEFlWwW1zVpL1t+mVZaaJKuc1LjRfogO97QT
	 0Wh7WBSL3CKdCNbeHlF/An7nnghO7Jc4z+S12V4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh R <vigneshr@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 118/461] spi: ti-qspi: fix use-after-free after DMA setup failure
Date: Thu, 28 May 2026 21:44:07 +0200
Message-ID: <20260528194650.391171060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
@@ -867,6 +867,7 @@ static int ti_qspi_probe(struct platform
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
 		dma_release_channel(qspi->rx_chan);
+		qspi->rx_chan = NULL;
 		goto no_dma;
 	}
 	host->dma_rx = qspi->rx_chan;


