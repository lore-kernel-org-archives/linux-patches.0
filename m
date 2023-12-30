Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365279DE;
	Sat, 30 Dec 2023 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6SWDYt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E0C433C8;
	Sat, 30 Dec 2023 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938300;
	bh=h2qOHNguli0fSoEKRtXCDl6NH6FAvdMgSDnZ52hRPRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6SWDYt3FO2AOShesfsIf+0soJErS3VZhVdvTo2Tuu2J5L9rz1UMcC/lrBWkY4kZx
	 ZISfqzy/pVSGo3HfwDKRIu8/b9ql/79L2d2T313h5rxYZGnbhB6Maj8To57P0xoEN8
	 +iwPm2i7lfiZdFHYV3gYI/onpo2sZGnAiFL+0e4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rouven Czerwinski <r.czerwinski@pengutronix.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 079/112] net: rfkill: gpio: set GPIO direction
Date: Sat, 30 Dec 2023 11:59:52 +0000
Message-ID: <20231230115809.291987844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Rouven Czerwinski <r.czerwinski@pengutronix.de>

commit 23484d817082c3005252d8edfc8292c8a1006b5b upstream.

Fix the undefined usage of the GPIO consumer API after retrieving the
GPIO description with GPIO_ASIS. The API documentation mentions that
GPIO_ASIS won't set a GPIO direction and requires the user to set a
direction before using the GPIO.

This can be confirmed on i.MX6 hardware, where rfkill-gpio is no longer
able to enabled/disable a device, presumably because the GPIO controller
was never configured for the output direction.

Fixes: b2f750c3a80b ("net: rfkill: gpio: prevent value glitch during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Link: https://msgid.link/20231207075835.3091694-1-r.czerwinski@pengutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/rfkill-gpio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -116,6 +116,14 @@ static int rfkill_gpio_probe(struct plat
 		return -EINVAL;
 	}
 
+	ret = gpiod_direction_output(rfkill->reset_gpio, true);
+	if (ret)
+		return ret;
+
+	ret = gpiod_direction_output(rfkill->shutdown_gpio, true);
+	if (ret)
+		return ret;
+
 	rfkill->rfkill_dev = rfkill_alloc(rfkill->name, &pdev->dev,
 					  rfkill->type, &rfkill_gpio_ops,
 					  rfkill);


