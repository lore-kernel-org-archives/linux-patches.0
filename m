Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9DE2580CF;
	Sun,  7 Jun 2026 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829173; cv=none; b=PAPBqhguRBpuXV1+krIYt4gUAcaDPPqIfs0XXoyREh58+n0aUz0MbIFXtDq4mu/233SGr05x9/wB9TCa82YzsxL3RlUa2gU5uFjeb2dMPt9gQ4TPg++2vqZuDlwBDTP0O92rP4U/wMcBZgWmUt6EwY7g4czhvZujsESY8DbOca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829173; c=relaxed/simple;
	bh=GxX98q4B54umtcbVlqaiSexNWSCtKBZVPb5LCcyat+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUFk9a/idTWPPIqg0RMki8gZWd9O+lUCN/Ot9SkNPaYtuWCVEFv3d0shr//Lcvikme9DeEhN19LKAZhM0jYw24y4iDLdcyjKy4mNWVGJe7gLGznETiv4nsREDdxvLKXOiAKm2Ge02ykogjiE18MCGpmNX11hZdqZ9cWulMD2Ehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN1JuWQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN1JuWQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A61F00893;
	Sun,  7 Jun 2026 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829172;
	bh=JjKlVpwuCJnfUqcqOHHNzxPubVNTmiteucjHutoVlZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XN1JuWQDWCi5QkdvNbRYR9SVnVBUrKE0QaFaq+aKQo6rbDdYlJISCvQvVdz3q+DYW
	 CLWETf3L1B+U7LBWLoPUqJOL46JNP1cj0wkl5DFWmew8DQ5VG/zg1tl98cvBV1h61y
	 /iwYjqg9sSiTSAurw3/Wpq3Z+R7hFd5Pv+SI6LA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 7.0 251/332] usb: chipidea: core: convert ci_role_switch to local variable
Date: Sun,  7 Jun 2026 12:00:20 +0200
Message-ID: <20260607095737.265848910@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,12 +670,6 @@ static enum ci_role ci_get_role(struct c
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
@@ -802,9 +796,6 @@ static int ci_get_platdata(struct device
 			cable->connected = false;
 	}
 
-	if (device_property_read_bool(dev, "usb-role-switch"))
-		ci_role_switch.fwnode = dev->fwnode;
-
 	platdata->pctl = devm_pinctrl_get(dev);
 	if (!IS_ERR(platdata->pctl)) {
 		struct pinctrl_state *p;
@@ -1048,6 +1039,7 @@ ATTRIBUTE_GROUPS(ci);
 
 static int ci_hdrc_probe(struct platform_device *pdev)
 {
+	struct usb_role_switch_desc ci_role_switch = {};
 	struct device	*dev = &pdev->dev;
 	struct ci_hdrc	*ci;
 	struct resource	*res;
@@ -1194,7 +1186,11 @@ static int ci_hdrc_probe(struct platform
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


