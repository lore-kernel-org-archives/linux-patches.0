Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317C63ACA62;
	Mon, 23 Mar 2026 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274026; cv=none; b=ZRpGy6LVN9k3xIyFlVW6znYiE3de+LyeQ/lXLlkrHHIUPjalNgulzCdKaIsCZC/DDbv/jMjs2uIWdllKWh3PXsW38Y04BaR64zIm2dPWcPKZp66AXlDPFQzWMisvJ5AEvU1VRC7lEdHGgwyjk+odRhaLHQJ3njXpeOP0N9dGZU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274026; c=relaxed/simple;
	bh=HR1YGV6wBB+f1ygl5bYYIQb7NI8ysrjmgQRsdDcCQaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYVc1n64IQighUXdqNvWoWKfAn3vkJrEL5uga/7xP4D3GmGl7K1hxpqEfDQb16LqFTLypVnFTI1cJAjvR7IvQ/GOQuMaj4f9oWZXyrfUcR7qrZo7FhL6RJ+CjLrvCw30WttmowsWn9EDH8QsEDOsk9PpJ4X3d/T3a0g0jvZA1bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRgjq79e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRgjq79e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A849FC4CEF7;
	Mon, 23 Mar 2026 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274026;
	bh=HR1YGV6wBB+f1ygl5bYYIQb7NI8ysrjmgQRsdDcCQaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRgjq79e/Lx2/ziDROx7TTWlMsnKa7S8lwvHF/qx9FLQKOLkO49rsxW3va/itJoX0
	 tWNxsYDe2N6Vzl8wfTeZKpnAiaiA/GLmi4hIOTB3O0dqgiFVhtReuA8IKiRIbX6sN7
	 qnIXqZBMNCvAYhAS0q9SH/sClC/Np1UkmVNEoYqk=
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
Subject: [PATCH 6.19 086/220] drm/i915/dmc: Fix an unlikely NULL pointer deference at probe
Date: Mon, 23 Mar 2026 14:44:23 +0100
Message-ID: <20260323134507.311612426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -798,7 +798,7 @@ void gen9_set_dc_state(struct intel_disp
 			power_domains->dc_state, val & mask);
 
 	enable_dc6 = state & DC_STATE_EN_UPTO_DC6;
-	dc6_was_enabled = val & DC_STATE_EN_UPTO_DC6;
+	dc6_was_enabled = power_domains->dc_state & DC_STATE_EN_UPTO_DC6;
 	if (!dc6_was_enabled && enable_dc6)
 		intel_dmc_update_dc6_allowed_count(display, true);
 
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -1591,8 +1591,7 @@ static bool intel_dmc_get_dc6_allowed_co
 		return false;
 
 	mutex_lock(&power_domains->lock);
-	dc6_enabled = intel_de_read(display, DC_STATE_EN) &
-		      DC_STATE_EN_UPTO_DC6;
+	dc6_enabled = power_domains->dc_state & DC_STATE_EN_UPTO_DC6;
 	if (dc6_enabled)
 		intel_dmc_update_dc6_allowed_count(display, false);
 


