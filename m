Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3283A3E9C;
	Wed, 20 May 2026 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276001; cv=none; b=WbdKDKws8NxnO1KualdcWdiK1LVcbv9nm/iJXiPydH9C3FZfpVgmuJBjsGz+/UhiK2PpWbuZdBY1wMdr358XShJYEWhb/bk2I2QFXIQAZSbDUabcQfeUsMOnkyDydkl2j01kw26Algo9/HFBje+sby4F2Wj2KADGyDU/4f7dEI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276001; c=relaxed/simple;
	bh=NQc4CnQWhGH095J57HFMfL4NRzo/EKU/flET+NJ+iRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmaQcCb/ROWG98qK2UTOGzQP4xPl5+K9GnDukZ29U5zRexXDGLclJW8p0vebxw2w/HIkeX2Qe5upxaiVHtK4OLBkbHNcCu6BRJaPzFiFi9hHJKA7X6e/eTqj0yFDwD1LuAjBJ6ssLUfqURvKZ7kbGhVNyMlf/CLXBB61PEmtIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHkGQqMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHkGQqMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF36E1F00899;
	Wed, 20 May 2026 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275997;
	bh=o8yikqMBR73n80l53MqCB/5Pcdd2h9+MR666hYJgGV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHkGQqMCv9QD5dxLIpvLKPasYO5WwBYuo+sZ5vzfY4IQiw1rWnGxnfvagE9jhych3
	 BlBiCb43y7otiVtbnLABf5GSVn5Sz2omL2MpivLGq9FT6EMfDZM56sdv7x5zDvlSBt
	 aSiN50d0r/WXwcMcu9G1dv8f+vUreLzqZtsOd2qIMAx7svpUSpW3I1cVVFUZgHXuKw
	 48O94rhqCDmXGQ9ZvcPcVpBgVUce8g4hzYwMMx3L+RDKy4zduw1Ysw2MDjTYIGwQfV
	 /ES9FJplGqN0dXAL1zXuP3XbRAfjottTQyPspNvLRW3027obYAkei9T8R+rK6eb/ro
	 oSedEHlkBZt2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID
Date: Wed, 20 May 2026 07:18:41 -0400
Message-ID: <20260520111944.3424570-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

[ Upstream commit d93ba918a185aca2594da63e92fdc5495b559c0f ]

It is currently possible for a malicious or misconfigured USB device to
cause an out-of-bounds (OOB) read when submitting reports using
DOUBLE_REPORT_ID by specifying a large report length and providing a
smaller one.

Let's prevent that by comparing the specified report length with the
actual size of the data read in from userspace.  If the actual data
length ends up being smaller than specified, we'll politely warn the
user and prevent any further processing.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `HID: magicmouse`; action verb `Prevent`;
claimed intent is preventing an out-of-bounds read while parsing
`DOUBLE_REPORT_ID`.

Step 1.2 Record: Tags present: `Signed-off-by: Lee Jones
<lee@kernel.org>`, `Reviewed-by: Günther Noack <gnoack@google.com>`,
`Signed-off-by: Jiri Kosina <jkosina@suse.com>`. No `Fixes:`, `Reported-
by:`, `Tested-by:`, `Link:`, or `Cc: stable@vger.kernel.org` tag was
present in the supplied commit text.

Step 1.3 Record: The body describes a malformed HID report where
`data[1]` advertises a larger embedded report length than the actual
received buffer. Symptom/failure mode: OOB read during recursive
parsing. No affected kernel versions are named. Root cause:
`magicmouse_raw_event()` trusted the embedded length before checking
that the buffer actually contained that many bytes.

Step 1.4 Record: This is not a hidden cleanup; it is an explicit memory-
safety bug fix.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `drivers/hid/hid-magicmouse.c`, 16
insertions, no removals. Modified function: `magicmouse_raw_event()`.
Scope: single-file surgical fix.

Step 2.2 Record: First hunk adds `if (size < 1) return 0;` before
`switch (data[0])`, preventing zero-sized recursive calls from
dereferencing `data[0]`. Second hunk adds `size < 2` before reading
`data[1]`, then validates `size >= data[1] + 2` before splitting the
double report into recursive calls.

Step 2.3 Record: Bug category is memory safety / bounds validation.
Broken mechanism: the `DOUBLE_REPORT_ID` case used `data[1]` to choose
recursive buffer pointers and sizes without proving the first embedded
report existed in the received buffer.

Step 2.4 Record: The fix is obviously correct by inspection: it checks
the exact fields before use and follows existing invalid-report behavior
of returning `0`. Regression risk is very low; only malformed undersized
reports are rejected. Minor concern: the new `hid_warn()` string lacks a
trailing newline, but that is logging style, not functional risk.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows `magicmouse_raw_event()` dates back
to `128537cea464` from 2010, while the `DOUBLE_REPORT_ID` recursive
parsing lines were introduced by `a462230e16acc` (`HID: magicmouse:
enable Magic Trackpad support`). `git describe --contains` places that
introduction at `v2.6.37-rc1~144^2~3^5~2`.

Step 3.2 Record: No `Fixes:` tag is present, so there was no tagged
introducing commit to follow. Blame independently identifies the
relevant old code.

Step 3.3 Record: Recent `drivers/hid/hid-magicmouse.c` history contains
other fixes such as missing input crash prevention and report-fixup leak
fixes, but no prerequisite for this bounds check was identified. This
patch is standalone.

Step 3.4 Record: `git log --author='Lee Jones' -- drivers/hid` shows Lee
Jones has multiple recent HID fixes, including OOB/UAF-related HID work.
The patch was reviewed by Günther Noack and applied by HID maintainer
Jiri Kosina in the mailing-list thread.

Step 3.5 Record: No dependency was found. The patch only uses existing
`hid_warn()` and local variables already present in
`magicmouse_raw_event()`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: No commit hash was supplied and the commit object was
not found in local `git log`, so `b4 dig -c <commit>` was not
applicable. I used `b4 mbox` with the v2 Message-ID instead. Lore URL:
`https://lore.kernel.org/all/20260416131655.2279756-1-lee@kernel.org/`.
Series revisions found: v1 and v2.

Step 4.2 Record: The v2 headers show Lee sent it to Jiri Kosina,
Benjamin Tissoires, `linux-input@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, and Cc’d Günther Noack. Jiri later replied
“Applied”.

Step 4.3 Record: No `Reported-by` or external bug-report link was
present. The thread itself contains the bug explanation.

Step 4.4 Record: v1 added only the `size < data[1] + 2` check. Günther
Noack objected that `size == data[1] + 2` still caused a zero-sized
second recursive call which then dereferenced `data[0]`. v2 added the
top-level `size < 1` and `DOUBLE_REPORT_ID` `size < 2` checks; Günther
replied “This looks correct now” and gave `Reviewed-by`.

Step 4.5 Record: Web search for stable-specific discussion did not find
a stable nomination or a reason not to backport.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `magicmouse_raw_event()`.

Step 5.2 Record: Callers are HID core through the driver `.raw_event`
callback and recursive self-calls in the `DOUBLE_REPORT_ID` case. `hid-
core.c` calls `hdrv->raw_event(hid, report, data, size)` before generic
report processing.

Step 5.3 Record: Key callees in the affected path are recursive
`magicmouse_raw_event()` calls, `magicmouse_emit_touch()`, input event
reporting helpers, and `hid_warn()`. The new checks run before recursive
pointer arithmetic.

Step 5.4 Record: Reachability is verified through `hid_input_report()`,
including `usbhid` interrupt/control paths and `uhid` input paths. A
matched or emulated HID device can feed raw reports to this parser.
Unprivileged triggering was not verified and is not needed for the
decision.

Step 5.5 Record: Search in `drivers/hid` found this `DOUBLE_REPORT_ID`
split pattern only in `hid-magicmouse.c`.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: The vulnerable pattern exists in `v6.6`, `v6.1`,
`v5.15`, `v5.10`, `v5.4`, and `v4.19` by `git grep`. The relevant code
was introduced around `v2.6.37-rc1`.

Step 6.2 Record: Expected backport difficulty is low: the same block and
function exist across checked stable baselines, though line offsets
differ. Exact clean application to every stable branch was not tested.

Step 6.3 Record: Local history searches for `DOUBLE_REPORT_ID` and `out-
of-bounds.*magicmouse` found no prior equivalent fix in this checkout.

## Phase 7: Subsystem Context
Step 7.1 Record: Subsystem is HID input driver support for Apple Magic
Mouse/Trackpad, under `drivers/hid`. Criticality: peripheral/driver-
specific, but memory-safety relevant.

Step 7.2 Record: HID is actively maintained; recent `drivers/hid`
history shows multiple 2026 fixes including OOB, UAF, and NULL-deref
fixes.

## Phase 8: Impact And Risk
Step 8.1 Record: Affected users are systems with `CONFIG_HID_MAGICMOUSE`
and matching Apple Magic Trackpad/Magic Mouse style HID devices or
emulated/spoofed devices reaching this driver.

Step 8.2 Record: Trigger requires a malformed `DOUBLE_REPORT_ID` report
where the embedded length does not fit the actual received size, or
where the second recursive call would be zero-sized. This is not a
normal-path trigger, but it is reachable via raw HID reports.

Step 8.3 Record: Failure mode is OOB read in kernel HID parsing.
Severity: HIGH because it is memory safety in a device-input path and
can be triggered by malformed device input; exact crash or disclosure
behavior was not independently reproduced.

Step 8.4 Record: Benefit is high for affected systems because it blocks
a concrete OOB read. Risk is very low: 16 inserted validation lines,
single function, no ABI/API change, no locking change.

## Phase 9: Final Synthesis
Step 9.1 Record: Evidence for backporting: real OOB read, old code
present in many stable baselines, small surgical validation, reviewed
after v1 caught an incomplete fix, applied by HID maintainer. Evidence
against: no `Tested-by`, no explicit stable nomination, exact clean
apply to every tree not tested. Unresolved: exact upstream commit hash
unavailable locally; exact unprivileged triggerability unverified; exact
USB-vs-Bluetooth trigger wording not independently verified.

Step 9.2 Record: Stable rules: obviously correct: yes, by code
inspection and review; tested: no explicit `Tested-by`. Fixes real bug:
yes, OOB read. Important issue: yes, memory safety. Small and contained:
yes, one function, 16 insertions. No new features/APIs: yes. Can apply
to stable: likely low difficulty; exact apply unverified.

Step 9.3 Record: No exception category applies; this is a normal memory-
safety bug fix, not a device ID, quirk, DT, build, or documentation
patch.

Step 9.4 Record: The technical merit strongly favors backporting. The
fix is narrow, old affected code is present across stable trees, and the
mailing-list review specifically corrected the subtle recursive zero-
size case.

## Verification
- Phase 1: Parsed supplied commit message and tags.
- Phase 2: Compared supplied diff with local `drivers/hid/hid-
  magicmouse.c` context.
- Phase 3: Ran `git blame -L 386,496 -- drivers/hid/hid-magicmouse.c`;
  identified `a462230e16acc` as the `DOUBLE_REPORT_ID` recursive parsing
  introduction.
- Phase 3: Ran `git describe --contains --match 'v[0-9]*'
  a462230e16acc`; found `v2.6.37-rc1~144^2~3^5~2`.
- Phase 4: Used `b4 mbox 20260416131655.2279756-1-lee@kernel.org`; found
  v2 thread, reviewer approval, and Jiri’s “Applied” reply.
- Phase 4: Used `b4 mbox ad-S8Riah-f6mEWm@google.com`; found v1 review
  pointing out the remaining zero-sized recursive-call bug.
- Phase 5: Used `rg` and read `hid-core.c`; verified `.raw_event`
  dispatch and `hid_input_report()` reachability.
- Phase 6: Used `git grep` on `v6.6`, `v6.1`, `v5.15`, `v5.10`, `v5.4`,
  and `v4.19`; confirmed vulnerable code exists.
- Phase 7: Checked `drivers/hid/Kconfig`; confirmed
  `CONFIG_HID_MAGICMOUSE`.
- Phase 8: Severity assessment is based on verified OOB read mechanics;
  exact crash/leak manifestation is unverified.
- UNVERIFIED: Exact commit hash in local repository; exact clean apply
  to every stable branch; unprivileged triggerability.

**YES**

 drivers/hid/hid-magicmouse.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 9eadf3252d0dc..f53839484c861 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -390,6 +390,10 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 	struct input_dev *input = msc->input;
 	int x = 0, y = 0, ii, clicks = 0, npoints;
 
+	/* Protect against zero sized recursive calls from DOUBLE_REPORT_ID */
+	if (size < 1)
+		return 0;
+
 	switch (data[0]) {
 	case TRACKPAD_REPORT_ID:
 	case TRACKPAD2_BT_REPORT_ID:
@@ -490,6 +494,18 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		/* Sometimes the trackpad sends two touch reports in one
 		 * packet.
 		 */
+
+		/* Ensure that we have at least 2 elements (report type and size) */
+		if (size < 2)
+			return 0;
+
+		if (size < data[1] + 2) {
+			hid_warn(hdev,
+				 "received report length (%d) was smaller than specified (%d)",
+				 size, data[1] + 2);
+			return 0;
+		}
+
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-- 
2.53.0

