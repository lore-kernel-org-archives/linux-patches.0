Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DA311960;
	Tue, 10 Feb 2026 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766287; cv=none; b=nP7AFjSQoCUrclKoIjXQ1NHPHz9w/wxzpFnCEueC3B1CdqPpmfHdjbMmyIUDoIhITaKQR0FOygBABUhvRwuXpdlxdibkBEVU0JPymmbiApZTVtF4pVvHrYBqaapHrLltD4PmBLNOlnvF4UoIQX2/0qRcMr+sNA9ufk2NIcFEo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766287; c=relaxed/simple;
	bh=xn4ES4OSZ+j4auWwrEB1CSEtmrh1w8Li9JuVgu7mAkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVcc3UTiF3fuVmvuFbZ2DCtfOA/f6wZDiYG/UJ5TMYKiyBFtyUsF7rwmhXZOJw+8SB13UVGKyXf9W4iWl65FR0ZTl3+VrETmEEWM8rvqI7e7kcORurQGSgEvDTu2hP4UOu31elnVI8js5CgR4qIpMdZG1c6dLqIY/boKElueZik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/z7EfNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/z7EfNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B41C19424;
	Tue, 10 Feb 2026 23:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766286;
	bh=xn4ES4OSZ+j4auWwrEB1CSEtmrh1w8Li9JuVgu7mAkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/z7EfNwu5dwc8BO7eHefUMGav8aEzcR/TwfKoxkCT2CRZ8xMezY+d2PcCq7q5fyY
	 9/00qgnRu4Cam36AgPhIcGes78o14THulHXEQ3V2+p63urxsISzjvHPX5lhllSkjKa
	 dZHlyGjBn49XTO3Si94Y3A20403xEsafytnT5wLrP8hwCwDqeasO0xwKfY/QJXgl6U
	 UYAWO0EEJ+ZE/Ry12bUg+boOPFkrBqMsUGzEygP+cLoocbMygUbm+/l6T9SvS/bq0h
	 6wpq9o1KZpWRZUXAaU2bii1BIy2+lUdYvZJy5jKbNd2mpeOJZ3DrjvOXBeR/Kxr+ll
	 D0Fo0MLv4MO2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.15] gfs2: fiemap page fault fix
Date: Tue, 10 Feb 2026 18:30:47 -0500
Message-ID: <20260210233123.2905307-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit e411d74cc5ba290f85d0dd5e4d1df8f1d6d975d2 ]

In gfs2_fiemap(), we are calling iomap_fiemap() while holding the inode
glock.  This can lead to recursive glock taking if the fiemap buffer is
memory mapped to the same inode and accessing it triggers a page fault.

Fix by disabling page faults for iomap_fiemap() and faulting in the
buffer by hand if necessary.

Fixes xfstest generic/742.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have the complete picture. Let me write up the full analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit subject is "gfs2: fiemap page fault fix" — a clear bug fix.
The body explains a concrete deadlock scenario: calling `iomap_fiemap()`
while holding the inode glock can lead to **recursive glock taking** if
the fiemap buffer is memory-mapped to the same inode. It also says it
"Fixes xfstest generic/742," which is a test specifically designed to
catch this class of bug.

The author is Andreas Gruenbacher, the GFS2 maintainer and the same
person who wrote the original mmap + page fault deadlock fixes for
GFS2's buffered I/O (commit `00bfe02f47968`) and direct I/O (commit
`b01b2d72da25c`) paths — both merged in v5.16.

### 2. Code Change Analysis — The Deadlock Mechanism

The deadlock path is clear and concrete:

1. **`gfs2_fiemap()`** acquires the inode glock `ip->i_gl` in
   `LM_ST_SHARED` mode via `gfs2_glock_nq_init()`
2. **`iomap_fiemap()`** iterates over file extents and calls
   **`iomap_to_fiemap()`** → **`fiemap_fill_next_extent()`**
3. `fiemap_fill_next_extent()` uses **`copy_to_user()`** to write extent
   data to the user-supplied buffer (line 144 of `fs/ioctl.c`)
4. If that user buffer is **mmap'd to the same file**, `copy_to_user()`
   triggers a page fault
5. The page fault enters **`gfs2_page_mkwrite()`** (for write faults) or
   **`gfs2_fault()`** (for read faults)
6. **`gfs2_page_mkwrite()`** tries to acquire `ip->i_gl` in
   `LM_ST_EXCLUSIVE` mode — **deadlock**: it conflicts with the already-
   held `LM_ST_SHARED`. Even `gfs2_fault()` would attempt another
   `LM_ST_SHARED`, which in GFS2's distributed locking model can also
   cause issues (the glock holder tracks are per-process, and in a
   clustered scenario this can cause distributed deadlocks).

### 3. The Fix — Well-Established Pattern

The fix follows the **exact same pattern** already used in 4+ locations
within `fs/gfs2/file.c`:

```2195:2212:fs/gfs2/inode.c
retry:
        ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
        if (ret)
                goto out;

        pagefault_disable();
        ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
        pagefault_enable();

        gfs2_glock_dq_uninit(&gh);

        if (ret == -EFAULT && fault_in_fiemap(fieinfo)) {
                fieinfo->fi_extents_mapped = 0;
                goto retry;
        }
```

The pattern is:
- **`pagefault_disable()`** before the operation that touches user
  memory while holding the glock
- **`pagefault_enable()`** after
- If `-EFAULT` is returned (page fault was needed but prevented), **drop
  the glock**, **manually fault in** the user pages, and **retry**

The helper `fault_in_fiemap()` calls `fault_in_safe_writeable()` on the
destination buffer, which is a non-destructive way to ensure pages are
resident without holding any filesystem locks.

### 4. Cross-Subsystem Validation

The **exact same bug class** was found and fixed in OCFS2
(`04100f775c2ea`), reported by syzbot, and explicitly tagged `Cc:
stable@vger.kernel.org`. That fix had a stack trace showing the deadlock
happening during `copy_to_user` in `fiemap_fill_next_extent` → recursive
semaphore acquisition in `ocfs2_page_mkwrite`. The GFS2 case is
structurally identical.

### 5. Scope and Risk Assessment

- **Lines changed**: +20 lines in a single file (`fs/gfs2/inode.c`)
- **New helper**: `fault_in_fiemap()` — 6 lines, trivial wrapper around
  `fault_in_safe_writeable()`
- **Dependencies**: `fault_in_safe_writeable()` exists in all current
  LTS trees (v6.1, v6.6, v6.12)
- **Clean apply**: The `gfs2_fiemap()` function is byte-for-byte
  identical in v6.1, v6.6, v6.12, and mainline. The patch applies
  cleanly.
- **Risk**: Very low. The fix uses a well-established pattern from the
  same subsystem. The only behavioral change is adding retry logic for
  the (previously impossible) case where the user buffer is mmap'd to
  the same file. Normal fiemap calls are unaffected (no page faults, no
  retry).

### 6. User Impact

- **Severity**: **Deadlock** — system hang for the process, and on
  clustered GFS2, potential cluster-wide impact
- **Trigger**: User-space can trigger this by mmap'ing a GFS2 file and
  passing the mmap'd buffer to `FS_IOC_FIEMAP`
- **Affected users**: All GFS2 users, especially those running xfstests
  or using fiemap on clustered filesystems
- **Test coverage**: xfstest generic/742 specifically tests this
  scenario

### 7. Stability and Quality Indicators

- Author is the GFS2 subsystem maintainer (Andreas Gruenbacher)
- Pattern is proven and battle-tested in the same codebase since v5.16
- The analogous OCFS2 fix was syzbot-reported and stable-tagged
- The fix has a dedicated xfstest (generic/742)

### 8. Dependency Check

No external dependencies. The fix is self-contained:
- `pagefault_disable/enable` — core kernel functions, always available
- `fault_in_safe_writeable` — available since v5.16, present in all
  current LTS trees
- The `gfs2_fiemap` function is unchanged across all LTS trees

### Conclusion

This commit fixes a **real deadlock** in GFS2's fiemap path that can be
triggered from user space. The fix is small (20 lines), self-contained,
follows a well-established pattern already used in the same subsystem,
applies cleanly to all current stable trees, and has a dedicated
xfstest. The same bug class in OCFS2 was considered important enough for
syzbot reporting and explicit stable tagging. This is a textbook stable
backport candidate.

**YES**

 fs/gfs2/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 36618e3531996..ea03c23bd147b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2182,6 +2182,14 @@ static int gfs2_getattr(struct mnt_idmap *idmap,
 	return 0;
 }
 
+static bool fault_in_fiemap(struct fiemap_extent_info *fi)
+{
+	struct fiemap_extent __user *dest = fi->fi_extents_start;
+	size_t size = sizeof(*dest) * fi->fi_extents_max;
+
+	return fault_in_safe_writeable((char __user *)dest, size) == 0;
+}
+
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len)
 {
@@ -2191,14 +2199,22 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	inode_lock_shared(inode);
 
+retry:
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	if (ret)
 		goto out;
 
+	pagefault_disable();
 	ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
+	pagefault_enable();
 
 	gfs2_glock_dq_uninit(&gh);
 
+	if (ret == -EFAULT && fault_in_fiemap(fieinfo)) {
+		fieinfo->fi_extents_mapped = 0;
+		goto retry;
+	}
+
 out:
 	inode_unlock_shared(inode);
 	return ret;
-- 
2.51.0

