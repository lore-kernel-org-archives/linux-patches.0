Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F6E1E1A35;
	Tue, 15 Oct 2024 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994004; cv=none; b=jQvZKoqhwSTOPBGmR5CHCeHRJXI2m9f9QcMtHRP/XFyO5L0mP/IrbS4SyWuTYSooksFPFUbqhdpd1w90nI2OWMmb0yswcfo7WYtQGwpAMXEXbZhXK0OaZpKsA9uRE2/uLRRji3bdlosXGam2qMC2oZmokMixnoJBgu44xoYGnD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994004; c=relaxed/simple;
	bh=j8hgGJ+VpbjwKHWOgJWI3DdEqH6Z5lu5WjrHy9uGBKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALwkibw8tnxPikHtlma6gexqJ1MMs5CngPcqZYs6ENq76TN41GcLeBzxHbGAt373v0IWlyH1s6X6o/gvx1YloKhlBFVi/w03Lex/xntdMN3ZzhKpruJs9JG6MmNbEeAgi4TgW/S7xxEPdtGWAZIiux54VEEQP1ifXAmJdz/zcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btwbMe6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btwbMe6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37336C4CEC6;
	Tue, 15 Oct 2024 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994004;
	bh=j8hgGJ+VpbjwKHWOgJWI3DdEqH6Z5lu5WjrHy9uGBKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btwbMe6mjL8uIlvbpsYHZwawItwspX53FC3qDm2z4ddGDtWNf51HEjsPOGl75xSa9
	 w0+tnOqPknvnh7ivt26CqjAK6w3kjuVJmzyEjoaqWmFzOmo5S84IuXC6bzDM48VitZ
	 uII5ciw3ST9G+zfj0PIiGe3QNoxUonoMbldpBfwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 578/691] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Tue, 15 Oct 2024 13:28:46 +0200
Message-ID: <20241015112503.282076935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 76959aff14a0012ad6b984ec7686d163deccdc16 ]

When a battery hook returns an error when adding a new battery, then
the battery hook is automatically unregistered.
However the battery hook provider cannot know that, so it will later
call battery_hook_unregister() on the already unregistered battery
hook, resulting in a crash.

Fix this by using the list head to mark already unregistered battery
hooks as already being unregistered so that they can be ignored by
battery_hook_unregister().

Fixes: fa93854f7a7e ("battery: Add the battery hooking API")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20241001212835.341788-3-W_Armin@gmx.de
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6a8580427e1a9..8bb0f4d06adc0 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -712,7 +712,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		hook->remove_battery(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -720,7 +720,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 void battery_hook_unregister(struct acpi_battery_hook *hook)
 {
 	mutex_lock(&hook_mutex);
-	battery_hook_unregister_unlocked(hook);
+	/*
+	 * Ignore already unregistered battery hooks. This might happen
+	 * if a battery hook was previously unloaded due to an error when
+	 * adding a new battery.
+	 */
+	if (!list_empty(&hook->list))
+		battery_hook_unregister_unlocked(hook);
+
 	mutex_unlock(&hook_mutex);
 }
 EXPORT_SYMBOL_GPL(battery_hook_unregister);
@@ -730,7 +737,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



