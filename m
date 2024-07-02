Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733BE15218A;
	Tue,  2 Jul 2024 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940933; cv=none; b=U4fyPyL+BdNjltb6CDDvbdRAxmF3c1sac7LDkzSlPreo9rQvQ6TSULNJnNzCMvjcHDPxWL7SUmTwBziRx4nVjG3oYVVfJUKZchvsufyzCz3lSL8dnKpq5ehho3j97gz/v/QPyUrX/+5zSAkwUyM6FpuWxqx/NIXyjmWPct3FYWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940933; c=relaxed/simple;
	bh=JY/X8N1Tf7bkDDpI5OjStF4CcjwjpJx/fszVKayEvfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn7q7Cq4WDHY0p8c+z8f37La1gxwcBDG1VDJ+pt8Xl2Bb6OgNPjadH9C6WcrO0Eul+OEg80G/+YTFqI8pF3q3kKRjGqr+LElFNpg4X1L0jJnKvGPbFdCPSFQIvyHfKOD0GDMVuuJReTo9aefwbImnog6NaFBf60b8rnIgrRUTzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx8co11V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx8co11V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BCDC116B1;
	Tue,  2 Jul 2024 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940932;
	bh=JY/X8N1Tf7bkDDpI5OjStF4CcjwjpJx/fszVKayEvfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx8co11VfDK7h283IVt2tpnF4k54WnOnVsm2y05QR1FC31dJjHJbrQVtPA9H1mNwX
	 /OTkhPxp/T8XRo1SpvdnkEuOsSo2Uns7i1IQacls7TezhRLCSm/LLfFsAnKa/bd8l7
	 OFXm4MzRdFY8wv+rswMHzGaNzs+fhUIBiI7rR4Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 080/163] Revert "MIPS: pci: lantiq: restore reset gpio polarity"
Date: Tue,  2 Jul 2024 19:03:14 +0200
Message-ID: <20240702170236.090316103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 6e5aee08bd2517397c9572243a816664f2ead547 upstream.

This reverts commit 277a0363120276645ae598d8d5fea7265e076ae9.

While fixing old boards with broken DTs, this change will break
newer ones with correct gpio polarity annotation.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-lantiq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -124,14 +124,14 @@ static int ltq_pci_startup(struct platfo
 		clk_disable(clk_external);
 
 	/* setup reset gpio used by pci */
-	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_ASIS);
+	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset",
+					     GPIOD_OUT_LOW);
 	error = PTR_ERR_OR_ZERO(reset_gpio);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request gpio: %d\n", error);
 		return error;
 	}
 	gpiod_set_consumer_name(reset_gpio, "pci_reset");
-	gpiod_direction_output(reset_gpio, 1);
 
 	/* enable auto-switching between PCI and EBU */
 	ltq_pci_w32(0xa, PCI_CR_CLK_CTRL);
@@ -194,10 +194,10 @@ static int ltq_pci_startup(struct platfo
 
 	/* toggle reset pin */
 	if (reset_gpio) {
-		gpiod_set_value_cansleep(reset_gpio, 0);
+		gpiod_set_value_cansleep(reset_gpio, 1);
 		wmb();
 		mdelay(1);
-		gpiod_set_value_cansleep(reset_gpio, 1);
+		gpiod_set_value_cansleep(reset_gpio, 0);
 	}
 	return 0;
 }


