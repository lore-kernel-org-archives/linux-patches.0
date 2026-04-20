Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C02D77E5;
	Mon, 20 Apr 2026 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700428; cv=none; b=G3r7ompZt2YIl5HA/CzjZRLVOYvkNzRztx1GwfwdriIj+8kVcWQ2BeRBrpmWfhJDdvjX14ARD0GBnqC7bD3pPYd25s3N0Wti4CsyoHqgr7zsCfuRq1LdKwrJOCquENkBW6R/pq1uFW3nrcGTKBq+avWhl844wmOM1/+OWWERvjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700428; c=relaxed/simple;
	bh=OiRWUVvI/t7S2UerChIavVeeua2pfb3BgMKwMdFz+ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byzpheLJsOlSPCSPdlY07XJC3j4XGlUjWI5yhZbILjQOLl/Knu9/BGs6ETpG9t3a+zDUNGUHYs2OD/fUSjPDfswzbwRvIxzFzzofCN8+BE8RioegnpF2FaOLWut63w8UoSh8I23Ji5SQ0ilRrNm9/b06VE/5cE+t3BOARf62SMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPdAlXxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPdAlXxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85853C19425;
	Mon, 20 Apr 2026 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700427;
	bh=OiRWUVvI/t7S2UerChIavVeeua2pfb3BgMKwMdFz+ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPdAlXxzAildlUiR04gf4qH3K826uj9Frvf0+o7ZSn1zgQu4KQkob8UMuhgWeqt3D
	 lr4PjzIRwDYX6l64Kuyrd7jEKc7goL55N/W/ZyavoSCGy948Zgl5t4qEkin27d8zf+
	 LzcdjfEsaSHGJ9Y70FOXksCBlYNq9AbIGKsc3Ah8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.19 168/220] usb: port: add delay after usb_hub_set_port_power()
Date: Mon, 20 Apr 2026 17:41:49 +0200
Message-ID: <20260420153940.076873836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,6 +141,7 @@ static ssize_t disable_store(struct devi
 		usb_disconnect(&port_dev->child);
 
 	rc = usb_hub_set_port_power(hdev, hub, port1, !disabled);
+	msleep(2 * hub_power_on_good_delay(hub));
 
 	if (disabled) {
 		usb_clear_port_feature(hdev, port1, USB_PORT_FEAT_C_CONNECTION);


