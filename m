Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF27A6155CB;
	Mon, 19 Oct 2026 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418645; cv=none; b=fAL25giOXSybXMITrRp4mc0UH6TenwdDN+um0Y2BXTheDjF1PFY7KzNRm0KLRbnFyGs8czc9M6usJA742tHq7fQWQjXd2oTEpXygVWJQmeiJ6bTS72expLyV1fFG+fNIFmRyl3SAx/lg/Va0XrZMe04IOByVBpfWXx+iu5SqEDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418645; c=relaxed/simple;
	bh=dBL88SZdWg+OHaILtB+4vqLppN7xoIma9OkVNKOYwb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6NrDkN5llm07caPuo2YHdfBw+Ad98mZd6bIEuL7skCFVWQ5d2MMpEsHFnRqnent8NK+xFr/VfxbC6yXYjjg5jybnbAdAdhLR9d9TbPIjen0UibgK4fBfC8DnFiqbOdkuIZna/YKNqYVmMG8dyNA+94pnxOKB/d5NaNGK9Di8m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gI4Nvyo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gI4Nvyo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8030F1F000C5;
	Mon, 19 Oct 2026 14:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418642;
	bh=DIhielErLTTM7llarhAejxyZ2UE6k/WPB0646jrq39k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gI4Nvyo0c3cHyXGkO5KUa/rX3itWSs66laY/o0pHGoU0+nvVcJDxcPmA9jLCY9yoK
	 H3apCQqi8cB1weGLzyieq3tNrnzksTqm2r8/b7/Y30tcJgapTuEJUDIuxeMN6H4zqh
	 vYx+q5ISmX8u3sQmyjC+EHyiSKGC+KNYiTApkK2DnxPdSgHDTNMHX5EMfJbxO77ATM
	 83TR3qT8OhaK+lbpm4WCq69VJmOSoBrC/5GMU2bU73k4au6DfjsqPEKMPh42jbwyk1
	 ihKL1w+3tUVmBtM9N/0nG7n0E8D9Y4lhI29KwHky0aRh3DdBZMQk2foCEzn3RBQkCX
	 d4DOmaQrZtgWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhaoJinming <zhaojinming@uniontech.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Mon, 19 Oct 2026 09:51:25 -0400
Message-ID: <20261019135441.1420968-394-sashal@kernel.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit 8ab38bbac02298e3fb03008ed4a0227485c0fd62 ]

In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
returns the error immediately without freeing the CE IRQs that were
successfully registered in previous loop iterations. The probe error
path does not call ath11k_ahb_free_irq() either, so the previously
registered CE IRQ handlers remain attached to the interrupt lines and
are never released.

In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
the error is only logged and the loop continues. The function then
returns 0 indicating success, leaving the device in a partially
configured state where some external IRQs are not registered. This
causes enable_irq()/disable_irq()/free_irq() to be called on
unregistered IRQs during runtime and remove/shutdown, triggering
WARN_ON(!desc->action), and missing interrupt handlers lead to data
loss.

Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
function returns -ENOMEM without freeing the ext IRQs and napi_ndev
that were successfully set up for earlier groups.

Fix all three issues: propagate the error up to the caller and unwind
all successfully registered IRQs and allocated resources on failure.
Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
in the ext IRQ path to match the CE IRQ path and avoid storing a stale
IRQ number on failure.

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260729020005.219253-1-zhaojinming@uniontech.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `8ab38bbac022` (“wifi: ath11k: fix resource
leak on error in ext IRQ setup”)

Local tree: **Linux 6.1.188** (`p-6.1-11-gffee1c0de6cf2`). The candidate
is **not** an ancestor of HEAD. Verdict is for this 6.1.y tree only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
- Record: **[wifi: ath11k]** **[fix]** resource leak on error in AHB ext
  IRQ setup.

**Step 1.2 — Tags**
- Record:
  - `Reviewed-by: Rameshkumar Sundaram
    <rameshkumar.sundaram@oss.qualcomm.com>` (Qualcomm ath11k reviewer)
  - `Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>`
    (Qualcomm ath11k reviewer)
  - `Link: https://patch.msgid.link/20260729020005.219253-1-
    zhaojinming@uniontech.com`
  - `Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>` (author)
  - `Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>`
    (ath11k maintainer, applied)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence is
    expected for this pipeline)
  - No syzbot / sanitizer tags

**Step 1.3 — Body**
The commit describes three bugs in `ath11k_ahb_config_irq()` /
`ath11k_ahb_config_ext_irq()`:

1. **CE `request_irq()` fail:** returns immediately; previously
   registered CE IRQs are not freed. Probe `err_ce_free` does **not**
   call `ath11k_ahb_free_irq()`, so those handlers stay attached.
2. **Ext `request_irq()` fail:** error is logged only; function still
   returns 0. Device probes in a partial-IRQ state. Later `enable_irq()`
   / `disable_irq()` / `free_irq()` on unregistered lines trigger
   `WARN_ON(!desc->action)`; missing handlers cause data loss.
3. **`alloc_netdev_dummy()` fail** on a later group: `-ENOMEM` without
   freeing earlier groups’ ext IRQs / dummy netdevs.

Fix: propagate errors, unwind registered IRQs/resources, assign
`ab->irq_num[irq_idx]` only after a successful `request_irq()`.

- Record: **[Bugs: IRQ leak, swallowed setup error, dummy-netdev leak]**
  **[Symptoms: leaked IRQ handlers; WARN_ON; missing datapath IRQs /
  data loss]** **[No version bounds in the message]** **[Root cause:
  missing unwind + ignored `request_irq()` failure]**

**Step 1.4 — Hidden bug fix?**
- Record: **No.** This is an explicit error-path / resource-leak fix,
  not cleanup disguised as a fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Record: **1 file**, `drivers/net/wireless/ath/ath11k/ahb.c`, **+55 /
  −24**.
- Functions: `ath11k_ahb_free_ext_irq` split into
  `ath11k_ahb_free_ext_irq_grp` + wrapper; new
  `ath11k_ahb_free_ce_irqs`; `ath11k_ahb_free_irq` uses the new helpers;
  `ath11k_ahb_config_ext_irq` and `ath11k_ahb_config_irq` grow unwind
  paths.
- Scope: **single-file surgical fix** (small helper extract, no API
  change).

**Step 2.2 — Flow change**
- **`free_ext_irq`:** all-groups cleanup → per-group helper so a failed
  group can be unwound without touching later groups.
- **`config_ext_irq` `request_irq` fail:** log and continue / return 0 →
  set `num_irq = j`, free current group, unwind prior groups, return
  error.
- **`alloc_netdev_dummy` fail:** immediate `-ENOMEM` → same unwind of
  prior groups.
- **`irq_num` store:** before `request_irq` → after success (avoids a
  stale IRQ number used by later enable/disable/free).
- **`config_irq` CE fail:** bare `return ret` →
  `ath11k_ahb_free_ce_irqs(ab, i)` then return.
- **`config_irq` ext fail:** return `ret` with CE IRQs still held → free
  all CE IRQs then return.

**Step 2.3 — Bug mechanism**
- Record: **[Error-path resource leak + logic/correctness (swallowed
  error)]**
- CE leak = missing `free_irq` on probe failure.
- Ext path = ignored `request_irq` error so probe “succeeds” with
  unregistered IRQs; `ath11k_ahb_ext_grp_enable()` then calls
  `enable_irq()` over `irq_grp->num_irq`.
- Dummy-netdev leak is mainline-only (see Phase 6).

**Step 2.4 — Fix quality**
- Record: **Obviously correct for the two `request_irq` bugs.** Helpers
  match existing free loops. `num_irq = j` before freeing the failed
  group is right (only successful IRQs). `err_request_irq` does `i--` so
  the current group is not double-freed. **Regression risk is low** if
  adapted; **high if the mainline diff is applied blindly** because it
  calls `free_netdev(irq_grp->napi_ndev)` and `napi_ndev` is an embedded
  `struct net_device` here, not a pointer.

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame / introduction**
- Record: Buggy CE early-return and swallowed ext `request_irq` error
  are in the original driver **`d5c65159f2895` (2019-11-23, “ath11k:
  driver for Qualcomm IEEE 802.11ax devices”)**. Present since before
  v5.6; certainly in 6.1.

**Step 3.2 — Fixes: tag**
- Record: **No `Fixes:` tag.** Original buggy commit is `d5c65159f2895`,
  which **is** in this tree.

**Step 3.3 — File history on this tree**
- Record: Recent 6.1.y ahb.c commits are unrelated (IPQ5018 CE remap,
  rproc defer, fw deinit, `platform_get_irq` for MSI). Related older
  commit **`22b59cb965f79`** added `netif_napi_del()` on free to fix a
  reload oops — same area, does **not** fix these leaks. **Standalone
  candidate**, not patch X/Y.

**Step 3.4 — Author**
- Record: ZhaoJinming has **no other ath11k commits in this 6.1 tree**.
  Review/apply came from Qualcomm (Baochen Qiang, Rameshkumar Sundaram,
  Jeff Johnson).

**Step 3.5 — Prerequisites**
- Record: Mainline diff **depends on `bca592ead8252` (2024-04-22,
  dynamic dummy netdev)** for `alloc_netdev_dummy` / `free_netdev`. That
  commit is **not** in 6.1 (`git merge-base --is-ancestor` failed).
  CE/ext `request_irq` unwind does **not** need that commit. **Cannot
  apply the mainline diff standalone; a 6.1-shaped backport can.**

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 8ab38bbac0229` → lore thread
  https://patch.msgid.link/20260728031335.3818736-1-
  zhaojinming@uniontech.com
- Revisions: **v1 (2026-06-22) through v7 (2026-07-28)**; committed
  message id is a follow-up of v7. Review drove: move `irq_grp` to
  function scope, init `ret` on ENOMEM, unwind CE IRQs on ext failure,
  extract per-group/CE free helpers, drop an unreachable `napi_ndev`
  NULL guard, store `irq_num` only after success.
- **No NAK.** Baochen’s v7 comment was process-only (don’t put old-
  version `Link:` in the commit body). **No reviewer `Cc: stable`.**

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Jeff Johnson, Baochen Qiang, `ath11k@lists.infradead.org`,
  `linux-wireless@vger.kernel.org`, `linux-kernel@vger.kernel.org`.
  Right maintainers were on the thread.

**Step 4.3 — Bug report**
- Record: **No user/syzbot/bugzilla report.** Analysis-driven. Severity
  claimed by the author is verified in this tree’s code (Phase 6).

**Step 4.4 — Series**
- Record: **Single-patch series** (v1–v7 are revisions of the same
  change). No sibling patches required.

**Step 4.5 — Stable list**
- Record: **UNVERIFIED.** `lore.kernel.org/stable` fetch returned HTTP
  403. No stable-list discussion found via `b4`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions**
- Record: `ath11k_ahb_free_ext_irq_grp` (new),
  `ath11k_ahb_free_ext_irq`, `ath11k_ahb_free_ce_irqs` (new),
  `ath11k_ahb_free_irq`, `ath11k_ahb_config_ext_irq`,
  `ath11k_ahb_config_irq`.

**Step 5.2 — Callers (this tree)**
- `ath11k_ahb_config_irq()` — only from `ath11k_ahb_probe()`
  (`ahb.c:1219`).
- `ath11k_ahb_free_irq()` — from `ath11k_ahb_free_resources()` on
  remove/shutdown (`ahb.c:1268`), **not** from probe `err_ce_free`.
- `ath11k_ahb_ext_grp_enable()` — from `ath11k_ahb_ext_irq_enable()` /
  NAPI complete; walks `irq_grp->num_irq` and `enable_irq()`.
- Hybrid WCN6750 uses `ath11k_pcic_config_irq()` instead (PCI probe
  **does** have `err_free_irq`).

**Step 5.3 — Callees**
- Record: `request_irq`, `free_irq`, `platform_get_irq_byname`,
  `irq_set_status_flags`, `netif_napi_add` / `netif_napi_del`,
  `init_dummy_netdev` (6.1) vs `alloc_netdev_dummy` / `free_netdev`
  (mainline).

**Step 5.4 — Reachability**
- Record: Probe / start / remove of `CONFIG_ATH11K_AHB` devices
  (IPQ8074/6018/5018 and similar). Userspace cannot hit it via a normal
  syscall; it runs on device bind, `ath11k_ahb_start()`, and unbind.
  **Reachable on every AHB ath11k probe.** The *failure* path needs
  `request_irq()` to fail (missing DT IRQ, IRQ alloc failure).

**Step 5.5 — Similar patterns**
- Record: `ath11k_pcic_ext_irq_config()` **does** return `request_irq`
  errors; PCI probe frees IRQs on error. AHB is the inconsistent path.
  Same swallowed-`request_irq` pattern has been in AHB since 2019.

---

## PHASE 6: THIS TREE (6.1.188)

**Step 6.1 — Does the buggy code exist?**
Yes, two of three bugs:

```617:624:drivers/net/wireless/ath/ath11k/ahb.c
                        if (ret) {
                                ath11k_err(ab, "failed request_irq for
%d\n",
                                           irq);
                        }
                }
        }

        return 0;
```

`num_irq` is set to the **full** count **before** that loop
(`ahb.c:605`), and `ab->irq_num[irq_idx] = irq` is stored **before**
`request_irq()` (`ahb.c:612`). `ath11k_ahb_ext_grp_enable()` then
`enable_irq()`s every entry (`ahb.c:247-248`).

```649:650:drivers/net/wireless/ath/ath11k/ahb.c
                if (ret)
                        return ret;
```

Probe error path:

```1219:1230:drivers/net/wireless/ath/ath11k/ahb.c
        ret = ath11k_ahb_config_irq(ab);
        if (ret) {
                ath11k_err(ab, "failed to configure irq: %d\n", ret);
                goto err_ce_free;
        }
        ...
err_ce_free:
        ath11k_ce_free_pipes(ab);
```

No `ath11k_ahb_free_irq()` on that path.

**Third bug does not exist here.** Dummy NAPI netdev is embedded:

```172:172:drivers/net/wireless/ath/ath11k/core.h
        struct net_device napi_ndev;
```

Setup uses `init_dummy_netdev(&irq_grp->napi_ndev)` (`ahb.c:558`). No
`alloc_netdev_dummy`, no `free_netdev`.

- Record: **Bugs 1 and 2 present since 2019. Bug 3 introduced in 2024;
  not in 6.1.**

**Step 6.2 — Backport difficulty**
- `git show 8ab38bb | git apply --check` **fails**: context expects
  `free_netdev(irq_grp->napi_ndev)`.
- Needed 6.1 backport: same error propagation and CE/ext unwind;
  **omit** `free_netdev` and the `alloc_netdev_dummy` ENOMEM path; keep
  `netif_napi_del` only.
- Record: **Needs rework (not a clean cherry-pick).** Blind apply would
  not compile.

**Step 6.3 — Related fixes already here?**
- Record: **No equivalent fix.** `22b59cb965f79` only added
  `netif_napi_del` on the success/remove free path.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
- Record: **`drivers/net/wireless/ath/ath11k` (AHB HIF).** Criticality:
  **IMPORTANT** — Qualcomm Wi-Fi 6 on IPQ SoCs used in routers/APs; not
  core mm/net, but common on 6.1 LTS embedded/enterprise images.
  `CONFIG_ATH11K_AHB`.

**Step 7.2**
- Record: Mature driver (2019). 6.1.y still receives targeted ath11k
  backports (rproc defer, fw deinit, IPQ5018 CE remap). Not a staging or
  newly added subsystem.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
- Record: **Driver-specific / config-specific:** `CONFIG_ATH11K_AHB`
  (IPQ8074/6018/5018 class). Hybrid WCN6750 uses the PCI-common path and
  is not fixed (or broken) by this change.

**Step 8.2 — Trigger**
- Record: `request_irq()` failure during probe (bad/missing DT
  interrupt, IRQ exhaustion). **Uncommon on a correct board DT**, but
  then **every** subsequent enable/disable/free and datapath completion
  is wrong. Not an unprivileged syscall primitive; bind is typically
  module load / boot. **Unprivileged users do not directly trigger it.**

**Step 8.3 — Failure mode**
- Swallowed ext IRQ error: **`WARN_ON(!desc->action)`** plus missing
  TX/RX completion IRQs → **data loss / broken Wi-Fi while probe reports
  success**. Severity: **HIGH**.
- CE IRQ leak on failed probe: leaked IRQ actions, messy rebind.
  Severity: **MEDIUM–HIGH** (reload already oopsed in this area before
  `22b59cb`).
- Dummy-netdev leak: **N/A on this tree**.

**Step 8.4 — Risk vs benefit**
- Benefit: **High** for AHB boards if `request_irq` fails (WARN_ON +
  silent datapath loss is worse than a clean probe failure).
- Risk of a **correct 6.1 backport**: **Low** (error paths + helper
  split; success path behavior unchanged).
- Risk of the **raw mainline patch**: **High** (`free_netdev` on an
  embedded `net_device`).
- Ratio: **favorable if adapted; do not cherry-pick as-is.**

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

**For:**
- Real bugs in **this** 6.1 tree (CE leak; swallowed ext `request_irq`).
- User-visible: kernel `WARN_ON`, missing datapath IRQs, data loss,
  leaked IRQ handlers.
- Small, one-file, no new API/feature.
- Logic checked against probe/remove and `enable_irq` paths in this
  checkout.
- Present since 2019; reviewed by Qualcomm ath11k reviewers; applied by
  Jeff Johnson.
- PCI sibling already returns `request_irq` errors; AHB is the hole.

**Against:**
- Mainline diff **does not apply**; it assumes `alloc_netdev_dummy` /
  pointer `napi_ndev` (`bca592ead8252` not in 6.1).
- Third issue is **not** in 6.1.
- Trigger is uncommon (needs `request_irq` failure).
- No `Reported-by` / syzbot / stable-list nomination (stable search
  UNVERIFIED).
- Author is not an ath11k regular on this tree.

**Unresolved:** stable@ discussion (HTTP 403).

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** for the two applicable bugs
   (review + maintainer apply). The shipped diff is **not** drop-in
   correct on 6.1.
2. Real bug affecting users? **PASS** (WARN_ON, data loss, IRQ leak on
   AHB probe/remove).
3. Important (crash / warn / data loss / leak)? **PASS** — HIGH for
   swallowed ext IRQ failure.
4. Small and contained? **PASS** (one file, ~50 lines of logic).
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **FAIL** as a raw cherry-pick; **PASS** as a
   small mechanical backport (drop `free_netdev` / `alloc_netdev_dummy`
   ENOMEM path).

**Step 9.3 — Exception category**
- Record: **None** (not a device ID, quirk, DT, build, or doc fix).
  Qualifies as a normal error-path / correctness bug fix.

**Step 9.4 — Decision**
The two bugs that matter on 6.1 are in this tree, are real, and are
serious when they fire. The mainline commit also cleans up a later
dummy-netdev leak that 6.1 does not have; that does not erase the AHB
`request_irq` holes. A 6.1 backport must **not** call `free_netdev` on
the embedded `napi_ndev`. With that adjustment, this belongs on 6.1.y.

---

## What the commit solves for 6.1 users

On IPQ AHB ath11k, a failed `request_irq()` for an ext IRQ is ignored
and probe still succeeds. Start/remove then `enable_irq`/`free_irq`
unregistered lines (`WARN_ON`) and drop datapath interrupts. A failed CE
`request_irq()` also leaks earlier CE handlers because probe’s
`err_ce_free` never calls `ath11k_ahb_free_irq()`. Both are old,
contained, and worth fixing on this LTS tree. The dummy-netdev part of
the mainline patch is irrelevant here and must be omitted.

---

## Verification
- [Phase 1] Parsed tags: Reviewed-by Rameshkumar Sundaram, Baochen
  Qiang; SOB ZhaoJinming + Jeff Johnson; Link msgid 20260729020005; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +55/−24 in `ahb.c`; helper split + error unwind;
  `irq_num` assigned after success
- [Phase 3] `git log` on `ahb.c`: swallowed ext error and CE early-
  return since `d5c65159f2895` (2019-11-23)
- [Phase 3] No Fixes: tag; `bca592ead8252` is **not** an ancestor of
  HEAD
- [Phase 3] `git log --author=ZhaoJinming` on ath11k in this tree: no
  other commits
- [Phase 4] `b4 dig -c 8ab38bbac0229`: thread https://patch.msgid.link/2
  0260728031335.3818736-1-zhaojinming@uniontech.com
- [Phase 4] `b4 dig -a`: v1–v7; committed version is latest content
  (v6+irq_num ordering, v7 resend)
- [Phase 4] `b4 dig -w`: Jeff Johnson, Baochen Qiang, ath11k and linux-
  wireless lists
- [Phase 4] mbox: Baochen process comment only; no NAK; no Cc:stable
- [Phase 4] lore.kernel.org WebFetch: HTTP 403; stable-list search
  UNVERIFIED
- [Phase 5] Callers: `ath11k_ahb_probe` → `config_irq`; enable path
  `ath11k_ahb_ext_grp_enable` uses `num_irq`
- [Phase 6] `git describe HEAD` / Makefile: **6.1.188**
  (`p-6.1-11-gffee1c0de6cf2`); `v6.1.188` is ancestor
- [Phase 6] `git merge-base --is-ancestor 8ab38bbac0229 HEAD`: **not
  present**
- [Phase 6] Read `ahb.c` 545–659 and 1219–1230: bugs 1 and 2 present;
  `init_dummy_netdev` / embedded `napi_ndev`
- [Phase 6] `git apply --check` of 8ab38bb: **does not apply** (expects
  `free_netdev`)
- [Phase 8] Failure mode verified: `enable_irq` on stored irq_num after
  ignored `request_irq` → WARN_ON / data loss
- UNVERIFIED: whether stable@ already discussed this commit (lore 403)

The two AHB `request_irq` bugs exist in 6.1.188, are user-visible when
they trigger, and a small adapted backport (no `free_netdev`) is the
right way to take this commit.

**YES**

 drivers/net/wireless/ath/ath11k/ahb.c | 79 +++++++++++++++++++--------
 1 file changed, 55 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index b8437e23e5192..5d8c0457721cd 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -431,36 +431,44 @@ static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)
 	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
 }
 
-static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
+static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
+					struct ath11k_ext_irq_grp *irq_grp)
 {
-	int i, j;
-
-	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
+	int j;
 
-		for (j = 0; j < irq_grp->num_irq; j++)
-			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
+	for (j = 0; j < irq_grp->num_irq; j++)
+		free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
 
-		netif_napi_del(&irq_grp->napi);
-		free_netdev(irq_grp->napi_ndev);
-	}
+	netif_napi_del(&irq_grp->napi);
+	free_netdev(irq_grp->napi_ndev);
 }
 
-static void ath11k_ahb_free_irq(struct ath11k_base *ab)
+static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
 {
-	int irq_idx;
 	int i;
 
-	if (ab->hw_params.hybrid_bus_type)
-		return ath11k_pcic_free_irq(ab);
+	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++)
+		ath11k_ahb_free_ext_irq_grp(ab, &ab->ext_irq_grp[i]);
+}
 
-	for (i = 0; i < ab->hw_params.ce_count; i++) {
+static void ath11k_ahb_free_ce_irqs(struct ath11k_base *ab, int max_idx)
+{
+	int irq_idx, i;
+
+	for (i = 0; i < max_idx; i++) {
 		if (ath11k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
 			continue;
 		irq_idx = ATH11K_IRQ_CE0_OFFSET + i;
 		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
 	}
+}
+
+static void ath11k_ahb_free_irq(struct ath11k_base *ab)
+{
+	if (ab->hw_params.hybrid_bus_type)
+		return ath11k_pcic_free_irq(ab);
 
+	ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
 	ath11k_ahb_free_ext_irq(ab);
 }
 
@@ -524,20 +532,25 @@ static irqreturn_t ath11k_ahb_ext_interrupt_handler(int irq, void *arg)
 static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 {
 	struct ath11k_hw_params *hw = &ab->hw_params;
+	struct ath11k_ext_irq_grp *irq_grp;
 	int i, j;
 	int irq;
 	int ret;
 
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 		u32 num_irq = 0;
 
+		irq_grp = &ab->ext_irq_grp[i];
+
 		irq_grp->ab = ab;
 		irq_grp->grp_id = i;
 
 		irq_grp->napi_ndev = alloc_netdev_dummy(0);
-		if (!irq_grp->napi_ndev)
-			return -ENOMEM;
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			irq_grp->num_irq = 0;
+			goto err_request_irq;
+		}
 
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath11k_ahb_ext_grp_napi_poll);
@@ -585,14 +598,11 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 				}
 			}
 		}
-		irq_grp->num_irq = num_irq;
-
-		for (j = 0; j < irq_grp->num_irq; j++) {
+		for (j = 0; j < num_irq; j++) {
 			int irq_idx = irq_grp->irqs[j];
 
 			irq = platform_get_irq_byname(ab->pdev,
 						      irq_name[irq_idx]);
-			ab->irq_num[irq_idx] = irq;
 			irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
 			ret = request_irq(irq, ath11k_ahb_ext_interrupt_handler,
 					  IRQF_TRIGGER_RISING,
@@ -600,11 +610,24 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 			if (ret) {
 				ath11k_err(ab, "failed request_irq for %d\n",
 					   irq);
+				irq_grp->num_irq = j;
+				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
+				goto err_request_irq;
 			}
+			ab->irq_num[irq_idx] = irq;
 		}
+
+		irq_grp->num_irq = num_irq;
 	}
 
 	return 0;
+
+err_request_irq:
+	for (i--; i >= 0; i--) {
+		irq_grp = &ab->ext_irq_grp[i];
+		ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
+	}
+	return ret;
 }
 
 static int ath11k_ahb_config_irq(struct ath11k_base *ab)
@@ -629,16 +652,24 @@ static int ath11k_ahb_config_irq(struct ath11k_base *ab)
 		ret = request_irq(irq, ath11k_ahb_ce_interrupt_handler,
 				  IRQF_TRIGGER_RISING, irq_name[irq_idx],
 				  ce_pipe);
-		if (ret)
+		if (ret) {
+			ath11k_err(ab, "failed request_irq for %d\n", irq);
+			ath11k_ahb_free_ce_irqs(ab, i);
 			return ret;
+		}
 
 		ab->irq_num[irq_idx] = irq;
 	}
 
 	/* Configure external interrupts */
 	ret = ath11k_ahb_config_ext_irq(ab);
+	if (ret) {
+		ath11k_err(ab, "failed to configure ext irq: %d\n", ret);
+		ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int ath11k_ahb_map_service_to_pipe(struct ath11k_base *ab, u16 service_id,
-- 
2.53.0

