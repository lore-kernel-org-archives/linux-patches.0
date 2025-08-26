Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4552139C9;
	Tue, 26 Aug 2025 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215616; cv=none; b=EKOuWvwUg2izz5Stq+Kbg1U+zKjkS5RuBBXUyTDkk/6He3BzhmCx9jdCAqPq31NGG1ZpuytwaYkwQi63QCvqJPYkim86iwb8+xeG99i+DLzoKbQAePSaGHBsaebTHxF/w/m74KwM+gb7f0zZeAkC7an+E40aLQKaY3P76COT6KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215616; c=relaxed/simple;
	bh=PH0CEK+eH81IH4gWU03qxEqfuDXSxKrTSsGhblym5Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3+0PCjVsc9KXyZKrxS1hEyWI7U+tsmwpfqi8cJZI1V8rFVfKqJbn7VKTO/TDFbD2c7az6p0P/nEp4y5N5M0HGSuvNgFGY5p0xt0Egnx/p0w6qHNtxjAlpdNWfj8H+6RycW3NhZdECVCYbaUItfsoPCX5B55e3uKniIu3oEj31o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJUxsKTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJUxsKTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74734C4CEF1;
	Tue, 26 Aug 2025 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215615;
	bh=PH0CEK+eH81IH4gWU03qxEqfuDXSxKrTSsGhblym5Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJUxsKTHfP2fAzOSPHjmikLpO4t29FfbzhcVrJMBE4hokbcMzGSyvMJ43h7AQtPno
	 K60scRr+WPZxqrKDHd7B45MX9v7NNMRpF7FFy7G2eLZha4SylBlA0LW1T4WpUMFs0z
	 JqN2i48YmNRlEQZ8JtrQbJLgu1VdSDWcWIZM1i3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/644] usb: typec: tcpm: allow switching to mode accessory to mux properly
Date: Tue, 26 Aug 2025 13:03:12 +0200
Message-ID: <20250826110949.013155882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 8a50da849151e7e12b43c1d8fe7ad302223aef6b upstream.

The funciton tcpm_acc_attach is not setting the proper state when
calling tcpm_set_role. The function tcpm_set_role is currently only
handling TYPEC_STATE_USB. For the tcpm_acc_attach to switch into other
modal states tcpm_set_role needs to be extended by an extra state
parameter. This patch is handling the proper state change when calling
tcpm_acc_attach.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250404-ml-topic-tcpm-v1-3-b99f44badce8@pengutronix.de
Stable-dep-of: bec15191d523 ("usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1024,7 +1024,7 @@ static int tcpm_set_attached_state(struc
 				     port->data_role);
 }
 
-static int tcpm_set_roles(struct tcpm_port *port, bool attached,
+static int tcpm_set_roles(struct tcpm_port *port, bool attached, int state,
 			  enum typec_role role, enum typec_data_role data)
 {
 	enum typec_orientation orientation;
@@ -1061,7 +1061,7 @@ static int tcpm_set_roles(struct tcpm_po
 		}
 	}
 
-	ret = tcpm_mux_set(port, TYPEC_STATE_USB, usb_role, orientation);
+	ret = tcpm_mux_set(port, state, usb_role, orientation);
 	if (ret < 0)
 		return ret;
 
@@ -3622,7 +3622,8 @@ static int tcpm_src_attach(struct tcpm_p
 
 	tcpm_enable_auto_vbus_discharge(port, true);
 
-	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
+	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB,
+			     TYPEC_SOURCE, tcpm_data_role_for_source(port));
 	if (ret < 0)
 		return ret;
 
@@ -3772,7 +3773,8 @@ static int tcpm_snk_attach(struct tcpm_p
 
 	tcpm_enable_auto_vbus_discharge(port, true);
 
-	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
+	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB,
+			     TYPEC_SINK, tcpm_data_role_for_sink(port));
 	if (ret < 0)
 		return ret;
 
@@ -3796,6 +3798,7 @@ static int tcpm_acc_attach(struct tcpm_p
 	int ret;
 	enum typec_role role;
 	enum typec_data_role data;
+	int state = TYPEC_STATE_USB;
 
 	if (port->attached)
 		return 0;
@@ -3804,7 +3807,13 @@ static int tcpm_acc_attach(struct tcpm_p
 	data = tcpm_port_is_sink(port) ? tcpm_data_role_for_sink(port)
 				       : tcpm_data_role_for_source(port);
 
-	ret = tcpm_set_roles(port, true, role, data);
+	if (tcpm_port_is_audio(port))
+		state = TYPEC_MODE_AUDIO;
+
+	if (tcpm_port_is_debug(port))
+		state = TYPEC_MODE_DEBUG;
+
+	ret = tcpm_set_roles(port, true, state, role, data);
 	if (ret < 0)
 		return ret;
 
@@ -4484,7 +4493,7 @@ static void run_state_machine(struct tcp
 		 */
 		tcpm_set_vconn(port, false);
 		tcpm_set_vbus(port, false);
-		tcpm_set_roles(port, port->self_powered, TYPEC_SOURCE,
+		tcpm_set_roles(port, port->self_powered, TYPEC_STATE_USB, TYPEC_SOURCE,
 			       tcpm_data_role_for_source(port));
 		/*
 		 * If tcpc fails to notify vbus off, TCPM will wait for PD_T_SAFE_0V +
@@ -4516,7 +4525,7 @@ static void run_state_machine(struct tcp
 		tcpm_set_vconn(port, false);
 		if (port->pd_capable)
 			tcpm_set_charge(port, false);
-		tcpm_set_roles(port, port->self_powered, TYPEC_SINK,
+		tcpm_set_roles(port, port->self_powered, TYPEC_STATE_USB, TYPEC_SINK,
 			       tcpm_data_role_for_sink(port));
 		/*
 		 * VBUS may or may not toggle, depending on the adapter.
@@ -4615,10 +4624,10 @@ static void run_state_machine(struct tcp
 	case DR_SWAP_CHANGE_DR:
 		tcpm_unregister_altmodes(port);
 		if (port->data_role == TYPEC_HOST)
-			tcpm_set_roles(port, true, port->pwr_role,
+			tcpm_set_roles(port, true, TYPEC_STATE_USB, port->pwr_role,
 				       TYPEC_DEVICE);
 		else
-			tcpm_set_roles(port, true, port->pwr_role,
+			tcpm_set_roles(port, true, TYPEC_STATE_USB, port->pwr_role,
 				       TYPEC_HOST);
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);


