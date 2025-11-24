Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087952EB847;
	Mon, 24 Nov 2025 08:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971643; cv=none; b=j6tLAk3Ht1ouNikc9JwTwgxU6Uduom1zoNLdaYi8orQvqFAheylJiPg/0Nd9CPN4JdbuKWcM54cymquZVHpSxdInwkvWEqW6D/Zj5m2nWWKL4snRslOHYL2wm4K2X4dWSzdSqJXS0tjPE190yCscpny1MAA8HyyLt9EezLd8QFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971643; c=relaxed/simple;
	bh=Xas3JP4IADJMP8+4+q5VvnvwuatgWitTieRvkxIecEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjC3eN/vGdvgYLOZSR1TcGIU4LaqYuJ4IFSYtmeE+oYHKTgct4kY7lErx0Wi+XImSux5aCtXI8FmIvOugLgdV8+dTVrWhdsFQ4rrWMZk2xkLxpno7lNht6rlG3RiQJJWgVqO7j6N8MgI5BkjR/MFEqSnu1KoroJ7aVk4dPDzJZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckG6HYOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckG6HYOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C5FC116D0;
	Mon, 24 Nov 2025 08:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971642;
	bh=Xas3JP4IADJMP8+4+q5VvnvwuatgWitTieRvkxIecEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckG6HYOSDJ9cNjclZiGAHx9/cX7G+hE9BENhsTN4Knf919jog1+dHsq1plRHD2mRH
	 nPkYSY4jVTHtRt8jh2y5rKD7d0I3goUEw6dfJEk3uI3Z+E7V8SuCck6QZG2BvrCpvN
	 /v32H2qGIFmlFBHh/dsxobWSyRv4EKTqvuJ/qm/GQH5tyBB3XpBSHd6bsaqlZ5NA+D
	 Ghu0j4IFVeiVpcBgT+OdR9D72LgXkB+8WRzqIfeGb23SxbhFDNyDziC7ppvnvoD5c7
	 dtwu9fw34InkCzN2xvFrJorIYqCGhWbe0Eq4uxEnURLMIBrDYop9Lva7y2IjEcJpzB
	 XdXbRlQTz09pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] bfs: Reconstruct file type when loading from disk
Date: Mon, 24 Nov 2025 03:06:35 -0500
Message-ID: <20251124080644.3871678-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 34ab4c75588c07cca12884f2bf6b0347c7a13872 ]

syzbot is reporting that S_IFMT bits of inode->i_mode can become bogus when
the S_IFMT bits of the 32bits "mode" field loaded from disk are corrupted
or when the 32bits "attributes" field loaded from disk are corrupted.

A documentation says that BFS uses only lower 9 bits of the "mode" field.
But I can't find an explicit explanation that the unused upper 23 bits
(especially, the S_IFMT bits) are initialized with 0.

Therefore, ignore the S_IFMT bits of the "mode" field loaded from disk.
Also, verify that the value of the "attributes" field loaded from disk is
either BFS_VREG or BFS_VDIR (because BFS supports only regular files and
the root directory).

Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patch.msgid.link/fabce673-d5b9-4038-8287-0fd65d80203b@I-love.SAKURA.ne.jp
Reviewed-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

1. **COMMIT MESSAGE ANALYSIS**
   - **Problem:** A syzbot report identified a bug where `inode->i_mode`
     could contain bogus `S_IFMT` (file type) bits. This occurs because
     the kernel was trusting the upper bits of the 32-bit on-disk `mode`
     field. If these bits contained garbage (which is possible as BFS
     historically only utilized the lower 9 bits), they would conflict
     with the actual file type determined by the `i_vtype` attribute.
   - **Fix:** The patch ignores the `S_IFMT` bits from the on-disk
     `mode` by narrowing the mask from `0xFFFF` to `0x0FFF`. It then
     reconstructs the correct file type solely from `di->i_vtype` and
     adds validation to ensure `i_vtype` is a known type (`BFS_VREG` or
     `BFS_VDIR`).
   - **Stable Signals:** Fixes a reported bug (syzbot), handles
     corrupted input (security hardening), small surgical fix.
   - **Missing Signals:** No `Cc: stable` or `Fixes` tag, but the commit
     addresses a vulnerability found by fuzzing, which typically
     qualifies for stable backporting.

2. **DEEP CODE RESEARCH**
   - **File:** `fs/bfs/inode.c`, function `bfs_iget`.
   - **Root Cause:**
     The original code used a mask of `0x0000FFFF`:
     ```c
     inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
     if (le32_to_cpu(di->i_vtype) == BFS_VDIR)
     inode->i_mode |= S_IFDIR;
     ```
     The `S_IFMT` mask in Linux corresponds to the bits `0xF000` (octal
     `0170000`). By preserving these bits from the disk and then ORing
     in the type (`S_IFDIR`), the code could result in a mixed, invalid
     file type if the disk data was not clean (e.g., `S_IFLNK |
     S_IFDIR`).
   - **The Fix:**
     The new code uses a mask of `0x00000FFF`:
     ```c
     inode->i_mode = 0x00000FFF & le32_to_cpu(di->i_mode);
     ```
     This strictly clears the file type bits before setting them based
     on the authoritative `i_vtype`. It also adds necessary error
     handling:
     ```c
     } else {
     brelse(bh);
     printf("Unknown vtype=%u...\n", ...);
     goto error;
     }
     ```
     This ensures that if the authoritative type is unknown, the
     operation fails safely rather than proceeding with an invalid
     inode.

3. **STABLE KERNEL RULES ALIGNMENT**
   - **Obviously correct:** Yes. It applies standard input sanitization
     to untrusted disk data.
   - **Fixes real bug:** Yes. Prevents type confusion and potential
     crashes when mounting corrupted or malicious filesystem images
     (syzbot report).
   - **Important:** Yes. While BFS is a legacy filesystem, handling
     corrupted images gracefully is a standard security requirement for
     the kernel.
   - **Small and contained:** Yes. The change is isolated to ~20 lines
     in a single function in `fs/bfs/inode.c`.
   - **No new features:** Yes. This is purely a robustness fix.

4. **RISK VS BENEFIT**
   - **Benefit:** Prevents undefined behavior, crashes, or security
     issues arising from type confusion in the VFS layer.
   - **Risk:** Negligible. Valid BFS images will have correct `i_vtype`
     values and will work exactly as before. The change only affects how
     the kernel interprets potentially garbage data in unused bits.
   - **Dependencies:** None. The fix is self-contained and uses existing
     constants (`BFS_VDIR`, `BFS_VREG`).

5. **CONCLUSION**
  This commit is a classic input validation fix for a filesystem driver.
  It resolves a bug found by automated fuzzing (syzbot) where untrusted
  disk data was allowed to corrupt in-memory kernel structures
  (`inode->i_mode`). Even though BFS is a niche filesystem, preventing
  data corruption and crashes upon mount is a requirement for stable
  kernels. The fix is small, low-risk, and obviously correct.

**YES**

 fs/bfs/inode.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 1d41ce477df58..984b365df0460 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -61,7 +61,19 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
 	di = (struct bfs_inode *)bh->b_data + off;
 
-	inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
+	/*
+	 * https://martin.hinner.info/fs/bfs/bfs-structure.html explains that
+	 * BFS in SCO UnixWare environment used only lower 9 bits of di->i_mode
+	 * value. This means that, although bfs_write_inode() saves whole
+	 * inode->i_mode bits (which include S_IFMT bits and S_IS{UID,GID,VTX}
+	 * bits), middle 7 bits of di->i_mode value can be garbage when these
+	 * bits were not saved by bfs_write_inode().
+	 * Since we can't tell whether middle 7 bits are garbage, use only
+	 * lower 12 bits (i.e. tolerate S_IS{UID,GID,VTX} bits possibly being
+	 * garbage) and reconstruct S_IFMT bits for Linux environment from
+	 * di->i_vtype value.
+	 */
+	inode->i_mode = 0x00000FFF & le32_to_cpu(di->i_mode);
 	if (le32_to_cpu(di->i_vtype) == BFS_VDIR) {
 		inode->i_mode |= S_IFDIR;
 		inode->i_op = &bfs_dir_inops;
@@ -71,6 +83,11 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &bfs_file_inops;
 		inode->i_fop = &bfs_file_operations;
 		inode->i_mapping->a_ops = &bfs_aops;
+	} else {
+		brelse(bh);
+		printf("Unknown vtype=%u %s:%08lx\n",
+		       le32_to_cpu(di->i_vtype), inode->i_sb->s_id, ino);
+		goto error;
 	}
 
 	BFS_I(inode)->i_sblock =  le32_to_cpu(di->i_sblock);
-- 
2.51.0

