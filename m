Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025785;
	b=tgUxfIS34gKcAL20YTbDa0dlodhNXmi9Xb/mWvz7ggsJevB+KLc9/sdRFm1ZZfaqlop8
	 LHibfmN1YuDZfAgxsAOrr/fGVFT5nR1zJ1RqtJ1o/P0DgN7A44R+97Fj1rdtSJdJzyEN5
	 WGQ5xY3nxdeTho/bcT14bQmLF062osPK49L0kDmXYWcXrKwA13V5kGVU4wKIY9tWA+ELb
	 j8dyd94QlmtBGDLupnLTpyJVSlD7/k935f+Nj4a5OiA+bXFaD3ozKIWyQmrbek8seCf4e
	 v8nyXV4JtN40W79ZST557xc2Wi2LamjqLcQ6qVNBSDq8i/e0NFbdnMKCWaAVY9TI50Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1KtF4SY7CuMAclqI2ff8S112HuMYO4045xEvybcC5Bc=;
	b=T1ypADe58hQ9vn+psJNWnFAtUMov3xygfnsy3c5sW2wpcKn/QGQ9AG/R/EkE6NaHfYe1
	 pjTXHjnYrEH1PZiwdQvFSlfdi1xKkhsOOblfyWVRy65n7mf43yrf4wpZfXgmITSOZov0H
	 9KGWts5/AkOC4t2g/YTMNdczvzzr2eh4LqH0cX6XCuzTCapGQboxptTgmO/9puNYr2X5w
	 BTpdf9GeiyKGLS4f4PCURi4fULDVlqfoU8qKYpch5qtS2y+r6qDzLco9nULVTALI5Ma4j
	 biGE1QPzX7fjG4UrUcZDudxBkcMMd1kNb604w8OdXLG9c3pu9iPmUZCK4zb8AApO28g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1MFiTpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55273606A32F;
	Wed, 18 Nov 2026 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1MFiTpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B2B1F000C5;
	Wed, 18 Nov 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025785;
	bh=1KtF4SY7CuMAclqI2ff8S112HuMYO4045xEvybcC5Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1MFiTpMY+AHEISzZo/LeP9e82RBzp9Wq+doQBCCz7sK6eua1hXWvsFl6gsf1v+Fc
	 48te5zMQMVx0LwGRgBor/w28hf/rVoNSbWoid2lABqTuHOQlyP/fCpPHiazyHFBB0z
	 5th2MZVNLIrzmGD7ko7vnbQoJ7LQHSHGFTAFbyks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1160/2151] spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150204.426197786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f3ce7a3ca82bd9cda9ef61250aeff65fe6b44809 ]

In commit 6d9fe44bd73d ("spi: sun4i: fix FIFO limit"), the TX-FIFO is
filled max to SUN4I_FIFO_DEPTH - 1 (= 63) bytes to work around timeouts
observed on A10s SoCs.

Commit 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO
size") added support for transfers larger than the FIFO size. But this
commit only enabled the TX-FIFO empty interrupt for transfers larger
than the FIFO (= 64) bytes.

This breaks transfers with exactly 64 bytes: the TX-FIFO is only filled
with 63 bytes but the interrupt to refill the FIFO is not triggered. The
problem can be reproduced with the following command:

| spidev_test -D /dev/spidev0.1 -S 64 -s 20000000 -I 1
|
| [ 7797.548745] spi_master spi0: spi0.1: timeout transferring 64 bytes@20000000Hz for 110(100)ms
| [ 7797.557237] spidev spi0.1: SPI transfer failed: -110
| [ 7797.562308] spi_master spi0: failed to transfer one message from queue
| [ 7797.568936] spi_master spi0: noqueue transfer failed

To fix the problem enable the TX-FIFO interrupt if the total TX length
is larger than SUN4I_FIFO_DEPTH - 1 (= 63) bytes.

Fixes: 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO size")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-1-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 280b0fb909e98..9f0761b0ecdfe 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -322,7 +322,7 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TC |
 					 SUN4I_INT_CTL_RF_F34);
 	/* Only enable Tx FIFO interrupt if we really need it */
-	if (tx_len > SUN4I_FIFO_DEPTH)
+	if (tx_len > SUN4I_FIFO_DEPTH - 1)
 		sun4i_spi_enable_interrupt(sspi, SUN4I_INT_CTL_TF_E34);
 
 	/* Start the transfer */
-- 
2.53.0



