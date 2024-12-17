Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E8D1F868C;
	Tue, 17 Dec 2024 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455755; cv=none; b=r3W02bsPPu7Sr8X4KE31MSST82RJ6CSb8MmFw2Gj9xb+AkZ0S2LtOGJ8w6x72WW13AH6zC/k/6KHivTZloeJa0d84C311JzXrVibXT2HGn+mvofbPbb5rq5fXpzEpuSlOb2HXTq+qySEzeIPVTYMEt7HiuDfPGz36jUnDudLGKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455755; c=relaxed/simple;
	bh=2rBn/hlLt5HpqDm5wvqZYUVsw7ydmJPywX+aW0HZpsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKZHT75EQXT5ZJieB8enIy5XvEjYlcgoRv9RuBROG1podf8dUCp36aWTLgAeVO1IkfGCK84U2iq8WpV169tg3nJX8BtcZ5OiG3BHg6m64c8V/SXT3RrCoBz0saVJ+7aIYPqe4WCUi/BH/sWHtBQezdflTMxVPQgqmudBBG1a9A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXwWSwS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXwWSwS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B76EC4CED3;
	Tue, 17 Dec 2024 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455754;
	bh=2rBn/hlLt5HpqDm5wvqZYUVsw7ydmJPywX+aW0HZpsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXwWSwS0//GWLvx1QuGMmdul+TJaXknTtAEXKtqClpU2/GLZX+MRuD+HNQ2xliQCC
	 nI61esbZL8Fc0L4079wre6GnCUJeeWTYh+aCnMCl6nk3byC4MxygRXo5/Mc0753+cD
	 LKV+8AUmAEQas5WSgs52TbUW4aya77nEfxYx4tEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.1 09/76] usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature
Date: Tue, 17 Dec 2024 18:06:49 +0100
Message-ID: <20241217170526.635347863@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit a8d3e4a734599c7d0f6735f8db8a812e503395dd upstream.

On Rasperry Pis without onboard USB hub the power cycle during
power connect init only disable the port but never enabled it again:

  usb usb1-port1: attempt power cycle

The port relevant part in dwc2_hcd_hub_control() is skipped in case
port_connect_status = 0 under the assumption the core is or will be soon
in device mode. But this assumption is wrong, because after ClearPortFeature
USB_PORT_FEAT_POWER the port_connect_status will also be 0 and
SetPortFeature (incl. USB_PORT_FEAT_POWER) will be a no-op.

Fix the behavior of dwc2_hcd_hub_control() by replacing the
port_connect_status check with dwc2_is_device_mode().

Link: https://github.com/raspberrypi/linux/issues/6247
Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20241202001631.75473-3-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -3546,11 +3546,9 @@ static int dwc2_hcd_hub_control(struct d
 			port_status |= USB_PORT_STAT_C_OVERCURRENT << 16;
 		}
 
-		if (!hsotg->flags.b.port_connect_status) {
+		if (dwc2_is_device_mode(hsotg)) {
 			/*
-			 * The port is disconnected, which means the core is
-			 * either in device mode or it soon will be. Just
-			 * return 0's for the remainder of the port status
+			 * Just return 0's for the remainder of the port status
 			 * since the port register can't be read if the core
 			 * is in device mode.
 			 */
@@ -3620,13 +3618,11 @@ static int dwc2_hcd_hub_control(struct d
 		if (wvalue != USB_PORT_FEAT_TEST && (!windex || windex > 1))
 			goto error;
 
-		if (!hsotg->flags.b.port_connect_status) {
+		if (dwc2_is_device_mode(hsotg)) {
 			/*
-			 * The port is disconnected, which means the core is
-			 * either in device mode or it soon will be. Just
-			 * return without doing anything since the port
-			 * register can't be written if the core is in device
-			 * mode.
+			 * Just return 0's for the remainder of the port status
+			 * since the port register can't be read if the core
+			 * is in device mode.
 			 */
 			break;
 		}


