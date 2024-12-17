Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752A6149DFA;
	Tue, 17 Dec 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455587; cv=none; b=gCpmuieVj/ay5IHxDcRBQj85THeHA+k8PInb4v7ClzSLHH5h3cZkb55Iqhgt+TkxUCzVi1pponcx99Vkfx2BZle/uh4DfNoemB87x8Vrk9di6HQjT8COCp7MXLxsKbvqNZ5hC6oFqKvjT4yip3R0rZ3hZ22OwERWKrgT8Vq/Zts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455587; c=relaxed/simple;
	bh=/4WKjmMHedUFnGFQ+OGBIgbbZVhICzvW9GSgjlcrkEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rcvnejii/bkp2wQSPqzBBrA6Ha3F2321wYbC2M7w1AqbYexKHmKrR+scqthO94v1ilwIi4LVBMZKOmzibKu11od9lbhEHwGpzoQCRpWYIEMuArolCScWqRzUtzeW34gP4z2yUV/1AQ+6bHNr0YoqCX/OgDkoP4rGgig1tpLKeYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcb3HaH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcb3HaH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA80C4CED3;
	Tue, 17 Dec 2024 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455587;
	bh=/4WKjmMHedUFnGFQ+OGBIgbbZVhICzvW9GSgjlcrkEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcb3HaH7ARMMD6N+vKLhuLxKkYyJEgIXiprVICK5HDZlnIQ3fCaDFgz6YdDw2rf8a
	 ThGFhf3Dd//12sD0vZ81tE9JbHH4HeyAWwLYHS0NjoqrPEdbZ/85v6DnvRVm1FTyKt
	 CMlfTT2cyCiXPTWAqWB8nm1Xq6mYDIOB6PNJX+RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 5.15 06/51] usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature
Date: Tue, 17 Dec 2024 18:06:59 +0100
Message-ID: <20241217170520.568090915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3579,11 +3579,9 @@ static int dwc2_hcd_hub_control(struct d
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
@@ -3653,13 +3651,11 @@ static int dwc2_hcd_hub_control(struct d
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


