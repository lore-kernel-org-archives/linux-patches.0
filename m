Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160B515E8B;
	Mon, 30 Dec 2024 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573710; cv=none; b=vBpMX7hHOkAzlut4vB6CbP+wEarlSH4mxkOBYbETbOSpouOVPEvsfE2DHyftOcSifuhaEjXiAA7vZX+nFv7fFcKmvxARtJP/vi+s0ssZIdBHZEb8tlQDGmz/awz+UVIt3mxfJk+wWTEvMEQJI40aUswXffzWeMKlUXhwhVWYcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573710; c=relaxed/simple;
	bh=FZUJ67+Npe30Kc0/bBpkIm3/f6k3QcSmCJIiwOWKQVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxwPLD/uVzuqcNvnMCm7jTFtWBq7sdgvEQVpbi4g4m+6BVsWsVc/M6KE+94AniYN7yNciXGoeGHwHb01lXiVKAl662CU+8nC+JMrGSIRjja8phuxIcvnB6Ja4kWuH1xWos3kJhqudj7GbYvXsB6TFmon1WRXKNDTx7mzvR39PyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxPU0I6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxPU0I6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D22C4CED0;
	Mon, 30 Dec 2024 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573709;
	bh=FZUJ67+Npe30Kc0/bBpkIm3/f6k3QcSmCJIiwOWKQVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxPU0I6cI0MFsHuR5C7h2f3Nn0ly6gSalr1FFoJ+Qz5+vSHSKYYU4cccOAVFoUO16
	 L1KfY0KeDkrHPVoZm2eAJ08OeQB9hLqPE5KuS6q9k5Me5hHOkqinkMaiGYHllqDGYW
	 jMabknn1grRr4of9PJJYT8SlS336wAaDAc/zO7R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 13/86] mtd: rawnand: arasan: Fix missing de-registration of NAND
Date: Mon, 30 Dec 2024 16:42:21 +0100
Message-ID: <20241230154212.219696362@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1479,8 +1479,15 @@ static int anfc_probe(struct platform_de
 
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
 


