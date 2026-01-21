Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C333F8B2;
	Wed, 21 Jan 2026 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019744; cv=none; b=ruOMrS9q4EJTRHMHsmigu7o99/QM/zFijx3fl3sPf2SlsXuIq/X7UoDG9rlytMrJoZbHrwLhZt3zBXM6MbQ21YlWqtOhM7DciuA7+djR3KKhyX/gWaS9dPpBh4wzDORW0eG9Qe/P2VfEl5+ENtCiaCickFtr4qfpiCFEnlQWqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019744; c=relaxed/simple;
	bh=rjZE5BshAOnkWBbBj43h8LJfH+V1pZU8aaeTy5+IGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFqhBrbkrRV6ejexDPxwBFJa6MW4eCoySs05lcKtad/0FwF7Hny3W400rUZgH39DF9ohjYCS49PgSdLuHMBSQYQHIFubMWfev+uI6J98s2J90phTem+OkSUq/lJkeyt8jwMI9z4XBbeAnlYTdFiLxFkwiOYL+HB6KWXfEcjy3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVKiF6JI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVKiF6JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053D1C4CEF1;
	Wed, 21 Jan 2026 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019744;
	bh=rjZE5BshAOnkWBbBj43h8LJfH+V1pZU8aaeTy5+IGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVKiF6JI4WHFBQdaecy8kbwN1Pe/WNeBKmx/VopTTw5rwVJFVdrNnEUMdlwOehg9l
	 dGy4KpFtJmT1Ad7jWKohr4vdiNI4Wc7Tf/42BFyEqDWzhpFgMUyppM0kko1R76YV4C
	 8HuW1+no89PX7ndpALWM1qIS4HPlTC7TeQpvx1WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.12 062/139] drm/amd/display: mark static functions noinline_for_stack
Date: Wed, 21 Jan 2026 19:15:10 +0100
Message-ID: <20260121181413.685879306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit a8d42cd228ec41ad99c50a270db82f0dd9127a28 upstream.

When compiling allmodconfig (CONFIG_WERROR=y) with clang-19, see the
following errors:

.../display/dc/dml2/display_mode_core.c:6268:13: warning: stack frame size (3128) exceeds limit (3072) in 'dml_prefetch_check' [-Wframe-larger-than]
.../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:7236:13: warning: stack frame size (3256) exceeds limit (3072) in 'dml_core_mode_support' [-Wframe-larger-than]

Mark static functions called by dml_prefetch_check() and
dml_core_mode_support() noinline_for_stack to avoid them become huge
functions and thus exceed the frame size limit.

A way to reproduce:
$ git checkout next-20250107
$ mkdir build_dir
$ export PATH=/tmp/llvm-19.1.6-x86_64/bin:$PATH
$ make LLVM=1 O=build_dir allmodconfig
$ make LLVM=1 O=build_dir drivers/gpu/drm/ -j

The way how it chose static functions to mark:
[0] Unset CONFIG_WERROR in build_dir/.config.
To get display_mode_core.o without errors.

[1] Get a function list called by dml_prefetch_check().
$ sed -n '6268,6711p' drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c \
  | sed -n -r 's/.*\W(\w+)\(.*/\1/p' | sort -u >/tmp/syms

[2] Get the non-inline function list.
Objdump won't show the symbols if they are inline functions.

$ make LLVM=1 O=build_dir drivers/gpu/drm/ -j
$ objdump -d build_dir/.../display_mode_core.o | \
  ./scripts/checkstack.pl x86_64 0 | \
  grep -f /tmp/syms | cut -d' ' -f2- >/tmp/orig

[3] Get the full function list.
Append "-fno-inline" to `CFLAGS_.../display_mode_core.o` in
drivers/gpu/drm/amd/display/dc/dml2/Makefile.

$ make LLVM=1 O=build_dir drivers/gpu/drm/ -j
$ objdump -d build_dir/.../display_mode_core.o | \
  ./scripts/checkstack.pl x86_64 0 | \
  grep -f /tmp/syms | cut -d' ' -f2- >/tmp/noinline

[4] Get the inline function list.
If a symbol only in /tmp/noinline but not in /tmp/orig, it is a good
candidate to mark noinline.

$ diff /tmp/orig /tmp/noinline

Chosen functions and their stack sizes:
CalculateBandwidthAvailableForImmediateFlip [display_mode_core.o]:144
CalculateExtraLatency [display_mode_core.o]:176
CalculateTWait [display_mode_core.o]:64
CalculateVActiveBandwithSupport [display_mode_core.o]:112
set_calculate_prefetch_schedule_params [display_mode_core.o]:48

CheckGlobalPrefetchAdmissibility [dml2_core_dcn4_calcs.o]:544
calculate_bandwidth_available [dml2_core_dcn4_calcs.o]:320
calculate_vactive_det_fill_latency [dml2_core_dcn4_calcs.o]:272
CalculateDCFCLKDeepSleep [dml2_core_dcn4_calcs.o]:208
CalculateODMMode [dml2_core_dcn4_calcs.o]:208
CalculateOutputLink [dml2_core_dcn4_calcs.o]:176

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[nathan: Fix conflicts in dml2_core_dcn4_calcs.c]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c                        |   12 +++++-----
 drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c |    8 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -1736,7 +1736,7 @@ static void CalculateBytePerPixelAndBloc
 #endif
 } // CalculateBytePerPixelAndBlockSizes
 
-static dml_float_t CalculateTWait(
+static noinline_for_stack dml_float_t CalculateTWait(
 		dml_uint_t PrefetchMode,
 		enum dml_use_mall_for_pstate_change_mode UseMALLForPStateChange,
 		dml_bool_t SynchronizeDRRDisplaysForUCLKPStateChangeFinal,
@@ -4458,7 +4458,7 @@ static void CalculateSwathWidth(
 	}
 } // CalculateSwathWidth
 
-static  dml_float_t CalculateExtraLatency(
+static noinline_for_stack dml_float_t CalculateExtraLatency(
 		dml_uint_t RoundTripPingLatencyCycles,
 		dml_uint_t ReorderingBytes,
 		dml_float_t DCFCLK,
@@ -5915,7 +5915,7 @@ static dml_uint_t DSCDelayRequirement(
 	return DSCDelayRequirement_val;
 }
 
-static dml_bool_t CalculateVActiveBandwithSupport(dml_uint_t NumberOfActiveSurfaces,
+static noinline_for_stack dml_bool_t CalculateVActiveBandwithSupport(dml_uint_t NumberOfActiveSurfaces,
 										dml_float_t ReturnBW,
 										dml_bool_t NotUrgentLatencyHiding[],
 										dml_float_t ReadBandwidthLuma[],
@@ -6019,7 +6019,7 @@ static void CalculatePrefetchBandwithSup
 #endif
 }
 
-static dml_float_t CalculateBandwidthAvailableForImmediateFlip(
+static noinline_for_stack dml_float_t CalculateBandwidthAvailableForImmediateFlip(
 													dml_uint_t NumberOfActiveSurfaces,
 													dml_float_t ReturnBW,
 													dml_float_t ReadBandwidthLuma[],
@@ -6213,7 +6213,7 @@ static dml_uint_t CalculateMaxVStartup(
 	return max_vstartup_lines;
 }
 
-static void set_calculate_prefetch_schedule_params(struct display_mode_lib_st *mode_lib,
+static noinline_for_stack void set_calculate_prefetch_schedule_params(struct display_mode_lib_st *mode_lib,
 						   struct CalculatePrefetchSchedule_params_st *CalculatePrefetchSchedule_params,
 						   dml_uint_t j,
 						   dml_uint_t k)
@@ -6265,7 +6265,7 @@ static void set_calculate_prefetch_sched
 				CalculatePrefetchSchedule_params->Tno_bw = &mode_lib->ms.Tno_bw[k];
 }
 
-static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
+static noinline_for_stack void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 {
 	struct dml_core_mode_support_locals_st *s = &mode_lib->scratch.dml_core_mode_support_locals;
 	struct CalculatePrefetchSchedule_params_st *CalculatePrefetchSchedule_params = &mode_lib->scratch.CalculatePrefetchSchedule_params;
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -2774,7 +2774,7 @@ static double dml_get_return_bandwidth_a
 	return return_bw_mbps;
 }
 
-static void calculate_bandwidth_available(
+static noinline_for_stack void calculate_bandwidth_available(
 	double avg_bandwidth_available_min[dml2_core_internal_soc_state_max],
 	double avg_bandwidth_available[dml2_core_internal_soc_state_max][dml2_core_internal_bw_max],
 	double urg_bandwidth_available_min[dml2_core_internal_soc_state_max], // min between SDP and DRAM
@@ -4066,7 +4066,7 @@ static bool ValidateODMMode(enum dml2_od
 	return true;
 }
 
-static void CalculateODMMode(
+static noinline_for_stack void CalculateODMMode(
 	unsigned int MaximumPixelsPerLinePerDSCUnit,
 	unsigned int HActive,
 	enum dml2_output_format_class OutFormat,
@@ -4164,7 +4164,7 @@ static void CalculateODMMode(
 #endif
 }
 
-static void CalculateOutputLink(
+static noinline_for_stack void CalculateOutputLink(
 	struct dml2_core_internal_scratch *s,
 	double PHYCLK,
 	double PHYCLKD18,
@@ -6731,7 +6731,7 @@ static void calculate_bytes_to_fetch_req
 	}
 }
 
-static void calculate_vactive_det_fill_latency(
+static noinline_for_stack void calculate_vactive_det_fill_latency(
 		const struct dml2_display_cfg *display_cfg,
 		unsigned int num_active_planes,
 		unsigned int bytes_required_l[],


