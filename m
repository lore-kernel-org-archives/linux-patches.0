Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328A73B42CB;
	Tue, 21 Jul 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672080; cv=none; b=Mj9cqL8UlLusr0pMErLoDZjhADz7ppO+b8ev5VKUC4my2lmX73Ulu387C1R7BVLebYa4XRN7BzVDJtNJXNG6tctjvDP2iT6F5Lb7aW3bxFJ0KgIJQ2OnrFmxfj+imTHMZEORvpue/O+yn19tW2qtAuQjRwNr2Lg2X7xqFIGqjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672080; c=relaxed/simple;
	bh=vYlRTg0pobgbHcgX4h+ab/4ZjGGGIRvUzIMzmGVmPaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEIma5kzeTiLsf/zySjKCwdFn4Tay24ccI+2ad5M6eaGOVORqkwMIBu1eGzZgjLnCppcg34XH7ZsYfn0IFNNvAIEyM4QJ3NfklSTwbufXN3yC8H4U6aV/tO32XsiWGuP+Xr819zasZbc7sJ+2B7WooawXvXxKLgdMGbqF0hbRvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPJZkWjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPJZkWjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984D81F000E9;
	Tue, 21 Jul 2026 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672079;
	bh=xbpRUPiYR5iFt+0fLoXz1nkrSfyQI/qZr6huikeNwck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPJZkWjGbnkydGyi0daEMJDixg6YiRmGx8JHtoeW0pnDcec1xXq7sqjlCAlybz+ye
	 6OeVH2xwk+OUa6rtIJMpTA9sripAmyJopUnq10Gbx+iO0/QGcLdHWwXW0f1c+c8T4I
	 DfiSpy5OH4/a+Vwe8Y65cb4JkXccZ1OuLSHP04PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/843] gpio: mvebu: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:22:02 +0200
Message-ID: <20260721152416.985233818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index b965513f44fea1..db32f5b4a46cdc 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1233,7 +1233,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
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



