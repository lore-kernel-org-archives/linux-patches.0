Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141213F8F4;
	Mon,  1 Apr 2024 16:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988796; cv=none; b=SWhooqGfNFT/rNOl7fPKu7UXSqv4HkKwjWYaDcr8fhQFtcGyfRPLGPV3+QvPaah6UKI6QpO4yWvL0RjPLNsUQcz/4nM52990sHH4mj0LBhPlICvq6GlhWUc157ubYg1By9zs64M40wZN3/ltzcrbDLhVPBJ1lsuD+AuotL7KQI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988796; c=relaxed/simple;
	bh=ACZzbXsQvnxXVGmh/QoaVbNMcRLdfaHHt2QiQB4Yhz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qydq4NT3lzEuoeqbouej+OkIr8PjMnbQrvFwEm9+sjaJCxlnqNeNXB4IIZkW+CmXp8x+BoqAS096W1yU+sxFYsdnPsOqSBKzG9sevksVXi8dLQA6PecTK4ac8JG7Qal0nMU7Ng8i16NEa2dnHTaGvIIDH19CRIEb4CBKkhFy038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxPPnBeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxPPnBeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75569C433C7;
	Mon,  1 Apr 2024 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988795;
	bh=ACZzbXsQvnxXVGmh/QoaVbNMcRLdfaHHt2QiQB4Yhz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxPPnBeLRMZMw9QH96hAXS5XhCN1ucUiO4PsKIqCuWdJkMtCYnbapiYN+fW5Eh+jb
	 DRG+1ev4kU1Kr66iuYzfcFIHusA6R95C3VTxF7DLzJHpMRa+4oDYXmwP+rKuxGt03k
	 yrLYfXvNjmYG71A9IeSfL4y6OQUBHNxQVYklAO08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>
Subject: [PATCH 6.7 262/432] usb: typec: altmodes/displayport: create sysfs nodes as drivers default device attribute group
Date: Mon,  1 Apr 2024 17:44:09 +0200
Message-ID: <20240401152600.966716117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit 165376f6b23e9a779850e750fb2eb06622e5a531 upstream.

The DisplayPort driver's sysfs nodes may be present to the userspace before
typec_altmode_set_drvdata() completes in dp_altmode_probe. This means that
a sysfs read can trigger a NULL pointer error by deferencing dp->hpd in
hpd_show or dp->lock in pin_assignment_show, as dev_get_drvdata() returns
NULL in those cases.

Remove manual sysfs node creation in favor of adding attribute group as
default for devices bound to the driver. The ATTRIBUTE_GROUPS() macro is
not used here otherwise the path to the sysfs nodes is no longer compliant
with the ABI.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Link: https://lore.kernel.org/r/20240229001101.3889432-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -559,16 +559,21 @@ static ssize_t hpd_show(struct device *d
 }
 static DEVICE_ATTR_RO(hpd);
 
-static struct attribute *dp_altmode_attrs[] = {
+static struct attribute *displayport_attrs[] = {
 	&dev_attr_configuration.attr,
 	&dev_attr_pin_assignment.attr,
 	&dev_attr_hpd.attr,
 	NULL
 };
 
-static const struct attribute_group dp_altmode_group = {
+static const struct attribute_group displayport_group = {
 	.name = "displayport",
-	.attrs = dp_altmode_attrs,
+	.attrs = displayport_attrs,
+};
+
+static const struct attribute_group *displayport_groups[] = {
+	&displayport_group,
+	NULL,
 };
 
 int dp_altmode_probe(struct typec_altmode *alt)
@@ -576,7 +581,6 @@ int dp_altmode_probe(struct typec_altmod
 	const struct typec_altmode *port = typec_altmode_get_partner(alt);
 	struct fwnode_handle *fwnode;
 	struct dp_altmode *dp;
-	int ret;
 
 	/* FIXME: Port can only be DFP_U. */
 
@@ -587,10 +591,6 @@ int dp_altmode_probe(struct typec_altmod
 	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
-	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
-	if (ret)
-		return ret;
-
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
@@ -624,7 +624,6 @@ void dp_altmode_remove(struct typec_altm
 {
 	struct dp_altmode *dp = typec_altmode_get_drvdata(alt);
 
-	sysfs_remove_group(&alt->dev.kobj, &dp_altmode_group);
 	cancel_work_sync(&dp->work);
 
 	if (dp->connector_fwnode) {
@@ -649,6 +648,7 @@ static struct typec_altmode_driver dp_al
 	.driver = {
 		.name = "typec_displayport",
 		.owner = THIS_MODULE,
+		.dev_groups = displayport_groups,
 	},
 };
 module_typec_altmode_driver(dp_altmode_driver);


