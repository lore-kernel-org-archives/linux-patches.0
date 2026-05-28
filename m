Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAE42D9787;
	Thu, 28 May 2026 20:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999620; cv=none; b=gUmFHoYXOW53OLpieW0iVGmK1bM/yR7d/ICtsKbzPgFPskyKAET4XozUwU6cwd3NWht4D5UQ6DCS3G1RPgaDcXY3+hnQvUNOiugi05Uj6HuBeBviUOUgkpZaJqY9ANlNWy3KzXK4KbdcR23hHM6EcQYA9DSE5QL6txepU7Z1xeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999620; c=relaxed/simple;
	bh=ac5y0u/+dO+/qcg/kUkr7pO1fUk7Wh0GAgUQyECPqcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY+UYa07ASu8ZR9jfjwun6Z1GzuKEfE4fVxs/2E/HeHxC3Ef9kQTb7jLYP2MgIvGB3ZzEyhdz4c7GJNCGmfnmPAi1XJq+DCYmupn9cfQCUwYgwU+iOSIUx8FpQ6aWWIuuuHBoKHi/6bBZCnFkevLBgQWGnyH2Lq3mC5jP9Sl+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AW23zaKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AW23zaKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D041F000E9;
	Thu, 28 May 2026 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999619;
	bh=8rzHbFVyUyUL1h/a1iccEZQ2FUgG0PJ159XpJ8VwdvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AW23zaKzOJvhGkSgCn/G2SJVxSrlejn067thlSzS69uU2a6BojvpZLWA1Wr23qIta
	 GKmj89sRvd3ZS7w9ZC1TsQK3E9W+6XwIuYxJWQ8cF5tbzF80GjG2NAiBinbQsuPK6R
	 uj83YkE4HwsxROE6eAkm0JXAQdZ0bSxre04nE2Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 114/377] spi: qup: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:45:52 +0200
Message-ID: <20260528194641.635534623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
 


