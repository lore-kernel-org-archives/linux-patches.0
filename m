Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C648377A80;
	Wed, 23 Sep 2026 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173471; cv=none; b=cURO4v62uZbHAk5teBN8hluS8ZPwhJ1IzUrGXBUK7TnetDtvcSFEwtbMl3CHzmqMPDrvgTSWKFFzHxEk2GUfVZSE2LmBkqBvpyE6Q3EzwgmjDLAUSZHDqJuOQKFTQmxVP3h/IMVLjM8Zuya4UaHoPSFg9oTkGH1l0y5/cDkrHgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173471; c=relaxed/simple;
	bh=ZNRCUWD8xMEX2AwgXuY0mc4Kb3OKvEvmlubc0QChngA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5VNThQJZVIMSj9Y/qW8xX9ayKDucksbp393YAjVJP0BTWsB3vwuOyWu9u3b6iSOv3J8PcWOeZQs36oNdvWSgpNr/9kian4Y35Jl4OoTA0ZzxR1FQFH+k79FYdjxDOFoNoKDg7ZnkM5T0Ip+cCBKabZJjMBLrrLBkuIzYBJeewo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmN9/kLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmN9/kLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DC71F000FF;
	Wed, 23 Sep 2026 14:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173470;
	bh=gzMhtq5NBSBp4zYFNMC/I7snkytoOVBkODxrrlOJtIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmN9/kLfvgZsEvsy5A4kiOeo1BKpNaVw0qwpzSZGmUkvOqXu/mLL0qhDR00P2B+GF
	 qfDRKHdazVKvajIVk8yXmPf2C3GMgtwW+LHNcIzYV/+yYsJOAZT4gPX+amjMvWYf8I
	 SjHZUpL5UlSKy6xR3lgjeVtpI8KN/lMOAS6ATD9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Marlou Pacaro <pacaro.francis.marlou.n@gmail.com>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 223/438] drm/amd/display: fix MALL hysteresis timer underflow at high refresh rates
Date: Wed, 23 Sep 2026 16:04:04 +0200
Message-ID: <20260923140650.545138856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francis Marlou Pacaro <pacaro.francis.marlou.n@gmail.com>

[ Upstream commit 2ac2fe765ef475f409616ac0b57c4a3922749b0f ]

dcn30_apply_idle_power_optimizations() derives the MALL frame cache
hysteresis timer with

	tmr_delay = (uint32_t)(div_u64(..., denom) - 64LL);

div_u64() returns a u64, so when the quotient is smaller than 64 the
subtraction wraps instead of going negative and tmr_delay ends up huge.
The loop that follows tries to squeeze it into the 6 bit register field
by doubling denom, but that only makes the quotient smaller, so tmr_delay
can never converge.  tmr_scale is bumped past 3 and the function gives up
with

	/* Delay exceeds range of hysteresis timer */
	ASSERT(false);

even though the requested delay is too *short* to encode, not too long.

With mall_additional_timer_percent left at its default of 0, the quotient
drops below 64 once the refresh rate used for the calculation goes above
~243 Hz.  Every DCN 3.0 display above that loses MALL static screen
entirely and splats a WARN once per boot.  Reproduced on Navi 23
(RX 6600) driving 1920x1080, resetting /sys/kernel/debug/clear_warn_once
between modes:

	refresh   MALL       ASSERT
	144 Hz    enabled    no
	240 Hz    enabled    no
	280 Hz    skipped    yes
	360 Hz    skipped    yes

Commit 3bb68cec4db8 ("drm/amd/display: Add Overflow check to skip MALL")
already covered the other end of the range, where a large stutter period
makes the delay too long to encode.  Cover the short end by clamping to
0, which selects the shortest hysteresis the register can express,
65.28us * 64 = ~4.18ms.  That is marginally longer than what the formula
asks for at these refresh rates, and erring long is the safe direction:
it only delays MALL entry, it can never enter early.

The numerator does not change between iterations, only denom does, so
compute it once and keep both call sites inside 100 columns.

The genuinely out of range case at very low refresh rates still reaches
the ASSERT, which is where it belongs.

Fixes: 52f2e83e2fe5 ("drm/amdgpu/display: add MALL support (v2)")
Signed-off-by: Francis Marlou Pacaro <pacaro.francis.marlou.n@gmail.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 387550e53e1405f1f960b62b22f8783db17c8e1d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
index 2d3587a31bc8b..2ecd3a4068c03 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -1058,10 +1058,12 @@ bool dcn30_apply_idle_power_optimizations(struct dc *dc, bool enable)
 				 */
 				unsigned int denom = refresh_hz * 6528;
 				unsigned int stutter_period = dc->current_state->perf_params.stutter_period_us;
+				uint64_t num = (1000000LL + 2 * stutter_period * refresh_hz) *
+					(100LL + dc->debug.mall_additional_timer_percent);
+				uint64_t tmr_ticks;
 
-				tmr_delay = (uint32_t)(div_u64(((1000000LL + 2 * stutter_period * refresh_hz) *
-						(100LL + dc->debug.mall_additional_timer_percent) + denom - 1),
-						denom) - 64LL);
+				tmr_ticks = div_u64(num + denom - 1, denom);
+				tmr_delay = tmr_ticks > 64 ? (uint32_t)(tmr_ticks - 64) : 0;
 
 				/* In some cases the stutter period is really big (tiny modes) in these
 				 * cases MALL cant be enabled, So skip these cases to avoid a ASSERT()
@@ -1083,9 +1085,8 @@ bool dcn30_apply_idle_power_optimizations(struct dc *dc, bool enable)
 					}
 
 					denom *= 2;
-					tmr_delay = (uint32_t)(div_u64(((1000000LL + 2 * stutter_period * refresh_hz) *
-							(100LL + dc->debug.mall_additional_timer_percent) + denom - 1),
-							denom) - 64LL);
+					tmr_ticks = div_u64(num + denom - 1, denom);
+					tmr_delay = tmr_ticks > 64 ? (uint32_t)(tmr_ticks - 64) : 0;
 				}
 
 				/* Copy HW cursor */
-- 
2.53.0



