Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ACF34AB17;
	Tue, 17 Mar 2026 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765630; cv=none; b=T5O+mvezLYb1s7PO3TcPPQVP6Wo8z1Nikec91yShNrz78cvkg7x4Z2kT2oRgZgJbQYq/w92gl213jGEt6lQBQ2qEumGw5W/wpnpZU69qn1Q52kx+cKUc3ZbzPolmDUnpqHyfq9Lkt4e4BkpYZ/30I9WKn7ut4dr73cQJ2Z3bcts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765630; c=relaxed/simple;
	bh=PxxMhPIl8drhbFobGSJDfbeltGJ1zHzMJHdPuWS72wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdYtpHSVSKeAWAHDKBZAdkMh7ZUMrudl0MM8LGn0NXhMxN0sqakdDUkeAdy8mlUERLJEVcMdyRKq0Nf+jbOvd6bxuAnSC+VFcK7S2ITj6ABTbfzRa2dyZVe//6rSjc/0zvDzJsfh9J/URrs3KJIegmWXjfqAcJtEatLuW1Udlss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBNgz/RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBNgz/RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB68FC4CEF7;
	Tue, 17 Mar 2026 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765630;
	bh=PxxMhPIl8drhbFobGSJDfbeltGJ1zHzMJHdPuWS72wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBNgz/RO0cX5TR+pK+bOt8yfdZA6mFcPri+Qk3UsA6jeaiTL9QUXt5cKwWU05V8U3
	 9S0j+K3yjfgneGRuaRmF4TurALxoko6WNQBT8f+pebONUw4DUQoA3NH7j/RleEPXUN
	 4eEowGKtCqhVa8SdiKxyhRvvy8xgPJf7BLIoYSqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	David Lechner <dlechner@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 053/378] drm/sitronix/st7586: fix bad pixel data due to byte swap
Date: Tue, 17 Mar 2026 17:30:10 +0100
Message-ID: <20260317163008.942113677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/sitronix/st7586.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/sitronix/st7586.c b/drivers/gpu/drm/sitronix/st7586.c
index b57ebf37a664c..16b6b4e368af8 100644
--- a/drivers/gpu/drm/sitronix/st7586.c
+++ b/drivers/gpu/drm/sitronix/st7586.c
@@ -347,6 +347,12 @@ static int st7586_probe(struct spi_device *spi)
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
 
@@ -356,15 +362,6 @@ static int st7586_probe(struct spi_device *spi)
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



