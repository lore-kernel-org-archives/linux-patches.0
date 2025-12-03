Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855F30F535;
	Wed,  3 Dec 2025 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775925; cv=none; b=RwPMFthCS5OXkL1m1huOb4rLWRSVZborj0gqoBCpyB/hZJPZ5LOnJGJnZdRHPqdZkzrPcElgI09mwdUc9E7hM50o3JId2NcRktChi5a2tti/Gx+bLaafP204tW+BmpF3oikylZMPDPgObTQ98ImRAEX6foZ6BENlRKV4iOcTGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775925; c=relaxed/simple;
	bh=GTdgsaUVZCbVqDXyQfwrJLhRAnmnmnQKfVPIDMBSwLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFHbRntWyclEoVWeTswOSGFWev3NatIb5cL/TEwHynbIjGb52PtF6O3cdYYJDWWPiclI/FCRP6rY+vVe1LL0rWW9rdrWzL/lESpTZho48CPEPslrWgD4bVNRAZpoIVsTidOYGRYdPIklIdSWxzUAzfDLzqWSkknTA/BCC4A7MG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NjePCE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NjePCE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B387C4CEF5;
	Wed,  3 Dec 2025 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775924;
	bh=GTdgsaUVZCbVqDXyQfwrJLhRAnmnmnQKfVPIDMBSwLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NjePCE5y2rTK3eNXcMEIo6aHNtKBPbdgJX1OjuVQ4Ili+tsyL1YxJoZIwIAv+30Y
	 ZC4YbfgxToiQbqXQNzIsykBLPocmR4wode6bmyYgKre3eRcRTvl7xlpBDEzCuzROuV
	 Sry1kYyS27Z42suOIZISPyjOByhgCUlghij9Li2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 006/300] net: usb: asix_devices: Check return value of usbnet_get_endpoints
Date: Wed,  3 Dec 2025 16:23:30 +0100
Message-ID: <20251203152400.695028732@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit dc89548c6926d68dfdda11bebc1a5258bc41d887 upstream.

The code did not check the return value of usbnet_get_endpoints.
Add checks and return the error if it fails to transfer the error.

Found via static anlaysis and this is similar to
commit 07161b2416f7 ("sr9800: Add check for usbnet_get_endpoints").

Fixes: 933a27d39e0e ("USB: asix - Add AX88178 support and many other changes")
Fixes: 2e55cc7210fe ("[PATCH] USB: usbnet (3/9) module for ASIX Ethernet adapters")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://patch.msgid.link/20251026164318.57624-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_devices.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -230,7 +230,9 @@ static int ax88172_bind(struct usbnet *d
 	int i;
 	unsigned long gpio_bits = dev->driver_info->data;
 
-	usbnet_get_endpoints(dev,intf);
+	ret = usbnet_get_endpoints(dev, intf);
+	if (ret)
+		goto out;
 
 	/* Toggle the GPIOs in a manufacturer/model specific way */
 	for (i = 2; i >= 0; i--) {
@@ -681,7 +683,9 @@ static int ax88772_bind(struct usbnet *d
 	u32 phyid;
 	struct asix_common_private *priv;
 
-	usbnet_get_endpoints(dev, intf);
+	ret = usbnet_get_endpoints(dev, intf);
+	if (ret)
+		return ret;
 
 	/* Maybe the boot loader passed the MAC address via device tree */
 	if (!eth_platform_get_mac_address(&dev->udev->dev, buf)) {
@@ -1063,7 +1067,9 @@ static int ax88178_bind(struct usbnet *d
 	int ret;
 	u8 buf[ETH_ALEN] = {0};
 
-	usbnet_get_endpoints(dev,intf);
+	ret = usbnet_get_endpoints(dev, intf);
+	if (ret)
+		return ret;
 
 	/* Get the MAC address */
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf, 0);


