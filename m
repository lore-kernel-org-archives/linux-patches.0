Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FD94F4023;
	Thu, 17 Sep 2026 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664598; cv=none; b=NgSgmxhk4nJ6228ODgRKXrnIZWXR2Bi+4jbLAYSSb/T91ScwoumFgr6eP3IRUDnMp4h8HBLarE/kiW6y2Fx/t5nwGBG2Zl99jbvv92RJhbDAQ0VmugEIDjaC0xHCeI6MNw6DAmfPW0pk/Y3H4KQ2zA0q/4louzsOZ0UtUDOySAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664598; c=relaxed/simple;
	bh=lxugPKnN/zXVr3xRUOXNYM82KlMWswYYFmqW75keDVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwXsi2mUzl8AnjYCDoUhyNuObbKMallKOzwiwOuwy5I0okowkkmYoa4VzgCcO1kZ/kOwms8ZVGHENgD8MJJ0DeR80Ai+3FUJPYiqY+hB+z2xq4h5nLuTwKtA5U4KjiZAnfv4056LV07jOdnIA3edHZrh59qdxyp7vyKk/yF7s68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcYfMyhr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcYfMyhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EBB1F000FF;
	Thu, 17 Sep 2026 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664597;
	bh=T/mNcOC+ANRESCFviAdwAoBxqCZfgWcFtjpgyWDYSOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcYfMyhrXb0l8MSGy/Swh6N1pGE2qzWA842p4tzBGXH9x7K9ojdWBdncdErzofSPS
	 eRD0vQ+v/1p+bykbhVZYflpttSqacJBeNV+lb/G1pK1kfvqZRYfl9hHSY7D4qdzYU3
	 dCqEuniDpSZhvv2uA1gn0MOcs71XZXgISM9J79wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0424/1250] gpio: pisosr: Read "ngpios" as u32
Date: Thu, 17 Sep 2026 16:03:39 +0100
Message-ID: <20260917151603.508619872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7ec6a46ed6007..2732ea8c16b7b 100644
--- a/drivers/gpio/gpio-pisosr.c
+++ b/drivers/gpio/gpio-pisosr.c
@@ -112,6 +112,7 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct pisosr_gpio *gpio;
+	u32 ngpios;
 	int ret;
 
 	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
@@ -120,7 +121,8 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 
 	gpio->chip = template_chip;
 	gpio->chip.parent = dev;
-	of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
+	if (!of_property_read_u32(dev->of_node, "ngpios", &ngpios))
+		gpio->chip.ngpio = ngpios;
 
 	gpio->spi = spi;
 
-- 
2.53.0



