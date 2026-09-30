Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135AB42C513;
	Wed, 30 Sep 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791021; cv=none; b=ozgJbLuhjYoO243SyhJK8VKZmUB+YC00fhOll7ZqmEIgG8sWsPI4GdlqfvoeFC3ye2GUvtGMY6nQYM/RklCka5WnmMtjWZZIv+1Cx44NuXDGiwiMbHIGqcHhr2ys69CQCs4rUkAh+TJzRMYtraJYePhmgAzE5cDTTBNunztq8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791021; c=relaxed/simple;
	bh=E3q/WcpZeEI1XIY2EeIHTEuTpJ8gbTS+jCkI0oXYwCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llzlE1mi6C2naRbXHcVcDDijWaJoTJpmErHGLzT3O+VwSpFBoH774m1mUUoYELlxDJ1wL/eFqTqRdv6wQgfiIa+FwqeV8IxoDo1mv5i4/LLYeKKcbwTi9FsizPKjFOYa5Zo1KOmha1SKUMFoMvaj3xr6DPESLWQX3MdtuXVBF3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUadEL1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUadEL1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C00E1F00898;
	Wed, 30 Sep 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791020;
	bh=VPKwgWo/GvUW1KAKNn2Uc5feisJ4+uM1SVPLoWzX37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUadEL1dGHFbOEWTRQYSBbv8nPTib6OKsg/Cb32J+666bz9PFzBz5H6eV2f2XjGx6
	 Pd40mZhs59YjwLoaM8JrXiAd4uLChlIQK4vMmBC1YbllKd5bhKvOJB2/6//I9raFNi
	 DRb/6GMK+KZYo882gjVuu6HkA1ELuZJZmqgNldQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/752] gpio: pisosr: Read "ngpios" as u32
Date: Wed, 30 Sep 2026 17:20:26 +0200
Message-ID: <20260930152401.565663899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e04054cf07e3..9d0dfc8b985f0 100644
--- a/drivers/gpio/gpio-pisosr.c
+++ b/drivers/gpio/gpio-pisosr.c
@@ -128,6 +128,7 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct pisosr_gpio *gpio;
+	u32 ngpios;
 	int ret;
 
 	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
@@ -138,7 +139,8 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 
 	gpio->chip = template_chip;
 	gpio->chip.parent = dev;
-	of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
+	if (!of_property_read_u32(dev->of_node, "ngpios", &ngpios))
+		gpio->chip.ngpio = ngpios;
 
 	gpio->spi = spi;
 
-- 
2.53.0



