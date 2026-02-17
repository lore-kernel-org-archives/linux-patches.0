Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B2C378830;
	Tue, 17 Feb 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361002; cv=none; b=hRzm/B3cf8W23eBDcB4e6GGMgmX9iECN0Z2VFsHNtQbhEyEhv4QIdDBgHXVIrtfxlnZ6sut+yrI6xc6lA3+lrS7RVKm/vc7cMnDF9ZZX5He4PAZMfR1oalUs6AIGmGYrecEx3UrhTGd43oCFLFGa7kRoKjFq/ge1s/u/E6xFP5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361002; c=relaxed/simple;
	bh=17EtB7EPOVaA/MC84feh20E8ATwpXPt6XKF/m6+THvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahh5FTTWQm4GJEGSPDA/VBd84RV9JKdsSsoSDQPpH8o26yatfuEvXiI3Q8w7QM6K6IX7ecc7preD5GHvAlab3VGJ1F9sbH0xImnTm03UpRa9Z2seQlROfluJEvnqouAdMTGNIEYMJ6m6f9ZryTPUafvr/qMYikrmQ9uC1R+h/Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsOT1YGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsOT1YGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C9C4CEF7;
	Tue, 17 Feb 2026 20:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361002;
	bh=17EtB7EPOVaA/MC84feh20E8ATwpXPt6XKF/m6+THvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsOT1YGPkBZbImf05Q687rWEzjEg7grLYU8HQ+Hqs7mjm177BKUhfgMouY+I2DuBJ
	 W8JCi+gnuOWTsXASr112MDiQv0F/8MsnVF+W0DtxtkKd+FW+RUrsOiz6n/vfQmtgJI
	 e0NCAy1aHdNL4TNqdcHnGi6mV7GyZT2GdZcz4K/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/39] platform/x86: classmate-laptop: Add missing NULL pointer checks
Date: Tue, 17 Feb 2026 21:31:22 +0100
Message-ID: <20260217200003.440946034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fe747d7112283f47169e9c16e751179a9b38611e ]

In a few places in the Classmate laptop driver, code using the accel
object may run before that object's address is stored in the driver
data of the input device using it.

For example, cmpc_accel_sensitivity_store_v4() is the "show" method
of cmpc_accel_sensitivity_attr_v4 which is added in cmpc_accel_add_v4(),
before calling dev_set_drvdata() for inputdev->dev.  If the sysfs
attribute is accessed prematurely, the dev_get_drvdata(&inputdev->dev)
call in in cmpc_accel_sensitivity_store_v4() returns NULL which
leads to a NULL pointer dereference going forward.

Moreover, sysfs attributes using the input device are added before
initializing that device by cmpc_add_acpi_notify_device() and if one
of them is accessed before running that function, a NULL pointer
dereference will occur.

For example, cmpc_accel_sensitivity_attr_v4 is added before calling
cmpc_add_acpi_notify_device() and if it is read prematurely, the
dev_get_drvdata(&acpi->dev) call in cmpc_accel_sensitivity_show_v4()
returns NULL which leads to a NULL pointer dereference going forward.

Fix this by adding NULL pointer checks in all of the relevant places.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12825381.O9o76ZdvQC@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/classmate-laptop.c | 32 +++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 9309ab5792cbc..ac02b22154d62 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -208,7 +208,12 @@ static ssize_t cmpc_accel_sensitivity_show_v4(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	return sprintf(buf, "%d\n", accel->sensitivity);
 }
@@ -225,7 +230,12 @@ static ssize_t cmpc_accel_sensitivity_store_v4(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	r = kstrtoul(buf, 0, &sensitivity);
 	if (r)
@@ -257,7 +267,12 @@ static ssize_t cmpc_accel_g_select_show_v4(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	return sprintf(buf, "%d\n", accel->g_select);
 }
@@ -274,7 +289,12 @@ static ssize_t cmpc_accel_g_select_store_v4(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	r = kstrtoul(buf, 0, &g_select);
 	if (r)
@@ -303,6 +323,8 @@ static int cmpc_accel_open_v4(struct input_dev *input)
 
 	acpi = to_acpi_device(input->dev.parent);
 	accel = dev_get_drvdata(&input->dev);
+	if (!accel)
+		return -ENXIO;
 
 	cmpc_accel_set_sensitivity_v4(acpi->handle, accel->sensitivity);
 	cmpc_accel_set_g_select_v4(acpi->handle, accel->g_select);
@@ -551,7 +573,12 @@ static ssize_t cmpc_accel_sensitivity_show(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	return sprintf(buf, "%d\n", accel->sensitivity);
 }
@@ -568,7 +595,12 @@ static ssize_t cmpc_accel_sensitivity_store(struct device *dev,
 
 	acpi = to_acpi_device(dev);
 	inputdev = dev_get_drvdata(&acpi->dev);
+	if (!inputdev)
+		return -ENXIO;
+
 	accel = dev_get_drvdata(&inputdev->dev);
+	if (!accel)
+		return -ENXIO;
 
 	r = kstrtoul(buf, 0, &sensitivity);
 	if (r)
-- 
2.51.0



