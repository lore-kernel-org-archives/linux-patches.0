Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A9915884E;
	Tue, 23 Jul 2024 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760246; cv=none; b=MO8hEfVQ0NyonmQNfgSPa8lSHn3VRM+7WbFDd7V/wY7Ric2Szrt9vhO5aKMMPIN6XjnWVDphAXBVphnyX+jvb4w47CdGt62zDVm4LeyN7Yd1fQ9d0A8GyeH9L06QVLy8Du7bWJbMBUn61Sdm2Cc9fR0EjPIdJcNTcOxYq6GclP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760246; c=relaxed/simple;
	bh=ATC2w5OPHN2rgs9QIptE2loHYNhxGWzOAuZk/6h/4Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4HLdWJP9uqMaybzm2BwfuXmjHqr0gq4ZrHW1RysJjg/zdcnNHtBIkhAfI91IajDgxEQcCpL6zbHsodMRf49lWuuXuEQT1HLDh7GRDAxJeN069fiERhtlvU7LqaftYFnfjTWiG4JQ/WIiJhCrWoizuN8SShDg0ikoWKm/UtZPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rb9nrsmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rb9nrsmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B234AC4AF0A;
	Tue, 23 Jul 2024 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760246;
	bh=ATC2w5OPHN2rgs9QIptE2loHYNhxGWzOAuZk/6h/4Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rb9nrsmY07KTEB4gNx1mkbvKh7DQU0fpM/9mLYyPaaFRggx/ChA7P4kHgNwm6+3bO
	 ATwfsPYtPCun5HJhP3KJ3LDL15yFNHaQ5LKAGCry08kt6axO+sNmwGff0G2L4IMjQz
	 0zD55DU43rBtq4iindjVdDufP+2cGbSeLVmrrVgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 152/163] spi: mux: set ctlr->bits_per_word_mask
Date: Tue, 23 Jul 2024 20:24:41 +0200
Message-ID: <20240723180149.342933642@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 031b5795d1060..a8bb07b38ec64 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -156,6 +156,7 @@ static int spi_mux_probe(struct spi_device *spi)
 	/* supported modes are the same as our parent's */
 	ctlr->mode_bits = spi->controller->mode_bits;
 	ctlr->flags = spi->controller->flags;
+	ctlr->bits_per_word_mask = spi->controller->bits_per_word_mask;
 	ctlr->transfer_one_message = spi_mux_transfer_one_message;
 	ctlr->setup = spi_mux_setup;
 	ctlr->num_chipselect = mux_control_states(priv->mux);
-- 
2.43.0



