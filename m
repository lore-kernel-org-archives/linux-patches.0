Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F982FD7BA;
	Mon, 15 Dec 2025 00:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759315; cv=none; b=C60gjxgPLGVpljA2GpcT13t9nTbw7hkVmaW9Y8MiUsaW4d9+cs5OAQ6BMnfth4lM1qsWfKRlHH3x5j8ykEELdlSNfw+4ijPbDICdmPJkInQFH158BgjM92FnCj3R2F8L8FdhuzmNHUDd1HcIpHM+3QWWcfODcKS6Bz82m/cy9YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759315; c=relaxed/simple;
	bh=ke6qqVjdfFE556uVIaXQme1UHZfTLMZdFnPlanCbopg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQOTO3fcplFiMpc5/IiAsZiXkkt3MeKI8Qd/+CyQKeamSSTqs0SW1U1A8I6Z25JxGXl/+a47vl0J2WMlatfIGpcQB04jq5Epl7fP35eu4945XX/NeCSkDdmdsEpB9eJTenbSUdFFpQzfLjki6nM5bUvhASAlqxQOd8DFH170Z1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CybgRLjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CybgRLjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D991C4CEFB;
	Mon, 15 Dec 2025 00:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759315;
	bh=ke6qqVjdfFE556uVIaXQme1UHZfTLMZdFnPlanCbopg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CybgRLjNPjkBsZJIpqnpQ8y340lF9xdB4Gf1JhwcI+YPcSK58oavmiWyiXqDPOpKB
	 1XEJ85Y0ZeBOAFtp7cygbavQ6MAJrUHvxMZlWOs/8IBSW/xcTDVbMzA/QEl0UZeVcx
	 eHtRFmpJs6j84L9Nh8fQxKFlTmp3asZGl6y31zzKnu9Sc8sZqYKLrBlDG2aDPE07A9
	 oDWqZ1k442m+IbO1boDPhdcSfNRt4IgS1W58wB4dB6Ke8lWrhQbl5ZJNhLSk0O1X0S
	 JjN/RQWFPQfQ+opTyfci7rtoJ/qYZF2fa4Ey4WEUxvSC0/cXLTh8wznMTRSwdcdnUx
	 Mt7pC+ze2Ztqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Askar Safin <safinaskar@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	kai.vehmanen@linux.intel.com,
	cezary.rojewski@intel.com,
	ranjani.sridharan@linux.intel.com,
	rf@opensource.cirrus.com,
	bradynorander@gmail.com
Subject: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer legacy driver as fallback
Date: Sun, 14 Dec 2025 19:41:20 -0500
Message-ID: <20251215004145.2760442-3-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 161a0c617ab172bbcda7ce61803addeb2124dbff ]

When config table entries don't match with the device to be probed,
currently we fall back to SND_INTEL_DSP_DRIVER_ANY, which means to
allow any drivers to bind with it.

This was set so with the assumption (or hope) that all controller
drivers should cover the devices generally, but in practice, this
caused a problem as reported recently.  Namely, when a specific
kconfig for SOF isn't set for the modern Intel chips like Alderlake,
a wrong driver (AVS) got probed and failed.  This is because we have
entries like:

 #if IS_ENABLED(CONFIG_SND_SOC_SOF_ALDERLAKE)
 /* Alder Lake / Raptor Lake */
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = PCI_DEVICE_ID_INTEL_HDA_ADL_S,
 	},
 ....
 #endif

so this entry is effective only when CONFIG_SND_SOC_SOF_ALDERLAKE is
set.  If not set, there is no matching entry, hence it returns
SND_INTEL_DSP_DRIVER_ANY as fallback.  OTOH, if the kconfig is set, it
explicitly falls back to SND_INTEL_DSP_DRIVER_LEGACY when no DMIC or
SoundWire is found -- that was the working scenario.  That being said,
the current setup may be broken for modern Intel chips that are
supposed to work with either SOF or legacy driver when the
corresponding kconfig were missing.

For addressing the problem above, this patch changes the fallback
driver to the legacy driver, i.e. return SND_INTEL_DSP_DRIVER_LEGACY
type as much as possible.  When CONFIG_SND_HDA_INTEL is also disabled,
the fallback is set to SND_INTEL_DSP_DRIVER_ANY type, just to be sure.

Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/
Tested-by: Askar Safin <safinaskar@gmail.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251210131553.184404-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. Commit Message Analysis

**Keywords**: "problem", "wrong driver", "failed", "broken"

**Strong positive indicators**:
- `Reported-by: Askar Safin` - Real user encountered this bug
- `Closes:` link - References actual bug report
- `Tested-by: Askar Safin` - Reporter verified the fix works
- `Reviewed-by: Peter Ujfalusi` - Intel audio engineer review
- `Signed-off-by: Takashi Iwai` - ALSA maintainer

### 2. Code Change Analysis

The change is minimal - only 2-3 lines:

```c
// Before:
if (!cfg)
    return SND_INTEL_DSP_DRIVER_ANY;

// After:
if (!cfg)
    return IS_ENABLED(CONFIG_SND_HDA_INTEL) ?
        SND_INTEL_DSP_DRIVER_LEGACY : SND_INTEL_DSP_DRIVER_ANY;
```

**Technical mechanism of the bug**:
1. Config table entries for Alderlake chips are wrapped in `#if
   IS_ENABLED(CONFIG_SND_SOC_SOF_ALDERLAKE)`
2. When that Kconfig is not set, entries are compiled out
3. `snd_intel_dsp_find_config()` returns NULL (no match)
4. Code returns `SND_INTEL_DSP_DRIVER_ANY` - letting any driver bind
5. AVS driver may bind first and fail, leaving no working audio

**Why the fix works**:
- Returns `SND_INTEL_DSP_DRIVER_LEGACY` when `CONFIG_SND_HDA_INTEL` is
  enabled
- The legacy HDA Intel driver then probes successfully
- This matches the behavior at the end of the function (line 742) when
  config entries exist but don't match conditions

### 3. Classification

This is clearly a **bug fix**:
- Fixes wrong driver selection leading to broken audio
- Does not add new features or APIs
- Uses compile-time conditional - zero runtime overhead

### 4. Scope and Risk Assessment

- **Lines changed**: 2-3 lines
- **Files affected**: 1 file
- **Complexity**: Very low - single compile-time conditional
- **Risk**: Very low
  - Uses `IS_ENABLED()` which is compile-time evaluation
  - Preserves original behavior when `CONFIG_SND_HDA_INTEL` is disabled
  - The legacy driver is the conservative/safe fallback

### 5. User Impact

- **Severity**: High - audio completely broken
- **Who is affected**: Users with modern Intel chips (Alderlake, Raptor
  Lake, etc.) without `CONFIG_SND_SOC_SOF_ALDERLAKE` enabled
- **Real-world**: This is a realistic scenario for distribution kernels

### 6. Stability Indicators

- ✓ `Tested-by:` from reporter
- ✓ `Reviewed-by:` from Intel engineer
- ✓ Author is Takashi Iwai (ALSA maintainer - highly experienced)

### 7. Dependency Check

**Stable tree compatibility verified**:
- File exists at `sound/hda/intel-dsp-config.c` in v6.6 and v6.12 stable
- The exact code being modified (`if (!cfg) return
  SND_INTEL_DSP_DRIVER_ANY;`) exists in all active stable kernels
- File was recently moved to `sound/hda/core/intel-dsp-config.c` in
  mainline - stable backport needs path adjustment
- No dependencies on other commits

### Conclusion

This commit meets all stable kernel criteria:
- ✓ Fixes a real, user-reported bug (broken audio)
- ✓ Obviously correct (uses same logic already present elsewhere in the
  function)
- ✓ Small and contained (2-3 lines in one file)
- ✓ No new features or APIs
- ✓ Well-tested (reporter verified)
- ✓ Properly reviewed (Intel engineer + ALSA maintainer)
- ✓ Applies to stable trees (with path adjustment for file location)

The bug causes complete audio failure on modern Intel systems with
certain kernel configurations. The fix is minimal, low-risk, and uses a
compile-time conditional that preserves old behavior as a fallback.

**YES**

 sound/hda/core/intel-dsp-config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/hda/core/intel-dsp-config.c b/sound/hda/core/intel-dsp-config.c
index 2a9e35cddcf7c..ddb349bc46bbd 100644
--- a/sound/hda/core/intel-dsp-config.c
+++ b/sound/hda/core/intel-dsp-config.c
@@ -710,7 +710,8 @@ int snd_intel_dsp_driver_probe(struct pci_dev *pci)
 	/* find the configuration for the specific device */
 	cfg = snd_intel_dsp_find_config(pci, config_table, ARRAY_SIZE(config_table));
 	if (!cfg)
-		return SND_INTEL_DSP_DRIVER_ANY;
+		return IS_ENABLED(CONFIG_SND_HDA_INTEL) ?
+			SND_INTEL_DSP_DRIVER_LEGACY : SND_INTEL_DSP_DRIVER_ANY;
 
 	if (cfg->flags & FLAG_SOF) {
 		if (cfg->flags & FLAG_SOF_ONLY_IF_SOUNDWIRE &&
-- 
2.51.0

