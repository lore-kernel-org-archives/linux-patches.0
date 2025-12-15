Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545FE2FD684;
	Mon, 15 Dec 2025 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759331; cv=none; b=cNppXqAOfRuPFniISRoWXsk0ZKWdHy9w/9+Dqe5rfZ+H+563qZI8wx2RWUxyN+yvhXqyV1vIjizT4MmUk3UZ5/01w7pktx6R3UxNR1qjKb3phQvElnpOPO2AnoPV8iSXkZlcc5hyxjalc8vJzXGBjElOw2frNHTDp7y39IoNzcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759331; c=relaxed/simple;
	bh=kuWJhXAe9SCj/OWGFt8enynHLN+ZYtr4H1zNXLrgJ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3lD+hasPn3C8xMT0CZGJ2vXWAi1fIbZzt6gQqIlc3UrrRtnmgvZY9sIjsHZXQeJ4byr7NtkTJE2UR856mD4woOjRpT5AW/IxTep8v/0s9N3DdXNvQkgNcNNJ05+aEKMe2eufKVKDg4FZ6KsFz92Ye8MirX+ky2wpMb9dWa/N64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lwkcj2+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lwkcj2+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2617AC4CEFB;
	Mon, 15 Dec 2025 00:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759331;
	bh=kuWJhXAe9SCj/OWGFt8enynHLN+ZYtr4H1zNXLrgJ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lwkcj2+J8GayBKYflfBuBuE5czrsEaMfaXy9bvIz5OL3vQXju3EzguKtAOk8oM3Yi
	 btZWaoP3/goRlGdTae3VXPY2F/l+UgKvpi7+VoR3cfWS3N5PnBbQ+WtGD+/SoOcYsF
	 tB9R3QKBOGLIFwSejPyLH4kSc2a0Z4hHYt49gAbZ2ONB9alRU7q2boQmIZof7QDTuT
	 hSF9ifUZYYfI50pLjF1RbyRPqEy39x842JED8Wh2jahzn7FiYZrUNdhPu34ebSw6ZX
	 EHKivPaXoIPPwISPZhuLCY0mhYxNRNlpjYQJpOLJo7GrY5sH2ksv/CJF4zKLt5n3N4
	 TUMMyNgA8yFIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Charlene.Liu@amd.com,
	aurabindo.pillai@amd.com,
	alvin.lee2@amd.com,
	timur.kristof@gmail.com,
	Ausef.Yousof@amd.com,
	Zhongwei.Zhang@amd.com,
	Martin.Leung@amd.com,
	srinivasan.shanmugam@amd.com
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: shrink struct members
Date: Sun, 14 Dec 2025 19:41:27 -0500
Message-ID: <20251215004145.2760442-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215004145.2760442-1-sashal@kernel.org>
References: <20251215004145.2760442-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7329417fc9ac128729c3a092b006c8f1fd0d04a6 ]

On a 32-bit ARM system, the audio_decoder struct ends up being too large
for dp_retrain_link_dp_test.

link_dp_cts.c:157:1: error: the frame size of 1328 bytes is larger than
1280 bytes [-Werror=frame-larger-than=]

This is mitigated by shrinking the members of the struct and avoids
having to deal with dynamic allocation.

feed_back_divider is assigned but otherwise unused. Remove both.

pixel_repetition looks like it should be a bool since it's only ever
assigned to 1. But there are checks for 2 and 4. Reduce to uint8_t.

Remove ss_percentage_divider. Unused.

Shrink refresh_rate as it gets assigned to at most a 3 digit integer
value.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3849efdc7888d537f09c3dcfaea4b3cd377a102e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: drm/amd/display: shrink struct members

### 1. COMMIT MESSAGE ANALYSIS

The commit addresses a **build failure** on 32-bit ARM systems:
```
link_dp_cts.c:157:1: error: the frame size of 1328 bytes is larger than
1280 bytes [-Werror=frame-larger-than=]
```

The fix shrinks struct members to reduce stack frame size. Key changes:
- Remove `feed_back_divider` (assigned but never read - write-only)
- Remove `ss_percentage_divider` (completely unused)
- Shrink `pixel_repetition` from `uint32_t` to `uint8_t` (only assigned
  1, checked for 2,4 - all fit in uint8_t)
- Shrink `refresh_rate` from `uint32_t` to `uint16_t` ("at most 3 digit
  integer")

The commit is already marked as "(cherry picked from commit
3849efdc7888...)" indicating it was deemed important for another tree.

### 2. CODE CHANGE ANALYSIS

**In `dce110_hwseq.c`:**
- Removes one assignment: `audio_output->pll_info.feed_back_divider =
  pipe_ctx->pll_settings.feedback_divider;`
- This was a write to an unused field - safe to remove

**In `audio_types.h`:**
- `struct audio_crtc_info`: Type changes and reordering for better
  packing
- `struct audio_pll_info`: Removes two unused fields, reorders remaining
  members

These are **internal kernel structures** used within the AMD display
driver - not part of any userspace ABI.

### 3. CLASSIFICATION

This is a **BUILD FIX** - one of the explicitly allowed exception
categories for stable trees. The `-Werror=frame-larger-than=` flag is
commonly enabled in kernel builds, especially on embedded/ARM systems,
and this causes a hard compilation failure.

### 4. SCOPE AND RISK ASSESSMENT

**Lines changed:** Small - 2 files, ~20 lines modified
**Subsystem:** AMD display driver (DCE110 hardware sequencer, audio
types)

**Risk factors:**
- Struct layout changes - LOW risk since these are internal driver
  structures
- Removing unused fields - VERY LOW risk (can't break what's not used)
- Type narrowing (uint32_t → uint16_t/uint8_t) - LOW risk as values
  confirmed to fit

**Risk mitigation:**
- Reviewed by Alex Hung (AMD developer)
- Signed off by Alex Deucher (AMD display maintainer)
- Already cherry-picked to another tree

### 5. USER IMPACT

- **Affected users:** Anyone building Linux kernel on 32-bit ARM systems
  with AMD display support
- **Severity:** Build fails completely - users cannot compile the kernel
- **Scope:** Primarily embedded ARM systems running AMD GPUs

### 6. STABILITY INDICATORS

- `Reviewed-by: Alex Hung <alex.hung@amd.com>` ✓
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (maintainer)
  ✓
- Already cherry-picked (deemed important) ✓

### 7. DEPENDENCY CHECK

The commit is self-contained. It only removes unused code and shrinks
types - no dependencies on other commits. The affected code (AMD
display, DCE110 HWSEQ, audio_types.h) exists in stable trees.

### Summary

**Pros:**
- Fixes a real build failure (compile error, not just warning)
- Build fixes are explicitly allowed in stable rules
- Small, contained changes
- Removes unused/dead code (lowest risk category)
- Type changes are provably safe (values fit)
- Reviewed and signed-off by AMD maintainers
- Already cherry-picked

**Cons:**
- Struct layout changes require careful consideration
- Only affects 32-bit ARM with specific kernel config

### Verdict

This is a legitimate **build fix** - one of the explicit exceptions in
stable kernel rules. The changes are low-risk: removing unused struct
members and narrowing types to values that demonstrably fit. The build
error affects real users on 32-bit ARM platforms. The fix has been
properly reviewed by AMD maintainers and already cherry-picked,
indicating it's deemed important. The risk of runtime regression is
minimal since unused code is being removed.

**YES**

 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    |  3 ---
 drivers/gpu/drm/amd/display/include/audio_types.h    | 12 +++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index ebc220b29d142..b94fec8347400 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1458,9 +1458,6 @@ void build_audio_output(
 						state->clk_mgr);
 	}
 
-	audio_output->pll_info.feed_back_divider =
-			pipe_ctx->pll_settings.feedback_divider;
-
 	audio_output->pll_info.dto_source =
 		translate_to_dto_source(
 			pipe_ctx->stream_res.tg->inst + 1);
diff --git a/drivers/gpu/drm/amd/display/include/audio_types.h b/drivers/gpu/drm/amd/display/include/audio_types.h
index e4a26143f14c9..6699ad4fa825e 100644
--- a/drivers/gpu/drm/amd/display/include/audio_types.h
+++ b/drivers/gpu/drm/amd/display/include/audio_types.h
@@ -47,15 +47,15 @@ struct audio_crtc_info {
 	uint32_t h_total;
 	uint32_t h_active;
 	uint32_t v_active;
-	uint32_t pixel_repetition;
 	uint32_t requested_pixel_clock_100Hz; /* in 100Hz */
 	uint32_t calculated_pixel_clock_100Hz; /* in 100Hz */
-	uint32_t refresh_rate;
+	uint32_t dsc_bits_per_pixel;
+	uint32_t dsc_num_slices;
 	enum dc_color_depth color_depth;
 	enum dc_pixel_encoding pixel_encoding;
+	uint16_t refresh_rate;
+	uint8_t pixel_repetition;
 	bool interlaced;
-	uint32_t dsc_bits_per_pixel;
-	uint32_t dsc_num_slices;
 };
 struct azalia_clock_info {
 	uint32_t pixel_clock_in_10khz;
@@ -78,11 +78,9 @@ enum audio_dto_source {
 
 struct audio_pll_info {
 	uint32_t audio_dto_source_clock_in_khz;
-	uint32_t feed_back_divider;
+	uint32_t ss_percentage;
 	enum audio_dto_source dto_source;
 	bool ss_enabled;
-	uint32_t ss_percentage;
-	uint32_t ss_percentage_divider;
 };
 
 struct audio_channel_associate_info {
-- 
2.51.0

