Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584313D5656;
	Tue, 16 Jun 2026 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633589; cv=none; b=BnT+2YiTSLYPZDWOHF6wc5EtEtMyzcYAs1HZI0KlV6R40DsSToi9HeDQZMMST5CggGwCFn5rg91wkqlBYCIhUSxcPLvgFCYTiDQz98wZ1VStH9ZvVgeXaEYEcoBoCMx9OiFr2n59/+c5fEbDIMVTwB/2l9fChGptUJg/WIJUV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633589; c=relaxed/simple;
	bh=yUbR3FUXgL08VPxoodLP/LI9GmqsJM1qVnTJdUY66XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJi6XpT3+pHyklDxNAugQTVKuFQE85t74pjkUTNRPPf02L7cupoUQ59IWwX64+CgAFVXmsmAX0Gdnvm5B3clUNoLKMW7nh6LB2XMwk4gfxD489N/h5872X1E5AVexsWiKzqCTNYy4nQYgv3C4dkzE2Z9WGyUbDbH/siaVMTNa14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2otsd71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2otsd71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0551F000E9;
	Tue, 16 Jun 2026 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633588;
	bh=YFvgeYXUs2f079bguzEVeFwD+GJz0qGEcQN+ozYIsfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2otsd71PfSx1pQKtsbR6TDpWXqFngAasaLeexJdvfBk/EF05sosYQ7wuCBlmFzCQ
	 Twu2bGy12L+QeJAZj+/x1cE0HqAp8V7nR4qI9KjwjV15Rl20FoqIO9QywH1jLOhni/
	 UIqnYrn8VJwGDwZn8h+tQ28pxJnWH7Ca+PxMOZjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.15 107/411] usb: chipidea: core: convert ci_role_switch to local variable
Date: Tue, 16 Jun 2026 20:25:45 +0530
Message-ID: <20260616145105.945804342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 8f6aa392653e52a45858cff5c063df550028836b upstream.

When a system contains multiple USB controllers, the global ci_role_switch
variable may be overwritten by subsequent driver initialization code.

This can cause issues in the following cases:
 - The 2nd ci_hdrc_probe() sees ci_role_switch.fwnode as non-NULL even
   though the "usb-role-switch" property is not present for the controller.
 - When the ci_hdrc device is unbound and bound again, ci_role_switch
   fwnode will not be reassigned, and the old value will be used instead.

Convert ci_role_switch to a local variable to fix these issues.

Fixes: 05559f10ed79 ("usb: chipidea: add role switch class support")
Cc: stable <stable@kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260427075755.3611217-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -659,12 +659,6 @@ static int ci_usb_role_switch_set(struct
 	return 0;
 }
 
-static struct usb_role_switch_desc ci_role_switch = {
-	.set = ci_usb_role_switch_set,
-	.get = ci_usb_role_switch_get,
-	.allow_userspace_control = true,
-};
-
 static int ci_get_platdata(struct device *dev,
 		struct ci_hdrc_platform_data *platdata)
 {
@@ -791,9 +785,6 @@ static int ci_get_platdata(struct device
 			cable->connected = false;
 	}
 
-	if (device_property_read_bool(dev, "usb-role-switch"))
-		ci_role_switch.fwnode = dev->fwnode;
-
 	platdata->pctl = devm_pinctrl_get(dev);
 	if (!IS_ERR(platdata->pctl)) {
 		struct pinctrl_state *p;
@@ -1013,6 +1004,7 @@ ATTRIBUTE_GROUPS(ci);
 
 static int ci_hdrc_probe(struct platform_device *pdev)
 {
+	struct usb_role_switch_desc ci_role_switch = {};
 	struct device	*dev = &pdev->dev;
 	struct ci_hdrc	*ci;
 	struct resource	*res;
@@ -1154,7 +1146,11 @@ static int ci_hdrc_probe(struct platform
 		}
 	}
 
-	if (ci_role_switch.fwnode) {
+	if (device_property_read_bool(dev, "usb-role-switch")) {
+		ci_role_switch.set = ci_usb_role_switch_set;
+		ci_role_switch.get = ci_usb_role_switch_get;
+		ci_role_switch.allow_userspace_control = true;
+		ci_role_switch.fwnode = dev_fwnode(dev);
 		ci_role_switch.driver_data = ci;
 		ci->role_switch = usb_role_switch_register(dev,
 					&ci_role_switch);


