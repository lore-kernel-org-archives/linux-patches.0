Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74A19443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F781C433C8;
	Sun, 13 Aug 2023 21:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962009;
	bh=MHAYt9nXF93untm5fYy3jt6VKQq9Ox487RA/iJjsDVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2xbFKb4AtuU5P7SDNcuaAtJcUGF9IUa747Lh0Sxi3KPwFfHhdbIZC2jGg6FAZODD
	 179Q82gYVD9DcGVE5i5jwpn10Rx4TjsCSQse8RypUTBmPFaMjKRkGS0y9XRZqgXnFX
	 dgDbHwjbC3cuiy78w58B0zDHv0e2qXAwbYTTqXiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.4 079/206] usb: typec: altmodes/displayport: Signal hpd when configuring pin assignment
Date: Sun, 13 Aug 2023 23:17:29 +0200
Message-ID: <20230813211727.341992771@linuxfoundation.org>
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

From: RD Babiera <rdbabiera@google.com>

commit 5a5ccd61cfd76156cb3e0373c300c509d05448ce upstream.

When connecting to some DisplayPort partners, the initial status update
after entering DisplayPort Alt Mode notifies that the DFP_D/UFP_D is not in
the connected state. This leads to sending a configure message that keeps
the device in USB mode. The port partner then sets DFP_D/UFP_D to the
connected state and HPD to high in the same Attention message. Currently,
the HPD signal is dropped in order to handle configuration.

This patch saves changes to the HPD signal when the device chooses to
configure during dp_altmode_status_update, and invokes sysfs_notify if
necessary for HPD after configuring.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230726020903.1409072-1-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -60,6 +60,7 @@ struct dp_altmode {
 
 	enum dp_state state;
 	bool hpd;
+	bool pending_hpd;
 
 	struct mutex lock; /* device lock */
 	struct work_struct work;
@@ -144,8 +145,13 @@ static int dp_altmode_status_update(stru
 		dp->state = DP_STATE_EXIT;
 	} else if (!(con & DP_CONF_CURRENTLY(dp->data.conf))) {
 		ret = dp_altmode_configure(dp, con);
-		if (!ret)
+		if (!ret) {
 			dp->state = DP_STATE_CONFIGURE;
+			if (dp->hpd != hpd) {
+				dp->hpd = hpd;
+				dp->pending_hpd = true;
+			}
+		}
 	} else {
 		if (dp->hpd != hpd) {
 			drm_connector_oob_hotplug_event(dp->connector_fwnode);
@@ -161,6 +167,16 @@ static int dp_altmode_configured(struct
 {
 	sysfs_notify(&dp->alt->dev.kobj, "displayport", "configuration");
 	sysfs_notify(&dp->alt->dev.kobj, "displayport", "pin_assignment");
+	/*
+	 * If the DFP_D/UFP_D sends a change in HPD when first notifying the
+	 * DisplayPort driver that it is connected, then we wait until
+	 * configuration is complete to signal HPD.
+	 */
+	if (dp->pending_hpd) {
+		drm_connector_oob_hotplug_event(dp->connector_fwnode);
+		sysfs_notify(&dp->alt->dev.kobj, "displayport", "hpd");
+		dp->pending_hpd = false;
+	}
 
 	return dp_altmode_notify(dp);
 }


