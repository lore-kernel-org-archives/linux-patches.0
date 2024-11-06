Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0BF1DF252;
	Wed,  6 Nov 2024 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895457; cv=none; b=cDh0c4UC6dhTkb4QZ92Ncvy1Tf6dgykTfEBTZYeqWD9yWDhtiQB6IhacsAeYIoolEiMKVAWvatZKTNVBSz+s2JPnwgoesAPiCEPQZYYXawoikGgzdyXULSuvTxmhjmddn0jul1CYroQA7nyjhQCcUu7cC55xiw7a4JxaPM3YlN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895457; c=relaxed/simple;
	bh=YUcax+c7OSxpd+bFmEOpc8bX7LAQ7dXo8BjkdccrH6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IciWYEhCzhxR7wjAgP/oWmXtlgr5W2iD8CSN+2zGHl6Bp3gertKck2RfoI4xIsZTgiVWv8yhnkdPO6/i1XP2PHKjM1k0bc+o1c+vBQz0iFQXgVt4AGDuOsrDkdqBdJFCT9c3ZOWyXpuBxLf/JsNnmEV291jkEH06w6GLkowMZic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKxgs+Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKxgs+Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB62C4CECD;
	Wed,  6 Nov 2024 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895456;
	bh=YUcax+c7OSxpd+bFmEOpc8bX7LAQ7dXo8BjkdccrH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKxgs+AfyuUmN5wVqeAkVAypglM9RJZBP/0zVxp1PTlFj/dSVBZGmiAm5nZMLs9eQ
	 XB6/vO7qJyOsRU4hBkiu6vGQIhMT2bS3KJIOKogmlfPw+upAzEClyXhz0JY/1ZlJ6j
	 Lui2fzUXFXxQtG7ZTYJcAeo+b1V+CJWfYapR67gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/350] ACPI: battery: Simplify battery hook locking
Date: Wed,  6 Nov 2024 13:02:33 +0100
Message-ID: <20241106120326.550783162@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 88f4040d6c1f2..b741ed87ab3db 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -713,27 +713,27 @@ static LIST_HEAD(acpi_battery_list);
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
 		hook->remove_battery(battery->bat);
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
 
@@ -759,7 +759,7 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 			 * hooks.
 			 */
 			pr_err("extension failed to load: %s", hook->name);
-			__battery_hook_unregister(hook, 0);
+			battery_hook_unregister_unlocked(hook);
 			goto end;
 		}
 	}
@@ -796,7 +796,7 @@ static void battery_hook_add_battery(struct acpi_battery *battery)
 			 */
 			pr_err("error in extension, unloading: %s",
 					hook_node->name);
-			__battery_hook_unregister(hook_node, 0);
+			battery_hook_unregister_unlocked(hook_node);
 		}
 	}
 	mutex_unlock(&hook_mutex);
@@ -829,7 +829,7 @@ static void __exit battery_hook_exit(void)
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



