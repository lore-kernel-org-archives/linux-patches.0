Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8861E1527B1;
	Tue, 17 Dec 2024 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455726; cv=none; b=Ailu3bk5V62s0+xkxLWms7VDKqQwnPhrSgbWnFYr+/vKAE6hrco4LfGNkMfMEXmGqn7UDg3AKBhewyN4XIIsSgKBz1yG4GFL7WomPd9HhKk0aQ1BxN0wBK3gY5ebfIGl9RJmtF0itfFhMjRW6CACXXc5sNQD7enYw+4oQIZGlRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455726; c=relaxed/simple;
	bh=+fN627a0NtWEk3vJhF62AghK2cQ0Q73RTuCVppaMNq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcwA2u4KPIkMA/DgBz4tUR4v2fLytkikJRCMeD7nt32vBwp+Zy+dcu2+1VhAh9/jmBYsfczzUpA10KNRxPikz3hK4988O4c1V94fFri0AUHzorHW9PraCWUYZWmFpCHAhUhnuSdm10hPXz5sNKLpq8YEaBCcLvDNBaTAJbZWcBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seX/z5lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seX/z5lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11910C4CED3;
	Tue, 17 Dec 2024 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455726;
	bh=+fN627a0NtWEk3vJhF62AghK2cQ0Q73RTuCVppaMNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seX/z5lrmLHALS0ooG1wezeuXXYsE2n/kkML1Bg3zZQsaIx4C+rjAU4KMGHusaQ4N
	 Qg5jWn8ycH+eHRL0ffpT3hRvlLKVudPtJKd93UTrlLpdmrgKS1J0JW2/OFVDkbp0s7
	 Q7XYmqaEMH2UyBtuTFcu7+DJiyTlvn1ECRcKkn/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 12/76] usb: typec: anx7411: fix fwnode_handle reference leak
Date: Tue, 17 Dec 2024 18:06:52 +0100
Message-ID: <20241217170526.760238484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 645d56e4cc74e953284809d096532c1955918a28 upstream.

An fwnode_handle and usb_role_switch are obtained with an incremented
refcount in anx7411_typec_port_probe(), however the refcounts are not
decremented in the error path. The fwnode_handle is also not decremented
in the .remove() function. Therefore, call fwnode_handle_put() and
usb_role_switch_put() accordingly.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20241121023429.962848-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |   47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1020,6 +1020,16 @@ static void anx7411_port_unregister_altm
 		}
 }
 
+static void anx7411_port_unregister(struct typec_params *typecp)
+{
+	fwnode_handle_put(typecp->caps.fwnode);
+	anx7411_port_unregister_altmodes(typecp->port_amode);
+	if (typecp->port)
+		typec_unregister_port(typecp->port);
+	if (typecp->role_sw)
+		usb_role_switch_put(typecp->role_sw);
+}
+
 static int anx7411_usb_mux_set(struct typec_mux_dev *mux,
 			       struct typec_mux_state *state)
 {
@@ -1153,34 +1163,34 @@ static int anx7411_typec_port_probe(stru
 	ret = fwnode_property_read_string(fwnode, "power-role", &buf);
 	if (ret) {
 		dev_err(dev, "power-role not found: %d\n", ret);
-		return ret;
+		goto put_fwnode;
 	}
 
 	ret = typec_find_port_power_role(buf);
 	if (ret < 0)
-		return ret;
+		goto put_fwnode;
 	cap->type = ret;
 
 	ret = fwnode_property_read_string(fwnode, "data-role", &buf);
 	if (ret) {
 		dev_err(dev, "data-role not found: %d\n", ret);
-		return ret;
+		goto put_fwnode;
 	}
 
 	ret = typec_find_port_data_role(buf);
 	if (ret < 0)
-		return ret;
+		goto put_fwnode;
 	cap->data = ret;
 
 	ret = fwnode_property_read_string(fwnode, "try-power-role", &buf);
 	if (ret) {
 		dev_err(dev, "try-power-role not found: %d\n", ret);
-		return ret;
+		goto put_fwnode;
 	}
 
 	ret = typec_find_power_role(buf);
 	if (ret < 0)
-		return ret;
+		goto put_fwnode;
 	cap->prefer_role = ret;
 
 	/* Get source pdos */
@@ -1192,7 +1202,7 @@ static int anx7411_typec_port_probe(stru
 						     typecp->src_pdo_nr);
 		if (ret < 0) {
 			dev_err(dev, "source cap validate failed: %d\n", ret);
-			return -EINVAL;
+			goto put_fwnode;
 		}
 
 		typecp->caps_flags |= HAS_SOURCE_CAP;
@@ -1206,7 +1216,7 @@ static int anx7411_typec_port_probe(stru
 						     typecp->sink_pdo_nr);
 		if (ret < 0) {
 			dev_err(dev, "sink cap validate failed: %d\n", ret);
-			return -EINVAL;
+			goto put_fwnode;
 		}
 
 		for (i = 0; i < typecp->sink_pdo_nr; i++) {
@@ -1250,13 +1260,21 @@ static int anx7411_typec_port_probe(stru
 		ret = PTR_ERR(ctx->typec.port);
 		ctx->typec.port = NULL;
 		dev_err(dev, "Failed to register type c port %d\n", ret);
-		return ret;
+		goto put_usb_role_switch;
 	}
 
 	typec_port_register_altmodes(ctx->typec.port, NULL, ctx,
 				     ctx->typec.port_amode,
 				     MAX_ALTMODE);
 	return 0;
+
+put_usb_role_switch:
+	if (ctx->typec.role_sw)
+		usb_role_switch_put(ctx->typec.role_sw);
+put_fwnode:
+	fwnode_handle_put(fwnode);
+
+	return ret;
 }
 
 static int anx7411_typec_check_connection(struct anx7411_data *ctx)
@@ -1528,8 +1546,7 @@ free_wq:
 	destroy_workqueue(plat->workqueue);
 
 free_typec_port:
-	typec_unregister_port(plat->typec.port);
-	anx7411_port_unregister_altmodes(plat->typec.port_amode);
+	anx7411_port_unregister(&plat->typec);
 
 free_typec_switch:
 	anx7411_unregister_switch(plat);
@@ -1554,17 +1571,11 @@ static void anx7411_i2c_remove(struct i2
 	if (plat->spi_client)
 		i2c_unregister_device(plat->spi_client);
 
-	if (plat->typec.role_sw)
-		usb_role_switch_put(plat->typec.role_sw);
-
 	anx7411_unregister_mux(plat);
 
 	anx7411_unregister_switch(plat);
 
-	if (plat->typec.port)
-		typec_unregister_port(plat->typec.port);
-
-	anx7411_port_unregister_altmodes(plat->typec.port_amode);
+	anx7411_port_unregister(&plat->typec);
 }
 
 static const struct i2c_device_id anx7411_id[] = {


