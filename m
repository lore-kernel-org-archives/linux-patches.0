Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCB1C0DE7;
	Mon,  1 Apr 2024 16:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989180; cv=none; b=PH5kSt8spEjJz18ERyvTL6kf1Z9k/IKqVt1LwxBAduSJm1kfrcq37csJpY/htBb9enEY7pa58+Vl7koJZyGCurqp4cKSMq2DOj9r2XIg0leBYZ9qNzDlij4VLCl0MLOZcCDYGVdftnklYO7tF/OGAbKsxnS5un1A+yN2e3PMzuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989180; c=relaxed/simple;
	bh=RRJqGzVkPOcUdQkLdQJNpP84vk2qlEYoqJ3y0a/I+70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxvXP2sg227v4ngWd6oP8rFo4G+JjLLPCC+8jZd05h/iruQ0bkeHJOOwYIv2fV6FC2Ojmiij/ZTGukMrgtp7d8ZyO81dUaWg2IYivtESWeFbUBlbW0xNBXLqDY4pLyfhHpEzUHQUqGlQuWmTNj5oQERHBuTcDDdLslfbHDIagPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkIRUqHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkIRUqHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456EBC433F1;
	Mon,  1 Apr 2024 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989180;
	bh=RRJqGzVkPOcUdQkLdQJNpP84vk2qlEYoqJ3y0a/I+70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkIRUqHp6Ft03Q9vIZi5hQRWtQSP3fnU/R3ENOIW3l7Befgq3l3FWZsIg2iQwIzkM
	 O4RDiz2Z/r2+txddrcgaihVjLzhRafroGsOlWTi+/cvgyS8Stx+o7cuUyI8f2anjCq
	 xT4FR2AId74xHoS/MDeDCMTAqTp1DTyHJiFZ14qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.7 405/432] usb: typec: ucsi: Fix race between typec_switch and role_switch
Date: Mon,  1 Apr 2024 17:46:32 +0200
Message-ID: <20240401152605.466637391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit f5e9bda03aa50ffad36eccafe893d004ef213c43 upstream.

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
---
 drivers/usb/typec/ucsi/ucsi_glink.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -254,6 +254,20 @@ static void pmic_glink_ucsi_notify(struc
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


