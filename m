Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620125;
	b=VyfOQN5+l2plfe9GM/20dg0A5IE3R3abo9ICH7qbrkbBNin3qpGXTY5uGNlwzCUFXkhg
	 9td6CRiFVtbNRqQYauU4jbMkc1BR07uig1aOd0dwIz0HSoZn07fwg3MAqq+d2GxvEbopF
	 NrB2KcefH3t9SaC3HXqqsejkyzqZc1RYnTfEHYB64zieag7aBOR1ljJvpkptmlvqFa20G
	 cONDRQhT6bQo+FeYeMEgLpAtp2rQz0yylzdWnhWFWfkdYUJHEUYvsEwkxe5blR3BFicIn
	 hoE/aHrihLQjgSHBAiBvZGzRi1pE7xMtOJA+JvS2hlaybQfa1wwV2oJjRT+q8+hQa5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CaxcK2GprvA+ooddCmLUvec3mwEsVdq/RU5E4pft+/A=;
	b=KPKaZ6vM4Zn4qT3EC1r6vERZNRSo8u9cSbKsNALwPLGVMFQCIk/i9FT7qcRCOzxh7qHL
	 1C/7Ie2F7mm1y4dzMSyAhtK/T2hE7pMGmEXLHuD/xGeHIau6aNnkC0SyCNDZvLP9YKgAN
	 mVLvmwIrd/DByNDsSu+P+sM0DIHfPH8tOe0V6narzMJq337OqB8rYc2MHvLOB3rM524g6
	 9/5YNuUzbtum6TT37BfpyzQ88wLcCUwNnp+gwsBBuDSSiWwRIZaKgxyODdsW7h8hOJJdv
	 TESDjmKqbcnuGw6SA5nBHY5fWRlbk/6r4JK0BJ3ToYWH4ou+M5yOgDgUKTmsSOLDEzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXjRd5FO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905F3606A32A;
	Wed, 25 Nov 2026 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pXjRd5FO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0C71F000CA;
	Wed, 25 Nov 2026 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620125;
	bh=CaxcK2GprvA+ooddCmLUvec3mwEsVdq/RU5E4pft+/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXjRd5FOnNTk42Fvp6Azdq97k2BXlyWOVFNTvlavSfIwTlQj/Dpcy6mxhdb8rfx9g
	 6pOHMI6XrRvj7oA+4loJXT+0TnO2l9v9hxIQpyFEGbk4MoEOHDjn9iIRgEp2e58Cc3
	 FoQidWYIUG91PnhbpFXrlvyEVNSjEGbj0aTtwj5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0817/1005] gpio: sodaville: fix use-after-free bug when registering the irqchip
Date: Wed, 25 Nov 2026 15:35:55 +0100
Message-ID: <20261125143840.866243484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


