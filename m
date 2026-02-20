Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263FE344D86;
	Fri, 20 Feb 2026 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591099; cv=none; b=vGf17CFso6th7JlWT+YZ/vvdYTVg0EiQxjNzUfV99e/VSfYtQecJQ5qIUTSDCQdeSrRcCTbqTr4f8sgC+lMJljDU4gwHpgNuz4uM2fQ5DU8wSNgBIaS++0CBJL/AMTGoYw8uUl0Xd3jcvyDvCvxCcCiCqB7akFWU+mHq8GZxoSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591099; c=relaxed/simple;
	bh=LElftox2x5jV9I/EfuAroS8I55lWSr4HdGo97oTqbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idD+qACrxncd9RdCqrNwbV1bFW/ciz7bjFGieLu6uoOXMuRewk47mYavkNR3sqF/yZmPrtoea1dET36qtrTd7XhBnE8I5dEcTwppcE9xHSAJvoqql+ImoS1KQHwaMk31uswBxSXv6cXClnvuDUufqsAS7nS1I97JPHQAbNPYs8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS+WDXfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS+WDXfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298C9C116C6;
	Fri, 20 Feb 2026 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591098;
	bh=LElftox2x5jV9I/EfuAroS8I55lWSr4HdGo97oTqbsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS+WDXfqL5R9YvbCnFNCEiqLUW3XPeFoKUJcoIdWnHYTjEVMD2MqrrCbXuW6EPoSL
	 eYKdHsiXav+u+j74Ib09GSVai7AuhnzZYPxhPeTRoPuG9HgXT/GrEHD7y9P1DVcJ9b
	 vk540HFA4KvcO2sQsHv8eb3ifxsM2Hs0kjaKplCgaFQz22YiIloIII4Fs+YjP0rEjz
	 GXvczNY8kYzadz+zy1mS1tRv0zcDv4sCo/U5ZqSvv6VxMVYKTA/kAmubcVBOK1jv0J
	 tspybAJzqI14k+KNkhytH3p8ADGJhe64yD2H/0uaKtbNcsV72uU9lQBpGc4A/BIG4T
	 a3Lbn4Ny9E0Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] fs/ntfs3: handle attr_set_size() errors when truncating files
Date: Fri, 20 Feb 2026 07:37:57 -0500
Message-ID: <20260220123805.3371698-8-sashal@kernel.org>
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

[ Upstream commit 576248a34b927e93b2fd3fff7df735ba73ad7d01 ]

If attr_set_size() fails while truncating down, the error is silently
ignored and the inode may be left in an inconsistent state.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear picture of the bug. Let me analyze it:

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear: "handle attr_set_size() errors when
truncating files." It states that if `attr_set_size()` fails while
truncating down, the error is silently ignored and the inode may be left
in an inconsistent state. The author is Konstantin Komarov, the NTFS3
maintainer.

### 2. CODE CHANGE ANALYSIS

**The bug:** In the original `ntfs_truncate()` function (line 504-554 of
`fs/ntfs3/file.c`), `attr_set_size()` is called at line 531-533 and its
return value is stored in `err`. However, after `ni_unlock(ni)`, the
code does **not** check `err` — it proceeds to modify the inode metadata
(setting FILE_ATTRIBUTE_ARCHIVE, updating timestamps) and then either:
- Sets `dirty = 1` and later calls `mark_inode_dirty()`, OR
- Calls `ntfs_sync_inode()` which **overwrites** `err` (line 545-546)

In both paths, the original error from `attr_set_size()` is lost. The
function returns `0` (line 554) even when the underlying attribute size
change failed.

**The fix adds** (after line 539, after `ni_unlock(ni)`):
```c
if (unlikely(err))
    return err;
```

This ensures that if `attr_set_size()` failed, the error is propagated
to the caller immediately, before marking the inode dirty with
potentially inconsistent metadata.

**Additional cleanup:** The `dirty` variable is removed and
`mark_inode_dirty()` is called directly in the `!IS_DIRSYNC` branch,
which is a trivial simplification.

### 3. IMPACT ASSESSMENT

**The caller** (`ntfs_setattr` at line 851) checks the return value of
`ntfs_truncate()`:
```c
err = ntfs_truncate(inode, newsize);
...
if (err)
    goto out;
```

So if `attr_set_size()` fails (e.g., due to disk I/O error, out of
space, corrupted MFT records), the old code would:
1. Silently ignore the failure
2. Proceed to update inode metadata as if truncation succeeded
3. Return success to the VFS layer

This means the in-memory inode state (already updated by
`truncate_setsize()`) could diverge from the on-disk NTFS attribute
state, leading to **filesystem inconsistency**. The inode would think
the file is the new size while the NTFS data attribute still has the old
size.

This is a **data corruption** bug. On an NTFS filesystem, this could
lead to:
- Stale data being visible after truncation
- Incorrect file sizes reported
- Further I/O errors when accessing the inconsistent inode

### 4. SCOPE AND RISK

- **2 lines of actual logic change** (the `if (unlikely(err)) return
  err;` check), plus trivial cleanup of the `dirty` variable
- Affects only the NTFS3 truncate path
- Very low risk of regression — it only changes behavior when
  `attr_set_size()` already failed
- The code has existed since the initial NTFS3 commit `4342306f0f0d5f`
  (v5.15, 2021-08-13), so this bug affects all stable trees containing
  NTFS3

### 5. STABLE CRITERIA

- **Obviously correct**: The fix simply checks an already-captured error
  return value that was being silently ignored
- **Fixes a real bug**: Silently ignoring errors from `attr_set_size()`
  can lead to filesystem inconsistency
- **Important issue**: Filesystem data corruption/inconsistency
- **Small and contained**: ~5 lines changed, single file, single
  function
- **No new features**: Pure error handling fix

### Verification

- `git blame` confirmed the buggy code (missing error check after
  `attr_set_size()`) has been present since commit `4342306f0f0d5f`
  (Konstantin Komarov, 2021-08-13), which is the initial NTFS3 import in
  v5.15
- Verified the caller `ntfs_setattr` at line 851 checks
  `ntfs_truncate()` return value — so propagating the error has
  meaningful effect
- Verified that line 554 (`return 0`) means the error is unconditionally
  discarded in the original code — confirmed by reading lines 539-554
- Verified `attr_set_size()` can return errors (e.g., `-ENOENT` at line
  430, propagated errors from `attr_set_size_res` at line 437)
- Verified the `dirty` variable removal is safe — `mark_inode_dirty()`
  is now called directly in the `!IS_DIRSYNC` branch, which is
  functionally identical
- Could NOT verify whether this specific patch has been discussed on
  lore.kernel.org (not checked via WebFetch), but the author is the
  NTFS3 maintainer which provides confidence

This is a clear, small, obviously-correct error handling fix for a
filesystem data consistency bug that has existed since NTFS3 was first
introduced. It meets all stable kernel criteria.

**YES**

 fs/ntfs3/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2e7b2e566ebe1..362396968ab69 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -505,8 +505,8 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	int err, dirty = 0;
 	u64 new_valid;
+	int err;
 
 	if (!S_ISREG(inode->i_mode))
 		return 0;
@@ -522,7 +522,6 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 	}
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
-
 	truncate_setsize(inode, new_size);
 
 	ni_lock(ni);
@@ -536,20 +535,19 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 		ni->i_valid = new_valid;
 
 	ni_unlock(ni);
+	if (unlikely(err))
+		return err;
 
 	ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (!IS_DIRSYNC(inode)) {
-		dirty = 1;
+		mark_inode_dirty(inode);
 	} else {
 		err = ntfs_sync_inode(inode);
 		if (err)
 			return err;
 	}
 
-	if (dirty)
-		mark_inode_dirty(inode);
-
 	return 0;
 }
 
-- 
2.51.0

