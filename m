Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E68F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88176C433C7;
	Sun, 16 Jul 2023 20:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538506;
	bh=wO2sMeKKYgErAO1sPZjBqE0HyUSDdamvzSjgu/qei2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xB4L63+Wo0GnhWqxw3rgjWhoutg2fVRRmS9PCPtxrFiA+2TbHJSxzfVh6a//fFAi3
	 AvdEoRDn7ZXkrr5Rffi2rOxHPay9TRAjuFYbhHNe9KZM2x6bcojtwETbkzG0eOUH3g
	 wtTm97SKy+QyFmsNvb8ZR50H4L2S6PBiedPkZ7OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 458/800] platform/x86: think-lmi: mutex protection around multiple WMI calls
Date: Sun, 16 Jul 2023 21:45:11 +0200
Message-ID: <20230716194959.720918399@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit c41e0121a1221894a1a9c4666156db9e1def4d6c ]

When an attribute is being changed if the Admin account is enabled, or if
a password is being updated then multiple WMI calls are needed.
Add mutex protection to ensure no race conditions are introduced.

Fixes: b49f72e7f96d ("platform/x86: think-lmi: Certificate authentication support")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230601200552.4396-1-mpearson-lenovo@squebb.ca
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 1138f770149d9..6cf77bc26b05b 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -14,6 +14,7 @@
 #include <linux/acpi.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/dmi.h>
@@ -195,6 +196,7 @@ static const char * const level_options[] = {
 };
 static struct think_lmi tlmi_priv;
 static struct class *fw_attr_class;
+static DEFINE_MUTEX(tlmi_mutex);
 
 /* ------ Utility functions ------------*/
 /* Strip out CR if one is present */
@@ -437,6 +439,9 @@ static ssize_t new_password_store(struct kobject *kobj,
 	/* Strip out CR if one is present, setting password won't work if it is present */
 	strip_cr(new_pwd);
 
+	/* Use lock in case multiple WMI operations needed */
+	mutex_lock(&tlmi_mutex);
+
 	pwdlen = strlen(new_pwd);
 	/* pwdlen == 0 is allowed to clear the password */
 	if (pwdlen && ((pwdlen < setting->minlen) || (pwdlen > setting->maxlen))) {
@@ -493,6 +498,7 @@ static ssize_t new_password_store(struct kobject *kobj,
 		kfree(auth_str);
 	}
 out:
+	mutex_unlock(&tlmi_mutex);
 	kfree(new_pwd);
 	return ret ?: count;
 }
@@ -981,6 +987,9 @@ static ssize_t current_value_store(struct kobject *kobj,
 	/* Strip out CR if one is present */
 	strip_cr(new_setting);
 
+	/* Use lock in case multiple WMI operations needed */
+	mutex_lock(&tlmi_mutex);
+
 	/* Check if certificate authentication is enabled and active */
 	if (tlmi_priv.certificate_support && tlmi_priv.pwd_admin->cert_installed) {
 		if (!tlmi_priv.pwd_admin->signature || !tlmi_priv.pwd_admin->save_signature) {
@@ -1039,6 +1048,7 @@ static ssize_t current_value_store(struct kobject *kobj,
 		kobject_uevent(&tlmi_priv.class_dev->kobj, KOBJ_CHANGE);
 	}
 out:
+	mutex_unlock(&tlmi_mutex);
 	kfree(auth_str);
 	kfree(set_str);
 	kfree(new_setting);
-- 
2.39.2



