Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0CC22A804;
	Mon,  2 Jun 2025 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875231; cv=none; b=F8ZpAs6RitE627EwNt9kXTs6Fa8NoOahNlGOxowL4wDykwPdNTqAZyG4Ym19M0vo+CyZf9+6bBcFAHqjs1uJfUbuut+9ek4ih24xy+6+M7GVnvKbH/3ATbrt02b9nrqWKcCgpIENb7ekZMve7ZbAwP19X8oDJ//f2lBJu+KFROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875231; c=relaxed/simple;
	bh=+NuOw8SVgUHpX9MjD25Y6pIOEWl3C29u6BP6ggaykl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbhK73ZoKHmnmSkA5sUpKk9Yn33hOZvhqKy6Bl/5sNWIwpsFY3KMhSftpWmz7pLEYqnVwDlK8N/2/YZkyz9duomiJErM3ZCA8RN6YNNDdZBJqUUq2Q765eqyVjXnADCdCDNCUPyqZNVBJteCbff6BBRjkGSZwN1hTwMjNfGVD6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP22lPXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP22lPXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FBFC4CEEB;
	Mon,  2 Jun 2025 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875231;
	bh=+NuOw8SVgUHpX9MjD25Y6pIOEWl3C29u6BP6ggaykl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP22lPXEjBF4GR7MYYFolUivyvtV73Qgd5W9Y9/TwqnMw0Hp/D1xGTmVcU4YcOet2
	 5yeoh0U3y9cjML4ACefAf00thkdSImMeUvgvz1bYmud71GAv3/cOzcLEklJDJYCQiT
	 X0XP+O+skCVLUZjgVSrinsvCBmwMU3L4DiLKkv7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Lin <jilin@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.10 070/270] usb: host: tegra: Prevent host controller crash when OTG port is used
Date: Mon,  2 Jun 2025 15:45:55 +0200
Message-ID: <20250602134310.047967174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Lin <jilin@nvidia.com>

commit 732f35cf8bdfece582f6e4a9c659119036577308 upstream.

When a USB device is connected to the OTG port, the tegra_xhci_id_work()
routine transitions the PHY to host mode and calls xhci_hub_control()
with the SetPortFeature command to enable port power.

In certain cases, the XHCI controller may be in a low-power state
when this operation occurs. If xhci_hub_control() is invoked while
the controller is suspended, the PORTSC register may return 0xFFFFFFFF,
indicating a read failure. This causes xhci_hc_died() to be triggered,
leading to host controller shutdown.

Example backtrace:
[  105.445736] Workqueue: events tegra_xhci_id_work
[  105.445747]  dump_backtrace+0x0/0x1e8
[  105.445759]  xhci_hc_died.part.48+0x40/0x270
[  105.445769]  tegra_xhci_set_port_power+0xc0/0x240
[  105.445774]  tegra_xhci_id_work+0x130/0x240

To prevent this, ensure the controller is fully resumed before
interacting with hardware registers by calling pm_runtime_get_sync()
prior to the host mode transition and xhci_hub_control().

Fixes: f836e7843036 ("usb: xhci-tegra: Add OTG support")
Cc: stable <stable@kernel.org>
Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20250422114001.126367-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1178,6 +1178,7 @@ static void tegra_xhci_id_work(struct wo
 	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(tegra->padctl,
 								    tegra->otg_usb2_port);
 
+	pm_runtime_get_sync(tegra->dev);
 	if (tegra->host_mode) {
 		/* switch to host mode */
 		if (tegra->otg_usb3_port >= 0) {
@@ -1207,6 +1208,7 @@ static void tegra_xhci_id_work(struct wo
 		}
 
 		tegra_xhci_set_port_power(tegra, true, true);
+		pm_runtime_mark_last_busy(tegra->dev);
 
 	} else {
 		if (tegra->otg_usb3_port >= 0)
@@ -1214,6 +1216,7 @@ static void tegra_xhci_id_work(struct wo
 
 		tegra_xhci_set_port_power(tegra, true, false);
 	}
+	pm_runtime_put_autosuspend(tegra->dev);
 }
 
 static int tegra_xusb_get_usb2_port(struct tegra_xusb *tegra,


