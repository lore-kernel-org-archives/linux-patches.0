Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4864519A0;
	Fri,  9 Oct 2026 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556434; cv=none; b=gWYvez/82LVhy/wnJw5iS5Wm243O4W54lLct9hIRf5Dnqyjpu7edw1O6jgVd/heoZyRFu2PeXKHVFixXVw3erAP98HwREkEwmsPfGz3mdoXhyNyCCGiY9VfV13XP/uuXXJYn5t9u8/yBMuuDV4mEZxak1hu75eWavvubw+JYSp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556434; c=relaxed/simple;
	bh=3boKmXfPTn+VeelkLs5ljtbqupyE7PpIf0SxA2FIxgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nad6ub+jXDFMGkwz+HaK66d53kQyHrR1Kq4klzTFA7AL2pmIbJ0nsieq4xFF8ITQTS4/fo+hchbYqhpKavZQPnlOl3W4Fhu5zNGcg7OM/zyqCoMKYy33NlpjBPGkmshWHWz7uDZo5c4DGFs38hYoOtmiLDqGCiMuSoeqJyovkDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5onzulV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5onzulV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7EF1F000FF;
	Fri,  9 Oct 2026 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556433;
	bh=VX1d1RbXJmqeBzU58CTHhfVnZnVv8D6pNlCF2LMMRoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5onzulVaQeqnIYFlGYmASuLdY5YHHxIEtAI7p5TnOeJR9kk8uTOBk6DWVOI0fyEG
	 kQQb/dslKO5UpaaY8U08aepk2sU3D7onLzN9hm+4x3Zz6xDq/0y7FPX9TOQuSF9JhS
	 LWWme9Wl9mk/euqDMds89+c1w+x85PFDNcjEfX1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 175/428] drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC
Date: Fri,  9 Oct 2026 16:08:32 +0200
Message-ID: <20261009140949.994839227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5263,7 +5263,8 @@ static int si_init_smc_table(struct amdg
 		break;
 	}
 
-	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC)
+	if ((adev->flags & AMD_IS_MOBILITY) &&
+	    (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC))
 		table->systemFlags |= PPSMC_SYSTEMFLAG_GPIO_DC;
 
 	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_REGULATOR_HOT) {


