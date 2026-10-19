Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F655F624;
	Mon, 19 Oct 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418257; cv=none; b=J9moGr1PHWEV/KiyzAzhkEjOauPu3aKAiNum3arFY9uny3veNja/c7mHZ6XKU+i89malDf9tfFhqikw8lhNXJVW7peI0eCUM2m3CZbKpIsTTV8hneAmtuOqxUkTO4jJ6x1xkcvMfvJsM34Z149aFKtqOxY8is85Rsp9aRZm0al8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418257; c=relaxed/simple;
	bh=MM+AaQHsp4wpgAhHNkA8vM0Fly5Ksy7GWA4iSSoDAZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7xKYS1MOEzJDA6UKiw01gfXgZxdKr6PqwYxZRKGyaAGLIigVkssGgGx7/sae69fSBUub8JNQa+FjyKWKPT3A0N8v7uzxjvTU116EhIgrJgz8DgIGp/DfFl7AdGAN9qpnQGe243ayLbCsFbLsy2qGSIA1JICh/KHnR4MAPUzv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBQziWuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBQziWuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC6F1F000C4;
	Mon, 19 Oct 2026 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418254;
	bh=wx9Mb4QsaVFHtSfVFCf4Mf+XgS6xKgB1lDQXb9H3s5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBQziWuHfr3bfy+ejeY4kT9ZGxeU93eLsOlIzTc7Z26oAf3etFgU2AdHR3RewfIlu
	 XybQSCmmDu8g/ni5e8H505j90YhvqSgv3Poh/cdRWkVzNRO0OY3gFSa+vCKEDns3Gy
	 XLlbNg1Kfcw3ueZyoW5dotRStmv/IL71mnWmKqhp8b79vlXw+iZXDa/eWHOge/y7Rn
	 YA25XYqIZZ6G215LxXCIUyeDs9TtthEAKkw2uHQZr1Zo4YlsFn10WhBI5MLt3UyhGb
	 4T28hnjHhc3sDWnL0PVym4A6rkwQL5BdP1Bxm0xW8yQjptBBvJEEHeFULZYVmImDBO
	 o+RXHpz71x++Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: codec: max98926: fixup invert setup mask
Date: Mon, 19 Oct 2026 09:46:53 -0400
Message-ID: <20261019135441.1420968-122-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit dd0ae9a2e19a24c532c9aa80a44f572b4907bcdf ]

invert might have both WCI/BCI mask, but regmap_update_bits() masks
BCI only. It needs both mask. Fixup it.

	static int max98926_dai_set_fmt(...)
	{
		...
		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
		case SND_SOC_DAIFMT_NB_NF:
			break;
		case SND_SOC_DAIFMT_NB_IF:
=>			invert = MAX98926_DAI_WCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^
		case SND_SOC_DAIFMT_IB_NF:
=>			invert = MAX98926_DAI_BCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^
		case SND_SOC_DAIFMT_IB_IF:
=>			invert = MAX98926_DAI_BCI_MASK | MAX98926_DAI_WCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		default:
			...
		}
		...
		regmap_update_bits(max98926->regmap, MAX98926_FORMAT,
				MAX98926_DAI_BCI_MASK, invert);
		...		^^^^^^^^^^^^^^^^^^^^^
	}

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87wltomc97.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a **6.12.111** tree (`pending-6.12`, `p-6.12-3-gc504cf0baa3d8`).
The candidate is `dd0ae9a2e19a2` (“ASoC: codec: max98926: fixup invert
setup mask”). It is **not** in this checkout; the buggy
`regmap_update_bits()` mask **is**.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `ASoC: codec: max98926`
- Action verb: `fixup`
- Claimed intent: correct the invert-mode bit mask written to the
  MAX98926 FORMAT register

Record: **[ASoC/max98926] [fixup] [WCI invert bit never programmed
because update mask is BCI-only]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>`
  (author)
- `Link: https://patch.msgid.link/87wltomc97.wl-
  kuninori.morimoto.gx@renesas.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)

Record: **Author + ASoC maintainer SOB; lore Link; no user/syzbot
report**

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The body shows `max98926_dai_set_fmt()` building `invert` as:
- `NB_IF` → `MAX98926_DAI_WCI_MASK`
- `IB_NF` → `MAX98926_DAI_BCI_MASK`
- `IB_IF` → `BCI | WCI`

then calling `regmap_update_bits(..., MAX98926_DAI_BCI_MASK, invert)`.
`regmap_update_bits()` only changes bits in the mask, so WCI is never
written.

Record: **[Bug: WCI invert bit dropped] [Symptom: inverted frame clock
not applied] [No version info] [Root cause: BCI-only mask]**

**Step 1.4: DETECT HIDDEN BUG FIXES**
This is an explicit register-programming bug, not a disguised cleanup.

Record: **Not a hidden fix; it is a real DAI-format bug**

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `sound/soc/codecs/max98926.c` (`1 insertion, 1 deletion`)
- Function: `max98926_dai_set_fmt()`
- Scope: single-file, one-line surgical fix

Record: **[max98926.c +1/-1] [max98926_dai_set_fmt] [surgical]**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (this tree, lines 360–363):

```360:364:sound/soc/codecs/max98926.c
        regmap_write(max98926->regmap,
                        MAX98926_FORMAT, MAX98926_DAI_DLY_MASK);
        regmap_update_bits(max98926->regmap, MAX98926_FORMAT,
                        MAX98926_DAI_BCI_MASK, invert);
        return 0;
```

`regmap_write()` sets FORMAT to only `DAI_DLY_MASK` (WCI and BCI
cleared). Then update_bits can set BCI, but never WCI.

After: mask is `MAX98926_DAI_BCI_MASK | MAX98926_DAI_WCI_MASK`, so both
invert bits can be set.

Record: **[BCI-only update → BCI|WCI update on DAI set_fmt path]**

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Header bits in this tree:

```525:528:sound/soc/codecs/max98926.h
#define MAX98926_DAI_WCI_MASK           (1<<3)
...
#define MAX98926_DAI_BCI_MASK           (1<<2)
```

This is a logic/correctness bug: wrong `regmap` mask, so advertised
invert modes do not take effect.

Record: **[Logic/correctness] [WCI never written for NB_IF/IB_IF]**

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: it matches sibling `max98925.c` (already uses `BCI |
WCI`). Minimal. No API/locking/refcount change. Regression risk is near
zero: NB_NF still writes 0 into both bits; IB_NF still sets only BCI.

Record: **[Obviously correct, 1-line] [Very low regression risk]**

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
`git blame -L 343,363 -- sound/soc/codecs/max98926.c`: the buggy mask is
from `a2e2876aa0bab` (“ASoC: Add max98926 codec driver”, Anish Kumar,
2016-01-14). `git describe --contains a2e2876aa0bab` → `v4.6-rc1~...`.
Present for ~10 years.

Record: **[a2e2876aa0bab, v4.6] [long-standing bug]**

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. The introducing commit is in this tree (`git merge-base
--is-ancestor a2e2876aa0bab HEAD` succeeded).

The **identical** bug in the sibling driver was already treated as
stable material:

```
0b51601d4504f4 ASoC: max98925: Fix mask for setting DAI invert mode
...
Cc: stable@vger.kernel.org
```

That 2015 fix is in this tree. max98926 (2016) reintroduced the same
mistake.

Record: **[No Fixes tag; sibling max98925 fix was Cc: stable]
[Introducing commit is in this 6.12 tree]**

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `max98926.c` history in this tree is probe/OF/DAI-terminology
churn, not invert-mask work. No prerequisite refactor. Standalone 1-line
change.

Record: **[No prerequisites] [Standalone]**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Kuninori Morimoto is a regular ASoC contributor. Nearby work includes
`alc5623` invert tidyup (different driver, “tidyup” not this bug). This
patch is a standalone `[PATCH]`, not patch X/Y.

Record: **[Core ASoC contributor] [Standalone invert-mask fix, not a
series]**

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
The hunk matches this tree exactly. `git show dd0ae9a2e19a2 | git apply
--check` → **APPLY_CLEAN**. No new helpers or structs.

Record: **[No dependencies] [Applies standalone and cleanly]**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c dd0ae9a2e19a2` → https://patch.msgid.link/87wltomc97.wl-
kuninori.morimoto.gx@renesas.com
`b4 dig -a`: single v1, no later revisions.
Mbox (2 messages): submission + Mark Brown “Applied to for-7.3”. No NAK,
no review concerns, no `Cc: stable` request. Included in the “sound
fixes for 7.3-rc1” pull.

Record: **[v1 only] [Applied by ASoC maintainer] [No objections]
[Treated as a fix in the rc1 pull]**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` recipients: Jaroslav Kysela, Liam Girdwood, Mark Brown,
Takashi Iwai, linux-sound@. Maintainer applied it the same day.

Record: **[ASoC/ALSA maintainers on To; Mark Brown applied]**

**Step 4.3: SEARCH FOR THE BUG REPORT**
No `Reported-by` / bugzilla / syzbot. Found by code inspection (same
class as Axel Lin’s 2015 max98925 fix).

Record: **[No user report; bug is visible from the code and sibling
driver]**

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone `[PATCH]`. No follow-ups on `all-next` after this commit for
`max98926.c`.

Record: **[Standalone; no later superceding patch]**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Search for this title on lore stable did not find a prior stable
discussion (unrelated hits only).

Record: **[No stable-list discussion found]**

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: **[`max98926_dai_set_fmt`]**

**Step 5.2: TRACE CALLERS**
Wired as `.set_fmt` in `max98926_dai_ops`. ASoC core
`snd_soc_dai_set_fmt()` in `sound/soc/soc-dai.c` calls
`dai->driver->ops->set_fmt`. `sound/soc/soc-core.c` applies DAI format
from the card/DAI link at setup.

Record: **[Called from ASoC DAI format setup, not a hot IRQ path]**

**Step 5.3: TRACE CALLEES**
`regmap_write` / `regmap_update_bits` on `MAX98926_FORMAT`.

Record: **[Register programming only]**

**Step 5.4: FOLLOW THE CALL CHAIN**
Reachable when a MAX98926 card configures DAI format (DT `dai-format` /
machine driver). Unprivileged users typically cannot change invert
flags, but boot/stream setup hits this. `NB_IF` / `IB_IF` are the broken
cases (`soc-dai.h`: inverted frame).

Record: **[Reachable on DAI setup for this codec] [Broken for inverted
frame clock]**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
This tree: only `max98926.c` still uses BCI-only. `max98925.c` already
uses `BCI | WCI`.

Record: **[Sibling already fixed; this is the remaining copy of the same
bug]**

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `git merge-base --is-ancestor dd0ae9a2e19a2 HEAD` failed (fix not
present). Surrounding code in this tree matches the parent of the
candidate commit. Introduced in v4.6, still here in 6.12.111.

Record: **[Buggy code present at max98926_dai_set_fmt] [Since v4.6]**

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Context is identical; `git apply --check` is clean.

Record: **[Clean apply]**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No invert-mask fix for max98926 in this tree. max98925’s equivalent fix
**is** already here.

Record: **[No prior max98926 invert fix; sibling fix already present]**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`sound/soc/codecs/max98926.c` — Maxim MAX98926 speaker amplifier.
`CONFIG_SND_SOC_MAX98926` is selected via `SND_SOC_ALL_CODECS` imply; DT
compatible `maxim,max98926` exists. No in-tree board file found that
hard-codes this codec.

Record: **[ASoC codec driver] [PERIPHERAL, but real hardware]**

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Codec file is mature; little recent functional change.

Record: **[Mature driver; bug is old, not a new-feature regression]**

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Users of MAX98926 whose DAI link requests inverted word/frame clock
(`NB_IF` or `IB_IF`). Default `NB_NF` is unaffected.

Record: **[Driver-specific; only inverted-frame configurations]**

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Triggered at DAI format setup (card bring-up / PCM start). Common I2S is
`NB_NF` (works). Inverted frame is less common but is a documented,
handled mode in this function. Not a userspace-triggered security issue.

Record: **[DAI setup] [Uncommon invert modes] [Not unprivileged-
exploitable]**

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
WCI never programmed → LRCLK/frame polarity wrong → swapped channels,
DAI desync, or unusable playback. Not a panic/UAF/deadlock.

Record: **[Incorrect audio DAI polarity] [Severity: MEDIUM-HIGH for
affected devices; not CRITICAL crash]**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Benefit: makes advertised invert modes actually work; same class of
  fix max98925 already shipped to stable.
- Risk: 1-line mask OR, no API/locking change, applies cleanly.

Record: **[Benefit: medium for this hardware] [Risk: very low]
[Favorable]**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, obvious register bug: WCI invert is computed then discarded
- One-line, obviously correct; matches max98925
- Identical max98925 fix (`0b51601d4504f4`) was `Cc: stable`
- Bug present since v4.6 and in this 6.12 tree
- Applies cleanly; no dependencies or new APIs
- Applied by Mark Brown; landed in a sound **fixes** pull
- User-visible: inverted frame clock does not work

AGAINST:
- Not a crash, UAF, deadlock, or security issue
- Peripheral codec; no in-tree machine driver found
- No `Reported-by` / `Tested-by`
- Common `NB_NF` path already works

UNRESOLVED:
- Direct user reports of broken MAX98926 inverted-frame setups were not
  found
- lore.kernel.org WebFetch returned 403; discussion recovered via `b4
  dig -m`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line mask, sibling
   precedent, maintainer applied
2. Fixes a real bug that affects users? **PASS** — advertised invert
   modes do not program WCI
3. Important issue? **PASS** — hardware misconfiguration / broken audio
   for inverted frame (same bar as the 2015 max98925 stable fix), not a
   panic
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   context matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Not a device-ID/quirk/DT/build/docs exception. It is a normal small
driver correctness fix.

**Step 9.4: MAKE YOUR DECISION**
This belongs in **this** 6.12 tree. The buggy code is here, the fix is
trivial and already proven on the sibling codec (including an explicit
stable nomination there), and the only cost is flipping one register
mask bit that the driver already intended to set.

### What the commit solves for stable users
On MAX98926, `set_fmt` claims to support word-clock invert (`NB_IF` /
`IB_IF`) but `regmap_update_bits()` only allows the BCI bit to change,
so LRCLK invert never reaches the chip. That is broken DAI polarity for
those boards, not a style change.

### Risk vs benefit
Very low risk (one OR into an existing mask) versus a real, long-
standing hardware-config bug that already met the stable bar on
max98925.

### Concerns
None for this tree: no prerequisites, no conflict, no follow-up needed.
Impact is limited to MAX98926 with inverted frame clock.

---

## Verification
- [Phase 1] Parsed tags: author SOB, Mark Brown SOB, lore Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: 1 line in `max98926_dai_set_fmt()`; mask `BCI` → `BCI
  | WCI`
- [Phase 2] Header verified: WCI is bit 3, BCI is bit 2 in `max98926.h`
- [Phase 3] `git blame`: buggy line from `a2e2876aa0bab` (2016, v4.6)
- [Phase 3] `git merge-base --is-ancestor a2e2876aa0bab HEAD`:
  introducing commit **is** in this tree
- [Phase 3] Sibling fix `0b51601d4504f4` (“Fix mask for setting DAI
  invert mode”) had `Cc: stable@vger.kernel.org` and is in this tree
- [Phase 3] `git log` on `max98926.c`: no invert-mask prerequisite
- [Phase 4] `b4 dig -c dd0ae9a2e19a2`: lore URL `87wltomc97.wl-
  kuninori.morimoto.gx@renesas.com`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Kysela, Girdwood, Brown, Iwai, linux-sound
- [Phase 4] mbox: Mark Brown applied to for-7.3; no NAKs
- [Phase 4] WebFetch lore/msgid: 403; discussion taken from b4 mbox
  instead
- [Phase 4] Stable lore search: no prior discussion of this patch
- [Phase 5] Callers: `snd_soc_dai_set_fmt()` → dai ops `.set_fmt`; used
  from `soc-core.c` DAI setup
- [Phase 5] `git grep`: only max98926 still has BCI-only invert update
- [Phase 6] `make kernelversion` / Makefile: **6.12.111**; `git describe
  HEAD`: `p-6.12-3-gc504cf0baa3d8`
- [Phase 6] `git merge-base --is-ancestor dd0ae9a2e19a2 HEAD`: fix
  **not** in this tree
- [Phase 6] Parent context of candidate matches local `max98926.c` lines
  360–363
- [Phase 6] `git apply --check`: APPLY_CLEAN
- [Phase 7] No in-tree machine driver hard-coding max98926; DT
  compatible `maxim,max98926` exists
- [Phase 8] Failure mode: WCI not programmed → wrong frame polarity /
  broken audio; not a crash
- UNVERIFIED: specific MAX98926 products using `NB_IF`/`IB_IF` in the
  field (driver still implements those cases)

**YES**

 sound/soc/codecs/max98926.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98926.c b/sound/soc/codecs/max98926.c
index ae962bda163eb..8f48f702d5621 100644
--- a/sound/soc/codecs/max98926.c
+++ b/sound/soc/codecs/max98926.c
@@ -360,7 +360,7 @@ static int max98926_dai_set_fmt(struct snd_soc_dai *codec_dai,
 	regmap_write(max98926->regmap,
 			MAX98926_FORMAT, MAX98926_DAI_DLY_MASK);
 	regmap_update_bits(max98926->regmap, MAX98926_FORMAT,
-			MAX98926_DAI_BCI_MASK, invert);
+			MAX98926_DAI_BCI_MASK | MAX98926_DAI_WCI_MASK, invert);
 	return 0;
 }
 
-- 
2.53.0

