Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4D2745E;
	Fri, 17 Oct 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714833; cv=none; b=aRyc96hbB8/Huab6u9EchBSKCKP79mxL8XlIJ8uMXteZscGRhre3V4VKRuoPblW/9ticlVQwdM64ajM7xhskzOt8C4zjup/IyN96NgGA7sVs7QUdPs9J1qcH7isDpz0HeZB65hLxkyJlffyGMj2nJeSKvB1U5ak6ccxBBCgSPlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714833; c=relaxed/simple;
	bh=EPc0ZpYJRTxYexr2ZL7eU3Y+ZScFXlgiDf/AY5kss14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzHVTfcgdGvb8MUXrqxvzZ8We6fQmXcWFoyVV4GnmgVEP0EQR5RH40o2N9K3oNwPIneWAifzHR4r/fWGdsES+kc42NBEOcs7KFtcpGCkuXI1G/a1ORU5heOSB9aM1fbtPoeZt+przEsMYluu6CjStqo666JZoC79SfVNfZPlX4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeCRxkHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeCRxkHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC61C4CEE7;
	Fri, 17 Oct 2025 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714833;
	bh=EPc0ZpYJRTxYexr2ZL7eU3Y+ZScFXlgiDf/AY5kss14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeCRxkHvZMcL4/WVQraghffXapBTfP3X9g/juuXrxy4n/+FwSnL0xDBo0U8LWgeJ9
	 zRxm4WN3W69Tnq1a5BitQUyBSas9WlNm2R6LO9DVWrmUJ0FO8soTrijQUBsY2SCJye
	 JC1kGjlmgTMoCLfGYzS6DZmmxXjlnZIqBETvE3/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/277] ACPI: battery: initialize mutexes through devm_ APIs
Date: Fri, 17 Oct 2025 16:54:16 +0200
Message-ID: <20251017145156.242602725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 0710c1ce50455ed0db91bffa0eebbaa4f69b1773 ]

Simplify the cleanup logic a bit.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20240904-acpi-battery-cleanups-v1-3-a3bf74f22d40@weissschuh.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 399dbcadc01e ("ACPI: battery: Add synchronization between interface updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -1225,8 +1225,8 @@ static int acpi_battery_add(struct acpi_
 	strscpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strscpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
-	mutex_init(&battery->lock);
-	mutex_init(&battery->sysfs_lock);
+	devm_mutex_init(&device->dev, &battery->lock);
+	devm_mutex_init(&device->dev, &battery->sysfs_lock);
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
 
@@ -1254,8 +1254,6 @@ fail_pm:
 	unregister_pm_notifier(&battery->pm_nb);
 fail:
 	sysfs_remove_battery(battery);
-	mutex_destroy(&battery->lock);
-	mutex_destroy(&battery->sysfs_lock);
 
 	return result;
 }
@@ -1275,9 +1273,6 @@ static void acpi_battery_remove(struct a
 	device_init_wakeup(&device->dev, 0);
 	unregister_pm_notifier(&battery->pm_nb);
 	sysfs_remove_battery(battery);
-
-	mutex_destroy(&battery->lock);
-	mutex_destroy(&battery->sysfs_lock);
 }
 
 #ifdef CONFIG_PM_SLEEP


