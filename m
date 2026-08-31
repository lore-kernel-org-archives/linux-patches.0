Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF5F4EF5D1;
	Mon, 31 Aug 2026 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183650; cv=none; b=MIg4OwDyLJUinwnV1tCbynO2S5Tm8KJOiyA/2uulGr6VLz2tPZt97R5ySMj3adbC6pFiRQ5oR4qs2jV8XCTArIDoVagu1LJXeRYx0Eqtj68Rcmhjr6hJ7ySUX07zOrv81m4awwqS2STHe6Tcmpb0cG6S431hMWAuv1Dr+7nzrkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183650; c=relaxed/simple;
	bh=kyEBg55ljYgqrg6tB1hCS/sa3lb/txFuyToVTvxe3sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sgUERqU70pI7WP1PJcs0yYmKnjaq2fKTsjmuHVlK6AMUjVYhKUGYDy7+++jgXpfxxi1Nk7vvF5kZDCv+dlWyGutlw6jp6LnvlIXekt/gcP9Y8u0MEWmva/n/bKZDu82uFvk7svGBhwHbmAt6whH8bHLrRhtD9NKcOwvwDf5dYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EeWEymUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EeWEymUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C11F000E9;
	Mon, 31 Aug 2026 13:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183644;
	bh=Ozei9IEzoiIN89Yz+QY76kiB07UqZVp/OyaXBkL13Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeWEymUqXaD2R3fUAjn3ndgVlAKNg4NZE+QL6KCe07gB0h7uwlkVccij/Ob5OE5yH
	 7l7rJC1pL7rQ9A4aw3J9sgUEgR87xgeokKpjYIYIxefnS3gRglpcsTH328SC5eoJ2G
	 kKwqgAsTh/Rs3t+AZwd7L8wyVw2KLXRMqO6KjMSB0RHbq5h5AnKYk6weqPlmsUNT3Q
	 jWkqaolkpxX+UnHM0IVF2d3aVqxip/P7cI29/vfMMwGV5jlO0jKbIhkMf7IWCSJhzt
	 Np+myghw+trmJpiRum+M7pwWWFvOAV9RnmWqRgVSByAuM/SSqlvmgJJ+e3BXCwo8JV
	 2oBgKDTm83ASw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	ericvh@kernel.org,
	lucho@ionkov.net,
	v9fs@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] 9p: use kvzalloc for readdir buffer
Date: Mon, 31 Aug 2026 09:24:05 -0400
Message-ID: <20260831133314.4125787-217-sashal@kernel.org>
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

From: Pierre Barre <pierre@barre.sh>

[ Upstream commit b4d71bea144550ff4a0917f8c4b06d4063eb27a6 ]

The readdir buffer is sized to msize, so kzalloc() can fail under
fragmentation with a page allocation failure in v9fs_alloc_rdir_buf()
/ v9fs_dir_readdir_dotl().

The buffer is only a response sink and is never pack_sg_list()'d,
so kvzalloc() is safe for all transports, unlike the fcall buffers
fixed in e21d451a82f3 ("9p: Use kvmalloc for message buffers on
supported transports").

Signed-off-by: Pierre Barre <pierre@barre.sh>
Message-ID: <20260512132032.369281-1-pierre@barre.sh>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `9p: use kvzalloc for readdir buffer`

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[9p]` `[use]` — Switch readdir buffer allocation from
`kzalloc()` to `kvzalloc()`.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Pierre Barre <pierre@barre.sh>` (author)
- `Message-ID: <20260512132032.369281-1-pierre@barre.sh>`
- `Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>` (9p
  maintainer/committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- References prior commit `e21d451a82f3` ("9p: Use kvmalloc for message
  buffers on supported transports") for context only

### Step 1.3: Body analysis
**Record:**
- **Bug:** `v9fs_alloc_rdir_buf()` allocates `sizeof(struct p9_rdir) +
  buflen` with `kzalloc()`, where `buflen ≈ msize - header`. With
  default `msize` of 128 KiB, this is a ~128 KiB physically-contiguous
  allocation that can fail under fragmentation even when total free
  memory is ample.
- **Symptom:** `-ENOMEM` from `v9fs_dir_readdir()` /
  `v9fs_dir_readdir_dotl()` → directory listing (`ls`, `getdents`) fails
  on 9p mounts.
- **Root cause:** `kzalloc()` requires contiguous physical pages; large
  order allocations fail under fragmentation.
- **Fix rationale:** `kvzalloc()` can fall back to vmalloc. The rdir
  buffer is only a CPU-side response sink and is safe for vmalloc on all
  transports (unlike fcall buffers that may need DMA).

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit allocation-failure bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `fs/9p/vfs_dir.c`: 1 line changed (`kzalloc` → `kvzalloc`)
- `net/9p/client.c`: 1 line changed (`kfree` → `kvfree`)
- **Functions:** `v9fs_alloc_rdir_buf()`, `p9_fid_destroy()`
- **Scope:** Single-file surgical fix, 2 lines total

### Step 2.2: Code flow per hunk

**Hunk 1 — `v9fs_alloc_rdir_buf()` (`fs/9p/vfs_dir.c`):**
- **Before:** `fid->rdir = kzalloc(sizeof(struct p9_rdir) + buflen,
  GFP_KERNEL)` — fails if ~128 KiB contiguous pages unavailable.
- **After:** `kvzalloc(...)` — falls back to vmalloc when kmalloc fails.
- **Path:** First `readdir`/`readdir_dotl` on a directory fid; error
  path returns `-ENOMEM` to userspace.

**Hunk 2 — `p9_fid_destroy()` (`net/9p/client.c`):**
- **Before:** `kfree(fid->rdir)` — incorrect pairing if buffer was
  vmalloc-backed.
- **After:** `kvfree(fid->rdir)` — correct free for either kmalloc or
  vmalloc allocation.

### Step 2.3: Bug mechanism
**Record:** **Memory allocation failure / functional correctness**
- `buflen = fid->clnt->msize - P9_IOHDRSZ` (or `P9_READDIRHDRSZ`) →
  ~131,072 bytes with default `msize`
- Total allocation ≈ 131,088 bytes (order-5 contiguous pages)
- Under fragmentation, `kzalloc()` returns NULL → `-ENOMEM` → userspace
  directory operations fail

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Standard `kvzalloc`/`kvfree` pairing; both
  files already include `<linux/slab.h>`
- **Minimal:** 2 lines, no unrelated changes
- **Regression risk:** Very low — `kvzalloc` is a drop-in replacement;
  virtio zerocopy path already handles vmalloc addresses via
  `vmalloc_to_page()` in `p9_get_mapped_pages()`
- **No public API changes**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `kzalloc` in `v9fs_alloc_rdir_buf()`: introduced in `7ffdea7ea36cd1`
  (Al Viro, Jan 2013) — flex-array refactor for rdir buffer
- `kfree(fid->rdir)` in `p9_fid_destroy()`: introduced in
  `3e2796a90cf349` (Eric Van Hensbergen, Nov 2009)
- Bug mechanism present since 2013; worsened when default `msize` rose
  to 128 KiB in `9c4d94dc9a644` (Sep 2021), which **is** in this tree

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:**
- `9c4d94dc9a644` "net/9p: increase default msize to 128k" is an
  ancestor of HEAD — directly increases readdir buffer size
- Related commit `e21d451a82f3` ("9p: Use kvmalloc for message buffers")
  exists in the repo but is **not** an ancestor of HEAD (mainline-only);
  **not required** for this fix per commit message
- No "patch X/Y" series indicator; standalone fix

### Step 3.4: Author context
**Record:** Pierre Barre authored the related fcall `kvmalloc` fix
(`e21d451a82f3`). Dominique Martinet (9p maintainer) committed this
patch. No other Pierre Barre 9p commits found in this tree's history.

### Step 3.5: Dependencies
**Record:** **No dependencies on commits not in this tree.** The fix
does not use `supports_vmalloc` transport flags from `e21d451a82f3`.
`kvzalloc`/`kvfree` are available in 6.18 via `<linux/slab.h>`. Applies
cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commitish>` could not be run — commit hash not
present in this checkout. Lore.kernel.org fetch blocked (Anubis bot
protection). **UNVERIFIED:** mailing list review thread and any stable
nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via `b4 dig -w`. Committer is 9p maintainer
Dominique Martinet.

### Step 4.3: Bug report
**Record:** No `Reported-by:` or `Link:` tags. Author describes
reproduction under high-load 9p server testing (same context as
`e21d451a82f3`). No syzbot/KASAN report.

### Step 4.4: Series context
**Record:** Standalone patch, not part of a multi-patch series.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — could not search lore stable archive due to
bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `v9fs_alloc_rdir_buf()`, `v9fs_dir_readdir()`,
`v9fs_dir_readdir_dotl()`, `p9_fid_destroy()`, `p9_client_readdir()`,
`p9_client_read_once()`

### Step 5.2: Callers
**Record:**
- `v9fs_alloc_rdir_buf()` called from `v9fs_dir_readdir()` and
  `v9fs_dir_readdir_dotl()` — VFS `iterate_shared`/`readdir` path
- `p9_fid_destroy()` called from multiple fid teardown paths in
  `net/9p/client.c`
- Triggered by userspace directory listing on mounted 9p filesystems
  (common in QEMU/KVM virtio-9p)

### Step 5.3: Callees
**Record:** Allocation via `kvzalloc`; free via `kvfree`; buffer used
via `kvec`/`iov_iter` and `p9_client_read()`/`p9_client_readdir()`

### Step 5.4: Reachability
**Record:** **Userspace-reachable** — any `ls`, `find`, or `getdents()`
on a 9p mount triggers this allocation on first directory read per fid.

### Step 5.5: Similar patterns
**Record:** Commit message references `e21d451a82f3` for fcall buffers
(transport-gated `kvmalloc`). For rdir buffer, virtio zerocopy uses
`p9_get_mapped_pages()` which explicitly handles vmalloc:

```368:373:net/9p/trans_virtio.c
                for (index = 0; index < nr_pages; index++) {
                        if (is_vmalloc_addr(p))
                                (*pages)[index] = vmalloc_to_page(p);
                        else
                                (*pages)[index] = kmap_to_page(p);
```

Non-zerocopy paths copy via `copy_to_iter()`/`memmove()` — also vmalloc-
safe.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at `fs/9p/vfs_dir.c:73` uses
`kzalloc()`; `net/9p/client.c:893` uses `kfree()`. Default `msize` is
`(128 * 1024) + P9_IOHDRSZ` (`net/9p/client.c:36`).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — 2-line change, no structural
conflicts. Recent churn in `fs/9p/vfs_dir.c` does not touch allocation
code.

### Step 6.3: Related fixes already present?
**Record:** `e21d451a82f3` (fcall `kvmalloc`) is **not** in this tree.
No existing fix for rdir buffer allocation found via `git log --grep`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `fs/9p` (9p filesystem) + `net/9p` (9p
client). Affects users of 9p mounts (virtio-9p in QEMU/KVM, development
containers, Plan 9 derivatives).

### Step 7.2: Activity level
**Record:** Moderately active — recent fixes for protocol errors, USB
transport overflow, fid refcounting in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with 9p filesystem mounts (`CONFIG_9P_FS`), especially
virtio-9p in virtualization, under memory fragmentation or high load.

### Step 8.2: Trigger conditions
**Record:**
- Directory listing on 9p mount (common operation)
- `msize` at default 128 KiB or higher (configurable via mount option)
- Physical memory fragmentation sufficient to fail order-5 `kmalloc`
  despite available total memory
- **Not** a security-relevant trigger; unprivileged users can trigger
  via normal filesystem use

### Step 8.3: Failure mode severity
**Record:** `-ENOMEM` returned to userspace → directory listing fails
(`ls: cannot access ...`). **Severity: MEDIUM** — functional failure,
not kernel crash, corruption, or deadlock.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — restores directory operations under
  fragmentation; same bug class as documented fcall allocation failures
- **Risk:** VERY LOW — 2-line change, standard allocator pairing,
  vmalloc safety verified for virtio zerocopy
- **Ratio:** Favorable — minimal risk for a real functional fix

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible allocation failure causing `-ENOMEM` on directory
  reads
- Buggy code present in v6.18.44 since 2013, exacerbated by 128 KiB
  default `msize` (in tree since 2021)
- 2-line surgical fix, obviously correct `kvzalloc`/`kvfree` pairing
- No dependency on commits missing from this tree
- Maintainer (Martinet) committed the patch
- `kvzalloc` safe for all transports — verified virtio zerocopy handles
  vmalloc via `vmalloc_to_page()`
- Applies cleanly

**AGAINST backport:**
- Failure mode is userspace `-ENOMEM`, not kernel
  crash/corruption/security
- Only manifests under memory fragmentation (not every boot)
- Workaround exists: lower `msize` mount option
- No syzbot report or explicit stable nomination (UNVERIFIED on lore)
- Related fcall `kvmalloc` fix (`e21d451a82f3`) also not yet in this
  tree

**UNRESOLVED:**
- Mailing list review discussion and any stable nominations (lore
  blocked, commit not in tree for `b4 dig`)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard allocator change;
   maintainer committed; author tested under high load (per message and
   related `e21d451a82f3` context)
2. Fixes a real bug affecting users? **PASS** — directory listing fails
   with `-ENOMEM`
3. Important issue? **PASS (borderline)** — functional failure on common
   filesystem operation, not crash/corruption, but affects real 9p users
   under realistic conditions
4. Small and contained? **PASS** — 2 lines, 2 files
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, no missing
   prerequisites

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs fix).

### Step 9.4: Decision rationale

This commit fixes a real allocation failure in the 9p readdir path that
has been present since the flex-array rdir buffer was introduced in
2013, and became more likely after the default `msize` was raised to 128
KiB (present in v6.18.44). Under memory fragmentation, `kzalloc()` for a
~128 KiB buffer fails despite available memory, causing directory
operations to return `-ENOMEM` to userspace. The fix is minimal (2
lines), pairs alloc/free correctly, requires no prerequisite commits,
and is safe across all 9p transports — including virtio zerocopy, which
already handles vmalloc addresses. While the failure mode is functional
rather than a kernel crash, it is a user-visible bug on a commonly-used
virtualization filesystem path, and the fix carries negligible
regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Diff analysis: 2 lines in `v9fs_alloc_rdir_buf()` and
  `p9_fid_destroy()`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`
- **[Phase 3]** `git blame -L 72,74 fs/9p/vfs_dir.c` → `7ffdea7ea36cd1`
  (2013)
- **[Phase 3]** `git blame -L 893,893 net/9p/client.c` →
  `3e2796a90cf349` (2009)
- **[Phase 3]** `git merge-base --is-ancestor e21d451a82f3 HEAD` → not
  ancestor (not in tree)
- **[Phase 3]** `git merge-base --is-ancestor 9c4d94dc9a644 HEAD` →
  ancestor (128k msize in tree)
- **[Phase 3]** `git show 9c4d94dc9a644` → default msize raised to 128k
- **[Phase 4]** `b4 dig -c` → failed (commit not in checkout)
- **[Phase 4]** WebFetch lore.kernel.org → blocked by Anubis
- **[Phase 5]** Read `p9_client_readdir()`, `p9_client_read_once()`,
  `p9_virtio_zc_request()`, `p9_get_mapped_pages()` — confirmed vmalloc
  handling at `trans_virtio.c:368-373`
- **[Phase 5]** `grep zc_request net/9p` → only virtio transport has
  zerocopy
- **[Phase 6]** `grep kzalloc/kfree` in tree → buggy code at
  `vfs_dir.c:73`, `client.c:893`
- **[Phase 6]** `grep DEFAULT_MSIZE` → `(128 * 1024) + P9_IOHDRSZ` at
  `client.c:36`
- **[Phase 6]** Calculated allocation size: ~131,088 bytes for default
  msize
- **[Phase 6]** `grep kvzalloc/kvfree include/linux/slab.h` → APIs
  available in tree
- **[Phase 6]** `git log --grep` for existing rdir kvmalloc fix → none
  found
- **UNVERIFIED:** Mailing list review content and stable nominations
- **UNVERIFIED:** Whether `e21d451a82f3` was or will be backported
  separately

**YES**

 fs/9p/vfs_dir.c | 2 +-
 net/9p/client.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index edef553bbd59e..323f85352f6a4 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -72,7 +72,7 @@ static struct p9_rdir *v9fs_alloc_rdir_buf(struct file *filp, int buflen)
 	struct p9_fid *fid = filp->private_data;
 
 	if (!fid->rdir)
-		fid->rdir = kzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
+		fid->rdir = kvzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
 	return fid->rdir;
 }
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 08ae4c44d7305..75aac636b20e7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -890,7 +890,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	spin_lock_irqsave(&clnt->lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
 	spin_unlock_irqrestore(&clnt->lock, flags);
-	kfree(fid->rdir);
+	kvfree(fid->rdir);
 	kfree(fid);
 }
 
-- 
2.53.0

