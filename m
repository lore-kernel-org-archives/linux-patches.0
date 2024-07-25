Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850519D07A;
	Thu, 25 Jul 2024 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918429; cv=none; b=ndwJC5FhvYIVgOcLoRbl/WcxMXh50AJ93YggNcirDlo5elhBR1DjGpF+sVOC6Co620a+/ehYJfjZtxaPfltwJvTjtUsRmaaJq0nKk2qvvE3IdQDM807r6JGVn6X5iDm+tCQfMgR9N7WLtJPCSkjSjqqqRg0uZGxX+Q2PJdV6fPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918429; c=relaxed/simple;
	bh=UmKHu6/VZt+A6YuAe1BjQgmx4LNZQZCEjc5uBi6pH+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DY1wr4I+Pu84cV6aXX5n3QGH8j0NwIXeZYbBJLdnfluTiYHXQHl9j0O0WAQc6ye0jDMthNF7KyNC5H9DvDnKd+5ZCyqAtpWxvUlbUl7FpPSu0HI9O677nwNrxofjmjAV+pGN0ssXzp7vShgTu0Mmn++NZiJxnhAOLkkB3BeUMvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bg6fUArV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bg6fUArV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AC7C116B1;
	Thu, 25 Jul 2024 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918428;
	bh=UmKHu6/VZt+A6YuAe1BjQgmx4LNZQZCEjc5uBi6pH+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bg6fUArVPL7D0gxIC8U1N4Vf8QhTNh7Emo4I2IX1qafEw5s040unX80oc4SVa2MBI
	 OBNpXXhedoW4ZZ082oM2Nh6MousvuMItpv7CR9EUkqFJFIWYm6V6R4cxSbuAvKlTT6
	 BOks729mfvqKlV69jRCwjw1+3KMK0UjBuyhRa0XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/33] gpio: pca953x: fix pca953x_irq_bus_sync_unlock race
Date: Thu, 25 Jul 2024 16:36:40 +0200
Message-ID: <20240725142729.169703470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit bfc6444b57dc7186b6acc964705d7516cbaf3904 ]

Ensure that `i2c_lock' is held when setting interrupt latch and mask in
pca953x_irq_bus_sync_unlock() in order to avoid races.

The other (non-probe) call site pca953x_gpio_set_multiple() ensures the
lock is held before calling pca953x_write_regs().

The problem occurred when a request raced against irq_bus_sync_unlock()
approximately once per thousand reboots on an i.MX8MP based system.

 * Normal case

   0-0022: write register AI|3a {03,02,00,00,01} Input latch P0
   0-0022: write register AI|49 {fc,fd,ff,ff,fe} Interrupt mask P0
   0-0022: write register AI|08 {ff,00,00,00,00} Output P3
   0-0022: write register AI|12 {fc,00,00,00,00} Config P3

 * Race case

   0-0022: write register AI|08 {ff,00,00,00,00} Output P3
   0-0022: write register AI|08 {03,02,00,00,01} *** Wrong register ***
   0-0022: write register AI|12 {fc,00,00,00,00} Config P3
   0-0022: write register AI|49 {fc,fd,ff,ff,fe} Interrupt mask P0

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://lore.kernel.org/r/20240620042915.2173-1-ian.ray@gehealthcare.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index dc4088a47ab2d..5dcc31e5fb3eb 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -489,6 +489,8 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	u8 invert_irq_mask[MAX_BANK];
 
 	if (chip->driver_data & PCA_PCAL) {
+		guard(mutex)(&chip->i2c_lock);
+
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
-- 
2.43.0



