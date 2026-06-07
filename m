Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8CC2580CF;
	Sun,  7 Jun 2026 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829165; cv=none; b=uIadeTnAeAegNseypbmwhnAi4qyCWMlKn5vXEM01APLue75GB5tnUaZOSDG3oNuxqAzdoUDqa39ntz1lbwOGgT3SNVd4XtI13pSxSqKIk8lgitkR1N5EM5fTBXZuLT3EyWGoSKS0p27t0uPys6Y18VMILv5wv1mxB7dhSZpDbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829165; c=relaxed/simple;
	bh=EkP8oDNqE1Jaz9zLhJrYoxxgHI4FWs+7l74KE/ns9vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTusvXkLUCZO4YStfe+cEqrMbHrje7vXNChcYHgBO9DWvu46Ra9ndF6N0QIweRi1SnErdo5vPYS4Jiz95CBeNRm3Plwj3e4V4DmtHCuK+kwRnnCwX4A8ChgAjtmwR1u9lIjym4ieXYAKr31uZKhdvkSwFAR1XJfpJdFSjgk1Th8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJoElXPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJoElXPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF06E1F00893;
	Sun,  7 Jun 2026 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829164;
	bh=1N15axydbY5K7O7ugpRcPdGm59mkEzRrGMuTwtP8sLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJoElXPFJecXWHC30xBE5R+j+0X1ZmW7mNKc8LXxmfbEsnqIv0yYudrW1lck4CA7A
	 MhXlYE5srYvBCnzRxaohfWYPSzFLNlZVqOY1Z0m2gNs7tv97UXtOLxStLvcW9gAabR
	 8TMAnmpooEJhCbycFfiW3Ip4EdbmfBnXY8wyCl2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.18 222/315] usb: chipidea: core: convert ci_role_switch to local variable
Date: Sun,  7 Jun 2026 12:00:09 +0200
Message-ID: <20260607095735.728237356@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -669,12 +669,6 @@ static enum ci_role ci_get_role(struct c
 	return role;
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
@@ -801,9 +795,6 @@ static int ci_get_platdata(struct device
 			cable->connected = false;
 	}
 
-	if (device_property_read_bool(dev, "usb-role-switch"))
-		ci_role_switch.fwnode = dev->fwnode;
-
 	platdata->pctl = devm_pinctrl_get(dev);
 	if (!IS_ERR(platdata->pctl)) {
 		struct pinctrl_state *p;
@@ -1045,6 +1036,7 @@ ATTRIBUTE_GROUPS(ci);
 
 static int ci_hdrc_probe(struct platform_device *pdev)
 {
+	struct usb_role_switch_desc ci_role_switch = {};
 	struct device	*dev = &pdev->dev;
 	struct ci_hdrc	*ci;
 	struct resource	*res;
@@ -1191,7 +1183,11 @@ static int ci_hdrc_probe(struct platform
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


