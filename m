Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203B01D0499;
	Wed,  2 Oct 2024 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877309; cv=none; b=U+mKmvbpF0VI3y8quj4aKKfO7VdW4NjtJhDteN0Um7u8zUq4Zrtjup7iVGS7ZdF5XTtoQGjfF8t6iLSVu8h2i5hnUuD6WvUusG3nsZg6zgRUYQZjmADQQd6igVD0nv3ZlyBxUUGc1SHdbuEug6VEBIUYzRgeYOWRjLohYVweMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877309; c=relaxed/simple;
	bh=UYmcXzp8B2aPWu6cUpJGKIvbFoS3E7oxHeUI9yFWwPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQhWzBa2nJhpXevyomkN6GA8lXjIEGkvIuQprIDmuWvZgpB61/zWCG00KFgLGrFdYJVbNBW3weNX3LX7oSu608toFSA2jd/ht4dtnoxT/bxY5MxU1gr/QK/jP4A5tNN7+H830T7HpXWvjOj6twH9LmH8YLLK7uBUblzUva37iko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiIHZmAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiIHZmAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E936C4AF1D;
	Wed,  2 Oct 2024 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877309;
	bh=UYmcXzp8B2aPWu6cUpJGKIvbFoS3E7oxHeUI9yFWwPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiIHZmAyDgjN5CVotT6Gzae2fACVIk919Y3idZy6tSO6TwESyVB4syUjfQe6yvije
	 Bu/Kdjx09FztFkrmHzKQxSuzMr6EsdFw7YkePtTL1mAl1mpaADhB295MDZSIlhnT3N
	 dLdCvCJHh+T6qs4Hy9fXsJDZHU2GFUF8+9mytuxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/634] thermal: core: Fix rounding of delay jiffies
Date: Wed,  2 Oct 2024 14:52:10 +0200
Message-ID: <20241002125812.286065359@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 8144dbe68c493baa412d78f41a57e90a6461f6c3 ]

Using round_jiffies() in thermal_set_delay_jiffies() is invalid because
its argument should be time in the future in absolute jiffies and it
computes the result with respect to the current jiffies value at the
invocation time.  Fortunately, in the majority of cases it does not
make any difference due to the time_is_after_jiffies() check in
round_jiffies_common().

While using round_jiffies_relative() instead of round_jiffies() might
reflect the intent a bit better, it still would not be defensible
because that function should be called when the timer is about to be
set and it is not suitable for pre-computation of delay values.

Accordingly, drop thermal_set_delay_jiffies() altogether, simply
convert polling_delay and passive_delay to jiffies during thermal
zone initialization and make thermal_zone_device_set_polling() call
round_jiffies_relative() on the delay if it is greather than 1 second.

Fixes: 17d399cd9c89 ("thermal/core: Precompute the delays from msecs to jiffies")
Fixes: e5f2cda61d06 ("thermal/core: Move thermal_set_delay_jiffies to static")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/1994438.PYKUYFuaPT@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 99a8c06f6964d..d0e71698b3562 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -323,11 +323,15 @@ static void thermal_zone_broken_disable(struct thermal_zone_device *tz)
 static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 					    unsigned long delay)
 {
-	if (delay)
-		mod_delayed_work(system_freezable_power_efficient_wq,
-				 &tz->poll_queue, delay);
-	else
+	if (!delay) {
 		cancel_delayed_work(&tz->poll_queue);
+		return;
+	}
+
+	if (delay > HZ)
+		delay = round_jiffies_relative(delay);
+
+	mod_delayed_work(system_freezable_power_efficient_wq, &tz->poll_queue, delay);
 }
 
 static void thermal_zone_recheck(struct thermal_zone_device *tz, int error)
@@ -1327,13 +1331,6 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
 
-static void thermal_set_delay_jiffies(unsigned long *delay_jiffies, int delay_ms)
-{
-	*delay_jiffies = msecs_to_jiffies(delay_ms);
-	if (delay_ms > 1000)
-		*delay_jiffies = round_jiffies(*delay_jiffies);
-}
-
 int thermal_zone_get_crit_temp(struct thermal_zone_device *tz, int *temp)
 {
 	const struct thermal_trip_desc *td;
@@ -1470,8 +1467,8 @@ thermal_zone_device_register_with_trips(const char *type,
 		td->threshold = INT_MAX;
 	}
 
-	thermal_set_delay_jiffies(&tz->passive_delay_jiffies, passive_delay);
-	thermal_set_delay_jiffies(&tz->polling_delay_jiffies, polling_delay);
+	tz->polling_delay_jiffies = msecs_to_jiffies(polling_delay);
+	tz->passive_delay_jiffies = msecs_to_jiffies(passive_delay);
 	tz->recheck_delay_jiffies = THERMAL_RECHECK_DELAY;
 
 	/* sys I/F */
-- 
2.43.0



