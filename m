Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934073AEB38;
	Wed, 30 Sep 2026 18:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794601; cv=none; b=lLIHai97ndWpAKdFS8gjQjnmGr0JY1UFNxB07NKBBqkHaCc8djF8+BcA8AgjlIHkr4+KeMH5KBFyygF/v6QaYAg3lOZIjNVVEe2AiY0iIMhzXUu4Px6B9arW6RX/khT7j98gPpfkUQXKNGSUCWWU222IG6dNTEwFxeW/H8GvOLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794601; c=relaxed/simple;
	bh=5HilJpvaA9J5b+GhhAxDcTNvxDrB4AqShsUpCwCIQmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8QGgp3W7W0IdJ9vEsER42UaQPFFpXqOj99dWLFXRiz8UX5tAwXeDDhMOYpvo719n+ett5W87S7xDVUAoewEY2MJCKyHC6LyKAvFjRDATXorlxetp6HjK8WN7FbLQy6Wj35uC58JYQMzDUbMnXqHHeT4Eaxm2bahwWieEm8SYCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s38lsVG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s38lsVG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4381F00898;
	Wed, 30 Sep 2026 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794600;
	bh=djhpcgkwxEPsEbzY8TDyDdWuBfUoMDvWlSWciZTvP+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s38lsVG1xU58+skDS6FzGhN0b4EZZSkmoQ6b0fzihENV5vTP0fW6qtFEuSYZrF2lz
	 HsoQfrELRRgXYx7RJ5eFQglnAQhD5ffHFpq71a0tXsP4Ni1HBoQ6mwjg/GGoeqEcYl
	 KylK67kZvj1ksDPyTyDW6ET26h20L641JRrJa/zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0231/1193] gpio: pisosr: Read "ngpios" as u32
Date: Wed, 30 Sep 2026 17:15:15 +0200
Message-ID: <20260930152439.328836097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e3013e778e151..dd4a0a990d158 100644
--- a/drivers/gpio/gpio-pisosr.c
+++ b/drivers/gpio/gpio-pisosr.c
@@ -125,6 +125,7 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct pisosr_gpio *gpio;
+	u32 ngpios;
 	int ret;
 
 	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
@@ -133,7 +134,8 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 
 	gpio->chip = template_chip;
 	gpio->chip.parent = dev;
-	of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
+	if (!of_property_read_u32(dev->of_node, "ngpios", &ngpios))
+		gpio->chip.ngpio = ngpios;
 
 	gpio->spi = spi;
 
-- 
2.53.0



