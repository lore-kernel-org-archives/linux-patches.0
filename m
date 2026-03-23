Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6A3AE1A6;
	Mon, 23 Mar 2026 14:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275286; cv=none; b=agmSK0PjzFDDULWmGvw5ZmBSySeEIsa7kGwXTi3OpC9EnmoCnAKxAlo0BcN9YqnS4mMljbA2dbZ6HQrXKmRkSug11coxV73fDV3jvoS9MOOB/huAvUv4dbZuhpyjFpb/WaN8smy3kMQS2CHoBdFRYkprZA0m0qylVySuTzenfAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275286; c=relaxed/simple;
	bh=4xCKPMmns1uRp3Wqg9S94bsww3uJ4+mz6PgxhUdD9cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frt7HDiwlb/VGbOUlFzAnsMtoym5SoGROzTc8iIrQWAypdbh2kUAoCytey/Hdrrl0YRkmYIEI6VjJdaAkyT58Fg9o7PrZ6vasvqUhXzygrjoZlwHrfmPbtuCLkzbkxTQ7ARf/EFizGGxOHjDR5+Bww+nYhpzDHGjBCxuTK5joXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIdF0r2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIdF0r2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00AFC2BC9E;
	Mon, 23 Mar 2026 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275286;
	bh=4xCKPMmns1uRp3Wqg9S94bsww3uJ4+mz6PgxhUdD9cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIdF0r2l9XwjmcMmL1bfjC95Up6NwBWJVvpPOTgzqRbR63dui9OUvEzN0XKpy6aOS
	 viAm8W2Kw0U1plvEiTJUL4h3jD1OBREFaadHokawo2bV8KyD705Ycn4lqpRF/XcJTf
	 LWaIzYB3zFhloLfgb5994lisK+MgGYjuIZeaN1l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	David Lechner <dlechner@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/460] drm/sitronix/st7586: fix bad pixel data due to byte swap
Date: Mon, 23 Mar 2026 14:40:37 +0100
Message-ID: <20260323134527.720471736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 46d8a07b4ae262e2fec6ce2aa454e06243661265 ]

Correctly set dbi->write_memory_bpw for the ST7586 driver. This driver
is for a monochrome display that has an unusual data format, so the
default value set in mipi_dbi_spi_init() is not correct simply because
this controller is non-standard.

Previously, we were using dbi->swap_bytes to make the same sort of
workaround, but it was removed in the same commit that added
dbi->write_memory_bpw, so we need to use the latter now to have the
correct behavior.

This fixes every 3 columns of pixels being swapped on the display. There
are 3 pixels per byte, so the byte swap caused this effect.

Fixes: df3fb27a74a4 ("drm/mipi-dbi: Make bits per word configurable for pixel transfers")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20260228-drm-mipi-dbi-fix-st7586-byte-swap-v1-1-e78f6c24cd28@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/st7586.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/tiny/st7586.c b/drivers/gpu/drm/tiny/st7586.c
index b9c6ed352182f..f8b1eaffb5e87 100644
--- a/drivers/gpu/drm/tiny/st7586.c
+++ b/drivers/gpu/drm/tiny/st7586.c
@@ -345,6 +345,12 @@ static int st7586_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	/*
+	 * Override value set by mipi_dbi_spi_init(). This driver is a bit
+	 * non-standard, so best to set it explicitly here.
+	 */
+	dbi->write_memory_bpw = 8;
+
 	/* Cannot read from this controller via SPI */
 	dbi->read_commands = NULL;
 
@@ -354,15 +360,6 @@ static int st7586_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	/*
-	 * we are using 8-bit data, so we are not actually swapping anything,
-	 * but setting mipi->swap_bytes makes mipi_dbi_typec3_command() do the
-	 * right thing and not use 16-bit transfers (which results in swapped
-	 * bytes on little-endian systems and causes out of order data to be
-	 * sent to the display).
-	 */
-	dbi->swap_bytes = true;
-
 	drm_mode_config_reset(drm);
 
 	ret = drm_dev_register(drm, 0);
-- 
2.51.0



