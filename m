Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42321F7094;
	Tue,  3 Dec 2024 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237897; cv=none; b=gJEQbKEfPNIyFeNM6FIoCX9Mg9KwJsWfHB5qvIxUT4gSIGo/KzsYuM6TuAK3kb8t5GjAVL3R7EfUhuiYZi5fliAqxwZ7wzEfV1wixG9OVPAABbCxQDzYZrcC8DphsVOQGkFH84zAtQnN4WEFcNtDcilhQhIa4PA1fQk0JMrvr0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237897; c=relaxed/simple;
	bh=A5cOJ74lujhUMQPNL5CRylSkjx9r39DnuxaoJnWbMzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgDPkdO5gbeKNAzq8Skb8Gf76vWqhsfAH23qQwFdTlnPJkVA2Ragt5TD9OeDJauFH8RLRn0RVjotrY2wrW41kQPrwzGQ+l157uwI86jbJxJpXewJoowvQFEa9+91fcdKST3SGkBOpn2QTrlFoDFqiPxmvx8kunuRg8i3XYM2Mps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABBOErrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABBOErrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35953C4CECF;
	Tue,  3 Dec 2024 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237897;
	bh=A5cOJ74lujhUMQPNL5CRylSkjx9r39DnuxaoJnWbMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABBOErrCETCopDVZw5tot/7hsi9o695WyXnnAwSd4dBRhvwjN//iLnQxIWJbOeIKD
	 Bpg3W01lgrvOoZkIFdhEwIe8vWSFczc7/tF8pwT8CLGDokxk6zPQBCWNniK5IPuTbn
	 943+GVzAmG930IsjL24AO/X1tVBwi+F1x342ScMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 099/817] thermal: core: Drop thermal_zone_device_is_enabled()
Date: Tue,  3 Dec 2024 15:34:31 +0100
Message-ID: <20241203143959.570132252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 54fccad63ec88924db828df6fc0648930bccf345 ]

There are only two callers of thermal_zone_device_is_enabled()
and one of them call is under the zone lock and the other one uses
lockdep_assert_held() on that lock.  Thus the lockdep_assert_held()
in thermal_zone_device_is_enabled() is redundant and it could be
dropped, but then the function would merely become a wrapper around
a simple tz->mode check that is more convenient to do directly.

Accordingly, drop thermal_zone_device_is_enabled() altogether and update
its callers to check tz->mode directly as appropriate.

While at it, combine the tz->mode and tz->suspended checks in
__thermal_zone_device_update() because they are of a similar category
and if any of them evaluates to "true", the outcome is the same.

No intentinal functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/9353673.CDJkKcVGEf@rjwysocki.net
Stable-dep-of: 7837fa8115e0 ("thermal: core: Mark thermal zones as initializing to start with")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c  | 12 +-----------
 drivers/thermal/thermal_core.h  |  3 ---
 drivers/thermal/thermal_sysfs.c |  2 +-
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 2f9128cf55e92..468a0dae8c497 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -553,10 +553,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 	LIST_HEAD(way_up_list);
 	int temp, ret;
 
-	if (tz->suspended)
-		return;
-
-	if (!thermal_zone_device_is_enabled(tz))
+	if (tz->suspended || tz->mode != THERMAL_DEVICE_ENABLED)
 		return;
 
 	ret = __thermal_zone_get_temp(tz, &temp);
@@ -651,13 +648,6 @@ int thermal_zone_device_disable(struct thermal_zone_device *tz)
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_disable);
 
-int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
-{
-	lockdep_assert_held(&tz->lock);
-
-	return tz->mode == THERMAL_DEVICE_ENABLED;
-}
-
 static bool thermal_zone_is_present(struct thermal_zone_device *tz)
 {
 	return !list_empty(&tz->node);
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 57fff8bd57611..e93a7641736ed 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -293,7 +293,4 @@ thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
 				    unsigned long new_state) {}
 #endif /* CONFIG_THERMAL_STATISTICS */
 
-/* device tree support */
-int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
-
 #endif /* __THERMAL_CORE_H__ */
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index d628dd67be5cc..21f73a230c53e 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -53,7 +53,7 @@ mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 	int enabled;
 
 	mutex_lock(&tz->lock);
-	enabled = thermal_zone_device_is_enabled(tz);
+	enabled = tz->mode == THERMAL_DEVICE_ENABLED;
 	mutex_unlock(&tz->lock);
 
 	return sprintf(buf, "%s\n", enabled ? "enabled" : "disabled");
-- 
2.43.0



