Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C427CB27;
	Tue,  8 Apr 2025 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117111; cv=none; b=PGO0tFZ+nA3rhhBnPi3uI/Y8/6UGKXJR4tmoTUcvv9zcOrl5VrxwKg00m+1o50nIE761VXR6baKSWAbGeOMzKAR/6Tk+/tFCGrBe7ZN0E57BvFJJ09lCa6EHPl7YQSRaf3FFXowhpaURbbRHcfmLsd69Jp5BBgcpLjR1rJJe/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117111; c=relaxed/simple;
	bh=7PNoV5JwLInBTusELkX/rsfgHI5rxH0g4MD3pFvCSiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnSjX/C2TxctTYr4VzLdU87MLUIEO1BF7PMfDm68JTnkDiCIO7GAdyxApq3i90zRLziAfs71dVLBfGerXPvgH5RUouB3zRBW0e/bjZiW7jD3e6ufNb+pR0Xq7VhxHajq2QGXBGZRgmm65XUcqsP4fYKHGWRvMjiQffEvIfl18Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LtuPJfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LtuPJfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73C0C4CEE5;
	Tue,  8 Apr 2025 12:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117111;
	bh=7PNoV5JwLInBTusELkX/rsfgHI5rxH0g4MD3pFvCSiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LtuPJfMuZ8o7RgBHEx/A0cuo2elAZAnK81F/WC0Kuv5+RK3bXLfRDgj3o9L8ucnu
	 3b6ToMss9Ne7STpEoiupavHZ/DYKTW2RtEYeviWNpevMvNU4v4ky7XpiuF0cD95GOw
	 kY1E9emEljco7Zn2OQpVPq7rslxjMaGcyUni5Ggo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan van de Ven <arjan@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/423] tools/power turbostat: report CoreThr per measurement interval
Date: Tue,  8 Apr 2025 12:51:15 +0200
Message-ID: <20250408104853.971197013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 56c7ff6efcdab..a3cf1d17163ae 100644
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
index 235e82fe7d0a5..77ef60980ee58 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3242,7 +3242,7 @@ void delta_core(struct core_data *new, struct core_data *old)
 	old->c6 = new->c6 - old->c6;
 	old->c7 = new->c7 - old->c7;
 	old->core_temp_c = new->core_temp_c;
-	old->core_throt_cnt = new->core_throt_cnt;
+	old->core_throt_cnt = new->core_throt_cnt - old->core_throt_cnt;
 	old->mc6_us = new->mc6_us - old->mc6_us;
 
 	DELTA_WRAP32(new->core_energy.raw_value, old->core_energy.raw_value);
-- 
2.39.5



