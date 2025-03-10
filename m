Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C071156861;
	Mon, 10 Mar 2025 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630939; cv=none; b=qNPW0/2rOWnMhODIxj7H5+9jBkuq08l1XOu0v3NGbnvb+GtTPouJKubOYZTK8glTdYBLkHpfemP221S10Aj65zQNdDOhmPg+T9LxYCb568kBsB6maF2vIemdOyzqwvLuIWaAdGKmNcFHktY11vkeT651GY5xKeNY8RFb0vb+kcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630939; c=relaxed/simple;
	bh=7+U6i/4lAiPxk2mQIjcaZreQhOmlC1oEi2l/PtjO01c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNOsYu0uVkUqn519d/edkG/qVqpLEj+yqvJdtiTs/Symr8fKh6W9EWZLlqlbYw4NVcYyJ7xNPHMEXgP8v+jzuL+Fgwz2RQmf3RPMKZn780/gSYi4a1P1J863RkgPKDRzUrzDdEFXyvikDBxJzGrhdMv1Xgf1aux8hl0oYIGY3zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWgiwby2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWgiwby2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C608C4CEE5;
	Mon, 10 Mar 2025 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630938;
	bh=7+U6i/4lAiPxk2mQIjcaZreQhOmlC1oEi2l/PtjO01c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWgiwby2FFYUzfCz4tos+jUX5Zzi2TMQLukBB6z1kS02hMAHi30QayxXjIWe4nCan
	 chy4EIaCKNQKuoR4H+CokOJq3xrzoGWtotlsFp38u4xUMyNKNWMtp6w8axiypxMRuq
	 Ugkq+acbOIbGHsNMR2uvuWPzHL//GIaUwr+Y7pIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.15 585/620] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Mon, 10 Mar 2025 18:07:11 +0100
Message-ID: <20250310170608.624479339@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 552ca6b87e3778f3dd5b87842f95138162e16c82 upstream.

When performing continuous unbind/bind operations on the USB drivers
available on the Renesas RZ/G2L SoC, a kernel crash with the message
"Unable to handle kernel NULL pointer dereference at virtual address"
may occur. This issue points to the usbhsc_notify_hotplug() function.

Flush the delayed work to avoid its execution when driver resources are
unavailable.

Fixes: bc57381e6347 ("usb: renesas_usbhs: use delayed_work instead of work_struct")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-4-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -774,6 +774,8 @@ static int usbhs_remove(struct platform_
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


