Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA73126B0B8;
	Tue,  8 Apr 2025 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115271; cv=none; b=KherC/i7lnWj9F1BtO0quop0f4R+def77UMqFiG867cpIeKAhuZX1Ay/a4bLxi/bGT+L3N3rSlr4ohaNSe86M7kbl+5gNCHbq/kit1ce4vigd/8R7X6KT5ycUyndstlqsGM7qbZFgiHSDYAlGb/V3tWYss55SPiEz0dQp5mXPSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115271; c=relaxed/simple;
	bh=zU/gh6rC+ELSvs8brArW56gqEWbR/n0fUh+L0VEpEGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCzW1Sker1Qgw9Zh1g854bfPLRebTql3CSm5b1TywVXoLwG9+3CcNDrCQ6sbaf3xLbBE0kOj9d3dJLXagaDJe/XWXMPwdIcFFVpCHAHM4Hz9iesIynNzK75k8Nz/2BDFdVhVxlx0RMjU0c2c0Q5Ul1GnHgTQdGzrVq/DCEvDNC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKNlSCMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKNlSCMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EB6C4CEE5;
	Tue,  8 Apr 2025 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115271;
	bh=zU/gh6rC+ELSvs8brArW56gqEWbR/n0fUh+L0VEpEGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKNlSCMR5hLpKGJHP4gserYxGR51lbO9RPG+EgqQNBNTsj784B1Kk+dmx71UX+J+m
	 bFoEVz6UKjAGe8q0+iY6hU8xnV3t9p7mPpMyaX64PbqYsuAg41r3ZDbBm9XqOn/h/Z
	 7UnfuvBbN7JLVPXqx0A4FcmYX1VecrdG+kr5crkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan van de Ven <arjan@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 411/499] tools/power turbostat: report CoreThr per measurement interval
Date: Tue,  8 Apr 2025 12:50:23 +0200
Message-ID: <20250408104901.474177429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit f729775f79a9c942c6c82ed6b44bd030afe10423 ]

The CoreThr column displays total thermal throttling events
since boot time.

Change it to report events during the measurement interval.

This is more useful for showing a user the current conditions.
Total events since boot time are still available to the user via
/sys/devices/system/cpu/cpu*/thermal_throttle/*

Document CoreThr on turbostat.8

Fixes: eae97e053fe30 ("turbostat: Support thermal throttle count print")
Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 2 ++
 tools/power/x86/turbostat/turbostat.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index a7f7ed01421c1..172191f841cd4 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -168,6 +168,8 @@ The system configuration dump (if --quiet is not used) is followed by statistics
 .PP
 \fBPkgTmp\fP Degrees Celsius reported by the per-package Package Thermal Monitor.
 .PP
+\fBCoreThr\fP Core Thermal Throttling events during the measurement interval.  Note that events since boot can be find in /sys/devices/system/cpu/cpu*/thermal_throttle/*
+.PP
 \fBGFX%rc6\fP The percentage of time the GPU is in the "render C6" state, rc6, during the measurement interval. From /sys/class/drm/card0/power/rc6_residency_ms or /sys/class/drm/card0/gt/gt0/rc6_residency_ms or /sys/class/drm/card0/device/tile0/gtN/gtidle/idle_residency_ms depending on the graphics driver being used.
 .PP
 \fBGFXMHz\fP Instantaneous snapshot of what sysfs presents at the end of the measurement interval. From /sys/class/graphics/fb0/device/drm/card0/gt_cur_freq_mhz or /sys/class/drm/card0/gt_cur_freq_mhz or /sys/class/drm/card0/gt/gt0/rps_cur_freq_mhz or /sys/class/drm/card0/device/tile0/gtN/freq0/cur_freq depending on the graphics driver being used.
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8ec677c639ece..08b1069d9ab54 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3298,7 +3298,7 @@ void delta_core(struct core_data *new, struct core_data *old)
 	old->c6 = new->c6 - old->c6;
 	old->c7 = new->c7 - old->c7;
 	old->core_temp_c = new->core_temp_c;
-	old->core_throt_cnt = new->core_throt_cnt;
+	old->core_throt_cnt = new->core_throt_cnt - old->core_throt_cnt;
 	old->mc6_us = new->mc6_us - old->mc6_us;
 
 	DELTA_WRAP32(new->core_energy.raw_value, old->core_energy.raw_value);
-- 
2.39.5



