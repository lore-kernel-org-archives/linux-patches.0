Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BAF426D2E;
	Wed, 23 Sep 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174772; cv=none; b=SvAIN/vQ/kbvh1t6ubtAxw2rrCvQ/mBHzbNt39u0ROG1fF7QtTxK3A5sXfmt600l0Zr/JDlJs+l+Jv1GMvh1Zmoo4y1y46f978hv1/QSjDsQ8kpUfBdPfF9QgA57p5XGRUa0zjsAq3v2ANzPDm2I1eTXyItcPd/9ei4f+Ab5T+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174772; c=relaxed/simple;
	bh=CQGctV2fekVf6HKjv4awGi89m1qUvT7k8Qlno3AU/eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5LU5vMaZLmaPda5Ly85YfyqPB5fpvn8xyN/Uqsw7o8vXIoc6u2ipAV6+SU6YoywbRnjvU61g6yF60gxhqTpmPhm6BFj6ENHphBNdvpK+cRq5v13KEuzNoqbAAoU/FnuDXEPUgyiQvISBq1ZiNvar6avmQuoWQ+h3rlJtBsDLE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjgnoCXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjgnoCXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BD31F000FF;
	Wed, 23 Sep 2026 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174770;
	bh=ADn6pjDH5l/kYqVDFieezf7ux7N+EO8J6xE6mrjxCAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjgnoCXTOKKEL0BuXKoGKgrRtDBWijZM8FiIh7ouCiljllDfv07nUoLepR0VzleRj
	 QkCzugJOrqbAOl5+btMNkQbk2ohv6lBr5wlSmEBSzDMDNYsk9gYDatxjqol7Xxe8nn
	 Qu4WQyayIsWatU5QMcpuuy5m/3QZwEfOhRXSHRqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 221/398] spi: virtio: Use the per-transfer bits per word
Date: Wed, 23 Sep 2026 16:04:55 +0200
Message-ID: <20260923140649.150507937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 095858324f063dba830041f067872f0a08765d2f upstream.

virtio_spi_transfer_one() puts spi->bits_per_word into the request
header, so a transfer that sets its own word size reaches the backend
with the device default instead. The SPI core has already copied that
default into xfer->bits_per_word when the transfer leaves it at zero,
the same way it does for xfer->speed_hz, which this function already
uses.

Per-transfer word sizes are ordinary SPI usage. mipi_dbi, for one, sends
a 9-bit command and reads the reply as 8-bit data in the same message.
With a 16-bit device default, a one-byte transfer asking for 8 bits goes
out as a partial 16-bit word, which the backend may reject.

Fixes: f98cabe3f6cf ("SPI: Add virtio SPI driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260913032049.11209.alvinhuang0603@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -169,7 +169,7 @@ static int virtio_spi_transfer_one(struc
 
 	/* Fill struct spi_transfer_head */
 	th->chip_select_id = spi_get_chipselect(spi, 0);
-	th->bits_per_word = spi->bits_per_word;
+	th->bits_per_word = xfer->bits_per_word;
 	th->cs_change = xfer->cs_change;
 	th->tx_nbits = xfer->tx_nbits;
 	th->rx_nbits = xfer->rx_nbits;


