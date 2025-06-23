Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A7619CC11;
	Mon, 23 Jun 2025 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714597; cv=none; b=B2tbCWySITYkAf/InIdz401Zbdn4tfIHFxCAY6GTS3J4rDNGmYVVdF0jsiKNrsvMiW1Zzigw5xnQjqB2FTBUJAE4xtHfpNhWxyFQ/LShVzhAy6GfGyGsXclt61aeKM9leoR9j4REDe5bzfg0BawsyHLMz+WJTwI0Ff0iC2iqEpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714597; c=relaxed/simple;
	bh=LBPjlFv0taToNEzAcJLhjVMyVfhBr+jHAoIyEaYTx3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5b9D2EtwO+s8xyNtWNqMnWOOc//DQMZd6xGUtPSS4hHhfMIY7agE1AaSfewwEga65WF6Ua9pwDe2dCZzcqkC10Uy98R8jvLojTIaydUdowfXwXwczByT8d8DqJbXLQYEhqzrQIvGkv2cifoe6SaZW/OEyYwPvfWb8imXE5/lLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gqM6Hcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gqM6Hcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B45FC4CEEA;
	Mon, 23 Jun 2025 21:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714595;
	bh=LBPjlFv0taToNEzAcJLhjVMyVfhBr+jHAoIyEaYTx3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gqM6HcnzS76p5HFwKkkeMY3S+THmfuylW5EfNhDvmq5lFT/qmCHN10wj6hjIBGRN
	 slSuTTJmuyhSWX+Rf0N+CFYFAbTO62koNCYMW+vhsVHY4B9LqCdEH4iiAt563Iewma
	 eMLWoXrE/26yZ+T7PYr4C6ygU1Au5GET/wf0PXXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Clayton Craft <clayton@craftyguy.net>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.12 118/414] soc: qcom: pmic_glink_altmode: fix spurious DP hotplug events
Date: Mon, 23 Jun 2025 15:04:15 +0200
Message-ID: <20250623130645.026316002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 5090ac9191a19c61beeade60d3d839e509fab640 upstream.

The PMIC GLINK driver is currently generating DisplayPort hotplug
notifications whenever something is connected to (or disconnected from)
a port regardless of the type of notification sent by the firmware.

These notifications are forwarded to user space by the DRM subsystem as
connector "change" uevents:

    KERNEL[1556.223776] change   /devices/platform/soc@0/ae00000.display-subsystem/ae01000.display-controller/drm/card0 (drm)
    ACTION=change
    DEVPATH=/devices/platform/soc@0/ae00000.display-subsystem/ae01000.display-controller/drm/card0
    SUBSYSTEM=drm
    HOTPLUG=1
    CONNECTOR=36
    DEVNAME=/dev/dri/card0
    DEVTYPE=drm_minor
    SEQNUM=4176
    MAJOR=226
    MINOR=0

On the Lenovo ThinkPad X13s and T14s, the PMIC GLINK firmware sends two
identical notifications with orientation information when connecting a
charger, each generating a bogus DRM hotplug event. On the X13s, two
such notification are also sent every 90 seconds while a charger remains
connected, which again are forwarded to user space:

    port = 1, svid = ff00, mode = 255, hpd_state = 0
    payload = 01 00 00 00 00 00 00 ff 00 00 00 00 00 00 00 00

Note that the firmware only sends on of these when connecting an
ethernet adapter.

Fix the spurious hotplug events by only forwarding hotplug notifications
for the Type-C DisplayPort service id. This also reduces the number of
uevents from four to two when an actual DisplayPort altmode device is
connected:

    port = 0, svid = ff01, mode = 2, hpd_state = 0
    payload = 00 01 02 00 f2 0c 01 ff 03 00 00 00 00 00 00 00
    port = 0, svid = ff01, mode = 2, hpd_state = 1
    payload = 00 01 02 00 f2 0c 01 ff 43 00 00 00 00 00 00 00

Fixes: 080b4e24852b ("soc: qcom: pmic_glink: Introduce altmode support")
Cc: stable@vger.kernel.org	# 6.3
Cc: Bjorn Andersson <andersson@kernel.org>
Reported-by: Clayton Craft <clayton@craftyguy.net>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Clayton Craft <clayton@craftyguy.net>
Link: https://lore.kernel.org/r/20250324132448.6134-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -219,21 +219,29 @@ static void pmic_glink_altmode_worker(st
 {
 	struct pmic_glink_altmode_port *alt_port = work_to_altmode_port(work);
 	struct pmic_glink_altmode *altmode = alt_port->altmode;
+	enum drm_connector_status conn_status;
 
 	typec_switch_set(alt_port->typec_switch, alt_port->orientation);
 
-	if (alt_port->svid == USB_TYPEC_DP_SID && alt_port->mode == 0xff)
-		pmic_glink_altmode_safe(altmode, alt_port);
-	else if (alt_port->svid == USB_TYPEC_DP_SID)
-		pmic_glink_altmode_enable_dp(altmode, alt_port, alt_port->mode,
-					     alt_port->hpd_state, alt_port->hpd_irq);
-	else
-		pmic_glink_altmode_enable_usb(altmode, alt_port);
+	if (alt_port->svid == USB_TYPEC_DP_SID) {
+		if (alt_port->mode == 0xff) {
+			pmic_glink_altmode_safe(altmode, alt_port);
+		} else {
+			pmic_glink_altmode_enable_dp(altmode, alt_port,
+						     alt_port->mode,
+						     alt_port->hpd_state,
+						     alt_port->hpd_irq);
+		}
+
+		if (alt_port->hpd_state)
+			conn_status = connector_status_connected;
+		else
+			conn_status = connector_status_disconnected;
 
-	drm_aux_hpd_bridge_notify(&alt_port->bridge->dev,
-				  alt_port->hpd_state ?
-				  connector_status_connected :
-				  connector_status_disconnected);
+		drm_aux_hpd_bridge_notify(&alt_port->bridge->dev, conn_status);
+	} else {
+		pmic_glink_altmode_enable_usb(altmode, alt_port);
+	}
 
 	pmic_glink_altmode_request(altmode, ALTMODE_PAN_ACK, alt_port->index);
 }


