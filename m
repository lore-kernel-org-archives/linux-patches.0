Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46081FFC48;
	Sat, 14 Feb 2026 01:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031259; cv=none; b=FeQZ8SqwyQ8J8kkOQgqmwOQW1r9L2x8MBmL3Fhr588DkbLYMGZwr00mqc14W3ZhO9ao7mo62Kn63QS3K2PkXF0jpMPQ6gfMuSFcCn54aSvloyJin4YzCzsTbGwcGaGJkyWNlDB21QhhQX7m7QYmNYCFMH32nBNJ/gZK9hNGTB9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031259; c=relaxed/simple;
	bh=PLV+QGyrfuZhs0mjPr04kQuIaDWgAcoy9szoMIGquQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayLD4Ydh31SlVNwugv+4RZhVkoZL5EuaRUlDG3Ab+7RRj5NzYmMVh/Zc53mECpXxzyXffxuJkU56Vnckp7jMNWlfWUpvQxQsjb8/jCTxbEjisMw3qe8PyPwUS63cNyDyuUNMAkP2Z3vyWDCu4R71yATD0klC0Gw4+zeuA8Rw3Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHe1IBly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHe1IBly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B73BC19423;
	Sat, 14 Feb 2026 01:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031258;
	bh=PLV+QGyrfuZhs0mjPr04kQuIaDWgAcoy9szoMIGquQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHe1IBly8teM8/uJXPPmdyXDn5IMsnEqjrCx1LerBBQjgEGPZJywVRkcRZyV4beJC
	 wRdkeoCxXKHH6oKUcpu9DwwUy2fZkM4fo9h68HkEiC7JIvbWGeK+o8Ek1Z1mjHhNjr
	 FkteFEm0/qVrGqs/1mqVgXmXvjgnqZTrHP8eyaw5y+nfrBACHbp9k2FZNbEVYK0IWn
	 rA9RtAGzbLFVs7RqWdVVx4gAWo5Wk63jf1IkptMHVoap/V6qHCdCwsojP0VZE5OGUI
	 WoWgNItsu23G422KJxysw5y3n5/n1pGHfEFLTZ9A+ILg49IUKuHD4d30C6M62adxjj
	 Neqb5affYi7BA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peichen Huang <PeiChen.Huang@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Cruise.Hung@amd.com,
	meenakshikumar.somasundaram@amd.com,
	rvojvodi@amd.com,
	timur.kristof@gmail.com,
	george.shen@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	superm1@kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amd/display: Don't disable DPCD mst_en if sink connected
Date: Fri, 13 Feb 2026 20:00:04 -0500
Message-ID: <20260214010245.3671907-124-sashal@kernel.org>
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

From: Peichen Huang <PeiChen.Huang@amd.com>

[ Upstream commit 9aeb31b2456452257ad1ff7ec566f21bab1f3e8a ]

[WHY]
User may connect mst dock with multi monitors and do quick unplug
and plug in one of the monitor. This operatioin may create CSN from
dock to display driver. Then display driver would disable and then enable
mst link and also disable/enable DPCD mst_en bit in dock RX. However,
when mst_en bit being disabled, if dock has another CSN message to
transmit then the message would be removed because of the disabling of
mst_en. In this case, the message is missing and it ends up no display in
the replugged monitor.

[HOW]
Don't disable mst_en bit when link still has sink connected.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me analyze the patch fully.

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly explains a real-world user-facing bug:

**Problem:** When a user has an MST dock (e.g., a USB-C/Thunderbolt dock
with multiple DisplayPort outputs) with multiple monitors, and quickly
unplugs and re-plugs one monitor, the dock generates a Connection Status
Notification (CSN) to the display driver. The driver handles this by
disabling and re-enabling the MST link, which includes toggling the DPCD
`mst_en` bit. However, when `mst_en` is disabled, if the dock has
another CSN message to transmit (for the still-connected monitors), that
message is discarded. The result is that the re-plugged monitor shows no
display.

**Fix:** Don't disable the `mst_en` bit when there are still sinks
connected to the link.

The commit has:
- `Reviewed-by: Wenjing Liu` (AMD display team member)
- `Tested-by: Daniel Wheeler` (AMD QA)
- `Signed-off-by: Alex Deucher` (AMD display subsystem maintainer)

### 2. CODE CHANGE ANALYSIS

The patch has 4 hunks, all in a single file (`link_dpms.c`), with 11
lines added and 5 removed:

**Hunk 1 (Critical fix - `disable_link_dp`):**
```c
// Before:
if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
    enable_mst_on_sink(link, false);

// After:
if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST && link->sink_count == 0)
    enable_mst_on_sink(link, false);
```
This is the core fix. It adds a single condition `link->sink_count == 0`
to ensure `mst_en` is only disabled when all sinks have been
disconnected. This prevents the race where a CSN from the dock is lost
because `mst_en` was momentarily disabled while other monitors are still
connected.

**Hunk 2 (Complementary fix - `enable_link_dp`):**
```c
// Before:
if (DP_128b_132b_ENCODING && SST && set_mst_en_for_sst) {
    enable_mst_on_sink(link, true);
}

// After:
if (DP_128b_132b_ENCODING && SST && set_mst_en_for_sst) {
    enable_mst_on_sink(link, true);
} else if (link->dpcd_caps.is_mst_capable && SST) {
    enable_mst_on_sink(link, false);
}
```
This is the complementary change. When re-enabling a link in SST mode on
an MST-capable sink, the patch explicitly disables MST mode on the sink.
This ensures that if `disable_link_dp` skipped the `mst_en` disable
(because `sink_count > 0`), it is properly cleaned up when re-enabling
the link in SST mode.

**Hunks 3 & 4 (Debug logging):**
These add `sink_count` to the debug log messages in `link_set_dpms_off`
and `link_set_dpms_on` — purely for debugging/observability, zero risk.

### 3. CLASSIFICATION

This is a **bug fix** for a real-world user-visible issue: monitors
connected through MST docks failing to display after hot-plug events.
This is a common scenario — USB-C docks with multiple monitor outputs
are extremely popular.

### 4. SCOPE AND RISK ASSESSMENT

- **Size:** Very small — 11 lines added, 5 removed, 1 file changed
- **Scope:** Localized to MST link enable/disable paths in the AMD
  display driver
- **Risk:** LOW
  - Hunk 1 adds a defensive guard condition that preserves existing
    behavior when `sink_count == 0` (the last sink disconnects) — it's
    strictly narrowing when `mst_en` is cleared
  - Hunk 2 adds an explicit `mst_en` disable for SST-on-MST-capable-
    sink, which is a correct complement to hunk 1
  - Debug logging changes have zero risk
- **Subsystem:** AMD display driver — mature, well-tested subsystem
- **Could it break something?** The guard `link->sink_count == 0` is
  correct — if there are still sinks, we should not disable MST mode on
  the dock. The `enable_link_dp` complementary change is also sound:
  when connecting in SST mode to an MST-capable sink, explicitly
  disabling MST mode is the correct DPCD protocol behavior.

### 5. USER IMPACT

This affects **anyone using MST docks (USB-C/Thunderbolt docks with
multi-monitor support) with AMD GPUs**, which is a very common
configuration, especially in:
- Laptops with AMD integrated graphics (Ryzen mobile) connected to docks
- Desktop systems with AMD discrete GPUs using DP MST hubs

The bug manifests as **no display on a re-plugged monitor** after a
quick unplug/plug cycle, which is a common user action. The severity is
HIGH — a non-functional monitor requires manual intervention (re-plug,
driver restart, or reboot) to recover.

### 6. STABILITY INDICATORS

- `Reviewed-by` from Wenjing Liu (AMD DC team)
- `Tested-by` from Daniel Wheeler (AMD QA)
- Signed off by Alex Deucher (AMD GPU maintainer who reviews all AMDGPU
  commits)
- No reverts or follow-up fixes found

### 7. DEPENDENCY CHECK

- `link->sink_count` exists in all relevant stable trees (v6.1, v6.6,
  v6.12)
- `link->dpcd_caps.is_mst_capable` exists in all relevant stable trees
- `enable_mst_on_sink()` function exists identically in all relevant
  stable trees
- The `disable_link_dp()` function's MST handling code is identical
  across v6.6, v6.12, and mainline
- The `enable_link_dp()` function's MST workaround block is also present
  in all stable trees
- **No dependencies on other commits** — this patch is completely self-
  contained
- The patch should apply cleanly to v6.6 and v6.12 (minor context
  differences in a distant function signature for `dp_set_fec_enable` in
  v6.6 may require a trivial context adjustment, but the key hunks are
  identical)

### 8. RISK VS BENEFIT

- **Benefit:** Fixes a real, user-hitting bug where monitors go blank
  through MST docks — a very common hardware configuration
- **Risk:** Minimal — the change is small, surgical, well-understood,
  and was tested by AMD QA
- The logic is clearly correct: don't clear MST mode when there are
  still active sinks, and ensure MST mode is cleared when re-enabling in
  SST mode

The fix is small, surgical, addresses a real user-visible bug with MST
docks (a very common configuration), has been reviewed and tested by AMD
engineers, has no dependencies, and the affected code exists in all
current stable trees.

**YES**

 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index a6f1b3569f6f5..0b85826c7ea70 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -1931,7 +1931,7 @@ static void disable_link_dp(struct dc_link *link,
 			link->dc->hwss.edp_power_control(link, false);
 	}
 
-	if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
+	if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST && link->sink_count == 0)
 		/* set the sink to SST mode after disabling the link */
 		enable_mst_on_sink(link, false);
 
@@ -2082,7 +2082,12 @@ static enum dc_status enable_link_dp(struct dc_state *state,
 			pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT &&
 			link->dc->debug.set_mst_en_for_sst) {
 		enable_mst_on_sink(link, true);
+	} else if (link->dpcd_caps.is_mst_capable &&
+		pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT) {
+		/* disable mst on sink */
+		enable_mst_on_sink(link, false);
 	}
+
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_EDP) {
 		/*in case it is not on*/
 		if (!link->dc->config.edp_no_power_sequencing)
@@ -2368,9 +2373,9 @@ void link_set_dpms_off(struct pipe_ctx *pipe_ctx)
 	if (pipe_ctx->stream->sink) {
 		if (pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_VIRTUAL &&
 			pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_NONE) {
-			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d\n", __func__,
+			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d sink_count=%d\n", __func__,
 			pipe_ctx->stream->sink->edid_caps.display_name,
-			pipe_ctx->stream->signal, link->link_index);
+			pipe_ctx->stream->signal, link->link_index, link->sink_count);
 		}
 	}
 
@@ -2484,10 +2489,11 @@ void link_set_dpms_on(
 	if (pipe_ctx->stream->sink) {
 		if (pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_VIRTUAL &&
 			pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_NONE) {
-			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d\n", __func__,
+			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d sink_count=%d\n", __func__,
 			pipe_ctx->stream->sink->edid_caps.display_name,
 			pipe_ctx->stream->signal,
-			link->link_index);
+			link->link_index,
+			link->sink_count);
 		}
 	}
 
-- 
2.51.0

