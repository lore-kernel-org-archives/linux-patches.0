Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA13AE1A2;
	Tue, 16 Jun 2026 18:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635836; cv=none; b=ii/gCYpQE9WfInaxKBmAVxMnfbMfUxgNP3y7UO8c1LgIc0bkfaQP+FTWENzQMVu6KnMx00Ydm/YJ3npldv530tpKcIEdlPprMotLYl30BR82iTSPYvtnX97K/6CAK3wAlRew/Rr14XY6gn809KPmZa6c3cBnzddMHBKfMoiFD0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635836; c=relaxed/simple;
	bh=8htpIbOXkAIkLZWm/Xj62KEgZXjIhsZlsZd2sobwCSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6MHgD5sFNbadliKqlo9bccajTCbvwqvquSJwsRYTlu83XQBH6eorXS5HYndheEecSCiOt+vsKEevHEOsLzNCdXHHhGYIsOtKcZrlM2QMI5fM8GcKRnS7uKyoI1T3KSLkXc5sirEQfEr9BxdXlkFfZMny9/Hid+nsf73uVp+Pws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vovLtr2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vovLtr2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F74D1F000E9;
	Tue, 16 Jun 2026 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635835;
	bh=ZxtCOkfA3C1HKldQ6KEq3pldxE6LovBOLiqFxCS+cx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vovLtr2FPJquoB/qKEYIGreG6HIa7XhJW2NUVu2bU/teH7Yv5R8Cgq5C+cCzC1+H6
	 R7S65fbm3uJBOYLgjsZ96GWkBTeUN6NGCesuvyl0re5Cp3Ng0XZHBqi9wp0df78xWK
	 QiPy76HlxNs0D4mbLNd5vRgyM0v4PE2IATDv/2is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.10 090/342] usb: chipidea: core: convert ci_role_switch to local variable
Date: Tue, 16 Jun 2026 20:26:26 +0530
Message-ID: <20260616145052.431963268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -654,12 +654,6 @@ static int ci_usb_role_switch_set(struct
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
@@ -786,9 +780,6 @@ static int ci_get_platdata(struct device
 			cable->connected = false;
 	}
 
-	if (device_property_read_bool(dev, "usb-role-switch"))
-		ci_role_switch.fwnode = dev->fwnode;
-
 	platdata->pctl = devm_pinctrl_get(dev);
 	if (!IS_ERR(platdata->pctl)) {
 		struct pinctrl_state *p;
@@ -1005,6 +996,7 @@ ATTRIBUTE_GROUPS(ci);
 
 static int ci_hdrc_probe(struct platform_device *pdev)
 {
+	struct usb_role_switch_desc ci_role_switch = {};
 	struct device	*dev = &pdev->dev;
 	struct ci_hdrc	*ci;
 	struct resource	*res;
@@ -1146,7 +1138,11 @@ static int ci_hdrc_probe(struct platform
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


