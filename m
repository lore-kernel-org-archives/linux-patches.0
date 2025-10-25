Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A112F5B;
	Sat, 25 Oct 2025 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408704; cv=none; b=B7e05FOOXYBcxbXnw7CDehHvQ6P9fbqVLy7mPPNwTz2UQqEf4ihISC1DvK145G4q95V+yOHzry6ZCQkJXTS02T9pIzgu9HqeUqjjBi62JQvhO/B7xr88HhOl8wlypLHdQqUz+yH6ZbksX6BR1usiv9v33/9mkfsNbX+8D8FRMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408704; c=relaxed/simple;
	bh=/cI56iyJL+UlSwCls/Va19+RSXDoKFw2JWm5fDdtKP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRXycIqjb9X4q+IdUMiOKcAtmXbCTNkyDLUtXE+tHaDHleKwB2h8lSoKzMSdYEw1OfOWLeJz5mSBs8wBiN96cdGdB1gSYvhnlOMYAAUlB0AC4B2irBOjWoanWbYCX4QZUtdDTSQIKYcrrK4B68vEjNwnydutOgn2s+d7eNZclOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP1g4Jz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP1g4Jz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC34C4CEFB;
	Sat, 25 Oct 2025 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408704;
	bh=/cI56iyJL+UlSwCls/Va19+RSXDoKFw2JWm5fDdtKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YP1g4Jz9XdODV4Qmr1l/LWsownIqWR4W1or4KHTor9x5yfKJd4FddkdmuEYgQOSzZ
	 xsn6uOciJNLc5Ng1Psx/tNz8HO5qUHhTJ2jub72cDah4sSK1Hmw4dC+VOOMgyQ0T3p
	 PvfG7x0BIstN/boioXGWw/SNNNJ3hCBR1/Ql3NKkhPyx3bd5nK3LMPQ/X3DzVtXy0o
	 J/LhTjGtxGtUtyIGjOP497UCMTgaTt8OF7AEEZ4Jx6yhMn6nlPrLogtylkzJHb5n3m
	 CGlkwrCy6trEC+O6+H74AXK3/m3b5B2UHZK4u5HLdTCEA0V5BdFJorxZ4eOm5kkzCQ
	 TgjwetCIQouEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niranjan H Y <niranjan.hy@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] ASoC: ops: improve snd_soc_get_volsw
Date: Sat, 25 Oct 2025 11:54:39 -0400
Message-ID: <20251025160905.3857885-48-sashal@kernel.org>
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

From: Niranjan H Y <niranjan.hy@ti.com>

[ Upstream commit a0ce874cfaaab9792d657440b9d050e2112f6e4d ]

* clamp the values if the register value read is
  out of range

Signed-off-by: Niranjan H Y <niranjan.hy@ti.com>
[This patch originally had two changes in it, I removed a second buggy
 one -- broonie]
--
v5:
 - remove clamp parameter
 - move the boundary check after sign-bit extension
Link: https://patch.msgid.link/20250912083624.804-1-niranjan.hy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The fix clamps the register-derived value before it is re-based in
  `soc_mixer_reg_to_ctl()` (`sound/soc/soc-ops.c:113-127`), preventing
  it from wandering outside `[mc->min, mc->max]`. Without this, any
  register value below `mc->min` (common when a codec powers up with
  zero while the control’s logical minimum is >0 or negative) underflows
  when `mc->min` is subtracted and then wraps through the `& mask`, so
  userspace can observe bogus values above the advertised maximum from
  `snd_soc_get_volsw()` and `snd_soc_get_volsw_sx()`. That mismatch
  breaks ALSA controls built with `SOC_SINGLE_RANGE`,
  `SOC_DOUBLE_R_RANGE`, `SOC_*_S8_TLV`, etc., all of which rely on the
  helper to enforce the declared range.
- Hardware already rejects out-of-range writes via
  `soc_mixer_valid_ctl()`/`soc_mixer_ctl_to_reg()` (`sound/soc/soc-
  ops.c:160-205`), so the user-visible read path was the lone gap;
  adding `clamp()` makes readback consistent with the rest of the
  subsystem and the limits reported by `soc_info_volsw()`.
- This bug is long-standing: older kernels (e.g. v6.9’s
  `snd_soc_get_volsw_sx`) perform the same `value - min` arithmetic
  without any bounds check before masking, so stable trees inherit the
  same failure mode. Backporting only adds the clamp line and has no
  architectural fallout or API change.
- Risk is minimal: `clamp()` is already available, the new bound check
  happens after optional sign-extension (meeting the requirement for
  signed controls), and only narrows the set of values we propagate to
  userspace. Given it fixes real misreports while touching a single
  helper used by all range-aware mixer gets, it fits stable policy well.

Next steps: consider sanity-testing a couple of affected controls (e.g.
via `amixer`) on hardware that boots with out-of-range defaults to
confirm the user-visible values now saturate instead of wrapping.

 sound/soc/soc-ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index a629e0eacb20e..d2b6fb8e0b6c6 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -118,6 +118,7 @@ static int soc_mixer_reg_to_ctl(struct soc_mixer_control *mc, unsigned int reg_v
 	if (mc->sign_bit)
 		val = sign_extend32(val, mc->sign_bit);
 
+	val = clamp(val, mc->min, mc->max);
 	val -= mc->min;
 
 	if (mc->invert)
-- 
2.51.0

