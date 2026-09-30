Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A49151993C;
	Wed, 30 Sep 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789191; cv=none; b=pif2PXITeUIeFhj2yNxhFO14HYMUWzvljsiTseNGKXlyzldcw3q3YpbdWcV/tBa1p8unzYF7mfb2AFbrSzbc6YNC85lioDnHUUIR0F0dGAFHP4N1cuSOmbZluXUwhw8N3rRirkQSeFnidtDsJzH6K91ilAy+2aCCh9cT2Ra/Nn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789191; c=relaxed/simple;
	bh=EGz/PZ4aMI/7pM6AIHdC+GdCcGKigc0xOnhhyfxmEmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGkBc3vzVfCtx8EEjIyi7MKDA34vBG7GLNoOO/hl58Lzyci0BvwDQwe0VRqMoxL0hsRd54VPM7UujxSkvfktY2oi7OoETltLWMLBPS0RAlpFGLNI8wWx9/isD5ks9k/EPhLE5KdMDjXvq4OnggV9m6NuTonD+d1WxoNVb/e9jWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioydpJUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioydpJUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E7F1F000FF;
	Wed, 30 Sep 2026 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789190;
	bh=p2LOdPlXEizXUhQW3/ire53lZUvNfnXugEsHiX9yAGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioydpJUtkN+G5IBcq62T3bH2n/OLTnk3pExwJSTLrLRXnoLP1V5rZgWqcqZxokfiG
	 i6MdyXqpW+wgxWP/hBDr3LEUgOEIpOudCdgcZssu4ebVxlrtH97fQjdWsD8OARwOfR
	 SXDL8sAngOaQzGijm7/kWx9uzwiRhoU1l2MqenLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/877] thermal: gov_step_wise: Fix stale mitigation vote with non-zero lower bounds
Date: Wed, 30 Sep 2026 17:21:40 +0200
Message-ID: <20260930152423.080015701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b038f042ed74e..b191e11e553b5 100644
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



