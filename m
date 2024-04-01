Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7773613C;
	Mon,  1 Apr 2024 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989145; cv=none; b=U5YK7ZbkZwzEwOVu4VfUfT9FR5n0PoWsuVTnd2L1MdYH61AcWL7DUpuWE/H0DQtzE2TGrwLw7wk4VZdbvFXNpW+AwjSnDPj35ayYyT2Ot1E1udO94mO1kqXSZsdl7nLqdMW+aNKN5IcYVhEO9pV/nI/HDo04FO8swulFTSE3fuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989145; c=relaxed/simple;
	bh=qfZthv6AgG/7/vlsHd//b8iISVXoHfeHpse9B3F8dqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvQ02AxdTYpKjhkiFenDvM6ACvRJ4jw+vKcxmK8V1WEgxXT2dNw9sq+qX5O7PaM/mXMqBNhKdSayUxJaWw5gQFr0SZo4GTfcq6xw3GEsF2XAlWMVwsVIO6n2VKaPt19C3FfYP+0OkLz+b9zNRosA5sbVfOWBqA5P6+f2a+/sbpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQrfbSvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQrfbSvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1208DC433C7;
	Mon,  1 Apr 2024 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989145;
	bh=qfZthv6AgG/7/vlsHd//b8iISVXoHfeHpse9B3F8dqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQrfbSvwrfhLPMRVzQy7btdHW++2v68hywBxExfE3wWqK/rRFl0usF5aZotprxtRK
	 VPgj5ngYjgbNyVFPeMdfO8jkLzvP9WERDGc5sGPdrhagZ1YqUgS7fYXFZZBGrr1arw
	 bs8OBJ4C2LA07RsvS53mBdRARE5rvT+8xAr4frP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sanath S <Sanath.S@amd.com>
Subject: [PATCH 6.7 395/432] usb: dwc3: Properly set system wakeup
Date: Mon,  1 Apr 2024 17:46:22 +0200
Message-ID: <20240401152605.132593860@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit f9aa41130ac69d13a53ce2a153ca79c70d43f39c upstream.

If the device is configured for system wakeup, then make sure that the
xHCI driver knows about it and make sure to permit wakeup only at the
appropriate time.

For host mode, if the controller goes through the dwc3 code path, then a
child xHCI platform device is created. Make sure the platform device
also inherits the wakeup setting for xHCI to enable remote wakeup.

For device mode, make sure to disable system wakeup if no gadget driver
is bound. We may experience unwanted system wakeup due to the wakeup
signal from the controller PMU detecting connection/disconnection when
in low power (D3). E.g. In the case of Steam Deck, the PCI PME prevents
the system staying in suspend.

Cc: stable@vger.kernel.org
Reported-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Closes: https://lore.kernel.org/linux-usb/70a7692d-647c-9be7-00a6-06fc60f77294@igalia.com/T/#mf00d6669c2eff7b308d1162acd1d66c09f0853c7
Fixes: d07e8819a03d ("usb: dwc3: add xHCI Host support")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Tested-by: Sanath S <Sanath.S@amd.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com> # Steam Deck
Link: https://lore.kernel.org/r/667cfda7009b502e08462c8fb3f65841d103cc0a.1709865476.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c   |    2 ++
 drivers/usb/dwc3/core.h   |    2 ++
 drivers/usb/dwc3/gadget.c |   10 ++++++++++
 drivers/usb/dwc3/host.c   |   11 +++++++++++
 4 files changed, 25 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1507,6 +1507,8 @@ static void dwc3_get_properties(struct d
 	else
 		dwc->sysdev = dwc->dev;
 
+	dwc->sys_wakeup = device_may_wakeup(dwc->sysdev);
+
 	ret = device_property_read_string(dev, "usb-psy-name", &usb_psy_name);
 	if (ret >= 0) {
 		dwc->usb_psy = power_supply_get_by_name(usb_psy_name);
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1127,6 +1127,7 @@ struct dwc3_scratchpad_array {
  *	3	- Reserved
  * @dis_metastability_quirk: set to disable metastability quirk.
  * @dis_split_quirk: set to disable split boundary.
+ * @sys_wakeup: set if the device may do system wakeup.
  * @wakeup_configured: set if the device is configured for remote wakeup.
  * @suspended: set to track suspend event due to U3/L2.
  * @imod_interval: set the interrupt moderation interval in 250ns
@@ -1350,6 +1351,7 @@ struct dwc3 {
 
 	unsigned		dis_split_quirk:1;
 	unsigned		async_callbacks:1;
+	unsigned		sys_wakeup:1;
 	unsigned		wakeup_configured:1;
 	unsigned		suspended:1;
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2968,6 +2968,9 @@ static int dwc3_gadget_start(struct usb_
 	dwc->gadget_driver	= driver;
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
+	if (dwc->sys_wakeup)
+		device_wakeup_enable(dwc->sysdev);
+
 	return 0;
 }
 
@@ -2983,6 +2986,9 @@ static int dwc3_gadget_stop(struct usb_g
 	struct dwc3		*dwc = gadget_to_dwc(g);
 	unsigned long		flags;
 
+	if (dwc->sys_wakeup)
+		device_wakeup_disable(dwc->sysdev);
+
 	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->gadget_driver	= NULL;
 	dwc->max_cfg_eps = 0;
@@ -4664,6 +4670,10 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	else
 		dwc3_gadget_set_speed(dwc->gadget, dwc->maximum_speed);
 
+	/* No system wakeup if no gadget driver bound */
+	if (dwc->sys_wakeup)
+		device_wakeup_disable(dwc->sysdev);
+
 	return 0;
 
 err5:
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -123,6 +123,14 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
+	if (dwc->sys_wakeup) {
+		/* Restore wakeup setting if switched from device */
+		device_wakeup_enable(dwc->sysdev);
+
+		/* Pass on wakeup setting to the new xhci platform device */
+		device_init_wakeup(&xhci->dev, true);
+	}
+
 	return 0;
 err:
 	platform_device_put(xhci);
@@ -131,6 +139,9 @@ err:
 
 void dwc3_host_exit(struct dwc3 *dwc)
 {
+	if (dwc->sys_wakeup)
+		device_init_wakeup(&dwc->xhci->dev, false);
+
 	platform_device_unregister(dwc->xhci);
 	dwc->xhci = NULL;
 }


