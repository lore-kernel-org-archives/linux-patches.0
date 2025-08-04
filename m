Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB28C211F;
	Mon,  4 Aug 2025 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267670; cv=none; b=pLXZmXQrQ7CyuWr34DkSQEz+mifMuDpA4rxm3aLg/RvEkOKLiD4GEemx30P9XUE0vVV7lisKjJPHy4iAKC7LcFPSO5KzXH1cbUOoCNn1q5YSXdpntZgBmXxIwg2abBEHhteqxVVenYNfWzx7VGDRxqFxxH7hAmbxX5Xn8G4eYr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267670; c=relaxed/simple;
	bh=oml94BNXBk49bETlQtnIXffpz7S/ZZyi4HVpLeL1MFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rz4txurJvhy2NMFPlTSE089zOL1OFiF96OjM6sK6qQxrmrp8QPNRfwM04fUcZX6lif0sA+/DAtErAJBHIa5LNe5f++WFk3FQ09rhigPkKAdhRll7yAaWTvgXFZa0KCrgh6mh/yS9tsFtXokiPSJO4DFEwrXWDLiJ4iYmXMHnfs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfHkc55U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfHkc55U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73124C4CEF8;
	Mon,  4 Aug 2025 00:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267670;
	bh=oml94BNXBk49bETlQtnIXffpz7S/ZZyi4HVpLeL1MFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfHkc55UQKmlEWeZYLwaSKvat/0CofXStjPFuujv/v/qosTooNOP0+llx2xjfodAG
	 h3Z4dXdBheYV59Sj2RbzQPkYQVhhDCBZJCyAWAGnBfeYldMxcivWifuRy0s2wo+vaG
	 vz2OBEw541/94pXZNLkaH0MFWQ2cFTHTYSaWw2fLW0rHudHS/suj2oQZ5ee1mGnV1O
	 gZih3XY+tjnEYN1XTtCjQQ3I+vdil1fX9O+V7q2HHWgxAlGhzE9NZq7dnV//4EOS6h
	 1sIwAQgoETJtel3ZMj1NXw0ZrBFSjXvBzDAMtOk7Kl6Vh6vbC9rULAUdDTjzv9Nml3
	 OgDU4EVm4r3oQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Romain Gantois <romain.gantois@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 06/59] regulator: core: repeat voltage setting request for stepped regulators
Date: Sun,  3 Aug 2025 20:33:20 -0400
Message-Id: <20250804003413.3622950-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Romain Gantois <romain.gantois@bootlin.com>

[ Upstream commit d511206dc7443120637efd9cfa3ab06a26da33dd ]

The regulator_set_voltage() function may exhibit unexpected behavior if the
target regulator has a maximum voltage step constraint. With such a
constraint, the regulator core may clamp the requested voltage to a lesser
value, to ensure that the voltage delta stays under the specified limit.

This means that the resulting regulator voltage depends on the current
voltage, as well as the requested range, which invalidates the assumption
that a repeated request for a specific voltage range will amount to a noop.

Considering the case of a regulator with a maximum voltage step constraint
of 1V:

initial voltage: 2.5V

consumer requests 4V
expected result: 3.5V
resulting voltage: 3.5V

consumer requests 4V again
expected result: 4V
actual result: 3.5V

Correct this by repeating attempts to balance the regulator voltage until
the result converges.

Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/20250718-regulator-stepping-v2-1-e28c9ac5d54a@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit fixes a legitimate bug in the voltage regulator subsystem
that affects users with stepped voltage regulators. Here's my extensive
analysis:

## Bug Description and Impact

The commit addresses a bug where regulators with `max_uV_step`
constraints fail to reach their target voltage when the same voltage
range is requested multiple times. The bug manifests as follows:

1. When a regulator has a maximum voltage step constraint (e.g., 1V),
   the core limits each voltage change to stay within this step
2. The optimization at line 3814 (`if (voltage->min_uV == min_uV &&
   voltage->max_uV == max_uV) goto out;`) assumes repeated requests are
   no-ops
3. This creates a situation where requesting 4V twice from 2.5V only
   reaches 3.5V, not the desired 4V

## Code Analysis

The fix adds a retry mechanism specifically for stepped regulators:

1. **New helper function** `regulator_get_voltage_delta()` (lines
   3800-3808): Calculates the absolute difference between current and
   target voltage
2. **Retry loop** (lines 3865-3893): After the initial voltage setting,
   if `max_uV_step` is configured, it:
   - Checks if we've reached the target voltage (delta > 0)
   - Repeatedly calls `regulator_balance_voltage()` until convergence
   - Includes convergence protection to avoid infinite loops (line 3888)

## Why This Is a Good Backport Candidate

1. **Fixes a real bug**: Users with stepped voltage regulators cannot
   reach target voltages, potentially causing system instability or
   device malfunction
2. **Minimal invasive changes**: The fix is well-contained within
   `regulator_set_voltage_unlocked()` and only affects regulators with
   `max_uV_step` constraints
3. **No API/ABI changes**: Only internal implementation changes, no
   external interfaces modified
4. **Clear regression potential**: Low risk as the new code only
   executes for regulators with `max_uV_step` set
5. **Safety checks included**: The convergence check prevents infinite
   loops (`if (new_delta - delta > rdev->constraints->max_uV_step)`)

## Specific Code References

- The bug is in the optimization at drivers/regulator/core.c:3814-3815
- The fix adds retry logic at drivers/regulator/core.c:3865-3893
- Only affects regulators where `rdev->constraints->max_uV_step > 0`
- The existing `regulator_limit_voltage_step()` function already handles
  the step limiting logic

This is exactly the type of fix that belongs in stable: it addresses a
specific functional bug without introducing new features or
architectural changes.

 drivers/regulator/core.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d2e21dc61dd7..60dbae922496 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3751,6 +3751,16 @@ static int _regulator_do_set_suspend_voltage(struct regulator_dev *rdev,
 	return 0;
 }
 
+static int regulator_get_voltage_delta(struct regulator_dev *rdev, int uV)
+{
+	int current_uV = regulator_get_voltage_rdev(rdev);
+
+	if (current_uV < 0)
+		return current_uV;
+
+	return abs(current_uV - uV);
+}
+
 static int regulator_set_voltage_unlocked(struct regulator *regulator,
 					  int min_uV, int max_uV,
 					  suspend_state_t state)
@@ -3758,8 +3768,8 @@ static int regulator_set_voltage_unlocked(struct regulator *regulator,
 	struct regulator_dev *rdev = regulator->rdev;
 	struct regulator_voltage *voltage = &regulator->voltage[state];
 	int ret = 0;
+	int current_uV, delta, new_delta;
 	int old_min_uV, old_max_uV;
-	int current_uV;
 
 	/* If we're setting the same range as last time the change
 	 * should be a noop (some cpufreq implementations use the same
@@ -3806,6 +3816,37 @@ static int regulator_set_voltage_unlocked(struct regulator *regulator,
 		voltage->max_uV = old_max_uV;
 	}
 
+	if (rdev->constraints->max_uV_step > 0) {
+		/* For regulators with a maximum voltage step, reaching the desired
+		 * voltage might take a few retries.
+		 */
+		ret = regulator_get_voltage_delta(rdev, min_uV);
+		if (ret < 0)
+			goto out;
+
+		delta = ret;
+
+		while (delta > 0) {
+			ret = regulator_balance_voltage(rdev, state);
+			if (ret < 0)
+				goto out;
+
+			ret = regulator_get_voltage_delta(rdev, min_uV);
+			if (ret < 0)
+				goto out;
+
+			new_delta = ret;
+
+			/* check that voltage is converging quickly enough */
+			if (new_delta - delta > rdev->constraints->max_uV_step) {
+				ret = -EWOULDBLOCK;
+				goto out;
+			}
+
+			delta = new_delta;
+		}
+	}
+
 out:
 	return ret;
 }
-- 
2.39.5

