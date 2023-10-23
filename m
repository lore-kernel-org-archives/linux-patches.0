Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE1125CA
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tw5D+M20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147A1C433C8;
	Mon, 23 Oct 2023 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058824;
	bh=HTApyrNstoRf3c2TNHiBwRMxdsG4m4RErgxOWfeskQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tw5D+M209/qtwktpdxeeqlZQaZfNCAyzU4YtS0b3sruF5z1dUkXaJmQ3VtNZ4JUnL
	 rxBW6lTsb/qD9eosY6sWZ0MlK4RwX506UyRgmoK7DNbDOcOcLVkRPhtuGwf2wTZuvu
	 YeMJkkf8DQp3q8OEL3z0R+PMkwhTJwYrY9IuOfjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 39/66] net: rfkill: gpio: prevent value glitch during probe
Date: Mon, 23 Oct 2023 12:56:29 +0200
Message-ID: <20231023104812.302082694@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit b2f750c3a80b285cd60c9346f8c96bd0a2a66cde upstream.

When either reset- or shutdown-gpio have are initially deasserted,
e.g. after a reboot - or when the hardware does not include pull-down,
there will be a short toggle of both IOs to logical 0 and back to 1.

It seems that the rfkill default is unblocked, so the driver should not
glitch to output low during probe.
It can lead e.g. to unexpected lte modem reconnect:

[1] root@localhost:~# dmesg | grep "usb 2-1"
[    2.136124] usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd
[   21.215278] usb 2-1: USB disconnect, device number 2
[   28.833977] usb 2-1: new SuperSpeed USB device number 3 using xhci-hcd

The glitch has been discovered on an arm64 board, now that device-tree
support for the rfkill-gpio driver has finally appeared :).

Change the flags for devm_gpiod_get_optional from GPIOD_OUT_LOW to
GPIOD_ASIS to avoid any glitches.
The rfkill driver will set the intended value during rfkill_sync_work.

Fixes: 7176ba23f8b5 ("net: rfkill: add generic gpio rfkill driver")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Link: https://lore.kernel.org/r/20231004163928.14609-1-josua@solid-run.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/rfkill-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -111,13 +111,13 @@ static int rfkill_gpio_probe(struct plat
 
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
-	gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
+	gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_ASIS);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 
 	rfkill->reset_gpio = gpio;
 
-	gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
+	gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_ASIS);
 	if (IS_ERR(gpio))
 		return PTR_ERR(gpio);
 


