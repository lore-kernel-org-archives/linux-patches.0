Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E2712EBCA;
	Tue, 14 May 2024 11:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685739; cv=none; b=up/EpzOWFUo66LBedqXyf7MwCyMQCuD4dIrVOTNEuuRW8+ORJepQyKJs/OdyEkKj+5ZOxnCtTMO3tC5+UcjrNiyeyPJYbWwiba/gvWlE3WCeX6tOUK0rGcWeRCjU4pxHXntqBf7ZM79OkIPpaW2j3D63SJ69LQ37iH5TqDK+dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685739; c=relaxed/simple;
	bh=4xrYzcM4bG1Gcs71cv5/mR1Xce+q2FTkBOpPVIHmz3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvgEBiPiEVgmKQVqIW3Dcou4GCdWLDfUMT6tuLOoldyA4j/+0aSIfGjYl4VJ8+SvFZO7tWJvNjeMMxaGzjYDo9l6Itb2Izgk7S3DkfZZ70scV0QzePcukWev2xJZYw1kU8V6QdvOOwwjsoKG4pAzP3ezkVsjJmOdjjN1yiMRa14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NH5ewGNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NH5ewGNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9477DC32781;
	Tue, 14 May 2024 11:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685739;
	bh=4xrYzcM4bG1Gcs71cv5/mR1Xce+q2FTkBOpPVIHmz3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NH5ewGNt1I6Sr2jmcavEPw85B99DH6aAW24n7TYqxTfH3fVRS82H7QQjxrWOpFwtc
	 IQmMWtJSdzhgIl+1JMAAJ7yf54Tkv/pyjH5z8i8VkDV62KTKY9wP5qrTCOok4ns5ZE
	 yx1K13qfKOCIp4l6wVSe7H7s9zR/GyJhEEbb6s+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 238/301] usb: typec: tcpm: Check for port partner validity before consuming it
Date: Tue, 14 May 2024 12:18:29 +0200
Message-ID: <20240514101041.240519279@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badhri Jagan Sridharan <badhri@google.com>

commit ae11f04b452b5205536e1c02d31f8045eba249dd upstream.

typec_register_partner() does not guarantee partner registration
to always succeed. In the event of failure, port->partner is set
to the error value or NULL. Given that port->partner validity is
not checked, this results in the following crash:

Unable to handle kernel NULL pointer dereference at virtual address xx
 pc : run_state_machine+0x1bc8/0x1c08
 lr : run_state_machine+0x1b90/0x1c08
..
 Call trace:
   run_state_machine+0x1bc8/0x1c08
   tcpm_state_machine_work+0x94/0xe4
   kthread_worker_fn+0x118/0x328
   kthread+0x1d0/0x23c
   ret_from_fork+0x10/0x20

To prevent the crash, check for port->partner validity before
derefencing it in all the call sites.

Cc: stable@vger.kernel.org
Fixes: c97cd0b4b54e ("usb: typec: tcpm: set initial svdm version based on pd revision")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240427202812.3435268-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1488,7 +1488,8 @@ static void svdm_consume_identity(struct
 	port->partner_ident.cert_stat = p[VDO_INDEX_CSTAT];
 	port->partner_ident.product = product;
 
-	typec_partner_set_identity(port->partner);
+	if (port->partner)
+		typec_partner_set_identity(port->partner);
 
 	tcpm_log(port, "Identity: %04x:%04x.%04x",
 		 PD_IDH_VID(vdo),
@@ -1576,6 +1577,9 @@ static void tcpm_register_partner_altmod
 	struct typec_altmode *altmode;
 	int i;
 
+	if (!port->partner)
+		return;
+
 	for (i = 0; i < modep->altmodes; i++) {
 		altmode = typec_partner_register_altmode(port->partner,
 						&modep->altmode_desc[i]);
@@ -3574,7 +3578,10 @@ static int tcpm_init_vconn(struct tcpm_p
 
 static void tcpm_typec_connect(struct tcpm_port *port)
 {
+	struct typec_partner *partner;
+
 	if (!port->connected) {
+		port->connected = true;
 		/* Make sure we don't report stale identity information */
 		memset(&port->partner_ident, 0, sizeof(port->partner_ident));
 		port->partner_desc.usb_pd = port->pd_capable;
@@ -3584,9 +3591,13 @@ static void tcpm_typec_connect(struct tc
 			port->partner_desc.accessory = TYPEC_ACCESSORY_AUDIO;
 		else
 			port->partner_desc.accessory = TYPEC_ACCESSORY_NONE;
-		port->partner = typec_register_partner(port->typec_port,
-						       &port->partner_desc);
-		port->connected = true;
+		partner = typec_register_partner(port->typec_port, &port->partner_desc);
+		if (IS_ERR(partner)) {
+			dev_err(port->dev, "Failed to register partner (%ld)\n", PTR_ERR(partner));
+			return;
+		}
+
+		port->partner = partner;
 		typec_partner_set_usb_power_delivery(port->partner, port->partner_pd);
 	}
 }
@@ -3656,9 +3667,11 @@ out_disable_mux:
 static void tcpm_typec_disconnect(struct tcpm_port *port)
 {
 	if (port->connected) {
-		typec_partner_set_usb_power_delivery(port->partner, NULL);
-		typec_unregister_partner(port->partner);
-		port->partner = NULL;
+		if (port->partner) {
+			typec_partner_set_usb_power_delivery(port->partner, NULL);
+			typec_unregister_partner(port->partner);
+			port->partner = NULL;
+		}
 		port->connected = false;
 	}
 }
@@ -3874,6 +3887,9 @@ static enum typec_cc_status tcpm_pwr_opm
 
 static void tcpm_set_initial_svdm_version(struct tcpm_port *port)
 {
+	if (!port->partner)
+		return;
+
 	switch (port->negotiated_rev) {
 	case PD_REV30:
 		break;


