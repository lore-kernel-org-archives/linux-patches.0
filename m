Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F41F666D;
	Wed,  6 Nov 2024 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898606; cv=none; b=mZN3Zp4j2y1IfprdFOQIOqkJKbAS8JaU24FjIDgaRqJLp1tT3CGyHPfgeRTNoiCaaWJjyzsh1Ghc/kOugjEfiR9XqwHrPlXX3Cz3t67KHMEW9p1jT0xrQBaVOKuauxTgbQQ9AgllHFWfYeO9GiIPLZWJlkU/5ryQfo8dVfSA5rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898606; c=relaxed/simple;
	bh=hnv8c0t2mJ5Sc+EtWWFMTUlc7F4ckS2+pgPwFSpUeLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nd5J1+9T8LY2dXWJ7iX8oe5rKkr1U+oZ3nJqMlml5BO/CBjzP+mS5ThRIMBqb8oa1JXYSNrUg1x51vGavov9/akC8wC44IQCMaJRli9El3jNwpSxmuK/qIoUnryDT6jjwuJ+dgrMHEwYPY3p6+dLRG9arhmTH7wFcCjW0jjnB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7FQdPf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7FQdPf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E688C4CECD;
	Wed,  6 Nov 2024 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898606;
	bh=hnv8c0t2mJ5Sc+EtWWFMTUlc7F4ckS2+pgPwFSpUeLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7FQdPf9GRpDuCiq/9PFeUsbVBQ0w0x8kVNbIlmDN1JX1Q5Dz6EXTTgPOjuERGkqr
	 gDTFpSs8GL9cey2+GuEou3JPJXrbrLeLl/bvUfGzNtv97ChLLwwGn/+xlOP5Fxf8VH
	 q1pgzbl16Tdfi5il6gT4yHfLrz8xdJoyuYmtv4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/462] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Wed,  6 Nov 2024 13:03:07 +0100
Message-ID: <20241106120338.786103328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6c45d183213ed..cf853e985d6d9 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -717,7 +717,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		hook->remove_battery(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -725,7 +725,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
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
@@ -735,7 +742,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



