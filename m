Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939C31618C;
	Thu, 28 May 2026 19:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998028; cv=none; b=VnMuMUvdz6HXqPUEKr3lTIno8O8S8f9ObyhaHqa3Gd2QCocV+M4u9VHaZO5jSlPTicd2W28kBhKSu9U+2hgUeqsGvTzPvXM8rlLS2s6+CKsF28srveUFOgiVzRavx8OOgCGRCzqogDCm3sLDy9PwUWlVTgDOp2WBDn9yMgLVa3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998028; c=relaxed/simple;
	bh=Oa/FtmToeBoJZ41ETD+FulgP05YcWcIbd2nbvLfpT30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmu9+tiyYTBndzhE+9BLzDkZdkkEdUhJD1oG+Z9T9Rs1Z4BvOUWBtARoicqbxT8BQzOhGY4RUyqxBTzUc3KQ3/gXVXiuD6kRe4ukfBYFlfohIUcfSZQqLFov97NM8pk++zNQWl4tmdtafUx2duGUdf/EV/ia1PzMqiDEj+zEgao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPfcMKTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPfcMKTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF11F000E9;
	Thu, 28 May 2026 19:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998027;
	bh=nNYIj9rQ4MDMiMdaPR66Qx4YCRexLP3y9na6xSD8OU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPfcMKTIFT7rmDQDuIxu0PGPy+DaDyIGd38sUZ2TueeM1v2h8A6wp4S861Suugjl7
	 uDQtZQwAMH49f29+ad3rM3kH/D8kgYQswC1vgc5nCNzwKbxfNOMfQNNLqCCfqs3XlR
	 zuasFoQn98PzWib9F+r4c8/QvLqJ2WnBkUW+TBtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.0 027/461] ACPI: battery: Fix system wakeup on critical battery status
Date: Thu, 28 May 2026 21:42:36 +0200
Message-ID: <20260528194647.678917695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c35cb4fc7231702d1e9952aec1a442f3e27df6f5 upstream.

Commit 0a869409a981 ("ACPI: battery: Convert the driver to a platform
one") changed the parent of the battery wakeup source to the platform
device used for driver binding, but it forgot to update the
acpi_pm_wakeup_event() call in acpi_battery_update() accordingly.

Do it now to unbreak waking up the system on critical battery status
during suspend-to-idle and during transitions to ACPI S3/S4.

Fixes: 0a869409a981 ("ACPI: battery: Convert the driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 7.0+ <stable@vger.kernel.org> # 7.0+
Link: https://patch.msgid.link/12898712.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -96,6 +96,7 @@ struct acpi_battery {
 	struct power_supply *bat;
 	struct power_supply_desc bat_desc;
 	struct acpi_device *device;
+	struct device *phys_dev;
 	struct notifier_block pm_nb;
 	struct list_head list;
 	unsigned long update_time;
@@ -1035,7 +1036,7 @@ static int acpi_battery_update(struct ac
 	if ((battery->state & ACPI_BATTERY_STATE_CRITICAL) ||
 	    (test_bit(ACPI_BATTERY_ALARM_PRESENT, &battery->flags) &&
 	     (battery->capacity_now <= battery->alarm)))
-		acpi_pm_wakeup_event(&battery->device->dev);
+		acpi_pm_wakeup_event(battery->phys_dev);
 
 	return result;
 }
@@ -1228,6 +1229,7 @@ static int acpi_battery_probe(struct pla
 
 	platform_set_drvdata(pdev, battery);
 
+	battery->phys_dev = &pdev->dev;
 	battery->device = device;
 	strscpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strscpy(acpi_device_class(device), ACPI_BATTERY_CLASS);


