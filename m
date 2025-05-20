Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201BDDA9;
	Tue, 20 May 2025 13:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749534; cv=none; b=QnKsg68Cv8H6vj7L8eDsIBJVi0AOwazehiOMFFY0ecfvw4U7tzQzTwO9g4C8ORYwonA4a7L9FIWtlmKuItoqKCgkBJRRHZjFytM4dbhVQTxAh9Zf5LvE5VV5nlVP6GrpYDGyFAd7qy/uB/0Ys8Q8FiFDxpUOp9O+GQKFH6tewAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749534; c=relaxed/simple;
	bh=5TPTbbm2+hS8DCvhZoe1uJW9BiI39xYlHEHkG4JGyG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciW8xel6zU5hC/1XEV+OurqivMq2WRl0srOi/Zlf+3/3oyX5i8y8mjrUR70LVu/y1vAa6jtJfrZ3BqNXWSB34bdj6qdrLq9LqlIXZl8OkyS7qn8nrntW6C7ONfizyeM8DCoqpUAh9nLvtRzCrTrDT7qux5esHHg41BO6nwOHazI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlgqF+Mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlgqF+Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9E4C4CEE9;
	Tue, 20 May 2025 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749534;
	bh=5TPTbbm2+hS8DCvhZoe1uJW9BiI39xYlHEHkG4JGyG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlgqF+MgRYnJAVkMYQSrDKnBWUirnoAZK1q91bzd2rWAOK9LTzmPtJJ5MI04bgMRZ
	 fLO/3BZfuDGK6BelZc9OKYBZqVHFhh1zO/MDWPbFFdAD/VgwLFSJrOCZ1TGAB8C7rD
	 nZxY6qbYi6JRpoWNJP9EYkEumaRSFPGWJ4gses/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 76/97] usb: typec: altmodes/displayport: create sysfs nodes as drivers default device attribute group
Date: Tue, 20 May 2025 15:50:41 +0200
Message-ID: <20250520125803.625160991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
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
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -543,15 +543,20 @@ static ssize_t pin_assignment_show(struc
 }
 static DEVICE_ATTR_RW(pin_assignment);
 
-static struct attribute *dp_altmode_attrs[] = {
+static struct attribute *displayport_attrs[] = {
 	&dev_attr_configuration.attr,
 	&dev_attr_pin_assignment.attr,
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
@@ -559,7 +564,6 @@ int dp_altmode_probe(struct typec_altmod
 	const struct typec_altmode *port = typec_altmode_get_partner(alt);
 	struct fwnode_handle *fwnode;
 	struct dp_altmode *dp;
-	int ret;
 
 	/* FIXME: Port can only be DFP_U. */
 
@@ -570,10 +574,6 @@ int dp_altmode_probe(struct typec_altmod
 	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
-	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
-	if (ret)
-		return ret;
-
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
@@ -604,7 +604,6 @@ void dp_altmode_remove(struct typec_altm
 {
 	struct dp_altmode *dp = typec_altmode_get_drvdata(alt);
 
-	sysfs_remove_group(&alt->dev.kobj, &dp_altmode_group);
 	cancel_work_sync(&dp->work);
 
 	if (dp->connector_fwnode) {
@@ -629,6 +628,7 @@ static struct typec_altmode_driver dp_al
 	.driver = {
 		.name = "typec_displayport",
 		.owner = THIS_MODULE,
+		.dev_groups = displayport_groups,
 	},
 };
 module_typec_altmode_driver(dp_altmode_driver);


