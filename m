Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E36976021;
	Mon, 29 Jan 2024 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548617; cv=none; b=LFB9MISrdt6TADXVYYGepa40wSD+b9Yl7Sgsry8ypSZznCChLERP+a1Su6sIz9DbV/TefozhsccUImlNorMqwEGsHX9TwEqoBaYWdgl1A78TywloLxgd0P6vPTi6W4420ikSbJz5FrmE0BoNamcA50UsueXskHRgIT/f3R/YzuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548617; c=relaxed/simple;
	bh=3fTA6jl+Iucv4EFkHMTJS9gI30EdzQZ/O2kK6Jd/9GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvKIc4I1LjxqzBbxAF92Kv34cVQLyikh1oWMrvM+A5mvnyfj1XisBx2R59ADUTSdzrRPVyE4JUwpSuaOpyfwLuWLa1E63ezyBCE60KtGyKSFytS3vF57A4vZHU6l7dIg3X1GvQ4o9ZRiQoKWy988ESIptfZ3vX87aT6MjR3nI3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYNyhsQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYNyhsQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7B5C433F1;
	Mon, 29 Jan 2024 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548617;
	bh=3fTA6jl+Iucv4EFkHMTJS9gI30EdzQZ/O2kK6Jd/9GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYNyhsQ5ujw++c8G7r92IUMzTWRMPhV9A1Qifa0mOATXVW27fJMDPopN9cCaBmUPh
	 ArMtEGGSyYNnel/CRJs7Dfowbpr/LLlkWz9/Qo7sRRW742WK2p+1pZPklwP7UjbZ7+
	 PNs/GsV9XK1g4uuipRwk/YWnPAs6zOxlQMsr1L4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wang <wvw@google.com>,
	Di Shen <di.shen@unisoc.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/331] thermal: gov_power_allocator: avoid inability to reset a cdev
Date: Mon, 29 Jan 2024 09:05:49 -0800
Message-ID: <20240129170023.201884204@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Di Shen <di.shen@unisoc.com>

[ Upstream commit e95fa7404716f6e25021e66067271a4ad8eb1486 ]

Commit 0952177f2a1f ("thermal/core/power_allocator: Update once
cooling devices when temp is low") adds an update flag to avoid
triggering a thermal event when there is no need, and the thermal
cdev is updated once when the temperature is low.

But when the trips are writable, and switch_on_temp is set to be a
higher value, the cooling device state may not be reset to 0,
because last_temperature is smaller than switch_on_temp.

For example:
First:
switch_on_temp=70 control_temp=85;
Then userspace change the trip_temp:
switch_on_temp=45 control_temp=55 cur_temp=54

Then userspace reset the trip_temp:
switch_on_temp=70 control_temp=85 cur_temp=57 last_temp=54

At this time, the cooling device state should be reset to 0.
However, because cur_temp(57) < switch_on_temp(70)
last_temp(54) < switch_on_temp(70)  ---->  update = false,
update is false, the cooling device state can not be reset.

Using the observation that tz->passive can also be regarded as the
temperature status, set the update flag to the tz->passive value.

When the temperature drops below switch_on for the first time, the
states of cooling devices can be reset once, and tz->passive is updated
to 0. In the next round, because tz->passive is 0, cdev->state will not
be updated.

By using the tz->passive value as the "update" flag, the issue above
can be solved, and the cooling devices can be updated only once when the
temperature is low.

Fixes: 0952177f2a1f ("thermal/core/power_allocator: Update once cooling devices when temp is low")
Cc: 5.13+ <stable@vger.kernel.org> # 5.13+
Suggested-by: Wei Wang <wvw@google.com>
Signed-off-by: Di Shen <di.shen@unisoc.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 1faf55446ba2..fc969642f70b 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -715,7 +715,7 @@ static int power_allocator_throttle(struct thermal_zone_device *tz, int trip_id)
 
 	ret = __thermal_zone_get_trip(tz, params->trip_switch_on, &trip);
 	if (!ret && (tz->temperature < trip.temperature)) {
-		update = (tz->last_temperature >= trip.temperature);
+		update = tz->passive;
 		tz->passive = 0;
 		reset_pid_controller(params);
 		allow_maximum_power(tz, update);
-- 
2.43.0



