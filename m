Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84C190055;
	Tue,  8 Oct 2024 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394234; cv=none; b=ozq8rhuW2lsgPiqwIT9yOblvF6uBoIUCSgmkuLo0RkMdVAw4CgThHS+dfNU+ZWi306FmbPzzXZT3aBU93VwYRexr4pYQpLASc/saV7tUtZJ3GyixVyDv+k8W41/M+bza4vSOHCCHSXuGEl1bcSL60mzEls9u+byFs1KiJhYjhhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394234; c=relaxed/simple;
	bh=TI3VhaIHlilJ41LjmmiVEoEiY6edYv8ZeLny1UehKX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wxkmkl9tBkh1c58lpHCve5mFDdDXSZGPg3kinStSJG6Z9Ll+WlkyOMxe2ZcNuSUpKSNXp3QMzbs2iqvI9CHif9hNRRzAwvSDx+lchyM/KKOCESXhuMmN9GX2wops+xcJK4udw9olMWgsyz5cstVi7gv7e3GWHRJSPsi+aK36ZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuJej19t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuJej19t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962F1C4CECC;
	Tue,  8 Oct 2024 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394234;
	bh=TI3VhaIHlilJ41LjmmiVEoEiY6edYv8ZeLny1UehKX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuJej19tRruG3FdH58d21hnVGg4z2NbsQLY07B8L05VRc8jhasfyI9BmR5b8RsayH
	 pDUkeUGUg6YVff8tyXspSJRaz3VZn+uyBMAlUyKC7qEWsf7o1QZug1Ijaydo2sCKUY
	 DVojgYEU1uMCvvuK84RV+Xugl9ySLZ3DDCUdZuq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/386] ACPI: battery: Simplify battery hook locking
Date: Tue,  8 Oct 2024 14:10:06 +0200
Message-ID: <20241008115643.588725287@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7f7ad94f22b91..a14852b612bba 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -703,28 +703,28 @@ static LIST_HEAD(acpi_battery_list);
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
 
@@ -750,7 +750,7 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 			 * hooks.
 			 */
 			pr_err("extension failed to load: %s", hook->name);
-			__battery_hook_unregister(hook, 0);
+			battery_hook_unregister_unlocked(hook);
 			goto end;
 		}
 
@@ -789,7 +789,7 @@ static void battery_hook_add_battery(struct acpi_battery *battery)
 			 */
 			pr_err("error in extension, unloading: %s",
 					hook_node->name);
-			__battery_hook_unregister(hook_node, 0);
+			battery_hook_unregister_unlocked(hook_node);
 		}
 	}
 	mutex_unlock(&hook_mutex);
@@ -822,7 +822,7 @@ static void __exit battery_hook_exit(void)
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



