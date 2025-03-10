Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D0623372F;
	Mon, 10 Mar 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629152; cv=none; b=pWf7sTb8oxlOQBw7TlNrOR1+rjqNC/4obJpcgT+SkjlQjiTfkwPguFtWas+Wt6lOcGjrKfMT25KZnxkLLsPMej12yY/ETMjIg55qRN6b0VYrltp0NTqUqj66PyBBu0kpUjKQoVL2ej6kkFOqWieyA0HfEbNKKTRN+ZveynYL9yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629152; c=relaxed/simple;
	bh=4ANDcZ426HbWdWaq64I98kvYJVhvQpdsD5l8XjYADaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAF9WBr7tPW5SckTlszfAtBDaJM8rqDz3yBwQ4apJZNexUReK607jUwqtvhRbYusLSGXAOwYe2ew4gMnyXzFfb+f/HeGWzbM51woh+qclIUcUg5Xwzf83XVIl7v5kFgMWDI1JJHOyQimGg6gH4UJ7U46MO8w2YSc7fNhW6aEbFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QKEIqYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QKEIqYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37AEC4CEEC;
	Mon, 10 Mar 2025 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629152;
	bh=4ANDcZ426HbWdWaq64I98kvYJVhvQpdsD5l8XjYADaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QKEIqYsOIXP1BktEzw7ltKDzYD+q2HX8WGy0y4G66Bj/RI/yOLQvJs9b5C8Z6TTb
	 Ha/fT2VeNWIul+4l3sKnWkAHkJUefmA4lYk/T4HA0tOxA98Bx5uW5+WOlL655Gm4Nu
	 nZui7jLsDKRVNB3cP3WzRVHoKW6xUzSra4DFsk0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.15 196/620] usb: typec: tcpci: Prevent Sink disconnection before vPpsShutdown in SPR PPS
Date: Mon, 10 Mar 2025 18:00:42 +0100
Message-ID: <20250310170553.367975888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Kyle Tso <kyletso@google.com>

commit 4d27afbf256028a1f54363367f30efc8854433c3 upstream.

The Source can drop its output voltage to the minimum of the requested
PPS APDO voltage range when it is in Current Limit Mode. If this voltage
falls within the range of vPpsShutdown, the Source initiates a Hard
Reset and discharges Vbus. However, currently the Sink may disconnect
before the voltage reaches vPpsShutdown, leading to unexpected behavior.

Prevent premature disconnection by setting the Sink's disconnect
threshold to the minimum vPpsShutdown value. Additionally, consider the
voltage drop due to IR drop when calculating the appropriate threshold.
This ensures a robust and reliable interaction between the Source and
Sink during SPR PPS Current Limit Mode operation.

Fixes: 4288debeaa4e ("usb: typec: tcpci: Fix up sink disconnect thresholds for PD")
Cc: stable <stable@kernel.org>
Signed-off-by: Kyle Tso <kyletso@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250114142435.2093857-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c |   13 +++++++++----
 drivers/usb/typec/tcpm/tcpm.c  |    8 +++++---
 include/linux/usb/tcpm.h       |    3 ++-
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -26,6 +26,7 @@
 #define	VPPS_NEW_MIN_PERCENT			95
 #define	VPPS_VALID_MIN_MV			100
 #define	VSINKDISCONNECT_PD_MIN_PERCENT		90
+#define	VPPS_SHUTDOWN_MIN_PERCENT		85
 
 #define tcpc_presenting_rd(reg, cc) \
 	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
@@ -358,7 +359,8 @@ static int tcpci_enable_auto_vbus_discha
 }
 
 static int tcpci_set_auto_vbus_discharge_threshold(struct tcpc_dev *dev, enum typec_pwr_opmode mode,
-						   bool pps_active, u32 requested_vbus_voltage_mv)
+						   bool pps_active, u32 requested_vbus_voltage_mv,
+						   u32 apdo_min_voltage_mv)
 {
 	struct tcpci *tcpci = tcpc_to_tcpci(dev);
 	unsigned int pwr_ctrl, threshold = 0;
@@ -380,9 +382,12 @@ static int tcpci_set_auto_vbus_discharge
 		threshold = AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV;
 	} else if (mode == TYPEC_PWR_MODE_PD) {
 		if (pps_active)
-			threshold = ((VPPS_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
-				     VSINKPD_MIN_IR_DROP_MV - VPPS_VALID_MIN_MV) *
-				     VSINKDISCONNECT_PD_MIN_PERCENT / 100;
+			/*
+			 * To prevent disconnect when the source is in Current Limit Mode.
+			 * Set the threshold to the lowest possible voltage vPpsShutdown (min)
+			 */
+			threshold = VPPS_SHUTDOWN_MIN_PERCENT * apdo_min_voltage_mv / 100 -
+				    VSINKPD_MIN_IR_DROP_MV;
 		else
 			threshold = ((VSRC_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
 				     VSINKPD_MIN_IR_DROP_MV - VSRC_VALID_MIN_MV) *
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2312,10 +2312,12 @@ static int tcpm_set_auto_vbus_discharge_
 		return 0;
 
 	ret = port->tcpc->set_auto_vbus_discharge_threshold(port->tcpc, mode, pps_active,
-							    requested_vbus_voltage);
+							    requested_vbus_voltage,
+							    port->pps_data.min_volt);
 	tcpm_log_force(port,
-		       "set_auto_vbus_discharge_threshold mode:%d pps_active:%c vbus:%u ret:%d",
-		       mode, pps_active ? 'y' : 'n', requested_vbus_voltage, ret);
+		       "set_auto_vbus_discharge_threshold mode:%d pps_active:%c vbus:%u pps_apdo_min_volt:%u ret:%d",
+		       mode, pps_active ? 'y' : 'n', requested_vbus_voltage,
+		       port->pps_data.min_volt, ret);
 
 	return ret;
 }
--- a/include/linux/usb/tcpm.h
+++ b/include/linux/usb/tcpm.h
@@ -145,7 +145,8 @@ struct tcpc_dev {
 	void (*frs_sourcing_vbus)(struct tcpc_dev *dev);
 	int (*enable_auto_vbus_discharge)(struct tcpc_dev *dev, bool enable);
 	int (*set_auto_vbus_discharge_threshold)(struct tcpc_dev *dev, enum typec_pwr_opmode mode,
-						 bool pps_active, u32 requested_vbus_voltage);
+						 bool pps_active, u32 requested_vbus_voltage,
+						 u32 pps_apdo_min_voltage);
 	bool (*is_vbus_vsafe0v)(struct tcpc_dev *dev);
 	void (*set_partner_usb_comm_capable)(struct tcpc_dev *dev, bool enable);
 };


