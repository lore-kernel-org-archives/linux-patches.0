Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEFF34A79D;
	Sat, 30 May 2026 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158696; cv=none; b=i7rdpvMMco7WWKGENAGcWtFnszg190Wd/v1Jk1pOk4YwBqld6sC1EcRX4Lr19d48N+4wrez2rCP2FDXAvLjNxwrtPQng5eMuG1U6tsksMW6+/3BgxkXDlw183IyVw03xoh2rEnpRvqC1/DhbEadK9TfJGqc0d9mh21vstSEPeP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158696; c=relaxed/simple;
	bh=H3LxCqnb+Y/jLpPKC3ZtJYhMMK2ylzqrAbO9R3L1Wwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3CWRHb5t8KMpUgp08Fz8znigm0TShfQtbbBw8o9gMDIdM4ykZ3j961nWDoKyzwe/zSMjLMTDHRHIZQA/9OMhIbKtAiCVNuwfXCcOs3t3njZ/EKhmOtn01OpjJmbPs5EuFNNaSl8L9JujvZTYencVAfNJ1nZiHgBc5Gvbr7XnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxtrNpx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxtrNpx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC441F00893;
	Sat, 30 May 2026 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158695;
	bh=A1yR4tkAVHYBDwdeZDcuHAvZM+6SMfkGS7jUI5kfiNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxtrNpx8kBL68i4xe35pK4aeOTSlmu4asw9x+2jZ8v6MHP21vPNjl5X+iySMNg+kM
	 pMRT8U6QKFZZ5OCk8NVyQdXkVjEEICHaUtUXlc39Gr3itZ4u1qdqblNF+JzEzgJKJs
	 L3C8L5iqWdKLldvCC3CYLSQM1sjXHhGdbVcAAXtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.1 075/969] usb: port: add delay after usb_hub_set_port_power()
Date: Sat, 30 May 2026 17:53:19 +0200
Message-ID: <20260530160302.426546834@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b84cc80610a8ce036deb987f056ce3196ead7f1e upstream.

When a port is disabled, an attached device will be disconnected.  This
causes a port-status-change event, which will race with hub autosuspend
(if the disabled port was the only connected port on its hub), causing
an immediate resume and a second autosuspend.  Both of these can be
avoided by adding a short delay after the call to
usb_hub_set_port_power().

Below log shows what is happening:

$ echo 1 > usb1-port1/disable
[   37.958239] usb 1-1: USB disconnect, device number 2
[   37.964101] usb 1-1: unregistering device
[   37.970070] hub 1-0:1.0: hub_suspend
[   37.971305] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
[   37.974412] usb usb1: bus auto-suspend, wakeup 1
[   37.988175] usb usb1: suspend raced with wakeup event         <---
[   37.993947] usb usb1: usb auto-resume
[   37.998401] hub 1-0:1.0: hub_resume
[   38.105688] usb usb1-port1: status 0000, change 0000, 12 Mb/s
[   38.112399] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[   38.118645] hub 1-0:1.0: hub_suspend
[   38.122963] usb usb1: bus auto-suspend, wakeup 1
[   38.200368] usb usb1: usb wakeup-resume
[   38.204982] usb usb1: usb auto-resume
[   38.209376] hub 1-0:1.0: hub_resume
[   38.213676] usb usb1-port1: status 0101 change 0001
[   38.321552] hub 1-0:1.0: state 7 ports 1 chg 0002 evt 0000
[   38.327978] usb usb1-port1: status 0101, change 0000, 12 Mb/s
[   38.457429] usb 1-1: new high-speed USB device number 3 using ci_hdrc

Then, port change bit will be fixed to the final state and
usb_clear_port_feature() can correctly clear it after this period. This
will also avoid usb runtime suspend routine to run because
usb_autopm_put_interface() not run yet.

Fixes: f061f43d7418 ("usb: hub: port: add sysfs entry to switch port power")
Cc: stable@kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260316095042.1559882-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -111,6 +111,7 @@ static ssize_t disable_store(struct devi
 		usb_disconnect(&port_dev->child);
 
 	rc = usb_hub_set_port_power(hdev, hub, port1, !disabled);
+	msleep(2 * hub_power_on_good_delay(hub));
 
 	if (disabled) {
 		usb_clear_port_feature(hdev, port1, USB_PORT_FEAT_C_CONNECTION);


