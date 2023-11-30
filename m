Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E65524C2;
	Thu, 30 Nov 2023 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3V8ryef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4996C433C7;
	Thu, 30 Nov 2023 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361660;
	bh=Wb6NCm/ayWcsowgpZUQNhcY6ZBGWvqD6b6yrWuU189U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3V8ryefA3lxVniqq6pSnFMo4xGcs3tjHaEuzbCFTGMMe61sYp0ICz6CYpSRMFK5D
	 OsVo6uOPdSvrCL8pVqyee39hcnprNByUo1hx9kwckry8ML7F4hjtwgGV8enMA+1at6
	 TY4PIHvq4404j4mpunXAk4V/fel3v65x65lJAN0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chang <stanley_chang@realtek.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.6 086/112] Revert "usb: phy: add usb phy notify port status API"
Date: Thu, 30 Nov 2023 16:22:13 +0000
Message-ID: <20231130162143.056999223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 1a229d8690a0f8951fc4aa8b76a7efab0d8de342 upstream.

This reverts commit a08799cf17c22375752abfad3b4a2b34b3acb287.

The recently added Realtek PHY drivers depend on the new port status
notification mechanism which was built on the deprecated USB PHY
implementation and devicetree binding.

Specifically, using these PHYs would require describing the very same
PHY using both the generic "phy" property and the deprecated "usb-phy"
property which is clearly wrong.

We should not be building new functionality on top of the legacy USB PHY
implementation even if it is currently stuck in some kind of
transitional limbo.

Revert the new notification interface which is broken by design.

Fixes: a08799cf17c2 ("usb: phy: add usb phy notify port status API")
Cc: stable@vger.kernel.org      # 6.6
Cc: Stanley Chang <stanley_chang@realtek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231106110654.31090-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c  | 23 -----------------------
 include/linux/usb/phy.h | 13 -------------
 2 files changed, 36 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b4584a0cd484..87480a6e6d93 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -622,29 +622,6 @@ static int hub_ext_port_status(struct usb_hub *hub, int port1, int type,
 		ret = 0;
 	}
 	mutex_unlock(&hub->status_mutex);
-
-	/*
-	 * There is no need to lock status_mutex here, because status_mutex
-	 * protects hub->status, and the phy driver only checks the port
-	 * status without changing the status.
-	 */
-	if (!ret) {
-		struct usb_device *hdev = hub->hdev;
-
-		/*
-		 * Only roothub will be notified of port state changes,
-		 * since the USB PHY only cares about changes at the next
-		 * level.
-		 */
-		if (is_root_hub(hdev)) {
-			struct usb_hcd *hcd = bus_to_hcd(hdev->bus);
-
-			if (hcd->usb_phy)
-				usb_phy_notify_port_status(hcd->usb_phy,
-							   port1 - 1, *status, *change);
-		}
-	}
-
 	return ret;
 }
 
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index b513749582d7..e4de6bc1f69b 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -144,10 +144,6 @@ struct usb_phy {
 	 */
 	int	(*set_wakeup)(struct usb_phy *x, bool enabled);
 
-	/* notify phy port status change */
-	int	(*notify_port_status)(struct usb_phy *x, int port,
-				      u16 portstatus, u16 portchange);
-
 	/* notify phy connect status change */
 	int	(*notify_connect)(struct usb_phy *x,
 			enum usb_device_speed speed);
@@ -320,15 +316,6 @@ usb_phy_set_wakeup(struct usb_phy *x, bool enabled)
 		return 0;
 }
 
-static inline int
-usb_phy_notify_port_status(struct usb_phy *x, int port, u16 portstatus, u16 portchange)
-{
-	if (x && x->notify_port_status)
-		return x->notify_port_status(x, port, portstatus, portchange);
-	else
-		return 0;
-}
-
 static inline int
 usb_phy_notify_connect(struct usb_phy *x, enum usb_device_speed speed)
 {
-- 
2.43.0



