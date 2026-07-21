Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4140542FCBC;
	Tue, 21 Jul 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663164; cv=none; b=ZTj/7JVw9xn4rqzehydeqtoSfrWVd7Hu3AxTmhZ4dGYP7IK1MNEJvaRnLr/VUJETFSACCad3WIL57ymtvhdKpY4KoYlrnMLdgO4PwS7ZjOQg1TYSoDURdy5MBSSWtMu72nQmFrS0lMCUYmf4gZjv9oDLHBCUvkaOszbXjuUe3TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663164; c=relaxed/simple;
	bh=fDWpMla77rVcMvUSPGbzUJMhnzkO13GIywFxcMrfA0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qxcb2Dlsty/zXNsF+wU9Xys95++2UalAx5zpGgRNuvp4KdakPt3n9siZ4Js2UAkR1sQOMb56DkUU3UGTYIYgxx6e1nHNePtiVzI+408ieimUG++6hRkWC0VPv7TPdTtmG3wXVl6/PHP1ds4jeCfwh6NU329O3ZoIKZHhdbvFdJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4mfvNoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4mfvNoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1B51F000E9;
	Tue, 21 Jul 2026 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663162;
	bh=QFDKdLA2loAp0AePFOwhWeR7kQXpSVRkYd5GidjAUig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4mfvNoExG15BSZHq1tuct4sD0pWgbK9XNWqCcox7ob58tZDgvI772ZxfPK+MvKFI
	 4+V+lZxtv4gYIyjxUxEo32Ntxm+i0ou13fvJ5uMJWFQKADE/IfCUPl+bldVC0ZniNX
	 xu3akt0rYmUqCrNaK+/Xf33RCM7EPzkhJjjyt4Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0692/1276] gpio: mvebu: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:18:55 +0200
Message-ID: <20260721152501.581835452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 479e91fc92416a4d54d2b3150aa1e4550d9cc759 ]

mvebu_gpio_probe() registers the GPIO chip with
devm_gpiochip_add_data() but ignores the return value. If registration
fails, probe continues and leaves later code operating on a GPIO chip
that was never published to gpiolib.

Return the registration error so the device fails probe cleanly.

Fixes: fefe7b092345 ("gpio: introduce gpio-mvebu driver for Marvell SoCs")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624131645.86884-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index c85ab356bc72a9..60895272d904e6 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1227,7 +1227,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		BUG();
 	}
 
-	devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	err = devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to register gpiochip\n");
 
 	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
 	if (IS_REACHABLE(CONFIG_PWM)) {
-- 
2.53.0



