Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704781;
	b=Tf3w77UTgQLAVXj7aacSIRgy4Th5HU8OvYdkk4MIflqfClaZWA24pR2gLKhkiyOO2sU4
	 ew0C54qrASZ2wP5CJ8qoBIkTBji1zFFKFH5IetZD5F7UzPqnNgTm2ZlOl3jsZiFy1p/Eo
	 zXbGdnO7EqIH3UOHLfVVYxiXoZyQFbUBayghcD0pLSG8qXaniM2FZQ6kZGXZnP2ofGy2h
	 XcoEJim/c9sZkfZyHtMTD2XjS3ToM1Up7hyVXTNr0ck7T24Nm0pEmkoVCotOSZAcBqitY
	 an5KcNhD/p1K+mZDDYR9wsNCE1FwyVZxvGVNnz6Zmk0ivOwS48+gEuHkwgnoLsiImWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NUg++9ekoIZQoiYXJmG9mIWQGqqoYYvqG3vILnPSs5U=;
	b=EvlwBDyCqqN2Z0bo4LnfM6NDsff3EkUiktCUnFV6fnQ42V06g32u7eOMUVaXz1wwmdON
	 xKgHzNVNVVwnG1hw1YVmtmJNnl6p7SNjZ/PXLDMBc88kXQl2pD8Hd8qOqu+5wsRFFdVyv
	 yiJ1JA481JWZuKWCk2WiHAjncG1HD5h2xeEUx1CR0NqK5LS4K0jU4iQlC+B9wcgS5AtPt
	 ibACFr0IQq6xAMOrFGSFPdBXbjSLIYtPoAq5FFiv3C7vw69OQDq2+hkWtXAEeUs5DFMfi
	 VcYOjArjnd7pLNadiyVqSo3innwWzPiPq8R79mf4A2W56EdxrRtsnA68vptgdz31Vzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jaC//Ywz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8C6606A31C;
	Thu, 26 Nov 2026 14:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jaC//Ywz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E81F000C6;
	Thu, 26 Nov 2026 14:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704780;
	bh=NUg++9ekoIZQoiYXJmG9mIWQGqqoYYvqG3vILnPSs5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaC//Ywzw0DXfTmTGm7rJxnUcRVNov3zvMTTv1XKZCzMixbvy2p9YeNpFLpvKSrlz
	 cHRNQcgrItUha7QOR6CY4a5Z9vvioxKaO+6jweTfL0nRnlnly3DxNNRt7fNGs3oLK6
	 wHd3dUlruHKw5BlBNoC4EMU++MeGO7f/MoTndLUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 197/265] gpio: sodaville: fix use-after-free bug when registering the irqchip
Date: Thu, 26 Nov 2026 15:38:47 +0100
Message-ID: <20261126143618.995861011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit ab9102375b7c77e0c4d33c7594e514454dc9f2b3 upstream.

In sdv_register_irqsupport(), if irq_domain_create_legacy() fails during
device probing, a generic IRQ chip is left registered in the global gc_list
while its underlying memory is freed, leading to a use-after-free. Use
the managed variant of irq_setup_generic_chip() to ensure that the chip
gets unregistered before the memory it uses is freed.

Cc: stable@vger.kernel.org
Fixes: 9381fc5d655d ("gpio: sodaville: Convert to use managed functions pcim_* and devm_*")
Closes: https://sashiko.dev/#/bug/linux-2f7ac8b6-5034-4ff1-9afa-5700ff44e3e9
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261105-gpio-sodaville-use-after-free-v1-1-f572f40feedd@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sodaville.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -165,9 +165,12 @@ static int sdv_register_irqsupport(struc
 	ct->chip.irq_eoi = irq_gc_eoi;
 	ct->chip.irq_set_type = sdv_gpio_pub_set_type;
 
-	irq_setup_generic_chip(sd->gc, IRQ_MSK(SDV_NUM_PUB_GPIOS),
-			IRQ_GC_INIT_MASK_CACHE, IRQ_NOREQUEST,
-			IRQ_LEVEL | IRQ_NOPROBE);
+	ret = devm_irq_setup_generic_chip(&pdev->dev, sd->gc,
+					  IRQ_MSK(SDV_NUM_PUB_GPIOS),
+					  IRQ_GC_INIT_MASK_CACHE, IRQ_NOREQUEST,
+					  IRQ_LEVEL | IRQ_NOPROBE);
+	if (ret)
+		return ret;
 
 	sd->id = irq_domain_add_legacy(pdev->dev.of_node, SDV_NUM_PUB_GPIOS,
 				sd->irq_base, 0, &irq_domain_sdv_ops, sd);


