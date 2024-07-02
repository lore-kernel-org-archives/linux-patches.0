Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B041514DC;
	Tue,  2 Jul 2024 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941259; cv=none; b=sDGDQHnjKxM65ytf4JLI+2f7aDA+hfcrq5Gyce+LYhm+XK2q+P02itIbH40OJ9PwMN/wLsMRcSIR+E46ZDtbanYPYhK5LFw5quXzZQn/f5HiVreDW+SrFD4wg4p29a9Lyr7Xg3ZG/i+B0eZKLlex+LnFt968v0m3tgXgOCoKxb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941259; c=relaxed/simple;
	bh=v0mzWV2mJFQSmee/PSUSrvYVX/Ovg+6fwMoX+WdutkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrmO71ixGNxE5a82W3x3AVtdftUyGm42Fy1zA9ukW+JFrmsE7zgkA/+05UYjiwF6avfkqup14m+P/4m9+gp0245WcmFL8eCNeTKliJ0tR2qjGchQHhCp8tg4aIJ2+swzdPb3iLIQJrUQ9PqiVyha26EIy6n4+6yYbuV40XoZt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhdAt9aD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhdAt9aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D81C116B1;
	Tue,  2 Jul 2024 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941259;
	bh=v0mzWV2mJFQSmee/PSUSrvYVX/Ovg+6fwMoX+WdutkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhdAt9aDx/n+o9ihgz0SbR5qQiSpxDSwNDQA8fLlq6TT7yxP3B8UZgg3NJBWyL+Lw
	 G8M8uJ40FSZ3MZmvSUtqH3igV11/LjjjoQ15uFsZz0OPsNBzXzsx+Ho56IR9OwhEa8
	 18p4n2iwqtAVwHsOr/H/4psrJVJCkX4zHTwF+Z0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/128] MIPS: pci: lantiq: restore reset gpio polarity
Date: Tue,  2 Jul 2024 19:03:33 +0200
Message-ID: <20240702170226.699245531@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 277a0363120276645ae598d8d5fea7265e076ae9 ]

Commit 90c2d2eb7ab5 ("MIPS: pci: lantiq: switch to using gpiod API") not
only switched to the gpiod API, but also inverted / changed the polarity
of the GPIO.

According to the PCI specification, the RST# pin is an active-low
signal. However, most of the device trees that have been widely used for
a long time (mainly in the openWrt project) define this GPIO as
active-high and the old driver code inverted the signal internally.

Apparently there are actually boards where the reset gpio must be
operated inverted. For this reason, we cannot use the GPIOD_OUT_LOW/HIGH
flag for initialization. Instead, we must explicitly set the gpio to
value 1 in order to take into account any "GPIO_ACTIVE_LOW" flag that
may have been set.

In order to remain compatible with all these existing device trees, we
should therefore keep the logic as it was before the commit.

Fixes: 90c2d2eb7ab5 ("MIPS: pci: lantiq: switch to using gpiod API")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/pci-lantiq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/pci/pci-lantiq.c b/arch/mips/pci/pci-lantiq.c
index 8d16cd021f604..5c83f54341299 100644
--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -124,14 +124,14 @@ static int ltq_pci_startup(struct platform_device *pdev)
 		clk_disable(clk_external);
 
 	/* setup reset gpio used by pci */
-	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset",
-					     GPIOD_OUT_LOW);
+	reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_ASIS);
 	error = PTR_ERR_OR_ZERO(reset_gpio);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request gpio: %d\n", error);
 		return error;
 	}
 	gpiod_set_consumer_name(reset_gpio, "pci_reset");
+	gpiod_direction_output(reset_gpio, 1);
 
 	/* enable auto-switching between PCI and EBU */
 	ltq_pci_w32(0xa, PCI_CR_CLK_CTRL);
@@ -194,10 +194,10 @@ static int ltq_pci_startup(struct platform_device *pdev)
 
 	/* toggle reset pin */
 	if (reset_gpio) {
-		gpiod_set_value_cansleep(reset_gpio, 1);
+		gpiod_set_value_cansleep(reset_gpio, 0);
 		wmb();
 		mdelay(1);
-		gpiod_set_value_cansleep(reset_gpio, 0);
+		gpiod_set_value_cansleep(reset_gpio, 1);
 	}
 	return 0;
 }
-- 
2.43.0



