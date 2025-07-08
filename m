Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAD2A1BA;
	Tue,  8 Jul 2025 16:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992157; cv=none; b=EsNXzVqEVAqEPgaVCKhDnL/kl3Aeo+Hc0uGj9/Lir3OeLZxKyTGt8IgoV7UtWNN0FMnfZeG7tjnftLVLEzpoqhCzyf+VkpwYQvrPrZRX0ACWatqPs5pWzpYT8dJ8wzIXuvYyRDoZ92zOovDYJz2nISCMXI55dECO4hzhorsimog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992157; c=relaxed/simple;
	bh=abbLUU+ZrBFvlpFHEjTZpM7zHnrU0sZCpZe0d0bbn3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZ7JEGuLfdnZm+oIs7mZWLZc4e0pDY+SH4SMXnE0plc1isbC2/emfQ5Q4it0Ej/dfoNNnfHD3OfCH4p/DK8f6+1rRbYQwVBPkwpKdWrvEpIXWLACz+gjc2a0dpEPAQGArO/LMxuZYl5LDfaDO5WnyseCXqjb/xmxsjDARclj2M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khpZzgS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khpZzgS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D06C4CEED;
	Tue,  8 Jul 2025 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992157;
	bh=abbLUU+ZrBFvlpFHEjTZpM7zHnrU0sZCpZe0d0bbn3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khpZzgS+UxD474ulcO7vXtKJWSQojigS6GscYjvHWMNrxba+0twct720JP9eCsEnw
	 ESx9zQythYnKniAqe0gwIvRXfHymH18Rwcq7My29g/UeOH8ZOYbj7B49hGOPT1QArG
	 WinbKuS1DQAfpAaQIC8Y2C/FPoAPgDebr5ZWa1pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>
Subject: [PATCH 6.1 76/81] platform/x86: think-lmi: Fix kobject cleanup
Date: Tue,  8 Jul 2025 18:24:08 +0200
Message-ID: <20250708162227.350455787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 9110056fe10b0519529bdbbac37311a5037ea0c2 upstream.

In tlmi_analyze(), allocated structs with an embedded kobject are freed
in error paths after the they were already initialized.

Fix this by first by avoiding the initialization of kobjects in
tlmi_analyze() and then by correctly cleaning them up in
tlmi_release_attr() using their kset's kobject list.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Fixes: 30e78435d3bf ("platform/x86: think-lmi: Split kobject_init() and kobject_add() calls")
Cc: stable@vger.kernel.org
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-2-ce4f81c9c481@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/think-lmi.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1208,19 +1208,22 @@ static struct kobj_attribute debug_cmd =
 /* ---- Initialisation --------------------------------------------------------- */
 static void tlmi_release_attr(void)
 {
+	struct kobject *pos, *n;
 	int i;
 
 	/* Attribute structures */
 	for (i = 0; i < TLMI_SETTINGS_COUNT; i++) {
 		if (tlmi_priv.setting[i]) {
 			sysfs_remove_group(&tlmi_priv.setting[i]->kobj, &tlmi_attr_group);
-			kobject_put(&tlmi_priv.setting[i]->kobj);
 		}
 	}
 	sysfs_remove_file(&tlmi_priv.attribute_kset->kobj, &pending_reboot.attr);
 	if (tlmi_priv.can_debug_cmd && debug_support)
 		sysfs_remove_file(&tlmi_priv.attribute_kset->kobj, &debug_cmd.attr);
 
+	list_for_each_entry_safe(pos, n, &tlmi_priv.attribute_kset->list, entry)
+		kobject_put(pos);
+
 	kset_unregister(tlmi_priv.attribute_kset);
 
 	/* Free up any saved signatures */
@@ -1229,19 +1232,17 @@ static void tlmi_release_attr(void)
 
 	/* Authentication structures */
 	sysfs_remove_group(&tlmi_priv.pwd_admin->kobj, &auth_attr_group);
-	kobject_put(&tlmi_priv.pwd_admin->kobj);
 	sysfs_remove_group(&tlmi_priv.pwd_power->kobj, &auth_attr_group);
-	kobject_put(&tlmi_priv.pwd_power->kobj);
 
 	if (tlmi_priv.opcode_support) {
 		sysfs_remove_group(&tlmi_priv.pwd_system->kobj, &auth_attr_group);
-		kobject_put(&tlmi_priv.pwd_system->kobj);
 		sysfs_remove_group(&tlmi_priv.pwd_hdd->kobj, &auth_attr_group);
-		kobject_put(&tlmi_priv.pwd_hdd->kobj);
 		sysfs_remove_group(&tlmi_priv.pwd_nvme->kobj, &auth_attr_group);
-		kobject_put(&tlmi_priv.pwd_nvme->kobj);
 	}
 
+	list_for_each_entry_safe(pos, n, &tlmi_priv.authentication_kset->list, entry)
+		kobject_put(pos);
+
 	kset_unregister(tlmi_priv.authentication_kset);
 }
 
@@ -1309,8 +1310,8 @@ static int tlmi_sysfs_init(void)
 
 		/* Build attribute */
 		tlmi_priv.setting[i]->kobj.kset = tlmi_priv.attribute_kset;
-		ret = kobject_add(&tlmi_priv.setting[i]->kobj, NULL,
-				  "%s", tlmi_priv.setting[i]->display_name);
+		ret = kobject_init_and_add(&tlmi_priv.setting[i]->kobj, &tlmi_attr_setting_ktype,
+					   NULL, "%s", tlmi_priv.setting[i]->display_name);
 		if (ret)
 			goto fail_create_attr;
 
@@ -1331,7 +1332,8 @@ static int tlmi_sysfs_init(void)
 
 	/* Create authentication entries */
 	tlmi_priv.pwd_admin->kobj.kset = tlmi_priv.authentication_kset;
-	ret = kobject_add(&tlmi_priv.pwd_admin->kobj, NULL, "%s", "Admin");
+	ret = kobject_init_and_add(&tlmi_priv.pwd_admin->kobj, &tlmi_pwd_setting_ktype,
+				   NULL, "%s", "Admin");
 	if (ret)
 		goto fail_create_attr;
 
@@ -1340,7 +1342,8 @@ static int tlmi_sysfs_init(void)
 		goto fail_create_attr;
 
 	tlmi_priv.pwd_power->kobj.kset = tlmi_priv.authentication_kset;
-	ret = kobject_add(&tlmi_priv.pwd_power->kobj, NULL, "%s", "Power-on");
+	ret = kobject_init_and_add(&tlmi_priv.pwd_power->kobj, &tlmi_pwd_setting_ktype,
+				   NULL, "%s", "Power-on");
 	if (ret)
 		goto fail_create_attr;
 
@@ -1350,7 +1353,8 @@ static int tlmi_sysfs_init(void)
 
 	if (tlmi_priv.opcode_support) {
 		tlmi_priv.pwd_system->kobj.kset = tlmi_priv.authentication_kset;
-		ret = kobject_add(&tlmi_priv.pwd_system->kobj, NULL, "%s", "System");
+		ret = kobject_init_and_add(&tlmi_priv.pwd_system->kobj, &tlmi_pwd_setting_ktype,
+					   NULL, "%s", "System");
 		if (ret)
 			goto fail_create_attr;
 
@@ -1359,7 +1363,8 @@ static int tlmi_sysfs_init(void)
 			goto fail_create_attr;
 
 		tlmi_priv.pwd_hdd->kobj.kset = tlmi_priv.authentication_kset;
-		ret = kobject_add(&tlmi_priv.pwd_hdd->kobj, NULL, "%s", "HDD");
+		ret = kobject_init_and_add(&tlmi_priv.pwd_hdd->kobj, &tlmi_pwd_setting_ktype,
+					   NULL, "%s", "HDD");
 		if (ret)
 			goto fail_create_attr;
 
@@ -1368,7 +1373,8 @@ static int tlmi_sysfs_init(void)
 			goto fail_create_attr;
 
 		tlmi_priv.pwd_nvme->kobj.kset = tlmi_priv.authentication_kset;
-		ret = kobject_add(&tlmi_priv.pwd_nvme->kobj, NULL, "%s", "NVMe");
+		ret = kobject_init_and_add(&tlmi_priv.pwd_nvme->kobj, &tlmi_pwd_setting_ktype,
+					   NULL, "%s", "NVMe");
 		if (ret)
 			goto fail_create_attr;
 
@@ -1406,8 +1412,6 @@ static struct tlmi_pwd_setting *tlmi_cre
 	new_pwd->maxlen = tlmi_priv.pwdcfg.core.max_length;
 	new_pwd->index = 0;
 
-	kobject_init(&new_pwd->kobj, &tlmi_pwd_setting_ktype);
-
 	return new_pwd;
 }
 
@@ -1512,7 +1516,6 @@ static int tlmi_analyze(void)
 		if (setting->possible_values)
 			strreplace(setting->possible_values, ',', ';');
 
-		kobject_init(&setting->kobj, &tlmi_attr_setting_ktype);
 		tlmi_priv.setting[i] = setting;
 		kfree(item);
 	}


