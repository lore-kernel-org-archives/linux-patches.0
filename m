Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053C18EB7;
	Fri,  5 Jan 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMZOhRls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69759C433C8;
	Fri,  5 Jan 2024 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465854;
	bh=df0FKZgJ2QXvSZmCUYW/3gk1vLU9xuRH9sx3hXQtPgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMZOhRlsk+qK8Icm207QyPxu2fEY+XmvvRnH0IaaMXbGOxfkvSvKIvll8ZDy3ozZY
	 Px0C3V/36eXPf9ITkYnGGik6TSafxc1MNFbbUhavee56uJvnLBFRWrrexD13KE0m1r
	 cU/WDUtdvb9KM8C2/4M3WlcG4t9y8YYw1X7Y7Aag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rouven Czerwinski <r.czerwinski@pengutronix.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 40/47] net: rfkill: gpio: set GPIO direction
Date: Fri,  5 Jan 2024 15:39:27 +0100
Message-ID: <20240105143817.167051512@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


