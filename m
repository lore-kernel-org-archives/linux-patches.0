Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96F1267B88;
	Sun,  1 Jun 2025 23:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820392; cv=none; b=DY2goarO5pGNIwpma00+m7zczTCIU9QN4KS9Kwm9OR0Ab+kQQ7tKshX3tIwZK+f2kW1iq1saIOSuFv0fexFSuzFKlFQY78FKxwKivmXDG2Z1BvvCLltn/pmnlQXYVhqAU4O01m/sMO4gW9aZ6tN/jBvKxtltHcSVHwfVe0CPkPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820392; c=relaxed/simple;
	bh=O40NOxv/cbMvwp8e6JnE7yFQyeGP5k32sfavIm7BbIE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/YdYqj8gHbSkZqUpcWyKSwQTNu4xkM2MX1tl9KDNP3fSPsZn8t7YVgxbx686sc5Y8Eydl5UEFpSjenHz5Fq2eHU02vMdkpKc6iquC5GNIp9ySO5n96rJw7ErscQe9JmijM14Ug9HRDRNC/AhjSqEEu6QFhxgoYbDOI7Jrwptdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKmvegVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKmvegVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C7C4CEE7;
	Sun,  1 Jun 2025 23:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820392;
	bh=O40NOxv/cbMvwp8e6JnE7yFQyeGP5k32sfavIm7BbIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKmvegVxeBoDrsx2N48nUXIrNf63NgtnKDSTkxPQBfxqGNnwk6GBgrbnrr9vMwBYu
	 Xo9cRq+T0oxz+jczISLs2Wsy2iZe3IWj9o99d+kYCwSlbSAnQHJoPnKdUhPOWNz06d
	 msBFskUyM0YAvJSBGEHYKABSzDUFUpt1gl0rk2njrAFFDdLHZEdQXj4X7s4yMif7Ij
	 q31cPrfqSwlEV0Ms8BnxEj416jZyIVqTjvT0AlgihXoBMGrCpLG9lYEOGd9rbKD+QQ
	 d9VFMW234XfAjxVNTiRY6Idi6SBc3OOyAyYtPtPbOuVBdre9u2IOzGRRbAfFLljgMq
	 qEWqu4XpTGg+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aditya Dutt <duttaditya18@gmail.com>,
	syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	ghanshyam1898@gmail.com,
	eadavis@qq.com,
	r.smirnov@omp.ru,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 046/110] jfs: fix array-index-out-of-bounds read in add_missing_indices
Date: Sun,  1 Jun 2025 19:23:28 -0400
Message-Id: <20250601232435.3507697-46-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aditya Dutt <duttaditya18@gmail.com>

[ Upstream commit 5dff41a86377563f7a2b968aae00d25b4ceb37c9 ]

stbl is s8 but it must contain offsets into slot which can go from 0 to
127.

Added a bound check for that error and return -EIO if the check fails.
Also make jfs_readdir return with error if add_missing_indices returns
with an error.

Reported-by: syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com./bug?extid=b974bd41515f770c608b
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Security and Stability Impact 1. **Critical
Array-Index-Out-of-Bounds Fix**: The commit addresses a serious array-
index-out-of-bounds vulnerability in the JFS filesystem's
`add_missing_indices()` function at `fs/jfs/jfs_dtree.c:2648`. The code
was accessing `p->slot[stbl[i]]` without validating that `stbl[i]` is
within valid bounds (0-127). 2. **Consistent with Established Pattern**:
This fix follows the exact same pattern as **all 5 similar commits**
that were marked as "Backport Status: YES": - Similar Commits #1, #2, #3
all add bounds checking for `stbl[i] < 0 || stbl[i] > 127` - Similar
Commits #4, #5 add bounds checking for array indices in JFS - All were
successfully backported due to their security importance 3. **Syzbot-
Reported Vulnerability**: The commit fixes a vulnerability reported by
syzbot (`syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com`),
indicating this is a real exploitable issue found through fuzzing. ##
Code Analysis **Key Changes Made:** 1. **Bounds Check Addition**: Added
validation `if (stbl[i] < 0)` before accessing `p->slot[stbl[i]]` 2.
**Error Handling**: Changed `add_missing_indices()` from `void` to `int`
return type to propagate errors 3. **Proper Error Propagation**:
Modified `jfs_readdir()` to check return value and exit on error: `if
((rc = add_missing_indices(ip, bn))) goto out;` 4. **Transaction
Cleanup**: Added `txAbort(tid, 0)` on error path to properly clean up
the transaction **Technical Context:** - `stbl` is declared as `s8 *`
(signed 8-bit array) but must contain valid slot indices (0-127) -
`DTPAGEMAXSLOT` is defined as 128, so valid indices are 0-127 - Negative
values in `stbl[i]` cause array-index-out-of-bounds when accessing
`p->slot[stbl[i]]` ## Backport Criteria Assessment ✅ **Fixes Important
Bug**: Prevents potential kernel crashes and security issues ✅ **Small
and Contained**: Limited to one function with clear, minimal changes ✅
**No Side Effects**: Only adds bounds checking and error handling ✅ **No
Architectural Changes**: Preserves existing logic flow ✅ **Critical
Subsystem**: Filesystem corruption/crashes affect system stability ✅
**Clear Pattern**: Identical to 5 other successfully backported JFS
fixes ✅ **Minimal Regression Risk**: Only adds safety checks, doesn't
change core logic ✅ **Confined to Subsystem**: Changes isolated to JFS
dtree handling ## Existing Infrastructure The kernel already has
extensive bounds checking for `stbl` indices throughout `jfs_dtree.c`: -
Line 2895-2898: `if (stbl[i] < 0 || stbl[i] > 127)` in `jfs_readdir()` -
Line 3099-3102: `if (stbl[0] < 0 || stbl[0] > 127)` in `dtReadFirst()` -
Line 637-640: `if (stbl[index] < 0)` in search functions This commit
simply extends the same pattern to the previously missed
`add_missing_indices()` function, maintaining consistency with the
existing codebase security measures. The fix is essential for preventing
potential kernel crashes and maintaining filesystem integrity, making it
an ideal candidate for stable tree backporting.

 fs/jfs/jfs_dtree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 93db6eec44655..ab11849cf9cc3 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2613,7 +2613,7 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
  *	     fsck.jfs should really fix this, but it currently does not.
  *	     Called from jfs_readdir when bad index is detected.
  */
-static void add_missing_indices(struct inode *inode, s64 bn)
+static int add_missing_indices(struct inode *inode, s64 bn)
 {
 	struct ldtentry *d;
 	struct dt_lock *dtlck;
@@ -2622,7 +2622,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	struct lv *lv;
 	struct metapage *mp;
 	dtpage_t *p;
-	int rc;
+	int rc = 0;
 	s8 *stbl;
 	tid_t tid;
 	struct tlock *tlck;
@@ -2647,6 +2647,16 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 
 	stbl = DT_GETSTBL(p);
 	for (i = 0; i < p->header.nextindex; i++) {
+		if (stbl[i] < 0) {
+			jfs_err("jfs: add_missing_indices: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+				i, stbl[i], (long)inode->i_ino, (long long)bn);
+			rc = -EIO;
+
+			DT_PUTPAGE(mp);
+			txAbort(tid, 0);
+			goto end;
+		}
+
 		d = (struct ldtentry *) &p->slot[stbl[i]];
 		index = le32_to_cpu(d->index);
 		if ((index < 2) || (index >= JFS_IP(inode)->next_index)) {
@@ -2664,6 +2674,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	(void) txCommit(tid, 1, &inode, 0);
 end:
 	txEnd(tid);
+	return rc;
 }
 
 /*
@@ -3017,7 +3028,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		if (fix_page) {
-			add_missing_indices(ip, bn);
+			if ((rc = add_missing_indices(ip, bn)))
+				goto out;
 			page_fixed = 1;
 		}
 
-- 
2.39.5

