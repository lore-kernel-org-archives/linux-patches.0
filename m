Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1B58110D;
	Mon, 19 Oct 2026 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418326; cv=none; b=V2XZQj+qTqKvsVct1G9r8VLzjzlf4B5VrGrHmWtBF+xPbT3oexM2trH470DMME0tkoxL6YolEtpGxw50o0zABZtXjrexqQWy1o6DcSQaEGw5Kxy47+BjpY6bOySlXPa/oWRUd9Qw8gGToPIzPoqfrkW6RZS0b1plR30rIqoxjxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418326; c=relaxed/simple;
	bh=i0IlCIv7pyilbwZcnN+6XbhzW3Tg+4U2ngeMCrqt/ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fpd0BqpvCg0L75K+GqTmV1xFzi2AVPQnBKy8nIeRIIzHm898KvCCeh97EyiqHMccfwbxNeWU3vnNy5HaHumvQgC93D5Bo3/OZP4E48X0+xuSsTkiYjtQTT4sXDQkeyPI+JYSqzZhp+Vk0pYTBTP3i09N0HLQyHVStOvKgV3J2vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdKfBQjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdKfBQjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C81F1F000C4;
	Mon, 19 Oct 2026 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418323;
	bh=woEF3Kbtoybbab/DTXcJXzNtcHi8tW3Ti0bDiIc7/9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdKfBQjOSIZlTFB0X6CC0cqPinLpTBzMWRN0B4o5aHqeprRqrBfAhLKmZ2cipTMs0
	 myZvtd30wmFVRhs4IobZmGUMPPpRFXRxz1aGBWy5WGlkbjAOYaSe6c+2Q2Ml+M7MYd
	 U8Mi+5CxamX2SXH03Gs9CBKgzLYZU1PCJHFmY1hB/Wxxm/0ewv+FGgK7DOvnH/Zvxj
	 98VldMkavRwXkADiD/UROVsx2LJyO7D6ud0KXdpMGl5AvcdjAFmPsjrPzNKRt3SSGi
	 LnRCR0PPYc7D3Rjq5aDtuxOr96/wh3god8N9LLkDBZY2BMRWLyjAqUQmPtwMAGHQwP
	 CWAanD7Pea4Iw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: go7007: s2250: propagate control I/O failures
Date: Mon, 19 Oct 2026 09:47:37 -0400
Message-ID: <20261019135441.1420968-166-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 59dc14a6cb5ff1ae5ce2f6ebf51fe0139e1c0623 ]

The brightness and contrast paths use oldvalue after read_reg_fp()
without checking whether the read succeeded.  A failed read leaves
oldvalue uninitialized and can write arbitrary reserved register bits.

Return read and write errors from every control path so failed hardware
access cannot be reported as a successful control update.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is mainline **7.3.0-rc4**. The Sensoray 2250 control path
is present here, and the change is a small, real error-path fix: a
failed `read_reg_fp()` left `oldvalue` uninitialized and could program
reserved VPX322 bits while still reporting success to V4L2.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[media/go7007/s2250] [propagate] Return control I/O errors so
brightness/contrast do not use an uninitialized register image**

**Step 1.2: Tags**
Record:
- **Signed-off-by:** Yousef Alhouseen (author)
- **Signed-off-by:** Hans Verkuil (media/GO7007 maintainer; applied the
  patch)
- **No** Fixes, Reported-by, Tested-by, Reviewed-by, Acked-by, Link, or
  Cc: stable (absence of Fixes/Cc stable is expected for this review)
- Not a syzbot report; not a kernel test robot report

**Step 1.3: Body**
Record:
- **Bug:** brightness/contrast call `read_reg_fp()` then use `oldvalue`
  without checking the read.
- **Symptom:** a failed read leaves `oldvalue` uninitialized; the
  following write can poke **arbitrary reserved register bits**. Failed
  I/O is still reported as a successful control update.
- **Version info:** none in the message. Commit `59dc14a6cb5ff` was
  applied 2026-07-27 and is an ancestor of `v7.3-rc1` (this checkout is
  `v7.3-rc4-27-gf0100363d8c37`). It is **not** an ancestor of `v7.2`.
- **Root cause (author):** missing error checks on FP register
  read/write in `s2250_s_ctrl()`.

**Step 1.4: Hidden bug fix?**
Record: **Yes, and it is not hidden.** The subject uses “propagate”
rather than “fix”, but the body is an uninitialized-use / false-success
bug. Saturation/hue changes are the same class: swallow write errors and
return 0.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- **File:** `drivers/media/usb/go7007/s2250-board.c` — **+33 / −21** (54
  lines with context; under the 100-line stable cap)
- **Function:** `s2250_s_ctrl()` only
- **Scope:** single-file surgical fix

**Step 2.2: Code flow**
Record (before → after), all in `s2250_s_ctrl()`:

- **Brightness / contrast:** `read_reg_fp()` / `write_reg_fp()` results
  ignored; always `break` then `return 0` → each call’s return is
  checked; first failure is returned; last write’s status is returned.
- **Saturation / hue:** write ignored, `return 0` → `return
  write_reg_fp(...)`.
- **Normal path:** unchanged when I/O succeeds (still RMW reserved bits,
  then write `0x140`).
- **Error path:** now fails the V4L2 set instead of committing a fake
  success.

**Step 2.3: Bug mechanism**
Record: **Uninitialized data + ignored I/O errors (logic/correctness).**

Verified in this tree: `read_reg_fp()` writes `*val` only after a
successful USB vendor request:

```249:286:drivers/media/usb/go7007/s2250-board.c
static int read_reg_fp(struct i2c_client *client, u16 addr, u16 *val)
{
        // ...
        if (go == NULL)
                return -ENODEV;
        if (go->status == STATUS_SHUTDOWN)
                return -EBUSY;
        // kzalloc / mutex_lock_interruptible / usb_control_msg failures
        // all return without *val = ...
        *val = (buf[0] << 8) | buf[1];
        kfree(buf);
        return 0;
}
```

`write_reg_fp()` likewise returns 0 or a negative errno, never a
positive byte count, so `if (ret)` is equivalent to `if (ret < 0)`.

On a failed read, `oldvalue` is stack garbage. The write is `ctrl->val |
(oldvalue & ~0xff)` (brightness) or `... & ~0x3f` (contrast), so
reserved bits come from that garbage.

**Step 2.4: Fix quality**
Record: **Obviously correct and minimal.** No API/data-structure change.
Regression risk is low: VIDIOC_S_CTRL that used to return 0 on hardware
failure now returns the errno. That is the intended V4L2 behavior
(`try_or_set_cluster()` only copies new values after `s_ctrl` succeeds).
Partial updates if a later write fails were already possible; the patch
does not add locking or new control IDs.

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Unchecked `read_reg_fp()` + `oldvalue` RMW: **05d76f2da1e5cc**
  (“s2250: subdev conversion”, 2009; contained in **v2.6.33-rc1**)
- Driver itself: **b11869dbb6cc4** (v2.6.29-rc1 era staging)
- Control-framework conversion: **d3b2ccd9e307ea** (2013) kept the same
  ignore-errors pattern
- Bug is old, not recent churn

**Step 3.2: Fixes: tag**
Record: **None.** No Fixes SHA to follow. The buggy pattern is the 2009
subdev conversion, not a recent regression.

**Step 3.3: File history**
Record: Recent `s2250-board.c` work is i2c probe conversions and a probe
leak fix, not a series this patch depends on. **Standalone.** Same-day
sibling by the same author: `41f82777e5477` (“avoid undefined shifts in
MPEG-4 headers”) — different file (`go7007-driver` MPEG path), not a
prerequisite.

**Step 3.4: Author**
Record: Yousef Alhouseen is not the subsystem maintainer. Two
media/go7007 correctness patches on 2026-06-30; Hans Verkuil applied
both. Maintainer SOB is a positive quality signal.

**Step 3.5: Dependencies**
Record: **None.** Uses existing `read_reg_fp()` / `write_reg_fp()` and
`s2250_s_ctrl()`. **Applies standalone.**

## Phase 4: Mailing list / external

**Step 4.1:**
Record:
- **b4 dig -c 59dc14a6cb5ff** → https://patch.msgid.link/20260630105015.
  53932-1-alhouseenyousef@gmail.com
- **b4 dig -a:** **v1 only** (committed diff matches v1)
- **b4 dig -m:** thread is the patch mail only — **no replies, no NAK,
  no Cc: stable**
- lore.kernel.org HTTP fetches returned **403**; discussion content was
  recovered via `b4`

**Step 4.2:**
Record: **b4 dig -w** recipients: Hans Verkuil, Mauro Chehab, linux-
media, linux-kernel. Appropriate lists/maintainers. Hans’s SOB on the
git commit is the review signal.

**Step 4.3:**
Record: **No bugzilla/syzbot/user report.** Finding is from code
inspection.

**Step 4.4:**
Record: Standalone v1 patch, not part of a numbered series. Sibling
MPEG-4 shift patch is independent.

**Step 4.5:**
Record: **UNVERIFIED** whether linux-stable ever discussed this
(lore.kernel.org 403; no local hit on this file’s history besides the
mainline commit).

## Phase 5: Semantic / call graph

**Step 5.1:**
Record: Modified function: **`s2250_s_ctrl`**. Helpers used:
`read_reg_fp`, `write_reg_fp`.

**Step 5.2: Callers**
Record: Wired as `s2250_ctrl_ops.s_ctrl`. Invoked from:
- `try_or_set_cluster()` → `call_op(master, s_ctrl)` (`v4l2-ctrls-
  core.c`)
- `__v4l2_ctrl_handler_setup()` during control setup
- Userspace: `v4l2_s_ctrl()` / `VIDIOC_S_CTRL` / `VIDIOC_S_EXT_CTRLS`

**Step 5.3: Callees**
Record: USB vendor requests via `go7007_usb_vendor_request()` →
`usb_control_msg()`. Also `mutex_lock_interruptible()` (can return
**-EINTR**).

**Step 5.4: Reachability**
Record: **Yes, from userspace** if `CONFIG_VIDEO_GO7007_USB_S2250_BOARD`
is enabled and a Sensoray 2250/2251 is present. Realistic failure that
still continues into the write: **EINTR on the read’s mutex**, then a
successful write mutex — two separate `mutex_lock_interruptible()`
calls. ENOMEM on the read’s `kzalloc` with a later successful write
alloc is also possible. `STATUS_SHUTDOWN`/`go == NULL` fail both read
and write before hardware access, so those paths do not program garbage.

**Step 5.5: Similar patterns**
Record: `s2250_s_std`, `s2250_set_fmt`, and `s2250_s_video_routing`
still ignore `write_reg_fp()` results. This patch does not claim to fix
those; they have no uninitialized `oldvalue`. Not a series dependency.

semcode MCP: **not available**; used `git grep` / file reads.

## Phase 6: This checkout

**Step 6.1:**
Record:
- Tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4**
- File and `s2250_s_ctrl()` **exist**
- Buggy ignore-error RMW existed in this lineage from 2009 until
  **59dc14a6cb5ff** (merged for **v7.3-rc1**)
- Current `HEAD` source already contains the fixed function (commit is
  an ancestor of `HEAD` and of `v7.3-rc4`)
- Bug was **not** introduced after this tree; it is old. This 7.3
  snapshot already includes the fix as a mainline merge, not as a stable
  cherry-pick.

**Step 6.2:**
Record: **Clean apply** to this file’s `s2250_s_ctrl()` shape (same
switch, same register macros). No conflicting refactor in this tree.

**Step 6.3:**
Record: No alternate fix for this `oldvalue` bug. Only this commit
changes those checks.

## Phase 7: Subsystem context

**Step 7.1:**
Record: **media / USB V4L2 driver** (`drivers/media/usb/go7007/`).
**PERIPHERAL** — Sensoray 2250/2251 only
(`CONFIG_VIDEO_GO7007_USB_S2250_BOARD`). Maintainer: Hans Verkuil,
linux-media.

**Step 7.2:**
Record: File is mature/low-churn (last functional s2250 work before this
was older i2c/probe fixes). Not a newly added subsystem.

## Phase 8: Impact and risk

**Step 8.1:**
Record: **Driver-specific / config-specific**
(`VIDEO_GO7007_USB_S2250_BOARD`). Not universal. Small user population
(legacy USB MPEG capture box).

**Step 8.2:**
Record:
- Trigger: `VIDIOC_S_CTRL` for brightness/contrast (and sat/hue for the
  false-success half)
- Common on a working device: **no** (happy path already initialized
  `oldvalue`)
- Realistic error: **signal interrupting the read lock**, USB control-
  msg failure, or alloc failure
- Unprivileged user with the video node can issue the ioctl

**Step 8.3:**
Record:
- **Failure mode:** uninitialized stack bits written into VPX322
  reserved fields; V4L2 still treats the set as success and publishes
  the new control value
- **Not** an oops, deadlock, filesystem corruption, or a demonstrated
  CVE
- **Severity: MEDIUM** (hardware misprogramming + lying to userspace).
  On shutdown-only failures, writes also fail first, so those are lower
  impact.

**Step 8.4:**
Record:
- **Benefit:** medium-low globally, high for the few users of this board
  if a control set races with EINTR/USB error
- **Risk:** **very low** (33 lines, error returns only, maintainer-
  applied)
- **Ratio:** favorable for a tiny correctness fix; the weak point is
  “important issue” given niche hardware and no reports

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For backporting**
- Verified uninitialized `oldvalue` when `read_reg_fp()` fails
- Verified reserved-bit RMW from that garbage
- Verified V4L2 commits the new value if `s_ctrl` returns 0
- Realistic EINTR window (separate interruptible locks)
- Small, obviously correct, maintainer SOB
- No new API; under 100 lines
- Driver and function exist in this tree

**Against**
- Niche, aging Sensoray 2250/2251 hardware
- No user/syzbot/KMSAN report
- Not a crash, hang, or user-data corruption
- Looks like a static-analysis sweep (two go7007 patches the same day)
- Sibling functions still ignore I/O errors
- Official rule text wants a bug that “bothers people” or an “oh, that’s
  not good” issue — this is the latter, not a production fire

**Unresolved**
- Could not read lore.kernel.org in the browser (403); no on-list review
  beyond Hans applying v1
- Did not compile to confirm `-Wmaybe-uninitialized`
- No evidence of prior stable-list discussion

**Step 9.2: Stable rules checklist** (this tree)
1. Obviously correct and tested? **PASS** — mechanical error returns;
   applied by Hans Verkuil. No extra Tested-by.
2. Real bug that affects users? **PASS** — uninit RMW and false ioctl
   success on a reachable control path.
3. Important (crash/security/corruption/deadlock)? **PASS** (weak) —
   hardware register corruption and incorrect V4L2 success fall under
   “oh, that’s not good”, not oops/hang. Not a theoretical race without
   a trigger.
4. Small and contained? **PASS** — one function, +33/−21.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — same `s2250_s_ctrl()`; this
   7.3-rc4 checkout already contains the commit as of v7.3-rc1.

**Step 9.3: Exception category**
Record: **None** (not a device ID, quirk, DT, build, or docs fix).

**Step 9.4: Decision**
This tree’s go7007/s2250 code is the long-standing buggy RMW path. The
patch is a small, maintainer-applied fix for uninitialized reserved-bit
writes and false `VIDIOC_S_CTRL` success. That is a real, user-visible
device-control bug with very low regression risk. It is not a core-
kernel crisis, but it is in-scope for stable as an “oh, that’s not good”
driver correctness fix, and the code it needs is present here.

### What the commit solves for this tree
`s2250_s_ctrl()` used to ignore FP register I/O errors. On
brightness/contrast, a failed read left `oldvalue` uninitialized and the
next write could set reserved VPX322 bits while V4L2 still stored the
new control. After the fix, those errors propagate so userspace is not
told the hardware update succeeded.

### Risk vs benefit
Benefit is limited to Sensoray 2250/2251 users, but the downside of
taking the patch is negligible. Returning errno instead of 0 on failed
I/O is the correct userspace contract.

---

Verification:
- [Phase 1] Parsed commit `59dc14a6cb5ff`; tags are author + Hans
  Verkuil SOB only
- [Phase 1] Confirmed no syzbot/Fixes/Link/Reported-by
- [Phase 2] Diff is only `s2250_s_ctrl()` in `s2250-board.c` (+33/−21)
- [Phase 2] Read `read_reg_fp()`/`write_reg_fp()`: `*val` set only on
  success; writes return 0 or negative
- [Phase 3] `git blame` on pre-patch function: ignore-errors RMW from
  `05d76f2da1e5cc` (v2.6.33-rc1)
- [Phase 3] No Fixes tag; sibling `41f82777e5477` is a different go7007
  issue, not a dep
- [Phase 3] `git merge-base --is-ancestor 59dc14a6cb5ff v7.2` → not in
  7.2; ancestor of `v7.3-rc1` and of HEAD
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1, Hans+media list, no thread
  replies, no stable nomination
- [Phase 4] WebFetch/curl to lore.kernel.org → 403; UNVERIFIED public
  review beyond the mbox
- [Phase 5] `s2250_ctrl_ops.s_ctrl` → `try_or_set_cluster()` /
  `v4l2_s_ctrl()`; userspace `VIDIOC_S_CTRL`
- [Phase 5] Confirmed `try_or_set_cluster()` does not publish new values
  if `s_ctrl` returns nonzero
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current file already has the error checks; driver Kconfig
  `VIDEO_GO7007_USB_S2250_BOARD` exists
- [Phase 7] MAINTAINERS: GO7007 MPEG CODEC, Hans Verkuil
- [Phase 8] Failure mode: reserved-bit programming + false success;
  severity MEDIUM; EINTR path verified in `read_reg_fp`/`write_reg_fp`
- [Phase 9] Official `stable-kernel-rules.rst` read: ≤100 lines, real
  bug, “oh that’s not good”, no new API
- UNVERIFIED: compiler warning reproduction; stable mailing-list history

**YES**

 drivers/media/usb/go7007/s2250-board.c | 54 ++++++++++++++++----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index a155b987282f8..e536964c14e6a 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -365,36 +365,48 @@ static int s2250_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct s2250 *state = container_of(ctrl->handler, struct s2250, hdl);
 	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	u16 oldvalue;
+	int ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
-			     ctrl->val | (oldvalue & ~0xff));
-		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
-			     ctrl->val | (oldvalue & ~0xff));
-		write_reg_fp(client, 0x140, 0x60);
-		break;
+		ret = read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
+				   ctrl->val | (oldvalue & ~0xff));
+		if (ret)
+			return ret;
+		ret = read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
+				   ctrl->val | (oldvalue & ~0xff));
+		if (ret)
+			return ret;
+		return write_reg_fp(client, 0x140, 0x60);
 	case V4L2_CID_CONTRAST:
-		read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_CONTRAST0,
-			     ctrl->val | (oldvalue & ~0x3f));
-		read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
-		write_reg_fp(client, VPX322_ADDR_CONTRAST1,
-			     ctrl->val | (oldvalue & ~0x3f));
-		write_reg_fp(client, 0x140, 0x60);
-		break;
+		ret = read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_CONTRAST0,
+				   ctrl->val | (oldvalue & ~0x3f));
+		if (ret)
+			return ret;
+		ret = read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
+		if (ret)
+			return ret;
+		ret = write_reg_fp(client, VPX322_ADDR_CONTRAST1,
+				   ctrl->val | (oldvalue & ~0x3f));
+		if (ret)
+			return ret;
+		return write_reg_fp(client, 0x140, 0x60);
 	case V4L2_CID_SATURATION:
-		write_reg_fp(client, VPX322_ADDR_SAT, ctrl->val);
-		break;
+		return write_reg_fp(client, VPX322_ADDR_SAT, ctrl->val);
 	case V4L2_CID_HUE:
-		write_reg_fp(client, VPX322_ADDR_HUE, ctrl->val);
-		break;
+		return write_reg_fp(client, VPX322_ADDR_HUE, ctrl->val);
 	default:
 		return -EINVAL;
 	}
-	return 0;
 }
 
 static int s2250_set_fmt(struct v4l2_subdev *sd,
-- 
2.53.0

