Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2855344D82;
	Fri, 20 Feb 2026 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591101; cv=none; b=tIPemOBKPdmxoW434zWxzKE0Gj5ZoyNxI3OQTmCWf0psszv1ajinA6p0iyXR7C2XSqPH36bngbgOXjnmIfMeynXpKN06Bkyh38XJjRRCOAtY8miG8/L61AyRnRNZZV5+5JllPgx2wV+vXVeb8aN8DlaWLjBvpLJE1LyXLzCC3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591101; c=relaxed/simple;
	bh=NSV4O6oMq0tAlvE6jJSiNIWilx6qv+dqb2nLhbGP2xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p3CZTi/5R3SF+MdqnSGlcsMYqcP0+3tS+1+JedJCRfhAYPrHLdXxzDxE/ASPxa0GfPhuq1ta04iFtSf7XEAhlRvrt7vBIu5isbC5hD3Xzh47KMcTa6yyWJYhr8vRna/3V2k/Vr6ASt1AEkonVDL5XfCiQjWYI4UIQOn5RdrEtzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpMBxyBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpMBxyBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D2BC19423;
	Fri, 20 Feb 2026 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591101;
	bh=NSV4O6oMq0tAlvE6jJSiNIWilx6qv+dqb2nLhbGP2xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpMBxyBFRwXDL5E0rKR5Z1nOcLoJG8V4XQfdt9GKyJu0+aP3HUPLQw8ZE1QR6Z6YZ
	 TDZppoVtI2395Rj0GpBrzbxYeCyZ12qGnBnTp+tVqyhmy7aNrnitoWoclyd6XsdFJB
	 EYGPShuEd0NsjYKuG8yjsjUH+P0qoazzmr0oe3aAwfaUeT5i2Q3avilHnl2qjYQE57
	 2eDeOukY57Nv7wdc0ueS0LZERGUJFJ57pmMa9sVY4FMIGeK2roqrWqzGVDSPaNbinN
	 mhOnXhol6Xl7EWgXdYyhG/Kbni2JnMRbPhP9Zk9vnKEfQKwnm9O5VzBGSWD9s17jWq
	 ejamMPCJM3O6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] fs/ntfs3: drop preallocated clusters for sparse and compressed files
Date: Fri, 20 Feb 2026 07:37:59 -0500
Message-ID: <20260220123805.3371698-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260220123805.3371698-1-sashal@kernel.org>
References: <20260220123805.3371698-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 3a6aba7f3cf2b46816e08548c254d98de9c74eba ]

Do not keep preallocated clusters for sparsed and compressed files.
Preserving preallocation in these cases causes fsx failures when running
with sparse files and preallocation enabled.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding of the patch. Let me finalize
my analysis.

## Analysis

### 1. Commit Message Analysis

The commit message is straightforward: "Do not keep preallocated
clusters for sparsed and compressed files. Preserving preallocation in
these cases causes fsx failures when running with sparse files and
preallocation enabled."

The author is Konstantin Komarov, the ntfs3 maintainer. The commit
explicitly mentions **fsx failures**, which are data correctness test
failures from the filesystem exerciser tool in xfstests. fsx is one of
the most important tools for detecting filesystem data corruption bugs.

### 2. Code Change Analysis

The change is minimal — adding one line (`keep_prealloc = false;`)
inside an existing `if (is_ext)` block, and adding braces to accommodate
the new statement:

```c
// Before:
if (is_ext)
    align <<= attr_b->nres.c_unit;

// After:
if (is_ext) {
    align <<= attr_b->nres.c_unit;
    keep_prealloc = false;
}
```

When `keep_prealloc = true` and `new_size < old_size` (truncation), the
code at line 464-468 takes a shortcut: it only updates `data_size`
without actually deallocating clusters. For sparse/compressed files,
this behavior is incorrect because:
- Sparse files use implicit zero-filled ranges; keeping preallocated
  clusters creates an inconsistency between the on-disk layout and the
  NTFS sparse representation
- Compressed files have compression units that require precise cluster
  accounting
- The truncation path at line 694 (`(new_alloc != old_alloc &&
  !keep_prealloc)`) also relies on `keep_prealloc` to decide whether to
  actually free clusters

### 3. Historical Context

This commit effectively partially reverts `ce46ae0c3e31` ("fs/ntfs3:
Keep prealloc for all types of files", Oct 2021), which removed
`keep_prealloc = false` for sparse/ext files to fix xfstest generic/274.
However, keeping preallocation for these file types turned out to cause
**fsx failures** — meaning data corruption or incorrect behavior
detectable under stress testing. The current commit is a correction:
sparse/compressed files fundamentally should NOT keep preallocated space
when truncating.

Note that the extension path (line 529-531) already has `pre_alloc = 0`
for `is_ext` files — so the codebase already disables preallocation for
growth of sparse/compressed files. This commit makes the shrink path
consistent with the growth path.

### 4. Scope and Risk Assessment

- **Lines changed**: 3 lines (adding braces + one line of logic)
- **Files changed**: 1 (fs/ntfs3/attrib.c)
- **Risk**: Very low — only affects sparse/compressed NTFS files being
  truncated with prealloc enabled
- **Regression potential**: Minimal. This restores behavior closer to
  the original design for sparse/compressed files

### 5. User Impact

- Affects users of ntfs3 filesystem with sparse or compressed files
- fsx failures indicate real data corruption/inconsistency that users
  could encounter
- While ntfs3 may not be as widely used as ext4/xfs, filesystem data
  corruption is a critical severity issue

### 6. Stable Kernel Criteria Assessment

- **Obviously correct**: Yes — one-line fix, consistent with existing
  behavior in the growth path
- **Fixes a real bug**: Yes — fsx failures indicate data corruption
- **Small and contained**: Yes — 3 lines in one file
- **No new features**: Correct — this only changes behavior of existing
  preallocation logic
- **Low risk**: Yes — only affects a specific NTFS file type combination

### Verification

- Read the current state of `fs/ntfs3/attrib.c` lines 449-468 —
  confirmed the code matches the diff context (pre-patch state)
- Verified commit `ce46ae0c3e31` removed `keep_prealloc = false` for
  sparse/ext files in Oct 2021 — this commit re-adds it
- Verified the growth path at line 529-531 already has `pre_alloc = 0`
  for `is_ext` — confirming sparse/compressed files already don't
  preallocate on extension
- Verified `is_attr_ext()` checks for `ATTR_FLAG_SPARSED |
  ATTR_FLAG_COMPRESSED` flags
- Checked lore.kernel.org — found the patch submission (Dec 26, 2025)
  with no NAK or negative reviewer feedback
- Confirmed the author is Konstantin Komarov, the ntfs3 maintainer
- Verified `keep_prealloc` logic at line 464-468: when true and
  shrinking, only updates data_size without deallocating — this is the
  problematic behavior for sparse/compressed files
- Could NOT verify exact fsx test case that fails (unverified, but fsx
  failures generally indicate real data corruption)

### Conclusion

This is a small, well-contained filesystem data correctness fix by the
ntfs3 maintainer. It fixes fsx test failures (data
corruption/inconsistency) for sparse and compressed files. The change is
one line of logic, affects only ntfs3 sparse/compressed file truncation,
and is consistent with existing preallocation behavior in the growth
path. The risk is very low and the benefit is real — preventing data
corruption in a filesystem.

**YES**

 fs/ntfs3/attrib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index c45880ab23912..0cd15a0983fee 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -448,8 +448,10 @@ int attr_set_size(struct ntfs_inode *ni, enum ATTR_TYPE type,
 
 	is_ext = is_attr_ext(attr_b);
 	align = sbi->cluster_size;
-	if (is_ext)
+	if (is_ext) {
 		align <<= attr_b->nres.c_unit;
+		keep_prealloc = false;
+	}
 
 	old_valid = le64_to_cpu(attr_b->nres.valid_size);
 	old_size = le64_to_cpu(attr_b->nres.data_size);
-- 
2.51.0

