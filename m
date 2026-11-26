Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705561;
	b=Pxp3i2GT9BWR5Ibzo/wLwWrUjFGcxDt70cboz6Trb8LFsrcxMDeInJnWteyTrknlcQ2U
	 K9bL0SYZQvLdQCMFoOKEkIf0cupM8R1gIomvjK1Lda3jZLPqAwJ/wNX7/hGXROHc4FSQi
	 lSeHyxv818MaIB8Caqp9oKGDMJEG1dTR80xlDCosIKEuAgbLnmUs8BPkocD2mOFjz4kVe
	 0jdkIU+AsCfs+fzxFqdK9QRRi9Zm4WVtSedUZgTMMtwev92co2SiQTiIj9dQ4Ox5cA5D+
	 s5SrZrOyQXN07/LbJAGeZIF6+tXtiqzW5SKfEeQXXkX+4bKcMYmhuJGa2apyj1AiQFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=el61dRQwP4NjsmQykCMVzoqe0CnxfnIDycVQAR6pc1U=;
	b=F8GcNu3Kxqvumj9L2VwO9/zd7TtDj03KLrBlMbQ5O0Pe4xwYiO+emqRBPk93b8ZDTX3q
	 pDYyWx87o5SerphJV2aRoThfoPQUCVgCPeUFcqkaqPy274LVFQem/Cw4dW35qVh3H/uZF
	 fcBiCMTmtO/UTXvf+6EgXUtp51PV16yWyl8oPw7+/NAOdfu1aQMUOqKA0SGnZUoygkUl4
	 M8ypwXS6iYgxP3adXMkj5H7tMQ8UzPEouff+nP90NAAmL3/QreLQzN0z3UZTAeHLypqND
	 aebdWJ/9UpqxWuMhxCWOKv9ogQqESfVZk0MY0UIxTpBRz2u1bcYpljd5BLm/Q7524pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soBeaycy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C079606A31E;
	Thu, 26 Nov 2026 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soBeaycy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265DC1F000E0;
	Thu, 26 Nov 2026 15:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705560;
	bh=el61dRQwP4NjsmQykCMVzoqe0CnxfnIDycVQAR6pc1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soBeaycyfmaciXA6zoo6qv2/mqmz/8SpSIfBfCzxkmjhLw9XATZugXJqxKrTXf6uP
	 a8BW8649iHacX7AHZ0WNAp54AQzdJ5hErwiETjD5mfx5+Hnw1k9vlQT9rHz2g1Gg/5
	 Tn8/QCff8pWkWGVOxekc5xUdNpdUcSeF1+Ixx6e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 239/319] gpio: sodaville: fix use-after-free bug when registering the irqchip
Date: Thu, 26 Nov 2026 15:40:07 +0100
Message-ID: <20261126144012.140670636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


