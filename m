Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0A2E3B03;
	Tue,  8 Jul 2025 16:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992529; cv=none; b=K1vmQADT9x5mkjdA2ZEKeEqKAeFY/BUIbJJsD6lQfDxzA2VRMAzndhWlaIXNz03H/0+GJECA3v6aai5qnMlumdZG+lyS4F/WMP7slL4Lj3PApRPlEbnAupM7K/JXVEKuce0qqafmLvPFDPzr978qjISXrGpHwAEgMCjWCwJh2Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992529; c=relaxed/simple;
	bh=mf+SY3PkmjrZFYwgqs2XtcFdnyaLS/Naays9y1VYHJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIhomNioqi+MsjbTuGQ6xMS+E8rB6b2BfiGOlq1VqgzfxkuLcxwYLYx5Z014LzOoYcY6ltewnRD80rcwiXB7P89Qka3hqSJJw/uVW/nNxnlbHRxjii8SCcFt3sMUs3QKqrSLl0X8B8suYsqMZP13tA+Gpa6uVi/H0qUtB1S9LTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHFubuKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHFubuKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA38C4CEED;
	Tue,  8 Jul 2025 16:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992529;
	bh=mf+SY3PkmjrZFYwgqs2XtcFdnyaLS/Naays9y1VYHJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHFubuKiafyRnWEsEC0tjlO5D0FOFl+nLVj+8cewL4dbTipHmAFuGvRYUa4L2yNga
	 IC9tNVv1wO+KQSwKmTvuZuKOnUCpLVnFqHob6fuKpGQ6lNIGsUUujqc3lKYcZeLHdK
	 5XmBaqFJM0hwBTg55i1iYdyyScb4LtUyH7ca/5NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>
Subject: [PATCH 6.6 123/132] platform/x86: think-lmi: Create ksets consecutively
Date: Tue,  8 Jul 2025 18:23:54 +0200
Message-ID: <20250708162234.133142697@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1285,6 +1285,14 @@ static int tlmi_sysfs_init(void)
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
@@ -1322,12 +1330,6 @@ static int tlmi_sysfs_init(void)
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


