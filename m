Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C221DDE9;
	Thu, 30 Jan 2025 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246665; cv=none; b=ZPwOgccJs/vjEa+k+Ip+9jgTTNuzQy5G2QtaRKIQ8L/T5+lOjx72BWjKW+GxQLvuNd8U4ytYxWopz9+Uq9MkreSBNugvXvwcMG6051uomZRPFMXqWGcmYQSk8rFBRWnNz30rn5tl0dPpkjYCdgsr9MsbrFtmBxDMj1ttVJ/5Hzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246665; c=relaxed/simple;
	bh=nNOCzqR/mfSNdNSv07j/avyHBNwsAb6WrIs0ti+Rh4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKWtdQyHG7InliSTiq9tIfPR/kC3w5Q011e4f5iBwsN2uci/DJ4Hqo0DLZZuvvP+w39bfUAtcGfGEBNBmlGFajUxA8r7GJIoohSstsSrjSLBYFjTuI3vKjtLnxX/K51hUbKQCkhKw6d6NRn7vScqbmV+CWvDVbqfRHZboj8hYmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKEc23SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKEc23SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA92BC4CED2;
	Thu, 30 Jan 2025 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246665;
	bh=nNOCzqR/mfSNdNSv07j/avyHBNwsAb6WrIs0ti+Rh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKEc23SHupOA+RePO4c6llXpbWkLP0M0w/VrwJcQZJwI8+KGSCzuG3BTljSj3/jbD
	 g6FoO1JqozA83E38/TbSCZ5+g2BMHgWmXP5GYmJphibXDyFNvyFeqOA3iH4BVFbR2+
	 sOoTjslsKUCJfRSRXne93GAhkZ/ldVTsTpjaNSGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	stable <stable@kernel.org>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.4 26/91] USB: core: Disable LPM only for non-suspended ports
Date: Thu, 30 Jan 2025 15:00:45 +0100
Message-ID: <20250130140134.718094999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,10 +294,11 @@ static int usb_port_runtime_suspend(stru
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
 


