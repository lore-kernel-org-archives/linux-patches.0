Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD313C8E8;
	Mon, 18 Aug 2025 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525042; cv=none; b=elRPt7tO4rXOYPcU9Z7yoIMWt0cSDMfB6p11QmolRCnTVqCtZ4ag3YPONe/vjCLXbE/OAdLuumsFWz7FjYB5OFMoTwAl8srW5a3PvmP8sPEsKoit3ObDThETBdYnuptKeLOhoCDeM75A6hie3BwVdooAUc9DmuZUNzLXPdgHM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525042; c=relaxed/simple;
	bh=MqC7y4nyCwDtJpZup8VITGbEg4pgKezsAb3ylPD8GAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH9sMTQLLK25HspdKuHohk3sKTwDaimy/OeZTZDnBf49/P2g0DpxB2LL2KavMj1VK3ARWCKxJs/SVEfh85nGvfvGoBwyz14LdXADgNwYb8BWs2/Fv2YOpEnCAxMoWcB/yySAwVv2Vz3dyTsE6KnKVBqaZ2/DX7E+hLdZTIPWl88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAkAmkvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAkAmkvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52DC4CEEB;
	Mon, 18 Aug 2025 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525041;
	bh=MqC7y4nyCwDtJpZup8VITGbEg4pgKezsAb3ylPD8GAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAkAmkvOelzBILFfIYqblO7SEy+jTjowogV0zpGA2iw36vsYuCwRRy7t9YuRCeHm5
	 tg2z6c49RtRfp4cu7uroi1R7ebgk9JbDmHQVatiTDKI25nm23wvYcAPY7sp+attiOK
	 EsUFtow0xQV8eu8nIshtoy4Y+lNDMdPzw1L4BPxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 141/570] gpio: loongson-64bit: Extend GPIO irq support
Date: Mon, 18 Aug 2025 14:42:08 +0200
Message-ID: <20250818124511.258156557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit 27cb8f702eb789f97f7a8bd5a91d76c65a937b2f ]

Add the interrupt enable register offset (inten_offset) so that GPIO
interrupts can be enabled normally on more models.

According to the latest interface specifications, the definition of GPIO
interrupts in ACPI is similar to that in FDT. The GPIO interrupts are
listed one by one according to the GPIO number, and the corresponding
interrupt number can be obtained directly through the GPIO number
specified by the consumer.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250714064542.2276247-1-zhoubinbin@loongson.cn
[Bartosz: tweaked the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-loongson-64bit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpio-loongson-64bit.c b/drivers/gpio/gpio-loongson-64bit.c
index 70a01c5b8ad1..add09971d26a 100644
--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -222,6 +222,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data0 = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data1 = {
@@ -230,6 +231,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data1 = {
 	.conf_offset = 0x0,
 	.in_offset = 0x20,
 	.out_offset = 0x10,
+	.inten_offset = 0x30,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data2 = {
@@ -246,6 +248,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls3a5000_data = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls7a_data = {
@@ -254,6 +257,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls7a_data = {
 	.conf_offset = 0x800,
 	.in_offset = 0xa00,
 	.out_offset = 0x900,
+	.inten_offset = 0xb00,
 };
 
 /* LS7A2000 chipset GPIO */
@@ -263,6 +267,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls7a2000_data0 = {
 	.conf_offset = 0x800,
 	.in_offset = 0xa00,
 	.out_offset = 0x900,
+	.inten_offset = 0xb00,
 };
 
 /* LS7A2000 ACPI GPIO */
@@ -281,6 +286,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls3a6000_data = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct of_device_id loongson_gpio_of_match[] = {
-- 
2.39.5



