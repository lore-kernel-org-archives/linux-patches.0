Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFBA21FF21;
	Tue, 12 May 2026 17:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607942; cv=none; b=VcaWGCsmb6nB8E+21LHa8iMkbILkIM57guUvl2eXGHjND6hLNZtfXpTc8VEl1wlkJUcI65rBqXl12Ezjx+w785KFla04Zl0P2Uo6is9co8Ypc70/J8zz4zyz9VIsq1jQK9otSiBd/3G2LQ7kTKLvBqB1XzS6X+jb+t2dT9jT1mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607942; c=relaxed/simple;
	bh=DKhhVZNT4bVPB5ayPF9Rlo14H0AdHaH6YtsJeGoYe1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqRf3r9LM7miHP0jprBu1CwLZP1OEPtvvo9YGVskkVcmuXuxB1FPMfGl7U7yaD7pDZXR2oR72epKV+HSEuNxmmhCC4q+24EsOokgkDerf5N1XRxA2tXkp1Am+V8aWypktsemUm2okHCZUSlAx0WAXfSY5/WnsX/rNDNt2ZBDDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVnCbzms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVnCbzms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4C8C2BCB0;
	Tue, 12 May 2026 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607941;
	bh=DKhhVZNT4bVPB5ayPF9Rlo14H0AdHaH6YtsJeGoYe1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVnCbzmsvkyottnAKItd92a9jKN3m0aY/ZX5zplN2fa0Kg2xg2Qx/LNRFxEZrSolA
	 t2BbJmpCilZ2tZallrdeFCa0PCQoix6U58YOykS4M4NXMEBPrr/fJfxtGaWoTm253r
	 hk8p1q3E6hx6nnu2+qC2zk3Pv5tgcgfl3C5mQFGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 094/206] gpio: of: clear OF_POPULATED on hog nodes in remove path
Date: Tue, 12 May 2026 19:39:06 +0200
Message-ID: <20260512173934.847687723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bbee90e750262bfb406d66dc65c46d616d2b6673 upstream.

The previously set OF_POPULATED flag should be cleared on the hog nodes
when removing the chip.

Cc: stable@vger.kernel.org
Fixes: 63636d956c455 ("gpio: of: Add DT overlay support for GPIO hogs")
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260309-gpio-hog-fwnode-v2-1-4e61f3dbf06a@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -1196,5 +1196,12 @@ int of_gpiochip_add(struct gpio_chip *ch
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
-	of_node_put(dev_of_node(&chip->gpiodev->dev));
+	struct device_node *np = dev_of_node(&chip->gpiodev->dev);
+
+	for_each_child_of_node_scoped(np, child) {
+		if (of_property_present(child, "gpio-hog"))
+			of_node_clear_flag(child, OF_POPULATED);
+	}
+
+	of_node_put(np);
 }


