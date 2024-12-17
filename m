Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8001B1F76D5;
	Tue, 17 Dec 2024 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455958; cv=none; b=sUIzRX+ln6CwgvPeq8NxG+sAxHskH5KAaNfboVVKcCj+sN9MvH7G0ML4VooNz5CoWmHJLEx3MoprQB/Wij4jRvhECNDxN8sZrS/DpOfz+N63hqEw3uozYX++0LcW/IE1LuFqxOR3GktzcyDZPj0HVT28++Z433ykeqfzPoPWJL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455958; c=relaxed/simple;
	bh=pIz8Uf5MH5XEDHpgsg3YJBXGeQe8niaKHAnIZiu8zh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfNym3vtPVC/wRdrYDnyMNknfwGVMgZ56CDS5pJrMiZTsbe3K2F7tOD73/DL9Uirr/8yVGcAGUuYgO1IYjBw18t80nhRRcgsK/sWFS9uCceicpVpYkSkBgdv9hrmDK3wFn4qYHKybSfpzj8JhEEWn6byhvsMwMrSYCZzXMHbFlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0gRkruC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0gRkruC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CFDC4CED3;
	Tue, 17 Dec 2024 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455958;
	bh=pIz8Uf5MH5XEDHpgsg3YJBXGeQe8niaKHAnIZiu8zh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0gRkruCQn7FryQmtV6Zhpd0qTgh2TNuy6VpyZT5e3t6t7J6TP/Ex7orrM/muS2VF
	 nJ88VrlLlXetUrTo/Uv86oevoeg6ebYDzoyjein/gGTeFuTMu5uLk7D7z1uuzxjDjC
	 +bqihv3QId4RdcoKF4eM+33AtfYTQJrtFvAVF8S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.6 013/109] usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature
Date: Tue, 17 Dec 2024 18:06:57 +0100
Message-ID: <20241217170533.911246339@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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


