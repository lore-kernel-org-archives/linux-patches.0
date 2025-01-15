Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E931248BA0;
	Wed, 15 Jan 2025 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937730; cv=none; b=YNYFDXANOiRK2lpATO4p/4BHfS7O6v8sbTvO9C0oxY85xYzGuHq9tM5nbE1WqEtbCyjerJHq/ZuDbgHEmJa6PslfJ6M7L4W11Vw7U40u9zIlATycxbe9aBNV0NSvhcck1eUvXA7hkO4ulMFx4YtcINAZ72+0iCt43gKQ62gDtMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937730; c=relaxed/simple;
	bh=BH5SAzKi//Ev75ejqv1uUV8/iWnteixLZ7JNBdXWpBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eogGLoI4IfKQouLfeynRLoRcXEAmrBC2GppSgcdC5qKiql+yNRE3mMLKEaXqGc8zNzP3iuYFux+FHG3SJ5q8xI3VMWCekoSwhZgrLvxtWJUAY82bZAMhLUoMN6XfUZT3suMTWz93Vs0FjzFmJHH4EAQA/iAxdboKYlJqkbdHAMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG1wBLn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG1wBLn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD1DC4CEE2;
	Wed, 15 Jan 2025 10:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937730;
	bh=BH5SAzKi//Ev75ejqv1uUV8/iWnteixLZ7JNBdXWpBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG1wBLn34YMvyHJ71Z+nt6nqu4VLYXKBBIxR5qs5ITpbZjJNe3DKEmD6bdOQvJD+l
	 hgPXab3x8F9U34KeddG8tA6k6i9QVlOT2KZeZyUGFJI4J9+rTjSzYz3Q9B1/S9WApb
	 7G7yTfs/LQbwvOiSbNkZnmWJ/fcMTsXkhyRKyYF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	stable <stable@kernel.org>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.1 65/92] USB: core: Disable LPM only for non-suspended ports
Date: Wed, 15 Jan 2025 11:37:23 +0100
Message-ID: <20250115103550.149451431@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

From: Kai-Heng Feng <kaihengf@nvidia.com>

commit 59bfeaf5454b7e764288d84802577f4a99bf0819 upstream.

There's USB error when tegra board is shutting down:
[  180.919315] usb 2-3: Failed to set U1 timeout to 0x0,error code -113
[  180.919995] usb 2-3: Failed to set U1 timeout to 0xa,error code -113
[  180.920512] usb 2-3: Failed to set U2 timeout to 0x4,error code -113
[  186.157172] tegra-xusb 3610000.usb: xHCI host controller not responding, assume dead
[  186.157858] tegra-xusb 3610000.usb: HC died; cleaning up
[  186.317280] tegra-xusb 3610000.usb: Timeout while waiting for evaluate context command

The issue is caused by disabling LPM on already suspended ports.

For USB2 LPM, the LPM is already disabled during port suspend. For USB3
LPM, port won't transit to U1/U2 when it's already suspended in U3,
hence disabling LPM is only needed for ports that are not suspended.

Cc: Wayne Chang <waynec@nvidia.com>
Cc: stable <stable@kernel.org>
Fixes: d920a2ed8620 ("usb: Disable USB3 LPM at shutdown")
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241206074817.89189-1-kaihengf@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -412,10 +412,11 @@ static int usb_port_runtime_suspend(stru
 static void usb_port_shutdown(struct device *dev)
 {
 	struct usb_port *port_dev = to_usb_port(dev);
+	struct usb_device *udev = port_dev->child;
 
-	if (port_dev->child) {
-		usb_disable_usb2_hardware_lpm(port_dev->child);
-		usb_unlocked_disable_lpm(port_dev->child);
+	if (udev && !udev->port_is_suspended) {
+		usb_disable_usb2_hardware_lpm(udev);
+		usb_unlocked_disable_lpm(udev);
 	}
 }
 


