Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF87D539763;
	Mon, 19 Oct 2026 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418123; cv=none; b=gctkBiqUyk2AgTkrZ2hfVnMSpT6XmoKwXfYfxcved8akziB9CxGIM+ef46dMP2/xwtgwUR3lcSw6g/xiQxm8knaU//2HbvsDeDLYHb8qPS797kXbC22txFlhdfpYNFwi5zwIqSENf6ZzBIlOYNJPFR5kemHVZbgt+gTAn/6THgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418123; c=relaxed/simple;
	bh=p/DhF42raQ7LtZU+gbIb+kAcSbQNnWCPCFScLiNA36s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NicyaA3KZ2XASRXkPU43565TFbmKSUX1WiIQ664DI0d77V7RTaU1/0i5IQQ8tWX2//phheBAobw5KicTNaygSrL2u9z8uyjwNbkV7rFgo+ELq8do+gLSsGz596hv1lYMTY8qtef7hUgEeaBI7wggWk42s2oCmF5xa4tekJX144g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNbksOTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNbksOTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDD11F000CA;
	Mon, 19 Oct 2026 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418119;
	bh=GNAwXZxGzpjCpCLLS6riFOILsXe4BJz2ZdZ68y974jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNbksOTk0H4NLiU+E7mgpnuaBDfwmQvaTj+XeUtKrtBcGe3rRhnNfhdQId81XLwsT
	 ZJAVosnq/VJ6kfvW6Wveprnl1yNzqPDXuxw6Za24Iy7XEsniWQemYc5VBEngrAxPgd
	 FXGkyhbmIVB2fw/nUxnwH6ENOfrozXB1/C2MpofcL8sK04V9qmXhat1rV5yzfn1ybx
	 baFXf35QISVkxBfXHh88peDXwPaeR+ao7cd2NOuy1jo3BZCd6cDfOaPWXqAH1SDMyA
	 yIKLA+6JNwgUs3LLVv2d0qgi5JnoXvmwvLZsuiET8An/ob1lPAPRgNnepZswJ+SMQW
	 Y6a+YuvEh/Kww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Mon, 19 Oct 2026 09:45:16 -0400
Message-ID: <20261019135441.1420968-25-sashal@kernel.org>
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

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `usb_string_copy: Use kzalloc() to avoid
leaking old data`

Local tree: **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`). The commit
under review is `057df423bf474`. The buggy `kmalloc` + in-place `strcpy`
path has been in this lineage since **v5.12** (`98f153a10da403`).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: USB gadget configfs (`usb_string_copy` in
  `drivers/usb/gadget/configfs.c`)
- Action verb: **Use** (kzalloc) / implied **avoid leaking**
- Claimed intent: stop readers from observing memory that is not part of
  either the old or new string when an in-place update lengthens the
  buffer

Record: `[usb/gadget/configfs] [use/avoid] [zero the string buffer and
copy a known length to prevent leaking heap bytes during in-place
updates]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: David Laight <david.laight.linux@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260608095523.2606-37-
  david.laight.linux@gmail.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer applied it)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`, no
  `Acked-by:`, no `Cc: stable` (absence is expected)
- Message-Id `2606-37` = patch 37 of a large series

Record: Author SOB + Greg SOB + lore Link. No reporters. Hardening/USB
lists were the original audience (confirmed in Phase 4).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The body describes a concurrent-read hole in the in-place update path:
if a reader walks the buffer while a longer string is being copied, it
can pass the old NUL and consume bytes that belong to neither string. It
also switches `strcpy` to `memcpy` of the already-computed length.

Record:
- Bug: kernel heap contents can be observed by a concurrent reader of a
  gadget string during an in-place lengthening update
- Symptom: leaked uninitialized `kmalloc` bytes (via configfs show or
  USB string descriptors)
- Version info: none in the message
- Root cause: first allocation used `kmalloc` (unzeroed tail); in-place
  `strcpy` of a longer string temporarily removes the old NUL before the
  new one is written

**Step 1.4: DETECT HIDDEN BUG FIXES**
This is not disguised cleanup. The subject states the leak. It *is* one
patch in a treewide `strcpy` sweep, and `memcpy` is that sweep;
`kzalloc` is the actual leak fix.

Record: `[Not hidden. Real infoleak fix, bundled with strcpy-
elimination.]`

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/usb/gadget/configfs.c` (+2 / −2)
- Function: `usb_string_copy()`
- Scope: single-file, two-line surgical change

Record: `[configfs.c +2/-2] [usb_string_copy] [single-file surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before:
- First call: `kmalloc(USB_MAX_STRING_WITH_NULL_LEN)` then `strcpy`
- Later calls: reuse the same buffer (`str = copy`) and `strcpy` over it
  (the 2021 UAF workaround)

After:
- First call: `kzalloc` so the unused tail is zeros
- Copy: `memcpy(str, s, ret + 1)` (`ret` is `strlen(s)`, so this
  includes the NUL)

Affected path: configfs store of
manufacturer/product/serial/configuration strings (`GS_STRINGS_W`).

Record: `[kmalloc+strcpy -> kzalloc+memcpy of known length; first-alloc
and in-place update paths]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **uninitialized data / kernel infoleak** (with a concurrent-
read window created by in-place update).

Mechanism, verified in this tree:
1. `98f153a10da403` (v5.12) stopped `kfree`+`kstrdup` and copies in
   place so USB host pointers stay valid.
2. First fill still used `kmalloc`, so bytes after the first NUL are
   heap residue.
3. Bind aliases those buffers into USB string tables:
   - `stringtab[...].s = language->manufacturer/product/serialnumber`
     (`configfs_attach_gadget_strings`)
   - `cn->strings.s = cn->configuration` (`configfs_composite_bind`)
4. `usb_gadget_get_string()` does `strlen(s->s)` then converts to
   UTF-16.
5. Configfs show is `sprintf(page, "%s\n", gs->__name ?: "")`.
6. `GS_STRINGS_W` calls `usb_string_copy()` with **no** `gi->lock`. Host
   `GET_DESCRIPTOR` is not serialized against that store.
7. If a reader is in `strlen`/`sprintf` while `strcpy` lengthens the
   string, the old NUL is overwritten first; the walk continues into the
   unzeroed tail.

`kzalloc` makes that tail zeros, so a torn read stops instead of leaking
heap. `memcpy` is equivalent to `strcpy` here (`ret` already came from
`strlen`).

Record: `[uninitialized kmalloc tail leaked across a designed
concurrent-read window] [kzalloc zeros the tail; memcpy is strcpy
replacement]`

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct. `USB_MAX_STRING_LEN` is 126, so max `ret+1` is 127,
matching `USB_MAX_STRING_WITH_NULL_LEN`. `kzalloc` is strictly safer
than `kmalloc`. `memcpy` of `strlen+1` matches `strcpy` for a C string.

Regression risk: very low. Remaining torn-string reads of *previous
string contents* are the pre-existing in-place design, not introduced
here.

Record: `[minimal, correct] [regression risk very low]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Function added: `88af8bbe4ef781` (2012, “the start of the configfs
  interface”) — originally `kstrdup` + `kfree(old)`
- In-place `kmalloc` + `strcpy`: `98f153a10da403` (2021-03-17, in v5.12)
  — **this is the buggy code**
- Empty-string guard: `6d3c721e686ea` (2024, `Cc: stable`)
- This fix: `057df423bf474` (2026-06-08)

Record: `[98f153a10da403, v5.12] [bug present for years in this
lineage]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. The semantic Fixes target is `98f153a10da403`, which
**is** in this tree (`git merge-base --is-ancestor` succeeded). That
commit was itself `Cc: stable` and exists because USB host string reads
race with configfs stores.

Record: `[No Fixes tag] [real introducer 98f153a is in this tree since
v5.12]`

**Step 3.3: CHECK FILE HISTORY**
Recent related commits on this file: OOB empty-string fixes
(`6d3c721e686ea`, `3014168731b79`), later `f63edb54d8f73` (qw_sign,
unrelated). No prerequisite refactor is required for these two lines.
`kmalloc_obj` treewide conversion did **not** change this `kmalloc`
call; the pre-image is still `kmalloc(...)`.

Record: `[standalone vs file history] [no blocking prerequisites in this
tree]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
David Laight is not the USB gadget maintainer. Around this commit he
posted ~100 compile-tested `strcpy` replacements to linux-hardening /
subsystem lists. Greg applied this one. Sibling leak-style changes exist
(e.g. TIPC pad bytes).

Record: `[regular contributor, hardening series] [Greg applied; not a
maintainer-authored USB patch]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Needs the in-place buffer (`98f153a`) to be meaningful; that is in this
tree. Does not need `6d3c721e` (empty-string check) for correctness;
that only appears as nearby context. Applies standalone.

Record: `[standalone on any tree that has the 2021 in-place copy] [can
apply standalone here]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 057df423bf474` matched:
https://patch.msgid.link/20260608095523.2606-37-
david.laight.linux@gmail.com

`b4 dig -a`: only **v1**, dated 2026-06-08, subject `[PATCH next]`.
Saved mbox: patch only, **no replies**. Trailer notes:
- one of a group removing unbounded `strcpy()`
- **“all the changes are only compile tested”**
- ~100 patches sent individually
- “Apologies for the terse commit messages”

WebFetch to lore.kernel.org returned **403**. Discussion content was
recovered via `b4 dig -m`.

Record: `[lore msgid 20260608095523.2606-37] [v1 only, no review
comments in thread] [no reviewer Cc: stable] [compile-tested series]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` original recipients: Kees Cook, linux-hardening, linux-
kernel, linux-usb, Arnd Bergmann, Greg Kroah-Hartman. Greg’s merge SOB
is the only review signal in git. No `Reviewed-by`/`Acked-by` on the
commit.

Record: `[USB + hardening lists and Greg CC’d; Greg applied; no written
review in the thread]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No `Reported-by`, no syzbot, no bugzilla. The race is inferred from code
and from `98f153a`’s real KASAN UAF on the same overlapping access.

Record: `[no external bug report] [concurrent access is documented by
the 2021 UAF fix, not by a new user report]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Patch 37 of a ~100-patch `strcpy` series aimed at linux-next. This
instance is one of the few that also changes allocation to `kzalloc` and
describes a leak. No other series member is required for this function.

Record: `[strcpy series; this patch is self-contained]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable search via WebFetch and curl returned **403**.
Cannot confirm a stable-list nomination or rejection.

Record: `[UNVERIFIED: stable@ discussion]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP is not available. Used grep + file reads.

**Step 5.1: KEY FUNCTIONS**
Record: `[usb_string_copy]`

**Step 5.2: CALLERS**
Direct calls only through `GS_STRINGS_W` in
`include/linux/usb/gadget_configfs.h`, instantiated in `configfs.c` as:
- `gadget_language_{manufacturer,product,serialnumber}_store`
- `gadget_config_name_configuration_store`

Those are configfs attribute stores (privileged gadget setup). Host-side
readers are `usb_gadget_get_string()` → `strlen` on the aliased buffers
after bind.

Record: `[configfs stores write; USB GET_STRING and configfs show read
the same buffers]`

**Step 5.3: CALLEES**
`strlen`, `kzalloc`/`kmalloc`, `memcpy`/`strcpy`. No locks, no I/O.

Record: `[string copy + slab alloc only]`

**Step 5.4: CALL CHAIN / REACHABILITY**
Userspace with configfs gadget access: `write(2)` →
`configfs_write_file` → `GS_STRINGS_W` → `usb_string_copy`.
USB host: `GET_DESCRIPTOR` / string request → `composite_setup` →
`usb_gadget_get_string` → `strlen(s->s)`.

Reachable. Typical writers are root (Android/embedded gadgetd). The
**host** is a different trust domain.

Record: `[reachable from configfs writes and from USB host string reads]
[host path is the security-relevant reader]`

**Step 5.5: SIMILAR PATTERNS**
Same file already has other string-safety fixes (`6d3c721e`,
`3014168731b79`). Author’s series has other “don’t leak leftover bytes”
patches. No second copy of this exact helper.

Record: `[isolated helper; same file has prior stable-bound string
bugs]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. Pre-image at `057df423bf474^` still has `kmalloc` + `strcpy`.
Introduced v5.12, present through this 7.3-rc4 lineage until this
commit.

Record: `[yes, usb_string_copy in drivers/usb/gadget/configfs.c] [since
v5.12 / 98f153a]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Hunk is two lines inside a long-stable helper. Would apply cleanly here
(and would apply to older trees that still have `kmalloc`+`strcpy`;
empty-string check is only nearby context).

Record: `[clean apply]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
`6d3c721e` is a different bug (OOB on zero-length write). No other
kzalloc leak fix for this helper.

Record: `[no substitute fix already present before 057df423]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
USB gadget configfs (`CONFIG_USB_CONFIGFS`). Used to compose gadgets
from userspace (Android gadgets, gadgetfs-style gadgets, UDC testing).
Not core mm/VFS, but a common embedded/Android path.

Record: `[USB gadget configfs] [IMPORTANT for gadget/Android; PERIPHERAL
for desktops without UDC]`

**Step 7.2: SUBSYSTEM ACTIVITY**
File still receives security-relevant string fixes in 2024–2026. Mature
interface, not staging.

Record: `[mature, still getting bounded-string fixes]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Gadget systems that set manufacturer/product/serial/configuration via
configfs and have the gadget bound so a host can read string
descriptors. Config-specific: `CONFIG_USB_CONFIGFS`.

Record: `[driver/config-specific: USB gadget configfs users]`

**Step 8.2: TRIGGER CONDITIONS**
Concurrent in-place store of a **longer** string while
`strlen`/`sprintf` is walking the buffer. Window is a 127-byte copy —
short, but the overlap is intentional (`98f153a` exists because host
reads and configfs writes do overlap in practice). Unprivileged local
users generally cannot write these attributes; a USB host can read the
leaked bytes.

Record: `[short race during string lengthening while gadget is live]
[USB host can observe the leak]`

**Step 8.3: FAILURE MODE SEVERITY**
Kernel heap infoleak (uninitialized `kmalloc` bytes), not a crash. Can
cross to a USB host via string descriptors. That is a security issue,
not a panic.

Record: `[kernel heap infoleak to USB host / configfs reader] [HIGH for
security, not CRITICAL crash]`

**Step 8.4: RISK-BENEFIT RATIO**
- Benefit: closes a real infoleak on a path already known to race; 2
  lines; `kzalloc` is the usual stable-grade fix
- Risk: negligible (`kzalloc`/`memcpy` behavior-preserving for this
  helper)

Record: `[benefit high for gadget infoleak] [risk very low] [favorable]`

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real uninitialized-kmalloc leak, not style-only
- Concurrent reader is why in-place copy exists (`98f153a`, KASAN UAF,
  `Cc: stable`)
- Host `strlen` on aliased pointers is a verified path
- Two-line, obviously correct change
- No new API/feature
- Bug present since v5.12 in this tree’s history
- Applied by Greg KH

AGAINST:
- Tiny race window; no syzbot/CVE/user report
- Series was compile-tested only, labeled `[PATCH next]`
- No mailing-list review comments
- Not a universal core-kernel path
- `memcpy` half is strcpy-hardening, not the leak fix

UNRESOLVED:
- Whether stable@ ever discussed this (lore 403)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — correctness is local and
   obvious; series is compile-tested only, but the change cannot
   reasonably be wrong
2. Fixes a real bug that affects users? **PASS** — heap bytes can be
   read on a live gadget string update
3. Important issue? **PASS** — kernel infoleak (security), not a
   crash/deadlock
4. Small and contained? **PASS** — 2 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — pre-image matches; no missing
   helpers

**Step 9.3: EXCEPTION CATEGORIES**
Not a device-ID/quirk/DT/build/docs exception. It is a small
security/correctness fix.

**Step 9.4: DECISION**
This is a contained infoleak fix on a helper whose in-place update
exists specifically so USB hosts can read strings while configfs writes
them. `kzalloc` is the right, low-risk close of that hole. It meets
stable rules for this tree.

---

## What the commit solves for stable users

After the 2021 UAF fix, gadget strings live in a reused `kmalloc`
buffer. A host (or configfs reader) can walk that buffer while a longer
string is copied in place, skip the old NUL, and return leftover heap
data in a USB string descriptor. Zeroing on first allocation stops that
leak. `memcpy` is a safe `strcpy` substitute given the existing
`strlen`.

Risk vs benefit: two lines, no API change, no lock surgery, benefit is
closing a kernel-memory leak on Android/embedded gadget configs.

---

## Verification
- [Phase 1] Parsed tags: author SOB, Greg SOB, lore Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: `kmalloc`→`kzalloc`, `strcpy`→`memcpy(str,s,ret+1)` in
  `usb_string_copy`
- [Phase 2] Confirmed `USB_MAX_STRING_LEN` 126 and buffer size 127;
  `ret+1` cannot overflow
- [Phase 3] `git blame`: in-place `kmalloc` from `98f153a10da403`
  (v5.12); function from `88af8bbe4ef781` (2012)
- [Phase 3] `git merge-base --is-ancestor 98f153a10da403 HEAD` —
  introducer is in this tree
- [Phase 3] `git merge-base --is-ancestor 057df423bf474 HEAD` — this
  commit is already in HEAD (ignored as “already selected”)
- [Phase 3] `git describe HEAD` / Makefile: local tree is **v7.3-rc4 /
  7.3.0-rc4**
- [Phase 3] Pre-commit file still has `kmalloc`+`strcpy`
- [Phase 4] `b4 dig -c 057df423bf474`: msgid `20260608095523.2606-37`,
  `[PATCH next]`, v1 only
- [Phase 4] `b4 dig -w`: linux-usb, linux-hardening, Kees, Greg, Arnd
- [Phase 4] `b4 dig -m`: no replies; author said compile-tested only;
  ~100 strcpy patches
- [Phase 4] WebFetch lore.kernel.org: 403; used b4 instead
- [Phase 5] Callers: `GS_STRINGS_W` →
  manufacturer/product/serial/configuration stores
- [Phase 5] Host path: `stringtab[].s` and `cn->strings.s` alias the
  same buffers; `usb_gadget_get_string` uses `strlen`
- [Phase 5] `GS_STRINGS_W` does not take `gi->lock`
- [Phase 6] No other leak fix for this helper; `6d3c721e` is a different
  OOB bug
- [Phase 6] Backport difficulty: clean 2-line apply
- [Phase 8] Failure mode: uninitialized heap infoleak, severity HIGH
  (security), not a crash
- UNVERIFIED: stable@ mailing-list discussion (lore 403)
- UNVERIFIED: no runtime reproduction performed here; race is from code
  + the 2021 UAF report, not a new reproducer

**YES**

 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index aa0a25efb6aa0..b6237a2e02003 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -125,11 +125,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0

