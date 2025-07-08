Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA7B2E11B3;
	Tue,  8 Jul 2025 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993716; cv=none; b=AK86d/sstUAYv57Vakxce5dvxibzj8/Iu/P3/OmMZpQqQ4sxh864pyds/8s6MxZcY2YUeTRR+QNezpnME7QqlN24PRgH9K08FAAxicRcfqakXGuUYALjem648+rjRGVhxw7HwEVGGV9lDEdV3jby5U6oAvK/w8XmATEYR5s1jh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993716; c=relaxed/simple;
	bh=IjpU/fm+v+mzGwYOGYCXfr52Z5LOzQ/YgZRIrI/hhWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knUSQHHyAZLcKKp8sFAeWBH6q/Ukxet1IAkLHMxJt+WPphwX+D0GrlrHXu//mPblfwSXLUDjjlycRo/7WhXnto8C7pdvMtafMike2aoK1Jn1jhnsIM9UEtqfC+CWBpah/GYkNgwLwYMXME0pdXNOnoMsH4PM8fHeork9upDh4aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zi/m/ZRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zi/m/ZRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF173C4CEED;
	Tue,  8 Jul 2025 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993716;
	bh=IjpU/fm+v+mzGwYOGYCXfr52Z5LOzQ/YgZRIrI/hhWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zi/m/ZRjZKRSnRmwCxacEMpn+rREeZkkshoJTGVibidZku8z6NlIXBh84txYkNtBE
	 flJ8IhAhGY8r6IStE4a2QmOSj+09PpFl1Ce5kpxaxn1sIJQi6M0USxIkv+S/JVE/X5
	 G7Et6X0AHbJ35pw0vazKR+y6gQOpG2yhecxumIMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>
Subject: [PATCH 6.15 168/178] platform/x86: think-lmi: Create ksets consecutively
Date: Tue,  8 Jul 2025 18:23:25 +0200
Message-ID: <20250708162240.854389772@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 8dab34ca77293b409c3223636dde915a22656748 upstream.

Avoid entering tlmi_release_attr() in error paths if both ksets are not
yet created.

This is accomplished by initializing them side by side.

Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-1-ce4f81c9c481@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/think-lmi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1455,6 +1455,14 @@ static int tlmi_sysfs_init(void)
 		goto fail_device_created;
 	}
 
+	tlmi_priv.authentication_kset = kset_create_and_add("authentication", NULL,
+							    &tlmi_priv.class_dev->kobj);
+	if (!tlmi_priv.authentication_kset) {
+		kset_unregister(tlmi_priv.attribute_kset);
+		ret = -ENOMEM;
+		goto fail_device_created;
+	}
+
 	for (i = 0; i < TLMI_SETTINGS_COUNT; i++) {
 		/* Check if index is a valid setting - skip if it isn't */
 		if (!tlmi_priv.setting[i])
@@ -1496,12 +1504,6 @@ static int tlmi_sysfs_init(void)
 	}
 
 	/* Create authentication entries */
-	tlmi_priv.authentication_kset = kset_create_and_add("authentication", NULL,
-								&tlmi_priv.class_dev->kobj);
-	if (!tlmi_priv.authentication_kset) {
-		ret = -ENOMEM;
-		goto fail_create_attr;
-	}
 	tlmi_priv.pwd_admin->kobj.kset = tlmi_priv.authentication_kset;
 	ret = kobject_add(&tlmi_priv.pwd_admin->kobj, NULL, "%s", "Admin");
 	if (ret)


