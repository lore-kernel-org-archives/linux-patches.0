Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CB82594B6;
	Mon, 30 Dec 2024 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573535; cv=none; b=AXId5EsjcygSRios1CZJ2b27C1+7ceQfCO4YX1aiO3alGrkOFCvIPeIqtPzYi5ClU00puqa5PzAu/sn/j5+eAPDbFXCm806pkvN1i+iOGBBlwohXS13UCCwoMxPwuBmM1ELQz1YBPD6A3mTLYDO/B7bquuuS+/rVrr9YojBgW8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573535; c=relaxed/simple;
	bh=HEYOgVKSCWSjT8hAtw3IafwLV/8KOY9tj9H1YNFW9+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABWofpzo9V8McIZRKRChvtj6wKHy9B6irIIWND6b0FRauVt+xz5b7TQ/XqNzsmAwG++0naALNRuuXzKx7yLfBiot6S/ju3fn1tzQpkqlndsrCuvPMONHVR1mC6ylmBQhUzRt6LkxFhGocnw1uUq/Cr2n2Z7Q5ej4vWNXqXw9NQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPzB8CS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPzB8CS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39405C4CED0;
	Mon, 30 Dec 2024 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573534;
	bh=HEYOgVKSCWSjT8hAtw3IafwLV/8KOY9tj9H1YNFW9+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPzB8CS9At6NtESorlKDIYiC4hH5iCxWf8cfZNWgs+eCprrs3rz2Chvv3ruTgl1LL
	 fllSezJ5x18O+zFdouRYeF38Pou3Y0yU4zOy2V/QbGg2VBECivieE8rHFmJs3lr3Yz
	 X1iDY/X6yGPoH3TWvwLk27e6BYuQEnvWr/UO2XGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 09/60] mtd: rawnand: arasan: Fix missing de-registration of NAND
Date: Mon, 30 Dec 2024 16:42:19 +0100
Message-ID: <20241230154207.638808832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1510,8 +1510,15 @@ disable_controller_clk:
 
 static int anfc_remove(struct platform_device *pdev)
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
 
 	clk_disable_unprepare(nfc->bus_clk);


