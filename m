Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D6A263C78;
	Tue,  8 Apr 2025 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112029; cv=none; b=tlxTaghGTesZIOCJANdaXUCEYrxAq1dYFxlv+aDsXbqNa9R7oM1uU/LAIsYf2uJkeuqz+8oUe26oS2HSYrX/RdMY/p5I0Q/uWOjYjtDT9hqAXqvIHtmw3QdlwAfISMpfr6Ir2geoA0wa4s5F1hmiWukCMbPXuZx4IuYRPTBx7O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112029; c=relaxed/simple;
	bh=HHlL+kEUuVQNSL4k7kMaIsre5srfC8HCLQsBiDiWRW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XALbqNjwwvUBXSCaDtvzuu1UHSMO7HWwk1RQzqvMFMaJ+uif0xD95FLJC/JoeuXt+qcWEy0bK4GqBoCTAGB5Eo/HbDz6wPgmbo8j2rhII2pG7jZ2uUjQr9brudcwwcOA4YJXJ2I49l3UNjcJGLEDiJJy7ndI/MxBQB6JKQ0XsBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K05vOksp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K05vOksp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADC3C4CEE5;
	Tue,  8 Apr 2025 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112029;
	bh=HHlL+kEUuVQNSL4k7kMaIsre5srfC8HCLQsBiDiWRW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K05vOkspOsTSUeOkWZ6ip9mJio5RkQhBBJLVxqInO8zjH6U6tc2+7CbQEM7PCfAiV
	 Uw6coMnFODxaYhYBVyOYcZUR4DjYSuP+KIQeuI0JJX7Ub3vklooCcMn7z7v7PBwMak
	 xJdc8HKCIIZlAkAgeCGmF5oGYYSos92s2viRbaDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan van de Ven <arjan@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 650/731] tools/power turbostat: report CoreThr per measurement interval
Date: Tue,  8 Apr 2025 12:49:07 +0200
Message-ID: <20250408104929.384574200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 99bf905ade812..e4f9f93c123a2 100644
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
index ff238798b7747..5b36f1fd885c9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3485,7 +3485,7 @@ void delta_core(struct core_data *new, struct core_data *old)
 	old->c6 = new->c6 - old->c6;
 	old->c7 = new->c7 - old->c7;
 	old->core_temp_c = new->core_temp_c;
-	old->core_throt_cnt = new->core_throt_cnt;
+	old->core_throt_cnt = new->core_throt_cnt - old->core_throt_cnt;
 	old->mc6_us = new->mc6_us - old->mc6_us;
 
 	DELTA_WRAP32(new->core_energy.raw_value, old->core_energy.raw_value);
-- 
2.39.5



