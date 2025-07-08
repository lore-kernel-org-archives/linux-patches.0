Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D7176ADB;
	Tue,  8 Jul 2025 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992154; cv=none; b=YjIkJBb2AegR79wEh7XCsYCO7bMXfFnzHgUDNu8+tg/9ufbFmZA/OY+zP4qyJuPECfyp4pppgGR5828MH0yGWTRYHl+Xoy6gHjVGKTr2rjcx2X6BNr0szRrj18BJX+UG1soB4MkP7tcD2oJcxeJQxC8MpjJh2DzZs+ytpe1merQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992154; c=relaxed/simple;
	bh=zm5TQi0lEwDuOfPjRJvP947Agvgl0npG7kjL7jWUq2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYtrxM2Uc8Y62Kl3E9t5118jSrabVaKVwkLUy4jpSI9Qg/grdPh0Xr1LFeJP+RgxL/Yxg5lAONlGa187rF+LOXuvbQYjoX3MuUgScJFonI6o7WsXX2mPWCFFr348KzD529G9nv6uFzQWFp9v8nS9IuN8SJH8AVsoAmKr1nIZlFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEhPdg6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEhPdg6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310BCC4CEED;
	Tue,  8 Jul 2025 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992154;
	bh=zm5TQi0lEwDuOfPjRJvP947Agvgl0npG7kjL7jWUq2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEhPdg6XbEWNwTweY1Qz54iKluoNU0jQc6urlVAm2HfiVvzkydZn8mh4OQwh3VS4q
	 cbvjPArYthEx2YuIRqU0soUR+ipQo85lfLBmjh3z8GLT7YHzbCq8Lsu4x3j3xMk3Pl
	 AMgnhL6979cR8S1MBCXy5RbG2+QUpbWk/+n2TArE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>
Subject: [PATCH 6.1 75/81] platform/x86: think-lmi: Create ksets consecutively
Date: Tue,  8 Jul 2025 18:24:07 +0200
Message-ID: <20250708162227.320096392@linuxfoundation.org>
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


