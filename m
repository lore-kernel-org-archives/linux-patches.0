Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFAD2DF126;
	Sat, 17 Oct 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259605; cv=none; b=QYKBmoDFi65MLjo2V2tOOIeXzbhaOyzdkClEKw7jSy51/HzBXcmylWz5Y/5ZYAkXyTcSnO7SSxi+aSVatJDLZujP/HuOHqnvGfYhumPAoK2BssmU1AYSPC6IANgdJKmYXSWHCZkQQdoYGHqkHMptvzmJcnTNNPpsYnFOmGz77I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259605; c=relaxed/simple;
	bh=4Us0wE6FMMpxlrtpWMRtSl0WQtALFOVoucxEDRdMftE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUwhnjYnwLjplfQNxxKRUuAaCaXNcfctCV/Di3ljo4HsSDf0GoZsUfL4ptwNrPi+3MBt+iVgbFFrDzVtiIkAH6djb0tlGvjf8NSeMMfIm7LieLssfxxKvcwB/BfBdb43gHGiNUet4GicgoGj0HNJaPmZvHEOmMZW7lof3g2WAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8iZ3gBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8iZ3gBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678961F000C4;
	Sat, 17 Oct 2026 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259604;
	bh=93zUpIurksaBfCqgnWk5ZXkyrIypB1zvZcYGu7VLCgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8iZ3gBIBrN+1yWbcnjS56PRMTiXNz6JrEvTXd1dtE1AzOaeRp23TGcOYXFqfrimn
	 YvssWjTYJIy0WcC9klwIlw4yxVgyWNPRE3D+u8u60SrsPIDmin9X9AXhK+FI8wWBhk
	 Zdf0821apeQIJW4Qf7mTdVNhIaTDZo37p9FX9ls0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1268/1674] platform/x86: int1092: Fix potential memory leak in sar_probe()
Date: Sat, 17 Oct 2026 17:59:00 +0200
Message-ID: <20261017160503.690446236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 30c906cff490c3601ee9ff110fe8115fabe75fd4 ]

The memory allocated for device_mode_info in parse_package() called by
sar_get_data() is not freed in some of the error paths in sar_probe().
Fix that by converting to use device managed allocations.

Fixes: dcfbd31ef4bc ("platform/x86: BIOS SAR driver for Intel M.2 Modem")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260723-platx86-v4-1-93b4a178b595@cse.iitm.ac.in
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/int1092/intel_sar.c    | 32 ++++++-------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index 926be7d9086a1..1cfb268f6b71f 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -91,8 +91,10 @@ static acpi_status parse_package(struct wwan_sar_context *context, union acpi_ob
 	    item->package.count <= data->total_dev_mode)
 		return AE_ERROR;
 
-	data->device_mode_info = kmalloc_array(data->total_dev_mode,
-					       sizeof(struct wwan_device_mode_info), GFP_KERNEL);
+	data->device_mode_info = devm_kmalloc_array(&context->sar_device->dev,
+						    data->total_dev_mode,
+						    sizeof(*data->device_mode_info),
+						    GFP_KERNEL);
 	if (!data->device_mode_info)
 		return AE_ERROR;
 
@@ -253,7 +255,7 @@ static int sar_probe(struct platform_device *device)
 	if (!handle)
 		return -ENODEV;
 
-	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	context = devm_kzalloc(&device->dev, sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -264,7 +266,7 @@ static int sar_probe(struct platform_device *device)
 	result = guid_parse(SAR_DSM_UUID, &context->guid);
 	if (result) {
 		dev_err(&device->dev, "SAR UUID parse error: %d\n", result);
-		goto r_free;
+		return result;
 	}
 
 	for (reg = 0; reg < MAX_REGULATORY; reg++)
@@ -272,43 +274,29 @@ static int sar_probe(struct platform_device *device)
 
 	if (sar_get_device_mode(device) != AE_OK) {
 		dev_err(&device->dev, "Failed to get device mode\n");
-		result = -EIO;
-		goto r_free;
+		return -EIO;
 	}
 
 	result = sysfs_create_group(&device->dev.kobj, &intcsar_group);
 	if (result) {
 		dev_err(&device->dev, "sysfs creation failed\n");
-		goto r_free;
+		return result;
 	}
 
 	if (acpi_install_notify_handler(ACPI_HANDLE(&device->dev), ACPI_DEVICE_NOTIFY,
 					sar_notify, (void *)device) != AE_OK) {
 		dev_err(&device->dev, "Failed acpi_install_notify_handler\n");
-		result = -EIO;
-		goto r_sys;
+		sysfs_remove_group(&device->dev.kobj, &intcsar_group);
+		return -EIO;
 	}
 	return 0;
-
-r_sys:
-	sysfs_remove_group(&device->dev.kobj, &intcsar_group);
-r_free:
-	kfree(context);
-	return result;
 }
 
 static void sar_remove(struct platform_device *device)
 {
-	struct wwan_sar_context *context = dev_get_drvdata(&device->dev);
-	int reg;
-
 	acpi_remove_notify_handler(ACPI_HANDLE(&device->dev),
 				   ACPI_DEVICE_NOTIFY, sar_notify);
 	sysfs_remove_group(&device->dev.kobj, &intcsar_group);
-	for (reg = 0; reg < MAX_REGULATORY; reg++)
-		kfree(context->config_data[reg].device_mode_info);
-
-	kfree(context);
 }
 
 static struct platform_driver sar_driver = {
-- 
2.53.0



