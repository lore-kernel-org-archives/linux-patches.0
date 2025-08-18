Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5353112AE;
	Mon, 18 Aug 2025 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526325; cv=none; b=vEHr3M23SrNK1tM46l3lxM8G3ZCoVkW1zOzCRlB+9+D8qUGcs+a9RoIcpBgCgRqWc1T7XK6JZkCGe1pYc8ZByrNxnPUTLXKxEeidutnuFBhj94Zh1B6QslrXqYkVbbSYNi5qnu1K3DKufAP7fvAmHH8swHAA+RjbxOHUKPJjYF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526325; c=relaxed/simple;
	bh=eXD7nvzId624pDZvDWDJlG10CZZ06JWIsTM9B4PZ4Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foMqKyVz8x2trIggR9mZIWm8MkSSGnM1mc2x43bbYmTpyppza0S5pSHByp5PZYxv+3B46wwBiBwtr96ZMtbX975OTqUDoWgNZJR0s+ubii2R28vdOKI9WK1B+tJLU9vIqUKKjatblz2X4jOw0EBmy/1cjfjN0cud6xxl58MpqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrjKAFYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrjKAFYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3BEC113D0;
	Mon, 18 Aug 2025 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526325;
	bh=eXD7nvzId624pDZvDWDJlG10CZZ06JWIsTM9B4PZ4Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrjKAFYBNDN880GN2mXmpDow9HYli4rDc2W7AudppNv9qDZm4Sxx+s3LqtGL5nQme
	 gpFi+7/jtiWzPwbjeIxG91M2dOfCIIxSZq44oOTR35YNk7o+IUnoFgM27h3PVH11rB
	 Ix3n09ju4g42GBGb27HfnQn+Whmk6tGADBw0ZSGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 480/570] drm/xe/hwmon: Add SW clamp for power limits writes
Date: Mon, 18 Aug 2025 14:47:47 +0200
Message-ID: <20250818124524.374183271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit 55d49f06162e45686399df4ae6292167f0deab7c ]

Clamp writes to power limits powerX_crit/currX_crit, powerX_cap,
powerX_max, to the maximum supported by the pcode mailbox
when sysfs-provided values exceed this limit.
Although the pcode already performs clamping, values beyond the pcode
mailbox's supported range get truncated, leading to incorrect
critical power settings.
This patch ensures proper clamping to prevent such truncation.

v2:
 - Address below review comments. (Riana)
 - Split comments into multiple sentences.
 - Use local variables for readability.
 - Add a debug log.
 - Use u64 instead of unsigned long.

v3:
 - Change drm_dbg logs to drm_info. (Badal)

v4:
 - Rephrase the drm_info log. (Rodrigo, Riana)
 - Rename variable max_mbx_power_limit to max_supp_power_limit, as
   limit is same for platforms with and without mailbox power limit
   support.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Fixes: 92d44a422d0d ("drm/xe/hwmon: Expose card reactive critical power")
Fixes: fb1b70607f73 ("drm/xe/hwmon: Expose power attributes")
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://lore.kernel.org/r/20250808185310.3466529-1-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit d301eb950da59f962bafe874cf5eb6d61a85b2c2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index f008e8049700..be2948dfc8b3 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -329,6 +329,7 @@ static int xe_hwmon_power_max_write(struct xe_hwmon *hwmon, u32 attr, int channe
 	int ret = 0;
 	u32 reg_val;
 	struct xe_reg rapl_limit;
+	u64 max_supp_power_limit = 0;
 
 	mutex_lock(&hwmon->hwmon_lock);
 
@@ -353,6 +354,20 @@ static int xe_hwmon_power_max_write(struct xe_hwmon *hwmon, u32 attr, int channe
 		goto unlock;
 	}
 
+	/*
+	 * If the sysfs value exceeds the maximum pcode supported power limit value, clamp it to
+	 * the supported maximum (U12.3 format).
+	 * This is to avoid truncation during reg_val calculation below and ensure the valid
+	 * power limit is sent for pcode which would clamp it to card-supported value.
+	 */
+	max_supp_power_limit = ((PWR_LIM_VAL) >> hwmon->scl_shift_power) * SF_POWER;
+	if (value > max_supp_power_limit) {
+		value = max_supp_power_limit;
+		drm_info(&hwmon->xe->drm,
+			 "Power limit clamped as selected %s exceeds channel %d limit\n",
+			 PWR_ATTR_TO_STR(attr), channel);
+	}
+
 	/* Computation in 64-bits to avoid overflow. Round to nearest. */
 	reg_val = DIV_ROUND_CLOSEST_ULL((u64)value << hwmon->scl_shift_power, SF_POWER);
 	reg_val = PWR_LIM_EN | REG_FIELD_PREP(PWR_LIM_VAL, reg_val);
@@ -697,9 +712,23 @@ static int xe_hwmon_power_curr_crit_write(struct xe_hwmon *hwmon, int channel,
 {
 	int ret;
 	u32 uval;
+	u64 max_crit_power_curr = 0;
 
 	mutex_lock(&hwmon->hwmon_lock);
 
+	/*
+	 * If the sysfs value exceeds the pcode mailbox cmd POWER_SETUP_SUBCOMMAND_WRITE_I1
+	 * max supported value, clamp it to the command's max (U10.6 format).
+	 * This is to avoid truncation during uval calculation below and ensure the valid power
+	 * limit is sent for pcode which would clamp it to card-supported value.
+	 */
+	max_crit_power_curr = (POWER_SETUP_I1_DATA_MASK >> POWER_SETUP_I1_SHIFT) * scale_factor;
+	if (value > max_crit_power_curr) {
+		value = max_crit_power_curr;
+		drm_info(&hwmon->xe->drm,
+			 "Power limit clamped as selected exceeds channel %d limit\n",
+			 channel);
+	}
 	uval = DIV_ROUND_CLOSEST_ULL(value << POWER_SETUP_I1_SHIFT, scale_factor);
 	ret = xe_hwmon_pcode_write_i1(hwmon, uval);
 
-- 
2.50.1



