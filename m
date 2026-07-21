Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D211146A61F;
	Tue, 21 Jul 2026 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649112; cv=none; b=gQgtafX9xhVGBaCY83DugAQiD+7a8OIFt762IkJRXTOzUtdNnABOGIJLIYwpXC/evNMB9UT6uUb1nx0bwBgF5DiL+tJO6vruTaCdfiNpOTyJXRZb2h0XjFyIGr7dDw3PfKl8RLkr1LY+MQoA9g5a47KuK71NJetbnmXNlSBE/yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649112; c=relaxed/simple;
	bh=HeynCC0p7RUAxP3GetBG5gO+IEF+rvztbov9Py5+GjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0ieqiVCamiwkANav9xIuXMmt3wr3rs4nxUwfwZndEMi2s5J/ynlYXVtFJrdVqk3arllp0Ak32W+68x61i7YDmft6hXL2vE9GdifGqJpEMsT0L5tTrJR+DqUR5pz2shwTmoLT/GFBrRyFBzTLd63NLecwjmeJmmYln02LqHBoYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkTD/2cG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkTD/2cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158B11F00A3A;
	Tue, 21 Jul 2026 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649110;
	bh=WugteUGtDC078ZZT7SosbsGQx5sFTInotQH0tJvJVZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkTD/2cGnbfT8SuiQBPKG+wk42J63chtqZnJX/PnL16t2zWNjlebSgBYfm+BQJq8G
	 +W5sZFSMidPj88Qz8lm4Fm2RPOQU0McEOFc0WbthEqaedtIp6vTUauTePNRbqVof7b
	 aeDpnpigHetnPWuRSA4Nwt2agtn2se8CE3uHBQTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0452/2077] drm/amd/pm: Add empty string validation to sysfs store functions
Date: Tue, 21 Jul 2026 17:02:05 +0200
Message-ID: <20260721152603.444531708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit c872fc05380c4eb2761ab289ce6a215c9bfa9576 ]

Discovery: Fuzzing for secure supply chain requirements
Tool: amd_fuzzing_sysfs (IGT test)

The AMDGPU power management sysfs store functions accept whitespace-only
strings when they should reject them with -EINVAL. This was discovered via
systematic fuzzing of sysfs interfaces crossing the user/kernel trust
boundary.

Affected functions:
- amdgpu_set_power_dpm_force_performance_level (power_dpm_force_performance_level)
- amdgpu_set_power_dpm_state (power_dpm_state)
- amdgpu_set_pp_power_profile_mode (pp_power_profile_mode)
- amdgpu_read_mask (used by pp_dpm_sclk/mclk/fclk/socclk/pcie)
- amdgpu_set_pp_features (pp_features)

Impact:
- Whitespace-only writes (e.g., "\n", " ") can cause unexpected behavior
- Better input validation at user/kernel trust boundary
- Defense-in-depth improvement

Root Cause:
The sysfs_streq() function matches whitespace-only strings against empty
string, allowing invalid input to be processed.

Fix:
Add explicit validation at the start of each affected store function:

    if (count == 0 || sysfs_streq(buf, ""))
        return -EINVAL;

This rejects whitespace-only inputs before they are processed. Note that
write() calls with count=0 (truly empty strings) are handled by the VFS
layer before reaching the sysfs .store() callback - the VFS returns 0
(success) without calling the kernel function. This is POSIX-compliant
behavior and cannot be changed at the kernel driver level.

What This Patch Fixes:
- Whitespace-only strings: "\n", " ", "  ", etc. are now rejected
- Defense-in-depth: Explicit validation at trust boundary
- Code clarity: Intent to reject invalid input is explicit

What This Patch Cannot Fix:
- write(fd, "", 0) returning success - this is VFS layer behavior
- Fuzzer tests for empty strings (count=0) will still report "accepted"
  because the VFS handles this before the kernel callback

Test Results After Fix:
- Whitespace strings ("\n", " ") now properly rejected
- Empty string tests (count=0) still show as "accepted" due to VFS behavior
- Overall improvement in input validation robustness
- No impact on valid inputs

This is a defense-in-depth improvement that hardens input validation
even though VFS layer behavior prevents catching all edge cases.

Tested: amd_fuzzing_sysfs IGT test

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 024bfdb7c1571c..952391aecf2d32 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -244,6 +244,10 @@ static ssize_t amdgpu_set_power_dpm_state(struct device *dev,
 	enum amd_pm_state_type  state;
 	int ret;
 
+	/* Reject empty/whitespace strings - fuzzing found this is not validated */
+	if (count == 0 || sysfs_streq(buf, ""))
+		return -EINVAL;
+
 	if (sysfs_streq(buf, "battery"))
 		state = POWER_STATE_TYPE_BATTERY;
 	else if (sysfs_streq(buf, "balanced"))
@@ -364,6 +368,10 @@ static ssize_t amdgpu_set_power_dpm_force_performance_level(struct device *dev,
 	enum amd_dpm_forced_level level;
 	int ret = 0;
 
+	/* Reject empty/whitespace strings - fuzzing found this is not validated */
+	if (count == 0 || sysfs_streq(buf, ""))
+		return -EINVAL;
+
 	if (sysfs_streq(buf, "low"))
 		level = AMD_DPM_FORCED_LEVEL_LOW;
 	else if (sysfs_streq(buf, "high"))
@@ -902,6 +910,10 @@ static ssize_t amdgpu_set_pp_features(struct device *dev,
 	uint64_t featuremask;
 	int ret;
 
+	/* Reject empty/whitespace strings - fuzzing found kstrtou64 accepts "" as 0 */
+	if (count == 0 || sysfs_streq(buf, ""))
+		return -EINVAL;
+
 	ret = kstrtou64(buf, 0, &featuremask);
 	if (ret)
 		return -EINVAL;
@@ -1027,6 +1039,10 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 
 	*mask = 0;
 
+	/* Reject empty/whitespace strings - fuzzing found this is not validated */
+	if (count == 0 || sysfs_streq(buf, ""))
+		return -EINVAL;
+
 	bytes = min(count, sizeof(buf_cpy) - 1);
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
@@ -1378,6 +1394,10 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 	long int profile_mode = 0;
 	const char delimiter[3] = {' ', '\n', '\0'};
 
+	/* Reject empty/whitespace strings - fuzzing found this is not validated */
+	if (count == 0 || sysfs_streq(buf, ""))
+		return -EINVAL;
+
 	tmp[0] = *(buf);
 	tmp[1] = '\0';
 	ret = kstrtol(tmp, 0, &profile_mode);
-- 
2.53.0



