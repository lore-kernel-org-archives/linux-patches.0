Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6A50E59B;
	Wed, 30 Sep 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782690; cv=none; b=PGY4cJhyJQLxlJdBSn2GnaVviMFn7Vlk0BcOtfgrtLhKMAbwWDvGlEU71sklaltDmJftVADdS3RDrkO4OyPszbSQ9oQzTuAK66vaIZEgMARhmJek2wQOnk0A58tFE6YU0Uo5u7zoWw56EA+revOB6NCSUjJXuv48UMc0O4Zc7oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782690; c=relaxed/simple;
	bh=57JWDcF266DLveY1HzxP1aC4Hs02fTtGeuuAvuHv8Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM312g/MKrp9yCex0Dm7tl5Bl2ZipB9k+D4qYx/gCSpmGjxJC5e5O0RpolvDiwv2zxux7XT0WAxp+zqjyURzVMQ6g6QL8pi+sBZu2/Ym2ACFOmUZRqgK5m3z4AJLAPLTZdr2xY0qZzThZ4QnL7B/CHk7qUjqzzcwZ22G2v4o25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP+ouWAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP+ouWAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9CE1F00898;
	Wed, 30 Sep 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782680;
	bh=SAd0izgRVTx1BjpW0iyy8GAdhfh/6C2/C0OFvtPhE6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP+ouWAAO3FQLElfw+CwcSMAnDtzwRsgRdEA8DOLnnz3pD0DWdqV6s/ufY0xvDslR
	 4U0EtnLEpNTbiBinJ5SQORw+pQw3txYtzMXv4xLCVEka46bV9Ifmng4MVGnIsP2rs2
	 TyYR3xDZenmDzAzrxdM3nkWK72J6ntSKCKwYBTGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/595] gpio: pisosr: Read "ngpios" as u32
Date: Wed, 30 Sep 2026 17:20:25 +0200
Message-ID: <20260930152350.576527656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



