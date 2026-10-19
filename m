Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E4B573F25;
	Mon, 19 Oct 2026 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418305; cv=none; b=EG5P/JjwVznabuZyrTuyA7leZoRjf1jw5pYMkVr/nWAj/oEFzfn7eTnx51yOQA3QBMLja0YuMbKWWZpfNAWvv/fyerefI5riUjwwSVDWIKss0COIuMaG6OXee5c+dzEafw9GVs4F2nFlKtIepvXjHCCAxrCCxlWIS4mNp/i44io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418305; c=relaxed/simple;
	bh=TcKnzKzhpo8huu/yPgAzmWU6KR+5ZU0doZWx0JTWjnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koypDQt5lQB1udhNBIasGuvDLprlCIXPMc9AwMXkecHF9pb+DhFIusLoJiSBlMadrr43myV96UrsMPIBeRkbvQTpsbfdc6iF37wuND3uoKiNKYwG2tktfqZGN3CvF7mmqpwhQNWUZENw7ceGA1ZLfvIdbVU9HB7NR2wUArJ3H3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEWsS0ZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEWsS0ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8DB1F000CA;
	Mon, 19 Oct 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418302;
	bh=DUJl/GxXz1RYTMumSslgzSZLfPGmTQQDty19QomRVDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEWsS0ZZd9IbPnhFQuC/TUTHOtIAXn/H325c2NMTyC+VU0+xbmowOFa9ri6RbI8rI
	 UFVH5pdO/PuW9SRQqJ0H3Q0AyOjBAaFDwZs+EmuoCnJuJotXJqQDbPIqz8Zxv59PDO
	 vdJinNeC+DeTr7R1qvKpnkMxXie9Bed/rB6sSsENwFraVa7g6l43w8q9cpY6NbITxt
	 kA9rmg4z8btSJtN0c/agEKyKdAGJiGNKIivAq2Vw1qLLsi4hSbyFgTVAEl4IobrMOy
	 LkMORitmMt54HWG6gocUS0oF9nfZoVoaMnTRAV5cLRNYH9V5p9AGH4dm5jz4wj5wKC
	 B/KtBa7jUlM/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Glass <sjg@chromium.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] kconfig: abort rather than loop for ever on EOF
Date: Mon, 19 Oct 2026 09:47:22 -0400
Message-ID: <20261019135441.1420968-151-sashal@kernel.org>
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

From: Simon Glass <sjg@chromium.org>

[ Upstream commit f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55 ]

When a non-interactive 'make oldconfig' or 'syncconfig' meets a new int
or hex symbol whose default cannot be applied, conf_string() reads a
value from stdin. At end of file fgets() returns NULL, no value is set
and the loop asks again. The result is an endless loop which fills the
output until it exhausts memory, rather than a clean failure.

Detect this in conf_string(): if the value cannot be set and stdin is at
end of file, stop with an error that names the symbol.

Note that a symbol with no default doesn't trigger this, since
sym_calc_value() falls back to 0, which is accepted at end of file. The
loop is triggered by a broken Kconfig file, with a default whose text
fails sym_string_valid().

Such mistakes do creep in from time to time and are hard to debug, since
the build fills the log with repeated prompts instead of pointing at the
offending symbol. Some bad defaults draw a parse-time warning, but
menu_validate_number() accepts a reference to any int or hex symbol, so
a cross-type reference loops with no warning at all. For example, "0xff"
is not a valid int value:

  config HEXSYM
          hex
          default 0xff

  config VAL
          int "Value"
          default HEXSYM

Interactive use is unaffected, since feof() only becomes true once a
read actually hits end of file: an invalid answer at a terminal still
re-prompts, while Ctrl-D at such a prompt exits with the error instead
of looping. bool and tristate symbols and choices already accept the
default on an empty line, so they still take their defaults in a
non-interactive build.

Tested with int and hex symbols carrying such defaults: with empty
stdin, the code without this change produces around 190MB of repeated
prompts within two seconds, while with the change it exits 1 naming the
symbol. Piped and interactive (pty) sessions still re-prompt on an
invalid answer and then accept a valid one. A new string symbol with no
default still takes the empty string at end of file, since any text is
valid for a string.

Signed-off-by: Simon Glass <sjg@chromium.org>
Link: https://patch.msgid.link/20260714133545.3294648-1-sjg@chromium.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[kconfig]** **[abort]** stop `conf_string()` from looping
forever when stdin hits EOF.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Simon Glass <sjg@chromium.org>` (author)
- `Link:
  https://patch.msgid.link/20260714133545.3294648-1-sjg@chromium.org`
- `Signed-off-by: Nicolas Schier <nsc@kernel.org>` (kbuild maintainer,
  applied)
- No `Fixes:`, `Cc: stable`, `Reported-by`, `Tested-by`, `Reviewed-by`,
  or `Acked-by` (absence of `Fixes:`/`Cc: stable` is expected for this
  review)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit …]` ignored
  per instructions

**Step 1.3 — Body**
Record:
- **Bug:** non-interactive `make oldconfig` / `syncconfig` on a **new
  int or hex** symbol whose default fails `sym_string_valid()`;
  `fgets()` returns NULL at EOF; the value is never set; `while (1)` re-
  prompts.
- **Symptom:** endless loop; output grows until the host OOMs (~190MB of
  repeated prompts in two seconds without the fix).
- **Root cause:** broken Kconfig default (e.g. `int` defaulting to a
  `hex` symbol whose text is `0xff`). `menu_validate_number()` accepts
  any int/hex symbol, so there is no parse-time warning for the cross-
  type case. A symbol with **no** default does not loop:
  `sym_calc_value()` falls back to `0`, which is valid.
- **Failure mode:** host-side hang + unbounded memory/log growth during
  config/build, not a runtime kernel oops.
- **Versions:** none named; the loop is in `conf_string()`, which has
  been in this form since the git import.

**Step 1.4 — Hidden bug fix?**
Record: **No disguise.** This is an explicit infinite-loop / OOM abort.
Not cleanup or a feature.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `scripts/kconfig/conf.c` only (`+17` / `-0` in the committed
  form)
- Function: `conf_string()`
- Scope: single-function, surgical

**Step 2.2 — Flow**
Record: After `sym_set_string_value()` fails, the loop used to retry
forever. After the change, if `feof(stdin)` it prints `error: no value
for new symbol '%s' at end of input` and `exit(1)`. Interactive invalid
input still re-prompts (`feof` is false until a real EOF). Ctrl-D now
exits instead of spinning.

**Step 2.3 — Bug mechanism**
Record: **Logic / hang.** Host `while (1)` with no EOF termination. Not
UAF, leak, race, or kernel memory unsafety.

Verified in this tree:

```77:161:scripts/kconfig/conf.c
static void xfgets(char *str, int size, FILE *in)
{
        if (!fgets(str, size, in))
                fprintf(stderr, "\nError in reading or end of file.\n");
        if (!tty_stdio)
                printf("%s", str);
}
// ...
static int conf_string(struct menu *menu)
{
        // ...
        while (1) {
                // prompt + conf_askvalue() -> xfgets(stdin)
                if (def && sym_set_string_value(sym, def))
                        return 0;
                // no feof() check — loops forever
        }
}
```

`conf_askvalue()` pre-sets `line[0] = '\n'`. On EOF, `fgets()` fails,
`line` stays `"\n"`, the `case '\n'` path keeps the invalid default,
`sym_set_string_value()` fails (`sym_string_within_range()` →
`sym_string_valid()`), and the loop repeats. `xfgets()` also reprints
the buffer when stdin is not a tty, which is why logs explode.

`menu_validate_number()` in `scripts/kconfig/menu.c` accepts any
`S_INT`/`S_HEX` symbol, matching the commit’s “no parse-time warning”
claim. `sym_string_valid()` for `S_INT` rejects a leading `0x` form
(`0xff` is not a valid int).

**Step 2.4 — Fix quality**
Record: **Obviously correct and minimal.** `feof(stdin)` after a failed
set is the right abort. `exit(1)` matches other fatal kconfig paths in
this file. Regression risk is **low**: valid defaults still apply on
empty/EOF input; bool/tristate/choice are unchanged; strings still
accept any text. Remaining gap (not a regression): a non-EOF `fgets`
error (`ferror` without `feof`) would still loop — pre-existing.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: The `while (1)` / `sym_set_string_value` loop in `conf_string()`
is from **`1da177e4c3f41` (Linux-2.6.12-rc2, 2005)**. It is not new
code. This tree already has a related robustness backport in the same
file: `35d8e7e7da7a6` (`kconfig: fix potential NULL pointer dereference
in conf_askvalue`).

**Step 3.2 — Fixes: tag**
Record: **None.** Bug is ancient, not tied to a later introducing
commit.

**Step 3.3 — File history**
Record: Recent `scripts/kconfig/conf.c` work in this tree is small
robustness/build fixes, not a refactor of `conf_string()`. No
prerequisite series. Standalone.

**Step 3.4 — Author**
Record: Simon Glass (Chromium). No prior `scripts/kconfig/` commits in
**this** 5.10 history. Applied by kbuild maintainer Nicolas Schier.

**Step 3.5 — Dependencies**
Record: **None.** Uses existing `feof`, `fprintf`, `exit`, `sym->name`.
`conf_string()` already prints `sym->name` unconditionally. **Can apply
standalone.**

`git merge-base --is-ancestor f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55
HEAD` → **not an ancestor** (not in this tree yet). Object exists in the
repo but is not on `pending-5.10`.

---

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- Lore/msgid:
  `https://patch.msgid.link/20260714133545.3294648-1-sjg@chromium.org`
- `b4 dig -c f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55` matched by patch-
  id
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: 2 messages — patch + maintainer apply
- Nicolas Schier: “Applied to kbuild/linux.git (kbuild-next-unstable)”
  (`https://git.kernel.org/kbuild/c/7b406f92`)
- **No NAK**, no requested changes, no reviewer `Cc: stable`

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Simon Glass; LKML; **Nathan Chancellor**; **Nicolas Schier**;
Xingjing Deng; **linux-kbuild**. Right kbuild maintainers were on the
patch.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Author describes a reproducible host hang
and measured 190MB/2s growth. Chromium kconfig/oldconfig is a realistic
LTS-style workload.

**Step 4.4 — Series**
Record: **Standalone 1/1.** No sibling patches required.

**Step 4.5 — Stable list**
Record: **No stable-list discussion found** (lore.kernel.org HTTP 403
via WebFetch; web search of `lore.kernel.org/stable` did not hit this
subject). Not treated as a negative.

No revert/follow-up found in search after the apply note.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: **`conf_string()`** only.

**Step 5.2 — Callers**
Record: In `scripts/kconfig/conf.c`, `conf()` calls `conf_string()` for
`S_INT` / `S_HEX` / `S_STRING`. `check_conf()` (oldconfig/syncconfig
restart loop at `conf.c:687-690`) calls `conf()`. `nconf.c`/`mconf.c`
have **separate** `conf_string()` implementations; this patch does not
touch those (ncurses/menuconfig UI).

**Step 5.3 — Callees**
Record: `conf_askvalue()` → `xfgets()` → `fgets(stdin)`;
`sym_get_string_value()`; `sym_set_string_value()` →
`sym_string_within_range()` → `sym_string_valid()`.

**Step 5.4 — Reachability**
Record: **Yes, from a normal kernel build.** `Makefile` includes
`auto.conf.cmd` and runs **`syncconfig`** when Kconfig changes
(`Makefile` ~706–732). `oldconfig`/`syncconfig` are everyday for CI and
distro builds. Unprivileged userspace syscalls are irrelevant; this is
**host kconfig**, triggered by `make`.

**Step 5.5 — Similar patterns**
Record: This tree already backported other kconfig infinite-loop fixes,
e.g. `87ddba29e72be` (macro expand at EOF) and `cc1956f8b278d` (`nconf`
endless search). Same class of host hang.

---

## Phase 6: This tree (5.10.270 / `pending-5.10`)

**Step 6.1 — Buggy code present?**
Record: **Yes.** `scripts/kconfig/conf.c` `conf_string()` lines 130–161:
same `while (1)` without `feof()`. Introduced in 2.6.12-rc2; present for
the entire 5.10 lifetime. `feof(stdin)` is **not** in this file today.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** Context around `if (def &&
sym_set_string_value(sym, def)) return 0;` matches; only line numbers
differ (~158 here vs ~348 upstream).

**Step 6.3 — Alternate fix already here?**
Record: **No.** Grep for `feof(stdin)` and `no value for new symbol` in
`scripts/kconfig` is empty. The `conf_askvalue` NULL-`def` fix is
adjacent but does not stop the EOF loop.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **kbuild/kconfig** (`scripts/kconfig/`). **IMPORTANT** for
anyone who **builds** this kernel (distros, CI, ChromeOS-style LTS,
embedded). Not a runtime CORE path (mm/net/fs).

**Step 7.2**
Record: kconfig in this tree is mature; changes are occasional
robustness backports, not active redesign. Long-lived bug, not a last-
month feature.

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: **Config/build host users** of this 5.10 tree (oldconfig,
syncconfig, automatic `make` syncconfig). Not running-system users.
Distros and out-of-tree Kconfig (ChromeOS, vendor) are in the blast
radius when they add int/hex symbols.

**Step 8.2 — Trigger**
Record: New visible int/hex symbol whose **default string fails
validation**, plus **EOF on stdin** (non-interactive
oldconfig/syncconfig, typical CI). Not every boot. Unprivileged kernel
syscall: no. **Kconfig authors and kernel builders:** yes. Author: these
mistakes “creep in from time to time.”

**Step 8.3 — Severity**
Record: Host **infinite loop + unbounded memory/log growth** (OOM of
`conf`, hung `make`). **HIGH** for the build, not a kernel panic.
Vanilla 5.10 Kconfig may be clean **today**; the bug is in the **tool**,
so the next bad default in a stable/Kconfig backport turns a warning-
shaped mistake into a CI disk/memory incident.

**Step 8.4 — Risk vs benefit**
Record: **Benefit: high for builders** (fail fast, name the symbol).
**Risk: very low** (~8 lines of real code + comment, error path only, no
kernel ABI). Ratio favors backport.

---

## Phase 9: Synthesis

**For**
- Real, demonstrated infinite loop and memory blow-up in `conf_string()`
- Triggered by `oldconfig`/`syncconfig`, including automatic build-time
  `syncconfig`
- Buggy loop exists in this 5.10 tree since 2.6.12
- Tiny, obviously correct, maintainer-applied, author-tested
- Matches the **build-fix** exception (prevents a hung/OOM configurator)
- This tree already takes kconfig hang/crash backports, including in the
  same file

**Against**
- Host tool, not a runtime kernel crash
- Needs a **broken Kconfig default**, not a typical `.config`
- No `Reported-by` / syzbot / stable nomination
- No evidence of a currently broken in-tree 5.10 symbol (not searched
  exhaustively across all Kconfig files)

**Unresolved**
- Could not HTTP-fetch lore.kernel.org (403); thread recovered via `b4
  mbox`
- Did not prove a current in-tree 5.10 Kconfig that trips
  `sym_string_valid()`; the tool bug is still present

**Stable rules**
1. Obviously correct and tested — **PASS** (v1 applied as-is; author
   tested empty/piped/pty)
2. Real bug affecting users — **PASS** (build hang/OOM; Chromium author)
3. Important (hang/OOM of configurator during `make`) — **PASS**
4. Small and contained — **PASS** (one function, +17)
5. No new features/APIs — **PASS**
6. Applies to this tree — **PASS** (clean)

**Exception:** build fix (stop compilation/config hang).

The patch should be backported to **this** 5.10.270 tree: the loop is
here, the fix is surgical, and a silent spin that fills logs until OOM
is exactly what stable builders cannot afford when a later Kconfig
default is wrong.

Verification:
- [Phase 1] Tags: Glass SOB, msgid link, Schier SOB; no Fixes/Reported-
  by/Cc:stable
- [Phase 2] `conf_string()` in this tree: `while (1)` with no `feof`;
  `xfgets` prints on EOF; `sym_string_valid(S_INT)` rejects `0xff`;
  `menu_validate_number()` accepts any int/hex
- [Phase 3] Blame: `1da177e4c3f41`; `git merge-base --is-ancestor
  f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55 HEAD` is false
- [Phase 3] Same-file backport already here: `35d8e7e7da7a6`
  conf_askvalue NULL def
- [Phase 4] `b4 dig`/`b4 mbox`: v1 only; Schier applied to kbuild-next-
  unstable; no NAK
- [Phase 4] Recipients: Nathan Chancellor, Nicolas Schier, linux-kbuild
- [Phase 5] Caller: `conf()` → `conf_string()`; Makefile runs
  `syncconfig`
- [Phase 6] `git describe HEAD` / `make kernelversion`: **5.10.270**
  `pending-5.10`; buggy code at `conf.c:130-161`
- [Phase 6] Apply context matches; no existing `feof(stdin)` in kconfig
- [Phase 8] Failure: host infinite loop + unbounded output; HIGH for
  builds
- UNVERIFIED: live lore.kernel.org HTML (403); whether any current 5.10
  Kconfig default already fails `sym_string_valid()`

**YES**

 scripts/kconfig/conf.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index c368bec5ab601..fe8ba09b00391 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -348,6 +348,23 @@ static int conf_string(struct menu *menu)
 		}
 		if (def && sym_set_string_value(sym, def))
 			return 0;
+
+		/*
+		 * A new int or hex symbol whose default fails validation
+		 * cannot be set from an empty answer. When standard input is
+		 * exhausted, as it is for a non-interactive oldconfig or
+		 * syncconfig, re-asking would loop forever and grow the output
+		 * until it exhausts memory. Stop with an error that names the
+		 * symbol instead. String symbols accept any text, and bool and
+		 * tristate symbols (conf_sym()) and choices (conf_choice())
+		 * accept the default on an empty line, so they are unaffected.
+		 */
+		if (feof(stdin)) {
+			fprintf(stderr,
+				"\nerror: no value for new symbol '%s' at end of input\n",
+				sym->name);
+			exit(1);
+		}
 	}
 }
 
-- 
2.53.0

