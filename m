Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D5378286;
	Mon,  8 Apr 2024 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582883; cv=none; b=XR+PpUQCKaK9KZMqb9BinZLe6bEHUVx1ifgICVRxk8YcAViAj14fizxMrI0bAhKJd3EE+phkdlorc2XOo/yiPY363rm58fiXQ69T1jANe5Rt4Ids5r9+KrGxvgwQqdX2duHpALysURaTSgphMOpx/pzBrrIcA4TANd+hpdAs59k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582883; c=relaxed/simple;
	bh=uib07FTFtO71UsC6FYPQEGPfJQAJjRo2MnnsL60mbFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIlBgN0cry8eyporeYqaBlJq3EjtJb5eEDhmOfEi39Lu8Gs4PcI/o9N6Kt4eQg8i11HbPukiNWcEYNFrLIu3BqAILtZx8jldXpDcCYOZFrzer1ySPT+S1I2KHDBUxcL7VfalK4kRwzpVreuTmQAYX2nr8eRS63UmPfGhhVN6SOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVs56V/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVs56V/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1049BC43390;
	Mon,  8 Apr 2024 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582883;
	bh=uib07FTFtO71UsC6FYPQEGPfJQAJjRo2MnnsL60mbFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVs56V/d+h6v0qW87VQwZPXe+35ha/BVYY/pdFyKclby9EKWAyIfn3LkDgMU0i39r
	 mOmp1bOlnkMtTm0RCkxfnGND9MsIQ/Y+VyOWYL/snkY4LeBlIuQh76Ku6diSRgHNXL
	 5w7McNXEjfiaDgbA7mjmq1I4jl9CZo+w8RrjZ5BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/252] usb: typec: ucsi: Fix race between typec_switch and role_switch
Date: Mon,  8 Apr 2024 14:57:11 +0200
Message-ID: <20240408125310.736492112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit f5e9bda03aa50ffad36eccafe893d004ef213c43 ]

When orientation switch is enabled in ucsi glink, there is a xhci
probe failure seen when booting up in host mode in reverse
orientation.

During bootup the following things happen in multiple drivers:

a) DWC3 controller driver initializes the core in device mode when the
dr_mode is set to DRD. It relies on role_switch call to change role to
host.

b) QMP driver initializes the lanes to TYPEC_ORIENTATION_NORMAL as a
normal routine. It relies on the typec_switch_set call to get notified
of orientation changes.

c) UCSI core reads the UCSI_GET_CONNECTOR_STATUS via the glink and
provides initial role switch to dwc3 controller.

When booting up in host mode with orientation TYPEC_ORIENTATION_REVERSE,
then we see the following things happening in order:

a) UCSI gives initial role as host to dwc3 controller ucsi_register_port.
Upon receiving this notification, the dwc3 core needs to program GCTL from
PRTCAP_DEVICE to PRTCAP_HOST and as part of this change, it asserts GCTL
Core soft reset and waits for it to be  completed before shifting it to
host. Only after the reset is done will the dwc3_host_init be invoked and
xhci is probed. DWC3 controller expects that the usb phy's are stable
during this process i.e., the phy init is already done.

b) During the 100ms wait for GCTL core soft reset, the actual notification
from PPM is received by ucsi_glink via pmic glink for changing role to
host. The pmic_glink_ucsi_notify routine first sends the orientation
change to QMP and then sends role to dwc3 via ucsi framework. This is
happening exactly at the time GCTL core soft reset is being processed.

c) When QMP driver receives typec switch to TYPEC_ORIENTATION_REVERSE, it
then re-programs the phy at the instant GCTL core soft reset has been
asserted by dwc3 controller due to which the QMP PLL lock fails in
qmp_combo_usb_power_on.

d) After the 100ms of GCTL core soft reset is completed, the dwc3 core
goes for initializing the host mode and invokes xhci probe. But at this
point the QMP is non-responsive and as a result, the xhci plat probe fails
during xhci_reset.

Fix this by passing orientation switch to available ucsi instances if
their gpio configuration is available before ucsi_register is invoked so
that by the time, the pmic_glink_ucsi_notify provides typec_switch to QMP,
the lane is already configured and the call would be a NOP thus not racing
with role switch.

Cc: stable@vger.kernel.org
Fixes: c6165ed2f425 ("usb: ucsi: glink: use the connector orientation GPIO to provide switch events")
Suggested-by: Wesley Cheng <quic_wcheng@quicinc.com>
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240301040914.458492-1-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_glink.c b/drivers/usb/typec/ucsi/ucsi_glink.c
index 4853141cd10c8..894622b6556a6 100644
--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -254,6 +254,20 @@ static void pmic_glink_ucsi_notify(struct work_struct *work)
 static void pmic_glink_ucsi_register(struct work_struct *work)
 {
 	struct pmic_glink_ucsi *ucsi = container_of(work, struct pmic_glink_ucsi, register_work);
+	int orientation;
+	int i;
+
+	for (i = 0; i < PMIC_GLINK_MAX_PORTS; i++) {
+		if (!ucsi->port_orientation[i])
+			continue;
+		orientation = gpiod_get_value(ucsi->port_orientation[i]);
+
+		if (orientation >= 0) {
+			typec_switch_set(ucsi->port_switch[i],
+					 orientation ? TYPEC_ORIENTATION_REVERSE
+					     : TYPEC_ORIENTATION_NORMAL);
+		}
+	}
 
 	ucsi_register(ucsi->ucsi);
 }
-- 
2.43.0



