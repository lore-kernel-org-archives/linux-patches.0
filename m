Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB83DFC90;
	Mon, 20 Apr 2026 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691467; cv=none; b=G+ZawHwHH+MF4uiJdmRTN3G+YCo5yUluqEaqLtcCB7Ozmx2UPy7C2zSy4+NxHtdRgPFl3kiLEHiNW+pU/FkYnSahMuUQEPR8Zki9mg5cGqlBYNEJqWtsB61FJe6Rfbu+FmCVQ8RMpcGed/g7E4ACoktgAWhXmei7hjS45nrbr3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691467; c=relaxed/simple;
	bh=IgJq5V+26na4YOff+t5F2K2k2dIbRenoNEI6CsdwQDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbGu4vp1ZzPOuR4CdUi1Ye38f9NnAeaf3LWOauMakFc70rS2yjHsWF2HdclmIknetZjYWK/LeQtuAZ3CH/hcUmucv+J6TiB/EWdfPiW0as46Tr/6lS3iMgp7bcTaHUqzby/oRdGgdwx5cVby7TjGwGD5b8Bhsfg2iXVVwg3PTkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArZxFb7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArZxFb7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C242C2BCB4;
	Mon, 20 Apr 2026 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691467;
	bh=IgJq5V+26na4YOff+t5F2K2k2dIbRenoNEI6CsdwQDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArZxFb7yELXdlHK7VlJH6374RAr4zEGMun3wmK0dk1mkIF+/mJIevA4nlx6uYwAaa
	 smY5tmIv792ABvhefE3lTBS7Gz0oOn2pjtS4e41UEYiaUrjoEqHbaxUlssYpd1ttut
	 JQVdEVoi3MfrzOdWnKV8nOPnL2+IYzjsR9BnOzfell/FOeEFgnqXDml9NVaxVQrbu7
	 zjC02K+mr/fDCc/9Qh5vmzyassi9x3RpBSqcZV2+uJp9PYHxjQDF0PZuDnoAYIlszY
	 e+x1+VVYbzvI5ycV9+Zbj0F4aGLiDkcpZPAYa5gElpr/8Jr4Igj26f1w4jW6+Lzx7S
	 hqdb/NQ5sLEnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] block: reject zero length in bio_add_page()
Date: Mon, 20 Apr 2026 09:17:20 -0400
Message-ID: <20260420132314.1023554-46-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 643893647cac7317bafca4040dd0cfb815b510d4 ]

The function bio_add_page() returns the number of bytes added to the
bio, and if that failed it should return 0.

However there is a special quirk, if a caller is passing a page with
length 0, that function will always return 0 but with different results:

- The page is added to the bio
  If there is enough bvec slot or the folio can be merged with the last
  bvec.

  The return value 0 is just the length passed in, which is also 0.

- The page is not added to the bio
  If the page is not mergeable with the last bvec, or there is no bvec
  slot available.

  The return value 0 means page is not added into the bio.

Unfortunately the caller is not able to distinguish the above two cases,
and will treat the 0 return value as page addition failure.

In that case, this can lead to the double releasing of the last page:

- By the bio cleanup
  Which normally goes through every page of the bio, including the last
  page which is added into the bio.

- By the caller
  Which believes the page is not added into the bio, thus would manually
  release the page.

I do not think anyone should call bio_add_folio()/bio_add_page() with zero
length, but idiots like me can still show up.

So add an extra WARN_ON_ONCE() check for zero length and rejects it
early to avoid double freeing.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Link: https://patch.msgid.link/bc2223c080f38d0b63f968f605c918181c840f40.1773734749.git.wqu@suse.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a comprehensive analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `block` (core block layer)
- Action verb: `reject` (defensive fix/hardening)
- Summary: Reject zero-length pages in `bio_add_page()` to prevent
  double-free

**Step 1.2: Tags**
- `Signed-off-by: Qu Wenruo <wqu@suse.com>` - Author, btrfs developer
- `Link:` patch.msgid.link URL (lore blocked by anti-scraping)
- `Signed-off-by: Jens Axboe <axboe@kernel.dk>` - Block layer maintainer
  committed it
- No `Fixes:` tag (expected for candidates), no `Cc: stable`, no
  `Reported-by`

**Step 1.3: Commit Body Analysis**
The commit describes a clear bug mechanism:
- When `len=0` is passed to `bio_add_page()`, return value is always 0
- But 0 can mean "success with zero bytes" (page added) OR "failure"
  (page not added)
- Caller cannot distinguish these two cases, treats return 0 as failure
- If the page WAS added, the caller releases the page manually (thinking
  it wasn't added), AND the bio cleanup also releases it → **double-
  free**

The author says: "I do not think anyone should call
bio_add_folio()/bio_add_page() with zero length, but idiots like me can
still show up" — referencing his own btrfs zlib bug.

**Step 1.4: Hidden Bug Fix Detection**
This IS a bug fix. While framed as adding a defensive check, it prevents
a concrete double-free scenario that was actually triggered in btrfs
(commit `0dcabcb920a5c`).

Record: [block] [reject] [Adds WARN_ON_ONCE check for zero-length to
prevent double-free from API ambiguity]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `block/bio.c`
- +2 lines added (only)
- Function modified: `bio_add_page()`
- Scope: Single-file, single-function, surgical fix

**Step 2.2: Code Flow Change**
Single hunk: After the BIO_CLONED check, adds:
```c
if (WARN_ON_ONCE(len == 0))
    return 0;
```
Before: zero-length pages could be silently added, causing return value
ambiguity.
After: zero-length is rejected early with a WARN, returning 0
unambiguously meaning failure.

**Step 2.3: Bug Mechanism**
Category: Double-free prevention (memory safety fix). The zero-length
case creates an ambiguous return path where the page can be freed by
both the bio cleanup and the caller.

**Step 2.4: Fix Quality**
- Obviously correct — nobody should add zero bytes to a bio
- Minimal — 2 lines
- No regression risk — no valid caller should pass len=0
- WARN_ON_ONCE is low-overhead, fires once per boot maximum

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
`bio_add_page()` was refactored by Christoph Hellwig in commit
`0aa69fd32a5f76` (2018-06-01), but the fundamental function dates back
to Linus's original `1da177e4c3f41` (2005). The zero-length ambiguity
has existed since the function's creation.

**Step 3.2: Fixes tag** — No Fixes: tag present. The bug is in the API
design of `bio_add_page()` itself, not introduced by a specific commit.

**Step 3.3: File History**
`block/bio.c` has been actively modified — 159 commits since v6.6.
Recent refactoring by Christoph Hellwig (`38446014648c9`,
`12da89e8844ae`) changed the merge logic but didn't address zero-length.

**Step 3.4: Author**
Qu Wenruo is a prolific btrfs developer. He discovered this issue while
debugging the btrfs zlib crash (`0dcabcb920a5c`), which was reported by
David Sterba and syzbot. He fixed both the btrfs caller AND added this
block-level defense.

**Step 3.5: Dependencies**
None. The 2-line check has no prerequisites. It uses only existing
macros (`WARN_ON_ONCE`).

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:** Lore.kernel.org was blocked by anti-scraping
protection. However, from examining the related btrfs fix commit
(`0dcabcb920a5c`), I can confirm:
- The bug was reported by David Sterba (btrfs maintainer), Jean-
  Christophe Guillain (user), and syzbot
- A bugzilla was filed:
  https://bugzilla.kernel.org/show_bug.cgi?id=221176
- The root cause was bio_add_folio/bio_add_page accepting zero-length
- The fix was signed off by Jens Axboe (block maintainer)

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** Modified function: `bio_add_page()`

**Step 5.2: Callers**
`bio_add_page()` is called from 44+ files across the kernel: filesystems
(btrfs, gfs2, ocfs2, ntfs3, f2fs, squashfs, nfs, erofs, direct-io),
block layer (blk-map, blk-crypto), device mapper (dm-crypt, dm-io, dm-
writecache, dm-log-writes, dm-flakey, dm-zoned), RAID (raid1, raid5,
raid10), NVMe target, SCSI target, drbd, zram, xen-blkback, floppy. This
is a CORE API.

**Step 5.3:** `bio_add_page` calls `bvec_try_merge_page` and
`__bio_add_page`, manipulating bio vectors.

**Step 5.4:** Any filesystem or block driver issuing I/O can reach this
function. It's on the hot path for ALL block I/O.

**Step 5.5:** The same zero-length ambiguity exists in `bio_add_folio()`
which wraps `bio_add_page()`, so this fix protects both paths.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** `bio_add_page()` exists in ALL stable trees (present since
2005). The zero-length ambiguity has existed since the beginning.

**Step 6.2: Backport Compatibility**
- v6.6/v6.12: Function has slightly different structure (uses
  `same_page` variable, `bvec_try_merge_page` has different signature),
  but the fix location (after the BIO_CLONED check, before the size
  check) is identical. Patch should apply cleanly or with trivial
  context adjustment.
- v6.1: Function uses `__bio_try_merge_page()` instead. Fix still
  applies at the top of the function.
- v5.15: Same as v6.1.

**Step 6.3:** No related zero-length fix exists in any stable tree.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Block layer (`block/`) — **CORE** criticality. Affects all
users who do any I/O.

**Step 7.2:** Actively developed subsystem (20+ recent commits).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Universal — every kernel user performs block I/O through
`bio_add_page()`.

**Step 8.2: Trigger Conditions**
Currently, the btrfs zlib path (`3d74a7556fba`, only in 7.0+) was the
known trigger. In stable trees, no known caller currently passes zero-
length. However, any future backported fix or existing edge case that
accidentally computes zero-length would trigger the double-free.

**Step 8.3: Failure Mode**
Double-free of a page → memory corruption, crash, or security
vulnerability. Severity: **CRITICAL** when triggered.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents double-free from API misuse; hardens a core API used
  by 44+ files
- RISK: Effectively zero — 2 lines, adds a check for an invalid input
  that should never occur
- Ratio: Very favorable

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Prevents double-free (memory safety, potential security issue)
- 2-line fix, obviously correct, zero regression risk
- Core block layer API used by 44+ files
- Real bug was triggered (btrfs zlib crash with syzbot report + user
  reports)
- Block maintainer (Jens Axboe) signed off
- The API ambiguity exists in all stable kernels
- No caller should ever pass zero-length; this enforces a correct
  invariant

AGAINST backporting:
- The specific known trigger (btrfs zlib) only exists in 7.0+ code
- No known caller in stable trees currently passes zero-length
- Somewhat defensive/hardening in nature for older stable trees

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? **YES** — trivially verifiable
2. Fixes a real bug? **YES** — double-free is real, demonstrated in
   btrfs
3. Important issue? **YES** — double-free = memory corruption/crash
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features? **YES** — purely defensive check
6. Applies to stable? **YES** — with minor context adjustments

**Step 9.3: Exception Categories** — N/A

**Step 9.4: Decision**
The fix is tiny, obviously correct, and addresses a genuine API-level
design flaw that leads to double-free when any caller passes zero-
length. While the known trigger exists only in 7.0+, the underlying API
ambiguity has existed since 2005 and could be triggered by any of the
44+ callers if they ever compute a zero-length. The defensive hardening
of such a critical, widely-used API is appropriate for stable.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Qu Wenruo (author), Jens Axboe
  (block maintainer), Link: tag present
- [Phase 2] Diff analysis: 2 lines added to `bio_add_page()` —
  WARN_ON_ONCE(len == 0) + return 0
- [Phase 3] git blame: bio_add_page refactored in 0aa69fd32a5f76 (2018),
  original from 1da177e (2005); zero-length bug exists since origin
- [Phase 3] Author check: Qu Wenruo is prolific btrfs developer,
  discovered bug while fixing btrfs zlib crash (0dcabcb920a5c)
- [Phase 3] Related commit 0dcabcb920a5c confirmed: btrfs zlib double-
  free from zero-length bio_add_folio, reported by David Sterba, syzbot,
  and user
- [Phase 4] Lore blocked by anti-scraping; patch link confirmed via
  commit message
- [Phase 5] grep found 44+ files calling bio_add_page() across fs/,
  drivers/, block/ — CORE API
- [Phase 6] bio_add_page in v6.6, v6.1, v5.15 confirmed via git show —
  function exists in all stable trees; fix applies at same location (top
  of function)
- [Phase 6] No existing zero-length check in any stable tree version
  confirmed
- [Phase 7] Block layer — CORE subsystem, affects all users
- [Phase 8] Double-free → memory corruption → CRITICAL severity when
  triggered; 2-line fix → zero regression risk
- UNVERIFIED: Could not access lore.kernel.org to read full review
  discussion due to anti-scraping protection

**YES**

 block/bio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index d80d5d26804e3..6048d9382fecf 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1064,6 +1064,8 @@ int bio_add_page(struct bio *bio, struct page *page,
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
+	if (WARN_ON_ONCE(len == 0))
+		return 0;
 	if (bio->bi_iter.bi_size > BIO_MAX_SIZE - len)
 		return 0;
 
-- 
2.53.0

