Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5730BB9A;
	Mon, 13 Oct 2025 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368717; cv=none; b=GULdmb6bwOXgdOLIp86xL6l1VkhAitiwDbpU5+Vkv1UFTpUEyBgheXnaYgIW3qpEdqc/l3s7Nbai5LrE2/3b8PHKMSayvnQcNIw2/Vh4hotAvAZQ04s24n9JtL1LYrpUNxsW6qPR+l8M2/HweVM+Cs1UJ++R5OMaKh4ooVmPFPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368717; c=relaxed/simple;
	bh=o5QrofD7a4BRKwEs5cTvr58q3lL9xvw6uV0B3xrp6sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANpmda1Z/AsY2gzQZamd2jMxMJ4uf1wnsDCMRLSat59WQT2sGZtH4agcq2PO+BuzPftHruFXgBCF1LsbFAfyfHxsyGiNGBGPftoB5hcjlhpOaKbYWiQe0uO4kzPcxNQG2xuEyT01G66u5XPEmPWkwFoBirl5n1aQZ+MKgjbBIjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOE+x//u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOE+x//u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF21C4CEE7;
	Mon, 13 Oct 2025 15:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368717;
	bh=o5QrofD7a4BRKwEs5cTvr58q3lL9xvw6uV0B3xrp6sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOE+x//u7clitvTn1U2qzJ4H/9/GcXX4farxAi8z7d+7hQTeyhr0J3OVQ25XwgU/1
	 VMUOSnA3lJNNjkYd9O+lEx9S2iM2K/eLu3a1j5dkdIkjqxJgbUBme547DmOKlMvC3t
	 HK/d/0f9d9nRgNHII3/zOmEdXIyDIDAeOv7i6FYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Hubert=20Wi=C5=9Bniewski?= <hubert.wisniewski.25632@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 259/262] net: usb: asix: hold PM usage ref to avoid PM/MDIO + RTNL deadlock
Date: Mon, 13 Oct 2025 16:46:41 +0200
Message-ID: <20251013144335.560742997@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 3d3c4cd5c62f24bb3cb4511b7a95df707635e00a upstream.

Prevent USB runtime PM (autosuspend) for AX88772* in bind.

usbnet enables runtime PM (autosuspend) by default, so disabling it via
the usb_driver flag is ineffective. On AX88772B, autosuspend shows no
measurable power saving with current driver (no link partner, admin
up/down). The ~0.453 W -> ~0.248 W drop on v6.1 comes from phylib powering
the PHY off on admin-down, not from USB autosuspend.

The real hazard is that with runtime PM enabled, ndo_open() (under RTNL)
may synchronously trigger autoresume (usb_autopm_get_interface()) into
asix_resume() while the USB PM lock is held. Resume paths then invoke
phylink/phylib and MDIO, which also expect RTNL, leading to possible
deadlocks or PM lock vs MDIO wake issues.

To avoid this, keep the device runtime-PM active by taking a usage
reference in ax88772_bind() and dropping it in unbind(). A non-zero PM
usage count blocks runtime suspend regardless of userspace policy
(.../power/control - pm_runtime_allow/forbid), making this approach
robust against sysfs overrides.

Holding a runtime-PM usage ref does not affect system-wide suspend;
system sleep/resume callbacks continue to run as before.

Fixes: 4a2c7217cd5a ("net: usb: asix: ax88772: manage PHY PM from MAC")
Reported-by: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
Closes: https://lore.kernel.org/all/DCGHG5UJT9G3.2K1GHFZ3H87T0@gmail.com
Tested-by: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/all/b5ea8296-f981-445d-a09a-2f389d7f6fdd@samsung.com
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20251005081203.3067982-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_devices.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -625,6 +625,21 @@ static void ax88772_suspend(struct usbne
 		   asix_read_medium_status(dev, 1));
 }
 
+/* Notes on PM callbacks and locking context:
+ *
+ * - asix_suspend()/asix_resume() are invoked for both runtime PM and
+ *   system-wide suspend/resume. For struct usb_driver the ->resume()
+ *   callback does not receive pm_message_t, so the resume type cannot
+ *   be distinguished here.
+ *
+ * - The MAC driver must hold RTNL when calling phylink interfaces such as
+ *   phylink_suspend()/resume(). Those calls will also perform MDIO I/O.
+ *
+ * - Taking RTNL and doing MDIO from a runtime-PM resume callback (while
+ *   the USB PM lock is held) is fragile. Since autosuspend brings no
+ *   measurable power saving here, we block it by holding a PM usage
+ *   reference in ax88772_bind().
+ */
 static int asix_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
@@ -919,6 +934,13 @@ static int ax88772_bind(struct usbnet *d
 	if (ret)
 		goto initphy_err;
 
+	/* Keep this interface runtime-PM active by taking a usage ref.
+	 * Prevents runtime suspend while bound and avoids resume paths
+	 * that could deadlock (autoresume under RTNL while USB PM lock
+	 * is held, phylink/MDIO wants RTNL).
+	 */
+	pm_runtime_get_noresume(&intf->dev);
+
 	return 0;
 
 initphy_err:
@@ -948,6 +970,8 @@ static void ax88772_unbind(struct usbnet
 	phylink_destroy(priv->phylink);
 	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
+	/* Drop the PM usage ref taken in bind() */
+	pm_runtime_put(&intf->dev);
 }
 
 static void ax88178_unbind(struct usbnet *dev, struct usb_interface *intf)
@@ -1600,6 +1624,11 @@ static struct usb_driver asix_driver = {
 	.resume =	asix_resume,
 	.reset_resume =	asix_resume,
 	.disconnect =	usbnet_disconnect,
+	/* usbnet enables autosuspend by default (supports_autosuspend=1).
+	 * We keep runtime-PM active for AX88772* by taking a PM usage
+	 * reference in ax88772_bind() (pm_runtime_get_noresume()) and
+	 * dropping it in unbind(), which effectively blocks autosuspend.
+	 */
 	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
 };


