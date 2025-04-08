Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A0F26B971;
	Tue,  8 Apr 2025 12:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115229; cv=none; b=tgM+4VsijcTHE+hbiSpRnw9Bb6C90Sh1pYvGN9D+fDXKi39dyXjNPlaTlZbKCXulSrA/OF4aRnrl+IoH5gBC83e8Gq2SBop/1zCH8uO78ieJd/gAnnmmiRxe1eTa/kLU7fgTdlOLRUh2G4UwDhRylzwppKXwyJlWWwJH5KVGLNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115229; c=relaxed/simple;
	bh=v8q7UCv1ki7A9NYKOj5elKREF5YLrkrw4oX2fO8SBLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9tmrMfNXk0PVu8dKvHjiql6sLkKWxwHcX4UlW2nx9FHBPWnrFm/uRGvpwQpeQs6y1RnBoyPZNc6HHNyXOn3V2jwOv09Cinf6NLIXZ2N/9141Cp1/VI3SQKvsNDb1u+uxQunGMEbN6mJmGn9wxmApvvgaP3n/S7NHcizI2ovqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVmaVJI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVmaVJI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C9DC4CEE7;
	Tue,  8 Apr 2025 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115229;
	bh=v8q7UCv1ki7A9NYKOj5elKREF5YLrkrw4oX2fO8SBLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVmaVJI7n++3sxqxLryjZYFQG9zp8xiKgtTyjbmEabsQkGiVKZiK+DEJNDo6eIl/J
	 fKTJjKzbYZqXAN+WemPENl3vwr9bgckuOVtSrcgaZQ0W7Xo7Ox5F/OKOEqagHRbn82
	 U35XBp6BWOWwOKu9fCwn63LCrpqTkqlskLUxqc50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 380/499] spi: bcm2835: Do not call gpiod_put() on invalid descriptor
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104900.709769770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit d6691010523fe1016f482a1e1defcc6289eeea48 ]

If we are unable to lookup the chip-select GPIO, the error path will
call bcm2835_spi_cleanup() which unconditionally calls gpiod_put() on
the cs->gpio variable which we just determined was invalid.

Fixes: 21f252cd29f0 ("spi: bcm2835: reduce the abuse of the GPIO API")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250401224238.2854256-1-florian.fainelli@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 0d1aa65924846..06a81727d74dd 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1162,7 +1162,8 @@ static void bcm2835_spi_cleanup(struct spi_device *spi)
 				 sizeof(u32),
 				 DMA_TO_DEVICE);
 
-	gpiod_put(bs->cs_gpio);
+	if (!IS_ERR(bs->cs_gpio))
+		gpiod_put(bs->cs_gpio);
 	spi_set_csgpiod(spi, 0, NULL);
 
 	kfree(target);
-- 
2.39.5



