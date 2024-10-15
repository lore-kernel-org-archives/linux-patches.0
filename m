Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65461C57B1;
	Tue, 15 Oct 2024 12:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994001; cv=none; b=joVUrlCQrg6LGeprruNTHQTU8BOVDNuKQrle24qXQSLb6Rkw1dzBbOd+ZHdJQk4sVGdE1TTNrqmLm1AQ+Dthx0Jhto6lZfd1oPAlQh7k7Lh1rJ7dAS2NAtv2rdLl46ja28S7UkuYv63B0oA17wLLVb3mXV6zpezNUMPnXK6JONE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994001; c=relaxed/simple;
	bh=j/C6tqke5US5ImDyKAQgqlhftegz9sTvpAQ4fSQE9ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HN4ocCD4jXZnJD9XbRRn4otlrpBjnN7s32qIzEWOVDeH3Ua1ynx7Opkv5US4nEFUMGWvUWskuMH1QNibgfQFqd5XqevXt384lyIc1i6PYo59SYCdLCclWDjKzJ+DSm6hs2wIaBHNZx7SoXANQr6enJclybyFkZxcAQkmn1FQsUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNcOuswt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNcOuswt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8287C4CEC6;
	Tue, 15 Oct 2024 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994000;
	bh=j/C6tqke5US5ImDyKAQgqlhftegz9sTvpAQ4fSQE9ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNcOuswtrVlhqksXEtYZSb31w5QbOOnsTv4iAE0Dg5M+Jop6A7aEfM3Mpe9Y2nJpT
	 eRvm4OnQVPtuvA7WtpcAP4jI2CXt7X8D3zjDJIWIJepLPmsl4518u6YUV9k/M3a/Gk
	 zA7kQn967RhFbOM4h0OiUV2dU5qWqhed83hp6mLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 577/691] ACPI: battery: Simplify battery hook locking
Date: Tue, 15 Oct 2024 13:28:45 +0200
Message-ID: <20241015112503.241652289@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aed4132985a96..6a8580427e1a9 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -701,27 +701,27 @@ static LIST_HEAD(acpi_battery_list);
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
 
@@ -747,7 +747,7 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 			 * hooks.
 			 */
 			pr_err("extension failed to load: %s", hook->name);
-			__battery_hook_unregister(hook, 0);
+			battery_hook_unregister_unlocked(hook);
 			goto end;
 		}
 	}
@@ -784,7 +784,7 @@ static void battery_hook_add_battery(struct acpi_battery *battery)
 			 */
 			pr_err("error in extension, unloading: %s",
 					hook_node->name);
-			__battery_hook_unregister(hook_node, 0);
+			battery_hook_unregister_unlocked(hook_node);
 		}
 	}
 	mutex_unlock(&hook_mutex);
@@ -817,7 +817,7 @@ static void __exit battery_hook_exit(void)
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



