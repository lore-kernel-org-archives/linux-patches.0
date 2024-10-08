Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEF51DF98E;
	Tue,  8 Oct 2024 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394237; cv=none; b=FYozEGCgzGPZy6dtZGRcee5rbj64qm6BO/TuSbvOvdFdjTDLMi4zPfSAPHfNKfpYtNNC4qgglPjr+ZuiAhznmrLKwqK0VjUaURxjOFuzAsy+DzrYZByOt3xIiYAsIqkRDTODQrM1P6D9v95eR/aCu1ZXVBELfm2yHFDS510RDgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394237; c=relaxed/simple;
	bh=HWpjRNJmoVaqmn09j0m9oHKWI4sxVMPLEhS58bq3PoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpWYqw15s88Pybc2fDtL1BdODJF1sffv/b6JByvPs5G9eeYDt7K+o+lZOEoIsaVIqO1ZbS5mChl8jCq2V4X9fbktlXuGsFpOIZRXxV6aiR2rJmHT4fUnXYYekXuyv2p0+oORCbKja7DcorDZzAZzNAL1kYRVJEXvQnS6tsKdt5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtFTYTqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtFTYTqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27BAC4CEC7;
	Tue,  8 Oct 2024 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394237;
	bh=HWpjRNJmoVaqmn09j0m9oHKWI4sxVMPLEhS58bq3PoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtFTYTqVa34Onnb/jVWzMTmYLSn+uuQNj7Hbhh4o4dyAV/PbYwrS1O9zAbWm9B/yn
	 fWnnGKaGMVlwoDxnx9fIszpds8yGxeTsns1ieS6ZviqD7AZklPR2+q59Hr/qEt12ux
	 lAM+GlFtjRuVrE6g0hD17gDKcdJArOyl+3qi0AUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/386] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Tue,  8 Oct 2024 14:10:07 +0200
Message-ID: <20241008115643.627366357@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a14852b612bba..e3cbaf3c3bbc1 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -715,7 +715,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 		if (!hook->remove_battery(battery->bat, hook))
 			power_supply_changed(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -723,7 +723,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
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
@@ -733,7 +740,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



