Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C8B2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0473BC433EF;
	Wed, 12 Apr 2023 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288603;
	bh=nFcOaDx7RDf9mjdo7joNbeSrMkDHetJ7wlnSxRCH5tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udYtAKFy9iZsGkuKSBDZDdRrD/MGmoaCeLD4uzXsp1qJszRmds23jrLWUCBRHSCvl
	 +fqHtLjcMnFHwfgzo6/O+8M0VIeh9pf1Dz6A7Prig5AU+Yzz6T851NmfkOR5wxviim
	 dcbCUBlaQBJICo/Jxx5Sd67AlE0rhExrmNkRViAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/93] platform/x86: think-lmi: Clean up display of current_value on Thinkstation
Date: Wed, 12 Apr 2023 10:33:41 +0200
Message-Id: <20230412082824.818762666@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

[ Upstream commit 7065655216d4d034d71164641f3bec0b189ad6fa ]

On ThinkStations on retrieving the attribute value the BIOS appends the
possible values to the string.
Clean up the display in the current_value_show function so the options
part is not displayed.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Reported by Mario Limoncello <Mario.Limonciello@amd.com>
Link: https://github.com/fwupd/fwupd/issues/5077#issuecomment-1488730526
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230403013120.2105-2-mpearson-lenovo@squebb.ca
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index ded3aacb26cc9..76f0d04e17f30 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -504,7 +504,7 @@ static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *at
 static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
-	char *item, *value;
+	char *item, *value, *p;
 	int ret;
 
 	ret = tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID);
@@ -515,9 +515,12 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	value = strpbrk(item, ",");
 	if (!value || value == item || !strlen(value + 1))
 		ret = -EINVAL;
-	else
+	else {
+		/* On Workstations remove the Options part after the value */
+		p = strchrnul(value, ';');
+		*p = '\0';
 		ret = sysfs_emit(buf, "%s\n", value + 1);
-
+	}
 	kfree(item);
 
 	return ret;
-- 
2.39.2



