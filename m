Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0614C97;
	Tue, 11 Nov 2025 00:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822701; cv=none; b=WQQYJiZl4H3d1pQeCMhyoFHugpQZIvMGSFuLzeW7JA72o8lYOs+f1qA63syKAbUGbQy/nQyPns6I7b2rpvP3flysY7oD2g/bIsMY4qXkxo2h4RrreSqX8nk9PcvcRt0KrmOPY86FzdZuZzWTZXaTUaUXzDW0q61JS8GUQdoFlqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822701; c=relaxed/simple;
	bh=IomGVz87cm44dirXA3Ch8Z8pqyE8FVD/SaKlbQY6rNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aev7w1R9/z8xkHL3RUC2sKfCn/y+6IC0fgiH4VeuNQ9fcOznCcYN3KESJgL69Jwi+Ho78QZmAokGXCOhKXudKTfXBm3R7iAl+AHroBlzlgoPRqMl6ribCVtkfOi03PGiZnCb6svMzfTRje0g8HXYcUbY4QuRFR8uO9a+lihNYI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyr+KTMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyr+KTMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FA3C19425;
	Tue, 11 Nov 2025 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822701;
	bh=IomGVz87cm44dirXA3Ch8Z8pqyE8FVD/SaKlbQY6rNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyr+KTMZqoI5F85+V4lKyVAWYLHLUQoUDUHVGz6RgW62w4iYzidpYtUgnC6tXZ/6m
	 UHGGaS353Ms8EQsYb2N6ODKIUEmD/8F6USv4Ck6MON0um4r95xxR+TJMjVnYWTyhPj
	 2ZIiSHvdF1/+4B4inP17JDgcXU0DwDLa3vTEy7Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 151/849] thermal: gov_step_wise: Allow cooling level to be reduced earlier
Date: Tue, 11 Nov 2025 09:35:21 +0900
Message-ID: <20251111004540.074020205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2e82368359f63567862a0d438710ddffcb1ace83 ]

The current behavior of the Step-wise thermal governor is to increase
the cooling level one step at a time after trip point threshold passing
by thermal zone temperature until the temperature stops to rise.  Then,
nothing is done until the temperature decreases below the (possibly
updated) trip point threshold, at which point the cooling level is
reduced straight to the applicable minimum.

While this generally works, it is not in agreement with the throttling
logic description comment in step_wise_manage() any more after some
relatively recent changes, and in the case of passive cooling, it may
lead to undesirable performance oscillations between high and low
levels.

For this reason, modify the governor's cooling device state selection
function, get_target_state(), to reduce cooling by one level even if
the temperature is still above the thermal zone threshold, but the
temperature has started to fall down.  However, ensure that the cooling
level will remain above the applicable minimum in that case to pull
the zone temperature further down, possibly until it falls below the
trip threshold (which may now be equal to the low temperature of the
trip).

Doing so should help higher performance to be restored earlier in some
cases which is desirable especially for passive trip points with
relatively high hysteresis values.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/1947735.tdWV9SEqCh@rafael.j.wysocki
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_step_wise.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_step_wise.c b/drivers/thermal/gov_step_wise.c
index d1bb59f1dfbd3..b7938bddd9a6a 100644
--- a/drivers/thermal/gov_step_wise.c
+++ b/drivers/thermal/gov_step_wise.c
@@ -20,7 +20,9 @@
  * If the temperature is higher than a trip point,
  *    a. if the trend is THERMAL_TREND_RAISING, use higher cooling
  *       state for this trip point
- *    b. if the trend is THERMAL_TREND_DROPPING, do nothing
+ *    b. if the trend is THERMAL_TREND_DROPPING, use a lower cooling state
+ *       for this trip point, but keep the cooling state above the applicable
+ *       minimum
  * If the temperature is lower than a trip point,
  *    a. if the trend is THERMAL_TREND_RAISING, do nothing
  *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
@@ -51,6 +53,17 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 	if (throttle) {
 		if (trend == THERMAL_TREND_RAISING)
 			return clamp(cur_state + 1, instance->lower, instance->upper);
+
+		/*
+		 * If the zone temperature is falling, the cooling level can
+		 * be reduced, but it should still be above the lower state of
+		 * the given thermal instance to pull the temperature further
+		 * down.
+		 */
+		if (trend == THERMAL_TREND_DROPPING)
+			return clamp(cur_state - 1,
+				     min(instance->lower + 1, instance->upper),
+				     instance->upper);
 	} else if (trend == THERMAL_TREND_DROPPING) {
 		if (cur_state <= instance->lower)
 			return THERMAL_NO_TARGET;
-- 
2.51.0



