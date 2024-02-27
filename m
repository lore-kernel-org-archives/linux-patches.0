Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E8145B16;
	Tue, 27 Feb 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041594; cv=none; b=I/vZMV++KEneB+tblxKfvCHdePhbCgKZoAOsuO61JMCEHYXpOXx8YHadJDjE9e3O43T7xHh76FF6L/llVTyrT7lCsfr1R4IvBXAbugFzSVYfrpSGJoVmGkIRt5FlJy+FvRIlmDhZ1T5b9S+yzNUv5bidmAp7nf5HaPVWZXz2RTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041594; c=relaxed/simple;
	bh=HMLYxvFstwsiaHCnlPCIJcYpKJW46H54BNaYSOlpDtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGc1giPJifCerpgQqxremXIEbOX7dJFsEzQqV6gYgPRBK/ykDyfxJJTgJyRFVWIRTgEMrP6tYcWCpsa86X7KvGQLYllhBvTdBPMcymyWtdwzbvR/Ebqcrdb7b7opJwLRjlMVnupPND42DX2roR0j5AIntWYDT+NjU5Jq75NaRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugPh0+VZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugPh0+VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F54C43394;
	Tue, 27 Feb 2024 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041594;
	bh=HMLYxvFstwsiaHCnlPCIJcYpKJW46H54BNaYSOlpDtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugPh0+VZ23An11mcz7Ha1Q7iZPJ1hDwmyFoZ6PKdT+ExlyplBZYXcInyZ0xGpanXQ
	 y/JRFOXBUD+sMoN3OkOSnc695pidLaUxG+22cOOP9RhVfGSFQgTNLDuecW4Gx4On1I
	 HEOuI4eJmxq1wLG99W5hNH/5CyjQ4SpFvEpSSXlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.19 34/52] usb: roles: dont get/set_role() when usb_role_switch is unregistered
Date: Tue, 27 Feb 2024 14:26:21 +0100
Message-ID: <20240227131549.652999750@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b787a3e781759026a6212736ef8e52cf83d1821a upstream.

There is a possibility that usb_role_switch device is unregistered before
the user put usb_role_switch. In this case, the user may still want to
get/set_role() since the user can't sense the changes of usb_role_switch.

This will add a flag to show if usb_role_switch is already registered and
avoid unwanted behaviors.

Fixes: fde0aa6c175a ("usb: common: Small class for USB role switches")
cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240129093739.2371530-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -19,6 +19,7 @@ struct usb_role_switch {
 	struct device dev;
 	struct mutex lock; /* device lock*/
 	enum usb_role role;
+	bool registered;
 
 	/* From descriptor */
 	struct device *usb2_port;
@@ -45,6 +46,9 @@ int usb_role_switch_set_role(struct usb_
 	if (IS_ERR_OR_NULL(sw))
 		return 0;
 
+	if (!sw->registered)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&sw->lock);
 
 	ret = sw->set(sw->dev.parent, role);
@@ -68,7 +72,7 @@ enum usb_role usb_role_switch_get_role(s
 {
 	enum usb_role role;
 
-	if (IS_ERR_OR_NULL(sw))
+	if (IS_ERR_OR_NULL(sw) || !sw->registered)
 		return USB_ROLE_NONE;
 
 	mutex_lock(&sw->lock);
@@ -276,6 +280,8 @@ usb_role_switch_register(struct device *
 		return ERR_PTR(ret);
 	}
 
+	sw->registered = true;
+
 	/* TODO: Symlinks for the host port and the device controller. */
 
 	return sw;
@@ -290,8 +296,10 @@ EXPORT_SYMBOL_GPL(usb_role_switch_regist
  */
 void usb_role_switch_unregister(struct usb_role_switch *sw)
 {
-	if (!IS_ERR_OR_NULL(sw))
+	if (!IS_ERR_OR_NULL(sw)) {
+		sw->registered = false;
 		device_unregister(&sw->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(usb_role_switch_unregister);
 


