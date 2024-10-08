Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737771C5793;
	Tue,  8 Oct 2024 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392948; cv=none; b=DmcPkmePrVw+LxcngSHYKHKM5IeOXFhZgabSMdjPW/G9gE7EsQrcFfSa+3IKExbsJ8j6xz2eNpjDk03sWTn6GcrDIo74LnRjL8ZxE2JVRVLUZ+RW4AUbD7FBMwALbAa3hCysMhghFfuyIj/vr2E7IOSm8Rxl/zaicUbdl+nE93E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392948; c=relaxed/simple;
	bh=75DqsOUw50RkHhhmVdFJ/83rzyjeO8JXlI6Dvp9pWMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU4ti8E8AD6JULiQ76eQzknA+wsTWhdtdZlqEPQYb55wwHXt4X/X4IubVRxKV4ve5dZErIyDwdqXlhI/BnSQc7HVgVcYr5RnR3w+Yb95MOUScp9KHH+ppnH4fwhUGXWaK9S8Ox8Z5WB/yPW++gU8WAZ2iN7CSd03zpD/JiBUuYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De675ae9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De675ae9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8767FC4CEC7;
	Tue,  8 Oct 2024 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392948;
	bh=75DqsOUw50RkHhhmVdFJ/83rzyjeO8JXlI6Dvp9pWMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De675ae919IZxfQjmqpxIbasPsZsRIO5YrZnlKE7EV9I29FMTLACo3jaMGjY8nUNb
	 Ae15rgPELvmmDq2u3FqvUXQvHjSK1doK7JIjr6SDzWdU5t96jvophZtPF14bUNMa9N
	 SjwB4ck4Q8fm617bGY5SPghjyAtIHUu7f5jlGjkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 544/558] ACPI: battery: Simplify battery hook locking
Date: Tue,  8 Oct 2024 14:09:34 +0200
Message-ID: <20241008115723.641977756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 86309cbed26139e1caae7629dcca1027d9a28e75 ]

Move the conditional locking from __battery_hook_unregister()
into battery_hook_unregister() and rename the low-level function
to simplify the locking during battery hook removal.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20241001212835.341788-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 76959aff14a0 ("ACPI: battery: Fix possible crash when unregistering a battery hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index da3a879d638a8..10e9136897a75 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -706,28 +706,28 @@ static LIST_HEAD(acpi_battery_list);
 static LIST_HEAD(battery_hook_list);
 static DEFINE_MUTEX(hook_mutex);
 
-static void __battery_hook_unregister(struct acpi_battery_hook *hook, int lock)
+static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 {
 	struct acpi_battery *battery;
+
 	/*
 	 * In order to remove a hook, we first need to
 	 * de-register all the batteries that are registered.
 	 */
-	if (lock)
-		mutex_lock(&hook_mutex);
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		if (!hook->remove_battery(battery->bat, hook))
 			power_supply_changed(battery->bat);
 	}
 	list_del(&hook->list);
-	if (lock)
-		mutex_unlock(&hook_mutex);
+
 	pr_info("extension unregistered: %s\n", hook->name);
 }
 
 void battery_hook_unregister(struct acpi_battery_hook *hook)
 {
-	__battery_hook_unregister(hook, 1);
+	mutex_lock(&hook_mutex);
+	battery_hook_unregister_unlocked(hook);
+	mutex_unlock(&hook_mutex);
 }
 EXPORT_SYMBOL_GPL(battery_hook_unregister);
 
@@ -753,7 +753,7 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 			 * hooks.
 			 */
 			pr_err("extension failed to load: %s", hook->name);
-			__battery_hook_unregister(hook, 0);
+			battery_hook_unregister_unlocked(hook);
 			goto end;
 		}
 
@@ -807,7 +807,7 @@ static void battery_hook_add_battery(struct acpi_battery *battery)
 			 */
 			pr_err("error in extension, unloading: %s",
 					hook_node->name);
-			__battery_hook_unregister(hook_node, 0);
+			battery_hook_unregister_unlocked(hook_node);
 		}
 	}
 	mutex_unlock(&hook_mutex);
@@ -840,7 +840,7 @@ static void __exit battery_hook_exit(void)
 	 * need to remove the hooks.
 	 */
 	list_for_each_entry_safe(hook, ptr, &battery_hook_list, list) {
-		__battery_hook_unregister(hook, 1);
+		battery_hook_unregister(hook);
 	}
 	mutex_destroy(&hook_mutex);
 }
-- 
2.43.0



