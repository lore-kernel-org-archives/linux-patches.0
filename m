Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D73335061;
	Fri, 17 Oct 2025 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713959; cv=none; b=nl/Axxa//MpjpkGPF0v0En+lQ7cHXzh8slKXpnvhsdW6AuL4fQI/bpfljh/w91LWjaXdOdb+In83Hl7KbX9y89luSnPKZ6ONsQpP5QcFt9anD1457OM3jn/r7/FlbPFyqQYacnl8EDguh/1fs6dBvj1hxvYLNDtuF/l4LMrmwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713959; c=relaxed/simple;
	bh=o8YiwCO933TL13t6fRAFJrlh12nLLILY9mb5AGbA+rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URKxDB7/cOZ8y0290DkxpTJaijcqUr8BajGAi4NqE4hJz5QgU3b4LftiGfNJLld62hI7pVKzF24Hvjji/qjvNOkbkYMpPoEnyrWuhZcGgIl85bPhJouoJAP505B6KgBIFkcD2kkHL94jS46PoeUwxlner4jEpAKHoFScNFFjmPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujr2zfad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujr2zfad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD72C4CEFE;
	Fri, 17 Oct 2025 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713959;
	bh=o8YiwCO933TL13t6fRAFJrlh12nLLILY9mb5AGbA+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ujr2zfadt2OJjuCsKCFnY/OIif9GAum8SkiftvK5+WAeyfKDUNMA5tldORdZAhY+a
	 64LFtiS/I+uT7ADujNe3uWIMJpdBwEBxDzVJoPTp9fO3ZDWZGONAvt7WRy1L/btzTo
	 glaqYX2Z5LWmhxUp0kC9239U6CwY14MI9kQd/i7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/201] ACPI: battery: initialize mutexes through devm_ APIs
Date: Fri, 17 Oct 2025 16:54:00 +0200
Message-ID: <20251017145141.330216724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
@@ -1210,8 +1210,8 @@ static int acpi_battery_add(struct acpi_
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
-	mutex_init(&battery->lock);
-	mutex_init(&battery->sysfs_lock);
+	devm_mutex_init(&device->dev, &battery->lock);
+	devm_mutex_init(&device->dev, &battery->sysfs_lock);
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
 
@@ -1239,8 +1239,6 @@ fail_pm:
 	unregister_pm_notifier(&battery->pm_nb);
 fail:
 	sysfs_remove_battery(battery);
-	mutex_destroy(&battery->lock);
-	mutex_destroy(&battery->sysfs_lock);
 
 	return result;
 }
@@ -1260,9 +1258,6 @@ static void acpi_battery_remove(struct a
 	device_init_wakeup(&device->dev, 0);
 	unregister_pm_notifier(&battery->pm_nb);
 	sysfs_remove_battery(battery);
-
-	mutex_destroy(&battery->lock);
-	mutex_destroy(&battery->sysfs_lock);
 }
 
 #ifdef CONFIG_PM_SLEEP


