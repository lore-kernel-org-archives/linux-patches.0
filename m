Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625921;
	b=jPHc0Li8Gs7nKMvGD6P8qnhSp7H1pSCrYTqEJIaKbpHDGqEJbcz+hVBY03LS/L25xm/z
	 ISBUXRkztQHxLXIiTGVovrMrRZT9IxMO1ZCJVUwhDJJ0U5NYbwMjXly9MttfxwhaFH2Os
	 SxgxsD8PZAq3a57w2UUmf+WW8PtSWedhm5HH8BYrTrfaosl80so4exQrO0+o4LPI/VB9S
	 Ib5wOLTEpeas/pYht9IqZiafGsRBDZm9fkkNiI2ViM0zuH987aluUuw10OWByEdRvV6sm
	 tKajgQYqqbi9Hlb89NABPeseIzPH34FYvjNO+h8UX6WktWHsjhalTXL4kUeNfDQ3JSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKI3YqaMmrLzxqOLVw0WQaWWv85rzq4TZ/eGPShX/3c=;
	b=XIjEJMRM/ZlTJaUnFrtagyYON4Pg/uVccbNbmA1s+hWNqLW3XyxwF/kiYWwRQiLy1sj7
	 wZdvBUzb75hJJgb4j0hGn4WJjE6Qm2WkzCLotorH8eTfr9ROx53GWsDGkhZnzb2i1yphH
	 XmtLBO6u3XbiJwuGxYmiCnSLuhgMxOLrUlskyzf4T+JAjJCEdS1mQsvSKCAez4NxPV1aH
	 OCmRZJnpRlYv4cJ1VZapDFXtoJSMgqdYb8DZ9KxOvQ3idZEj6cQmOdxvqKyaN3z5NlJ6r
	 Ev9M7OObJ6u71YbK1NLTzYx8zxeTDj9dyOJsk3d6jZIgWguuNk6R8WW9u6FEhMXQmOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AD/U59Wv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E3B606A321;
	Wed, 25 Nov 2026 16:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AD/U59Wv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064721F000CA;
	Wed, 25 Nov 2026 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625920;
	bh=GKI3YqaMmrLzxqOLVw0WQaWWv85rzq4TZ/eGPShX/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AD/U59WvX6lZb1Qoc1KMlKmkiUtWdM1FK7w56hZKS9a44c38WCUY7LVuQURqGTGIq
	 wA0/1/mga/wR9sPlTWlwKTkYLHNEGDm/HjbYMFCxGE5HkJAT+pEVcnYBZYhwMlLMx+
	 wAoYNk2256AFYA5rmseLFWevBvDRlCT9Acz8B/cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 674/816] gpio: sodaville: fix use-after-free bug when registering the irqchip
Date: Wed, 25 Nov 2026 15:37:02 +0100
Message-ID: <20261125143904.780208872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


