Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99663F8704;
	Wed, 20 May 2026 11:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276064; cv=none; b=js7iWQdl1CYHE1bGcl37LHmyjatZAsGisF2H8JTShTTv8ki/ye6X4cV9OfA8GDHuaKLyfrYGmDmiQ9w5TQyMbIF2LD2UKfnhoXLBMJ5Ad84II8K7AEx/EHxxNQDyXYVzgpjZt8Ka9mE8Qrva4DEL9RfHQjZMR8ro/jx8rRjxddQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276064; c=relaxed/simple;
	bh=zgftuuOrOu1QIoHJA9BCcsh7S4hA2JEWCcqWkr7fQUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcJh62biHu1fX/Ny3gO0TrAuPNw04a3em1u56AbabJvrSM5cvJjKwhoB88dGPmR71Vd6hQEsUuMeN5wuwEFYh0GzVNUr3Ru5r85LiDUe+L3eW1M/rgCbOhYpo2cSFO0EyMN9O1YUqs8jXK6hNp9sgvqhsY2604o9VQSPoLZhn0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kkekBnqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kkekBnqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647FB1F00898;
	Wed, 20 May 2026 11:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276061;
	bh=hHkJbiFO8k9nGuGfZvBqyiBrUzuMUuZIQlM6+XtdsEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkekBnqfa7ace45tMkRos367okR4+PPI9JYXueirA6y5ec47n6z06NH8MK8fCdjBc
	 GMwD+hYE0gGJKJCX/WX0Xoi9lZHXLgQoWEKJUMlkDAnUnIpk3KI6oRDcmle68zS+0L
	 IoNxxfLR0ks/daIsmF398PyUPiyOhHSCWPYofl7t8nwOeQ5CYmRYuUr0iAilXWgVWR
	 OZ4796NMTUKR0yfOtcgzKxxfhNwrbV4igTCiQK+DPEHk9wPHIc8/zc4VaRE9vG7e/0
	 8n12Id6V6462WQ6NtC5rNOV0xPDw1GPcXfT2V/ofU5IVpt8cWK2pNSj+tv9hZPuXTm
	 HqeugoTfC3slA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Zaidman <michael.zaidman@gmail.com>,
	=?UTF-8?q?Sebasti=C3=A1n=20Josu=C3=A9=20Alba=20Vives?= <sebasjosue84@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-i2c@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] HID: ft260: validate i2c input report length
Date: Wed, 20 May 2026 07:19:26 -0400
Message-ID: <20260520111944.3424570-54-sashal@kernel.org>
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

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit 80c4bbb2b38513e9c3d84805fa61a0ee16d79c45 ]

Add two checks to ft260_raw_event() to prevent out-of-bounds reads
from malicious or malfunctioning devices:

First, reject reports shorter than the 2-byte header (report ID +
length fields). Without this, even accessing xfer->length on a
1-byte report is an OOB read.

Second, validate xfer->length against the actual data capacity of
the received HID report. Each I2C data report ID (0xD0 through
0xDE) defines a different report size in the HID descriptor, so the
available payload varies per report. A corrupted length field could
cause memcpy to read beyond the report buffer.

Reported-by: Sebastián Josué Alba Vives <sebasjosue84@gmail.com>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
This should be backported. It is a small, single-driver HID fix for a
real out-of-bounds read in `ft260_raw_event()`, reachable from FT260 USB
HID input reports before HID core report-size validation runs. The
benefit is high because the failure mode is memory-safety/security
relevant; the regression risk is low because valid reports are unchanged
and only malformed reports are rejected.

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record: subsystem `HID: ft260`; action verb `validate`; intent is to
validate I2C input report length.

Record: tags in commit `80c4bbb2b38513e9c3d84805fa61a0ee16d79c45`:
`Reported-by: Sebastián Josué Alba Vives <sebasjosue84@gmail.com>`,
`Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>`, `Signed-
off-by: Jiri Kosina <jkosina@suse.com>`. No `Fixes:`, `Link:`, `Cc:
stable`, `Tested-by`, `Reviewed-by`, or `Acked-by` in the committed
message.

Record: bug description is explicit: malicious or malfunctioning
FT260-compatible HID devices can send too-short reports or corrupted
length fields, causing OOB reads. Symptom/failure mode is OOB heap read
before/inside `memcpy()`. No affected version listed in commit body.

Record: this is not a hidden fix; it is directly described as a memory-
safety fix.

### Phase 2: Diff Analysis
Record: one file changed, `drivers/hid/hid-ft260.c`, `14` insertions and
`2` deletions. Only `ft260_raw_event()` is modified. Scope is single-
file surgical.

Record: before, `ft260_raw_event()` cast `data` to `struct
ft260_i2c_input_report` and accessed `xfer->report`/`xfer->length`
without checking `size`; then `memcpy()` used `xfer->length` after
checking only destination capacity. After, it rejects reports shorter
than the 2-byte header and rejects `xfer->length > size - offsetof(...,
data)` before copying.

Record: bug category is memory safety: OOB read on truncated input and
OOB source read on corrupted length. No locking, API, or feature
behavior changes.

Record: fix quality is strong: minimal, obvious bounds checks
immediately before the unsafe accesses/copy. Regression risk is low;
only malformed reports are rejected. The use of actual `size` avoids the
earlier reviewed problem of rejecting valid short FT260 report IDs.

### Phase 3: Git History Investigation
Record: `git blame` shows the vulnerable header access and `memcpy()`
came from `6a82582d9fa4` (`HID: ft260: add usb hid to i2c host bridge
driver`, first contained around `v5.13-rc1`). The destination-buffer
check came from `b7121e3c04440` (`HID: ft260: skip unexpected HID input
reports`, first contained around `v6.2-rc1`).

Record: no `Fixes:` tag, so Step 3.2 is not applicable.

Record: recent file history shows related FT260 fixes and enhancements,
including `b7121e3c04440`, but no prerequisite needed for the new
source-length/header validation. For older `5.15.y`/`6.1.y`, the exact
patch context does not apply because `b7121e3c04440` is absent, but the
fix itself is still conceptually standalone.

Record: author Michael Zaidman is listed in `MAINTAINERS` as FT260
maintainer and has a long FT260 commit history. Jiri Kosina committed
the patch and is listed as HID core maintainer.

### Phase 4: Mailing List And External Research
Record: `b4 dig -c 80c4bbb2b3851` found the matching submission at `http
s://patch.msgid.link/20260411062437.279838-1-michael.zaidman@gmail.com`.

Record: `b4 dig -a` showed prior versions/discussion. The original
reporter’s v1/v2 were Cc’d to stable and had a too-broad `size < 64`
approach. Review identified that valid FT260 reports can be shorter,
leading to Michael’s final per-driver fix using the header size and
actual report size.

Record: `b4 dig -w` showed Michael Zaidman, Jiri Kosina, Benjamin
Tissoires, linux-input, linux-kernel, and the reporter on the final
submission.

Record: saved lore mbox shows Jiri applied the final patch to
`hid.git#for-7.1/upstream-fixes`. The thread also contains Michael’s
hardware test note: tested on FT260 with I2C-attached EEPROM behind
PCA9548 muxes, including small and larger reads.

Record: stable-specific history exists in the earlier reporter
submissions, including `Cc: stable@vger.kernel.org` and explicit
OOB/security rationale. No NAK remained against the final version.

### Phase 5: Code Semantic Analysis
Record: modified function is `ft260_raw_event()`.

Record: callers traced manually: `ft260_raw_event()` is registered as
`.raw_event`; HID core calls `hdrv->raw_event()` in
`__hid_input_report()` before `hid_report_raw_event()` performs report-
size checks. USB HID paths call `hid_input_report()` from
interrupt/control completion paths.

Record: callees/side effects: `ft260_raw_event()` copies HID I2C
response payload into `dev->read_buf`, advances `read_idx`, and
completes the waiting I2C read when enough data arrives.

Record: reachability: normal FT260 I2C reads go through `i2c_adapter`
operations (`ft260_i2c_xfer()` / `ft260_smbus_xfer()` ->
`ft260_i2c_read()`), while the malformed input itself is supplied by the
USB HID device. Userspace reachability depends on system I2C access
permissions; unprivileged trigger was not verified.

Record: similar pattern in this function is unique for the FT260 I2C
input report copy. Related HID OOB fixes exist in recent HID history,
supporting the general risk class but not required for this patch.

### Phase 6: Stable Tree Analysis
Record: `drivers/hid/hid-ft260.c` exists in `stable/linux-5.15.y`,
`6.1.y`, `6.6.y`, `6.12.y`, and current `v7.0.9` checkout; it does not
exist in `4.19.y`, `5.4.y`, or `5.10.y`.

Record: the buggy code pattern exists in `5.15.y`, `6.1.y`, `6.6.y`, and
`6.12.y`; none contain `80c4bbb2b3851`.

Record: patch applies cleanly to `6.6.y`, `6.12.y`, and current `v7.0.9`
using a temporary index. It does not apply unchanged to `5.15.y` or
`6.1.y` because those lack `b7121e3c04440` context, so older branches
need a small manual backport.

Record: no alternate stable fix for this exact validation was found.

### Phase 7: Subsystem And Maintainer Context
Record: subsystem is HID driver for an FTDI USB HID-to-I2C bridge.
Criticality is driver-specific but security-relevant for systems using
that hardware or exposed USB ports.

Record: subsystem/file activity is active; recent HID history includes
several OOB fixes, and FT260 has ongoing maintenance by Michael Zaidman.

### Phase 8: Impact And Risk
Record: affected population is driver/config/hardware-specific: systems
with `CONFIG_HID_FT260` and FT260 or malicious FT260-emulating USB HID
devices.

Record: trigger is a malformed HID input report from the device,
especially during/around I2C read handling. Physical or device-level
control is required; unprivileged local trigger was not verified.

Record: failure mode is OOB heap read, with reporter discussion noting
possible data exposure through the I2C read buffer. Severity: HIGH,
security-relevant memory safety.

Record: benefit is high for affected systems; risk is low because the
patch is small, contained, and only rejects malformed reports.

### Phase 9: Final Synthesis
Evidence for backporting: real OOB read; malicious/malfunctioning device
trigger; HID raw_event is called before HID core size validation;
maintainer-authored final fix; hardware test notes; one function and one
file; no new API or feature; applies cleanly to current 7.0 and newer
stable branches.

Evidence against/backport concerns: older `5.15.y` and `6.1.y` need
manual context adjustment; `4.19.y`, `5.4.y`, and `5.10.y` lack the
driver. No `Fixes:` tag, but that is not a negative signal here.

Stable rules checklist: obviously correct and tested: yes, by code
inspection and submission test notes. Fixes a real bug: yes, OOB reads.
Important issue: yes, memory safety/security. Small and contained: yes,
`14+/2-` in one function. No new features/APIs: yes. Can apply to
stable: yes for 6.6/6.12/7.0; minor backport needed for 5.15/6.1.

Exception categories: none; this is a direct memory-safety bug fix, not
a device ID/quirk/build/doc exception.

## Verification
- [Phase 1] `git show --format=fuller --no-patch 80c4bbb2b3851`:
  confirmed subject, message, author/committer, and tags.
- [Phase 2] `git show --function-context 80c4bbb2b3851 --
  drivers/hid/hid-ft260.c`: confirmed only `ft260_raw_event()` changes
  and exact bounds checks.
- [Phase 3] `git blame -L 1065,1085 80c4bbb2b3851^ -- drivers/hid/hid-
  ft260.c`: confirmed vulnerable lines originated in `6a82582d9fa4` and
  related destination check in `b7121e3c04440`.
- [Phase 3] `git show` on `6a82582d9fa4` and `b7121e3c04440`: confirmed
  driver introduction and related unexpected-report fix.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and `-m`: found final lore thread,
  revisions, recipients, maintainer apply message, and test notes.
- [Phase 4] WebFetch/Spinics: confirmed earlier stable-cc’d reporter
  patches and review discussion about avoiding a blanket 64-byte check.
- [Phase 5] Read `drivers/hid/hid-core.c`: confirmed `raw_event` runs
  before `hid_report_raw_event()` size validation.
- [Phase 5] Searched FT260 call paths: confirmed registration as
  `.raw_event`, USB HID input path, and I2C adapter read paths.
- [Phase 6] `git ls-tree` and `git grep` against stable branches:
  confirmed affected code exists in `5.15.y+` branches checked, absent
  from older listed branches.
- [Phase 6] Temporary-index `git apply --check`: clean for `6.6.y`,
  `6.12.y`, and current `v7.0.9`; fails unchanged for `5.15.y`/`6.1.y`,
  requiring minor backport.
- [Phase 7] `MAINTAINERS` search: confirmed Michael Zaidman maintains
  FT260 and Jiri/Benjamin maintain HID core.
- UNVERIFIED: whether an unprivileged local user can trigger this on a
  given distro; that depends on USB access, I2C device permissions, and
  deployment policy.

**YES**

 drivers/hid/hid-ft260.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ft260.c b/drivers/hid/hid-ft260.c
index 333341e80b0ec..70e2eedb465af 100644
--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -1068,10 +1068,22 @@ static int ft260_raw_event(struct hid_device *hdev, struct hid_report *report,
 	struct ft260_device *dev = hid_get_drvdata(hdev);
 	struct ft260_i2c_input_report *xfer = (void *)data;
 
+	if (size < offsetof(struct ft260_i2c_input_report, data)) {
+		hid_err(hdev, "short report %d\n", size);
+		return -1;
+	}
+
 	if (xfer->report >= FT260_I2C_REPORT_MIN &&
 	    xfer->report <= FT260_I2C_REPORT_MAX) {
-		ft260_dbg("i2c resp: rep %#02x len %d\n", xfer->report,
-			  xfer->length);
+		ft260_dbg("i2c resp: rep %#02x len %d size %d\n",
+			  xfer->report, xfer->length, size);
+
+		if (xfer->length > size -
+		    offsetof(struct ft260_i2c_input_report, data)) {
+			hid_err(hdev, "report %#02x: length %d exceeds HID report size\n",
+				xfer->report, xfer->length);
+			return -1;
+		}
 
 		if ((dev->read_buf == NULL) ||
 		    (xfer->length > dev->read_len - dev->read_idx)) {
-- 
2.53.0

