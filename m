Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEEC433C8;
	Tue, 25 Jul 2023 11:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284132;
	bh=DXsBlyXl6a8bx2jBOGbUfTKNT3T1e0cuJSeYlHczbmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UamD7AIsbB0irto4nD3egGWckDF6JLEpQhvi0SMHaBIm+MvMgw0PQ0ZjCy5TyBRnQ
	 BVQb85AKJtpDSRFCTd6LQn+akXoz7A/waR1rADfEndfUueBdrvl9LocKohGY9CccnE
	 1/zgK69IsfRNqaU2Jhtn+7QdxyzmLCKAoPa6Sf7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/509] usb: common: usb-conn-gpio: Set last role to unknown before initial detection
Date: Tue, 25 Jul 2023 12:43:04 +0200
Message-ID: <20230725104604.962752812@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 8fe7420de033d..e5fe640b2bb01 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -243,6 +243,8 @@ static enum usb_role cdns3_hw_role_state_machine(struct cdns3 *cdns)
 		if (!vbus)
 			role = USB_ROLE_NONE;
 		break;
+	default:
+		break;
 	}
 
 	dev_dbg(cdns->dev, "role %d -> %d\n", cdns->role, role);
diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index c9545a4eff664..5754e467c16a8 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -276,6 +276,9 @@ static int usb_conn_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, info);
 
+	/* Set last role to unknown before performing the initial detection */
+	info->last_role = USB_ROLE_UNKNOWN;
+
 	/* Perform initial detection */
 	usb_conn_queue_dwork(info, 0);
 
diff --git a/drivers/usb/musb/jz4740.c b/drivers/usb/musb/jz4740.c
index c4fe1f4cd17a3..f283629091ec4 100644
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
index b9ccaeb8a4aef..aecfce46d3544 100644
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



