Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCCE356A0D;
	Sat, 12 Sep 2026 10:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208073; cv=none; b=c3Nf5gsNbpwmOul3Sp9Bswej4ihd+Xo1k41Y3YOGUNHeibqyx3jISJAVCG2GWnPdN1FkfRgUhwhEx0FhhOFl5nTVR0B99EFk3DNKJlhkzTZjRMrpOWIMYYHOCkj7m8VjBmIqALx8j6RF39B+9jH3xpC9FD0ZG4EWWoyanc5YOHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208073; c=relaxed/simple;
	bh=h2A76TrmocHsR8Q2dJWtB5stGNe85vE2NAs1aIbZnKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAMflRmmwKEvA7SIFEejn2Lv4DdjEcH2tmgCOBFcGZsZffYFOIlC2i6CwPUBeaYDVpJ+fdoWbn0xS3dnaDoKV05011LQXjs0DkAXT+FxFr+2lTVj2VlmsZ+kGP1pF5AQDaH1T3YFcLBB+GfO9N4H6Bu9Cj33/fYUtadrRHTJQxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaPw6Kdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaPw6Kdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9472E1F000FF;
	Sat, 12 Sep 2026 10:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208072;
	bh=A4pO0HF8xT/+BPXyyyexlZWUVLxqIGsANbQLsjdMPyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaPw6KdlS16bm8XX1ur1ozNVb9Jud1qznJS8ONVZ479RUB0sjZCm8OeoScp+VM3Gc
	 hpQEQg1cCB0DZNYd0RL9NMGC1bjanq53zeHmIZRWMX76fN61qRkxggmuBTyNv5ZBZz
	 Of749EZMprp3j7Mo5lWPXOYv8wOLSdFDYB0EnLBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0542/1518] ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()
Date: Sat, 12 Sep 2026 08:45:11 +0200
Message-ID: <20260912065635.704188458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit c7e6b863d298f56522d0d08554bbea7f142e6588 ]

For casefolded encrypted directories ext4 stores an 8-byte hash trailer
after the name (EXT4_DIRENT_HASHES()), at an offset derived from
de->name_len.  On the sb_no_casefold_compat_fallback() path ext4_match()
reads that trailer, but ext4_search_dir()'s by-hand pre-check only tests
de->name + de->name_len <= dlimit, which proves the name fits, not the
rounded trailer.  A crafted entry whose name ends at the block boundary
passes the check while EXT4_DIRENT_HASHES(de) lands past the block end,
so ext4_match() reads out of bounds on an ordinary lookup.  KASAN reports
it as a use-after-free when the page after the directory block holds a
freed object:

  BUG: KASAN: use-after-free in ext4_match (fs/ext4/namei.c:1435)
  Read of size 4 at addr ffff888010458000 by task exploit
  Call Trace:
   ext4_match (fs/ext4/namei.c:1435)
   ext4_search_dir (fs/ext4/namei.c:1470)
   __ext4_find_entry (fs/ext4/namei.c:1268 fs/ext4/namei.c:1632)
   ext4_lookup (fs/ext4/namei.c:1703 fs/ext4/namei.c:1769)
   ...
   filename_lookup (fs/namei.c:2842)
   vfs_statx (fs/stat.c:353)
   __do_sys_newfstatat (fs/stat.c:538)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Require, for hash-in-dirent directories, that the whole entry including
the rounded trailer fits before calling ext4_match().  This is the same
bound ext4_check_dir_entry() already enforces via ext4_dir_rec_len(), so
no well-formed entry is rejected.  The other caller, ext4_find_dest_de(),
runs ext4_check_dir_entry() first and is unaffected.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260709184101.441348-1-xmei5@asu.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2e35453a56f28..2c661155158f8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1467,6 +1467,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if (de->name + de->name_len <= dlimit &&
+		    (!ext4_hash_in_dirent(dir) ||
+		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
-- 
2.53.0



