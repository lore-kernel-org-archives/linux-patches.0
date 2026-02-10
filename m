Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F252DC76F;
	Tue, 10 Feb 2026 23:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766321; cv=none; b=rT+VMZs61ohB1qZjlo4ilPPaU7IMq1c9v72FXuOvwg1+YC3+odR+jWX1LJFn/E98bfcdbUDOqjnYi0kXE9q0kbFV5l2jw5eRhreyh1toVEaJOm6ZDnrxTjRJFJsurOPL5wmXBL3xtZMO0leaUFyc7Pf4eteX0dNgSGMSm4mKZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766321; c=relaxed/simple;
	bh=SBo6Ip6zL7CuuAgpcphvuJ//YLD9xP6ZS8NtBlTW6CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzPTxOLHG0Zi/dNox3v28cZAa9Ce744yN91DidL0uDRmayv9ifS9qt5WtrE2SoKQqkyOuB8FFiQNUL2d6ChIGiXU/zshBOMsxQg+jDBWz2kL+hLLDlglFA3SQPaYhOojRvhbduijSb0MHH61tuifMth8k6HoDmooE2N7DK7OfzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuEXAMHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuEXAMHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637C5C19423;
	Tue, 10 Feb 2026 23:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766321;
	bh=SBo6Ip6zL7CuuAgpcphvuJ//YLD9xP6ZS8NtBlTW6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuEXAMHVyFeBIp+0A3CE7lAfqe6cThzLq0kNjlRKE1MsO9L6Dkwg1F0sLo+e3KV08
	 3DjtG9aV5B7NvPfKd2q9IcZNAwc4wiwnCYXB1sR9OcpkCF/udJzIxTl2eGQ1tf10Fd
	 wS4vUsOY5Bp+1v2bfGGhffYj5vZwaIjwrqhsMck3IJpcHiYAElzxUn4qlVctm+X5FE
	 MGi73hGla/qRR69TmXNb0dxtABekZoupS+0ajVEq+Ej95D7I3LF1VwRlFc4fHfN7Ci
	 W1uHTx/TX+hIxBlmzpHcyDLN2WiAN4u2Nai5akOOGogpu5ejjJT/7MfModHQoZop2C
	 f/sgG7tD/Kiig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	Jan Kara <jack@suse.cz>,
	syzbot+5ad0824204c7bf9b67f2@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	penguin-kernel@I-love.SAKURA.ne.jp,
	mjguzik@gmail.com,
	chentaotao@didiglobal.com
Subject: [PATCH AUTOSEL 6.19-5.10] minix: Add required sanity checking to minix_check_superblock()
Date: Tue, 10 Feb 2026 18:31:09 -0500
Message-ID: <20260210233123.2905307-24-sashal@kernel.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit 8c97a6ddc95690a938ded44b4e3202f03f15078c ]

The fs/minix implementation of the minix filesystem does not currently
support any other value for s_log_zone_size than 0. This is also the
only value supported in util-linux; see mkfs.minix.c line 511. In
addition, this patch adds some sanity checking for the other minix
superblock fields, and moves the minix_blocks_needed() checks for the
zmap and imap also to minix_check_super_block().

This also closes a related syzbot bug report.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20251208153947.108343-1-jkoolstra@xs4all.nl
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: syzbot+5ad0824204c7bf9b67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ad0824204c7bf9b67f2
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the comprehensive analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly states it adds "required sanity checking" for
the minix superblock, specifically:
- Validates `s_log_zone_size == 0` (only supported value)
- Adds validation for `s_ninodes`, `s_firstdatazone`, and zone/inode map
  block counts
- Moves existing `minix_blocks_needed()` checks from
  `minix_fill_super()` to `minix_check_superblock()` (earlier
  validation)
- Explicitly closes a **syzbot bug report** with a C reproducer

Key trust indicators:
- **Reported-by: syzbot** - fuzzer-found, reproducible bug with a
  concrete C reproducer
- **Reviewed-by: Jan Kara** - experienced filesystem developer at SUSE
- **Signed-off-by: Christian Brauner** - VFS maintainer
- The syzbot bug has been open for **1521+ days** (since Dec 2021),
  demonstrating a long-standing issue

### 2. CODE CHANGE ANALYSIS

**The root cause bug**: In `minix_statfs()` at line 415:

```415:415:fs/minix/inode.c
        buf->f_blocks = (sbi->s_nzones - sbi->s_firstdatazone) <<
sbi->s_log_zone_size;
```

The `s_log_zone_size` field is read directly from the on-disk superblock
(`__u16` type, values 0-65535) and stored in `sbi->s_log_zone_size`
(unsigned long) **without any validation**. When a crafted/corrupt minix
image provides a large value (e.g., 768, as shown in the syzbot crash),
this causes a UBSAN shift-out-of-bounds because the shift exponent
exceeds 64 bits.

The same vulnerability also exists in `minix_count_free_blocks()` in
`bitmap.c`:

```102:103:fs/minix/bitmap.c
        return (count_free(sbi->s_zmap, sb->s_blocksize, bits)
                << sbi->s_log_zone_size);
```

Additionally, `sbi->s_nzones - sbi->s_firstdatazone` can **underflow**
(unsigned subtraction wrapping around) if `s_firstdatazone >= s_nzones`,
affecting both `minix_statfs()` and `minix_count_free_blocks()`.

**What the fix does (line by line)**:

1. **Validates `s_log_zone_size == 0`**: The Linux minix implementation
   doesn't support zone sizes different from block sizes. This is
   consistent with `mkfs.minix` in util-linux. This single check
   prevents the UBSAN shift-out-of-bounds.

2. **Validates `s_ninodes >= 1`**: Prevents issues with zero-inode
   filesystems.

3. **Validates `s_firstdatazone > 4`**: The minimum layout of a minix FS
   requires: boot block (0), superblock (1), at least 1 imap block (2),
   at least 1 zmap block (3), at least 1 inode table block (4), so first
   data zone must be >= 5.

4. **Validates `s_firstdatazone < s_nzones`**: Prevents unsigned
   underflow in `s_nzones - s_firstdatazone` used in multiple places.

5. **Moves `minix_blocks_needed()` checks earlier**: Moves existing
   imap/zmap block validation from after bitmap buffer allocation (in
   `minix_fill_super()`) to before allocation (in
   `minix_check_superblock()`). This is an improvement because it
   rejects bad images before doing unnecessary I/O (sb_bread calls for
   bitmap blocks).

6. **Removes the old `s_imap_blocks == 0 || s_zmap_blocks == 0` check**:
   This is subsumed by the new `minix_blocks_needed()` checks — if
   either block count is 0 while `s_ninodes >= 1`, the blocks_needed
   check will catch it.

### 3. CLASSIFICATION

This is clearly a **bug fix** — specifically a UBSAN: shift-out-of-
bounds fix triggered by crafted filesystem images. It also fixes
potential unsigned integer underflow. There are zero new features.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 29 additions, 21 deletions — **small and
  contained**
- **Files touched**: 1 file (`fs/minix/inode.c`)
- **Complexity**: Low — all changes are straightforward value
  comparisons
- **Risk of regression**: Very low — the changes only add validation at
  mount time. A valid minix filesystem would pass all checks. A
  filesystem rejected by these checks was always corrupt/invalid.
- **Subsystem**: minix filesystem — mature, rarely modified, not in a
  hot development path

### 5. USER IMPACT

- **Severity**: UBSAN/undefined behavior triggered from userspace (mount
  syscall with crafted image)
- **Attack surface**: Any user who can mount a minix filesystem (often
  root, but in some configurations could be unprivileged)
- **Syzbot confirmed affected stable trees**: linux-5.15 and linux-6.1
  both have the same bug (syzbot "Similar bugs" section shows them as
  unpatched: "0/3")
- **Reproducible**: Yes, syzbot provides a C reproducer
- **Duration**: The bug has been open since December 2021 — over 4 years

### 6. STABILITY INDICATORS

- Reviewed-by: Jan Kara (experienced FS developer)
- Signed-off-by: Christian Brauner (VFS maintainer)
- Tested by syzbot (patch testing returned OK)
- The commit has been in mainline since the 6.19 merge window

### 7. DEPENDENCY CHECK

- `minix_check_superblock()` was introduced in commit 270ef41094e9f (Aug
  2020, with `Cc: stable`), so it **exists in all current stable
  trees**.
- The function signature was changed to `struct super_block *sb` in
  32ac86efff91a (also Aug 2020, also in stable), so the same signature
  is used everywhere.
- `minix_blocks_needed()` has existed since 2011 (commit 016e8d44bc06d).
- The mount API conversion (7cd7bfe593287, Mar 2024) may mean older
  stable trees (5.15, 6.1, 6.6) need minor context adjustments, but the
  core changes to `minix_check_superblock()` apply cleanly regardless.
- **No other commits are needed** — this is fully self-contained.

### 8. CONCLUSION

This commit fixes a **long-standing syzbot-reported UBSAN bug** (1521+
days old) in the minix filesystem's superblock validation. The bug is
triggered by crafted filesystem images and causes undefined behavior
(shift-out-of-bounds) that is reproducible with a C reproducer. The fix
is small (29 additions, 21 deletions in 1 file), self-contained,
obviously correct, reviewed by an experienced FS developer, and signed
off by the VFS maintainer. The affected code exists in all stable trees,
and syzbot confirms the bug is present and unfixed in at least
linux-5.15 and linux-6.1. The risk of regression is minimal since the
changes only reject invalid filesystem images at mount time. This is a
textbook stable backport candidate.

**YES**

 fs/minix/inode.c | 50 ++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 51ea9bdc813f7..c8c6b2135abe7 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -170,10 +170,38 @@ static int minix_reconfigure(struct fs_context *fc)
 static bool minix_check_superblock(struct super_block *sb)
 {
 	struct minix_sb_info *sbi = minix_sb(sb);
+	unsigned long block;
 
-	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
+	if (sbi->s_log_zone_size != 0) {
+		printk("minix-fs error: zone size must equal block size. "
+		       "s_log_zone_size > 0 is not supported.\n");
+		return false;
+	}
+
+	if (sbi->s_ninodes < 1 || sbi->s_firstdatazone <= 4 ||
+	    sbi->s_firstdatazone >= sbi->s_nzones)
 		return false;
 
+	/* Apparently minix can create filesystems that allocate more blocks for
+	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
+	 * create one with not enough blocks and bail out if so.
+	 */
+	block = minix_blocks_needed(sbi->s_ninodes, sb->s_blocksize);
+	if (sbi->s_imap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+		       "imap blocks allocated. Refusing to mount.\n");
+		return false;
+	}
+
+	block = minix_blocks_needed(
+			(sbi->s_nzones - sbi->s_firstdatazone + 1),
+			sb->s_blocksize);
+	if (sbi->s_zmap_blocks < block) {
+		printk("MINIX-fs: file system does not have enough "
+		       "zmap blocks allocated. Refusing to mount.\n");
+		return false;
+	}
+
 	/*
 	 * s_max_size must not exceed the block mapping limitation.  This check
 	 * is only needed for V1 filesystems, since V2/V3 support an extra level
@@ -293,26 +321,6 @@ static int minix_fill_super(struct super_block *s, struct fs_context *fc)
 	minix_set_bit(0,sbi->s_imap[0]->b_data);
 	minix_set_bit(0,sbi->s_zmap[0]->b_data);
 
-	/* Apparently minix can create filesystems that allocate more blocks for
-	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
-	 * create one with not enough blocks and bail out if so.
-	 */
-	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
-	if (sbi->s_imap_blocks < block) {
-		printk("MINIX-fs: file system does not have enough "
-				"imap blocks allocated.  Refusing to mount.\n");
-		goto out_no_bitmap;
-	}
-
-	block = minix_blocks_needed(
-			(sbi->s_nzones - sbi->s_firstdatazone + 1),
-			s->s_blocksize);
-	if (sbi->s_zmap_blocks < block) {
-		printk("MINIX-fs: file system does not have enough "
-				"zmap blocks allocated.  Refusing to mount.\n");
-		goto out_no_bitmap;
-	}
-
 	/* set up enough so that it can read an inode */
 	s->s_op = &minix_sops;
 	s->s_time_min = 0;
-- 
2.51.0

