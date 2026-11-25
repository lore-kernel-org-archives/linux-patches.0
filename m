Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620990;
	b=FPIDIODQv2NV6CW9GkVS7gEiDUQW7X1CsZZs8zrC0RDieSqyY+QfiIq9eWM8jkq2BneE
	 C07q1hEF2h7gsrXz0l54XXwZb/FYsCU0QlH+zviM8rWnKb4/jqfK0aG8xVfQIoTxticsz
	 tA/bG1uXI8FcBzlB2M6et8qo/V7DREWdmo6AyjDvCI6oNHQV4QV7tFE7gTJRaLhPrAcCN
	 r+eyMccRWy1zMt4OqpPNtcROw4p+SbCZCv+rHNELtZ5Pmb48Mio1JhOTGDTZJA8tyaWrr
	 7RattMh5Sn1TEtK9WS1rc+/Ghq5FsSUZ/yy3JEmJm+2NMPSEHoucemxnVGk99Q+XdQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OvYGaguo31zF/ACQilfBIIziN+FdgX71myHoYPdxmoI=;
	b=PNSqG03Gm4eCtGrTnoKng0ypSt1vMEm9eYLBRoS5KaKFr4xqvj3wTvQJIkFtmS2r2Rru
	 qOW4S3OQ+zgsi+ro8T7GFyJnMM9FZprvHgxMgT2dyPUoXRKEQn+XZ01lx6UJQIZMasAMZ
	 SpD49mXG8XfcgGcyC/WgnGj8ZixlCOpHDOuV5Ne8KCGPvgo6S1nSUHL4zCMcIEpdoppOy
	 sZD15niwxHURFeimm87q0rz4VETFxparVCukfK09X11XfW/03FC/3P7XNvgv6KagipJu8
	 8XRC55H00MATr9N0tOOD3H5kKfAmXzCGFucPMgdS9rb70T5SKyTMBbczllz5oq0zV+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFRln2mP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B41C607DE5B;
	Wed, 25 Nov 2026 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFRln2mP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACCB1F000EF;
	Wed, 25 Nov 2026 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620989;
	bh=OvYGaguo31zF/ACQilfBIIziN+FdgX71myHoYPdxmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFRln2mPpCzJtpoWqyTe/g5dx5RFyEPpd/XyCQ9ktWNYFsTQIvRHFxQmRFZoImOMi
	 YRfJYjtmxPFs4dU3rbWK+CHlFrgVtG65C4DquIvrI6QkHhQJzWa83Onv9+fv1eL/hi
	 IHOjovBI2JlGuUjFLTFn//1VW3o//scs+llvZa5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/990] gpio: omap: Propagate runtime PM failures in probe and request
Date: Wed, 25 Nov 2026 15:24:13 +0100
Message-ID: <20261125143824.107393236@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 05be1a99d6d68b24cbe24a191e1af67c70193ac3 ]

pm_runtime_get_sync() can fail when the OMAP PM domain cannot
resume a GPIO controller, but omap_gpio_probe() and
omap_gpio_request() ignore its return value.

Consequently, probe can register a GPIO controller despite a failed
resume, while a GPIO request can report success and modify GPIO
state even though runtime-PM acquisition failed.

Use pm_runtime_resume_and_get() in both paths and propagate
resume errors. On probe failure, disable runtime PM and unprepare
the debounce clock when applicable.

Reproduced both failures on QEMU N800 by injecting -EIO from the
OMAP PM-domain resume callback. The original driver continues
probe and accepts the GPIO request - while the patched driver
rejects both operations with -EIO. Normal GPIO controller
registration continues to work without fault injection.

Fixes: 77640aabd755 ("OMAP: GPIO: Implement GPIO as a platform device")
Fixes: 55b93c32520d ("gpio/omap: use pm-runtime framework")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261029103626.1527919-2-thnkslprpt@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 8693544304fa8..2ebef18c37abe 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -814,8 +814,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank = gpiochip_get_data(chip);
 	unsigned long flags;
+	int ret;
 
-	pm_runtime_get_sync(chip->parent);
+	ret = pm_runtime_resume_and_get(chip->parent);
+	if (ret < 0)
+		return ret;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
 	omap_enable_gpio_module(bank, offset);
@@ -1469,7 +1472,13 @@ static int omap_gpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bank);
 
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		pm_runtime_disable(dev);
+		if (bank->dbck_flag)
+			clk_unprepare(bank->dbck);
+		return ret;
+	}
 
 	if (bank->is_mpuio)
 		omap_mpuio_init(bank);
-- 
2.53.0



