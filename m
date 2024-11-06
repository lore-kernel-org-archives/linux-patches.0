Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61851DED58;
	Wed,  6 Nov 2024 12:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895459; cv=none; b=pt6oQxEJTRdSl8fv1HBSgM2i/P8L+QT3/wgtZJ0N06CPU1jQfxRmdZJeOIq2u+mNW3PWJRy9pxa+Rafb8nHJmI0mq2lPwBJ0zZnAXsozPm4FB1Rtkkkd0RNDdjbrTD6mMNxh/SH40e2lt0ZnPxYXj3QRaMQTMhe+8nLvoAHV6qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895459; c=relaxed/simple;
	bh=Sg5wDMnB/LRpqs6QwAWQ9kjqTDNQ7iOX/O5ASsv/UoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBF1H20I7+LCslmhAgkhCQx93ear7he4zyrsZX8SPVMiZeSXnf4CfaC+X4Icxa87OBGT/a09Q/xqmd4qwqtO3J1yK1TLvHaXlHE9jwWrSQNQPWkYodshh20lQmu30xw55HT9j53j8kyPsqq/u0+nEJ1RqevuTMqPFSTCK+peJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OThhtx1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OThhtx1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C45EC4CED3;
	Wed,  6 Nov 2024 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895459;
	bh=Sg5wDMnB/LRpqs6QwAWQ9kjqTDNQ7iOX/O5ASsv/UoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OThhtx1o3sFlmkZAfhmpnL0LJPDKhNnDRac/QhqjsPSPizJZ7c0+40nUDhPVkynn3
	 /fSSdokyTmFnguMxQ+EEvD6Hn8aOA8vT4Z0azYtpKHe91rvQUVyT+EOMyBIygME8dE
	 b4ZFrIgCNzTbRisDaBx1hEpgTQh+FSdcAgRzJGjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 226/350] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Wed,  6 Nov 2024 13:02:34 +0100
Message-ID: <20241106120326.573327650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b741ed87ab3db..46aa0e5e6f8b6 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -724,7 +724,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		hook->remove_battery(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -732,7 +732,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
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
@@ -742,7 +749,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



