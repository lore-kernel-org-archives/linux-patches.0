Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289A9272E5A;
	Tue,  5 Aug 2025 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399411; cv=none; b=b5e83C+Hz3XRuJpHRyh8A/1a9nIiWEPVtiBUQ1hnc6NdVfk7TG+7SiZhGGm0nV16vRV7/YcxsucU5rjZcpkymBnE/2O9AuXop1tQyGt8fLI5OFz0tsuGGC52hIbL5H+Ol7syDcCcni/gp/tvl+s7e6wgBTqkEZEojGjEj4nTheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399411; c=relaxed/simple;
	bh=Hk/f3ywqEdhAhUrmndY5pDG1upxEFn3WT+xr2WLPPpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I8BwEfRsdZUFhF5YqWsjYZFk0zUTYQaYa3db9Qjmb/Gpq7b9uairkrWMnc8Ej3vtxAJWg8vV3j5Yjk3eRGR+ZdeL4aUkzINBmuJAgcPVthcetbTrt2dQHfE65wIFoh9wIAhGAObj3o6UK+8VRg11t3Gd5f2jBiFLG5z0RNMefdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tC16lZN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tC16lZN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E13C4CEF7;
	Tue,  5 Aug 2025 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399411;
	bh=Hk/f3ywqEdhAhUrmndY5pDG1upxEFn3WT+xr2WLPPpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC16lZN/LHBid3HG5aRcQSNjgViMRL4L3NBEoOXcJPaSO2FgTY7g7zgh6IGbJkFJL
	 MIAJV9R6dSq0a15hLFKNLEysfC8MC/v+un9McqvNDyFGOFQOG5V8G8besnQvrjP76V
	 I1RELFuHd6cEOH891p1Y7ObifpUw56LgnW+wk+okZg+drDJVQYDDurb15bmuHepsDU
	 XnczcspzZ/Wqz5DtQETenQjQcu/np9pycSFvZLfktcsxBk2FshMN+ZqU2pEVeDO+eA
	 CvusvkkPPiH/WO8Cdzv5mqxoS351mWOG5eKNUEDv9JmsRpJSCpxtr2GTpMClzUdsTn
	 /Rafjz/7kfzKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] soundwire: amd: serialize amd manager resume sequence during pm_prepare
Date: Tue,  5 Aug 2025 09:08:46 -0400
Message-Id: <20250805130945.471732-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 03837341790039d6f1cbf7a1ae7dfa2cb77ef0a4 ]

During pm_prepare callback, pm_request_resume() delays SoundWire manager D0
entry sequence. Synchronize runtime resume sequence for amd_manager
instance prior to invoking child devices resume sequence for both the amd
power modes(ClockStop Mode and Power off mode).
Change the power_mode_mask check and use pm_runtime_resume() in
amd_pm_prepare() callback.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-3-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a critical synchronization issue in the AMD SoundWire
driver's power management sequence. The original code used
`pm_request_resume()` which is asynchronous, leading to race conditions
where the manager device might not be fully resumed before child devices
start their resume sequence. This causes:
1. Missing device alerts on AMD platforms
2. Race conditions during system resume
3. Potential communication failures between the SoundWire manager and
   peripheral devices

## Code Analysis

1. **Critical Fix**: The change from `pm_request_resume()` to
   `pm_runtime_resume()` ensures synchronous resume operation,
   eliminating race conditions. This is similar to Intel's fix (commit
   6f4867fa5760) which addressed the same class of issue.

2. **Expanded Scope**: The condition change from `(power_mode_mask &
   AMD_SDW_CLK_STOP_MODE)` to just `(power_mode_mask)` ensures the fix
   applies to both power modes:
   - AMD_SDW_CLK_STOP_MODE (value 1): Clock stop mode
   - AMD_SDW_POWER_OFF_MODE (value 2): Power off mode

   This ensures proper synchronization for all power management
scenarios, not just clock stop mode.

3. **Small and Contained**: The fix is minimal (3 lines changed) and
   localized to the `amd_pm_prepare()` function, reducing regression
   risk.

4. **Clear Bug Symptoms**: The commit message explicitly states the
   observed bug: "device alerts are missing without pm_prepare on AMD
   platforms" - a user-visible problem affecting SoundWire
   functionality.

5. **No Architectural Changes**: This is purely a bug fix that corrects
   the synchronization mechanism without introducing new features or
   changing the driver architecture.

6. **Subsystem Pattern**: This follows an established pattern in the
   SoundWire subsystem where Intel had a similar issue and fix,
   indicating this is a known class of bugs that should be addressed in
   stable kernels.

The commit meets all stable kernel criteria: it fixes a real bug
affecting users, is minimal in scope, has low regression risk, and
doesn't introduce new functionality.

 drivers/soundwire/amd_manager.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 7a671a786197..3b335d6eaa94 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1178,10 +1178,10 @@ static int __maybe_unused amd_pm_prepare(struct device *dev)
 	 * device is not in runtime suspend state, observed that device alerts are missing
 	 * without pm_prepare on AMD platforms in clockstop mode0.
 	 */
-	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
-		ret = pm_request_resume(dev);
+	if (amd_manager->power_mode_mask) {
+		ret = pm_runtime_resume(dev);
 		if (ret < 0) {
-			dev_err(bus->dev, "pm_request_resume failed: %d\n", ret);
+			dev_err(bus->dev, "pm_runtime_resume failed: %d\n", ret);
 			return 0;
 		}
 	}
-- 
2.39.5

