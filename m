Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA94E3236;
	Fri,  9 Oct 2026 14:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555913; cv=none; b=pawESCcgD4HqMIBc9LAu5k7gBzXx/8IeKHoEPdzEix5C/X0Cux3rCoy5uV6dtRwt3pinFembC853yhdqQ0yJQcKmkuezS/a/JlNk2f5G6ZU9WWD7Jwgr1+VzLxVtuIqbRk/zZ4dvZPHrerArRq/ID6Y6kZSB+hWhWZ/K8yAmtuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555913; c=relaxed/simple;
	bh=nw/lk3FZ13LMq12C+XHgcyfGwo07fHlKLnoeQKUH5gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sib4NpGM+wBB0VmUyPGejr6KqydokN+77+RS4h3p/lxl0YSuX0kKUt9yfXGCmfRi8qBsr+XDqZsOJLPwgKoOSNkfcES57EfoVwvL7RJn+6L6unEZLHUYnAIiDw/JZPOYgEg2BK3Sg4Wk2o3dUMMYpbgG/S/2ylc9asf5ITLV7WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajN8CU/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajN8CU/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF58C1F000FF;
	Fri,  9 Oct 2026 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555911;
	bh=M3NbT7KStZu9DvQvyqWt1Md+Of35DQhfiXv8M94iqbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajN8CU/0FKfjk/Km+c7+6OON1eZBj1E24pfjeNfrb56+gYoan/iXSsXe0NDsV+0T/
	 nC+ugJorWO0g5e15nO51e+/EzQbiN4FDGlNmN1urbjt8utPcxjr9mdTc4xZCeTGzfr
	 V2FgrAW6tI7h8hkP308m3RDe6GNsQtSWGzziDtBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 138/403] drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC
Date: Fri,  9 Oct 2026 16:08:19 +0200
Message-ID: <20261009140955.300869054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


