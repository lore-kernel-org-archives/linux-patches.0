Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0119A1E9B35;
	Tue, 28 Oct 2025 00:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612008; cv=none; b=Nm2U2ynpzc40NnZ7ywDpCV1PjO+087AnOQEpdr4XZ4xPUaOXuVobnSWySrnrgROsbhmG7n1dPfL3bWg/M6TjEUPKqqGdaJZTEhwgD23uC+K+28uFK1GDAmQj7UHm1hgZfxo/HKK3jFuuQURyOD1HiI8RUXrpIvHD/f8hnHY0cFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612008; c=relaxed/simple;
	bh=iFwyVq5eteXLFrsbWhqM4Wqoxgu8Kh5yVdtBebZ0cgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAKUrtrphU6Sm7Yvti2Uay49mafHcCFmWCm75dUzKv2rqA9VcoiBfxsBS+goCL3ZuXPcvsyp51OiP9LCxbjFFv4mLDqldS2IzNC1wgEOmkTJAOwKDNKr1HJ54K1pWIADoZvzU4/09KdHquQufYdTgr5G0ifFw/Hb5Wjv7wt9KaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSaXvF10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSaXvF10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A062C4CEFB;
	Tue, 28 Oct 2025 00:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612004;
	bh=iFwyVq5eteXLFrsbWhqM4Wqoxgu8Kh5yVdtBebZ0cgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSaXvF10DsXoxVRq8CVuCsICSj1xCDZ3OdmX1p2D++7zgbx+1CkdDIV2ojHfcJfPG
	 L3rqvg7kRJq3B2aluJ7Ke+o4IqI0S+71U2ntSIN6HhXDGEPUJKqKwLnsG+sBhif+wp
	 +ZCbxdd70kLOWiGiFTuNpiO26XGg7tz+in5WWp2Iw0agf1LBGqgJzB2i2WRWBPQv7I
	 wa0krQfMz6iNaHEvyu6kcAGYMcVS34jtDmZwTntUMysTjNYYaF/VG63S3ZAp+63GeD
	 Mm/oBc9yMxmbbJmJ/uD4RKpFbzpieng6uhhHbQGCiYoo0TXQkNSaY2un7Ai9pAl44K
	 TwIdTTutvyJlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
Date: Mon, 27 Oct 2025 20:38:53 -0400
Message-ID: <20251028003940.884625-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ee70bacef1c6050e4836409927294d744dbcfa72 ]

The interrupt handler offloads the microphone detection logic to
nau8821_jdet_work(), which implies a sleep operation.  However, before
being able to process any subsequent hotplug event, the interrupt
handler needs to wait for any prior scheduled work to complete.

Move the sleep out of jdet_work by converting it to a delayed work.
This eliminates the undesired blocking in the interrupt handler when
attempting to cancel a recently scheduled work item and should help
reducing transient input reports that might confuse user-space.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-5-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis using semantic code analysis tools and repository
examination, here is my assessment:

## **Backport Status: YES**

## Detailed Analysis:

### 1. Semantic Analysis Tools Used:

- **mcp__semcode__find_function**: Located the three affected functions
  (`nau8821_jdet_work`, `nau8821_interrupt`,
  `nau8821_enable_jack_detect`)
- **mcp__semcode__find_callers**: Identified that
  `nau8821_enable_jack_detect` is called by 2 AMD machine drivers
  (acp5x_8821_init, acp_8821_init)
- **mcp__semcode__find_type**: Examined the `struct nau8821` definition
  to understand the data structure change
- **Grep**: Analyzed all `cancel_work_sync` calls and `msleep` usage
  patterns in the driver
- **Git analysis**: Verified no follow-up fixes or reverts exist for
  this commit

### 2. Code Analysis - What Changed:

The commit addresses a **kernel programming anti-pattern: blocking in an
interrupt handler**.

**Before (problematic code):**
- `nau8821_jdet_work` (work handler) contains `msleep(20)` at
  sound/soc/codecs/nau8821.c:1115
- IRQ handler calls `cancel_work_sync()` at lines 1208 and 1222, which
  blocks waiting for work completion
- If work is sleeping, IRQ handler blocks for 20ms+ (unacceptable
  latency)

**After (fixed code):**
- Converted `struct work_struct` → `struct delayed_work`
- Removed `msleep(20)` from work handler
- Moved MICBIAS enable to IRQ handler, schedule delayed work with
  `msecs_to_jiffies(20)`
- Changed to `cancel_delayed_work_sync()` - won't block on sleeping work

### 3. Impact Scope Assessment:

**Call Graph Analysis:**
- Affects NAU8821 audio codec driver (used on AMD Vangogh platforms)
- 2 machine drivers call this code (AMD ACP platforms)
- User-triggerable via hardware jack insertion/ejection events
- Affects real consumer hardware (likely Steam Deck and similar AMD
  devices)

**Exposure:**
- Hardware interrupt path → directly user-facing
- Bug causes measurable interrupt latency (20ms blocking)
- Commit message states it helps "reducing transient input reports that
  might confuse user-space"

### 4. Complexity and Risk Analysis:

**Change Complexity: LOW**
- Only 2 files modified: nau8821.c (22 lines) and nau8821.h (2 lines)
- Simple type conversion: `work_struct` → `delayed_work`
- No API changes, no new dependencies
- Logic remains functionally equivalent (same 20ms delay, just
  implemented differently)

**Regression Risk: VERY LOW**
- Standard kernel pattern (delayed_work is designed exactly for this use
  case)
- Similar fix exists in WM8350 codec: "Use delayed work to debounce
  WM8350 jack IRQs"
- No follow-up fixes found in git history (ee70bacef1c60..HEAD shows no
  corrections)
- 4 subsequent commits to driver are unrelated (DMI quirks, interrupt
  clearing)

### 5. Backport Suitability Criteria:

| Criterion | Assessment | Details |
|-----------|------------|---------|
| Fixes important bug? | ✅ YES | Blocking in IRQ handler violates kernel
design |
| Small and contained? | ✅ YES | 24 lines changed, single subsystem |
| No new features? | ✅ YES | Pure bug fix |
| No architectural changes? | ✅ YES | Just work→delayed_work conversion
|
| Low regression risk? | ✅ YES | Standard pattern, no follow-up fixes |
| User impact? | ✅ YES | Improves latency, reduces spurious events |
| Has stable tag? | ❌ NO | No "Cc: stable" or "Fixes:" tag |

### 6. Why Backport Despite No Stable Tag:

1. **Correctness Issue**: Blocking in IRQ handlers is a documented
   kernel anti-pattern that can cause system-wide latency issues
2. **Real Hardware Impact**: Affects consumer devices with NAU8821 codec
   (AMD platforms)
3. **Safe Fix**: Uses standard kernel pattern (delayed_work), minimal
   code change
4. **Proven Stable**: Already in v6.18-rc2 with no reported issues or
   fixes
5. **User-Visible Benefit**: Reduces interrupt latency and spurious jack
   detection events

### Recommendation:

**This commit should be backported** to stable kernels that support the
affected hardware. It fixes a legitimate kernel programming bug
(blocking in IRQ context) with a small, safe, well-tested change. The
absence of an explicit stable tag appears to be an oversight rather than
intentional exclusion, given that the fix addresses a clear correctness
issue following established kernel patterns.

 sound/soc/codecs/nau8821.c | 22 ++++++++++++----------
 sound/soc/codecs/nau8821.h |  2 +-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index a8ff2ce70be9a..4fa9a785513e5 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1104,16 +1104,12 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 static void nau8821_jdet_work(struct work_struct *work)
 {
 	struct nau8821 *nau8821 =
-		container_of(work, struct nau8821, jdet_work);
+		container_of(work, struct nau8821, jdet_work.work);
 	struct snd_soc_dapm_context *dapm = nau8821->dapm;
 	struct snd_soc_component *component = snd_soc_dapm_to_component(dapm);
 	struct regmap *regmap = nau8821->regmap;
 	int jack_status_reg, mic_detected, event = 0, event_mask = 0;
 
-	snd_soc_component_force_enable_pin(component, "MICBIAS");
-	snd_soc_dapm_sync(dapm);
-	msleep(20);
-
 	regmap_read(regmap, NAU8821_R58_I2C_DEVICE_ID, &jack_status_reg);
 	mic_detected = !(jack_status_reg & NAU8821_KEYDET);
 	if (mic_detected) {
@@ -1146,6 +1142,7 @@ static void nau8821_jdet_work(struct work_struct *work)
 		snd_soc_component_disable_pin(component, "MICBIAS");
 		snd_soc_dapm_sync(dapm);
 	}
+
 	event_mask |= SND_JACK_HEADSET;
 	snd_soc_jack_report(nau8821->jack, event, event_mask);
 }
@@ -1194,6 +1191,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 {
 	struct nau8821 *nau8821 = (struct nau8821 *)data;
 	struct regmap *regmap = nau8821->regmap;
+	struct snd_soc_component *component;
 	int active_irq, event = 0, event_mask = 0;
 
 	if (regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq)) {
@@ -1205,7 +1203,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1219,12 +1217,15 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 		nau8821_irq_status_clear(regmap, NAU8821_KEY_RELEASE_IRQ);
 	} else if ((active_irq & NAU8821_JACK_INSERT_IRQ_MASK) ==
 		NAU8821_JACK_INSERT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_EN);
 		if (nau8821_is_jack_inserted(regmap)) {
-			/* detect microphone and jack type */
-			schedule_work(&nau8821->jdet_work);
+			/* Detect microphone and jack type */
+			component = snd_soc_dapm_to_component(nau8821->dapm);
+			snd_soc_component_force_enable_pin(component, "MICBIAS");
+			snd_soc_dapm_sync(nau8821->dapm);
+			schedule_delayed_work(&nau8821->jdet_work, msecs_to_jiffies(20));
 			/* Turn off insertion interruption at manual mode */
 			nau8821_setup_inserted_irq(nau8821);
 		} else {
@@ -1661,7 +1662,8 @@ int nau8821_enable_jack_detect(struct snd_soc_component *component,
 
 	nau8821->jack = jack;
 	/* Initiate jack detection work queue */
-	INIT_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+	INIT_DELAYED_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+
 	ret = devm_request_threaded_irq(nau8821->dev, nau8821->irq, NULL,
 		nau8821_interrupt, IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 		"nau8821", nau8821);
diff --git a/sound/soc/codecs/nau8821.h b/sound/soc/codecs/nau8821.h
index f0935ffafcbec..88602923780d8 100644
--- a/sound/soc/codecs/nau8821.h
+++ b/sound/soc/codecs/nau8821.h
@@ -561,7 +561,7 @@ struct nau8821 {
 	struct regmap *regmap;
 	struct snd_soc_dapm_context *dapm;
 	struct snd_soc_jack *jack;
-	struct work_struct jdet_work;
+	struct delayed_work jdet_work;
 	int irq;
 	int clk_id;
 	int micbias_voltage;
-- 
2.51.0

