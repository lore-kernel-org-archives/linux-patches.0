Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F282B481650;
	Tue, 25 Aug 2026 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666084; cv=none; b=Acwj5xJwKulufse/70uoJM/yZfsdjWvBK1w3tdaWbUQIfOTor8Xi3m52+5XE4qKwVF3LHgo2BrSILWsukNcGK9eetsB3DXHxIPRvsrjA+jnEQm9zZjIiyTl4pkHLnrupeGfUQ1i+fMD7QJBiD/hr/ayxSQ5tK3S+g9ZiDvVUw+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666084; c=relaxed/simple;
	bh=5lX4PP7OAB6FnWBjCIyQxDcyNJnaT1Aj8szh1CYdbFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG1UyQOtRDbiRcG6igwk2CEbEof83Zn1ZOWm1b87UfkIUCvbc+jTd3qVkyCOQkhVeLeorwMvayO2872Lzt0fp7mw6Jdm1nPh8Lu07jdqh2EWWJpCvWUhroZLK30vKg+tSmyw30gkmcrEyR8guNqs8X5MQLaT4ZmXrHV3PTuLjAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/XjQGd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/XjQGd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0D21F000E9;
	Tue, 25 Aug 2026 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666082;
	bh=P9o1OyXg/uUtqYuDV5H7heGJ32vKphnwmzRDaxglfoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/XjQGd8zjaey2FEfziZ6jxDbBhFd2ScSYN0eKG9Ev4r2TADp+8HR3m4QD7rFlq15
	 i6UpaoydYC6xvK3dt0eurJKfGJAfuGcXe4c0hJAmCGz6y4eKEm3lj2rsIhn2WmE8DN
	 gLk9ceakyQUXv1Buk46sDw7bLRFsGkAsaCF2nOS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 77/79] HID: sensor: custom: Fix use-after-free in enable_sensor
Date: Tue, 25 Aug 2026 15:26:57 +0200
Message-ID: <20260825132544.695736074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit ad8fb82b04422f49530d2aa2753cc81d1c60102c upstream.

enable_sensor_store() can call set_power_report_state(), which
dereferences sensor_inst->power_state and sensor_inst->report_state.
These pointers refer to entries in sensor_inst->fields.

Create the field attributes before exposing the enable_sensor sysfs
attribute, so enable_sensor cannot be accessed before the state it
depends on has been initialized.

On remove, delete enable_sensor before freeing the field attributes,
so a concurrent sysfs write cannot dereference freed memory through
power_state or report_state.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260623021950.1736413-1-haoxiang_li2024@163.com?part=1
Fixes: 4a7de0519df5 ("HID: sensor: Custom and Generic sensor support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-custom.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -910,26 +910,26 @@ static int hid_sensor_custom_probe(struc
 		return ret;
 	}
 
-	ret = sysfs_create_group(&sensor_inst->pdev->dev.kobj,
-				 &enable_sensor_attr_group);
+	ret = hid_sensor_custom_add_attributes(sensor_inst);
 	if (ret)
 		goto err_remove_callback;
 
-	ret = hid_sensor_custom_add_attributes(sensor_inst);
+	ret = sysfs_create_group(&sensor_inst->pdev->dev.kobj,
+				 &enable_sensor_attr_group);
 	if (ret)
-		goto err_remove_group;
+		goto err_remove_attributes;
 
 	ret = hid_sensor_custom_dev_if_add(sensor_inst);
 	if (ret)
-		goto err_remove_attributes;
+		goto err_remove_group;
 
 	return 0;
 
-err_remove_attributes:
-	hid_sensor_custom_remove_attributes(sensor_inst);
 err_remove_group:
 	sysfs_remove_group(&sensor_inst->pdev->dev.kobj,
 			   &enable_sensor_attr_group);
+err_remove_attributes:
+	hid_sensor_custom_remove_attributes(sensor_inst);
 err_remove_callback:
 	sensor_hub_remove_callback(hsdev, hsdev->usage);
 
@@ -947,9 +947,10 @@ static int hid_sensor_custom_remove(stru
 	}
 
 	hid_sensor_custom_dev_if_remove(sensor_inst);
-	hid_sensor_custom_remove_attributes(sensor_inst);
+	/* Remove enable_sensor first as it uses fields via power_state/report_state. */
 	sysfs_remove_group(&sensor_inst->pdev->dev.kobj,
 			   &enable_sensor_attr_group);
+	hid_sensor_custom_remove_attributes(sensor_inst);
 	sensor_hub_remove_callback(hsdev, hsdev->usage);
 
 	return 0;


