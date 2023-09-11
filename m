Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C21D11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B755C433C7;
	Mon, 11 Sep 2023 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444033;
	bh=OOYRjZXQug16bQQGEUKiZUmf+v+vywx4nqLVEZ2oHHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjGTWoDkvrx9i7Xt5r5gbRIXk9FxCLoot8cAPkdCUuhx2pjbLgsgHRIxpmYiUSjvE
	 gaMqw/7bL8mlnN3ev4MsK4AEJVVAc7JsG6EAmRbkFeoaGN9hJ6c86jpA26+jHay50N
	 Bd5cjJvv1Cb5RXCg3A66uQU9vREj0MwZhDwEBbrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 548/737] platform/x86: dell-sysman: Fix reference leak
Date: Mon, 11 Sep 2023 15:46:47 +0200
Message-ID: <20230911134705.867524090@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 7295a996fdab7bf83dc3d4078fa8b139b8e0a1bf ]

If a duplicate attribute is found using kset_find_obj(),
a reference to that attribute is returned. This means
that we need to dispose it accordingly. Use kobject_put()
to dispose the duplicate attribute in such a case.

Compile-tested only.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230805053610.7106-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index 0285b47d99d13..1dd5aa37ecc8b 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -396,6 +396,7 @@ static int init_bios_attributes(int attr_type, const char *guid)
 	struct kobject *attr_name_kobj; //individual attribute names
 	union acpi_object *obj = NULL;
 	union acpi_object *elements;
+	struct kobject *duplicate;
 	struct kset *tmp_set;
 	int min_elements;
 
@@ -454,9 +455,11 @@ static int init_bios_attributes(int attr_type, const char *guid)
 		else
 			tmp_set = wmi_priv.main_dir_kset;
 
-		if (kset_find_obj(tmp_set, elements[ATTR_NAME].string.pointer)) {
-			pr_debug("duplicate attribute name found - %s\n",
-				elements[ATTR_NAME].string.pointer);
+		duplicate = kset_find_obj(tmp_set, elements[ATTR_NAME].string.pointer);
+		if (duplicate) {
+			pr_debug("Duplicate attribute name found - %s\n",
+				 elements[ATTR_NAME].string.pointer);
+			kobject_put(duplicate);
 			goto nextobj;
 		}
 
-- 
2.40.1



