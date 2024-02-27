Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E459354BD4;
	Tue, 27 Feb 2024 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042218; cv=none; b=Zim72uH6X+zEPo27V88nomqSMt85BOBa8dRhnIZVjruKdd8PAlpwDGl5zFEMqrVnOsjR7jZhz04CC36+OKrafTH9aXVhaj6Rqy7i/bSnXf6jZ0IRemrM3IlGDHcY0G/LFtLme99219KDvA0lVQQElalrp8/Ash3HK2lMBy6fl0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042218; c=relaxed/simple;
	bh=Ev3UCLkIfPA3WRGQMAJn9zPLxyWVJVWA8RGPYPZL6yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmPEc92kYHKthObaEFke2u/nR1dpjcyu3gaMKtSkyopTTcN20vksyybVexb2s/XChFfMv0pKLLjaodL6Z+6bpQYVITrT62JHdELW7NZ+parks/8hM1vWQlgqOpal5U2NfRVAhzP6vFrhw4awnOqX5dIV//tJS97cAAtpBahn2Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz6PFl3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz6PFl3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DB5C433F1;
	Tue, 27 Feb 2024 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042217;
	bh=Ev3UCLkIfPA3WRGQMAJn9zPLxyWVJVWA8RGPYPZL6yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sz6PFl3zDmRzmVcCB9eZAGJob8eIllS6CpgBvGjoz1rrifiGJQcNpdkeobMOqhVg6
	 5tWS3xeomarVQZWUuFVNAVIqUTs6V8nyaSmxhM8IC6sP8NPql5VBKNWeQ9H/19SyJp
	 Lpa0fx21P3UnTqqgT1XeaYkvob+goI57bJ9Qu3yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 191/299] usb: roles: dont get/set_role() when usb_role_switch is unregistered
Date: Tue, 27 Feb 2024 14:25:02 +0100
Message-ID: <20240227131631.971898480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
@@ -23,6 +23,7 @@ struct usb_role_switch {
 	struct mutex lock; /* device lock*/
 	struct module *module; /* the module this device depends on */
 	enum usb_role role;
+	bool registered;
 
 	/* From descriptor */
 	struct device *usb2_port;
@@ -49,6 +50,9 @@ int usb_role_switch_set_role(struct usb_
 	if (IS_ERR_OR_NULL(sw))
 		return 0;
 
+	if (!sw->registered)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&sw->lock);
 
 	ret = sw->set(sw, role);
@@ -74,7 +78,7 @@ enum usb_role usb_role_switch_get_role(s
 {
 	enum usb_role role;
 
-	if (IS_ERR_OR_NULL(sw))
+	if (IS_ERR_OR_NULL(sw) || !sw->registered)
 		return USB_ROLE_NONE;
 
 	mutex_lock(&sw->lock);
@@ -357,6 +361,8 @@ usb_role_switch_register(struct device *
 		return ERR_PTR(ret);
 	}
 
+	sw->registered = true;
+
 	/* TODO: Symlinks for the host port and the device controller. */
 
 	return sw;
@@ -371,8 +377,10 @@ EXPORT_SYMBOL_GPL(usb_role_switch_regist
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
 


