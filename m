Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8703AC0E3;
	Mon, 23 Mar 2026 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274736; cv=none; b=seKQVfvqXs+jHUFKiesRzaRQTarxsviwAoYxth5Fg9xWCSFJv1nNjNm99xftQbwEisTkENBp9slZY9iUfw+LpFh5MdZ4eN8v9SV2Q3I/yRmpBgdZsxRkfZADOIwK4js8Tv+ev6TXcuD4lnA04vOqbeuKJsbc9Qt9OOVCD7TWMc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274736; c=relaxed/simple;
	bh=6vFmUa5dUuqeTEVJKt5Vt6y0lcVKC3RG4IZh8k99jNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyHIg5mqkPOMdw6H75pf2a4Spx11KSci7oAASARld2cPgpvOaiKleer6eca1ffPcoa6YF/38zKk2cF3u/aWno/jG2zFXCxXMl5BRqEraefj7FsTSLtWhEkreFDpb/wJbCADDjjlbB5q0dah715dhg3Z1jdjYmbNuQNQE3cTHTa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVrT5DbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVrT5DbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1289AC4AF0B;
	Mon, 23 Mar 2026 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274736;
	bh=6vFmUa5dUuqeTEVJKt5Vt6y0lcVKC3RG4IZh8k99jNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVrT5DbWB6ZobuYdc97LqhYDY5PRZ2zoiIuRRLDIWTr6IBne6TzJMLWKTQi8woJ7m
	 xxUKew4LJSBzkN0Lh/WK9Kl3gvoS6YTvSNw/g3Zg/rSG6xm/F7JaHRPRovVhZgo0Bw
	 8qmwLhQX9x/3bk6wCvF9vJ9C+shERLut05e/It68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Thasleem <mohammed.thasleem@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Tao Liu <ltao@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 093/212] drm/i915/dmc: Fix an unlikely NULL pointer deference at probe
Date: Mon, 23 Mar 2026 14:45:14 +0100
Message-ID: <20260323134506.716983161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit ac57eb3b7d2ad649025b5a0fa207315f755ac4f6 upstream.

intel_dmc_update_dc6_allowed_count() oopses when DMC hasn't been
initialized, and dmc is thus NULL.

That would be the case when the call path is
intel_power_domains_init_hw() -> {skl,bxt,icl}_display_core_init() ->
gen9_set_dc_state() -> intel_dmc_update_dc6_allowed_count(), as
intel_power_domains_init_hw() is called *before* intel_dmc_init().

However, gen9_set_dc_state() calls intel_dmc_update_dc6_allowed_count()
conditionally, depending on the current and target DC states. At probe,
the target is disabled, but if DC6 is enabled, the function is called,
and an oops follows. Apparently it's quite unlikely that DC6 is enabled
at probe, as we haven't seen this failure mode before.

It is also strange to have DC6 enabled at boot, since that would require
the DMC firmware (loaded by BIOS); the BIOS loading the DMC firmware and
the driver stopping / reprogramming the firmware is a poorly specified
sequence and as such unlikely an intentional BIOS behaviour. It's more
likely that BIOS is leaving an unintentionally enabled DC6 HW state
behind (without actually loading the required DMC firmware for this).

The tracking of the DC6 allowed counter only works if starting /
stopping the counter depends on the _SW_ DC6 state vs. the current _HW_
DC6 state (since stopping the counter requires the DC5 counter captured
when the counter was started). Thus, using the HW DC6 state is incorrect
and it also leads to the above oops. Fix both issues by using the SW DC6
state for the tracking.

This is v2 of the fix originally sent by Jani, updated based on the
first Link: discussion below.

Link: https://lore.kernel.org/all/3626411dc9e556452c432d0919821b76d9991217@intel.com
Link: https://lore.kernel.org/all/20260228130946.50919-2-ltao@redhat.com
Fixes: 88c1f9a4d36d ("drm/i915/dmc: Create debugfs entry for dc6 counter")
Cc: Mohammed Thasleem <mohammed.thasleem@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Tao Liu <ltao@redhat.com>
Cc: <stable@vger.kernel.org> # v6.16+
Tested-by: Tao Liu <ltao@redhat.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260309164803.1918158-1-imre.deak@intel.com
(cherry picked from commit 2344b93af8eb5da5d496b4e0529d35f0f559eaf0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_power_well.c |    2 +-
 drivers/gpu/drm/i915/display/intel_dmc.c                |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
@@ -796,7 +796,7 @@ void gen9_set_dc_state(struct intel_disp
 			power_domains->dc_state, val & mask);
 
 	enable_dc6 = state & DC_STATE_EN_UPTO_DC6;
-	dc6_was_enabled = val & DC_STATE_EN_UPTO_DC6;
+	dc6_was_enabled = power_domains->dc_state & DC_STATE_EN_UPTO_DC6;
 	if (!dc6_was_enabled && enable_dc6)
 		intel_dmc_update_dc6_allowed_count(display, true);
 
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -1569,8 +1569,7 @@ static bool intel_dmc_get_dc6_allowed_co
 		return false;
 
 	mutex_lock(&power_domains->lock);
-	dc6_enabled = intel_de_read(display, DC_STATE_EN) &
-		      DC_STATE_EN_UPTO_DC6;
+	dc6_enabled = power_domains->dc_state & DC_STATE_EN_UPTO_DC6;
 	if (dc6_enabled)
 		intel_dmc_update_dc6_allowed_count(display, false);
 


