Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90954CE681;
	Wed, 30 Sep 2026 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784572; cv=none; b=Ewq7Ki9MIVwliPwmbMFIkrG+l6sMwlT88ZF+Sej5+Q2/xTo4E8effBagUHQVn8h6xh4D/2oGki5zDjKqKUbKiEt43ciRJGErnFPXpf1fasSFNyCrgzjapsqRF1jx/D6FegQYm+EG50Jn5+tXXHCudK+xGF2ylrGs/Y6atWF/yZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784572; c=relaxed/simple;
	bh=72ouFEsGbmyY9wTPQwYj8h5NN47NW/eAirZ1ecIGyDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzsfPTUh872jCmZV3aZT4d8K7Lq5DR28k2ODmZLDsiXjUleE0C5v54RWumU095SPobllIb+HQ7OpetXjG4Sdh7RVHDgkwuCxZjcuCtS85J/g5taQU8wRArTJX9wU0nR9AFEacZuL1cNlIGkTgj5huZYWXRkd3JX7GjarEWV4TxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laEaPn4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laEaPn4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9041F000FF;
	Wed, 30 Sep 2026 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784567;
	bh=5EJFBX1g0Dr1spUB6xwml6p0Eavpzi0crVWvcsv4x5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laEaPn4/n0U/GZFFmkDjrhXGgGacfbk4qvcj66ReSYxR8dPnCT5AULwwEa20SXuga
	 dF3uOttudg63Eky2pus2a9YQBS7GCRt28uAyB4R7ubSf2g5xeku7lxqeNx9KN9vZ57
	 JjuflOLo8Pk878KrEy5215iNdbskQaql1DBClLxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/982] gpio: pisosr: Read "ngpios" as u32
Date: Wed, 30 Sep 2026 17:15:36 +0200
Message-ID: <20260930152421.107873603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 4910aa198d25e5d1067236560ba34ab12bccc677 ]

The generic "ngpios" property is encoded as a normal uint32 cell. The
pisosr driver stores it in the gpio_chip field, but reading it with a
u16 helper does not match the DT property encoding.

Read "ngpios" as u32 and keep the existing assignment to the chip
field.

Assisted-by: Codex:gpt-5-5
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260612215216.1887485-1-robh@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pisosr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pisosr.c b/drivers/gpio/gpio-pisosr.c
index 67071bea08c26..2c8bb0ab488ed 100644
--- a/drivers/gpio/gpio-pisosr.c
+++ b/drivers/gpio/gpio-pisosr.c
@@ -120,6 +120,7 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct pisosr_gpio *gpio;
+	u32 ngpios;
 	int ret;
 
 	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
@@ -130,7 +131,8 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 
 	gpio->chip = template_chip;
 	gpio->chip.parent = dev;
-	of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
+	if (!of_property_read_u32(dev->of_node, "ngpios", &ngpios))
+		gpio->chip.ngpio = ngpios;
 
 	gpio->spi = spi;
 
-- 
2.53.0



