Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100091B21BF;
	Tue, 15 Oct 2024 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998291; cv=none; b=Git7AUCKtcBureOyyKR6Dz8JvLcKRvMRIlrnq8nZ/v6wtXeXQqHGNUlRfT1w4ogz9eQg+/cIlyFKi9cu+MfX3bEuLvqBxORlqBQFCFcE/slrwXMEN87qZGfrkkcK2761DSEo7FAuFvcrnxBfISxVvaTLCf5YT1WLMG3iJ4O3MF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998291; c=relaxed/simple;
	bh=VPzohDqSMbCZHvpd2V8egzQ+H+JcKolFYKD8bjddfVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4LW15h7qqExMjueDH9KwpC+IpSsgVcY0JqCQNz4w7Lpnn4sjp+RWsuFPG6T2chSIM1nJ8O2KvjUgeNEhu+wNg284DEmNGq23/Oh/+Aqo95FC2o1zC3TMWQvdIHr3EUeSFZnrrXx0Ofqhdt3nYRkXktkWfQbCyl4btWolDSv7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Utj+cfxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Utj+cfxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5E1C4CEC6;
	Tue, 15 Oct 2024 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998290;
	bh=VPzohDqSMbCZHvpd2V8egzQ+H+JcKolFYKD8bjddfVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Utj+cfxh5apUTa/L+3SebT+FkewYWQ+Ex1KOW/0doArwdMG8Xxv3GJZYHf+bdB28d
	 UsBA/kSOrGvQuHTOPPa5sawDEjAywE/YaDR+LPwCs/lL4CALPeOItAukBkhCke5SbI
	 4uDbvHcKlBMdtwYE5+vDooJW1ThUtXMl+pYHbLpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/518] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Tue, 15 Oct 2024 14:45:37 +0200
Message-ID: <20241015123933.710377950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d6ad6be58f4a..f9fb092f33a26 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -706,7 +706,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		hook->remove_battery(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -714,7 +714,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
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
@@ -724,7 +731,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



