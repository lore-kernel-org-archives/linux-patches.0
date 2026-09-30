Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C051597D;
	Wed, 30 Sep 2026 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787210; cv=none; b=pLevZqAz91IHFqeD20my4z7k89ODdYdNdUkh5aXNAfax980hRTX415o/rdUTCKcxpjVzo+rqDMUw/NItHwXCW+UntV8jLeX6Il00kTKEOqOp9y91vUhIZwejja1ogOg7Q0uENyuCmV4R0y9XV44t3buADHs8jwUWfSIi/W/A7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787210; c=relaxed/simple;
	bh=u4aEMfscLF3ZOcaViXeTKxiBPhqOwYiyIcNQTLxU1Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnf0X6AnEGW9m29lmIGwEl13bsSNHdO0GkBwbXMzbcsH4l4M/7IDuOBsxxHK7MLZi9LcXsCEIAgZpL5P4vYeCE1cRETIoeRTyGMX100q1CDwoBgLtRzua4Bv1ACXQOUFOeNhTBGAMbSOXi8PQFoFyixtXcguLnK/N7lVc/fUkPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpLNQF8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpLNQF8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C61F00898;
	Wed, 30 Sep 2026 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787208;
	bh=IIoG9af6CmdPcpHiYHu4Ksyf+qerkr6ZCMDjUkMzkCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpLNQF8JJdZCh6Kjjpo1x+kjjd0Ja5n1uSJseSj5LKPyL/6iaGmkRbbDlqWu6ekIb
	 gqgxAmv7sn7mValeoF4n797MR4a1gRRYRbzwP9ql5/hmBZ6KrmWGYM8/ZUwbGhTbUt
	 l+PCF4070YUaJ5Ys50ui8ACTTScebJYHX1Esu/DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 148/457] thermal: gov_step_wise: Fix stale mitigation vote with non-zero lower bounds
Date: Wed, 30 Sep 2026 17:24:13 +0200
Message-ID: <20260930152349.247045188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>

[ Upstream commit ec0d89150a9381d591344a9f6f5428655c227a7f ]

When two or more thermal zones bind to a common cooling device and one zone
uses a non-zero instance->lower value, there is a bug where the instance
holds a stale mitigation vote even after its trip is cleared.

Problem scenario:
- thermal-zone1: Trip at 50°C, cooling-map with lower=0
- thermal-zone2: Trip at 55°C, cooling-map with lower=2
- Both zones share the same cooling device (e.g., CPU)

Issue flow:
1. Both trips trigger, zone1 requests state 5, zone2 also mitigates
2. Zone2 trip clears (temp < 53°C due to hysteresis)
3. When throttle=false and trend=THERMAL_TREND_DROPPING:
   - Current code checks: if (cur_state <= instance->lower)
     return THERMAL_NO_TARGET
   - Since cur_state (5) > instance->lower (2),
     it returns instance->lower (2)
   - This is the BUG where it returns instance->lower even though
     trip is cleared
4. Zone2's passive polling stops (tz->passive reaches 0) - no more updates
   for zone2
5. Zone2's stale vote of 2 persists indefinitely
6. Even when zone1 wants to reduce cooling to state, the cooling device
   cannot go below state 2 due to zone2's stale vote

When a trip is cleared (throttle == false), always return THERMAL_NO_TARGET
instead of instance->lower. Remove the unnecessary check comparing
cur_state with instance->lower. Since passive polling is already
deactivated when the trip is cleared, the instance should always be
deactivated regardless of its current cooling state. This ensures that
instances with non-zero lower bounds do not retain stale mitigation votes
after their trips are cleared.

Fixes: 042a3d80f118 ("thermal: core: Move passive polling management to the core")
Signed-off-by: Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-step_wise_multi_zone_stale_vote_fix-v1-1-789f68dab229@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_step_wise.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/gov_step_wise.c b/drivers/thermal/gov_step_wise.c
index ea277c466d8d2..4fa4377f0d428 100644
--- a/drivers/thermal/gov_step_wise.c
+++ b/drivers/thermal/gov_step_wise.c
@@ -65,14 +65,12 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 				     min(instance->lower + 1, instance->upper),
 				     instance->upper);
 	} else if (trend == THERMAL_TREND_DROPPING) {
-		if (cur_state <= instance->lower)
-			return THERMAL_NO_TARGET;
-
 		/*
-		 * If 'throttle' is false, no mitigation is necessary, so
-		 * request the lower state for this instance.
+		 * If 'throttle' is false, no mitigation is necessary and
+		 * passive polling is already deactivated, so clear this
+		 * instance state by returning THERMAL_NO_TARGET.
 		 */
-		return instance->lower;
+		return THERMAL_NO_TARGET;
 	}
 
 	return instance->target;
-- 
2.53.0



