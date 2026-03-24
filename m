Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72F3F54D3;
	Tue, 24 Mar 2026 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351199; cv=none; b=fCW0c9rDXxRXTn03qxceEUgmEQ1esi2RtPdAv8mx04kaYbf8nDoW9d5KSIuZT6qXKM2+AsHGmAWtBQTOcozLqF/3+lWeRUcvKLunSfPY92cak4TyVmer3RXjbaEVxeiYoqDAAKg0MuKM+Sd/fvJNG5AhlAtpya4E2PnwE1wNvMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351199; c=relaxed/simple;
	bh=MLTjk6bv09SrxmiE4s7AyFcFYXA97AgixW/HTyZL0kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pljzNAkZSiXwRE18RUNzAT3GKkaG+YavzCpyInia7s7zGuQ3L2EF+hb+sSkCRaAojttycOVWdDWzove+j9ntAsVnyVgtplmfHPa4g27LKwVqwjdC7U+oJSyo9qkgx3zdUWl0PstX2UycRyUyGyeNNYoIpHNM4KSCFUHB5NbM4fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LceuVVqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LceuVVqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4C8C19424;
	Tue, 24 Mar 2026 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351199;
	bh=MLTjk6bv09SrxmiE4s7AyFcFYXA97AgixW/HTyZL0kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LceuVVqIoh6YFDl9QE8b+9/6rQUe3ygiT8rmD2qq8rYaCgHFvTMKPSjpd/p41bIIo
	 LWmjHVqPhfahJC26YTVyvNaoZZ/dMQxZQdoFRTSao/ljl7PLJi2ixztrUrng6api/s
	 F4BOTQgm6XxguUqUgGWYlt66zLwc7D28b552iW2kNkuQkHvnYR+OMxpYjVWDtvCaVD
	 mNzzI5bWcRMVFAt3AX7zFEuDQuNTsaFKmlQym1PbMIvFmj9mDQKmK9j/Se62PLwySA
	 QPA+O79Z3j/1hfX6lFvsL9iCXoWIyFXpl7Qq/rdGMguqdFQPUn3Cm7DrIL2PXJOZtE
	 jkE1E8gcdCU5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] HID: multitouch: Check to ensure report responses match the request
Date: Tue, 24 Mar 2026 07:19:28 -0400
Message-ID: <20260324111931.3257972-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

[ Upstream commit e716edafedad4952fe3a4a273d2e039a84e8681a ]

It is possible for a malicious (or clumsy) device to respond to a
specific report's feature request using a completely different report
ID.  This can cause confusion in the HID core resulting in nasty
side-effects such as OOB writes.

Add a check to ensure that the report ID in the response, matches the
one that was requested.  If it doesn't, omit reporting the raw event and
return early.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

As Tissoires noted, `hid-vivaldi-common.c` has the same vulnerable
pattern. `wacom_sys.c` also has it. This confirms the bug is systemic.

Record: Same vulnerable pattern exists in hid-vivaldi-common.c and
wacom_sys.c. This is a known systemic issue.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?

The buggy code was introduced in commit `6d4f5440a3a2bb` from
2015-10-07, which is approximately kernel v4.4. This means the
vulnerable code exists in **ALL active stable trees** (5.4.y, 5.10.y,
5.15.y, 6.1.y, 6.6.y, 6.12.y, etc.).

Record: Buggy code exists in all active stable trees. Very wide
exposure.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS

The fix is 7 lines added to a single function. The function has been
stable since 2015 with only minor modifications (2018 `ret` variable and
`hid_report_len` changes). The patch should apply cleanly to all stable
trees or with trivial context adjustments.

Record: Expected backport difficulty: clean apply or trivial conflicts.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No related fixes for this specific issue found in any stable tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem**: HID (Human Interface Devices) — drivers/hid/
- **Criticality**: IMPORTANT — HID affects all USB input devices (mice,
  keyboards, touchscreens, touchpads). Multitouch is used by virtually
  all modern laptops and tablets.
- **Security aspect**: USB devices are a common physical attack vector.
  A malicious USB device can be plugged into any machine.

Record: [HID/multitouch] [IMPORTANT - affects all multitouch devices,
USB attack vector]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Active subsystem with regular commits. The HID maintainer (Benjamin
Tissoires) actively reviews and merges patches.

Record: Active subsystem, responsive maintainer.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Any system using HID multitouch devices (virtually all laptops, tablets,
kiosks, and touchscreen-equipped systems). The vulnerability is
triggerable via a malicious USB device.

Record: Affected user population: universal (any system with USB ports
and HID multitouch support).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger**: A USB device sends a HID feature report response with a
  report ID different from the one requested
- **Attack scenario**: Malicious USB device (BadUSB-style attack) — plug
  in a crafted USB device
- **Also possible**: Buggy/clumsy device firmware (accidental trigger)
- **Privilege**: Physical access to USB port required (no unprivileged
  userspace trigger)
- **Reproducibility**: Deterministic — controlled by the device firmware

Record: Physical access via USB required. Deterministic trigger from
device side. No unprivileged software trigger.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Failure mode**: Out-of-bounds memory write in kernel space
- **Consequences**: Memory corruption, potential kernel crash, potential
  privilege escalation
- **Severity**: **CRITICAL** — OOB write is one of the most serious
  vulnerability classes

Record: [OOB write / memory corruption] [Severity: CRITICAL]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT**: Very high — prevents OOB kernel memory corruption from
  malicious USB devices
- **RISK**: Very low — 7 lines, simple ID comparison check, only affects
  feature report processing in multitouch driver
- **Ratio**: Excellent — high benefit, minimal risk

Record: [Benefit: VERY HIGH] [Risk: VERY LOW] [Ratio: strongly favors
backporting]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes OOB write (CRITICAL severity security vulnerability)
- Exploitable via malicious USB device (physical attack vector)
- Fix is 7 lines, obviously correct (simple ID comparison)
- Accepted by HID maintainer Benjamin Tissoires
- Buggy code exists in ALL stable trees (since 2015, kernel v4.4)
- No dependencies on other patches (standalone fix)
- Clean backport expected
- Verified the OOB mechanism in `hid_report_raw_event()` — the `memset`
  at line 2062 can write beyond buffer bounds

**AGAINST backporting:**
- Part of a 2-patch series, but patch 1/2 is independent (different
  file, different issue)
- No explicit Cc: stable from author or reviewer (expected, that's why
  we're reviewing)
- Requires physical USB access (not remotely exploitable)

**UNRESOLVED:**
- None significant — the bug mechanism is clearly verified

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — simple comparison of
   report->id vs buf[0], reviewed and accepted by HID maintainer
2. **Fixes a real bug that affects users?** YES — OOB write from
   malicious/buggy USB devices
3. **Important issue?** YES — memory corruption / security vulnerability
   (CRITICAL)
4. **Small and contained?** YES — 7 lines in one function in one file
5. **No new features or APIs?** YES — purely validation logic
6. **Can apply to stable trees?** YES — code has been stable since 2015

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category — this is a standard security bug fix, which
is the primary use case for stable.

### Step 9.4: MAKE YOUR DECISION
This is a clear YES. It's a small, obviously correct security fix that
prevents OOB writes from malicious USB devices. The fix has been
reviewed and accepted by the HID maintainer. It affects all stable trees
and has minimal regression risk.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Lee Jones (author), Signed-off-by
  Benjamin Tissoires (HID maintainer). No Fixes/Reported-by/Cc:stable
  tags.
- [Phase 2] Diff analysis: 7 lines added to `mt_get_feature()` in hid-
  multitouch.c, adds report ID validation check before calling
  `hid_report_raw_event()`
- [Phase 3] git blame: Buggy code introduced in commit `6d4f5440a3a2bb`
  (2015-10-07, ~v4.4), present in ALL active stable trees
- [Phase 3] git log: No previous related fixes for this issue found
- [Phase 4] lore.kernel.org: Found patch submission at
  `20260227163031.1166560-2-lee@kernel.org`. Patch 2/2 of series; patch
  1/2 is independent (different file). Benjamin Tissoires reviewed and
  accepted. He noted same bug exists in hid-vivaldi-common.c.
- [Phase 4] RFC v3: Tissoires NACK'd core-level fix, preferred per-
  driver fixes like this one — confirming this is the maintainer's
  preferred approach.
- [Phase 5] Callers: `mt_get_feature()` called from
  `mt_feature_mapping()` at 3 sites during device enumeration — standard
  path for multitouch devices
- [Phase 5] Verified OOB mechanism: `hid_report_raw_event()` at hid-
  core.c:2040 uses `data[0]` (buf[0]) to look up report; at line 2062,
  `memset(cdata + csize, 0, rsize - csize)` writes beyond buffer if
  looked-up report is larger than the buffer allocated for the requested
  report
- [Phase 5] Same vulnerable pattern confirmed in hid-vivaldi-common.c:87
  and wacom_sys.c:397
- [Phase 6] Code exists in all active stable trees (v4.4+), fix should
  apply cleanly
- [Phase 7] HID subsystem: IMPORTANT criticality, affects all multitouch
  USB devices
- [Phase 8] Failure mode: OOB kernel memory write, severity CRITICAL.
  Trigger: malicious USB device (physical access required).

**YES**

 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b8a748bbf0fd8..e82a3c4e5b44e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -526,12 +526,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
 		dev_warn(&hdev->dev, "failed to fetch feature %d\n",
 			 report->id);
 	} else {
+		/* The report ID in the request and the response should match */
+		if (report->id != buf[0]) {
+			hid_err(hdev, "Returned feature report did not match the request\n");
+			goto free;
+		}
+
 		ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
 					   size, 0);
 		if (ret)
 			dev_warn(&hdev->dev, "failed to report feature\n");
 	}
 
+free:
 	kfree(buf);
 }
 
-- 
2.51.0

