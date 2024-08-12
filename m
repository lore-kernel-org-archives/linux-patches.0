Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79E16D9B8;
	Mon, 12 Aug 2024 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480329; cv=none; b=qevvVcPzozxYheZYQKM7E8UtFC3y8hvRDol48fbT6c0dev+/BfJGJ0ATU2BswA3giO4k4ao6bHjooqabm2WZpx+2l20f91bS2yUQ6/YBi+dkY+gJvSkr/DugBSXtpNU3ysBPhCoUoTDyrfiOeX2Vdbtgib3+Imc11wxRKA5VXbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480329; c=relaxed/simple;
	bh=taAEyJbjwokAM9a675V93UUrs3cs5gvq+lQdKzlx9ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXeuBDpC+OLjbTQvhAk1A/fon9NHObtrQrm4M44IrQQ2MvOEmVz/b2Ts95w3lb+f0YPXKDEeWju/gF0FLlNpRF1WPp4byIQAJHRMDWjhq5qwkQbWzOx9TWPGvyFrjXL76ZoLzm4YsWfuIh7NWcgpmkGFzfF6panNx15P68PFV+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MobRpce7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MobRpce7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEE4C32782;
	Mon, 12 Aug 2024 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480328;
	bh=taAEyJbjwokAM9a675V93UUrs3cs5gvq+lQdKzlx9ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MobRpce7EWD7WLEej+OA/Ozw1HZ1UOzEmhs6ZTMg/jW39UP1EzYw6F/5PykQp+7mV
	 kAq2p7UWE3P6if8zWmNXyJoTSZzV6iF77yCkhHB1lWknKxgfPp2FwdEiVbNbnqt+CT
	 jckUhoiA5y5PcmtTfMpG2iZ6RFZ/iOdW6sB/DPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/263] drm/xe/hwmon: Fix PL1 disable flow in xe_hwmon_power_max_write
Date: Mon, 12 Aug 2024 18:02:46 +0200
Message-ID: <20240812160152.863198387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit ac3191c5cf47e2d5220a1ed7353a2e498a1f415e ]

In xe_hwmon_power_max_write, for PL1 disable supported case, instead of
returning after PL1 disable, PL1 enable path was also being run.
Fixed it by returning after disable.

v2: Correct typo and grammar in commit message. (Jonathan)

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Fixes: fef6dd12b45a ("drm/xe/hwmon: Protect hwmon rw attributes with hwmon_lock")
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240801112424.1841766-1-karthik.poosa@intel.com
(cherry picked from commit 146458645e505f5eac498759bcd865cf7c0dfd9a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 453e601ddd5e6..d37f1dea9f8b8 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -200,9 +200,10 @@ static int xe_hwmon_power_max_write(struct xe_hwmon *hwmon, int channel, long va
 				     PKG_PWR_LIM_1_EN, 0, channel);
 
 		if (reg_val & PKG_PWR_LIM_1_EN) {
+			drm_warn(&gt_to_xe(hwmon->gt)->drm, "PL1 disable is not supported!\n");
 			ret = -EOPNOTSUPP;
-			goto unlock;
 		}
+		goto unlock;
 	}
 
 	/* Computation in 64-bits to avoid overflow. Round to nearest. */
-- 
2.43.0



