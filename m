Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B4B1A840E;
	Wed,  5 Mar 2025 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198130; cv=none; b=bJ4np1aPrgVpSiQHf/FEpedRAx+DI06SjAyWuiu8vCjBxNN77aQtWkTsVuYmPN8mia1GbHCK2NflRsah55Wizqi3N0Fu0rksPPOlPEY0+QWC9+WaehMbmHXuXxn9YN5P+bYMobQO+qOferl5gl45z3P4r/AIoEJbLR6J0WvMd48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198130; c=relaxed/simple;
	bh=BTiBWzMjcdd+Hgz6MLpqxM0+E86lWL/oc7vTw3IW8tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7jq3CDvack6lueKjmEOw4vI3UDU/FAKyTPjMAdXh5u8O2e/stAZxR2a0EdcItCyJLPRK9k/Jq6/8OMGtoWIy8Wzb5adrNolHqqPrwz8Mt7fJU2uOT2pHLZgFdOvXQQGzc9jibzSjiyE4oHf/hAaYZ/xoQyfulDWQKR8sS1VGHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZzYSbX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZzYSbX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEEBC4CED1;
	Wed,  5 Mar 2025 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198129;
	bh=BTiBWzMjcdd+Hgz6MLpqxM0+E86lWL/oc7vTw3IW8tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZzYSbX376dO6LbVL90jOIAV9F+cDe8NFk5aWGIk23uDP3diSJBkXcSUd/W/qvk50
	 pugPIMid8D2qPRSFAGWww2jpXEo4k4s80YGPg+mJ9ZSmO2clkx1y/rThNmr75uJ8pU
	 wtO/CsVZF4zkp4PeD7QdZV6Ef9AWTVpYQDqZvrTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/150] thermal: gov_power_allocator: Update total_weight on bind and cdev updates
Date: Wed,  5 Mar 2025 18:48:22 +0100
Message-ID: <20250305174506.749259494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Che Cheng <giver@chromium.org>

[ Upstream commit 0cde378a10c1cbfaa8dd2b89672d42f36c2809c3 ]

params->total_weight is not initialized during bind and not updated when
the bound cdev changes. The cooling device weight will not be used due
to the uninitialized total_weight, until an update via sysfs is
triggered.

The bound cdevs are updated during thermal zone registration, where each
cooling device will be bound to the thermal zone one by one, but
power_allocator_bind() can be called without an additional cdev update
when manually changing the policy of a thermal zone via sysfs.

Add a new function to handle weight update logic, including updating
total_weight, and call it when bind, weight changes, and cdev updates to
ensure total_weight is always correct.

Fixes: a3cd6db4cc2e ("thermal: gov_power_allocator: Support new update callback of weights")
Signed-off-by: Yu-Che Cheng <giver@chromium.org>
Link: https://patch.msgid.link/20250222-fix-power-allocator-weight-v2-1-a94de86b685a@chromium.org
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 30 ++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index b00da17c66a90..8117959dc6c42 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -630,6 +630,22 @@ static int allocate_actors_buffer(struct power_allocator_params *params,
 	return ret;
 }
 
+static void power_allocator_update_weight(struct power_allocator_params *params)
+{
+	const struct thermal_trip_desc *td;
+	struct thermal_instance *instance;
+
+	if (!params->trip_max)
+		return;
+
+	td = trip_to_trip_desc(params->trip_max);
+
+	params->total_weight = 0;
+	list_for_each_entry(instance, &td->thermal_instances, trip_node)
+		if (power_actor_is_valid(instance))
+			params->total_weight += instance->weight;
+}
+
 static void power_allocator_update_tz(struct thermal_zone_device *tz,
 				      enum thermal_notify_event reason)
 {
@@ -645,16 +661,12 @@ static void power_allocator_update_tz(struct thermal_zone_device *tz,
 			if (power_actor_is_valid(instance))
 				num_actors++;
 
-		if (num_actors == params->num_actors)
-			return;
+		if (num_actors != params->num_actors)
+			allocate_actors_buffer(params, num_actors);
 
-		allocate_actors_buffer(params, num_actors);
-		break;
+		fallthrough;
 	case THERMAL_INSTANCE_WEIGHT_CHANGED:
-		params->total_weight = 0;
-		list_for_each_entry(instance, &td->thermal_instances, trip_node)
-			if (power_actor_is_valid(instance))
-				params->total_weight += instance->weight;
+		power_allocator_update_weight(params);
 		break;
 	default:
 		break;
@@ -720,6 +732,8 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 
 	tz->governor_data = params;
 
+	power_allocator_update_weight(params);
+
 	return 0;
 
 free_params:
-- 
2.39.5



