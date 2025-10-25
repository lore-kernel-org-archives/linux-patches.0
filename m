Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86D5304BC9;
	Sat, 25 Oct 2025 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409720; cv=none; b=K865d5RETEFWSMy5j92ULuNVdqXknETUdqSG5WD0SNIRfczhgQmaFIXG6L6kW53QDbit6z1R/+9+gDH+F+0660x8wY6TotLIyvwRIyiBZ1wGhZkvRiSIqPYlM9bPotzx9Lve2fUQM5JA8hGIOsoRp7XsPOuFogkDMe6QNythtpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409720; c=relaxed/simple;
	bh=d9LbX26gL7YqzOiudrvgt57eHEmI+kF6jITcVt1XyEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THDLUPUirce/vlvyCCfs77OcBkXQOnskhDVA6ab/ifOUn5/yphdFDcLzdJutjVs58jMv+qAKsgIPLE5kCHczbCcMXFEHQrQdOAW8ytLr7F5370CE2GAJcEfQqGnMzio3J6eKABjLTkF5m8fKCZ+m5tf+S60kEl6P13bFnLxj44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfoPYCX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfoPYCX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64213C4CEF5;
	Sat, 25 Oct 2025 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409720;
	bh=d9LbX26gL7YqzOiudrvgt57eHEmI+kF6jITcVt1XyEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfoPYCX3bDsZ1IuPs7PWOmEqNqjGk0LsPMUi5VjphfOBmw/l9o5mdsGXsODIpKgo1
	 GsdZT882hRCKzbekj+29Dtp8dR2DI/9U9++BWlPP8n2dfTJmEYMom/7b8Px4/CMl9Y
	 f+o7EZqZkGEPkdhzVoqxY+K9fMyM9USJZ4cYaLgp02GkrlIr2vRKzrzPO1nXXgGw5Z
	 QUhDcqSdFLBu460K67/wkFmLOzu7iLWuw9NO72tim9NLrkUbbnakN9JlKgcNFHi7Mp
	 AeHrC8rP/QbxdalPRk0MNqXYGtpYtsC2bPS9HQrL7JI3ybk/xeQmGttvyJrCdgsYTV
	 tbVUEj83+6UaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Wayne.Lin@amd.com,
	roman.li@amd.com,
	alvin.lee2@amd.com,
	ray.wu@amd.com,
	Dillon.Varone@amd.com,
	PeiChen.Huang@amd.com,
	Sung.Lee@amd.com,
	Charlene.Liu@amd.com,
	alexandre.f.demers@gmail.com,
	Richard.Chiang@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: fix condition for setting timing_adjust_pending
Date: Sat, 25 Oct 2025 12:01:06 -0400
Message-ID: <20251025160905.3857885-435-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 1a6a3374ecb9899ccf0d209b5783a796bdba8cec ]

timing_adjust_pending is used to defer certain programming sequences
when OTG timing is about to be changed, like with VRR. Insufficient
checking for timing change in this case caused a regression which
reduces PSR Replay residency.

Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes and why it matters
  - Addresses a regression that reduced Panel Replay/PSR residency by
    spuriously deferring DRR timing updates; this impacts power and user
    experience on AMD eDP/VRR systems.
  - The regression stems from setting `timing_adjust_pending` even when
    the requested DRR timing does not actually change, causing
    Replay/PSR to remain disabled unnecessarily.

- Precise code change and behavior
  - In `drivers/gpu/drm/amd/display/dc/core/dc.c:445` (function
    `dc_stream_adjust_vmin_vmax`), the deferral gate:
    - Before: sets `stream->adjust.timing_adjust_pending = true` and
      returns `false` whenever `(dc->optimized_required ||
      dc->wm_optimized_required)` under `if (dc->ctx->dce_version >
      DCE_VERSION_MAX)`.
    - After: only does so when there is a real DRR timing change:
      - Adds `(stream->adjust.v_total_max != adjust->v_total_max ||
        stream->adjust.v_total_min != adjust->v_total_min)` to the
        condition.
  - Effect: avoids marking a timing change “pending” during bandwidth
    optimization windows unless VMIN/VMAX actually differ, eliminating
    false-positive deferrals.

- Why this is a good stable backport candidate
  - Bug/regression fix: Prevents unnecessary Replay/PSR disablement
    (commit message explicitly cites reduced PSR Replay residency).
  - Minimal and contained: A single conditional tightened in AMD DC
    code; no API/ABI or architectural changes.
  - Low risk:
    - When a timing change is real, behavior is unchanged (it still
      defers).
    - When there is no change, it stops needlessly setting
      `timing_adjust_pending`, preventing spurious disablement of
      Replay/PSR.
  - Clear positive side effects: Restores intended PSR Replay residency
    and reduces redundant DRR programming attempts.
  - Tested/Reviewed by AMD DC maintainers, indicating the scenario is
    understood and covered.

- Context with related code paths
  - The pending flag is consulted by DM to decide if timing programming
    is required; see
    `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:363` in
    `is_dc_timing_adjust_needed()`, which returns true if
    `new_state->stream->adjust.timing_adjust_pending` is set. The fix
    ensures this flag reflects real timing changes only, preventing
    unnecessary commits that keep PSR/Replay off.
  - Interacts safely with the existing paths in
    `dc_stream_adjust_vmin_vmax` (e.g., `dc_exit_ips_for_hw_access(dc)`,
    long vtotal handling, and `set_drr`), which remain unchanged and
    continue to clear `timing_adjust_pending` when appropriate.

- Applicability across stable trees
  - Trees that already contain the DRR deferral logic which sets
    `timing_adjust_pending` during BW/WM optimization windows (as in
    6.12.y; see the block around
    `drivers/gpu/drm/amd/display/dc/core/dc.c:445`) should take this fix
    to avoid the regression.
  - Older trees (e.g., some 6.6.y states) which still drop DRR updates
    without deferring (no `timing_adjust_pending` set in that path)
    won’t benefit directly from this exact change; they would first need
    the earlier deferral patch. Stable maintainers can gate this
    backport to branches where that deferral exists.

- Stable rules alignment
  - Fixes a user-visible regression (power/perf via PSR Replay
    residency).
  - Small, targeted, and confined to a single driver subsystem.
  - No feature addition; no architectural churn.
  - Reviewed/Tested by relevant maintainers; safe to backport.

 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index dcc48b5238e53..bb189f6773397 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -459,7 +459,9 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 	 * avoid conflicting with firmware updates.
 	 */
 	if (dc->ctx->dce_version > DCE_VERSION_MAX) {
-		if (dc->optimized_required || dc->wm_optimized_required) {
+		if ((dc->optimized_required || dc->wm_optimized_required) &&
+			(stream->adjust.v_total_max != adjust->v_total_max ||
+			stream->adjust.v_total_min != adjust->v_total_min)) {
 			stream->adjust.timing_adjust_pending = true;
 			return false;
 		}
-- 
2.51.0

