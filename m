Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6971ADC97;
	Sat, 14 Feb 2026 01:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031034; cv=none; b=XEoJVKJKQvbKgETZPsdgoor170H+G6TNizqtQyg2Ym1og+gtR5xBK/fpZJrvMPa9oTyZ640RfHaVgmDiaa4zTqzxyl16xVgRsJqQEOSgVjo5EL3FcjmSZmsPHllPxnZgVB2FChjq/2OdgVjxk3swDYvTfEMQ4a2MtCCe+TwoEWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031034; c=relaxed/simple;
	bh=3KVtbgJOEi4lVS8bOjCjIfgmBx38/4eUfhAdiBkE7ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gO+62iPYBLzeHYRMB4jowtcD65ILiqf2rjUWYh0U7NHEUApHafEgNh/HJ42yChtFCgvw+XwRYLgDeNrq6wamP1J7K+mfZo94Alyqxw1vQ+Y52hYKChLs+VGD1sfrsuvwFD4kiS6gum4J/1tW5wA3500bCSO2zEhoRn6BModLDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwJyKFMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwJyKFMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03EEC116C6;
	Sat, 14 Feb 2026 01:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031034;
	bh=3KVtbgJOEi4lVS8bOjCjIfgmBx38/4eUfhAdiBkE7ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwJyKFMGW32Y+dKnDkOlcbECoI1pSUhqkbVPT29gwXCb5Ea8QxxS0z/mQlorTnRqG
	 r1U/tqsZUsocsDCpv0TY/HgV8Kq6Wl/CQ584AukxwckpyQq9evQn7L9k336s94Fbxj
	 urPazjc0gJlS0s6lZtFWiQVOtodPK2nvzkWdsKfsceaC+bviF16m7MHuDJXpRFUi2g
	 VZZ4HBr7wrGExiHXXOUWIQz41t2sxaLPk6ANFqUJnHW2v39DUixZzXDEdmKWwQaBvu
	 c1gf/6uCTRsr1bXw3F26KGpv3ji7S7hUWRgRRoHhJOpEADqBG1SNfO7lIh/NIfRQQM
	 mDUfIpl3gcWgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Karen Chen <karen.chen@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Charlene.Liu@amd.com,
	alex.hung@amd.com,
	aurabindo.pillai@amd.com,
	timur.kristof@gmail.com,
	Ausef.Yousof@amd.com,
	rosenp@gmail.com,
	yelangyan@huaqin.corp-partner.google.com,
	dmytro.laktyushkin@amd.com,
	srinivasan.shanmugam@amd.com,
	Martin.Leung@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Disable FEC when powering down encoders
Date: Fri, 13 Feb 2026 19:58:32 -0500
Message-ID: <20260214010245.3671907-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 8cee62904caf95e5698fa0f2d420f5f22b4dea15 ]

[why & how]
VBIOS DMCUB FW can enable FEC for capable eDPs, but S/W DC state is
only updated for link0 when transitioning into OS with driver loaded.
This causes issues when the eDP is immediately hidden and DIG0 is
assigned to another link that does not support FEC. Driver will
attempt to disable FEC but FEC enablement occurs based on the link
state, which does not have fec_state updated since it is a different
link. Thus, FEC disablement on DIG0 will get skipped and cause no
light up.

Reviewed-by: Karen Chen <karen.chen@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: "drm/amd/display: Disable FEC when powering down
encoders"

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly explains a real bug scenario:

- **VBIOS DMCUB firmware** can enable FEC (Forward Error Correction) for
  capable eDP panels
- When transitioning into OS with driver loaded, the software DC state
  for FEC is only updated for **link0**
- When eDP is hidden and **DIG0 is reassigned** to another link that
  doesn't support FEC, the driver tries to disable FEC but fails
  because:
  - FEC enablement/disablement is based on the **link state**
    (`fec_state`)
  - The new link's `fec_state` was never updated (it's a different link
    object)
  - So the FEC disable gets **skipped**
- Result: **"no light up"** — the display fails to produce output

This is a real hardware bug causing **display failure** (no output/black
screen). The keywords "no light up" indicate complete display failure,
which is a serious user-visible issue.

### 2. CODE CHANGE ANALYSIS

The change is in `power_down_encoders()` in `dce110_hwseq.c`:

**Refactoring part** (low risk):
- Introduces a local `struct dc_link *link` variable to replace repeated
  `dc->links[i]` accesses — pure cleanup, no behavior change.
- Introduces `struct link_encoder *link_enc` local variable — same
  pattern.

**Bug fix part** (the critical addition):
```c
if (link->fec_state == dc_link_fec_enabled) {
    link_enc->funcs->fec_set_enable(link_enc, false);
    link_enc->funcs->fec_set_ready(link_enc, false);
    link->fec_state = dc_link_fec_not_ready;
}
```

This is the core fix: when powering down encoders, if FEC is enabled on
the link, explicitly disable it and update the state. This ensures that
when the DIG (display interface group) is later reassigned to a
different link, there's no stale FEC state causing the new link to fail
to light up.

The new include `#include "dc_dp_types.h"` is needed to access the
`dc_link_fec_enabled` / `dc_link_fec_not_ready` enum values.

### 3. CLASSIFICATION

This is a **bug fix** — it fixes a display failure scenario where:
- FEC is left enabled by firmware
- Software state tracking gets out of sync
- Display reassignment fails to produce output

This is NOT a feature addition. The FEC disable functionality already
exists; this just ensures it's called at the right time during encoder
power-down.

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 1 file
- **Lines changed**: Small — approximately 15 lines of functional
  change, plus some variable renaming for readability
- **Subsystem**: AMD display (drm/amd/display) — a very commonly used
  GPU driver
- **Risk**: Low-to-moderate
  - The FEC disable calls (`fec_set_enable(false)`,
    `fec_set_ready(false)`) are well-established operations
  - The condition check (`fec_state == dc_link_fec_enabled`) is
    defensive — it only acts when FEC is actually enabled
  - The state update (`dc_link_fec_not_ready`) keeps the software state
    consistent
  - The variable renaming is purely cosmetic and won't affect behavior

### 5. USER IMPACT

- **Who is affected**: Users with AMD GPUs that have eDP panels (laptops
  primarily), especially those with multiple display outputs or hybrid
  graphics scenarios
- **Severity**: HIGH — "no light up" means the display produces no
  output at all. Users would see a black screen.
- **Trigger scenario**: Transitioning into OS (boot, resume from sleep)
  where VBIOS enables FEC, then eDP gets hidden and DIG0 reassigned.
  This is a real-world scenario for laptops with hybrid GPU
  configurations.

### 6. STABILITY INDICATORS

- **Reviewed-by**: Karen Chen (AMD)
- **Tested-by**: Dan Wheeler (AMD) — explicitly tested
- **Signed-off-by**: Multiple AMD engineers including Alex Deucher (AMD
  display maintainer)

This has strong review and testing coverage from the vendor.

### 7. DEPENDENCY CHECK

The fix uses existing functions (`fec_set_enable`, `fec_set_ready`) and
existing state enums (`dc_link_fec_enabled`, `dc_link_fec_not_ready`).
The include of `dc_dp_types.h` brings in the FEC state definitions.
These should all exist in stable trees since FEC support has been in the
AMD display driver for several kernel versions.

The only minor concern is whether the `dc_dp_types.h` header and the
`fec_state` field exist in older stable trees, but FEC support was added
quite a while ago (around 5.x kernels), so it should be present in any
currently-maintained stable tree.

### 8. CONCLUSION

This commit fixes a real, user-visible bug (black screen / no display
output) in the AMD display driver. The fix is:
- **Small and contained**: One file, clear logic
- **Obviously correct**: If FEC is enabled, disable it when powering
  down the encoder
- **Well-tested**: Has Reviewed-by, Tested-by from AMD
- **Fixes a real bug**: Display failure is a serious issue
- **Low risk**: Defensive check, well-understood FEC operations

The fix meets all stable kernel criteria.

**YES**

 .../amd/display/dc/hwss/dce110/dce110_hwseq.c | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 0513784e1c6fc..4e67a94522dc9 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -59,6 +59,7 @@
 #include "dc_state_priv.h"
 #include "dpcd_defs.h"
 #include "dsc.h"
+#include "dc_dp_types.h"
 /* include DCE11 register header files */
 #include "dce/dce_11_0_d.h"
 #include "dce/dce_11_0_sh_mask.h"
@@ -1779,20 +1780,25 @@ static void power_down_encoders(struct dc *dc)
 	int i;
 
 	for (i = 0; i < dc->link_count; i++) {
-		enum signal_type signal = dc->links[i]->connector_signal;
-
-		dc->link_srv->blank_dp_stream(dc->links[i], false);
+		struct dc_link *link = dc->links[i];
+		struct link_encoder *link_enc = link->link_enc;
+		enum signal_type signal = link->connector_signal;
 
+		dc->link_srv->blank_dp_stream(link, false);
 		if (signal != SIGNAL_TYPE_EDP)
 			signal = SIGNAL_TYPE_NONE;
 
-		if (dc->links[i]->ep_type == DISPLAY_ENDPOINT_PHY)
-			dc->links[i]->link_enc->funcs->disable_output(
-					dc->links[i]->link_enc, signal);
+		if (link->ep_type == DISPLAY_ENDPOINT_PHY)
+			link_enc->funcs->disable_output(link_enc, signal);
+
+		if (link->fec_state == dc_link_fec_enabled) {
+			link_enc->funcs->fec_set_enable(link_enc, false);
+			link_enc->funcs->fec_set_ready(link_enc, false);
+			link->fec_state = dc_link_fec_not_ready;
+		}
 
-		dc->links[i]->link_status.link_active = false;
-		memset(&dc->links[i]->cur_link_settings, 0,
-				sizeof(dc->links[i]->cur_link_settings));
+		link->link_status.link_active = false;
+		memset(&link->cur_link_settings, 0, sizeof(link->cur_link_settings));
 	}
 }
 
-- 
2.51.0

