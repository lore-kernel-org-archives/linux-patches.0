Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550BBF519;
	Thu, 25 Jul 2024 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918969; cv=none; b=M++kqLQlyHP71zPMS3hLMpRh26NNTx761KmiCeYYnnAiUtqOQCJybDSITNOADgZ2e9A8YOtAesIiXCQCRTmxmKWkdoKe/znQbv5LA5+r7HZ0UjPfkJFgkkUBpW/bqCTckMIF57cFjehgIr1CPP2P+kkcTbL1GQWx/SU9uRbfLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918969; c=relaxed/simple;
	bh=e4DYBMUmK7wkbAxSF8QeyRWmvYmajE1I8NRZIUT0/3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6KOLmR4giuZB0dw1Ib4pnuRplPO/z7OylRvgdTYSSf5MNeKpn899Lk3f7Nnw+5ILY+zuBamMPn0UwvpCGTBPDTdy5Lz7G3e/bz6pqoxvrgITEeoNXhdDOrcvIPjXdkCrZSovfcTvQrjOxzBf6prm3Mnk+66DgB5lJ25rlyAPJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtmhQmNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtmhQmNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20C2C116B1;
	Thu, 25 Jul 2024 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918969;
	bh=e4DYBMUmK7wkbAxSF8QeyRWmvYmajE1I8NRZIUT0/3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtmhQmNcjYipNd6PayUPnhrOy6z754qGbpQ1ZW7SfYVuNzK1P7UFvbSE5g7eXIJnw
	 nNJ5Nbbeaje1H5DUmu5lnqfomkFlFSg88IhBDvOkDHRFl81hvTqAazxE3pz3n+CPvu
	 KpsT3xEXpp1Uoz4vYHpM0wspeJKXKmEJPP5+xHeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/59] spi: mux: set ctlr->bits_per_word_mask
Date: Thu, 25 Jul 2024 16:37:33 +0200
Message-ID: <20240725142734.889710497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit c8bd922d924bb4ab6c6c488310157d1a27996f31 ]

Like other SPI controller flags, bits_per_word_mask may be used by a
peripheral driver, so it needs to reflect the capabilities of the
underlying controller.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20240708-spi-mux-fix-v1-3-6c8845193128@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 9708b7827ff70..b18c5265e858c 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -149,6 +149,7 @@ static int spi_mux_probe(struct spi_device *spi)
 	/* supported modes are the same as our parent's */
 	ctlr->mode_bits = spi->controller->mode_bits;
 	ctlr->flags = spi->controller->flags;
+	ctlr->bits_per_word_mask = spi->controller->bits_per_word_mask;
 	ctlr->transfer_one_message = spi_mux_transfer_one_message;
 	ctlr->setup = spi_mux_setup;
 	ctlr->num_chipselect = mux_control_states(priv->mux);
-- 
2.43.0



