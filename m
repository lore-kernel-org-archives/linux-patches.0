Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5195A9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09ACC433C8;
	Sun, 13 Aug 2023 21:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962004;
	bh=SUzloAaHKebh0i07lhExKnM+0s1HO9wQJ1U8Tc7pdTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hySIvO/t9SkvtXc3gYrvdPAcdqqSgeiy3DsctMinb/vSniR5YA+Z6CTRbTvyw2k7R
	 5KIqq/cPu3Oa9qJfSSHFnGbXnrcUS9n+t+LSPJNRDqD89eYz5uPXTaq5Zr0R2yvjqn
	 HkIalS2esP+RzBh6tyAbySCgNGWeJOyFN+0UouOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.4 077/206] usb: common: usb-conn-gpio: Prevent bailing out if initial role is none
Date: Sun, 13 Aug 2023 23:17:27 +0200
Message-ID: <20230813211727.282898280@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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
@@ -42,6 +42,7 @@ struct usb_conn_info {
 
 	struct power_supply_desc desc;
 	struct power_supply *charger;
+	bool initial_detection;
 };
 
 /*
@@ -86,11 +87,13 @@ static void usb_conn_detect_cable(struct
 	dev_dbg(info->dev, "role %s -> %s, gpios: id %d, vbus %d\n",
 		usb_role_string(info->last_role), usb_role_string(role), id, vbus);
 
-	if (info->last_role == role) {
+	if (!info->initial_detection && info->last_role == role) {
 		dev_warn(info->dev, "repeated role: %s\n", usb_role_string(role));
 		return;
 	}
 
+	info->initial_detection = false;
+
 	if (info->last_role == USB_ROLE_HOST && info->vbus)
 		regulator_disable(info->vbus);
 
@@ -258,6 +261,7 @@ static int usb_conn_probe(struct platfor
 	device_set_wakeup_capable(&pdev->dev, true);
 
 	/* Perform initial detection */
+	info->initial_detection = true;
 	usb_conn_queue_dwork(info, 0);
 
 	return 0;


