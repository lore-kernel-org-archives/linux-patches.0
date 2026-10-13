Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3D246770;
	Tue, 13 Oct 2026 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894625; cv=none; b=M+8pL6aGTkK+9TD/UFQGcbjf9hxiHsLJKvZrhj/OCTuB7eErK4uINSLbA0hcWZhYO3WIn8gAV28TjwKIOroXTE19iLBdTtgSEhX8ZzYt2tklP5s6/58l+lnMFcIwuC4bfvIL0mMJ5UEpWd6Ha2zSYVHsZK85JmY0qDeDx9ivw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894625; c=relaxed/simple;
	bh=Ey4QA5CDA/IVcyCLJvbVnKalFoX3yvYF5nIgN+iCff4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrmlS0yxcVlF/UzakdZshosJwf5AABkhm+5Ktn4GZ3zNgj92KJdd1AaPMdhhUAr3RH9E6Sx4OyAoD1bbkhGdketQZwD044VnHotyDzyOHd0lYiUbEq61N6MzNz6zRM0l6x17tCsazOeza1ABrMDSfHfUJf20oqIP2PZW6hrWOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHUketFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHUketFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC361F000FF;
	Tue, 13 Oct 2026 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894624;
	bh=UDJearNagosRVjSjqIbspok7J5ckN6+ORn7Qo5d5yEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHUketFNiIrk1xFYEacA3v8+22uidedprc+uGqJEYKPd/PibD4Ywg7CYQbbNE3MiD
	 qZ8cFDlyimJcPv+WCz2Fp/NyZsGD3qBY3G5BJp4WHy0WMKFuHyjUD2xIxXxJ4m/HYE
	 sdXl6fj6aWgrlcMUJtqYowm2Xz16MDBnzxcK3OsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/621] ACPI: scan: Use acpi_setup_gpe_for_wake() for buttons
Date: Tue, 13 Oct 2026 13:40:16 +0200
Message-ID: <20261013112935.534696773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 57c31e6d620f132dcf610b2c52b4cdbd203c6f4a ]

After starting to use platform devices for representing buttons
enumerated via ACPI, acpi_mark_gpe_for_wake() is insufficient for
preparing their GPEs to wake up the system from sleep because it
does not change the "dispatch type" of the given GPE to
ACPI_GPE_DISPATCH_NOTIFY.  Subsequently, this causes acpi_enable_gpe()
in __acpi_device_wakeup_enable() to fail and system suspend transitions
to be aborted.

Address this by updating acpi_wakeup_gpe_init() to use
acpi_setup_gpe_for_wake() for buttons like for any other devices.

This allows acpi_setup_gpe_for_wake() to be simplified further because
buttons are not a special case in it any more, so do that as well.

Fixes: 52d864019636 ("ACPI: button: Convert the driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Xi Pardee <xi.pardee@linux.intel.com>
Link: https://patch.msgid.link/2259694.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 31cd177bd9672..7f9dd2704f638 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1005,15 +1005,11 @@ static int acpi_bus_extract_wakeup_device_power_package(struct acpi_device *dev)
 	return err;
 }
 
-/* Do not use a button for S5 wakeup */
-#define ACPI_AVOID_WAKE_FROM_S5		BIT(0)
-
 static bool acpi_wakeup_gpe_init(struct acpi_device *device)
 {
 	static const struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0C", 0},				/* Power button */
-		{"PNP0C0D", ACPI_AVOID_WAKE_FROM_S5},	/* Lid */
-		{"PNP0C0E", ACPI_AVOID_WAKE_FROM_S5},	/* Sleep button */
+		{"PNP0C0D", 0},	/* Lid */
+		{"PNP0C0E", 0},	/* Sleep button */
 		{"", 0},
 	};
 	struct acpi_device_wakeup *wakeup = &device->wakeup;
@@ -1022,15 +1018,9 @@ static bool acpi_wakeup_gpe_init(struct acpi_device *device)
 
 	wakeup->flags.notifier_present = 0;
 
-	/* Power button, Lid switch always enable wakeup */
 	match = acpi_match_acpi_device(button_device_ids, device);
-	if (match) {
-		if ((match->driver_data & ACPI_AVOID_WAKE_FROM_S5) &&
-		    wakeup->sleep_state == ACPI_STATE_S5)
-			wakeup->sleep_state = ACPI_STATE_S4;
-		acpi_mark_gpe_for_wake(wakeup->gpe_device, wakeup->gpe_number);
-		return true;
-	}
+	if (match && wakeup->sleep_state == ACPI_STATE_S5)
+		wakeup->sleep_state = ACPI_STATE_S4;
 
 	status = acpi_setup_gpe_for_wake(device->handle, wakeup->gpe_device,
 					 wakeup->gpe_number);
-- 
2.53.0



