Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623350;
	b=CcSvojacEQlsfdONrvJXebXT32n8c5Ipu8rVYx5E41GVpEx+UlBTee+ZO/H+eAnnaazi
	 qPEtQHESdZG4MOaEdQGfVo8XmT6c0+gUl9cA/OvBkh4qq2y1lEGsvxN6oxHPq5b/SXnUN
	 mukdiD01NMjcaFeBaVtdHE5AD7vj43cPq6CrVBU7HomZ6g0Vgk0PGUSkazNZbEZAe/ll1
	 LgJ9kmnHVUfBMsmQlzFQStd45SnIhk8vFR9el4L0UdrV6DLVIgVZpfAiAO6Rjp9s02qqn
	 L0cpu+INxnKNXrg9IBzUEpez4fbkn3GqKEToLwdluhzZcWgg797x5ZxzsiEKBU2uWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pY3foZxB5rlR1CuBQ1nzqL5IVBXiKXqfITXMAGoDpMQ=;
	b=1h7wFjYhrWXuYF624helWQjGDsmxOUfJGby2rJ1bnYYvNOWewsRDaiO/6rziqws0Eb0+
	 f0IjSYFePhkF5sP/PfefGXBrj+1/cFpRBu5a0agJqBOR3maeYny4MviNF1U93yzIeF3Yz
	 q4SRilaAMRkOtVAD9HmpBpfoHSSM3GTAGL2Lg3omdyLfeDydxJ/t3mmJ8ZETcJYfMiX88
	 BQUL5A2LC3LpBZdwTBTwu18yCjKFj3QQ8VwVhPGHQ6QOKgXwdCZrzc5gHprMKa7lUa1Xb
	 yXZHZ/m1uF+D/E4/0PrbFSht9UZfhNQebcpD04iQUCfsK7ud82D9KiIYSPbFC30FxNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vb1YjiHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DEB606A323;
	Wed, 25 Nov 2026 16:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vb1YjiHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9F31F000C6;
	Wed, 25 Nov 2026 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623350;
	bh=pY3foZxB5rlR1CuBQ1nzqL5IVBXiKXqfITXMAGoDpMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb1YjiHtC/e/kOXoykwuK+0NO/+h89vtXgoGSk6qXt0Yx9GDDzzw/2szkgYgKHIXR
	 qTzbSEoYB2KytzaPjnNZDQXiBDznOPoNZABT0ttCgkxbPH4BuDYLMuj24SgQTgwJ9/
	 UpvqI+paALNbmc0oyyjWpXv8g8o/XScZM/aiG8fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 828/990] gpio: sodaville: fix use-after-free bug when registering the irqchip
Date: Wed, 25 Nov 2026 15:36:35 +0100
Message-ID: <20261125143841.430977250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,9 +166,12 @@ static int sdv_register_irqsupport(struc
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
 
 	sd->id = irq_domain_create_legacy(dev_fwnode(&pdev->dev), SDV_NUM_PUB_GPIOS, sd->irq_base,
 					  0, &irq_domain_sdv_ops, sd);


