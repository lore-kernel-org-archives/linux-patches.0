Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09CF20C00A;
	Fri, 17 Oct 2025 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716362; cv=none; b=UDAgrBNLMCozUwodmoNDBEJbnmgN3cajy2iCZAAeXjANdCvtpLNhkiz+EWpagkw0h4H/J7alwqc8nMERHudJ2gvM7mi0P0yr/A6FSBiL0nIa1IogkMbxmFLS/UhmOBUY5fCLCRPKudghY6vNwM1A1xT6NqeVU0yTWuSDLPVmA1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716362; c=relaxed/simple;
	bh=z1IbArqWg876BwSlV4P05W2DgCHHrd9leCRNKmQVtwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I22B/hNHUm3Ub/3BuEZzt6R27od6BlsVQdVjT93D0DnJxoOsxVXwRxeynxyEevTxU+lsZEw1A8hLZOCPiuqUn8MHgU+CYB0uzEPBPcsnVxetKn/URlnustr3+JfIJcUna+02Isi/UTnnc511jr+HbpQ9ORGB5ghjB4gZTiPbq3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrZmYE70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrZmYE70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269F1C4CEE7;
	Fri, 17 Oct 2025 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716362;
	bh=z1IbArqWg876BwSlV4P05W2DgCHHrd9leCRNKmQVtwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrZmYE709q6V+zlwKSRdQB/4EsF1suFiQWMnMk+mGixEAUWcsHfulrOV1GrEG2G+D
	 XD7eAR3dm4NpoATKAvuznq4m7f+SaC5v/PRLvzIevG7RyOuoPn028r/9b93I5gnKic
	 6vw0EFqbDWs8pkB51wzDXFj+Uv63o7R6a/yyn1Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/276] gpio: wcd934x: mark the GPIO controller as sleeping
Date: Fri, 17 Oct 2025 16:54:17 +0200
Message-ID: <20251017145148.458658966@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit b5f8aa8d4bde0cf3e4595af5a536da337e5f1c78 ]

The slimbus regmap passed to the GPIO driver down from MFD does not use
fast_io. This means a mutex is used for locking and thus this GPIO chip
must not be used in atomic context. Change the can_sleep switch in
struct gpio_chip to true.

Fixes: 59c324683400 ("gpio: wcd934x: Add support to wcd934x gpio controller")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index cbbbd105a5a7b..26d70ac90933c 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -101,7 +101,7 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->can_sleep = false;
+	chip->can_sleep = true;
 
 	return devm_gpiochip_add_data(dev, chip, data);
 }
-- 
2.51.0



