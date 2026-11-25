Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625914;
	b=39ul9GajO1RyNFJWlIuY7d2jXszi4QpBW5cs+D1zNtupHywgg0lsycmu/53405xe049B
	 pk8hl0Idua+DT80V4M0udJdbwqOYWVL5Ske/zGvlClUQh6FsCHsER5EaXmTwK5+G/yVJO
	 u0ZP1dAL/RhD1SXH02E3eL8aKUys/8cYl5j1czqtaW4onvlCMW2NOXJaV/UY8c7DSqMW8
	 ISpQCkt0q+80P05HW1tA/l8s71dR5k2Y9buJFC2W95eWsk3D/RqE5knk1PL3UlBHzQdeP
	 NTPNGnbfeGB3fBU8JE44ySbnR9gig4Es60DFoCdDpdYwnjrIx0XlfLg6nijxY2YWjvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhFI/xDgvvrBZuFk6ZUugiWg3qcSSToltIpe3HZapl0=;
	b=yRvkAWGszCs+qgJs4YsQ0x2bklLh+rilHFxIBpgbpfy+Z2aLp02hJbayenlI83cz3XVJ
	 i81gRLzzdAfHY+mHDnmzePQr8Pmm5l0dL2xEyvPMwiETxJhsQwBawy/H09J7fb0Bo1TKY
	 yoK/Jjc4YRqB+D+/XWu4D0+cDG7Vh7soGt1hLhtclil9PWagvnC4098L6kz//aDCmLa40
	 Wd45J7aKdgLvfdaDyF/tV+OlpwZzQAo7aptuwcDqYFMeNw532GuX7WuTPX7qLytpXMZJX
	 1OIVZAeI7g/GoomR6uNVydgskK9mCMZsKOGsq8fIlPztLu/gy80kfKoQW/pEoskvveQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPBCaQyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99112606A32C;
	Wed, 25 Nov 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPBCaQyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8657D1F000CA;
	Wed, 25 Nov 2026 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625914;
	bh=zhFI/xDgvvrBZuFk6ZUugiWg3qcSSToltIpe3HZapl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPBCaQyuFESp23VEu/yNl58fyD8H8X6al0v3a7NLXu/JXVLlysPUQCrHhoKdFAuDG
	 vaWtQg3OFOp4vvstuhC1FXmMBEfOcVF6mhP9pLogcqt3kZ40ssRh0jGK80KedGR8NM
	 VMbPi2SpWrr/UuQkMLmJZALojSB+TrO2cE4DBghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 672/816] gpio: brcmstb: fix UAF after IRQ domain setup failure
Date: Wed, 25 Nov 2026 15:37:00 +0100
Message-ID: <20261125143904.734040490@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit baa14758afb3e2828de1f76511edc1de50216f39 upstream.

When devm_request_irq() fails in brcmstb_gpio_irq_setup(), the error
path removes the IRQ domain but leaves priv->irq_domain non-NULL.

The probe error path subsequently calls brcmstb_gpio_remove(), which
checks priv->irq_domain and attempts to access the already-freed
domain through irq_find_mapping(). It also attempts to remove the
domain again, resulting in a use-after-free and potentially further
memory corruption.

Set priv->irq_domain to NULL after removing it so that the common
cleanup path skips the already-freed IRQ domain.

This issue was found by our static analysis tool under development.

Fixes: 0ba31dc201de ("gpio: brcmstb: consolidate interrupt domains")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261026115227.41779-1-lgs201920130244@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-brcmstb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-brcmstb.c
+++ b/drivers/gpio/gpio-brcmstb.c
@@ -487,6 +487,7 @@ static int brcmstb_gpio_irq_setup(struct
 
 out_free_domain:
 	irq_domain_remove(priv->irq_domain);
+	priv->irq_domain = NULL;
 
 	return err;
 }


