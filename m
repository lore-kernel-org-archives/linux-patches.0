Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42EC350A07;
	Tue, 21 Oct 2025 20:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076869; cv=none; b=LHfTqMAhwQP4irY2bOfiic/80f0Ian32Sju2niiMWyxXlXvbGBn8ebi8pKnQEe80bxh7H1vbkdK9mbWBtq4DrP5QTYAusUAgBytY7rQfq8d7JCfKPToKuo8m9aIiehhLyKXnQk4jpBQ9Y+39vVYseYURrwXWjb10hmfEEAOneXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076869; c=relaxed/simple;
	bh=kBO0SVVXsA/248WDHWUgjLkJoN2BhhO3qPMZ9hEwr7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaX7cHLD30chicPG4BJcNDaJOXyEplIy8IOHivVj6v7plaz/ajsbkbR5OLOYFEnaLZJzCymHkIGmYK/Dlsd3Y70oLmpadVRnhSON9V6IZUBhCrA5mqkIKJjJX8tf9KpLA4qMsxobd3Ejcshbr9ZsYYfnXuZYYBr8vpgU9srgA1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrK7F4aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrK7F4aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2212DC4CEF1;
	Tue, 21 Oct 2025 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076869;
	bh=kBO0SVVXsA/248WDHWUgjLkJoN2BhhO3qPMZ9hEwr7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrK7F4aN3M64axmUO6mU5/fSTln0swvAViQGYbKEE/36+T/GvTs4MG0eHQ3+U5pYO
	 tFVhuWo5+2IMiYhzujaLXvbcrgevstsZQ47M7tubgbe2NcHH0s0YDaKQ9MNDLqCgfB
	 V8Y/hWCRxQsPnHLQt+p5121m7c+bwmgK7tLj4tNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/136] can: m_can: m_can_handle_state_errors(): fix CAN state transition to Error Active
Date: Tue, 21 Oct 2025 21:50:34 +0200
Message-ID: <20251021195037.094682756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 3d9db29b45f970d81acf61cf91a65442efbeb997 ]

The CAN Error State is determined by the receive and transmit error
counters. The CAN error counters decrease when reception/transmission
is successful, so that a status transition back to the Error Active
status is possible. This transition is not handled by
m_can_handle_state_errors().

Add the missing detection of the Error Active state to
m_can_handle_state_errors() and extend the handling of this state in
m_can_handle_state_change().

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Fixes: cd0d83eab2e0 ("can: m_can: m_can_handle_state_change(): fix state change")
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20250929-m_can-fix-state-handling-v4-2-682b49b49d9a@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 4942c42fe184 ("can: m_can: m_can_chip_config(): bring up interface in correct state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 53 +++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index dbcf17fb3ef25..8f663db386948 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -812,6 +812,9 @@ static int m_can_handle_state_change(struct net_device *dev,
 	u32 timestamp = 0;
 
 	switch (new_state) {
+	case CAN_STATE_ERROR_ACTIVE:
+		cdev->can.state = CAN_STATE_ERROR_ACTIVE;
+		break;
 	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cdev->can.can_stats.error_warning++;
@@ -841,6 +844,12 @@ static int m_can_handle_state_change(struct net_device *dev,
 	__m_can_get_berr_counter(dev, &bec);
 
 	switch (new_state) {
+	case CAN_STATE_ERROR_ACTIVE:
+		cf->can_id |= CAN_ERR_CRTL | CAN_ERR_CNT;
+		cf->data[1] = CAN_ERR_CRTL_ACTIVE;
+		cf->data[6] = bec.txerr;
+		cf->data[7] = bec.rxerr;
+		break;
 	case CAN_STATE_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |= CAN_ERR_CRTL | CAN_ERR_CNT;
@@ -877,30 +886,33 @@ static int m_can_handle_state_change(struct net_device *dev,
 	return 1;
 }
 
-static int m_can_handle_state_errors(struct net_device *dev, u32 psr)
+static enum can_state
+m_can_state_get_by_psr(struct m_can_classdev *cdev)
 {
-	struct m_can_classdev *cdev = netdev_priv(dev);
-	int work_done = 0;
+	u32 reg_psr;
 
-	if (psr & PSR_EW && cdev->can.state != CAN_STATE_ERROR_WARNING) {
-		netdev_dbg(dev, "entered error warning state\n");
-		work_done += m_can_handle_state_change(dev,
-						       CAN_STATE_ERROR_WARNING);
-	}
+	reg_psr = m_can_read(cdev, M_CAN_PSR);
 
-	if (psr & PSR_EP && cdev->can.state != CAN_STATE_ERROR_PASSIVE) {
-		netdev_dbg(dev, "entered error passive state\n");
-		work_done += m_can_handle_state_change(dev,
-						       CAN_STATE_ERROR_PASSIVE);
-	}
+	if (reg_psr & PSR_BO)
+		return CAN_STATE_BUS_OFF;
+	if (reg_psr & PSR_EP)
+		return CAN_STATE_ERROR_PASSIVE;
+	if (reg_psr & PSR_EW)
+		return CAN_STATE_ERROR_WARNING;
 
-	if (psr & PSR_BO && cdev->can.state != CAN_STATE_BUS_OFF) {
-		netdev_dbg(dev, "entered error bus off state\n");
-		work_done += m_can_handle_state_change(dev,
-						       CAN_STATE_BUS_OFF);
-	}
+	return CAN_STATE_ERROR_ACTIVE;
+}
 
-	return work_done;
+static int m_can_handle_state_errors(struct net_device *dev)
+{
+	struct m_can_classdev *cdev = netdev_priv(dev);
+	enum can_state new_state;
+
+	new_state = m_can_state_get_by_psr(cdev);
+	if (new_state == cdev->can.state)
+		return 0;
+
+	return m_can_handle_state_change(dev, new_state);
 }
 
 static void m_can_handle_other_err(struct net_device *dev, u32 irqstatus)
@@ -1031,8 +1043,7 @@ static int m_can_rx_handler(struct net_device *dev, int quota, u32 irqstatus)
 	}
 
 	if (irqstatus & IR_ERR_STATE)
-		work_done += m_can_handle_state_errors(dev,
-						       m_can_read(cdev, M_CAN_PSR));
+		work_done += m_can_handle_state_errors(dev);
 
 	if (irqstatus & IR_ERR_BUS_30X)
 		work_done += m_can_handle_bus_errors(dev, irqstatus,
-- 
2.51.0



