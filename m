Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112549446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA19C433C8;
	Sun, 13 Aug 2023 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963232;
	bh=nUMEiokJZiU6tqmO2VDBktmKlW/FpDm0C4mLBA3Q4qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ6VpUl3xS2aKMXwrNnnyJpAcowKuOtAkyPWkP06X3fg4QyHD5pvcL35cm7HIRw+k
	 I/4YaWcuRAORXb06waMwThdN5WBKooG2FBZvkcgW1Y8bNQy6e6xCdqM+WbCJZglCdO
	 5r4p0Amq0pQaFmAXeQf5+qQ3EGvUf4xeA6+2ZdQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 12/39] usb: common: usb-conn-gpio: Prevent bailing out if initial role is none
Date: Sun, 13 Aug 2023 23:20:03 +0200
Message-ID: <20230813211705.255122360@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashanth K <quic_prashk@quicinc.com>

commit 8e21a620c7e6e00347ade1a6ed4967b359eada5a upstream.

Currently if we bootup a device without cable connected, then
usb-conn-gpio won't call set_role() because last_role is same
as current role. This happens since last_role gets initialised
to zero during the probe.

To avoid this, add a new flag initial_detection into struct
usb_conn_info, which prevents bailing out during initial
detection.

Cc: <stable@vger.kernel.org> # 5.4
Fixes: 4602f3bff266 ("usb: common: add USB GPIO based connection detection driver")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/1690880632-12588-1-git-send-email-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/usb-conn-gpio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -38,6 +38,7 @@ struct usb_conn_info {
 	struct gpio_desc *vbus_gpiod;
 	int id_irq;
 	int vbus_irq;
+	bool initial_detection;
 };
 
 /**
@@ -82,11 +83,13 @@ static void usb_conn_detect_cable(struct
 	dev_dbg(info->dev, "role %d/%d, gpios: id %d, vbus %d\n",
 		info->last_role, role, id, vbus);
 
-	if (info->last_role == role) {
+	if (!info->initial_detection && info->last_role == role) {
 		dev_warn(info->dev, "repeated role: %d\n", role);
 		return;
 	}
 
+	info->initial_detection = false;
+
 	if (info->last_role == USB_ROLE_HOST)
 		regulator_disable(info->vbus);
 
@@ -206,6 +209,7 @@ static int usb_conn_probe(struct platfor
 	platform_set_drvdata(pdev, info);
 
 	/* Perform initial detection */
+	info->initial_detection = true;
 	usb_conn_queue_dwork(info, 0);
 
 	return 0;


