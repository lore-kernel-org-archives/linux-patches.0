Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9171062D2FF;
	Mon, 19 Oct 2026 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418720; cv=none; b=MxzK2l35TC8MScBB+ZKLsv77zVG86Cgv2ZKYRjHU8HfUbimS2GMiInJ+GE0z3asoGbAHd6YZXlDfI88DAxgtw5ndXu3MMlcrau8oCZAHOOiyl1W3YVPQJHFe9dfIGLSlw9QrN8IIByLqRxmjRA5mN7oJmyQoyEuSUnWx+iX8il8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418720; c=relaxed/simple;
	bh=HHXumO9yere8xenjgPU0DYVqiwNLD7RGMQ0V4N4u0EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7/cvyDHp4SjsjnLA47Q2hm3WD4KR30DkRgUHv1UGgvhj7C9Yi7s4WFwD+ahZu6rz0s2MgqLxTG4ChdKOWaZrlVgNHhN+rmaGf5BNNAztFExg5VIafvc3hDP5cChr+l+joJ7R4SqZ/J33lPq7ew3p9uu8Ufakjubv4fcAUqrnkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSvF8u9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSvF8u9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BAF1F000C6;
	Mon, 19 Oct 2026 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418716;
	bh=7WhbfMwH4dxw4f20PGQgV+68qXjbuOI35F5OglP1Mb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSvF8u9wVIHhhGrbixHy5POgfR47Y5C3F6epKX1OrYMgxj1qB/JgK6DY+5cVa4UI4
	 EMtqn+K1F9jri8mZ9890p/GSrrcPioygeLH4CAn4IS/hfmrtcqtnXiyHg5EEPMx4vH
	 ay6lY3QSPAEMpB2ifCQ+ltuJeHKGviNhLLEJ2newQfPdFlYtQdlZkRYWjlAPt2XRHO
	 wp9gsp1L2vUR1xXucnLlBsXtILOQLxFlTCmVp14bNMlcMP5pkEN02Nz1kQRM3++kJn
	 EvLhG7C7Bk6/FbzZzE1yaxQiGgXX/DH33dypCqaWcNEwc+L5gP4E3x8opE9M5C+ZRx
	 GNDDgHeMKfKQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kiseok.jo@irondevice.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: sma1303: remove fault-check sysfs group on remove
Date: Mon, 19 Oct 2026 09:52:16 -0400
Message-ID: <20261019135441.1420968-445-sashal@kernel.org>
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

[ Upstream commit ce3733792d38ade8df8ce288a96ff0c6ad858bf3 ]

sma1303_i2c_probe() creates a sysfs group that exposes the fault-check
controls. The check_fault_status store callback can queue
check_fault_work.

sma1303_i2c_remove() only cancels the delayed work. It does not remove
the sysfs group, so the controls can remain published after remove while
their callbacks still use the driver data and can queue the work again.

Remove the sysfs group before cancelling the delayed work.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615064456.28615-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line unbind/UAF fix in the SMA1303 codec. The local tree
is **6.18.53**; the driver and the unmatched `sysfs_create_group()` have
been present here since v6.3.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `ASoC: sma1303`
- Action verb: **remove**
- Claimed intent: tear down the fault-check sysfs group in the I2C
  remove path

Record: [ASoC/sma1303] [remove] [tear down fault-check sysfs group on
driver remove]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Present (ignoring pipeline `Upstream commit` / `Signed-off-by: Sasha
Levin`):
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260615064456.28615-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)

Absent (expected for this review): `Fixes:`, `Cc: stable`, `Reported-
by`, `Tested-by`, `Reviewed-by`, `Acked-by`.

Record: Author SOB + ASoC maintainer SOB + lore Link. No syzbot/user
report tags.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: `sma1303_i2c_probe()` creates a sysfs group;
  `sma1303_i2c_remove()` only `cancel_delayed_work_sync()`s
  `check_fault_work`.
- Symptom: sysfs controls stay published after remove. Their store
  callback uses driver private data and can queue `check_fault_work`
  again.
- Root cause: missing `sysfs_remove_group()` before work cancellation.
- No stack trace, no version list, no “this is theoretical only”
  language.

Record: [sysfs left published after unbind] [UAF / re-queue of delayed
work after remove] [no version info] [missing sysfs teardown]

**Step 1.4: DETECT HIDDEN BUG FIXES**
This is not disguised cleanup. The message describes a concrete lifetime
bug.

Record: [Not a hidden fix; explicit lifetime/UAF fix]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `sound/soc/codecs/sma1303.c` (+2 / -0)
- Function: `sma1303_i2c_remove()`
- Scope: single-file, two-line surgical fix

Record: [sma1303.c +2] [sma1303_i2c_remove] [single-file surgical]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (verified from `git show
02b2a3058912d^:sound/soc/codecs/sma1303.c`):
```c
cancel_delayed_work_sync(&sma1303->check_fault_work);
```
After:
```c
if (sma1303->attr_grp)
    sysfs_remove_group(sma1303->kobj, sma1303->attr_grp);
cancel_delayed_work_sync(&sma1303->check_fault_work);
```
Affected path: I2C driver unbind / module unload. The NULL check matches
probe, which sets `attr_grp = NULL` if `sysfs_create_group()` failed.

Record: [remove: cancel work only -> unpublish sysfs first, then cancel
work]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **memory safety / UAF + resource lifetime**, with a **race**
on re-queue.

Verified facts in this tree:
- Probe does `sysfs_create_group(sma1303->kobj, ...)` on
  `&client->dev.kobj` (not `devm_device_add_group()`).
- `check_fault_status_store()` does `dev_get_drvdata(dev)` and may
  `queue_delayed_work()`.
- `check_fault_period_{show,store}` also dereference `sma1303` with no
  extra locking.
- `sma1303` is `devm_kzalloc()`’d, so it is freed in
  `device_unbind_cleanup()` after `.remove`.
- The driver is `module_i2c_driver()` (`MODULE_LICENSE("GPL v2")`), so
  unbind on `rmmod` is a real path.
- `sysfs_remove_group()` → `kernfs_remove_by_name()` drains active sysfs
  ops, so after it returns no store can still be running. Then
  `cancel_delayed_work_sync()` waits for already-queued work. That order
  is the correct one.

Record: [UAF / dangling sysfs after unbind] [unpublish group, then
cancel work so store cannot re-queue]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct, matches the probe/create pairing, two lines, no
API/data-structure change. Regression risk is very low:
`sysfs_remove_group()` on a group that was never created is avoided via
`attr_grp`. `kobj` is the still-live i2c device kobject during
`.remove`.

Record: [minimal, correct] [very low regression risk]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
`git blame` on probe/remove: sysfs create and the original remove body
come from `68cd394efd0fd` (“ASoC: The Iron Device SMA1303 is a boosted
Class-D audio amplifier.”, KiseokJo, 2023-01-26).
`git describe --contains 68cd394efd0fd` → `v6.3-rc1~...`
`git merge-base --is-ancestor 68cd394efd0fd HEAD` → yes.

Record: [introduced in 68cd394efd0fd / v6.3] [present for the entire
6.18 lifetime]

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. Expected. The introducing commit is the original driver
add, and it **is** an ancestor of this tree.

Record: [no Fixes tag] [buggy code is the original driver, in this tree]

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `sma1303.c` history is unrelated (probe_new conversion, DT
includes, `driver_data` init). No series (“patch X/Y”). Standalone.

Record: [no related prerequisite series] [standalone]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Pengpeng Hou is not the SMA1303 maintainer (that is Kiseok Jo). Nearby
author work is systematic driver correctness (MODULE_DEVICE_TABLE,
bounds checks, error propagation). Mark Brown applied the patch.

Record: [not the codec author; ASoC maintainer applied it]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
The fix uses existing `sysfs_remove_group()`, `attr_grp`, and `kobj` —
all present since the driver was added. Applies standalone.

Record: [no dependencies] [can apply standalone]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 02b2a3058912d` →
https://patch.msgid.link/20260615064456.28615-1-pengpeng@iscas.ac.cn
`b4 dig -a`: **v1 only**.
`b4 dig -m`: thread is the patch plus Mark Brown’s apply mail to
`for-7.3` (`ce3733792d38`). No NAK, no requested changes, no reviewer
risk comments.

lore.kernel.org WebFetch returned 403; discussion was recovered from the
mbox instead.

Record: [msgid link above] [v1 only] [applied by Mark Brown, no
objections]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` original recipients: Kiseok Jo, Liam Girdwood, Mark Brown,
Jaroslav Kysela, Takashi Iwai, linux-sound, linux-kernel. ASoC/sound
maintainers were on To/Cc. Applied by Mark Brown.

Record: [ASoC maintainer To/Cc and applied]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No `Reported-by` / bugzilla / syzbot. The bug is identified from code
review of the probe/remove mismatch.

Record: [no user/syzbot report; code-analysis bug]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone 1/1. Sibling `sma1307.c` has delayed-work cancel on remove
but **no** sysfs group (different driver). `cs43130.c` already calls
`sysfs_remove_groups()` on teardown; `fs210x.c` uses
`devm_device_add_group()`.

Record: [standalone; not part of a multi-patch series]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable WebFetch 403. `git log --grep` on `sound/` found
only this commit for this subject.

Record: [no stable-list discussion recovered]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: [`sma1303_i2c_remove` only]

**Step 5.2: TRACE CALLERS**
`.remove = sma1303_i2c_remove` on `sma1303_i2c_driver`. Called by the
I2C/driver core on unbind (`rmmod`, `echo ... > unbind`, device
deletion). Not a hot path, but a standard teardown path.

Record: [I2C driver remove / module unload / device unbind]

**Step 5.3: TRACE CALLEES**
`sysfs_remove_group()` then `cancel_delayed_work_sync()`. Worker
`sma1303_check_fault_worker` does I2C/regmap reads and may re-queue
itself if `check_fault_status` is set. `check_fault_status` defaults to
`true` in probe.

Record: [sysfs_remove_group, cancel_delayed_work_sync; worker talks to
hardware]

**Step 5.4: FOLLOW THE CALL CHAIN**
Userspace can trigger the bad path by unbinding the driver (or `rmmod
snd-soc-sma1303`) and then reading/writing leftover `check_fault_status`
/ `check_fault_period` attributes, or by a store racing remove. That is
reachable without special hardware beyond having this codec bound. Work
is also queued from `sma1303_startup()` when the amp starts, so cancel-
then-requeue is not hypothetical if sysfs stays live.

Record: [reachable from unbind/sysfs] [yes, from userspace on systems
with this device]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Same file already cancels work in `sma1303_remove()` (component remove)
and `sma1303_shutdown()`, but those do not remove the I2C-device sysfs
group. Only i2c_remove can.

Record: [no second copy of this sysfs group; sibling sma1307 has no such
group]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
kernelversion` = `6.18.53`. File `sound/soc/codecs/sma1303.c` exists.
Parent of this commit has `sma1303_i2c_remove()` with only
`cancel_delayed_work_sync()`. Driver first appeared in v6.3, long before
6.18.

Record: [yes, sma1303_i2c_remove without sysfs_remove_group] [bug since
v6.3]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Parent hunk matches this tree exactly. Two insertions. Expected apply:
**clean**.

Record: [clean apply]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No earlier sma1303 sysfs-lifetime fix. This is the first teardown of
that group.

Record: [no prior equivalent fix]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`sound/soc/codecs/` — ASoC codec driver for Iron Device SMA1303
(`CONFIG_SND_SOC_SMA1303`, tristate, depends on I2C).

Record: [ASoC codec] [PERIPHERAL — specific amplifier, but a real in-
tree driver]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
`sound/soc/codecs/` is actively developed. `sma1303.c` itself has been
mostly quiet since 2023 except mechanical ASoC conversions.

Record: [codec tree active; this driver mature/stable]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Users with an SMA1303 on I2C (`compatible = "irondevice,sma1303"`). No
in-tree board DTS uses it (only the binding example); boards use out-of-
tree / product DTs. Still a supported in-tree driver.

Record: [driver-specific / config CONFIG_SND_SOC_SMA1303]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Module unload or I2C unbind with the sysfs files still present.
- Or a concurrent write to `check_fault_status` during remove, which re-
  queues work after cancel.
Not every boot. Unprivileged sysfs write depends on attribute mode
(`DEVICE_ATTR_RW` → 0644, so typically root). Unbind is admin. Still a
real oops/UAF on a supported teardown path.

Record: [unbind + leftover/racy sysfs] [uncommon but real] [not an
unprivileged remote exploit]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Use-after-free of `sma1303_priv` and/or calls into an unloaded module
via leftover sysfs attrs. That is oops / UAF, not a log-only issue.

Record: [UAF / oops on unbind] [HIGH]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: prevents UAF/oops on driver remove for this codec. Risk: two-
line, obviously correct teardown. Ratio strongly in favor of backport.

Record: [HIGH benefit for affected hardware] [VERY LOW risk]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real lifetime bug: `sysfs_create_group()` with no matching remove.
- Failure is UAF/oops (store can also re-queue delayed work after
  cancel).
- Two lines, obviously correct, applied by ASoC maintainer Mark Brown.
- Buggy code exists in this 6.18 tree (driver since v6.3).
- Clean apply; no prerequisites.
- `kernfs` drain on attribute removal makes the chosen order (sysfs
  first, then cancel work) correct.

AGAINST:
- Peripheral codec; no in-tree board DT, so user population is limited.
- No `Reported-by` / syzbot crash.
- Trigger is unbind/rmmod, not the audio hot path.

UNRESOLVED:
- lore.kernel.org HTTP 403 (thread recovered via `b4`).
- No stable@ discussion recovered.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — pairing is standard; applied
   by maintainer to for-7.3.
2. Fixes a real bug that affects users? **PASS** — leftover sysfs after
   unbind is a real UAF.
3. Important issue? **PASS** — UAF/oops (HIGH), not a feature tweak.
4. Small and contained? **PASS** — +2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code present, hunk matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Not a device-ID/quirk/DT/build/docs exception. It qualifies as a normal
small bugfix.

**Step 9.4: MAKE YOUR DECISION**
The limited hardware audience does not outweigh a two-line UAF fix that
applies cleanly to this 6.18 tree. Stable users who have this amp and
unbind or unload the module can oops; the fix is the standard teardown
the driver was missing from day one.

### What the commit solves
`sma1303_i2c_probe()` publishes `check_fault_period` /
`check_fault_status` on the I2C device. Remove only cancelled delayed
work, so those attributes stayed live, their callbacks still used
`sma1303_priv`, and `check_fault_status_store()` could queue work again
after cancel — UAF once `devm` frees the private data.

### Stable rules
Small, obviously correct, no new API, real UAF, present in this tree
since v6.3.

### Risk vs benefit
Very low risk, meaningful crash/UAF prevention on unbind.

### Concerns
None that block backport. No series dependencies. Apply is clean.

Verification:
- [Phase 1] Parsed subject/tags/body from `git log -1` on
  `02b2a3058912d`; tags are author SOB, Mark Brown SOB, msgid Link; no
  Fixes/Cc stable/Reported-by.
- [Phase 2] `git show --numstat`: +2/0 in `sma1303_i2c_remove`; parent
  file confirms cancel-only remove.
- [Phase 2] Read `sma1303_i2c_probe`/`check_fault_status_store`/`sma1303
  _check_fault_worker`; confirmed `devm_kzalloc`, `sysfs_create_group`
  on `client->dev.kobj`, default `check_fault_status = true`.
- [Phase 2] Read `fs/sysfs/group.c` `sysfs_remove_group`/`remove_files`
  and `fs/kernfs/dir.c` drain path; removal waits for active sysfs ops.
- [Phase 3] `git blame`: create/remove introduced in `68cd394efd0fd`;
  `git describe --contains` → v6.3-rc1; `merge-base --is-ancestor` yes.
- [Phase 3] `git log --oneline -- sound/soc/codecs/sma1303.c`: no
  prerequisite series.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; maintainers CC’d; Mark Brown
  applied to for-7.3; no NAK.
- [Phase 4] WebFetch lore/stable: 403; UNVERIFIED via HTTP, recovered
  via b4 mbox.
- [Phase 5] Grep: `.remove = sma1303_i2c_remove`; `module_i2c_driver`;
  work also queued from `sma1303_startup`.
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` = 6.18.53; buggy parent remove exists; no earlier
  equivalent fix.
- [Phase 7] `Kconfig` `SND_SOC_SMA1303`; DT binding
  `irondevice,sma1303.yaml`; no in-tree `.dts` users.
- [Phase 8] Failure mode UAF/oops on unbind; severity HIGH; patch size 2
  lines.
- UNVERIFIED: live user reports; stable@ mailing list (HTTP 403).

The fix is small, surgical, and meets the stable criteria for this 6.18
tree.

**YES**

 sound/soc/codecs/sma1303.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/sma1303.c b/sound/soc/codecs/sma1303.c
index 980c48cbc3482..e07ec1bbf2d50 100644
--- a/sound/soc/codecs/sma1303.c
+++ b/sound/soc/codecs/sma1303.c
@@ -1787,6 +1787,8 @@ static void sma1303_i2c_remove(struct i2c_client *client)
 	struct sma1303_priv *sma1303 =
 		(struct sma1303_priv *) i2c_get_clientdata(client);
 
+	if (sma1303->attr_grp)
+		sysfs_remove_group(sma1303->kobj, sma1303->attr_grp);
 	cancel_delayed_work_sync(&sma1303->check_fault_work);
 }
 
-- 
2.53.0

