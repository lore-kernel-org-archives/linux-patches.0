Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9B42236EB;
	Tue, 30 Sep 2025 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245201; cv=none; b=rOuPZr1aP2cfxQ5mY6fVTVy5bXm54hN3EaAfbYXtLSuTr14allOLQrMN4efpwYp6Hf0vaIPR+x6N2Z2j/jcJuWSFgnI7DN/fs2+a4Op0zITSxUsyGOREQTD3hHDWEaY8+A3PNMxeqn7tHljH6v1cgUSGgxKnoMsXCjem7QWNAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245201; c=relaxed/simple;
	bh=rx0gA6S10WVMKrYWq7gn4pxy5d2xrnIxcmG6FIkj0gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODESc23Ni6oJYIQcSDcFP+4NdH9k0TPGaFYKPEBo88GNBXywR0v3rAMliLIPH64zyM7mBD9QeAA6KJESXZltoTRHHSAhl9Y0UxXZ9QNh4VJ6fP0Zl2b+PgBCx3Dx8rD21H4JDCWMb5rT9aaFMGnUojrEwFCrF65cO/+AJFzD61w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjBv7yWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjBv7yWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D15C4CEF0;
	Tue, 30 Sep 2025 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245201;
	bh=rx0gA6S10WVMKrYWq7gn4pxy5d2xrnIxcmG6FIkj0gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjBv7yWfRGcF+NACjghzGSzX47+kefiXE3dLi7ypdwYo81zhR1F5/wnRLtyNQnQXU
	 1yO+VSWtSRBFeaVuqa5COGF1HBzJwZ0fLZQlhlMemys+zgFS/53q/+SKOVPJmsTZT8
	 wRDOMTRajee6uzm65NKanTyU+V5GP5oma09doz8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/151] phy: ti: omap-usb2: fix device leak at unbind
Date: Tue, 30 Sep 2025 16:47:07 +0200
Message-ID: <20250930143831.460107287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 64961557efa1b98f375c0579779e7eeda1a02c42 ]

Make sure to drop the reference to the control device taken by
of_find_device_by_node() during probe when the driver is unbound.

Fixes: 478b6c7436c2 ("usb: phy: omap-usb2: Don't use omap_get_control_dev()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724131206.2211-3-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-omap-usb2.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/phy/ti/phy-omap-usb2.c
+++ b/drivers/phy/ti/phy-omap-usb2.c
@@ -363,6 +363,13 @@ static void omap_usb2_init_errata(struct
 		phy->flags |= OMAP_USB2_DISABLE_CHRG_DET;
 }
 
+static void omap_usb2_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb	*phy;
@@ -373,6 +380,7 @@ static int omap_usb2_probe(struct platfo
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
 	const struct usb_phy_data *phy_data;
+	int ret;
 
 	phy_data = device_get_match_data(&pdev->dev);
 	if (!phy_data)
@@ -423,6 +431,11 @@ static int omap_usb2_probe(struct platfo
 			return -EINVAL;
 		}
 		phy->control_dev = &control_pdev->dev;
+
+		ret = devm_add_action_or_reset(&pdev->dev, omap_usb2_put_device,
+					       phy->control_dev);
+		if (ret)
+			return ret;
 	} else {
 		if (of_property_read_u32_index(node,
 					       "syscon-phy-power", 1,


