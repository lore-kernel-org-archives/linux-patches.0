Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC41F4735;
	Tue, 17 Dec 2024 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455501; cv=none; b=SrZNvxuZxaPsKJJBRKsS2rMe+chKN0mpmsIboWEzBIkqDg66UJ+hTljobnftil0NkimqsloCflfK50pS2IB30YIb+i8Nj7ZvKkcrrNIxHqUQba42GIXKaPnuQIAO9fDaHdyPgpdIHcrRgssIqg3hDixxrzKQku11pLvjq3v2tO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455501; c=relaxed/simple;
	bh=LpWd2WuODAAHxE27T32cOk4Eg+cu2dk2rEagRPT7o8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNRdHLGnHT7VtGRbaDelBSn4qxWdzQsltjYNPzxyd69yN/b7IRR1gHcF0ILEjSz6IrgpvRmS+tUdtNZNKHdoyZ48l2u8elHPGobRwMtlWLg9s/tJNyNheqwoMxrKMKbudJrZ92YOLCIg+P2KX4+gXybSM8k7yJZg7o+zdEPjRZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi7gNN8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi7gNN8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9BEC4CED3;
	Tue, 17 Dec 2024 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455500;
	bh=LpWd2WuODAAHxE27T32cOk4Eg+cu2dk2rEagRPT7o8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xi7gNN8M8pHUKsGQYLdL01FZVw4z1jJgL8ywueBoGnGW/uuHvZ5y3VJ11cLZ/sQiQ
	 HFaV3Cz/KOYJoeDvfvN58CXReKNcZqTa5v9r+v0A3aTsUpoEylgH6VrRoZnQAclJl7
	 FbOHwBPikIsEqbRz+RU4odA8IGdgt0ANM1wBQ/j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 5.10 04/43] usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature
Date: Tue, 17 Dec 2024 18:06:55 +0100
Message-ID: <20241217170520.640302597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3544,11 +3544,9 @@ static int dwc2_hcd_hub_control(struct d
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
@@ -3618,13 +3616,11 @@ static int dwc2_hcd_hub_control(struct d
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


