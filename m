Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E306344DBB;
	Tue,  5 May 2026 09:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974778; cv=none; b=V8K1FjQMX+GQezgXcKqnNtOeToB7W0I2/Jr5cPIC7HFF7mVE0ankqbOXKhmoD0JbzKGXQcrrmqnYLlBq1NhjEB2290THYqo7orQxuPodyaZgBD0Fzbai7HCVxIlEv5SeuhCMIWuFpUTVQH4EBfZ0zTsVOLU5Sa9Z1C8RAv0U8lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974778; c=relaxed/simple;
	bh=edflSTmsdQ0tbgYJZNTTtvMTb9kaob9/9JW7H9KvDc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ST/rPxrKqB7Iv/+U0h3yXw5aPNRldyU1vpUeu0SqW83aUI5yA6p32MkBEoHI7pFsJWceL9y48rXYZgstwUe5G9Wm/IGxPsC/V8Guontgg6RqzoCt/uWfr+dmilxfzKz3+9X5lPdrDc09hr0jTMER1GHAjJQu8SvD+y+J97nbu3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUcvXO+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUcvXO+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF6FC2BCB9;
	Tue,  5 May 2026 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974777;
	bh=edflSTmsdQ0tbgYJZNTTtvMTb9kaob9/9JW7H9KvDc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUcvXO+4BE8X8i5dxj+6Tm8CEYckEe/MIjf8Iiu62391GJWb59gavrGVaKJa+Wdh2
	 PJG2NIVukUS/6QeuOM6cR5fNSpA0TRStB8GjsN+7bBIgx4O374oBnDPIKrr4vonLgG
	 15k353NdoftmjQlx4NaK9SFZmETNqrjc5LYF91wDMJ31Nc1S9nEDukRz+zdNqB2mmI
	 5uj8Jx23gEYg3a2CktVWVzRfA3uknSLCk5lG1S/HcqDNjkQh4WJKQtR9mJWCtp0r5i
	 nBGZO8Z3LH3OyyO3B0+uxavPRZB7QLSjSHmSmRm9WNBkvoQmEkzqKjTfW1lKELznP7
	 7mZG4BZgguHZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ASoC: aw88395: Fix kernel panic caused by invalid GPIO error pointer
Date: Tue,  5 May 2026 05:51:37 -0400
Message-ID: <20260505095149.512052-21-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 241ee17ecb6be210f7b231b2a81bfb68871950d0 ]

In aw88395_i2c_probe(), if `devm_gpiod_get_optional()` fails, it returns
an ERR_PTR() error pointer. The current code only prints a message and
continues execution, leaving `aw88395->reset_gpio` as an invalid pointer.

Later, in `aw88395_hw_reset()`, this invalid pointer is passed to
`gpiod_set_value_cansleep()`, which dereferences it and causes a kernel
panic.

For optional GPIOs, `devm_gpiod_get_optional()` returns NULL if the GPIO
is not defined in the DT, which is safe. If it returns an ERR_PTR, it
means a real error occurred (e.g., -EPROBE_DEFER) and the probe must be
aborted.

Also, since the GPIO is optional, remove the dev_err() log in
aw88395_hw_reset() when the GPIO is missing to match the optional
semantics. This also fixes a potential NULL pointer dereference as
aw_pa is not initialized when aw88395_hw_reset() is called.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260428023408.46420-1-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
Step 1.1 Record: Subsystem `ASoC: aw88395`; action verb `Fix`; claimed
intent is preventing probe/reset crashes from invalid or missing
optional reset GPIO handling.

Step 1.2 Record: Tags found: `Signed-off-by: wangdicheng
<wangdicheng@kylinos.cn>`, `Link:
https://patch.msgid.link/20260428023408.46420-1-wangdich9700@163.com`,
`Signed-off-by: Mark Brown <broonie@kernel.org>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable`.

Step 1.3 Record: Commit body describes `devm_gpiod_get_optional()`
returning `ERR_PTR`, current code logging and continuing, then
`aw88395_hw_reset()` using the bad pointer. Verified an additional body
claim: `aw_pa` is uninitialized when `aw88395_hw_reset()` is called, so
the old missing-GPIO `dev_err(aw88395->aw_pa->dev, ...)` path can
dereference NULL.

Step 1.4 Record: This is a real bug fix despite also changing logging:
it fixes probe error handling and removes a pre-initialization NULL
dereference path.

Step 2.1 Record: One file changed: `sound/soc/codecs/aw88395/aw88395.c`,
4 insertions and 5 deletions. Modified functions: `aw88395_hw_reset()`
and `aw88395_i2c_probe()`. Scope is single-file surgical driver fix.

Step 2.2 Record: Hunk 1 changes missing reset GPIO from logging through
`aw88395->aw_pa->dev` to silent no-op. Hunk 2 changes
`IS_ERR(reset_gpio)` from “log and continue” to `return
dev_err_probe(...)`.

Step 2.3 Record: Bug categories: NULL pointer dereference in probe/reset
when optional GPIO is absent; probe error handling bug for `ERR_PTR`
values such as `-EPROBE_DEFER`. I could not verify the commit’s exact
claim that `gpiod_set_value_cansleep()` dereferences an `ERR_PTR`,
because current and checked stable gpiolib validate error pointers
before use.

Step 2.4 Record: Fix quality is good: minimal, contained, follows common
`devm_gpiod_get_optional()` patterns, and uses existing
`dev_err_probe()`. Regression risk is low; the behavior change is to
fail probe on real GPIO acquisition errors and stop logging through an
uninitialized pointer.

Step 3.1 Record: `git blame` shows the buggy lines were introduced by
`62fc25fbab5f4`, “ASoC: codecs: Add i2c and codec registration for
aw88395...”, first contained in `v6.3`.

Step 3.2 Record: No `Fixes:` tag, so there was no tagged introducing
commit to follow; blame identifies `62fc25fbab5f4` as the origin.

Step 3.3 Record: Recent file history shows normal aw88395 codec churn
and no prerequisite patch for this fix. On `fixes-next`, the candidate
`241ee17ecb6b` is the direct relevant change to this file.

Step 3.4 Record: `git log --author=wangdicheng` found no other local
aw88395/codecs commits by this author. Maintainer Mark Brown applied the
patch.

Step 3.5 Record: No dependent commits found. `dev_err_probe()` and the
touched code exist in the checked stable trees; the patch applies
cleanly to representative stable tags.

Step 4.1 Record: `b4 dig -c 241ee17ecb6b` matched the lore submission
`20260428023408.46420-1-wangdich9700@163.com`. `b4 dig -a` found v1 and
v2; v2 is the committed/applied version.

Step 4.2 Record: `b4 dig -w` shows recipients included Mark Brown,
Takashi Iwai, `linux-sound`, and `linux-kernel`.

Step 4.3 Record: No `Reported-by` or external bug report tag. The Link
points to the patch thread. WebFetch of lore was blocked by Anubis, but
b4 successfully retrieved the mboxes.

Step 4.4 Record: v1 changed only the `IS_ERR()` handling. Mark Brown
replied that it looked OK but noted the missing-GPIO `dev_err()` bug. v2
removed that `dev_err()` and was applied by Mark Brown to
`broonie/sound.git for-7.1` as `241ee17ecb6b`.

Step 4.5 Record: Stable-specific lore search through WebFetch was
blocked by Anubis; no stable-specific discussion was verified.

Step 5.1 Record: Modified functions are `aw88395_hw_reset()` and
`aw88395_i2c_probe()`.

Step 5.2 Record: `aw88395_hw_reset()` is called only from
`aw88395_i2c_probe()` in this file. `aw88395_i2c_probe()` is registered
as `.probe` in `aw88395_i2c_driver`.

Step 5.3 Record: Key callees include `devm_gpiod_get_optional()`,
`gpiod_set_value_cansleep()`, `devm_regmap_init_i2c()`, and later
`aw88395_init()`.

Step 5.4 Record: Call chain is I2C driver registration via
`module_i2c_driver()` -> I2C core `i2c_device_probe()` ->
`driver->probe(client)` -> `aw88395_i2c_probe()` ->
`aw88395_hw_reset()`. Trigger is device probe, not an unprivileged
syscall path.

Step 5.5 Record: Similar codec patterns usually return on
`IS_ERR(devm_gpiod_get_optional())`; `aw88166.c`, `wcd937x.c`,
`tlv320dac33.c`, and others show this local convention.

Step 6.1 Record: The driver does not exist in `v5.15` or `v6.1`. The
buggy code exists in `v6.3`, `v6.6`, `v6.12`, `v6.19`, and `v7.0`.

Step 6.2 Record: `git apply --check` passed on current `v7.0.3`;
temporary worktree checks passed cleanly on `v6.6`, `v6.12`, and
`v6.19`.

Step 6.3 Record: No related fix for this aw88395 reset GPIO issue was
found in checked `master`/file history; current stable checkout still
has the old code.

Step 7.1 Record: Subsystem is ALSA SoC codec driver under
`sound/soc/codecs`; criticality is driver-specific/peripheral, but
failure mode is severe for affected hardware.

Step 7.2 Record: aw88395 file history shows moderate ongoing maintenance
since the driver was added in v6.3.

Step 8.1 Record: Affected users are systems using the Awinic AW88395 I2C
codec driver.

Step 8.2 Record: Trigger is probe with missing optional reset GPIO, or
real GPIO acquisition failure such as deferred probe. Unprivileged users
cannot directly trigger this through a normal syscall path based on the
traced call chain.

Step 8.3 Record: Verified failure mode is probe-time NULL dereference
through `aw88395->aw_pa->dev` when `reset_gpio` is NULL before
`aw88395_init()` initializes `aw_pa`. Severity: HIGH/CRITICAL for
affected systems.

Step 8.4 Record: Benefit is high for affected hardware because it
prevents probe-time crash/misprobe. Risk is low: 9-line single-driver
change, no ABI/API changes, clean apply to representative stable trees.

Step 9.1 Record: Evidence for backporting: real NULL deref, correct
handling of `ERR_PTR`, maintainer feedback led to v2, maintainer
applied, small clean patch, affected code present in stable v6.6+.
Evidence against: no explicit reporter/test tag; exact `ERR_PTR` panic
claim was not verified because gpiolib validates error pointers.
Unresolved: no stable-specific lore discussion verified due WebFetch
blocking.

Step 9.2 Record: Stable rules: obviously correct yes; fixes real bug
yes; important issue yes, probe-time crash/oops; small and contained
yes; no new feature/API yes; applies to stable yes for checked
v6.6/v6.12/v6.19/v7.0.

Step 9.3 Record: No automatic exception category applies; this is not a
device ID, quirk, DT-only, build, or documentation patch.

Step 9.4 Record: Decision is backport. The verified NULL dereference
plus probe error handling fix outweigh the low regression risk.

## Verification
- [Phase 1] Parsed commit `241ee17ecb6be210f7b231b2a81bfb68871950d0`
  locally and confirmed tags/message.
- [Phase 2] Inspected patch and current source around
  `aw88395_hw_reset()` and `aw88395_i2c_probe()`.
- [Phase 2] Checked `drivers/gpio/gpiolib.c`: `validate_desc()` handles
  NULL and `IS_ERR()` descriptors before `gpiod_set_value_cansleep()`
  continues.
- [Phase 3] `git blame` traced both changed areas to `62fc25fbab5f4`,
  first present in `v6.3`.
- [Phase 4] `b4 dig` found v1/v2; v1 reviewer feedback from Mark Brown
  requested addressing the optional GPIO logging bug; v2 was applied.
- [Phase 5] Traced caller registration through `.probe`,
  `module_i2c_driver()`, and I2C core `driver->probe(client)`.
- [Phase 6] Verified code absent in `v5.15`/`v6.1`, present in `v6.3+`,
  and cleanly applying to `v6.6`, `v6.12`, `v6.19`, and current
  `v7.0.3`.
- [Phase 8] Verified `aw88395_malloc_init()` uses `devm_kzalloc()`, so
  `aw_pa` is NULL until later `aw88395_init()`.

**YES**

 sound/soc/codecs/aw88395/aw88395.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/aw88395/aw88395.c b/sound/soc/codecs/aw88395/aw88395.c
index 3602b5b9f7d77..dd09bac652f7f 100644
--- a/sound/soc/codecs/aw88395/aw88395.c
+++ b/sound/soc/codecs/aw88395/aw88395.c
@@ -456,8 +456,6 @@ static void aw88395_hw_reset(struct aw88395 *aw88395)
 		usleep_range(AW88395_1000_US, AW88395_1000_US + 10);
 		gpiod_set_value_cansleep(aw88395->reset_gpio, 1);
 		usleep_range(AW88395_1000_US, AW88395_1000_US + 10);
-	} else {
-		dev_err(aw88395->aw_pa->dev, "%s failed", __func__);
 	}
 }
 
@@ -522,9 +520,10 @@ static int aw88395_i2c_probe(struct i2c_client *i2c)
 	i2c_set_clientdata(i2c, aw88395);
 
 	aw88395->reset_gpio = devm_gpiod_get_optional(&i2c->dev, "reset", GPIOD_OUT_LOW);
-	if (IS_ERR(aw88395->reset_gpio))
-		dev_info(&i2c->dev, "reset gpio not defined\n");
-
+	if (IS_ERR(aw88395->reset_gpio)) {
+		return dev_err_probe(&i2c->dev, PTR_ERR(aw88395->reset_gpio),
+				"failed to get reset gpio\n");
+	}
 	/* hardware reset */
 	aw88395_hw_reset(aw88395);
 
-- 
2.53.0

