Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213E2E889C;
	Tue, 15 Jul 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586200; cv=none; b=MBqIVpJ+QGXD7UUl5ffVPXvbwQDbgaFTTHnsQEJLEwST3IdTJgUE71+KCQO3Olv7BuqY1Wd55Dr+1yrCAP9JnJz84Jft3A5/iqKXNMuCWJXZzgPfI++RovvUQGXubpcvqWBc4PC0qNsTUTmYw4GkomrXmzRSfMVpIcvDPRwzKfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586200; c=relaxed/simple;
	bh=z6ngKh2GItpMosxdnUfC7m3GnQrHmIKChS/BafY8Qtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efHbRp7EVh1pDOlSPwzzscNentmUGGCRNaH+ePuiN1u6AyZyjFezLm/Gtp5n5smg3yiJpWqTCEgakvJps30QOCTGUK5F3f8B+lIM6mJkCipPS+nKbvJrdUCzWRwROTH/A1FfDDaGr4JZHTFXh5YdMSpF5v0+mCUanoKnPLqRcHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhtshD+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhtshD+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA64AC4CEF1;
	Tue, 15 Jul 2025 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586200;
	bh=z6ngKh2GItpMosxdnUfC7m3GnQrHmIKChS/BafY8Qtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhtshD+IQNbXnC1aKd+7udIfhpsimtDovhBWlgJLbzoCob8Vzh0LLaI7uXqgbqWdR
	 QYTqK0VPtqi+v12hZh5uQ/9Bqs6YMl/Q8usXHZDa4+kIGsfc2e0Vid0QsiV1jnmfWV
	 Sb5+7/f7vgUjr0dt3ljxv8RkU15Hhv51ZzmLJbqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/77] platform/x86: think-lmi: Fix sysfs group cleanup
Date: Tue, 15 Jul 2025 15:13:52 +0200
Message-ID: <20250715130753.855799519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]

Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
when they were not even created.

Fix this by letting the kobject core manage these groups through their
kobj_type's defult_groups.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 35 +++++++++-----------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 36ff64a7b6847..cc46aa5f1da2c 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -491,6 +491,7 @@ static struct attribute *auth_attrs[] = {
 static const struct attribute_group auth_attr_group = {
 	.attrs = auth_attrs,
 };
+__ATTRIBUTE_GROUPS(auth_attr);
 
 /* ---- Attributes sysfs --------------------------------------------------------- */
 static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -643,6 +644,7 @@ static const struct attribute_group tlmi_attr_group = {
 	.is_visible = attr_is_visible,
 	.attrs = tlmi_attrs,
 };
+__ATTRIBUTE_GROUPS(tlmi_attr);
 
 static ssize_t tlmi_attr_show(struct kobject *kobj, struct attribute *attr,
 				    char *buf)
@@ -688,12 +690,14 @@ static void tlmi_pwd_setting_release(struct kobject *kobj)
 
 static struct kobj_type tlmi_attr_setting_ktype = {
 	.release        = &tlmi_attr_setting_release,
-	.sysfs_ops	= &tlmi_kobj_sysfs_ops,
+	.sysfs_ops	= &kobj_sysfs_ops,
+	.default_groups = tlmi_attr_groups,
 };
 
 static struct kobj_type tlmi_pwd_setting_ktype = {
 	.release        = &tlmi_pwd_setting_release,
-	.sysfs_ops	= &tlmi_kobj_sysfs_ops,
+	.sysfs_ops	= &kobj_sysfs_ops,
+	.default_groups = auth_attr_groups,
 };
 
 static ssize_t pending_reboot_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -765,25 +769,18 @@ static struct kobj_attribute debug_cmd = __ATTR_WO(debug_cmd);
 /* ---- Initialisation --------------------------------------------------------- */
 static void tlmi_release_attr(void)
 {
-	int i;
+	struct kobject *pos, *n;
 
 	/* Attribute structures */
-	for (i = 0; i < TLMI_SETTINGS_COUNT; i++) {
-		if (tlmi_priv.setting[i]) {
-			sysfs_remove_group(&tlmi_priv.setting[i]->kobj, &tlmi_attr_group);
-			kobject_put(&tlmi_priv.setting[i]->kobj);
-		}
-	}
 	sysfs_remove_file(&tlmi_priv.attribute_kset->kobj, &pending_reboot.attr);
 	if (tlmi_priv.can_debug_cmd && debug_support)
 		sysfs_remove_file(&tlmi_priv.attribute_kset->kobj, &debug_cmd.attr);
 	kset_unregister(tlmi_priv.attribute_kset);
 
 	/* Authentication structures */
-	sysfs_remove_group(&tlmi_priv.pwd_admin->kobj, &auth_attr_group);
-	kobject_put(&tlmi_priv.pwd_admin->kobj);
-	sysfs_remove_group(&tlmi_priv.pwd_power->kobj, &auth_attr_group);
-	kobject_put(&tlmi_priv.pwd_power->kobj);
+	list_for_each_entry_safe(pos, n, &tlmi_priv.authentication_kset->list, entry)
+		kobject_put(pos);
+
 	kset_unregister(tlmi_priv.authentication_kset);
 }
 
@@ -855,10 +852,6 @@ static int tlmi_sysfs_init(void)
 				  "%s", tlmi_priv.setting[i]->display_name);
 		if (ret)
 			goto fail_create_attr;
-
-		ret = sysfs_create_group(&tlmi_priv.setting[i]->kobj, &tlmi_attr_group);
-		if (ret)
-			goto fail_create_attr;
 	}
 
 	ret = sysfs_create_file(&tlmi_priv.attribute_kset->kobj, &pending_reboot.attr);
@@ -876,19 +869,11 @@ static int tlmi_sysfs_init(void)
 	if (ret)
 		goto fail_create_attr;
 
-	ret = sysfs_create_group(&tlmi_priv.pwd_admin->kobj, &auth_attr_group);
-	if (ret)
-		goto fail_create_attr;
-
 	tlmi_priv.pwd_power->kobj.kset = tlmi_priv.authentication_kset;
 	ret = kobject_add(&tlmi_priv.pwd_power->kobj, NULL, "%s", "System");
 	if (ret)
 		goto fail_create_attr;
 
-	ret = sysfs_create_group(&tlmi_priv.pwd_power->kobj, &auth_attr_group);
-	if (ret)
-		goto fail_create_attr;
-
 	return ret;
 
 fail_create_attr:
-- 
2.39.5



