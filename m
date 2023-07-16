Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AD58F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6C0C433C8;
	Sun, 16 Jul 2023 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538974;
	bh=zwFxB9uSf1fhT3gnZvWfuX2AivR7DrL8NbpQVka2umM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bidh3Zyj9UwlGJqEuvoTJti+Wq448aX+Bl2Y/PWsy1IkEep9agLdXiI75uXgueoKr
	 De9aKM6r9Y8o3+niqyezLPtiNw8Fxn4KYcTSNLRNYssmbps2zmrGFjLkY+7wYwBuGd
	 eh+t+FwABgOBBybGvI9L2hg04hY0ZlAdOqok1KKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Prashanth K <quic_prashk@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 625/800] Revert "usb: common: usb-conn-gpio: Set last role to unknown before initial detection"
Date: Sun, 16 Jul 2023 21:47:58 +0200
Message-ID: <20230716195003.628872558@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit df49f2a0ac4a34c0cb4b5c233fcfa0add644c43c ]

This reverts commit edd60d24bd858cef165274e4cd6cab43bdc58d15.

Heikki reports that this should not be a global flag just to work around
one broken driver and should be fixed differently, so revert it.

Reported-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Fixes: edd60d24bd85 ("usb: common: usb-conn-gpio: Set last role to unknown before initial detection")
Link: https://lore.kernel.org/r/ZImE4L3YgABnCIsP@kuha.fi.intel.com
Cc: Prashanth K <quic_prashk@quicinc.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c                       | 2 --
 drivers/usb/common/usb-conn-gpio.c             | 3 ---
 drivers/usb/musb/jz4740.c                      | 2 --
 drivers/usb/roles/intel-xhci-usb-role-switch.c | 2 --
 include/linux/usb/role.h                       | 1 -
 5 files changed, 10 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 69d2921f2d3b5..dbcdf3b24b477 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -252,8 +252,6 @@ static enum usb_role cdns_hw_role_state_machine(struct cdns *cdns)
 		if (!vbus)
 			role = USB_ROLE_NONE;
 		break;
-	default:
-		break;
 	}
 
 	dev_dbg(cdns->dev, "role %d -> %d\n", cdns->role, role);
diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index 30bdb81934bc8..e20874caba363 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -257,9 +257,6 @@ static int usb_conn_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, info);
 	device_set_wakeup_capable(&pdev->dev, true);
 
-	/* Set last role to unknown before performing the initial detection */
-	info->last_role = USB_ROLE_UNKNOWN;
-
 	/* Perform initial detection */
 	usb_conn_queue_dwork(info, 0);
 
diff --git a/drivers/usb/musb/jz4740.c b/drivers/usb/musb/jz4740.c
index 6d880c4cce36e..5aabdd7e2511d 100644
--- a/drivers/usb/musb/jz4740.c
+++ b/drivers/usb/musb/jz4740.c
@@ -95,8 +95,6 @@ static int jz4740_musb_role_switch_set(struct usb_role_switch *sw,
 	case USB_ROLE_HOST:
 		atomic_notifier_call_chain(&phy->notifier, USB_EVENT_ID, phy);
 		break;
-	default:
-		break;
 	}
 
 	return 0;
diff --git a/drivers/usb/roles/intel-xhci-usb-role-switch.c b/drivers/usb/roles/intel-xhci-usb-role-switch.c
index 4d6a3dd06e011..5c96e929acea0 100644
--- a/drivers/usb/roles/intel-xhci-usb-role-switch.c
+++ b/drivers/usb/roles/intel-xhci-usb-role-switch.c
@@ -97,8 +97,6 @@ static int intel_xhci_usb_set_role(struct usb_role_switch *sw,
 		val |= SW_VBUS_VALID;
 		drd_config = DRD_CONFIG_STATIC_DEVICE;
 		break;
-	default:
-		break;
 	}
 	val |= SW_IDPIN_EN;
 	if (data->enable_sw_switch) {
diff --git a/include/linux/usb/role.h b/include/linux/usb/role.h
index 65e790a28913e..b5deafd91f67b 100644
--- a/include/linux/usb/role.h
+++ b/include/linux/usb/role.h
@@ -11,7 +11,6 @@ enum usb_role {
 	USB_ROLE_NONE,
 	USB_ROLE_HOST,
 	USB_ROLE_DEVICE,
-	USB_ROLE_UNKNOWN,
 };
 
 typedef int (*usb_role_switch_set_t)(struct usb_role_switch *sw,
-- 
2.39.2



