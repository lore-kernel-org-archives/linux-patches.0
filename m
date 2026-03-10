Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0243CECE;
	Tue, 10 Mar 2026 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133315; cv=none; b=mBBBxSrQ85GQSM2ITR6zvN99TYqrMhX14sXqGzk0XRMCtODkxulb+82jOAyZ53fJUr62uNjQxeTjK7YgtovvHcaB96P+9Mf06NBTAfJXR9WLoWAyLt3LhXM3X4rnRo2ZMyMWuFHq7oIPpmIPBmCBkVhC7yn5TQIa3/tiz/X2lls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133315; c=relaxed/simple;
	bh=qADLJsEOtlwHVdyvIQ5k0hd5TQcGaz9PzQzZoF6moBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Akk81rvrthoGKCQSWeY8KcPktXCzwGNk0tB9h/YdAkr79xWx7AlCjiSwsXBh77sZPw5N0BqSyRWu375v8p84Ebe2oS3mFnF2GqLauz6k1vxtg2f4vqsr7VjCqeJG8v6Uz6T66krUufvB4PBB759DyPb6YR95pykyUJGin+PMoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciOetug8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciOetug8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1401CC2BC86;
	Tue, 10 Mar 2026 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133314;
	bh=qADLJsEOtlwHVdyvIQ5k0hd5TQcGaz9PzQzZoF6moBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciOetug8b1De1UuRxheXHQVr4CoJcD+RtuBqwaAt2O5tw8gbXhDWG4rBQfKyJbOlO
	 lLtQUaVSQKQkSdOklgTpSDr1KNatMNt+ZcMLCjR3aG5WxrpGasOo9TJx6strVyAw4w
	 2CIgOzfbIHvLrX5q7ak3Ox2a5/Jd+obcHqSbS/EqYAVhmQLmH4V0EFGoHjw2o1/MXa
	 zraZOFyI9ta3YPoq108aUDqBe3RV6kG0pviaqXUMQV7e9LpChIeVk6LpDdkcfTWtmF
	 t8veOpNwoMbm0dyvUq8jDRH/Mh6JXHMuzaoObXFQCpbSS99hFSHftD0lm57XrxEyy0
	 8WxkAqbYX8FCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	bo.liu@senarytech.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/senary: Ensure EAPD is enabled during init
Date: Tue, 10 Mar 2026 05:01:05 -0400
Message-ID: <20260310090145.2709021-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 7ae0d8f1abbbba6f98cac735145e1206927c67d9 ]

The driver sets spec->gen.own_eapd_ctl to take manual control of the
EAPD (External Amplifier). However, senary_init does not turn on the
EAPD, while senary_shutdown turns it off.

Since the generic driver skips EAPD handling when own_eapd_ctl is set,
the EAPD remains off after initialization (e.g., after resume), leaving
the codec in a non-functional state.

Explicitly call senary_auto_turn_eapd in senary_init to ensure the EAPD
is enabled and the codec is functional.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260303081516.583438-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So 6.12.y is an active LTS. The driver exists there (since v6.11) but in
its old form. A backport would need adaptation.

## Analysis

**What the commit fixes:**

This commit fixes a real functional bug in the Senarytech HDA audio
codec driver. The problem:

1. The driver sets `spec->gen.own_eapd_ctl = 1` during probe, telling
   the generic HDA framework "I'll manage EAPD myself, don't touch it"
2. `senary_shutdown()`/`senary_suspend()` turns EAPD **off** (to avoid
   spurious noises during reboot/suspend)
3. `senary_init()` (called during resume and initial setup) **never
   turns EAPD back on**
4. Since the generic framework skips EAPD because `own_eapd_ctl` is set,
   EAPD remains off
5. Result: **codec is non-functional after resume** - no audio output

This is an asymmetry bug that has existed since the driver was first
introduced in v6.11. The Conexant driver (which senarytech is based on)
correctly handles this by calling `cx_auto_turn_eapd()` in its init
function; the senarytech driver forgot to include this.

**The fix:**
- Adds `senary_auto_turn_eapd(codec, spec->num_eapds, spec->eapds,
  true)` to `senary_init()`
- Adds a `dynamic_eapd` field (currently never set to true) to match the
  Conexant driver's pattern, where dynamic EAPD control via the vmaster
  hook makes the unconditional enable unnecessary
- The actual fix is 3 lines of effective code change

**Stable criteria assessment:**
- **Fixes a real bug:** Yes - audio completely broken after resume
- **Obviously correct:** Yes - mirrors the exact pattern from Conexant
  driver; simple symmetry fix
- **Small and contained:** Yes - 3 functional lines in one file
- **No new features:** The `dynamic_eapd` field addition is structural
  preparation matching Conexant, but it's never set to true, so it's
  inert
- **User impact:** HIGH - any user with Senarytech SN6186 codec loses
  audio after suspend/resume

**Dependency concerns:**
- The driver was rewritten in commit 3cea413834503 (v6.17) - function
  names changed from `senary_auto_init` to `senary_init`
- For stable trees 6.12.y through 6.16.y, the patch needs adaptation to
  the old function names
- For stable trees older than 6.11, the driver doesn't exist (N/A)
- The fix itself is conceptually simple and can be adapted

**Risk assessment:** Very low. This is a trivially correct fix that
mirrors an established pattern from the parent Conexant driver. The code
path is init-only and simply enables the external amplifier that
shutdown already knows how to disable.

**Verification:**
- `git show eb882afcfa839` confirmed the original driver (v6.11) had the
  same bug - `senary_auto_init()` never called EAPD enable while
  `senary_auto_shutdown()` disabled it
- `git tag --contains eb882afcfa839` confirmed the driver was first
  included in v6.11
- `git tag --contains 3cea413834503` confirmed the rewrite happened in
  v6.17
- Examined Conexant driver (`sound/hda/codecs/conexant.c`) lines 189-193
  and confirmed it has the identical `if (!spec->dynamic_eapd)
  cx_auto_turn_eapd(...)` pattern in its init function
- Confirmed `dynamic_eapd` is never set to true in senarytech.c (only
  declared and checked), so the guard is always entered
- Read the full senarytech.c and confirmed `own_eapd_ctl = 1` at line
  182 prevents the generic framework from managing EAPD
- Confirmed `senary_suspend()` calls `senary_shutdown()` which disables
  EAPD, creating the asymmetry
- `git tag --contains 6014e9021b28e` confirmed the file was moved to its
  current location in v6.17

**YES**

 sound/hda/codecs/senarytech.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/codecs/senarytech.c b/sound/hda/codecs/senarytech.c
index 63cda57cf7868..f4732a8d7955d 100644
--- a/sound/hda/codecs/senarytech.c
+++ b/sound/hda/codecs/senarytech.c
@@ -28,6 +28,7 @@ struct senary_spec {
 	/* extra EAPD pins */
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
+	bool dynamic_eapd;
 	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
@@ -134,8 +135,12 @@ static void senary_init_gpio_led(struct hda_codec *codec)
 
 static int senary_init(struct hda_codec *codec)
 {
+	struct senary_spec *spec = codec->spec;
+
 	snd_hda_gen_init(codec);
 	senary_init_gpio_led(codec);
+	if (!spec->dynamic_eapd)
+		senary_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, true);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
 	return 0;
-- 
2.51.0

