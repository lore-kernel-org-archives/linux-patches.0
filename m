Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C409434D4D6;
	Thu, 28 May 2026 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998325; cv=none; b=PMyhy4T/todCFiMndeDjDHmUgbktgR29htIclEctwY6JagWmJvyLHVO0Xmx6kukbW8ZJsS4F+IElWlXIinomcGFJlHDMsE+92xhs8AKdcpKA5uq/z7ZLze+9+VZXktJKQdBcSyoVm/qOADSlzEBMCerkwIzO4vkGlQ2k1gesmUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998325; c=relaxed/simple;
	bh=YaXljnKGxDgnjt4ijwjcp/6VdsmnBJClLqW/Gxxn0f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAbsYRifzBq/4CyPm5K+HWiLhNSQMt3B+v8VgWYXuCundgFhuxR3Wx0xqGh92zcyOEonvCG8CQD7DR0CjVzD+1c6h86xOKN5FITKEJwNds0woVNr5aMCMDiunaIzZJkkdZP6neKZcgx3ZeZiGYu8yVUs5xkOhG8b1qmAT42TMpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z91IWlSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z91IWlSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF891F000E9;
	Thu, 28 May 2026 19:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998324;
	bh=XWlKuugbd0GZQy+9LPFL+8kGbluPebuKshdKd0YFaM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z91IWlSwk9hYqL1zsf9fPVj4mcHOGLDnInBupuu/G5o27pEt3RvvifoPJirzjA1N4
	 bccsusX3QvZKsDtbSfbh6a6HSmoCi07Qzc2OymIGxkN2q9+DkRJA5a6UobRaKW5iXl
	 JCjyArVciLh0oF75ZlMcIOapG3wpMiD4uNbTp+xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 116/461] spi: ep93xx: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:44:05 +0200
Message-ID: <20260528194650.331099522@linuxfoundation.org>
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

commit 5e121a81667a83e9a01d62b429e340f5a4a84abc upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to the clear the DMA channel pointers on setup failure to
avoid dereferencing an error pointer on later probe errors or driver
unbind.

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: e79e7c2df627 ("spi: ep93xx: add DT support for Cirrus EP93xx")
Link: https://sashiko.dev/#/patchset/20260429091333.165363-1-johan%40kernel.org?part=10
Cc: stable@vger.kernel.org	# 6.12
Cc: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Nikita Shubin <nikita.shubin@maquefel.me>
Link: https://patch.msgid.link/20260512074849.915143-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ep93xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -582,12 +582,14 @@ static int ep93xx_spi_setup_dma(struct d
 	espi->dma_rx = dma_request_chan(dev, "rx");
 	if (IS_ERR(espi->dma_rx)) {
 		ret = dev_err_probe(dev, PTR_ERR(espi->dma_rx), "rx DMA setup failed");
+		espi->dma_rx = NULL;
 		goto fail_free_page;
 	}
 
 	espi->dma_tx = dma_request_chan(dev, "tx");
 	if (IS_ERR(espi->dma_tx)) {
 		ret = dev_err_probe(dev, PTR_ERR(espi->dma_tx), "tx DMA setup failed");
+		espi->dma_tx = NULL;
 		goto fail_release_rx;
 	}
 


