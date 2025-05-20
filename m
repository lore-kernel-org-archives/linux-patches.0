Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D276245032;
	Tue, 20 May 2025 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749270; cv=none; b=pCnT7O0g/8z6xp2mfVdTpLWlas2mCjLTseq+sqyohD3yep7tRIKhY1g/bpnj+tjAgn8SFsV+Mv1upfk2orNRSbmbfJ1EofeJrtZZ74+/SCiJdTgHwa+okVOPKzUZ6hG4UyGgV1RdfJVUqmDmQdxzmbwYKdHEy6gWqFZxyiHRxf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749270; c=relaxed/simple;
	bh=2aPYMYIbIwmL8Xqu7KoPJfKsGZGGA1RbFtPQ4nwoDXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvBzmEudDFQfHzD1k070NQAOxM4ah3fjkwcpRTYrf9huxd445zpaovvpYBTpKO9ZOUtwvXXHIAwH2c8LpEg0cHL4guE+5tcI+/bsfPmVEMgApCiyB7crhuYOTMT2p/NVxaA8wpOxh8ejfq4UMtSkpeg9NpJk98u2AucyhCXP7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Olb5YDQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Olb5YDQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138AAC4CEEB;
	Tue, 20 May 2025 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749269;
	bh=2aPYMYIbIwmL8Xqu7KoPJfKsGZGGA1RbFtPQ4nwoDXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Olb5YDQsJM0ZBF4qjjzEMjiCf9KsanrZ+tdpdu5GgZXwWq9yB6GQbt9Hndad08hGu
	 wxKx9t8LWilu1kBs0t/+d4RdUzf4RpXkccnyy32aJqv1xjo1cUU1VX60h/sj1qtAb7
	 RiQMhC5gIEj5Yjgk2wpk+zo4A++BE8JQMYLe7zKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 49/59] usb: typec: altmodes/displayport: create sysfs nodes as drivers default device attribute group
Date: Tue, 20 May 2025 15:50:40 +0200
Message-ID: <20250520125755.791580854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -521,22 +521,26 @@ static ssize_t pin_assignment_show(struc
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
 {
 	const struct typec_altmode *port = typec_altmode_get_partner(alt);
 	struct dp_altmode *dp;
-	int ret;
 
 	/* FIXME: Port can only be DFP_U. */
 
@@ -547,10 +551,6 @@ int dp_altmode_probe(struct typec_altmod
 	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
-	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
-	if (ret)
-		return ret;
-
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
@@ -576,7 +576,6 @@ void dp_altmode_remove(struct typec_altm
 {
 	struct dp_altmode *dp = typec_altmode_get_drvdata(alt);
 
-	sysfs_remove_group(&alt->dev.kobj, &dp_altmode_group);
 	cancel_work_sync(&dp->work);
 }
 EXPORT_SYMBOL_GPL(dp_altmode_remove);
@@ -594,6 +593,7 @@ static struct typec_altmode_driver dp_al
 	.driver = {
 		.name = "typec_displayport",
 		.owner = THIS_MODULE,
+		.dev_groups = displayport_groups,
 	},
 };
 module_typec_altmode_driver(dp_altmode_driver);


