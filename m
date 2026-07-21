Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649F3415F17;
	Tue, 21 Jul 2026 18:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660183; cv=none; b=IB4BCYf7peUdlmEDPhtg03MQMmcWBu3YzQWhDTKjevPOjws3/dDk4SgvrcTJQ0T41cvVixAd/qb1SmbZFFxTZlzah41wY2Su+lEfntyl8Px9bf2cPgijpYGnpkd5AfEitLAB/5t2QVbcmFu1lD1Ou/OoJeQuhm0vzbM53KFJM2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660183; c=relaxed/simple;
	bh=QVQbH1Vm1pWO5V+uJp7i6COtL5Tvx9jPqFZK+/mhFxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgvV328UM9RNSC8DbMLm6Efq9sq+2kHpU1cnnpYyOXO3cGcASB/oBZ/VcTUl3AjKeXDOmpb47q+NDaJPi3yfmzJ0bm3uY9EZlVxxQxNSy7yAZTfEa/vjgMAkVGVGGuRD6p1arMCZQYM4FcD5Eq5LNnX6PZ51U5rZMSL0rp3rPLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/efi64V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/efi64V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9791F000E9;
	Tue, 21 Jul 2026 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660182;
	bh=ury1ShMFoOGgSD8D9BNiL55Vkbala7Th11SxWJlLLjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/efi64VjZ2b+5VZAPmW7Dvje1kQ/9/qDdMrgXZsjiRWDcbCEAjiGRySk3KbxYLdP
	 STC0OV3glOvegnUyDqvi7nNMVl414m9BpTEcoVofDpjMS8P3g53V5kvWvuSx00irKW
	 62Rs5TKmxSBSAYMj2ElzZ67gnWdcqOQoXgMtAUbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0884/2077] platform/x86: classmate-laptop: Address memory leaks on driver removal
Date: Tue, 21 Jul 2026 17:09:17 +0200
Message-ID: <20260721152613.657119699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 4baf44b4051940ba1abc68ef5136d25cb1806521 ]

Switch over cmpc_accel_add_v4() and cmpc_accel_add() to using
devm_kzalloc() for allocating the accel object which will cause it
to be freed automatically on device removal, so it won't be leaked
any more.

This also simplifies the rollback paths in these functions somewhat.

Fixes: 529aa8cb0a59 ("classmate-laptop: add support for Classmate PC ACPI devices")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/10846403.nUPlyArG6x@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/classmate-laptop.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index e6eed3d65580ae..a5fe34211afb99 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -400,7 +400,7 @@ static int cmpc_accel_add_v4(struct acpi_device *acpi)
 	struct input_dev *inputdev;
 	struct cmpc_accel *accel;
 
-	accel = kmalloc_obj(*accel);
+	accel = devm_kzalloc(&acpi->dev, sizeof(*accel), GFP_KERNEL);
 	if (!accel)
 		return -ENOMEM;
 
@@ -411,7 +411,7 @@ static int cmpc_accel_add_v4(struct acpi_device *acpi)
 
 	error = device_create_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v4);
 	if (error)
-		goto failed_sensitivity;
+		return error;
 
 	accel->g_select = CMPC_ACCEL_G_SELECT_DEFAULT;
 	cmpc_accel_set_g_select_v4(acpi->handle, accel->g_select);
@@ -434,8 +434,6 @@ static int cmpc_accel_add_v4(struct acpi_device *acpi)
 	device_remove_file(&acpi->dev, &cmpc_accel_g_select_attr_v4);
 failed_g_select:
 	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v4);
-failed_sensitivity:
-	kfree(accel);
 	return error;
 }
 
@@ -650,7 +648,7 @@ static int cmpc_accel_add(struct acpi_device *acpi)
 	struct input_dev *inputdev;
 	struct cmpc_accel *accel;
 
-	accel = kmalloc_obj(*accel);
+	accel = devm_kzalloc(&acpi->dev, sizeof(*accel), GFP_KERNEL);
 	if (!accel)
 		return -ENOMEM;
 
@@ -659,7 +657,7 @@ static int cmpc_accel_add(struct acpi_device *acpi)
 
 	error = device_create_file(&acpi->dev, &cmpc_accel_sensitivity_attr);
 	if (error)
-		goto failed_file;
+		return error;
 
 	error = cmpc_add_acpi_notify_device(acpi, "cmpc_accel",
 					    cmpc_accel_idev_init);
@@ -673,8 +671,6 @@ static int cmpc_accel_add(struct acpi_device *acpi)
 
 failed_input:
 	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr);
-failed_file:
-	kfree(accel);
 	return error;
 }
 
-- 
2.53.0



