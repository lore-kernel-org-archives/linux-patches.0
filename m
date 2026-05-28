Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97B530C343;
	Thu, 28 May 2026 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000605; cv=none; b=WvhoFSnXiPPpGO0aA0DfAnjBe1EhIFdheNcBn5kWfIiIraDNAnK5/92uMPeFdOq0KNuCNbX5tbCG8trE8J5+9y2YPKSmu1afUpJ4H6D7R8bsFza4lgsLaXuikiX1/ftIth1f35K/h+CqdF7Exj5l0itUOWFmguEZ92MxAH/Srlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000605; c=relaxed/simple;
	bh=UtWMY9Y3TiaJZG4cvTed8RScCUmgxsVJHDWLeaX4KtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS/9nCmXxyuUM0hmg11yDEZwNpqmVoI+48uit9yjkZC7e96+XvZR2yUtayYsypkC2eRZGUiqFdVw+aaO5SezFwpTDV345pc1x9koZvvzQjHwIwoWvRQHPlxQtNrTuaeDlx4mWQvYuNXSzrWBTUg00ZFFWNJqcB3ScIKXuHDbb24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABYXNKha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABYXNKha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B01F000E9;
	Thu, 28 May 2026 20:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000604;
	bh=0ekUPvpnHCr0GavI2YMII+waK59n3Q436HmkR+uybGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABYXNKhassPhank4l+jEt66rXWRlBj+y5vH7StjzWjRpw438Xs2kXrJVnL0rdPl/x
	 qCAwD8OEltvPX4YSKP4wzVr4bCSHKTONXk1WR+axB55bNo3ZL4UtsggnlskAvxc2p8
	 PeK/xO/W3dPvwpkmYCumsbYFpyy+x8H3IfHvb6Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 105/272] spi: qup: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:47:59 +0200
Message-ID: <20260528194632.317745188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a7e8f3efd50a165ba0189f6dc57f7e51a7d149db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -996,8 +996,11 @@ static int spi_qup_init_dma(struct spi_c
 
 err:
 	dma_release_channel(host->dma_tx);
+	host->dma_tx = NULL;
 err_tx:
 	dma_release_channel(host->dma_rx);
+	host->dma_rx = NULL;
+
 	return ret;
 }
 


