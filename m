Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA9F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FE3C433EF;
	Wed, 28 Dec 2022 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240529;
	bh=2LTkJeL1P3dA7gCjKQQyXF8xs1PHl7t3fT+QfgQ+Xyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0XnO9ZXb25nYPBGuBZokwaFZYzESoLpuoYvItq4ISM48e+cvI4fiPVgCAvttXLj5
	 x9MDZk/5Fge5EXGiCwpldf+IOG1fUDeIrgW3xa1rC7fj0XWeQ0W8D/1Pz9YIjWKh9e
	 qMP8vQ5iV5e47DyiN7Iu9iUQp7NI+gPK8EybgFO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0171/1073] platform/chrome: cros_ec_typec: Get retimer handle
Date: Wed, 28 Dec 2022 15:29:19 +0100
Message-Id: <20221228144332.658605072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 1a8912caba02522f612d465a4849ce98915b96ad ]

Where available, obtain the handle to retimer switch specified via
firmware, and update the mux configuration callsites to add retimer
support for supported modes.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20220816214857.2088914-8-pmalani@chromium.org
Stable-dep-of: 9a8aadcf0b45 ("platform/chrome: cros_ec_typec: zero out stale pointers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 44 +++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index fcfb98992920..00208ffbe2e7 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -20,6 +20,7 @@
 #include <linux/usb/typec_altmode.h>
 #include <linux/usb/typec_dp.h>
 #include <linux/usb/typec_mux.h>
+#include <linux/usb/typec_retimer.h>
 #include <linux/usb/typec_tbt.h>
 #include <linux/usb/role.h>
 
@@ -56,6 +57,7 @@ struct cros_typec_port {
 	struct usb_pd_identity c_identity;
 	struct typec_switch *ori_sw;
 	struct typec_mux *mux;
+	struct typec_retimer *retimer;
 	struct usb_role_switch *role_sw;
 
 	/* Variables keeping track of switch state. */
@@ -144,6 +146,12 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 		goto mux_err;
 	}
 
+	port->retimer = fwnode_typec_retimer_get(fwnode);
+	if (IS_ERR(port->retimer)) {
+		dev_dbg(dev, "Retimer handle not found.\n");
+		goto retimer_sw_err;
+	}
+
 	port->ori_sw = fwnode_typec_switch_get(fwnode);
 	if (IS_ERR(port->ori_sw)) {
 		dev_dbg(dev, "Orientation switch handle not found.\n");
@@ -161,6 +169,8 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 role_sw_err:
 	typec_switch_put(port->ori_sw);
 ori_sw_err:
+	typec_retimer_put(port->retimer);
+retimer_sw_err:
 	typec_mux_put(port->mux);
 mux_err:
 	return -ENODEV;
@@ -205,6 +215,21 @@ static void cros_typec_unregister_altmodes(struct cros_typec_data *typec, int po
 	}
 }
 
+/*
+ * Map the Type-C Mux state to retimer state and call the retimer set function. We need this
+ * because we re-use the Type-C mux state for retimers.
+ */
+static int cros_typec_retimer_set(struct typec_retimer *retimer, struct typec_mux_state state)
+{
+	struct typec_retimer_state rstate = {
+		.alt = state.alt,
+		.mode = state.mode,
+		.data = state.data,
+	};
+
+	return typec_retimer_set(retimer, &rstate);
+}
+
 static int cros_typec_usb_disconnect_state(struct cros_typec_port *port)
 {
 	port->state.alt = NULL;
@@ -213,6 +238,7 @@ static int cros_typec_usb_disconnect_state(struct cros_typec_port *port)
 
 	usb_role_switch_set_role(port->role_sw, USB_ROLE_NONE);
 	typec_switch_set(port->ori_sw, TYPEC_ORIENTATION_NONE);
+	cros_typec_retimer_set(port->retimer, port->state);
 
 	return typec_mux_set(port->mux, &port->state);
 }
@@ -410,9 +436,14 @@ static int cros_typec_init_ports(struct cros_typec_data *typec)
 
 static int cros_typec_usb_safe_state(struct cros_typec_port *port)
 {
+	int ret;
 	port->state.mode = TYPEC_STATE_SAFE;
 
-	return typec_mux_set(port->mux, &port->state);
+	ret = cros_typec_retimer_set(port->retimer, port->state);
+	if (!ret)
+		ret = typec_mux_set(port->mux, &port->state);
+
+	return ret;
 }
 
 /*
@@ -509,7 +540,11 @@ static int cros_typec_enable_dp(struct cros_typec_data *typec,
 	port->state.data = &dp_data;
 	port->state.mode = TYPEC_MODAL_STATE(ffs(pd_ctrl->dp_mode));
 
-	return typec_mux_set(port->mux, &port->state);
+	ret = cros_typec_retimer_set(port->retimer, port->state);
+	if (!ret)
+		ret = typec_mux_set(port->mux, &port->state);
+
+	return ret;
 }
 
 static int cros_typec_enable_usb4(struct cros_typec_data *typec,
@@ -598,7 +633,10 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 	} else if (port->mux_flags & USB_PD_MUX_USB_ENABLED) {
 		port->state.alt = NULL;
 		port->state.mode = TYPEC_STATE_USB;
-		ret = typec_mux_set(port->mux, &port->state);
+
+		ret = cros_typec_retimer_set(port->retimer, port->state);
+		if (!ret)
+			ret = typec_mux_set(port->mux, &port->state);
 	} else {
 		dev_dbg(typec->dev,
 			"Unrecognized mode requested, mux flags: %x\n",
-- 
2.35.1



