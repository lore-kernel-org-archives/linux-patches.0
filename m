Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A57F342C92;
	Mon, 18 Aug 2025 13:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523296; cv=none; b=UQG9/eIMo5FelZdl4c39m6srp4+3fDobr+TYer18+xfL9TgTpvlbDjF8fa6NhRpVJjV+Zy0ko6/1Z7NjczY91egyTsc58etajmtNroJKJwm/bJC51W88mvR8ycln/Y6HdznxvCWyAIBtyFgxcCY5bHRPw8nCU7kteDJtepZkHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523296; c=relaxed/simple;
	bh=Z0izx6XdtogP+3MU1EfzHC2Khb5ijdr+aWYdwiKa4O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dM7wA8GIZk8oX17GshftC9izt1aDVTwUYsSauL7z75KBQlVWrphkZ8EZ1jtga/ey2nOigJ1hC9Siv6I6ZHnRtbC9dyfTwUrjzkDmdKAxPhb9IRnEgVDlYpqCFTtzgmqX01uKTqXrfvMsHiE6J7x6Z3mUcjmlxSBR7hsRvfK02GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3xEhoKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3xEhoKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FC3C4CEEB;
	Mon, 18 Aug 2025 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523295;
	bh=Z0izx6XdtogP+3MU1EfzHC2Khb5ijdr+aWYdwiKa4O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3xEhoKrEZFl52fUj6fDIrkG8pGEdBEwWzjP6HddgdtdwdLugnBwP/TR0wUTfxS8R
	 xgpuWPRjrVSKVwZrbScGomIBmjKqZ4y2TUl1MMBt+rdtwMFE9jocEzMuu0u+/3/rNn
	 nspG+vf50IyeQZg0TGIYef5mAubN+I116eJZPEHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 128/515] gpio: loongson-64bit: Extend GPIO irq support
Date: Mon, 18 Aug 2025 14:41:54 +0200
Message-ID: <20250818124503.330254678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 286a3876ed0c..fd8686d8583a 100644
--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -220,6 +220,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data0 = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data1 = {
@@ -228,6 +229,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data1 = {
 	.conf_offset = 0x0,
 	.in_offset = 0x20,
 	.out_offset = 0x10,
+	.inten_offset = 0x30,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data2 = {
@@ -244,6 +246,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls3a5000_data = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls7a_data = {
@@ -252,6 +255,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls7a_data = {
 	.conf_offset = 0x800,
 	.in_offset = 0xa00,
 	.out_offset = 0x900,
+	.inten_offset = 0xb00,
 };
 
 /* LS7A2000 chipset GPIO */
@@ -261,6 +265,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls7a2000_data0 = {
 	.conf_offset = 0x800,
 	.in_offset = 0xa00,
 	.out_offset = 0x900,
+	.inten_offset = 0xb00,
 };
 
 /* LS7A2000 ACPI GPIO */
@@ -279,6 +284,7 @@ static const struct loongson_gpio_chip_data loongson_gpio_ls3a6000_data = {
 	.conf_offset = 0x0,
 	.in_offset = 0xc,
 	.out_offset = 0x8,
+	.inten_offset = 0x14,
 };
 
 static const struct of_device_id loongson_gpio_of_match[] = {
-- 
2.39.5



