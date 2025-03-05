Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8B3178CC8;
	Wed,  5 Mar 2025 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198550; cv=none; b=rEA93aCM5nrPNewCtBFmJgqMljzzgpWYKfZGeJBoxXT8vvItJOMsj4ZoSL7VbkNu4vI42drHWNF9bwErJW3da5k/imfAcZZIyDaV1J7Iih9oTM70dEjTZ0b3Baeiw3p6XchFoLf0qthPv78ArohB3x36YT3uGQUmSyUWYl08pPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198550; c=relaxed/simple;
	bh=PfMItk1iJLts6B0FLOteZSFOv5oxfmMlsz1PAsu3ZEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK7NQPSM6tfS+oNS0syPVNqdQjARswuoHm9xGxTKNTsWZpOCmPDaQhJ45zYCh2ig8yrS6rTom2zhWHq09Z+KJMe90YrzOoGoDDLOSC14NfaovP6W0bk0HxMReP+b8gwazYUYryzNdomPs70vV8ud2oWUoi3tJiUJB3pvYC4KiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ef3H9xZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ef3H9xZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C9C4CED1;
	Wed,  5 Mar 2025 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198550;
	bh=PfMItk1iJLts6B0FLOteZSFOv5oxfmMlsz1PAsu3ZEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ef3H9xZUtSEvraLnig6JK0lKA53OtkuVvDg/UTfWUq2eLlKbcq/6e0kvmjmJIimJd
	 j0oFjgidrlUxvpD/fc6/zBZrWTxcS1T+qQpNzvcoUsgM0WRtTRuTBKRa+j3RDrnCP1
	 RN2yOLvJ5nqTP6R88+Htt8MuNELDETJEd5aJajVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 067/157] thermal: gov_power_allocator: Update total_weight on bind and cdev updates
Date: Wed,  5 Mar 2025 18:48:23 +0100
Message-ID: <20250305174507.996170433@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3b626db55b2b9..0d9f636c80f4d 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -641,6 +641,22 @@ static int allocate_actors_buffer(struct power_allocator_params *params,
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
@@ -656,16 +672,12 @@ static void power_allocator_update_tz(struct thermal_zone_device *tz,
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
@@ -731,6 +743,8 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 
 	tz->governor_data = params;
 
+	power_allocator_update_weight(params);
+
 	return 0;
 
 free_params:
-- 
2.39.5



