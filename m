Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD285548361;
	Mon, 19 Oct 2026 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418192; cv=none; b=Ov4ZJ1po31c7b3E6cv+qZruTFT4hkn+8WnQLzrF/fMRKNILMQgFXr5hBvWFVazf3ZYd5CiPq5VOSdNKBEasTwjylV9Cby9YUNPJ8VM9xTetD3eAFg1DI1sSIDymTTCgweV0BaEzNslTcTcGgBx3Qd9akf/G/Ibem8f8NaDwXfFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418192; c=relaxed/simple;
	bh=YIgvDSLFUYaxwCXW75fGzmzMToDiAVGmeTXCss3DLEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/Dty8cP20U6/v36meMuYuRujjxywgXby+5jqMeiihph7LR33wXknxaVsYJ/H+luINyn8jHwNBupCGcU2F8JxCd+526HXlXf0KVvrsKhX7T12Bv3RseV417I17aBL8yM0S9OmNDFtfi55d4PEPLS3IqkrzwQ4fn7Np68CaZn0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViOgBH/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViOgBH/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7881F000C4;
	Mon, 19 Oct 2026 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418190;
	bh=GBDQnJH235L1jol/o3nhffq/7PZ9JTvYNaSZcRr7Cpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViOgBH/JD9oEtouHZ7LboM7mCl/oTm9IC9Bz20zzr+YZAvXiQy2Wpz9Eh8Q1yqb82
	 pvNGKETY/gyKpRv6Q23pq7Oi15CIrIIL47nxsWkwz3IVG2zdYAqdmOpL+uVZkBqkq2
	 LEdHsV6xG/bTRcOGh84/306v8FY6dgksqvOhKPWdVePcl1fzJtBMvKMNSmm9Mnles7
	 cpQqziWPSeZ3NNVvcluRm6vovOXzGHY7+YZ5k2mwwIXEXLZ/0GmEEHo1lvqKvHthZQ
	 ZEfwlDDhahzMs8ZEp/ekkyBGuIu81+KxF9hzBIPCPwpM2ogYI97SQwVoUVOxhOcUVo
	 nrYnWxqYqt93Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Israel=20T=C3=A9llez=20Garc=C3=ADa?= <i.tellez@btesa.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] libbpf: Fix ring buffer consumer loop on 32-bit position wrap
Date: Mon, 19 Oct 2026 09:46:07 -0400
Message-ID: <20261019135441.1420968-76-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Israel Téllez García <i.tellez@btesa.com>

[ Upstream commit fdd4fad0bbbd08501465c5f9b556963093c5d58a ]

ringbuf_process_ring() walks the records between the consumer and the
producer with an ordering comparison:

	while (cons_pos < prod_pos) {

cons_pos and prod_pos mirror the kernel's ring positions and are
unsigned long here too, so on 32-bit they wrap at 2^32 bytes of traffic.
When producer_pos has wrapped and consumer_pos has not, prod_pos is the
smaller of the two, the loop body never runs and no record is consumed.
Since consumer_pos only advances inside that loop, it never wraps either
and the consumer stops delivering samples for good, with no error
returned to the caller: ring_buffer__poll() keeps reporting zero
records while the kernel side fills up and starts dropping.

Compare the distance instead. The consumer never runs ahead of the
producer, so prod_pos - cons_pos is the amount of unconsumed data and
stays correct across the wrap.

64-bit hosts are unaffected in practice: the counters would need 16 EiB
to wrap. This is the userspace counterpart of the kernel-side walk fixed
in "bpf: Fix pending_pos walk on 32-bit ring position wrap"; a 32-bit
consumer hits whichever of the two comes first.

Signed-off-by: Israel Téllez García <i.tellez@btesa.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260814124843.22041-5-i.tellez@btesa.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[libbpf] [Fix] ring buffer consumer loop on 32-bit position
wrap**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Israel Téllez García `<i.tellez@btesa.com>`
  (author)
- **Signed-off-by:** Andrii Nakryiko `<andrii@kernel.org>` (libbpf/BPF
  maintainer)
- **Link:** `https://lore.kernel.org/bpf/20260814124843.22041-5-
  i.tellez@btesa.com`
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`, or `Cc:
  stable` on the original patch
- Original submission had **no `Fixes:` tag**. `b4 am` later attached a
  lore trailer: `Fixes: bf99c936f947 ("libbpf: Add BPF ring buffer
  support")` (DKIM/kernel.org). That SHA is the 2020 introduction of BPF
  ringbuf in libbpf, and it is in this tree.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ringbuf_process_ring()` uses `while (cons_pos < prod_pos)`
  on `unsigned long` positions. On 32-bit those wrap at 2^32 bytes.
  After producer wrap, `prod_pos` is small and `cons_pos` is still
  large, so the loop never runs.
- **Symptom:** `ring_buffer__poll()` / consume APIs keep returning 0
  with no error; the kernel ring fills and drops samples permanently.
- **Root cause:** ordering comparison is not wrap-safe; consumer_pos
  only advances inside that loop, so it never wraps either.
- **Version info:** 64-bit is unaffected in practice (16 EiB to wrap).
  Explicitly the userspace counterpart of the kernel `pending_pos` walk.
  Field data for that sibling: four armv7 i.MX7 Dual devices on 6.6.52
  stalled after exactly 4295491360 bytes (~2^32 + one 512 KiB ring).
- **Author’s fix:** `prod_pos - cons_pos > 0` (unsigned distance).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body describe a real wrap-induced stall.
Not cleanup/refactor.

---

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `tools/lib/bpf/ringbuf.c` — **1 line changed** (`+1 / -1`)
- Function: `ringbuf_process_ring()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `while (cons_pos < prod_pos)` — fails after producer wrap
  on 32-bit.
- **After:** `while (prod_pos - cons_pos > 0)` — unsigned modular
  distance; stays true while unconsumed data exists.
- Path: normal consume path (`ring_buffer__poll` / `__consume` /
  `__consume_n` / `ring__consume*`), not an error/init-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** logic/correctness (32-bit wrap / unsigned comparison)
- **Mechanism:** same class as kernel `pending_pos`. Unsigned `unsigned
  long` counters are documented to wrap
  (`Documentation/bpf/ringbuf.rst`). Distance arithmetic is already used
  in this tree in `ring__avail_data_size()` (`return prod_pos -
  cons_pos`) and kernel `ringbuf_avail_data_sz()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: matches the kernel-side pattern already in this
  tree (`while (prod_pos - pend_pos > 0)` in `kernel/bpf/ringbuf.c`).
- Minimal: one condition.
- Regression risk: low. On 64-bit equivalent until astronomical wrap. If
  consumer ever ran ahead of producer, the new check would wrap and keep
  looping; the author and kernel invariant say that does not happen.
  Same assumption the kernel pending_pos fix already shipped here.

---

## Phase 3: Git history investigation

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy `while (cons_pos < prod_pos)` introduced in
**`bf99c936f9478`** (“libbpf: Add BPF ring buffer support”, 2020-06-01)
by Andrii Nakryiko. Present since BPF ringbuf existed. Surrounding `cnt
>= n` bits are later (`13e8125a22763`, 2024) and unrelated.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: Original mail had no `Fixes:`. Trailer names `bf99c936f947`,
which **is in this tree**. Kernel sibling `19de99ea47e3c` (“bpf: Fix
pending_pos walk on 32-bit ring position wrap”) **is already in this
tree**; its `Fixes:` target `cfa1a2329a691` is also here.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `tools/lib/bpf/ringbuf.c` commits are consume_n
overflow/return-value fixes, not wrap handling. This is standalone:
series patch 4/4. Cover letter: patches 1–3 are kernel; 4 is libbpf.
Patches 2–3 are overwrite-mode `ringbuf_avail_data_sz()` —
**overwrite_pos does not exist in this 6.12 tree**. Nakryiko dropped
patch 3 anyway.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Israel Téllez García authored the kernel wrap fix already on
this branch (`19de99ea47e3c`). Andrii Nakryiko (libbpf maintainer)
applied both.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No code dependency. One-line condition change in a function that
already exists. `git apply --check` on the original mbox succeeded (exit
0). Does not need overwrite-mode patches.

---

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Series: **[PATCH v2 bpf 0/4] bpf: Fix ring buffer position wrap
  handling on 32-bit**
- Lore: `https://lore.kernel.org/bpf/20260814124843.22041-1-
  i.tellez@btesa.com`
- This patch: `...22041-5-i.tellez@btesa.com` (4/4)
- v1: `https://lore.kernel.org/bpf/20260806130214.66028-1-
  i.tellez@btesa.com/` (kernel pending_pos only; v2 added sites 2–4)
- v2 change for patch 1: drop `(long)` cast per Nakryiko; unsigned
  difference is enough
- Cover: patch 1 was the field-observed stall; patch 4 is the userspace
  counterpart. “A 32-bit consumer hits whichever of the two comes
  first.”
- No NAK on patch 4. Patch 3 was dropped by both author and Nakryiko
  (ordering of overwrite_pos loads).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Andrii Nakryiko, Alexei
Starovoitov, Daniel Borkmann, Eduard Zingerman, Martin KaFai Lau, Song
Liu, Jiri Olsa, `bpf@vger.kernel.org`. Applied by Nakryiko.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla for the libbpf loop itself. Field evidence is
on the kernel sibling: four armv7 devices, exact 2^32-byte trigger, 8–17
h uptime, one patched device then passed 10 GiB. Cover: “Userspace kept
consuming normally until the producer stopped” — meaning the kernel
stall fired first. Once that kernel fix is in (it is, here), this libbpf
loop is the next wrap failure.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record:
1. Kernel pending_pos — **already in this tree**
2. Overwrite-mode avail-data — **N/A here** (no overwrite_mode)
3. producer_pos vs overwrite_pos load order — dropped; **N/A here**
4. **This libbpf loop** — candidate
- User-ringbuf peek (`u64` locals, `cons_pos >= prod_pos`) was called
  out as a separate issue and is **not** this commit. Confirmed still
  present at `kernel/bpf/ringbuf.c:687`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable returned Anubis bot-
challenge (403/HTML). No stable-list discussion retrieved.

---

## Phase 5: Code semantic analysis

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `ringbuf_process_ring()` only. (semcode MCP not available; used
hunk headers + grep.)

**Step 5.2: TRACE CALLERS**
Record: All in-tree callers of `ringbuf_process_ring()`:
- `ring_buffer__consume_n()`
- `ring_buffer__consume()`
- `ring_buffer__poll()`
- `ring__consume_n()` / `ring__consume()`

These are the public libbpf ringbuf consume APIs. Reachable from any
userspace consumer of `BPF_MAP_TYPE_RINGBUF` (tracing, networking,
etc.). `bpftool` in this tree links `tools/lib/bpf`.

**Step 5.3: TRACE CALLEES**
Record: `smp_load_acquire` on positions/len, `roundup_len()`,
`r->sample_cb()`, `smp_store_release` of consumer_pos. No
allocation/locking in the changed condition.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace path: app/bpftool → `ring_buffer__poll/consume` →
`ringbuf_process_ring`. Trigger: ~4 GiB cumulative ring traffic on
32-bit. Unprivileged if the process already has the map fd (typical
tracing daemon). Not a kernel oops, but permanent event loss.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record:
- Same buggy compare in
  `tools/testing/selftests/bpf/benchs/bench_ringbufs.c:305` (benchmark
  only; not this commit).
- Wrap-safe distance already in `ring__avail_data_size()` and kernel
  `ringbuf_avail_data_sz()`.
- Kernel pending_pos already converted to distance in this tree.

---

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Local tree is **6.12.111** (`git describe`:
`p-6.12-3-gc504cf0baa3d8`, Makefile `VERSION=6 PATCHLEVEL=12
SUBLEVEL=111`).

```247:247:tools/lib/bpf/ringbuf.c
                while (cons_pos < prod_pos) {
```

`struct ring` uses `unsigned long *consumer_pos` / `*producer_pos`
(lines 29–30). Bug introduced in v5.8-era libbpf ringbuf
(`bf99c936f9478`), long before 6.12. Positions are still `unsigned long`
in kernel `struct bpf_ringbuf`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git apply --check` on the original patch mbox
exited 0. Function shape matches the hunk (`ringbuf_process_ring(struct
ring *r, size_t n)` with `cons_pos`/`prod_pos` as `unsigned long`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Kernel pending_pos wrap fix **is** here (`19de99ea47e3c`).
Userspace loop still has `cons_pos < prod_pos`. No alternate libbpf wrap
fix in this file.

---

## Phase 7: Subsystem and maintainer context

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **libbpf** (`tools/lib/bpf/`) — userspace helper shipped with
the kernel, used by bpftool and in-tree BPF tools. Criticality:
**IMPORTANT** for BPF users, especially 32-bit embedded collectors. Not
core mm/sched, but this tree already backports libbpf ringbuf fixes
(`087d757fb4736`, `00f0e08f23fc0`).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; libbpf ringbuf APIs grew through 6.12
(`ring__consume_n`, etc.). The wrap bug is old (2020), not a new-feature
leftover.

---

## Phase 8: Impact and risk assessment

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Config/platform-specific:** 32-bit hosts using in-tree libbpf
to consume `BPF_MAP_TYPE_RINGBUF` (armv7/i.MX and similar LTS/embedded).
64-bit unaffected in practice.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: After ~4 GiB of ring traffic, if producer wraps while consumer
still has unconsumed bytes. Common with epoll/batching. Timing-dependent
at the wrap, then **sticky forever**. Unprivileged if the process
already holds the map. The sibling bug was reproduced at 441–862
records/s over hours — not a theoretical corner.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Permanent silent stop of sample delivery; kernel then drops
events; APIs return 0 with no error. **HIGH** data/event loss (not a
kernel oops). Restart of the consumer is required.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: high for 32-bit BPF consumers.** Kernel producer wrap is
  already fixed here, so this is now the remaining stall. Same class as
  a field-proven 6.6.52 armv7 outage.
- **Risk: very low.** One comparison, same idiom as kernel code already
  on this branch.
- Ratio: strongly favors backport.

---

## Phase 9: Final synthesis

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real wrap bug; documented that 32-bit positions wrap
- Permanent silent event loss, no error
- One-line, obviously correct, applies cleanly
- Kernel counterpart already in this 6.12.y tree — without this,
  producer keeps going and userspace is the next stall
- Field-proven sibling on armv7 (core LTS/embedded)
- Maintainer SOB (Nakryiko); v2 reviewed
- No new APIs; no overwrite-mode dependency

**AGAINST:**
- Userspace libbpf (some distros use github libbpf, not in-tree)
- 32-bit only in practice
- Original field report hit kernel pending_pos first
- No `Cc: stable` on the original mail (expected for this review queue;
  not a negative)

**UNRESOLVED:**
- Could not query lore.kernel.org/stable (bot wall)
- Could not confirm whether standalone libbpf already carries this
  (irrelevant: verdict is for in-tree `tools/lib/bpf`)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — same unsigned-distance idiom
   as kernel code already here; series tested on armv7 for the sibling;
   maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — 32-bit ringbuf
   consumers stall after wrap.
3. Important issue (crash, security, corruption, deadlock)? **PASS** at
   HIGH — permanent silent event loss, not an oops, but equivalent
   operational failure for tracing/telemetry.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded; buggy loop present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary small bugfix.

**Step 9.4: DECISION**

This belongs on **this** 6.12.y tree. The buggy `cons_pos < prod_pos`
loop is here; the matching kernel wrap fix is already here; the one-line
change applies cleanly and closes the remaining 32-bit stall for in-tree
libbpf consumers.

### What the commit solves and why it matters here

On 32-bit, ring positions are 32-bit `unsigned long` and are documented
to wrap. After producer wrap, the consumer loop never runs, never
advances `consumer_pos`, and never recovers. `ring_buffer__poll()`
reports 0 forever while the kernel drops samples. 6.12.y already
contains the kernel `pending_pos` wrap fix, so a 32-bit producer can now
wrap; this userspace loop is the next failure. 32-bit ARM collectors are
a real LTS audience (the sibling was seen on i.MX7 Dual).

### Risk vs benefit

Benefit is high for 32-bit BPF ringbuf users; risk is a one-line
comparison already used in-kernel on this branch.

---

### Verification
- **[Phase 1]** Parsed subject/tags/body from the candidate and from
  `/tmp/ringbuf-mbox/wrap-p5`; `Fixes:` only as a later lore trailer to
  `bf99c936f947`
- **[Phase 2]** Diff is one condition in `ringbuf_process_ring()`;
  current tree still has `while (cons_pos < prod_pos)` at line 247
- **[Phase 3]** `git blame` → `bf99c936f9478` (2020); `git merge-base
  --is-ancestor` confirms that SHA, `cfa1a2329a691`, and kernel wrap fix
  `19de99ea47e3c` are in HEAD
- **[Phase 3]** `git log --oneline -- tools/lib/bpf/ringbuf.c` — no
  userspace wrap fix present
- **[Phase 4]** `b4 dig -c 19de99ea47e3c -a/-w` → v2 4-patch series;
  this is 4/4
- **[Phase 4]** Cover letter and patches from `/tmp/ringbuf-
  series/*.cover` and `.mbx`; Nakryiko dropped patch 3 (`/tmp/ringbuf-
  mbox/nakryiko`)
- **[Phase 4]** lore.kernel.org HTTP 403 / Anubis; used `b4` mboxes
  instead
- **[Phase 5]** grep callers of `ringbuf_process_ring` in
  `tools/lib/bpf/ringbuf.c`; public consume/poll APIs
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → `6.12.111`
- **[Phase 6]** `git apply --check /tmp/ringbuf-mbox/wrap-p5` exit 0
- **[Phase 6]** `overwrite_pos` / `overwrite_mode` absent from
  `kernel/bpf/ringbuf.c` in this tree
- **[Phase 7/8]** `Documentation/bpf/ringbuf.rst` documents 32-bit wrap;
  kernel sibling commit describes four armv7 devices
- **UNVERIFIED:** stable@ lore discussion; whether distro standalone
  libbpf already has this

**YES**

 tools/lib/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 00ec4837a06de..c8fe57401a8b5 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -244,7 +244,7 @@ static int64_t ringbuf_process_ring(struct ring *r, size_t n)
 	do {
 		got_new_data = false;
 		prod_pos = smp_load_acquire(r->producer_pos);
-		while (cons_pos < prod_pos) {
+		while (prod_pos - cons_pos > 0) {
 			len_ptr = r->data + (cons_pos & r->mask);
 			len = smp_load_acquire(len_ptr);
 
-- 
2.53.0

