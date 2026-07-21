Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23789382385;
	Tue, 21 Jul 2026 22:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673997; cv=none; b=rdGMuvj195AixfNdaE94wW7iIJyCNQ+TI3eoIUh4E5i99MhS9wUFbh2VK8vrQJiuX+JG3TQw59NmS0nxK5Qru4ad7umfNz1M8AKrNzmD6zrp0wSG7M5ykX/rzVCbnu9dIHIpqyldJkzVQy8zegi2H37wB1BVI9+ikM1hH0DC+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673997; c=relaxed/simple;
	bh=xKFQNogv9B6k5rfOL/N7EGq5d1iGubVW8kx3IGtzAgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTpo8CE3GVyYpDaqUoLUrO3mcwt5IgLYcmsg57W1dIoxE/lufq/HqMbSFhSCgEyO1oECJmSKCimd/3XJ5iPFSME+PEVP687ZS1lt4AZBkymVtdi5KQ6xVP8XVpOn8xX+0dmFaYk4W8IASkSy2pL8RFPk5/fH+5mN6/rw9Tuq5kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfXJOKD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfXJOKD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891F61F000E9;
	Tue, 21 Jul 2026 22:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673996;
	bh=U2nJKzS6cJgmTbPMwYondPmJB4RmxeNOGrrp6Ip2qOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfXJOKD3WRCGqXUGN9q2+6SxPPzAYLFTznvB5MKUxglvC1XF9EBJt68H3md2rApcG
	 Qm1eq6UC2xLJvcXunm55r+9R1dWVLdK+sMNMwRBFd97ZROuryfKXO2tSw5MkAP/cRd
	 g7cmIMXIMK+QYLJKCTa2QcBXesPfXRdaXM4DZ4YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/699] gpio: htc-egpio: use managed gpiochip registration
Date: Tue, 21 Jul 2026 17:22:14 +0200
Message-ID: <20260721152404.151879534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 17326db5f0ab4ec1901e75d052b5ebef486b467f ]

egpio_probe() registers each nested gpio_chip with gpiochip_add_data()
but ignores the return value. If one registration fails, probe still
returns success even though one of the chips was not published to
gpiolib.

Use devm_gpiochip_add_data() and fail probe if any chip registration
fails. This lets devres unwind already registered chips and prevents
the driver from publishing a partially initialized device.

Fixes: a1635b8fe59d ("[ARM] 4947/1: htc-egpio, a driver for GPIO/IRQ expanders with fixed input/output pins")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624131828.94139-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-htc-egpio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-htc-egpio.c b/drivers/gpio/gpio-htc-egpio.c
index a40bd56673fe36..5f12ce9ac28caf 100644
--- a/drivers/gpio/gpio-htc-egpio.c
+++ b/drivers/gpio/gpio-htc-egpio.c
@@ -268,6 +268,7 @@ static int __init egpio_probe(struct platform_device *pdev)
 	struct gpio_chip  *chip;
 	unsigned int      irq, irq_end;
 	int               i;
+	int               ret;
 
 	/* Initialize ei data structure. */
 	ei = devm_kzalloc(&pdev->dev, sizeof(*ei), GFP_KERNEL);
@@ -331,7 +332,10 @@ static int __init egpio_probe(struct platform_device *pdev)
 		chip->base            = pdata->chip[i].gpio_base;
 		chip->ngpio           = pdata->chip[i].num_gpios;
 
-		gpiochip_add_data(chip, &ei->chip[i]);
+		ret = devm_gpiochip_add_data(&pdev->dev, chip, &ei->chip[i]);
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed to register gpiochip %d\n", i);
 	}
 
 	/* Set initial pin values */
-- 
2.53.0



