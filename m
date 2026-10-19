Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B7491B3E;
	Mon, 19 Oct 2026 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418482; cv=none; b=OpKippj34l1xzdf3lgzAWvZyZnm9gNxXnjLpDX2ya6b2v88p8Z5VQ6KgbFPIVLGQA6lljd93jX7RwAixbAEfD3lBTXy4pl4aLfkiJ6AUCj9TTi04fLubZQB53UCgtfKWUQlqlAgbrGkhU8EGB78u4RXvrK7Ag38sHaIRj9/Bw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418482; c=relaxed/simple;
	bh=K0ESntjw4fF1ap6/IRUybtmSy0xMXhhDw7+K9Go5pZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtIoKLAKmpNS5z30J60wnbpr7wvSt8IqJplp39HLPF8EKLePVrtRww4RClspSAK6BhydtB07+Rx9IVEZZjS1IO0B6bO3kO/Vho6BGGbQsSvu9G6Qu3oekiJf+gpxlcODROaCuDnaUdBAIXQ/tYcqZ8zM+N62Emqiltnog1bDLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEocxF3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEocxF3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344101F000C4;
	Mon, 19 Oct 2026 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418480;
	bh=eXlYnUsXjhe1x1N0/Cd7tqlHUxpighDJI4zOsII8EAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEocxF3ZR4j3cvFiBwY5NMpzmgJN+KMQAWJNQj2ruIpP427wz8JjqvTjUkFy5Hf7m
	 92HpxFd7J8Ky+n+7uf6vKiAR1zmgOnkXh2KYp0knkQ99xdDdj9LKhUiaiyDuPIwkmw
	 in0oCStkaQHCPmjN5g5L94WO9h5KFQa42Mjr+xLd2uSUGPbNulPHjQ7yIpphbrnfOg
	 F4Zi31DvSMiWpvu5lCQCrUQIH4J1asgS3XkI8n+VbNeFp8DolXuNgDr/DRSWkTQEjk
	 qF8W+v9/Bd7vftf25dQ9Nwz2PoEYoKGh+Bii8h3pcLZoIVG1mqvmaN8T1g51kPxfZs
	 c5R8/g+UHqRfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	bwarrum@linux.ibm.com,
	rituagar@linux.ibm.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] misc: ibmvmc: release send buffer on write errors
Date: Mon, 19 Oct 2026 09:49:29 -0400
Message-ID: <20261019135441.1420968-278-sashal@kernel.org>
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

[ Upstream commit fd62c1f591372f7dc4c5bc041569c2f0a4a86be1 ]

ibmvmc_get_valid_hmc_buffer() marks the selected send buffer busy before
ibmvmc_write() validates the backing storage or copies data from user
space. Error exits after that point leave the buffer permanently busy.

Keep the buffer pointer until ownership is handed to the hypervisor, and
mark it free again on local write failures. Also report an RDMA send
failure instead of returning a successful byte count.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624185925.2133-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4** (`7.3.0-rc4`). The ibmvmc write path
and the finite send-buffer pool have been here since the driver landed
in v4.18; this is a small leak/false-success fix on that path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[misc/ibmvmc] [release] [free the HMC send buffer when
`ibmvmc_write()` fails after taking it]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Yousef Alhouseen \<alhouseenyousef@gmail.com\>
  (author)
- **Link:** https://patch.msgid.link/20260624185925.2133-1-
  alhouseenyousef@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman \<gregkh@linuxfoundation.org\>
  (char-misc maintainer; applied)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Reviewed-by:**,
  **Acked-by:**, or **Cc: stable** (absence is expected for this review)
- Ignored: any pipeline **Signed-off-by: Sasha Levin** / **Upstream
  commit** markers (none in `git show`)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ibmvmc_get_valid_hmc_buffer()` sets `buffer->free = 0`
  before `ibmvmc_write()` checks backing storage, copies from userspace,
  or RDMA-sends. Error exits after that leave the buffer **permanently
  busy**.
- **Symptom:** writes start returning `-EBUSY` once the pool is
  exhausted; RDMA failures were also reported as a **successful byte
  count**.
- **Version info:** none in the message. Driver introduced in v4.18
  (`0eca353e7ae75`).
- **Root cause (author):** buffer taken too early; not returned on local
  failure; `ibmvmc_send_msg()` return ignored.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** Explicit resource-leak + wrong-success-return
fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/misc/ibmvmc.c` — **+8 / −2** (commit stat: 10 lines
  changed)
- **Function:** `ibmvmc_write()` only
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Verified against parent of `fd62c1f591372` and current `ibmvmc_write()`:

- **Before:** `vmc_buffer` uninitialized; after
  `ibmvmc_get_valid_hmc_buffer()` the buffer is busy; `goto out` on
  missing `real_addr_local`, `copy_from_user` failure, zero-length write
  (`p == buffer`), or ignored `ibmvmc_send_msg()` failure never sets
  `free = 1`. Success path always returned `p - buffer` even if RDMA
  failed.
- **After:** `vmc_buffer = NULL` at declaration. On `ibmvmc_send_msg()`
  failure, `ret = -EIO` and `goto out`. On send success, `vmc_buffer =
  NULL` so the buffer stays with the hypervisor. `out:` sets
  `vmc_buffer->free = 1` if the pointer is still held.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category (a) + (g):** error-path resource leak of a finite buffer
  pool; ignored RDMA error treated as success.
- **Mechanism:** `ibmvmc_get_valid_hmc_buffer()` does `buffer[i].free =
  0` (lines 336–339). Default pool is **32** (`DEFAULT_BUF_POOL_SIZE`),
  range 16–64. Each leaked buffer is gone until the HMC session is
  reset. Zero-length `write()` takes a buffer, skips the copy loop, hits
  `if (p == buffer) goto out`, and leaks one slot. Bad user pointers
  (`-EFAULT`) and `h_copy_rdma()` failures do the same. The send-failure
  path previously returned a **positive byte count**.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** obviously correct. NULL init is required so early `goto
  out` (before a buffer is taken) does not free garbage. Clearing the
  pointer only after successful `ibmvmc_send_msg()` matches
  `ibmvmc_send_msg()` transferring ownership (`buffer->owner =
  VMC_BUF_OWNER_HV`) only after RDMA succeeds. Assignment of `free = 1`
  is done under the already-held `hmc->lock` (does not call
  `ibmvmc_free_hmc_buffer()`, which would deadlock).
- **Regression risk:** low. Does not change locking, APIs, or data
  structures. Worst case is incorrectly marking a buffer free after HV
  already owns it; that is avoided by NULLing the pointer on success.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy `ibmvmc_write` / `ibmvmc_get_valid_hmc_buffer` /
`ibmvmc_send_msg` introduced by **`0eca353e7ae75`** (“misc: IBM Virtual
Management Channel Driver (VMC)”, Bryant G. Ly, 2018-04-25). **`git
describe --contains`:** `v4.18-rc1~135^2~18`. Present for the life of
the driver.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Introducer identified by blame:
`0eca353e7ae75`. **`git merge-base --is-ancestor 0eca353e7ae75 HEAD`:**
yes. No intermediate write-path buffer-release fix in `git log --
drivers/misc/ibmvmc.c`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent ibmvmc commits are independent (inbound length check
`18189e5d84aa0`, named `vio_device_id` initializers). Not a numbered
series. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yousef Alhouseen is not the listed maintainer (Brad Warrum /
Ritu Agarwal). Same author has a sibling ibmvmc receive-path bounds fix.
Not a prerequisite.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. The hunk only uses `ibmvmc_send_msg()`,
`vmc_buffer->free`, and the existing `out:` unlock. **Applies
standalone.** Nearby `inode_set_mtime_to_ts()` is untouched.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **`b4 dig -c fd62c1f591372`:** https://patch.msgid.link/20260624185925
  .2133-1-alhouseenyousef@gmail.com
- **`b4 dig -a`:** **v1 only** (2026-06-24)
- **`b4 dig -m`:** thread is the patch only; **no replies, no NAK, no
  Cc: stable suggestion**
- **WebFetch lore.kernel.org:** **403** — discussion recovered via b4
  mbox instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (**`b4 dig -w`**): To IBM maintainers Brad Warrum, Ritu Agarwal;
Cc Arnd Bergmann, Greg Kroah-Hartman, linux-kernel. **No public
Reviewed-by/Acked-by.** Greg applied it (char-misc).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by / bugzilla / syzbot. Bug is from code inspection.
**UNVERIFIED:** number of production hits.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not `n/m`. Sibling `18189e5d84aa0`
(oversized inbound CRQ) is a different bug.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch **403**. **UNVERIFIED** whether
stable@ discussed this. No Cc: stable on the patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: **`ibmvmc_write()`** (modified). Helpers involved, not changed:
**`ibmvmc_get_valid_hmc_buffer()`**, **`ibmvmc_send_msg()`**.

**Step 5.2: TRACE CALLERS**
Record: `ibmvmc_write` is `.write` in `ibmvmc_fops`
(`drivers/misc/ibmvmc.c` ~1394–1397). Reachable from **`write(2)`** on
the misc device `/dev/ibmvmc`. `ibmvmc_send_msg` has a **single**
caller: `ibmvmc_write`. `ibmvmc_ioctl_sethmcid()` also calls
`ibmvmc_get_valid_hmc_buffer()` (line 1250); **this patch does not fix
that path.**

**Step 5.3: TRACE CALLEES**
Record: `ibmvmc_get_valid_hmc_buffer` (marks busy), `copy_from_user`,
`ibmvmc_send_msg` → `h_copy_rdma` then `ibmvmc_send_crq`. Error paths
now return the buffer under `hmc->lock`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: userspace `write()` → VFS → `ibmvmc_write`. Triggerable from the
management partition with `/dev/ibmvmc` open (PowerVM HMC-alternative).
**Zero-length write** and **`copy_from_user` failure** do not need
hypervisor errors.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `ibmvmc_ioctl_sethmcid()` takes a buffer, then fails on
`!buffer->real_addr_local` **after dropping the lock**, without setting
`free = 1`. Same class of leak, **unfixed by this commit**. Does not
make this write-path fix incomplete for its own bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- **`git describe HEAD`:** `v7.3-rc4-27-gf0100363d8c37`
- **`make kernelversion` / Makefile:** `7.3.0-rc4`
- Driver file present; buggy pattern is the original 2018
  `ibmvmc_write()` (parent of `fd62c1f591372`). **`git merge-base --is-
  ancestor 0eca353e7ae75 HEAD`:** yes. Bug is **not** post-branch.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree. The hunk does not depend on
timestamp-accessor or kmalloc-obj churn. No conflicting rewrite of
`ibmvmc_write()`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier write-buffer-release fix. `97b715b62e5b4` is
GFP_ATOMIC under spinlock in DMA alloc, unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **`drivers/misc` IBM VMC** (`CONFIG_IBMVMC`, `depends on
PPC_PSERIES`). **PERIPHERAL** for the kernel as a whole; **IMPORTANT**
for PowerVM management partitions (HMC alternative via `/dev/ibmvmc`).
MAINTAINERS: “IBM Power Virtual Management Channel Driver”, Supported.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature/low-churn since 2018; a handful of mechanical and two
2026 correctness fixes. Long-lived bug, not a new-subsystem issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific / platform-specific:**
`CONFIG_IBMVMC` on pseries PowerVM management partitions.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- **Common/easy:** `write(fd, buf, 0)` after the session is ready —
  takes a buffer, skips the copy loop, leaks it. Also `-EFAULT` from a
  bad user pointer.
- **Less common:** missing `real_addr_local`; `h_copy_rdma()` failure.
- Privileged vs unprivileged: miscdevice has **no `.mode`**; typical
  `/dev/ibmvmc` policy is management-partition specific (**UNVERIFIED**
  whether world-writable on shipped distros). Any opener of the device
  can trigger it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Exhausting **32** (default) send buffers → all further writes
  **`-EBUSY`** until session reset: management channel **DoS / hang**.
- Ignored RDMA error → userspace sees a **successful write** for a
  message that was **not** sent: **lost management traffic**.
- **Severity: HIGH** for this driver (not a kernel oops; operational
  failure of the VMC).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: high** for ibmvmc users (prevents permanent send-pool
exhaustion and false success). **Risk: very low** (8 lines, error path,
no API/lock/order change). **Ratio: strongly favors backport.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real finite-pool leak since v4.18, user-triggerable from `write(2)`
  (including count 0).
- False success on RDMA send failure.
- 8-line, obviously correct fix; NULL-init + free-on-error + check send
  return.
- Driver and buggy code exist in this 7.3-rc4 tree; no missing
  prerequisites.
- Merged by Greg KH; IBM maintainers were CC’d.

**AGAINST:**
- Peripheral (`PPC_PSERIES` / PowerVM only), not a universal crash.
- No Fixes/Reported-by/Tested-by; no mailing-list review comments (v1
  applied as-is).
- Does not fix the similar ioctl `sethmcid` leak.

**UNRESOLVED:**
- lore.kernel.org HTTP 403; stable@ discussion not fetched (b4 mbox used
  instead).
- Production hit count unknown.
- `/dev/ibmvmc` default permissions on distros unknown.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches ownership
   rules; merged to char-misc. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — leaked send buffers
   and false-success writes on `/dev/ibmvmc`.
3. Important issue? **PASS** — pool exhaustion disables the management
   channel; silent dropped messages. HIGH for this driver.
4. Small and contained? **PASS** — +8/−2, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same `ibmvmc_write()`
   structure; clean apply.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **None** (not a device-ID/quirk/DT/build/docs exception).
Qualifies as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree has had the 2018 ibmvmc write path for its entire life. The
patch returns a send buffer that was marked busy and then abandoned, and
it stops treating RDMA failure as a successful write. That is a real,
user-visible failure of the PowerVM management channel, with a tiny
contained fix and no dependencies.

**What problem it solves for this tree:** after
`ibmvmc_get_valid_hmc_buffer()` marks a slot busy, `ibmvmc_write()`
could `goto out` without `free = 1` (zero-length write, `-EFAULT`,
missing backing store, or `h_copy_rdma` failure). Default **32** slots
then stay busy and later writes get `-EBUSY`. Failed RDMA also used to
return a positive count.

**Risk vs benefit:** very low risk vs high benefit for ibmvmc users on
this tree.

Verification:
- [Phase 1] `git show fd62c1f591372 --format=fuller`: subject/body/tags
  as recorded; no Fixes/Reported-by
- [Phase 2] Parent `ibmvmc_write` via `git show
  fd62c1f591372^:drivers/misc/ibmvmc.c`: no free-on-error;
  `ibmvmc_send_msg()` return ignored
- [Phase 2] Current `ibmvmc_write` (lines 1039–1144): NULL init, send
  check, `free = 1` on `out`
- [Phase 2] `ibmvmc_get_valid_hmc_buffer` sets `free = 0`;
  `ibmvmc_send_msg` returns on `h_copy_rdma` failure before `owner = HV`
- [Phase 2] `drivers/misc/ibmvmc.h`: `DEFAULT_BUF_POOL_SIZE 32`, min 16,
  max 64
- [Phase 3] `git blame` on write/get/send: `0eca353e7ae75`; `git
  describe --contains 0eca353e7ae75` → v4.18-rc1
- [Phase 3] `git merge-base --is-ancestor 0eca353e7ae75 HEAD` and
  `fd62c1f591372 HEAD`: both true
- [Phase 3] `git log --oneline -- drivers/misc/ibmvmc.c`: no
  prerequisite series
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 lore URL; CC IBM maintainers +
  Greg/Arnd; mbox is patch-only
- [Phase 4] WebFetch lore/stable: 403; treated as UNVERIFIED for public
  review/stable@
- [Phase 5] grep: `ibmvmc_write` only from `ibmvmc_fops.write`;
  `ibmvmc_send_msg` only from `ibmvmc_write`
- [Phase 5] `ibmvmc_ioctl_sethmcid` still has a related leak (not a
  reason to drop this write fix)
- [Phase 6] `git describe HEAD` / Makefile: v7.3-rc4 / 7.3.0-rc4; driver
  present
- [Phase 7] Kconfig `IBMVMC` depends on `PPC_PSERIES`; MAINTAINERS
  Supported
- [Phase 8] Failure mode verified from code: pool exhaustion → `-EBUSY`;
  ignored send rc → false success
- UNVERIFIED: stable@ archives; field reports; `/dev/ibmvmc` distro
  permissions

**YES**

 drivers/misc/ibmvmc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index e5f935b5249d5..af84e94ec5f0e 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1040,7 +1040,7 @@ static ssize_t ibmvmc_write(struct file *file, const char *buffer,
 			    size_t count, loff_t *ppos)
 {
 	struct inode *inode;
-	struct ibmvmc_buffer *vmc_buffer;
+	struct ibmvmc_buffer *vmc_buffer = NULL;
 	struct ibmvmc_file_session *session;
 	struct crq_server_adapter *adapter;
 	struct ibmvmc_hmc *hmc;
@@ -1130,9 +1130,15 @@ static ssize_t ibmvmc_write(struct file *file, const char *buffer,
 	dev_dbg(adapter->dev, "write: file = 0x%lx, count = 0x%lx\n",
 		(unsigned long)file, (unsigned long)count);
 
-	ibmvmc_send_msg(adapter, vmc_buffer, hmc, count);
+	if (ibmvmc_send_msg(adapter, vmc_buffer, hmc, count)) {
+		ret = -EIO;
+		goto out;
+	}
+	vmc_buffer = NULL;
 	ret = p - buffer;
  out:
+	if (vmc_buffer)
+		vmc_buffer->free = 1;
 	spin_unlock_irqrestore(&hmc->lock, flags);
 	return (ssize_t)(ret);
 }
-- 
2.53.0

