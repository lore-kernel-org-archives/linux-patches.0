Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BDE2E8B7E;
	Tue,  9 Dec 2025 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239489; cv=none; b=cXRaE/OS+7zWlocKdPCrD7bX3czgYUI4cmksKaPP+gRZUtBauzJBuC8RXo2w4n2ygvgVHdFaGnkOAIPsrTEppje7Y7fimn9uMIzlxdB4u1y8FIej28UKcPRPtVnd2gPLxQ1nWl22GjNGuNlNVoIQqZDXnOAStwtUcAq/uiAbRYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239489; c=relaxed/simple;
	bh=kJAdqCXr4d3RnC2ag6980p/5Tk4kg1ToKyAzNT9irtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rgi6ZJLLLAeW9TJ3dDcMgIdSDesnxeOuemQakPARYOUv1/asQHvpJVE4ohLhlROqEjzHZ72dc1gMorvsTXZnN3guXBMUhCj0wf1896pxXFwVyjqDfVYaNMlFLZklG0AtjI0vMqkXwu8WFfH+tJ8dA7g8YS04bsPhd2zL5vg5Wm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXZenXE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXZenXE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7B3C19421;
	Tue,  9 Dec 2025 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239489;
	bh=kJAdqCXr4d3RnC2ag6980p/5Tk4kg1ToKyAzNT9irtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXZenXE4Eyl8DW9b/XyINswx2mwHO4gXbbKR3QfLwsI6+E1aX29SdTSF9W0acAHQt
	 APIOoc1cvA3Fqxiu7UQbGM3QsFgvB1pV2mhdcpyoAwI5PJQOaRgC936Cy1JuO+HqkH
	 8+fq5Tc7gWDBTEtvfZC/Tim2DbWfg1aAaxaKAmaEw51bKxtaC0+8ToHFOpyV1MWyRb
	 PRH6d06F9/re30QsHEJsrTE+c3HKDmvqTfQipkKAjeheO//k39SA2IX5IK+Qv2HdPo
	 FcPnTKwZyFFoO95zRr0OkgUSttoumI97YeEjtk4HbrCdB5bYZpdQkJlrumHeDGi4Yh
	 WQZh4DJpnTfDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] ntfs: set dummy blocksize to read boot_block when mounting
Date: Mon,  8 Dec 2025 19:15:31 -0500
Message-ID: <20251209001610.611575-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

[ Upstream commit d1693a7d5a38acf6424235a6070bcf5b186a360d ]

When mounting, sb->s_blocksize is used to read the boot_block without
being defined or validated. Set a dummy blocksize before attempting to
read the boot_block.

The issue can be triggered with the following syz reproducer:

  mkdirat(0xffffffffffffff9c, &(0x7f0000000080)='./file1\x00', 0x0)
  r4 = openat$nullb(0xffffffffffffff9c, &(0x7f0000000040), 0x121403, 0x0)
  ioctl$FS_IOC_SETFLAGS(r4, 0x40081271, &(0x7f0000000980)=0x4000)
  mount(&(0x7f0000000140)=@nullb, &(0x7f0000000040)='./cgroup\x00',
        &(0x7f0000000000)='ntfs3\x00', 0x2208004, 0x0)
  syz_clone(0x88200200, 0x0, 0x0, 0x0, 0x0, 0x0)

Here, the ioctl sets the bdev block size to 16384. During mount,
get_tree_bdev_flags() calls sb_set_blocksize(sb, block_size(bdev)),
but since block_size(bdev) > PAGE_SIZE, sb_set_blocksize() leaves
sb->s_blocksize at zero.

Later, ntfs_init_from_boot() attempts to read the boot_block while
sb->s_blocksize is still zero, which triggers the bug.

Reported-by: syzbot+f4f84b57a01d6b8364ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f4f84b57a01d6b8364ad
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
[almaz.alexandrovich@paragon-software.com: changed comment style, added
return value handling]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture of the issue. Let me summarize my
analysis:

## Summary of Analysis

### The Bug

The commit fixes a bug in ntfs3's `ntfs_init_from_boot()` function where
`ntfs_bread()` is called to read the boot block **before**
`sb->s_blocksize` is properly set.

### Root Cause Analysis

1. **Mount Flow**: When mounting an ntfs3 filesystem:
   - `get_tree_bdev()` calls `setup_bdev_super()` which calls
     `sb_set_blocksize(sb, block_size(bdev))`
   - If `block_size(bdev) > PAGE_SIZE` (which can happen via ioctl
     `FS_IOC_SETFLAGS` setting bdev block size to 16384 as shown in the
     reproducer), and the filesystem doesn't have `FS_LBS` flag,
     `sb_set_blocksize()` returns 0 and leaves `sb->s_blocksize = 0`

2. **The Crash Path**: In `ntfs_init_from_boot()`:
  ```c
  sbi->volume.blocks = dev_size >> PAGE_SHIFT;
  // sb->s_blocksize is 0 here!
  bh = ntfs_bread(sb, boot_block);  // Uses sb->s_blocksize = 0
  ```

3. **Cascade to Infinite Loop**:
   - `ntfs_bread()` → `sb_bread_unmovable()` → `__bread_gfp()` with
     size=0
   - `bdev_getblk()` → `__getblk_slow()` → `grow_buffers()` →
     `grow_dev_folio()` → `folio_alloc_buffers()`
   - In `folio_alloc_buffers()`: `while ((offset -= size) >= 0)` with
     size=0 causes infinite loop

### The Fix

The fix adds a call to `sb_min_blocksize(sb, PAGE_SIZE)` before
attempting to read the boot block:

```c
/* Set dummy blocksize to read boot_block. */
if (!sb_min_blocksize(sb, PAGE_SIZE)) {
    return -EINVAL;
}
```

This ensures:
1. `sb->s_blocksize` is set to at least the device's logical block size,
   capped at PAGE_SIZE
2. If this fails, mount fails gracefully with `-EINVAL` instead of
   hanging

### Backport Assessment

**STRONG YES signals:**
1. ✅ **Fixes a real crash/hang** - System hangs due to infinite loop in
   `folio_alloc_buffers()`
2. ✅ **Syzbot reported** - Has syzkaller reproducer
   (`f4f84b57a01d6b8364ad`)
3. ✅ **Small, surgical fix** - Only 4 lines added
4. ✅ **Clear, obvious fix** - Sets blocksize before using it for reads
5. ✅ **Uses well-established API** - `sb_min_blocksize()` is a standard
   helper used by many filesystems
6. ✅ **Affects production users** - ntfs3 is widely used (included since
   5.15)
7. ✅ **Denial of Service potential** - A local user can trigger the hang

**Risk Assessment:**
- **Very Low Risk**: The fix adds a safety check before an I/O operation
- **No behavioral change** for normal cases - the blocksize would have
  been set to PAGE_SIZE anyway after successful boot read
- **Graceful failure** if `sb_min_blocksize()` fails (which would be
  very rare in practice)

**Stable Trees Affected:**
- All stable trees with ntfs3: 5.15.y, 6.1.y, 6.6.y, 6.10.y, 6.11.y,
  etc.
- The bug has existed since ntfs3 was introduced in v5.15
- The recent `FS_LBS` change (March 2025) made it easier to trigger but
  the underlying issue predates it

**Dependencies:**
- The fix is standalone and uses existing kernel APIs
- No other patches required for backport
- `sb_min_blocksize()` has been available since at least 2.6.x

**YES**

 fs/ntfs3/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index ddff94c091b8c..e6c0908e27c29 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -933,6 +933,11 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 
 	sbi->volume.blocks = dev_size >> PAGE_SHIFT;
 
+	/* Set dummy blocksize to read boot_block. */
+	if (!sb_min_blocksize(sb, PAGE_SIZE)) {
+		return -EINVAL;
+	}
+
 read_boot:
 	bh = ntfs_bread(sb, boot_block);
 	if (!bh)
-- 
2.51.0

