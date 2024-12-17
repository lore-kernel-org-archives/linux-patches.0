Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3471F709A;
	Tue, 17 Dec 2024 17:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456498; cv=none; b=PqNvKADHuBT5BAoYFNRje544NxOz6XTY8euWkogrwSWRnLfqkMPiEbpjfKULK1nOwcjRSHKAeqAi7QKFYo/qQxsD0LQ+QU+IG/td2hFPxM1VkmbHq2JSfudfqwx/2cctbqhA4At0xhYJrx3PWaJMF+2VxxznRHxOh4dH0SWqaro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456498; c=relaxed/simple;
	bh=W0LRnxDBzkUGPfOJJxIYlke2uqnS1UOlkF6POw6nnRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCsFKEM6yKOiCDHSt1RG2LmkdhQQR29uGpshC8hCOudY+DK9CwOe5rLM2GPPTOxT/NPGq7bxxRxLiaAhfnA/4BSmBNkgGG5XJpIjR2Tl/2jwpWNEj03LWFZUvgEQ6jsmc+sq7COJuGfsVklxcGh8tXYQSaKJeImuqHe1EH6DMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unnewqVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unnewqVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DEAC4CED3;
	Tue, 17 Dec 2024 17:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456498;
	bh=W0LRnxDBzkUGPfOJJxIYlke2uqnS1UOlkF6POw6nnRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unnewqVisTBRHV0CmTM+9BxKt0/UsKhmr+m+N7WWnxB1gcGj4FbqdvgTUUPy9CczD
	 DoIMLdRkfYwGAX+PnpWSMhrrSaD1gCjK5Zv3wgCD59fjbhfOMKtLf4gt/zcdxhCfbX
	 MNB7GUYupAk1btdEVodSH9oUI4kdNMloCTwTkqn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 048/172] usb: dwc3: imx8mp: fix software node kernel dump
Date: Tue, 17 Dec 2024 18:06:44 +0100
Message-ID: <20241217170548.255210083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit a4faee01179a4d9cbad9ba6be2da8637c68c1438 upstream.

When unbind and bind the device again, kernel will dump below warning:

[  173.972130] sysfs: cannot create duplicate filename '/devices/platform/soc/4c010010.usb/software_node'
[  173.981564] CPU: 2 UID: 0 PID: 536 Comm: sh Not tainted 6.12.0-rc6-06344-g2aed7c4a5c56 #144
[  173.989923] Hardware name: NXP i.MX95 15X15 board (DT)
[  173.995062] Call trace:
[  173.997509]  dump_backtrace+0x90/0xe8
[  174.001196]  show_stack+0x18/0x24
[  174.004524]  dump_stack_lvl+0x74/0x8c
[  174.008198]  dump_stack+0x18/0x24
[  174.011526]  sysfs_warn_dup+0x64/0x80
[  174.015201]  sysfs_do_create_link_sd+0xf0/0xf8
[  174.019656]  sysfs_create_link+0x20/0x40
[  174.023590]  software_node_notify+0x90/0x100
[  174.027872]  device_create_managed_software_node+0xec/0x108
...

The '4c010010.usb' device is a platform device created during the initcall
and is never removed, which causes its associated software node to persist
indefinitely.

The existing device_create_managed_software_node() does not provide a
corresponding removal function.

Replace device_create_managed_software_node() with the
device_add_software_node() and device_remove_software_node() pair to ensure
proper addition and removal of software nodes, addressing this issue.

Fixes: a9400f1979a0 ("usb: dwc3: imx8mp: add 2 software managed quirk properties for host mode")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241126032841.2458338-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-imx8mp.c b/drivers/usb/dwc3/dwc3-imx8mp.c
index 356812cbcd88..3edc5aca76f9 100644
--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -129,6 +129,16 @@ static void dwc3_imx8mp_wakeup_disable(struct dwc3_imx8mp *dwc3_imx)
 	writel(val, dwc3_imx->hsio_blk_base + USB_WAKEUP_CTRL);
 }
 
+static const struct property_entry dwc3_imx8mp_properties[] = {
+	PROPERTY_ENTRY_BOOL("xhci-missing-cas-quirk"),
+	PROPERTY_ENTRY_BOOL("xhci-skip-phy-init-quirk"),
+	{},
+};
+
+static const struct software_node dwc3_imx8mp_swnode = {
+	.properties = dwc3_imx8mp_properties,
+};
+
 static irqreturn_t dwc3_imx8mp_interrupt(int irq, void *_dwc3_imx)
 {
 	struct dwc3_imx8mp	*dwc3_imx = _dwc3_imx;
@@ -148,17 +158,6 @@ static irqreturn_t dwc3_imx8mp_interrupt(int irq, void *_dwc3_imx)
 	return IRQ_HANDLED;
 }
 
-static int dwc3_imx8mp_set_software_node(struct device *dev)
-{
-	struct property_entry props[3] = { 0 };
-	int prop_idx = 0;
-
-	props[prop_idx++] = PROPERTY_ENTRY_BOOL("xhci-missing-cas-quirk");
-	props[prop_idx++] = PROPERTY_ENTRY_BOOL("xhci-skip-phy-init-quirk");
-
-	return device_create_managed_software_node(dev, props, NULL);
-}
-
 static int dwc3_imx8mp_probe(struct platform_device *pdev)
 {
 	struct device		*dev = &pdev->dev;
@@ -221,17 +220,17 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto disable_rpm;
 
-	err = dwc3_imx8mp_set_software_node(dev);
+	err = device_add_software_node(dev, &dwc3_imx8mp_swnode);
 	if (err) {
 		err = -ENODEV;
-		dev_err(dev, "failed to create software node\n");
+		dev_err(dev, "failed to add software node\n");
 		goto disable_rpm;
 	}
 
 	err = of_platform_populate(node, NULL, NULL, dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to create dwc3 core\n");
-		goto disable_rpm;
+		goto remove_swnode;
 	}
 
 	dwc3_imx->dwc3 = of_find_device_by_node(dwc3_np);
@@ -255,6 +254,8 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 
 depopulate:
 	of_platform_depopulate(dev);
+remove_swnode:
+	device_remove_software_node(dev);
 disable_rpm:
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
@@ -268,6 +269,7 @@ static void dwc3_imx8mp_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(dev);
 	of_platform_depopulate(dev);
+	device_remove_software_node(dev);
 
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
-- 
2.47.1



