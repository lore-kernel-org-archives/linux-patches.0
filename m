Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556BB61452C;
	Mon, 19 Oct 2026 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418641; cv=none; b=JyyvjgGe3bapb9LRB6tUspGuFvHdR6vsWqw2MI0zZ/8m7WR22qYXggbkRWFNdFfhg677KirPPpiur8EZ+iYVdUa9bL8gQIATiSxYGfp8AzYmXDpF8HaAwCOpqTUiMiAhvMgkTS+eSc3Pi2boBVXvwdRbwd0v6Ghnp+8oNYdMj2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418641; c=relaxed/simple;
	bh=F6lt85MPcOEl59jtb3ug1gRiJSnG6SVyKhxF5/x/u2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFRjWUBXBBOyAqrOCIEkNYseFyWzdbTyGWU47aceT0vCSkGMV8LDBR7Lo6BQlbR3BqJvXN+CJKx04u6m1J7hGNnJ0QNqKsOaJ6EAAMhzoGQnG0XK9rYw+dyneE31FU+IuDDKR+NL4aIkUa9IzSh8PJlf3xeUQoc79mv/Dz2/Ga0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0Ihlqp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0Ihlqp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1591F000C5;
	Mon, 19 Oct 2026 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418639;
	bh=B4aUK8YmLb+jDiSRsCJYcxErZJfEJETwyn2Yf6MMcYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0Ihlqp5IHOLY7iEX/gGb91SPVlxhehyTLXu3PeC61HY2FUHgBSSVHJH286T3Jd9m
	 GCoHIe72qawwOshCpP10Pd5nvQGwije+bnUZphIHJhrf9ykSoQeG4GcCXt/DL2qzcF
	 iYUEWotpv5T3U7yDOx2H60YZ4vppYBmQ503K4RviGAEidPwP5Xelr0ZGqwhAxxD/og
	 Kkd8iV08sv4Exwkmoq6A6QTZAaO8DbWM8DZl/0PuHMYnTY057BY8BjK11Ms9rvsrud
	 IYZ873sUvUcmxHL5y80Rs9HvjZo1RFTZjd78bJR9ySxjc4vk9JIlvDOcGrLRisPOP+
	 ht/Mn+jIHhldA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] firmware: imx: scu: manage mailbox channels and global handle
Date: Mon, 19 Oct 2026 09:51:23 -0400
Message-ID: <20261019135441.1420968-392-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 55c748d596f841a18cf659ce0999f64029a5c88c ]

imx_scu_probe() requests mailbox channels with the non-managed
mbox_request_channel_byname() helper and then publishes sc_ipc through
the global imx_sc_ipc_handle.  Later probe failures, including child
population failure, can leave the channels and global handle live after
the probe has failed.

Register devres actions to free each mailbox channel and clear the global
handle.  Also depopulate partially created child devices when
devm_of_platform_populate() reports an error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[firmware/imx SCU] [manage] Register managed
cleanup for mailbox channels and the global IPC handle, and depopulate
children if probe fails.`

**Step 1.2:** Tags present:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Frank Li <Frank.Li@nxp.com>` (i.MX maintainer who
  applied it)

No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Link:`, or `Cc: stable`. Absence of those tags is expected for this
review and is not treated as a negative signal.

**Step 1.3:** Record:
- **Bug:** `imx_scu_probe()` uses unmanaged
  `mbox_request_channel_byname()` and then publishes `sc_ipc` via the
  global `imx_sc_ipc_handle`. Later probe failures, including
  `devm_of_platform_populate()`, leave channels allocated and the global
  handle set.
- **Symptom:** Leaked mailbox channels after a failed probe; a live
  global handle to an object that `devm_kzalloc` then frees; partial
  child devices left behind.
- **Version info:** None in the message. Driver originated in v4.20
  (`edbee095fafb4`).
- **Root cause:** Non-devm mailbox requests plus a global pointer with
  no rollback on the remaining error paths.

**Step 1.4:** Record: This is an explicit probe-error-path resource-leak
/ dangling-pointer fix, not a disguised cleanup. The wording matches the
diff.

## Phase 2: Diff analysis

**Step 2.1:** Record:
- File: `drivers/firmware/imx/imx-scu.c` (+24 / −1)
- Functions added: `imx_scu_free_mbox_chan()`, `imx_scu_clear_handle()`
- Function modified: `imx_scu_probe()`
- Scope: single-file surgical fix

**Step 2.2:** Before → after:
1. After a successful `mbox_request_channel_byname()`, the channel was
   never registered with devres. Mid-loop failure (`-EPROBE_DEFER`,
   `-ENOMEM` from `kasprintf`, later channel failure) returned without
   `mbox_free_channel()`. After: each channel is wrapped in
   `devm_add_action_or_reset(..., imx_scu_free_mbox_chan, ch)`.
2. `imx_sc_ipc_handle = sc_ipc` was published with no undo. After: a
   matching `devm_add_action_or_reset(..., imx_scu_clear_handle,
   sc_ipc)` NULLs it on unwind if it still points at this object.
3. `return devm_of_platform_populate(dev)` could fail after
   `of_platform_populate()` had already created some children
   (`devm_of_platform_populate()` does **not** depopulate on failure; it
   only `devres_free()`s the tracking pointer). After: explicit
   `of_platform_depopulate(dev)` on that error.

**Step 2.3:** Record: `[error-path resource leak + dangling global
pointer]`
- Mailbox leak: unmanaged `mbox_request_channel_byname()` with no free
  on later probe failure.
- Retry hazard: `__mbox_bind_client()` returns `-EBUSY` if `chan->cl` is
  already set, so a later probe retry can stick forever.
- Handle leak / UAF: `sc_ipc` is `devm_kzalloc`’d; probe failure
  releases it while `imx_sc_ipc_handle` still points at it. Other i.MX
  drivers call `imx_scu_get_handle()`.
- Child leak: failed `of_platform_populate()` still sets
  `OF_POPULATED_BUS` and can leave partial children.

**Step 2.4:** Record: The mailbox and handle `devres` actions are
obviously correct (`devm_add_action_or_reset` runs the action
immediately if registration fails). Calling `of_platform_depopulate()`
only on populate failure is the right API:
`devm_of_platform_depopulate()` would `WARN` because the managed
resource was never added. Regression risk is low. Remaining related
leaks (`gip3`, `soc_device`, secondary static handles) are pre-existing
and not introduced here.

## Phase 3: Git history

**Step 3.1:** Record: Unmanaged `mbox_request_channel_byname()` and
`imx_sc_ipc_handle = sc_ipc` come from `edbee095fafb4` (“firmware: imx:
add SCU firmware driver support”, 2018-10-08), first contained in
**v4.20-rc1**. The bug is long-standing.

**Step 3.2:** No `Fixes:` tag. Not applicable.

**Step 3.3:** Related commits on this file:
- `89f12d6509bff` — kasprintf leak in the same probe loop (same class of
  bug)
- `fbf10b86f6057` — OF node leak in probe
- `97a07dd2b559d` — `devm_mutex_init` (adjacent context; not a
  functional prerequisite)
- `ff79af939d847` — `suppress_bind_attrs = true`

This is a standalone v1 patch, not part of a series. No follow-ups to
this file after `55c748d596f84`.

**Step 3.4:** Pengpeng Hou has only this commit in
`drivers/firmware/imx/`. Frank Li (NXP i.MX maintainer) applied it.
Author is a contributor; the applying maintainer is the subsystem owner.

**Step 3.5:** No hard dependencies. `devm_add_action_or_reset()` is in
`include/linux/device/devres.h` in this tree. Applies standalone.

## Phase 4: Mailing list and external research

**Step 4.1:** Record:
- Lore / msgid:
  https://patch.msgid.link/20260616005902.11634-1-pengpeng@iscas.ac.cn
- Series: v1 only (`b4 dig -a`)
- Maintainer apply: Frank Li, “Applied, thanks!” (24 Jul 2026), commit
  `55c748d596f84`
- No NAK. No `Cc: stable` suggestion in the thread.
- Sashiko bot flagged **pre-existing** incomplete cleanup (`gip3`,
  `soc_device`, secondary handles, RPC timeout). Those are not
  regressions from this patch.

**Step 4.2:** Recipients (`b4 dig -w`): Frank Li, Sascha Hauer,
Pengutronix, Fabio Estevam, `imx@lists.linux.dev`, `linux-arm-kernel`,
`linux-kernel`. Appropriate i.MX maintainers were on To/Cc.

**Step 4.3:** No bugzilla / syzbot / user `Reported-by`. Bug is from
code inspection of the probe error path.

**Step 4.4:** Standalone 1/1 patch. No series dependencies.

**Step 4.5:** Record: UNVERIFIED for lore.kernel.org/stable (Anubis bot
wall). Original imx thread has no stable discussion.

## Phase 5: Code semantic analysis

**Step 5.1:** Record: `imx_scu_free_mbox_chan`, `imx_scu_clear_handle`,
`imx_scu_probe`.

**Step 5.2:** `imx_scu_probe()` is the platform probe for `fsl,imx-scu`.
`imx_scu_get_handle()` is called from clk-scu, scu-pd, thermal, rtc,
pinctrl, nvmem, GPIO, reset, FEC, FlexCAN, remoteproc, DRM, SOF, and
others. Impact is every i.MX8QM/QXP SCU consumer.

**Step 5.3:** Probe allocates `sc_ipc`, requests MU mailbox channels,
publishes the global handle, then populates child devices. Callees:
`mbox_request_channel_byname`, `mbox_free_channel`,
`devm_of_platform_populate`, `of_platform_depopulate`.

**Step 5.4:** Reachable at boot on SCU SoCs (`subsys_initcall_sync`).
Not a syscall, but it is the firmware IPC path those boards need to
bring up clocks, power domains, and peripherals. Unprivileged userspace
cannot poke it directly.

**Step 5.5:** Same driver already had a kasprintf leak fix in this
probe. `imx_scu_enable_general_irq_channel()` still requests unmanaged
`gip3` (pre-existing, not this patch).

## Phase 6: Local tree

**Step 6.1:** Local tree is **7.3.0-rc4** (`git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`). Buggy pattern was introduced in v4.20 and
is in this lineage. `git merge-base --is-ancestor 55c748d596f84 HEAD`
succeeds. Pre-fix probe is in `55c748d596f84^`.

**Step 6.2:** Expected apply: clean on this tree (`devm_mutex_init`
context matches).

**Step 6.3:** No alternate fix for mailbox/handle cleanup. Prior leak
fixes (`89f12d6509bff`, `fbf10b86f6057`) do not cover this.

## Phase 7: Subsystem context

**Step 7.1:** Record: `[drivers/firmware/imx] [IMPORTANT]` — i.MX8QM/QXP
System Controller IPC. Not core mm/net, but it is the firmware bus those
SoCs use for clocks, PD, pinmux, thermal, RTC.

**Step 7.2:** Mature driver (2018), occasional probe-correctness fixes.
Not a new subsystem.

## Phase 8: Impact and risk

**Step 8.1:** i.MX8QM/QXP (and similar SCU) users with `CONFIG_IMX_SCU`.
Driver-specific / SoC-specific.

**Step 8.2:** Trigger is probe failure **after** some channels were
requested: mid-loop `kasprintf` `-ENOMEM`, a later
`mbox_request_channel_byname()` failure, `devm_mutex_init()` failure, or
`devm_of_platform_populate()` failure. First-channel `-EPROBE_DEFER`
does **not** leak (nothing held yet). Not userspace-triggerable except
via boot / driver bind.

**Step 8.3:** Failure mode:
- Leaked MU channels → retry gets `-EBUSY` → SCU never probes →
  clocks/PD/peripherals fail (**HIGH**, can make the board unusable)
- Dangling `imx_sc_ipc_handle` after `devm` frees `sc_ipc` (**HIGH** UAF
  if another driver then calls `imx_scu_get_handle()`)
- Orphan child devices after failed populate (**MEDIUM**)

Happy-path probe is unchanged.

**Step 8.4:** Benefit: prevents stuck SCU probe and a global-handle UAF
on real error paths. Risk: ~24 lines, probe error path only, standard
`devres` pattern. Ratio: favorable.

## Phase 9: Synthesis

**Evidence FOR:**
- Real leak of exclusive mailbox channels; `__mbox_bind_client()`
  returning `-EBUSY` can permanently break SCU probe retry.
- Global handle left pointing at `devm`-freed `sc_ipc` after populate
  failure (UAF for every `imx_scu_get_handle()` caller).
- `of_platform_depopulate()` on failed `devm_of_platform_populate()` is
  correct (verified against `drivers/of/platform.c`).
- Small, single-file, no new API.
- Applied by the i.MX maintainer; v1 accepted as-is.
- Same probe function already needed leak fixes; this is the
  mailbox/handle analogue.
- Code and helpers exist in this 7.3-rc4 tree; no missing prerequisites.

**Evidence AGAINST:**
- No user/syzbot report; author-found error-path bug.
- Trigger is uncommon (not the first-channel `-EPROBE_DEFER` case).
- Incomplete: `gip3`, `soc_device`, and secondary IPC statics still leak
  (pre-existing).
- Affects SCU i.MX8 platforms only.

**Unresolved:** lore.kernel.org/stable search blocked (Anubis). Thread
via `b4 dig` had no stable nomination.

**Stable rules:**
1. Obviously correct and tested? **PASS** — standard `devres` unwind;
   maintainer applied it; no NAK.
2. Real bug affecting users? **PASS** — leaked exclusive channels and a
   dangling global IPC handle on failed probe.
3. Important (crash/security/corruption/deadlock)? **PASS** — `-EBUSY`
   probe stall can prevent SCU bring-up; dangling handle is a UAF.
   Severity HIGH, not a happy-path panic.
4. Small and contained? **PASS** — 24 insertions, one file.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — context matches; helpers present.

**Exception category:** none; this is a normal error-path leak/UAF fix.

The local tree is 7.3-rc4. The SCU driver and the buggy unmanaged
mailbox/handle pattern are in this lineage (since v4.20). The fix is a
small, correct rollback of probe resources. Remaining gip3/soc_dev gaps
are not a reason to keep the main channel/handle leak.

Verification:
- [Phase 1] Parsed tags: only author + Frank Li SOBs; no Fixes/Reported-
  by/Cc: stable
- [Phase 2] Diff: +24/−1 in `imx_scu_probe()`;
  `devm_add_action_or_reset` for mbox + handle; `of_platform_depopulate`
  on populate failure
- [Phase 2] `devm_of_platform_populate()` on failure does
  `devres_free(ptr)` without depopulate; `of_platform_populate()` still
  sets `OF_POPULATED_BUS` — explicit depopulate is required and not a
  double-free
- [Phase 2] `__mbox_bind_client()` returns `-EBUSY` if `chan->cl` is set
  — verified in `drivers/mailbox/mailbox.c`
- [Phase 3] Blame: bug from `edbee095fafb4` (v4.20-rc1); `git merge-base
  --is-ancestor 55c748d596f84 HEAD` true
- [Phase 3] No Fixes: tag; no follow-up commits on this file
- [Phase 4] `b4 dig -c 55c748d596f84`:
  https://patch.msgid.link/20260616005902.11634-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: Frank Li / Sascha Hauer /
  imx list CC’d
- [Phase 4] mbox: Frank Li “Applied, thanks!”; Sashiko noted pre-
  existing gaps, no NAK
- [Phase 4] lore.kernel.org/stable: UNVERIFIED (bot challenge)
- [Phase 5] Callers of `imx_scu_get_handle()` span clk, pd, net,
  thermal, rtc, drm, etc.
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4; buggy probe exists in parent of this commit
- [Phase 8] Failure mode: mailbox leak → stuck probe / dangling handle
  UAF; severity HIGH

**YES**

 drivers/firmware/imx/imx-scu.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index 8c28e25ddc8a6..28d745ae06067 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -82,6 +82,17 @@ static int imx_sc_linux_errmap[IMX_SC_ERR_LAST] = {
 
 static struct imx_sc_ipc *imx_sc_ipc_handle;
 
+static void imx_scu_free_mbox_chan(void *data)
+{
+	mbox_free_channel(data);
+}
+
+static void imx_scu_clear_handle(void *data)
+{
+	if (imx_sc_ipc_handle == data)
+		imx_sc_ipc_handle = NULL;
+}
+
 static inline int imx_sc_to_linux_errno(int errno)
 {
 	if (errno >= IMX_SC_ERR_NONE && errno < IMX_SC_ERR_LAST)
@@ -321,6 +332,11 @@ static int imx_scu_probe(struct platform_device *pdev)
 		dev_dbg(dev, "request mbox chan %s\n", chan_name);
 		/* chan_name is not used anymore by framework */
 		kfree(chan_name);
+
+		ret = devm_add_action_or_reset(dev, imx_scu_free_mbox_chan,
+					       sc_chan->ch);
+		if (ret)
+			return ret;
 	}
 
 	sc_ipc->dev = dev;
@@ -328,6 +344,9 @@ static int imx_scu_probe(struct platform_device *pdev)
 	init_completion(&sc_ipc->done);
 
 	imx_sc_ipc_handle = sc_ipc;
+	ret = devm_add_action_or_reset(dev, imx_scu_clear_handle, sc_ipc);
+	if (ret)
+		return ret;
 
 	ret = imx_scu_soc_init(dev);
 	if (ret)
@@ -340,7 +359,11 @@ static int imx_scu_probe(struct platform_device *pdev)
 
 	dev_info(dev, "NXP i.MX SCU Initialized\n");
 
-	return devm_of_platform_populate(dev);
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		of_platform_depopulate(dev);
+
+	return ret;
 }
 
 static const struct of_device_id imx_scu_match[] = {
-- 
2.53.0

