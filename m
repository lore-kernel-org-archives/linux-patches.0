Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B84DF4A5;
	Mon, 31 Aug 2026 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183584; cv=none; b=eDtF0V0HswzOs4hxTTtLv1ORBVohrxhxIrubMEdRIwAsLm6M96yLu/0NIHh18+g5eina+Bhs4uxIKr+fZZHma06iLn/7pKbMx4TqbDGIYMqFgBmDtOstv1LzWh28KLsFVSjJShFhmQyB+8iQKqPAdFdDjphj7S+wmZgetmw1VLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183584; c=relaxed/simple;
	bh=NQNeAiCxThbAM87/kRb4hAAa0wmiok6S/jJut0bLhCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KiqympbwVXwONQe1/k0LzWUZd0uit/kcG+NbE85Y2YJ2aU5pxmOY8BwjvXgLRgtrA21QG1Cm89Jj9umtmmKoLfGHYn0uH8XVucDK/9CJHTsFc4Pc6peE62jboHWqeBsrqNHV/b3NSl9MUEjFKRY1gXeGUAHhIL5ZJeSObooA38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSkA1a6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSkA1a6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6DB1F00ADB;
	Mon, 31 Aug 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183582;
	bh=jR1/wuPn/1SFN5+Sk8Tes+Wj3LOxpbIQR0arzMeFJgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSkA1a6yEAhf2v0txq0yUIHWAX3NsVYW4KqZzWTY+U5OGGcTrjXpGtnu0zblrMyzU
	 NS/vUq2HgpTwI2Rf6Dh3GIs70WihhZLJbRDnyAQUhAn5XSs3nhYIYcZ5cI4Shdc3af
	 GcGN0BKVcM73QISzaT8JnKUr9b7lntloMvzI7rtwFJzrJpcakY/njynRKQMN6v7JGX
	 MjkEBTsXENPMCJjQlR2GDeopvbBnl4OHpkAfa9wYcqTHD+tYJ8V/QuuO/Sxdjaomyk
	 ypHdyU4s6lveNuE2wkQ7ZWJonFE3Biy9poZqbtw2XvcVaIgrDCBqj+ROREdYrRN4Q5
	 kR2eIj2grBHpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	neal_liu@aspeedtech.com,
	joel@jms.id.au,
	linux-aspeed@lists.ozlabs.org,
	linux-usb@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue
Date: Mon, 31 Aug 2026 09:23:29 -0400
Message-ID: <20260831133314.4125787-181-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit e2ffaac1884b921b8ec2b3a964c6a8b5d610bf4b ]

ast_udc_ep_dequeue() declares the loop cursor `req` outside the
list_for_each_entry(). After the loop it tests `&req->req != _req`
to decide whether the request was found. If the queue holds no
match, `req` is past-the-end. It then aliases
container_of(&ep->queue, struct ast_udc_request, queue) via offset
cancellation. Whether that synthetic address equals `_req` depends
on heap layout. The function can return 0 without dequeueing
anything.

Default `rc` to -EINVAL and set it to 0 only inside the match
branch. `req` is no longer read after the loop, so the past-the-end
dereference goes away. No extra cursor variable or post-loop test
is needed.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260521065428.3261238-1-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `usb: gadget: aspeed_udc: avoid past-the-end
iterator in dequeue`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)
**Fix commit on master:** `e2ffaac1884b9` (not present in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[usb: gadget: aspeed_udc]` **`avoid`** — fix incorrect
post-loop use of a `list_for_each_entry()` cursor in
`ast_udc_ep_dequeue()`.

### Step 1.2: Tags
**Record:**
- **Suggested-by:** Alan Stern `<stern@rowland.harvard.edu>` (USB
  maintainer)
- **Suggested-by:** Andrew Jeffery `<andrew@codeconstruct.com.au>`
  (Aspeed contributor)
- **Signed-off-by:** Maoyi Xie, Greg Kroah-Hartman
- **Link:** https://patch.msgid.link/20260521065428.3261238-1-
  maoyixie.tju@gmail.com
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Reviewed-by:`, or `Tested-
  by:` tags
- Notable: suggestions from core USB and Aspeed reviewers; patch went
  through v1→v3 on list

### Step 1.3: Body analysis
**Record:**
- **Bug:** After `list_for_each_entry()` finds no match, `req` is a
  past-the-end sentinel. Post-loop `&req->req != _req` uses that invalid
  cursor via `container_of()` offset arithmetic.
- **Symptom:** `ast_udc_ep_dequeue()` can return `0` (success) without
  dequeuing anything.
- **Root cause:** `rc` defaults to `0`; the post-loop pointer comparison
  is unreliable when the iterator is past-the-end.
- **Version info:** None explicit; driver has been in-tree since 5.19.

### Step 1.4: Hidden bug fix?
**Record:** Yes — clearly a logic/correctness bug in the USB gadget
dequeue API, not cosmetic cleanup. Matches the established idiom in
sibling `aspeed-vhub` and `pch_udc` drivers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/usb/gadget/udc/aspeed_udc.c` (+2 / −5 lines)
- **Function:** `ast_udc_ep_dequeue()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `rc = 0`; on match, dequeue and `break`; after loop, if
  `&req->req != _req` then `rc = -EINVAL` (reads past-the-end `req`).
- **After:** `rc = -EINVAL`; on match, dequeue, set `rc = 0`, `break`;
  no post-loop read of `req`.
- **Path affected:** Error/normal dequeue path when the requested
  `usb_request` is not on the endpoint queue.

### Step 2.3: Bug mechanism
**Record:** **Category (g) logic/correctness fix** — violates
`usb_ep_dequeue()` contract (must return negative error if request is
not active on endpoint). The post-loop test uses an invalid list
iterator, producing unreliable success/failure results.

### Step 2.4: Fix quality
**Record:** Obviously correct; matches `pch_udc_pcd_dequeue()` and
`ast_vhub_epn_dequeue()` patterns. Minimal regression risk — only
changes return value for the not-found path to the correct `-EINVAL`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy code introduced in `055276c132056` (“usb: gadget: add
Aspeed ast2600 udc driver”, May 2022, landed in 5.19). Present unchanged
in this tree at lines 697–713.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Introducing commit is
`055276c132056`, confirmed ancestor of HEAD.

### Step 3.3: Related file history
**Record:** Recent `aspeed_udc.c` changes are other small fixes
(endpoint validation, DMA, spinlock). No duplicate fix for this issue.
Standalone one-patch fix (v3 is final applied form).

### Step 3.4: Author context
**Record:** Maoyi Xie is not the driver author (Neal Liu) but submitted
a focused fix with guidance from Alan Stern and Andrew Jeffery. Greg K-H
committed to mainline.

### Step 3.5: Dependencies
**Record:** None. Self-contained; no prerequisite commits. Applies
cleanly to current `6.18.y` file.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c e2ffaac1884b9` → [PATCH v3] thread at https://pat
ch.msgid.link/20260521065428.3261238-1-maoyixie.tju@gmail.com. Series:
v2 (2026-05-19), v3 (2026-05-21, applied version). Alan Stern reviewed
v1 and suggested the correct loop/return-value idiom; Andrew Jeffery
suggested v3’s `rc = -EINVAL` default shape.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC’d Greg Kroah-Hartman, Alan Stern, Andrew
Jeffery, Neal Liu, linux-usb, linux-aspeed, linux-arm-kernel.
Appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla report. Bug identified via code review
(Alan Stern). Severity: API contract violation with potential request-
lifecycle confusion.

### Step 4.4: Series context
**Record:** Standalone fix; v3 is the committed version. No other
patches required.

### Step 4.5: Stable list history
**Record:** No `Cc: stable` nominations found in thread (`grep -i
stable` on saved mbox). Not a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ast_udc_ep_dequeue()` modified; registered in
`ast_udc_ep_ops.dequeue`.

### Step 5.2: Callers
**Record:** Called via `usb_ep_dequeue()` in
`drivers/usb/gadget/udc/core.c`, which dispatches to `ep->ops->dequeue`.
Gadget function drivers call this from disconnect/cancel paths:
`composite.c`, `f_fs.c`, `u_audio.c`, `f_mass_storage.c`, `f_ecm.c`,
`u_serial.c`, `raw_gadget.c`, etc. Callable from process or interrupt
context per `core.c` documentation.

### Step 5.3: Callees
**Record:** On successful match: `list_del_init()`, `ast_udc_done()`
(unmap + completion callback). Fix only changes behavior when no match
is found.

### Step 5.4: Reachability
**Record:** Reachable whenever a USB gadget function cancels an in-
flight request on an Aspeed UDC endpoint — common during teardown, error
recovery, or userspace interrupt (e.g. FunctionFS). Requires
`CONFIG_USB_ASPEED_UDC` on `ARCH_ASPEED` (AST260x BMC SoCs).

### Step 5.5: Similar patterns
**Record:** `aspeed-vhub` `ast_vhub_epn_dequeue()` already uses `rc =
-EINVAL` + separate iterator (`epn.c:472–488`). `pch_udc_pcd_dequeue()`
uses same pattern (`pch_udc.c:1862–1878`). `aspeed_udc` was the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current tree at
`drivers/usb/gadget/udc/aspeed_udc.c:697–713` has `int rc = 0` and post-
loop `if (&req->req != _req)`. Fix commit `e2ffaac1884b9` is **not** an
ancestor of HEAD (`merge-base` check failed).

### Step 6.2: Backport complications
**Record:** Clean apply expected — 7-line hunk, no structural conflicts.
File has had only minor unrelated changes since driver addition.

### Step 6.3: Related fixes already present?
**Record:** None found for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/usb/gadget** — IMPORTANT for Aspeed BMC/embedded
platforms using USB gadget mode; peripheral globally but significant for
OpenBMC/AST260x deployments.

### Step 7.2: Subsystem activity
**Record:** Driver actively maintained with several post-introduction
fixes in this tree (DMA, spinlock, endpoint validation). Bug predates
all of them.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of AST260x SoCs with `CONFIG_USB_ASPEED_UDC` running
USB gadget functions (mass storage, ECM, UAC, FunctionFS, etc.).

### Step 8.2: Trigger conditions
**Record:** `usb_ep_dequeue()` called with a `usb_request` not currently
queued on that endpoint — happens during disconnect, I/O cancellation,
or race between completion and cancel. Not every boot, but a normal
operational path. Unprivileged users can trigger via gadget
configfs/functionfs on systems exposing gadget to userspace.

### Step 8.3: Failure mode severity
**Record:** False success (`0` returned, nothing dequeued) → callers
assume request canceled. Example in `u_audio.c:455–463`: on success,
request is not freed but pointer is cleared; completion may still fire
later → request lifecycle confusion, potential use-after-free or double-
free depending on caller. **Severity: HIGH** (correctness bug with
memory-safety consequences possible); not a guaranteed crash on every
call.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware — restores correct
  `usb_ep_dequeue()` semantics
- **Risk:** VERY LOW — 5-line idiom change, well-reviewed, matches
  sibling drivers
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug present since driver introduction (2022)
- Buggy code confirmed in `v6.18.44`
- Can return false success on dequeue failure — API contract violation
- USB maintainers (Alan Stern) and Aspeed developers guided the fix
- Tiny, surgical, obviously correct change
- Sibling `aspeed-vhub` already uses correct pattern
- Gadget callers depend on accurate dequeue return values

**AGAINST backport:**
- Limited to `CONFIG_USB_ASPEED_UDC` platforms (not universal)
- No syzbot/CVE report; false-success case may be uncommon in practice
- No explicit stable nomination in mailing list

**Unresolved:** Exact frequency of spurious success in production
(address-coincidence scenario); not needed to justify fix given clear
API bug.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard UDC idiom; reviewed
   by Alan Stern and Andrew Jeffery; committed by Greg K-H
2. Fixes a real bug affecting users? **PASS** — incorrect dequeue return
   value on Aspeed UDC
3. Important issue? **PASS** — request lifecycle / potential UAF;
   severity HIGH for affected configs
4. Small and contained? **PASS** — 1 file, net −3 lines
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — driver and buggy code both
   present; clean apply

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard
driver bug fix).

### Step 9.4: Decision rationale
This tree (`6.18.y`) ships the Aspeed UDC driver with a dequeue bug that
has existed since the driver was added. The fix restores correct
`usb_ep_dequeue()` behavior using the same pattern as other UDC drivers
in-tree. It is small, reviewed by USB subsystem experts, and prevents
callers from mis-handling requests that were never dequeued. The
hardware scope is narrow but the fix is trivial and the failure mode is
serious enough for stable.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show e2ffaac1884b9`
- **[Phase 2]** Read diff; confirmed changes in `ast_udc_ep_dequeue()`
  at lines 691–716
- **[Phase 3]** `git blame`: buggy code from `055276c132056` (May 2022,
  5.19)
- **[Phase 3]** `git merge-base --is-ancestor 055276c132056 HEAD`:
  driver present in tree
- **[Phase 3]** `git merge-base --is-ancestor e2ffaac1884b9 HEAD`: fix
  **not** in tree (exit 1)
- **[Phase 3]** `git log --oneline -20 --
  drivers/usb/gadget/udc/aspeed_udc.c`: no duplicate fix
- **[Phase 4]** `b4 dig -c e2ffaac1884b9`: found v3 thread URL
- **[Phase 4]** `b4 dig -a`: v2 and v3 revisions listed
- **[Phase 4]** `b4 dig -w`: Greg K-H, Alan Stern, Andrew Jeffery CC'd
- **[Phase 4]** Saved mbox; read Alan Stern review suggesting correct
  idiom
- **[Phase 4]** `grep -i stable` on mbox: no stable nomination
- **[Phase 5]** `grep usb_ep_dequeue`: multiple gadget function driver
  call sites
- **[Phase 5]** Read `core.c:331–338`: dispatch wrapper
- **[Phase 5]** Read `aspeed-vhub/epn.c:472–488`: correct sibling
  pattern
- **[Phase 5]** Read `pch_udc.c:1862–1878`: correct peer pattern
- **[Phase 5]** Read `u_audio.c:455–463`: caller behavior on dequeue
  return value
- **[Phase 6]** `git describe HEAD`: `v6.18.44`
- **[Phase 6]** `make -s kernelversion`: `6.18.44`
- **[Phase 6]** Confirmed buggy code at `aspeed_udc.c:697–713` in
  working tree
- **[Phase 6]** `git log master --oneline --grep past-the-end`: fix
  exists on master only
- **[Phase 7]** Read `Kconfig:407–418`: `CONFIG_USB_ASPEED_UDC` depends
  on `ARCH_ASPEED`

**YES**The commit should be backported to this tree (`v6.18.44` /
`stable/linux-6.18.y`).

`ast_udc_ep_dequeue()` in `aspeed_udc.c` can return success without
actually dequeuing a request when the target isn’t on the endpoint
queue, because it reads a past-the-end `list_for_each_entry()` cursor
after the loop. The fix is small (default `rc` to `-EINVAL`, set `0`
only on match) and matches the pattern already used in `aspeed-vhub` and
`pch_udc`.

The buggy code is present here; the fix (`e2ffaac1884b9`) is on master
but not in this stable branch. It affects AST260x BMC systems using
`CONFIG_USB_ASPEED_UDC` and can confuse gadget callers that rely on
`usb_ep_dequeue()` return values during cancel/teardown.

**YES**

 drivers/usb/gadget/udc/aspeed_udc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index 353bfb1ff0a12..0b994afab0478 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -694,7 +694,7 @@ static int ast_udc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 	struct ast_udc_dev *udc = ep->udc;
 	struct ast_udc_request *req;
 	unsigned long flags;
-	int rc = 0;
+	int rc = -EINVAL;
 
 	spin_lock_irqsave(&udc->lock, flags);
 
@@ -704,14 +704,11 @@ static int ast_udc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			list_del_init(&req->queue);
 			ast_udc_done(ep, req, -ESHUTDOWN);
 			_req->status = -ECONNRESET;
+			rc = 0;
 			break;
 		}
 	}
 
-	/* dequeue request not found */
-	if (&req->req != _req)
-		rc = -EINVAL;
-
 	spin_unlock_irqrestore(&udc->lock, flags);
 
 	return rc;
-- 
2.53.0

