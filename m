Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86723D288;
	Sat, 25 Oct 2025 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409210; cv=none; b=k9sNFucU7jLhqNvZlWN4mgRlM4WdTdX5TNDH+HuzbInDZ+jxqjohzqNt8L7+rAnNdQ3Fdmyak7KQw0wrFwBaOD756cx+iMuUr03w7fbd/BQ4XUEUNVWp7MLRDwcguzysBcCBB0cjZpMQp8EgSCgeD7YgnF3YIccNlTfNm0rgQ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409210; c=relaxed/simple;
	bh=Azs5/WmDLV1h8jBKANAqoGYQS7sR47L8sRbriesti6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7n/TuDWHpYrZcQYZjlGrt0h7mZJf/sqCokgViXFvSTkSQ7U2I6kIsLfx2S6xh4o6YIWACSx63KLh6l33Ln46jkOXqV8wJerfTUhUlt/UZDa7IgqzI/jGX/VM6OcUul63DqRKpQ4WRbv1KTGGIQfqFPbZLW+UK0/ENa77seBBOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prW4GD0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prW4GD0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34535C4CEF5;
	Sat, 25 Oct 2025 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409210;
	bh=Azs5/WmDLV1h8jBKANAqoGYQS7sR47L8sRbriesti6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prW4GD0yp1qrBAMOTDJzSbMwUJjYeBYNC0YnYHSq6n3RRtH4Bl3Y5g9sZCbtXLd3j
	 iG9A56YUIvtR8R5kzqezgLfipFT+he/GagiFbZ58OVZ/DQYlXHO+ugf5RM8dBNC6ML
	 U/Fj2nqagxIOMmSybM0kG4q/BuMi0KOsb12ZTnIgIxZ6tBrzM3j/avOu1yc5CIsTR5
	 61XROhUeVkV+3UeEnDyNV6Rh0Xq89Jhjt9a93JaPQefkeQZV2jdeaqjZeYR5GoJ8uI
	 Hi0YJOMSuQKbW80q8JhGyorz6qOyuc2U4v5QS1yEvJd+mlYBNe/rGO22cS9G2Zqi4Z
	 aRob4oB4OFatQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	kovalev@altlinux.org,
	brauner@kernel.org,
	alexandre.f.demers@gmail.com,
	chentaotao@didiglobal.com,
	lizhi.xu@windriver.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-5.4] jfs: Verify inode mode when loading from disk
Date: Sat, 25 Oct 2025 11:57:54 -0400
Message-ID: <20251025160905.3857885-243-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7a5aa54fba2bd591b22b9b624e6baa9037276986 ]

The inode mode loaded from corrupted disk can be invalid. Do like what
commit 0a9e74051313 ("isofs: Verify inode mode when loading from disk")
does.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change bounds the special-file path in `jfs_iget()` to the four
  valid special inode classes (`S_ISCHR/S_ISBLK/S_ISFIFO/S_ISSOCK`)
  before calling `init_special_inode()` (`fs/jfs/inode.c:62-65`). That
  prevents invalid on-disk modes from silently flowing into
  `init_special_inode()`, which otherwise only emits a debug message and
  leaves `i_fop` unset (`fs/inode.c:2560-2583`), making later VFS
  operations trip over a `NULL` method table. Syzkaller already hit that
  crash scenario on corrupted metadata, so this is a real bug fix, not
  just hardening.
- When the mode is outside every legal class, the new branch logs the
  anomaly and fails the iget (`fs/jfs/inode.c:67-70`). Returning
  `ERR_PTR(-EIO)` is the standard idiom already used a few lines above
  for other `diRead()` failures (`fs/jfs/inode.c:34-38`), so callers
  such as `jfs_read_super()` and `jfs_lookup()` already expect and
  handle it. That turns a kernel crash into an I/O error, matching the
  stable tree goal of “don’t panic on corrupted media.”
- The patch is minimal and self-contained: it touches a single function,
  adds no new APIs, and mirrors the already-upstreamed isofs fix for the
  same syzbot report. Normal workloads (regular files, directories,
  symlinks, and well-formed special files) stay on their existing paths,
  so regression risk is negligible while the payoff is preventing a
  user-triggerable crash on damaged volumes—squarely within stable
  backport policy. Potential next step: queue it for all supported
  stable series that still carry the vulnerable code path.

 fs/jfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index fcedeb514e14a..21f3d029da7dd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -59,9 +59,15 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 			 */
 			inode->i_link[inode->i_size] = '\0';
 		}
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %lu.\n",
+		       inode->i_mode, inode->i_ino);
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	unlock_new_inode(inode);
 	return inode;
-- 
2.51.0

