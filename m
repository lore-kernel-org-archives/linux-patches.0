Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69A9178381;
	Tue,  2 Jul 2024 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939956; cv=none; b=YuZQOZsPVbIZFdjkoqcCBoQFehtBq9xkqSKiYyVPpnYR94q3tKjUJwV5y5DXR/sYtf4gAofPd4iNIUQlXBVvbzdTRYwWgXdh9IIAsTQQ6RnbUpMcvX0KIiQv8kA1ftwzjCadDRnD5PtZd9dzOmyvMVJTHrfu5febJb9RpMNNGdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939956; c=relaxed/simple;
	bh=3//B08kKzE5nq0k2+i0SUMshTltOwuJ1Wc3+kyrQxEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPe/uI/nVt4D5Ci+p8PTae7/fMN2Bo3s6U4owuyPCMZummZYayXNW8J19FPuHsbm79e2fxr2KEqTUy1+rNeBtgJSzXhVx5QaeRXRbL9zdZ/bLD01CMU89azMji2Qgczf/bizCmVIzHEyR9nAzQxqFg3fbqJ9ikk/EY10hjt8inA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvA1tqmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvA1tqmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF5FC116B1;
	Tue,  2 Jul 2024 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939956;
	bh=3//B08kKzE5nq0k2+i0SUMshTltOwuJ1Wc3+kyrQxEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvA1tqmrS3gXxIa5QMvoGf8fKvi03VSlATTi6S1ifel3lpwHsBvNEhxpeqEf9UuRn
	 FCMIQGPboMviVshheAkhlJQZZjZzq1Qh8wr7jmgbMeb14hZ+4GU36Z/pNfKlk1D0yJ
	 RDV05YH8UI7lxoCEqi2fAhDP1cZvezRYBba0Zjyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 010/222] MIPS: pci: lantiq: restore reset gpio polarity
Date: Tue,  2 Jul 2024 19:00:48 +0200
Message-ID: <20240702170244.366476072@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 68a8cefed420b..0844db34022e4 100644
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



