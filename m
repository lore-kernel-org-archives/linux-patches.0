Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713542F0C7F;
	Fri,  9 Jan 2026 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960819; cv=none; b=HxunrlpyUMhhh7c0O0blBrLmKVW4u5Bz3HmmnE0+zcrq4vha9Cfv11u+fJ3HjZyTZggRTefOT3EDsir7JVXnxNLVI+cdlMk3AarbxMIP19pFNo87zncR7sqWGjn+O914X9eA4raIaOh1LWS4rkjjHbq1efDTVOGgssv9kKLTHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960819; c=relaxed/simple;
	bh=kxd+4t7Hm8CoMhwJeIFDQZrFYP4kL/WvM0l/2jQxkCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FEtUeXXd7pW/nNV2uaIj636c7Zu5BYqF6czZiFHGu4ftt58R7K3zdKipUimo7F8Ndh0mXKFrk2o8hF+eRZB6/uZVjnCZYbeIeXTG0ew43z8j36PDVHQ4t8QJDOqb/4wRWrR7BLwPDW7eAvqABkeMq0ZhzcIGtYGAicmXICmWN6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej9cWcQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej9cWcQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED4CC4CEF1;
	Fri,  9 Jan 2026 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960819;
	bh=kxd+4t7Hm8CoMhwJeIFDQZrFYP4kL/WvM0l/2jQxkCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej9cWcQFgIHu9JRhgMmzBQNG7qvB/3IwwHswcgHIcQQbXSdV6emo2kM6HYOJcq5ZW
	 5FBzV+5XLOQ2fpXa5AXisJ7pke00GiiWA59XCFvkmnK0hq37pr6Ax4/Uw2bqsH1l3o
	 EGCagwMMVPoGHeN67L6IKmtHtPMHUiKWReIFC8vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6.6 494/737] platform/x86: intel: chtwc_int33fe: dont dereference swnode args
Date: Fri,  9 Jan 2026 12:40:33 +0100
Message-ID: <20260109112152.574849102@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 527250cd9092461f1beac3e4180a4481bffa01b5 upstream.

Members of struct software_node_ref_args should not be dereferenced
directly but set using the provided macros. Commit d7cdbbc93c56
("software node: allow referencing firmware nodes") changed the name of
the software node member and caused a build failure. Remove all direct
dereferences of the ref struct as a fix.

However, this driver also seems to abuse the software node interface by
waiting for a node with an arbitrary name "intel-xhci-usb-sw" to appear
in the system before setting up the reference for the I2C device, while
the actual software node already exists in the intel-xhci-usb-role-switch
module and should be used to set up a static reference. Add a FIXME for
a future improvement.

Fixes: d7cdbbc93c56 ("software node: allow referencing firmware nodes")
Fixes: 53c24c2932e5 ("platform/x86: intel_cht_int33fe: use inline reference properties")
Cc: stable@vger.kernel.org
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20251121111534.7cdbfe5c@canb.auug.org.au/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/chtwc_int33fe.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/intel/chtwc_int33fe.c
+++ b/drivers/platform/x86/intel/chtwc_int33fe.c
@@ -77,7 +77,7 @@ static const struct software_node max170
  * software node.
  */
 static struct software_node_ref_args fusb302_mux_refs[] = {
-	{ .node = NULL },
+	SOFTWARE_NODE_REFERENCE(NULL),
 };
 
 static const struct property_entry fusb302_properties[] = {
@@ -190,11 +190,6 @@ static void cht_int33fe_remove_nodes(str
 {
 	software_node_unregister_node_group(node_group);
 
-	if (fusb302_mux_refs[0].node) {
-		fwnode_handle_put(software_node_fwnode(fusb302_mux_refs[0].node));
-		fusb302_mux_refs[0].node = NULL;
-	}
-
 	if (data->dp) {
 		data->dp->secondary = NULL;
 		fwnode_handle_put(data->dp);
@@ -202,7 +197,15 @@ static void cht_int33fe_remove_nodes(str
 	}
 }
 
-static int cht_int33fe_add_nodes(struct cht_int33fe_data *data)
+static void cht_int33fe_put_swnode(void *data)
+{
+	struct fwnode_handle *fwnode = data;
+
+	fwnode_handle_put(fwnode);
+	fusb302_mux_refs[0] = SOFTWARE_NODE_REFERENCE(NULL);
+}
+
+static int cht_int33fe_add_nodes(struct device *dev, struct cht_int33fe_data *data)
 {
 	const struct software_node *mux_ref_node;
 	int ret;
@@ -212,17 +215,25 @@ static int cht_int33fe_add_nodes(struct
 	 * until the mux driver has created software node for the mux device.
 	 * It means we depend on the mux driver. This function will return
 	 * -EPROBE_DEFER until the mux device is registered.
+	 *
+	 * FIXME: the relevant software node exists in intel-xhci-usb-role-switch
+	 * and - if exported - could be used to set up a static reference.
 	 */
 	mux_ref_node = software_node_find_by_name(NULL, "intel-xhci-usb-sw");
 	if (!mux_ref_node)
 		return -EPROBE_DEFER;
 
+	ret = devm_add_action_or_reset(dev, cht_int33fe_put_swnode,
+				       software_node_fwnode(mux_ref_node));
+	if (ret)
+		return ret;
+
 	/*
 	 * Update node used in "usb-role-switch" property. Note that we
 	 * rely on software_node_register_node_group() to use the original
 	 * instance of properties instead of copying them.
 	 */
-	fusb302_mux_refs[0].node = mux_ref_node;
+	fusb302_mux_refs[0] = SOFTWARE_NODE_REFERENCE(mux_ref_node);
 
 	ret = software_node_register_node_group(node_group);
 	if (ret)
@@ -345,7 +356,7 @@ static int cht_int33fe_typec_probe(struc
 		return fusb302_irq;
 	}
 
-	ret = cht_int33fe_add_nodes(data);
+	ret = cht_int33fe_add_nodes(dev, data);
 	if (ret)
 		return ret;
 


