Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8806FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F452C433D2;
	Mon,  3 Apr 2023 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532294;
	bh=610eYB4IEW3NrhHmH0fo76VOsyahLA/go6GJkQBsv+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEf6zE2tEuDYfWIeMk4N1eWXcYzCCYsa73dJCX4Luik1220BSdavX5kHpi8bt1722
	 tnZwk2MDr+CWvTENoHYjjXu440ZjKmGddjfVRjyCt33v+GuwMQqj57BjcClgdQG0FN
	 HngqJvvLrdLgNWQo71FP5rrzDAQJNQApmnnyojHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/99] platform/x86: think-lmi: use correct possible_values delimiters
Date: Mon,  3 Apr 2023 16:08:51 +0200
Message-Id: <20230403140404.120824261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

[ Upstream commit 45e21289bfc6e257885514790a8a8887da822d40 ]

firmware-attributes class requires that possible values are delimited
using ';' but the Lenovo firmware uses ',' instead.
Parse string and replace where appropriate.

Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-2-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 0c166b4fa7167..f10fe5ffe47df 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -538,7 +538,7 @@ static ssize_t type_show(struct kobject *kobj, struct kobj_attribute *attr,
 
 	if (setting->possible_values) {
 		/* Figure out what setting type is as BIOS does not return this */
-		if (strchr(setting->possible_values, ','))
+		if (strchr(setting->possible_values, ';'))
 			return sysfs_emit(buf, "enumeration\n");
 	}
 	/* Anything else is going to be a string */
@@ -934,6 +934,13 @@ static int tlmi_analyze(void)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
 		}
+		/*
+		 * firmware-attributes requires that possible_values are separated by ';' but
+		 * Lenovo FW uses ','. Replace appropriately.
+		 */
+		if (setting->possible_values)
+			strreplace(setting->possible_values, ',', ';');
+
 		kobject_init(&setting->kobj, &tlmi_attr_setting_ktype);
 		tlmi_priv.setting[i] = setting;
 		kfree(item);
-- 
2.39.2



