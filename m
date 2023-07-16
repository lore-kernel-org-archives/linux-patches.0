Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE658F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10535C433C8;
	Sun, 16 Jul 2023 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540711;
	bh=q3iBZYpjFlMmsIkcS60RgRrzpJgwS4wLjJ5TCNk0a18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb3cmsNLWypgzFbiFgCcdbmAnN1MtQKunh9nkQKi6oZDy3vhMTI24qjm6/OpbfgE+
	 zu0VYufZg1cmxaJ9YVOPXP5t3k2JtHFrSn4iTCqv0moX4OOCWbP5QGcWtbovzkehB0
	 rq0A1qMC/m7oSowymR3p7XI/H0ij3gRildqGr5ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/591] usb: common: usb-conn-gpio: Set last role to unknown before initial detection
Date: Sun, 16 Jul 2023 21:49:33 +0200
Message-ID: <20230716194935.142150585@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit edd60d24bd858cef165274e4cd6cab43bdc58d15 ]

Currently if we bootup a device without cable connected, then
usb-conn-gpio won't call set_role() since last_role is same as
current role. This happens because during probe last_role gets
initialised to zero.

To avoid this, added a new constant in enum usb_role, last_role
is set to USB_ROLE_UNKNOWN before performing initial detection.

While at it, also handle default case for the usb_role switch
in cdns3, intel-xhci-usb-role-switch & musb/jz4740 to avoid
build warnings.

Fixes: 4602f3bff266 ("usb: common: add USB GPIO based connection detection driver")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Message-ID: <1685544074-17337-1-git-send-email-quic_prashk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c                       | 2 ++
 drivers/usb/common/usb-conn-gpio.c             | 3 +++
 drivers/usb/musb/jz4740.c                      | 2 ++
 drivers/usb/roles/intel-xhci-usb-role-switch.c | 2 ++
 include/linux/usb/role.h                       | 1 +
 5 files changed, 10 insertions(+)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index dbcdf3b24b477..69d2921f2d3b5 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -252,6 +252,8 @@ static enum usb_role cdns_hw_role_state_machine(struct cdns *cdns)
 		if (!vbus)
 			role = USB_ROLE_NONE;
 		break;
+	default:
+		break;
 	}
 
 	dev_dbg(cdns->dev, "role %d -> %d\n", cdns->role, role);
diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index e20874caba363..30bdb81934bc8 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -257,6 +257,9 @@ static int usb_conn_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, info);
 	device_set_wakeup_capable(&pdev->dev, true);
 
+	/* Set last role to unknown before performing the initial detection */
+	info->last_role = USB_ROLE_UNKNOWN;
+
 	/* Perform initial detection */
 	usb_conn_queue_dwork(info, 0);
 
diff --git a/drivers/usb/musb/jz4740.c b/drivers/usb/musb/jz4740.c
index d1e4e0deb7535..df4e9d397d986 100644
--- a/drivers/usb/musb/jz4740.c
+++ b/drivers/usb/musb/jz4740.c
@@ -91,6 +91,8 @@ static int jz4740_musb_role_switch_set(struct usb_role_switch *sw,
 	case USB_ROLE_HOST:
 		atomic_notifier_call_chain(&phy->notifier, USB_EVENT_ID, phy);
 		break;
+	default:
+		break;
 	}
 
 	return 0;
diff --git a/drivers/usb/roles/intel-xhci-usb-role-switch.c b/drivers/usb/roles/intel-xhci-usb-role-switch.c
index 5c96e929acea0..4d6a3dd06e011 100644
--- a/drivers/usb/roles/intel-xhci-usb-role-switch.c
+++ b/drivers/usb/roles/intel-xhci-usb-role-switch.c
@@ -97,6 +97,8 @@ static int intel_xhci_usb_set_role(struct usb_role_switch *sw,
 		val |= SW_VBUS_VALID;
 		drd_config = DRD_CONFIG_STATIC_DEVICE;
 		break;
+	default:
+		break;
 	}
 	val |= SW_IDPIN_EN;
 	if (data->enable_sw_switch) {
diff --git a/include/linux/usb/role.h b/include/linux/usb/role.h
index b5deafd91f67b..65e790a28913e 100644
--- a/include/linux/usb/role.h
+++ b/include/linux/usb/role.h
@@ -11,6 +11,7 @@ enum usb_role {
 	USB_ROLE_NONE,
 	USB_ROLE_HOST,
 	USB_ROLE_DEVICE,
+	USB_ROLE_UNKNOWN,
 };
 
 typedef int (*usb_role_switch_set_t)(struct usb_role_switch *sw,
-- 
2.39.2



