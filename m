Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE719BD9
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1BVctv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F487C433C8;
	Mon, 16 Oct 2023 08:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446329;
	bh=vQKpA9ssopWAJtDdLJuPdpILrPWSsUBtMuImBrMpLFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1BVctv2ev2Hfbru1xFrz//jlE4HnCl6dpS2ZtXdVZjnXoiTd+3wXZ6kIM2miYKRJ
	 y0SlhtxipchBP4rjGWrNZ+dZCMcvJOJK6yyP4IUKUVDJYGmdl10U71rF37hcS9/JpX
	 s9gL0Tmkd2Fs1Il1j+QvaHWIFw7IGeXblNMFlG3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/131] platform/x86: think-lmi: Fix reference leak
Date: Mon, 16 Oct 2023 10:39:49 +0200
Message-ID: <20231016084000.221053237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 528ab3e605cabf2f9c9bd5944d3bfe15f6e94f81 ]

If a duplicate attribute is found using kset_find_obj(), a reference
to that attribute is returned which needs to be disposed accordingly
using kobject_put(). Move the setting name validation into a separate
function to allow for this change without having to duplicate the
cleanup code for this setting.
As a side note, a very similar bug was fixed in
commit 7295a996fdab ("platform/x86: dell-sysman: Fix reference leak"),
so it seems that the bug was copied from that driver.

Compile-tested only.

Fixes: 1bcad8e510b2 ("platform/x86: think-lmi: Fix issues with duplicate attributes")
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230925142819.74525-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index f6290221d139d..6641f934f15bf 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1245,6 +1245,24 @@ static void tlmi_release_attr(void)
 	kset_unregister(tlmi_priv.authentication_kset);
 }
 
+static int tlmi_validate_setting_name(struct kset *attribute_kset, char *name)
+{
+	struct kobject *duplicate;
+
+	if (!strcmp(name, "Reserved"))
+		return -EINVAL;
+
+	duplicate = kset_find_obj(attribute_kset, name);
+	if (duplicate) {
+		pr_debug("Duplicate attribute name found - %s\n", name);
+		/* kset_find_obj() returns a reference */
+		kobject_put(duplicate);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int tlmi_sysfs_init(void)
 {
 	int i, ret;
@@ -1273,10 +1291,8 @@ static int tlmi_sysfs_init(void)
 			continue;
 
 		/* check for duplicate or reserved values */
-		if (kset_find_obj(tlmi_priv.attribute_kset, tlmi_priv.setting[i]->display_name) ||
-		    !strcmp(tlmi_priv.setting[i]->display_name, "Reserved")) {
-			pr_debug("duplicate or reserved attribute name found - %s\n",
-				tlmi_priv.setting[i]->display_name);
+		if (tlmi_validate_setting_name(tlmi_priv.attribute_kset,
+					       tlmi_priv.setting[i]->display_name) < 0) {
 			kfree(tlmi_priv.setting[i]->possible_values);
 			kfree(tlmi_priv.setting[i]);
 			tlmi_priv.setting[i] = NULL;
-- 
2.40.1



