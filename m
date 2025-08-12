Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF24A2FF149;
	Tue, 12 Aug 2025 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020320; cv=none; b=s3gNZeGSoJRvzjRxJkxp27np2tqZ47bekIHgPYIFVgySmF93UpD9lf0vVtgAVWACpdO2dUDlFSMWhDSv/xuKgzCQ9EOEqaAgHSBcrS7aER6KHO5ovm3pi9oS9WzMZP+nSG0taZDeOLaEgNQm++HntqNeNSi4qERkfKxhTyKqioE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020320; c=relaxed/simple;
	bh=uY9h/W6rlk56RRA848ZbZm54ex/9mzBZCcFnLqyOCiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRoOhMG+K6BrGkUSTBpPtzzSC2kM6oVaOkcMYG1EZ9P/kuKdLQOjynTp496x5iPCPXg+/1/490TLdbB7rlWDAIXnRflQ9jNYq+m8i7p3X5pBTevUBmhaG84929ydVldoQLGJ9c0JfoZRqDA0VDL4q8e7o+Mhs/ZA+pNd3OmRzmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c11U/vMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c11U/vMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A08C4CEF0;
	Tue, 12 Aug 2025 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020319;
	bh=uY9h/W6rlk56RRA848ZbZm54ex/9mzBZCcFnLqyOCiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c11U/vMQNFSB3ycE1Jv+Hv3yGRPmmTjIyhOBOpY/HlYtIlHw/f+dqMKLtfGr+wqIN
	 c4XfuCswzt1O164hWeh4nA2ZrgPd+v+Ig9MvuFKV/TpcOLsi1sbOJvULQn50TOI6Nh
	 fXoQ1efbHuS8UVy9iGILaXpYHxCoNoNc5xSKWbQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/253] usb: typec: tcpm: allow switching to mode accessory to mux properly
Date: Tue, 12 Aug 2025 19:27:13 +0200
Message-ID: <20250812172950.654123266@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1032,7 +1032,7 @@ static int tcpm_set_attached_state(struc
 				     port->data_role);
 }
 
-static int tcpm_set_roles(struct tcpm_port *port, bool attached,
+static int tcpm_set_roles(struct tcpm_port *port, bool attached, int state,
 			  enum typec_role role, enum typec_data_role data)
 {
 	enum typec_orientation orientation;
@@ -1069,7 +1069,7 @@ static int tcpm_set_roles(struct tcpm_po
 		}
 	}
 
-	ret = tcpm_mux_set(port, TYPEC_STATE_USB, usb_role, orientation);
+	ret = tcpm_mux_set(port, state, usb_role, orientation);
 	if (ret < 0)
 		return ret;
 
@@ -3686,7 +3686,8 @@ static int tcpm_src_attach(struct tcpm_p
 
 	tcpm_enable_auto_vbus_discharge(port, true);
 
-	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
+	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB,
+			     TYPEC_SOURCE, tcpm_data_role_for_source(port));
 	if (ret < 0)
 		return ret;
 
@@ -3844,7 +3845,8 @@ static int tcpm_snk_attach(struct tcpm_p
 
 	tcpm_enable_auto_vbus_discharge(port, true);
 
-	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
+	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB,
+			     TYPEC_SINK, tcpm_data_role_for_sink(port));
 	if (ret < 0)
 		return ret;
 
@@ -3868,6 +3870,7 @@ static int tcpm_acc_attach(struct tcpm_p
 	int ret;
 	enum typec_role role;
 	enum typec_data_role data;
+	int state = TYPEC_STATE_USB;
 
 	if (port->attached)
 		return 0;
@@ -3876,7 +3879,13 @@ static int tcpm_acc_attach(struct tcpm_p
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
 
@@ -4556,7 +4565,7 @@ static void run_state_machine(struct tcp
 		 */
 		tcpm_set_vconn(port, false);
 		tcpm_set_vbus(port, false);
-		tcpm_set_roles(port, port->self_powered, TYPEC_SOURCE,
+		tcpm_set_roles(port, port->self_powered, TYPEC_STATE_USB, TYPEC_SOURCE,
 			       tcpm_data_role_for_source(port));
 		/*
 		 * If tcpc fails to notify vbus off, TCPM will wait for PD_T_SAFE_0V +
@@ -4588,7 +4597,7 @@ static void run_state_machine(struct tcp
 		tcpm_set_vconn(port, false);
 		if (port->pd_capable)
 			tcpm_set_charge(port, false);
-		tcpm_set_roles(port, port->self_powered, TYPEC_SINK,
+		tcpm_set_roles(port, port->self_powered, TYPEC_STATE_USB, TYPEC_SINK,
 			       tcpm_data_role_for_sink(port));
 		/*
 		 * VBUS may or may not toggle, depending on the adapter.
@@ -4693,10 +4702,10 @@ static void run_state_machine(struct tcp
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


