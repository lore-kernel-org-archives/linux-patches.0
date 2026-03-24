Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECE63E928D;
	Tue, 24 Mar 2026 11:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351181; cv=none; b=olMw9m93BTOd5+K78A3CXEPmbsEn1k7qUKHKrT/t3bRysFlk3fE4TlhQfJLCOfE8DqG6HS0o6Ev0qT9IDdQgNXsDI2zEraz3KmJupdMwcXfFgFHsLffTzOxn5ImLcQU3wpgaJVCX1EySh4OjvyI1f2sAfZAPLJVVvBUuVjHPMZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351181; c=relaxed/simple;
	bh=i8NJNEqQp4AYOX7lcXa3kLjYDP4X/LphCTA6DBeClxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lcx2xnKXr6gxrvfTqIvoGK+cQ6hjI4zfRBDQ2e+ibNICe4vTP0NJ1EOhIrVIZd9KCpKIDxtVqe5KA6czua7nP5nJvlhSc4l+KmeaUqYosSSAwEcQi4v3WW3yBpBruYmAMeSPjEh/LQxmrlvN0OOWJNDBF8N/Y08GECUSxzW4mfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roQOV8JA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roQOV8JA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3671BC2BCB1;
	Tue, 24 Mar 2026 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351181;
	bh=i8NJNEqQp4AYOX7lcXa3kLjYDP4X/LphCTA6DBeClxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roQOV8JAFqaYIrtzdxbhDHDW1Q6UBL9ge93xnsC4VFwhmWaIdxt+MyQDg0zrlogmK
	 3+D4+E7Ki8SL7kWeoonMqCdWHv+RY3ivOX38Hh2+RWsl9pbGa/gRWRmZBlXneMAjfy
	 vdASlOHBaFN/CX6cZqkJ6ndRizC76SNSIjPfsJ9WVJ8ixZ2Qty9XFlMPRy2QewNGnS
	 1E/G3rfFzUU6Q+Qg6lPEinGxXuYhrNxBj7cYlFvia2CUNR+QQJgMOVofpn0A5C35qc
	 cb1b3FUNzbf/TDxPbOHOSnXsmu1t4gMLJb44uV/pihXmb8U6/kyT1OW2s/zSKDoXqM
	 d5gajAxVF31Yg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure
Date: Tue, 24 Mar 2026 07:19:15 -0400
Message-ID: <20260324111931.3257972-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

[ Upstream commit f7a4c78bfeb320299c1b641500fe7761eadbd101 ]

Presently, if the force feedback initialisation fails when probing the
Logitech G920 Driving Force Racing Wheel for Xbox One, an error number
will be returned and propagated before the userspace infrastructure
(sysfs and /dev/input) has been torn down.  If userspace ignores the
errors and continues to use its references to these dangling entities, a
UAF will promptly follow.

We have 2 options; continue to return the error, but ensure that all of
the infrastructure is torn down accordingly or continue to treat this
condition as a warning by emitting the message but returning success.
It is thought that the original author's intention was to emit the
warning but keep the device functional, less the force feedback feature,
so let's go with that.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The same bug exists in v6.6 - `hidpp_ff_init` failure leads to `ret`
being non-zero and the function returning error after userspace
interfaces are exported. The fix would need minor adaptation for v6.6
(the code structure is slightly different but the same logic applies).

Record: [Bug exists in all stable trees (v5.15+). In v6.6 and older, the
code structure is slightly different (g920_get_config is called
earlier), but the same hidpp_ff_init failure → error return path exists.
Backport may need minor adaptation for older trees.]

### Step 6.2: BACKPORT COMPLICATIONS
For v6.12 and later, the patch should apply cleanly (same code
structure). For v6.6 and v6.1, the code is slightly different but the
same fix (setting `ret = 0` after the warning) applies to the same
logical block.

Record: [Clean apply for 6.12.y; minor context adaptation needed for
6.6.y and older]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem**: HID (Human Interface Devices) - specifically the
  Logitech HID++ driver
- **Criticality**: IMPORTANT - USB input devices are common consumer
  hardware. The G920/G923 are popular gaming wheels.
- **Maintainer**: Benjamin Tissoires (who signed off on this patch)

Record: [HID/logitech-hidpp, IMPORTANT criticality, signed off by
subsystem maintainer]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Users of the Logitech G920 Driving Force Racing Wheel and G923 Xbox
version wheel. These are popular gaming peripherals.

Record: [Driver-specific: users of Logitech G920/G923 gaming wheels]

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger**: Force feedback initialization fails during device probe.
  This can happen due to communication issues with the device, firmware
  quirks, or timing issues.
- **How common**: Not every plug-in, but not rare either (the original
  commit notes this is about a real failure path)
- **Unprivileged trigger**: Yes - plugging in a USB device or having it
  connected at boot

Record: [Triggered when FF init fails during probe; can happen during
normal device use; unprivileged (USB plug-in)]

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **UAF**: Use-after-free when userspace continues to use dangling
  sysfs/input nodes after probe failure
- **Severity**: HIGH - UAF can lead to crashes, undefined behavior, and
  potentially security issues (exploitable from userspace via USB
  device)

Record: [Use-after-free → CRITICAL/HIGH severity. Can cause crashes,
potential security implications]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT**: HIGH - Prevents UAF for users of popular gaming hardware.
  Simple fix that also improves user experience (device works without FF
  instead of failing entirely).
- **RISK**: VERY LOW - 2 lines changed. Setting `ret = 0` is obviously
  correct. No new code paths, no locking changes, no API changes. Worst
  case: device appears to work but has no force feedback (which is the
  intended behavior stated in the commit message).

Record: [Benefit: HIGH (prevents UAF, improves UX). Risk: VERY LOW
(2-line change, obviously correct). Ratio: strongly favorable]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes a use-after-free vulnerability (HIGH severity bug)
- Extremely small and surgical fix (2 lines: braces + `ret = 0;`)
- Obviously correct - matches the original author's intent
- Reviewed by Google engineer, signed off by HID subsystem maintainer
- Bug has existed since v5.5 (~6 years), affecting all active stable
  trees
- Affects real consumer hardware (Logitech G920/G923 gaming wheels)
- UAF is reachable from userspace (USB device plug-in)
- No regression risk - device remains functional, just without FF on
  failure
- Clean separation from other changes - standalone fix

**Evidence AGAINST backporting:**
- No explicit Cc: stable tag (expected for review candidates)
- No Fixes: tag (but the bug origin is clear from blame)
- May need minor context adaptation for older stable trees (6.6.y and
  earlier)

**UNRESOLVED QUESTIONS:**
- None significant

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - reviewed, applied by
   maintainer, included in 7.0-rc5
2. **Fixes a real bug that affects users?** YES - UAF on G920/G923 probe
   failure
3. **Important issue?** YES - use-after-free (crash, potential security
   issue)
4. **Small and contained?** YES - 2 lines in 1 file
5. **No new features or APIs?** CORRECT - no new features
6. **Can apply to stable trees?** YES - cleanly for 6.12.y, with minor
   adaptation for older

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category - this is a straightforward bug fix that meets
the core stable criteria.

### Step 9.4: MAKE YOUR DECISION
This is a clear YES. A 2-line fix for a use-after-free vulnerability in
a popular USB gaming peripheral driver, reviewed by the subsystem
maintainer, with essentially zero regression risk.

## Verification

- [Phase 1] Parsed subject: "HID: logitech-hidpp:" subsystem, "Prevent"
  verb, UAF fix for FF init failure
- [Phase 1] Tags: Reviewed-by Günther Noack (Google), Signed-off-by
  Benjamin Tissoires (HID maintainer). No Fixes:, no Cc: stable
  (expected)
- [Phase 1] Commit body explicitly describes UAF scenario: error return
  after hid_connect() exports userspace interfaces
- [Phase 2] Diff: +3/-1 lines in drivers/hid/hid-logitech-hidpp.c,
  hidpp_probe() function. Adds braces + `ret = 0;`
- [Phase 2] Before: FF init failure → non-zero ret → probe returns error
  → userspace interfaces not torn down → UAF. After: FF init failure →
  ret=0 → probe succeeds → device works without FF
- [Phase 3] git blame: buggy pattern introduced in abdd3d0b344fdf (v5.5,
  2019-10-17), present in all active stable trees
- [Phase 3] git merge-base: confirmed abdd3d0b344fdf is ancestor of
  v5.5; 219ccfb60003a4 (refactored form) is in v6.7+ but not v6.6
- [Phase 3] Verified the same bug pattern exists in v6.6 by reading
  v6.6:drivers/hid/hid-logitech-hidpp.c lines 4538-4546
- [Phase 3] Author Lee Jones is a prolific kernel contributor with
  multiple HID patches
- [Phase 4] Lore: patch submitted 2026-02-27, reviewed without
  objections, applied by maintainer
- [Phase 5] HIDPP_QUIRK_CLASS_G920 applies to G920 (0xC262) and G923
  Xbox (matching 2 USB device entries)
- [Phase 5] hidpp_probe() is the standard USB device probe path, called
  during device enumeration
- [Phase 6] Bug exists in all stable trees (v5.15.y through v6.12.y).
  Code context differs slightly in v6.6 and older
- [Phase 7] HID subsystem, IMPORTANT criticality. Maintainer Benjamin
  Tissoires signed off
- [Phase 8] Severity: HIGH (UAF). Trigger: FF init failure during device
  probe. Risk: VERY LOW (2-line fix)

**YES**

 drivers/hid/hid-logitech-hidpp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index c3d53250a7604..65bfad405ac5b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4487,10 +4487,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		if (!ret)
 			ret = hidpp_ff_init(hidpp, &data);
 
-		if (ret)
+		if (ret) {
 			hid_warn(hidpp->hid_dev,
 		     "Unable to initialize force feedback support, errno %d\n",
 				 ret);
+			ret = 0;
+		}
 	}
 
 	/*
-- 
2.51.0

