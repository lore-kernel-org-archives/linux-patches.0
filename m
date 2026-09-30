Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C708415B66;
	Wed, 30 Sep 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789750; cv=none; b=b5YkgMa0/aXv7N0oCsVvAzOZy68CMlVeHORI5jEfDte6dEkyy6rw/GCOxp/lx6eQqjAsh/ys8yL9+MXjKff/1VTRmeuwIm3Hw4S+bmKa9gtz+SveRS0XYFbAaba5x8XDEEsuHR+sBQxoi9sIYYUxzTBJqIlrTFzORCmYOCd+YfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789750; c=relaxed/simple;
	bh=yVr1xRNPZS/mpMX4TFuoZ0BOUtAv8lNa2XfLXPFcGT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7Zmm7JAmX31M3nnJf9dRM+mCDqTK/u1WYwILYFgVH2jTutbw5vu0UO1SRLcngVTpsx+YTMdREZ1aqxWMX3C3hRqabXn+sxh5a83Cx+v6n4ZxLE8CPt5AGxzNmEnX6JJyesUjE3fWnV599sc6AxBMcGqeSjRZH/moTJgHEgZ9+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi+fzDwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi+fzDwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54081F000FF;
	Wed, 30 Sep 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789749;
	bh=3ht1aAL/or5FwtGMNbBFM7KkQ52P4IHdg62qdewPvRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi+fzDwfz/0gN5Bng33I41/yqPmyVgWSrclGg2pRmGE4WRzHZySk37If1r9hE0pgZ
	 /X+oSch6uK63dvUvpJ7Sc1GiY3tYqyNs0UjKGxtoV1mh8wcbR/FOiZcI3I5UFDz4Jd
	 t+tTTWD9FTN0gOsVU1sZBkHET8PjBE8pgng2tdgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 585/877] platform/x86: think-lmi: improve check if BIOS account security enabled
Date: Wed, 30 Sep 2026 17:24:56 +0200
Message-ID: <20260930152427.271219892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit b39e8ece931a4b4f64cdf9e75fffd6e82828e471 ]

Improve determination of whether authentication account is enabled by
checking if either password or certificate is enabled.

Renamed valid to pwd_enabled for better readability.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20241024195536.6992-1-mpearson-lenovo@squebb.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 4f3183f5ae9b ("platform/x86: think-lmi: Fix certificate thumbprint sysfs output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/think-lmi.c |   26 +++++++++++++-------------
 drivers/platform/x86/think-lmi.h |    2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -390,7 +390,7 @@ static ssize_t is_enabled_show(struct ko
 {
 	struct tlmi_pwd_setting *setting = to_tlmi_pwd_setting(kobj);
 
-	return sysfs_emit(buf, "%d\n", setting->valid);
+	return sysfs_emit(buf, "%d\n", setting->pwd_enabled || setting->cert_installed);
 }
 
 static struct kobj_attribute auth_is_pass_set = __ATTR_RO(is_enabled);
@@ -467,7 +467,7 @@ static ssize_t new_password_store(struct
 		if (ret)
 			goto out;
 
-		if (tlmi_priv.pwd_admin->valid) {
+		if (tlmi_priv.pwd_admin->pwd_enabled) {
 			ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
 					tlmi_priv.pwd_admin->password);
 			if (ret)
@@ -775,7 +775,7 @@ static ssize_t certificate_store(struct
 				new_cert, setting->signature);
 	} else {
 		/* This is a fresh install */
-		if (!setting->valid || !setting->password[0]) {
+		if (!setting->pwd_enabled || !setting->password[0]) {
 			kfree(new_cert);
 			return -EACCES;
 		}
@@ -1018,7 +1018,7 @@ static ssize_t current_value_store(struc
 		 * Workstation's require the opcode to be set before changing the
 		 * attribute.
 		 */
-		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+		if (tlmi_priv.pwd_admin->pwd_enabled && tlmi_priv.pwd_admin->password[0]) {
 			ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
 						  tlmi_priv.pwd_admin->password);
 			if (ret)
@@ -1041,7 +1041,7 @@ static ssize_t current_value_store(struc
 		else
 			ret = tlmi_save_bios_settings("");
 	} else { /* old non-opcode based authentication method (deprecated) */
-		if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+		if (tlmi_priv.pwd_admin->pwd_enabled && tlmi_priv.pwd_admin->password[0]) {
 			auth_str = kasprintf(GFP_KERNEL, "%s,%s,%s;",
 					tlmi_priv.pwd_admin->password,
 					encoding_options[tlmi_priv.pwd_admin->encoding],
@@ -1217,7 +1217,7 @@ static ssize_t save_settings_store(struc
 			if (ret)
 				goto out;
 		} else if (tlmi_priv.opcode_support) {
-			if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+			if (tlmi_priv.pwd_admin->pwd_enabled && tlmi_priv.pwd_admin->password[0]) {
 				ret = tlmi_opcode_setting("WmiOpcodePasswordAdmin",
 							  tlmi_priv.pwd_admin->password);
 				if (ret)
@@ -1225,7 +1225,7 @@ static ssize_t save_settings_store(struc
 			}
 			ret = tlmi_save_bios_settings("");
 		} else { /* old non-opcode based authentication method (deprecated) */
-			if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+			if (tlmi_priv.pwd_admin->pwd_enabled && tlmi_priv.pwd_admin->password[0]) {
 				auth_str = kasprintf(GFP_KERNEL, "%s,%s,%s;",
 						     tlmi_priv.pwd_admin->password,
 						     encoding_options[tlmi_priv.pwd_admin->encoding],
@@ -1275,7 +1275,7 @@ static ssize_t debug_cmd_store(struct ko
 	if (!new_setting)
 		return -ENOMEM;
 
-	if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
+	if (tlmi_priv.pwd_admin->pwd_enabled && tlmi_priv.pwd_admin->password[0]) {
 		auth_str = kasprintf(GFP_KERNEL, "%s,%s,%s;",
 				tlmi_priv.pwd_admin->password,
 				encoding_options[tlmi_priv.pwd_admin->encoding],
@@ -1602,14 +1602,14 @@ static int tlmi_analyze(void)
 		goto fail_clear_attr;
 
 	if (tlmi_priv.pwdcfg.core.password_state & TLMI_PAP_PWD)
-		tlmi_priv.pwd_admin->valid = true;
+		tlmi_priv.pwd_admin->pwd_enabled = true;
 
 	tlmi_priv.pwd_power = tlmi_create_auth("pop", "power-on");
 	if (!tlmi_priv.pwd_power)
 		goto fail_clear_attr;
 
 	if (tlmi_priv.pwdcfg.core.password_state & TLMI_POP_PWD)
-		tlmi_priv.pwd_power->valid = true;
+		tlmi_priv.pwd_power->pwd_enabled = true;
 
 	if (tlmi_priv.opcode_support) {
 		tlmi_priv.pwd_system = tlmi_create_auth("smp", "system");
@@ -1617,7 +1617,7 @@ static int tlmi_analyze(void)
 			goto fail_clear_attr;
 
 		if (tlmi_priv.pwdcfg.core.password_state & TLMI_SMP_PWD)
-			tlmi_priv.pwd_system->valid = true;
+			tlmi_priv.pwd_system->pwd_enabled = true;
 
 		tlmi_priv.pwd_hdd = tlmi_create_auth("hdd", "hdd");
 		if (!tlmi_priv.pwd_hdd)
@@ -1635,7 +1635,7 @@ static int tlmi_analyze(void)
 			/* Check if PWD is configured and set index to first drive found */
 			if (tlmi_priv.pwdcfg.ext.hdd_user_password ||
 					tlmi_priv.pwdcfg.ext.hdd_master_password) {
-				tlmi_priv.pwd_hdd->valid = true;
+				tlmi_priv.pwd_hdd->pwd_enabled = true;
 				if (tlmi_priv.pwdcfg.ext.hdd_master_password)
 					tlmi_priv.pwd_hdd->index =
 						ffs(tlmi_priv.pwdcfg.ext.hdd_master_password) - 1;
@@ -1645,7 +1645,7 @@ static int tlmi_analyze(void)
 			}
 			if (tlmi_priv.pwdcfg.ext.nvme_user_password ||
 					tlmi_priv.pwdcfg.ext.nvme_master_password) {
-				tlmi_priv.pwd_nvme->valid = true;
+				tlmi_priv.pwd_nvme->pwd_enabled = true;
 				if (tlmi_priv.pwdcfg.ext.nvme_master_password)
 					tlmi_priv.pwd_nvme->index =
 						ffs(tlmi_priv.pwdcfg.ext.nvme_master_password) - 1;
--- a/drivers/platform/x86/think-lmi.h
+++ b/drivers/platform/x86/think-lmi.h
@@ -65,7 +65,7 @@ struct tlmi_pwdcfg {
 /* password setting details */
 struct tlmi_pwd_setting {
 	struct kobject kobj;
-	bool valid;
+	bool pwd_enabled;
 	char password[TLMI_PWD_BUFSIZE];
 	const char *pwd_type;
 	const char *role;


