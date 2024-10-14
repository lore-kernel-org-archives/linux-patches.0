Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F51AB6E9;
	Mon, 14 Oct 2024 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919598; cv=none; b=ofrcl4UCf9LBlNCJZEwEjlLD7221s83vv6IZWUkGcvDvD8rhJLuVgrAXRODQqj/b0KSnqq3lVvW5fNIoDq6e23FcVvYDMjPEpJzVshQGPOFZNKicHi91pRR2dR2QhkNZYfbLmPNDKt5PF48a87vjypDzkIwqBHV2i9QBDGgrhQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919598; c=relaxed/simple;
	bh=jWmbwQM9SKeFyD+rp7UgHg7u0SA3H55+DLfcBJSg87A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHiizUZweL4lkvh2vmWOBH/E3VyhqZuFP6fLVW+HV00lYPvaNcJFk0n0E9eDtG+4dNMZTMQPqOc6zKWzO4ojH4xhfuMODk6hg69e5+es7+bRQj3Y1p2XOpXR0UrYNy4ZJ7A9OOXqiX2UjpohWcm4dhaeCN5m/Jd7WlP1NcdGYZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN/b4fxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN/b4fxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7F9C4CEC3;
	Mon, 14 Oct 2024 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919598;
	bh=jWmbwQM9SKeFyD+rp7UgHg7u0SA3H55+DLfcBJSg87A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN/b4fxW/5QcFb9SRFaWScxLEHtbci37lDVxrtux3HTTIqN9W/oOrMKj7XLBK5Ljr
	 0P3FiexqdS0gfCUIhj+3aMRF0PHhWoxYVBEDetZzmGmBmNFtz44ZlrUnS4Gc8frPen
	 p3KOBNQKoV/OMrJi5CXmVI+WdLHA5oYe6RbOHZKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 652/798] ACPI: battery: Fix possible crash when unregistering a battery hook
Date: Mon, 14 Oct 2024 16:20:06 +0200
Message-ID: <20241014141243.666232291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 59d38c6e45d83..5a4e022662417 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -703,7 +703,7 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
 	list_for_each_entry(battery, &acpi_battery_list, list) {
 		hook->remove_battery(battery->bat);
 	}
-	list_del(&hook->list);
+	list_del_init(&hook->list);
 
 	pr_info("extension unregistered: %s\n", hook->name);
 }
@@ -711,7 +711,14 @@ static void battery_hook_unregister_unlocked(struct acpi_battery_hook *hook)
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
@@ -721,7 +728,6 @@ void battery_hook_register(struct acpi_battery_hook *hook)
 	struct acpi_battery *battery;
 
 	mutex_lock(&hook_mutex);
-	INIT_LIST_HEAD(&hook->list);
 	list_add(&hook->list, &battery_hook_list);
 	/*
 	 * Now that the driver is registered, we need
-- 
2.43.0



