Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9007C15E8B;
	Mon, 30 Dec 2024 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574171; cv=none; b=aqpS0BnLvkANlqvBkhMLCu9MdqH81na4cfdsW9tfDkQGYen7ofo5vG1O6fov4da5KEBpY52l9KoquNLb1rI6dVT/Csdx47upuhFHGdKn0mr64qC+UrpQcdHd7+QTN1ZYI45f/FKzFpUsmk3jy9Fi5ii3dnZvyRYleMotOShR0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574171; c=relaxed/simple;
	bh=vBRsL+Lon4rY1ifamegUuxIkxKNd0ShUc6nNZ43ZjPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4Kc7h5YaER58Xb/ueR+c1tXEryCjytXHGXT+Uzy8TZOTnBAbg/x39qzJUgTO13nKH9EoiYgT0zg5gkqNws0Dl8ti1a+Johno1OQdzu/QdySyZbm7JO3MdRJIjn8at7FKKg+TvA9MqrdXVyFm60JtgR4dp5e6WiPtzzjQ5EH9sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHDfKh9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHDfKh9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D17EC4CED0;
	Mon, 30 Dec 2024 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574171;
	bh=vBRsL+Lon4rY1ifamegUuxIkxKNd0ShUc6nNZ43ZjPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHDfKh9VvsFeUtwCjD5Myi7OyceuG6AAJBZQ7zCSISyh01ZyXQsXjqB0UA/6g/Du3
	 zb8i+s6J6WucTtpKpYcX1i+Kr7thznzzsNlcDWs3jxYiG/fXRU9eKJNoxHDQNpF0eb
	 Afu8cJctyIEkBWjPVNAO87JX9uc3vCXnTw8GxN54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 017/114] mtd: rawnand: arasan: Fix missing de-registration of NAND
Date: Mon, 30 Dec 2024 16:42:14 +0100
Message-ID: <20241230154218.723630776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Andrzejewski <maciej.andrzejewski@m-works.net>

commit 11e6831fd81468cf48155b9b3c11295c391da723 upstream.

The NAND chip-selects are registered for the Arasan driver during
initialization but are not de-registered when the driver is unloaded. As a
result, if the driver is loaded again, the chip-selects remain registered
and busy, making them unavailable for use.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1478,8 +1478,15 @@ static int anfc_probe(struct platform_de
 
 static void anfc_remove(struct platform_device *pdev)
 {
+	int i;
 	struct arasan_nfc *nfc = platform_get_drvdata(pdev);
 
+	for (i = 0; i < nfc->ncs; i++) {
+		if (nfc->cs_array[i]) {
+			gpiod_put(nfc->cs_array[i]);
+		}
+	}
+
 	anfc_chips_cleanup(nfc);
 }
 


