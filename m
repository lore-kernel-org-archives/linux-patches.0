Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318CF42F71D;
	Tue, 21 Jul 2026 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669695; cv=none; b=srSPrpRbQEJuF2zcr2SvhIc85uMk+T5UDSI9Zb/dfBb5DRo2DPUWxiB9ZzMAH7uv1TXazzrLBMgEEjrM1u242b14x+/xd+UxGgR2rc9SX0i8JFCOnz6CPA5CzTJfW7Ft+x7e7kJcqYpRbhJP1gvRszIzaRpkFEV/jIQ3yf6hGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669695; c=relaxed/simple;
	bh=doZznMZBSRAfzp6busBJzC2jeZgLtnXWZaOl6JCUVqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9SJzA1CuIZA2MfXKB2tyuiurzHulph6Hdo8eJ8G4pmDyhgTw53egMpz4G6wo8cASukHLyMXZkR1BP2BKq5I77vlWd54ld07MuEBZRWW5rGA7ywKxqN9gIHScWAFzQZCh7EdP7BX/lD2s9EfT6QAkXuThVn/y2RVBHUc69Mg+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovh94ezt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovh94ezt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504471F000E9;
	Tue, 21 Jul 2026 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669692;
	bh=6tdCrPDYIbtyzCtGawWNHy3TvUzBo6MIOj+1Lljedas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovh94eztOXRmMOMAFpIoG8Mpd11ib2cmCd6Sqm+3TjkE5kDyaza3AZ1ORHk56XL2n
	 PU+mjI69+IsBM/q2fcQnTxGoOhsmo9u1rUw3I6g96btskewTSk4hzyTGDmQWRKArUV
	 Ff/q7yJiIZsg9tQBLiu4UeQsbKXIwfyw6K9sr33E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0649/1067] gpio: mvebu: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:20:50 +0200
Message-ID: <20260721152439.109666002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 0ba9d04183a602..53c678ba6c51d8 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1232,7 +1232,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		BUG();
 	}
 
-	devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	err = devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to register gpiochip\n");
 
 	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
 	if (IS_ENABLED(CONFIG_PWM)) {
-- 
2.53.0



