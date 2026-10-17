Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BD03B19B9;
	Sat, 17 Oct 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256441; cv=none; b=W/fdBgX6LrM+QfnJM2J2Cvr7XtBvq3lLXqYc+LecXHkmxHiiEsWo0HpMMSAhRxhrvkQ2HoZaPt5utvt6GBuh+rkHbeqxfDCTTNwnMTswExX51DPVCrvWG/x8iY8vECqeW4RqBGzixmfmb2lNGpWbpnoVTdGogEAutN1GVj1K/A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256441; c=relaxed/simple;
	bh=rBQW111yp4xfvaFscGGo1dbrSenKspyamM4HiaD18Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJ8hmZEl7oP9xd+2w7M30/l7eTxF2LPo30+KVUyNk4zyYDc/tXYf9gVzTBE8sNCEQsSrwF8YxgQLXsRpMAotA1Yk/fcUa8vJudUxqXNBAly2kPTOWASAC5v59SbHVIiUUv/b+B8Ueu5BRSiTg4aBgvjHfM33GRTTQz4/LRP939U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KB7yGVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KB7yGVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5441F000C4;
	Sat, 17 Oct 2026 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256440;
	bh=WREqiKq2LUTSbQ5JSXbK6rKtrxqTd87/fBhjFUHreYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KB7yGVUNkak1JPQ8MQhUT4fllIuA0FaI96t5iGo5WDxLLJ12DX1tQ0xRRpJzOH62
	 f1n2hYozeeEJ2hDPpZmvYL//7IiWWFqB4QMhQ/67TE0ZAqNUhIhGBuW4PWXhBIlLwR
	 D0fu3AfocWC/gg6GEoxt86QQLkbygND+q5Wicuo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0236/1674] drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC
Date: Sat, 17 Oct 2026 17:41:48 +0200
Message-ID: <20261017160437.192171975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit cd883d0a3937df82a5ea03709ba8ba623b868419 upstream.

Unfortunately, some desktop boards eg. the FirePro D500
have the HARDWAREDC platform flag set and also have
a battery power state configured in their VBIOS.
This makes no sense for a desktop GPU and results in
incorrect behaviour: the clocks are stuck at lowest.

We observed that the kernel driver can work around
the issue in two possible ways:
1. Set PPSMC_SWSTATE_FLAG_DC on all power states
2. Clear PPSMC_SYSTEMFLAG_GPIO_DC

We think that the PPSMC_SYSTEMFLAG_GPIO_DC flag
makes the SMC assume it's running on battery even
though this is a desktop machine with no battery,
and that's why it doesn't do DPM on power states
without PPSMC_SYSTEMFLAG_GPIO_DC.

Issue was uncovered by "Fix updating clock limits from
power states" because previously the limits for the
battery state were not tracked separately. However,
battery power state has lower frequencies and voltages,
so the kernel doesn't set the DC flag on the current
power state anymore. That causes the SMC to be stuck
on the lowest clocks.

Let's clear PPSMC_SYSTEMFLAG_GPIO_DC on desktop GPUs.
We can use the AMD_IS_MOBILITY flag to determine that.

Fixes: e6c5d36756e7 ("drm/amd/pm/si: Fix updating clock limits from power states")
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/16352
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923120354.1027996-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 58473c7c49ce9f5f5a4a1c24ffb9aa1d3c8771f4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5239,7 +5239,8 @@ static int si_init_smc_table(struct amdg
 		break;
 	}
 
-	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC)
+	if ((adev->flags & AMD_IS_MOBILITY) &&
+	    (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC))
 		table->systemFlags |= PPSMC_SYSTEMFLAG_GPIO_DC;
 
 	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_REGULATOR_HOT) {


