Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BFF14388D;
	Tue, 23 Apr 2024 21:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908497; cv=none; b=ao46tEaUuyvQgJyL/9LNWyBMUJOnp27cu4lXTpF/KZP/DjLjUSmDkFxopZ50DulDrM6XaVs8gwb9k08ftOMMyWHt4m4eh+BN4PSXr9Xni82DTcRJ+D6zDS98sWfN2vODRvNi4aAbwBC4MS2F4UsL9TWVsQFhoINLBOnXyz0SmGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908497; c=relaxed/simple;
	bh=ecFnaapH1Dva+3bYLXkVaTjeyeOFnljScyNsH/AmVmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyoR1kbNVR9DI+vhDGEMkZZChGBpXyYG+ePCTgvBWBU09QRUNyPBVKrrP3EH8d9UtTfpQEU6Vf2tfDAYKIbFYG4EdL8EDmCYrMbUTb0kh9nlW6uCpGdMZ6X2k2BQQSBw9obbhJFo2+6L/hDhHFy7OUEc7YAQrMUYowdB656ncpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDC+TILX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDC+TILX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092CDC3277B;
	Tue, 23 Apr 2024 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908497;
	bh=ecFnaapH1Dva+3bYLXkVaTjeyeOFnljScyNsH/AmVmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDC+TILX1mRAy4orTy/+j4IdFRpo5ZoIv6IPvl7oy2tU57RRwFswYueWaBwJp0XvM
	 YS06IfhlbCoTaRsB9Gftwzm4pGidxDfIhKBH9h5dP/bf1jR54/b183YKGViNEec2pJ
	 IHpGdqanZfNn2CKfCEjuuym5wTez6I34DuUBcK0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/158] thermal/debugfs: Add missing count increment to thermal_debug_tz_trip_up()
Date: Tue, 23 Apr 2024 14:38:16 -0700
Message-ID: <20240423213858.365596146@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b552f63cd43735048bbe9bfbb7a9dcfce166fbdd ]

The count field in struct trip_stats, representing the number of times
the zone temperature was above the trip point, needs to be incremented
in thermal_debug_tz_trip_up(), for two reasons.

First, if a trip point is crossed on the way up for the first time,
thermal_debug_update_temp() called from update_temperature() does
not see it because it has not been added to trips_crossed[] array
in the thermal zone's struct tz_debugfs object yet.  Therefore, when
thermal_debug_tz_trip_up() is called after that, the trip point's
count value is 0, and the attempt to divide by it during the average
temperature computation leads to a divide error which causes the kernel
to crash.  Setting the count to 1 before the division by incrementing it
fixes this problem.

Second, if a trip point is crossed on the way up, but it has been
crossed on the way up already before, its count value needs to be
incremented to make a record of the fact that the zone temperature is
above the trip now.  Without doing that, if the mitigations applied
after crossing the trip cause the zone temperature to drop below its
threshold, the count will not be updated for this episode at all and
the average temperature in the trip statistics record will be somewhat
higher than it should be.

Fixes: 7ef01f228c9f ("thermal/debugfs: Add thermal debugfs information for mitigation episodes")
Cc :6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index c617e8b9f0ddf..d78d54ae2605e 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -616,6 +616,7 @@ void thermal_debug_tz_trip_up(struct thermal_zone_device *tz,
 	tze->trip_stats[trip_id].timestamp = now;
 	tze->trip_stats[trip_id].max = max(tze->trip_stats[trip_id].max, temperature);
 	tze->trip_stats[trip_id].min = min(tze->trip_stats[trip_id].min, temperature);
+	tze->trip_stats[trip_id].count++;
 	tze->trip_stats[trip_id].avg = tze->trip_stats[trip_id].avg +
 		(temperature - tze->trip_stats[trip_id].avg) /
 		tze->trip_stats[trip_id].count;
-- 
2.43.0



