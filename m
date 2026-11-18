Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047178;
	b=46tXTeXev6HJ69TdQuPaNq3kSgwGBVFPb61DnrJCE4WXO4mI1Bpv12nfN9Jq5jAS4xjO
	 znFCxpY35bgFPw8JjVgpTDQEnUplZfm7zSRrayYJYGwS4VD8NEFKQTHAU0CJgio+IYtpC
	 6Rf3TleqFWR3x8/WTo2ocjPvykHKiBf/+bYDlJWL3YhEzj5Q/g2uLhgt5fDfslWV5WQPA
	 HLiLxkwjmH3dvXcH6TrTSEyPuQX1qDqJTUGymxK+cY20O0I5HjTxMvyE3OWtQyMVM+hN7
	 GpQRo4hYCLFFbTZQKpN3OMzCsyaKImlj/nqWVkhM9nt2LCqQ2QSz+bAz95nzgk92i+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sHzZJUILxpA8yoO0lMrJ+EMkmn+wpC7zJqALkZUem6Y=;
	b=wRgIRVvr4CMITU7+pw3FHcA5CybWjyX1o/zXtnAJMB2N5eLS9VR6Pgm42iRod3g/yEvy
	 NYZ1PJBqOUJvapMXl1b+BNf1yK0+6gJTHU46His3UeiKUECjZhvoTtwqRsmeYI2MPndui
	 FJq4krIl/sfOS+HroHw84sLpB8cdVg2K3NWDo6w4DS/ETRzN9RnAwZwcucX2vizLtPpmQ
	 gQfLGmLjWREQ8qwUbMVPVTu7deksykKWZOQlbhBxaWARRstgUr7C2uCE33Muu5sfYf+rw
	 D0P+veUzpr06kvBFglKpF93hn8b9yXHyQggFnVqdq8r5a1tX16e40TBQzoxI5k/Cuog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4nQzN1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D4606A33A;
	Thu, 19 Nov 2026 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4nQzN1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A031F000C6;
	Thu, 19 Nov 2026 00:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047178;
	bh=sHzZJUILxpA8yoO0lMrJ+EMkmn+wpC7zJqALkZUem6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4nQzN1ggAWA4LxNZDJ59BssOTYVeR8NnAhRJO9lXkTG4l33rD8/j617TEMNm8tpv
	 r/H6ey/XY9p96c3MpuMSlvEE31DAoV/A94kPxp2tuDiVUgFwFTcBAi9iBeXjfANSsM
	 0gzy6Ta18h2yODsK6erygibcZ8iXuR0xlkHfF6YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiu-Hsien Lee <swinds24@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1545/2857] ext4: fix fast commit replay failing on a read-only mount
Date: Wed, 18 Nov 2026 15:42:59 +0100
Message-ID: <20261118150256.955328481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiu-Hsien Lee <swinds24@gmail.com>

[ Upstream commit e1a881ea4674876721cab97680d1d8308f90e9a4 ]

A filesystem with fast_commit that needs recovery cannot be mounted
read-only:

  EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
  EXT4-fs (dm-0): write access will be enabled during recovery
  WARNING: CPU: 22 PID: 5544 at fs/ext4/ext4_jbd2.c:73
   ext4_journal_check_start
   __ext4_journal_start_sb
   __ext4_unlink
   ext4_fc_replay
   do_one_pass
   jbd2_journal_recover
   jbd2_journal_load
   __ext4_fill_super
  JBD2: journal recovery failed
  EXT4-fs (dm-0): error loading journal

Fast commit replay runs ext4 metadata operations instead of writing
blocks through the buffer cache: ext4_fc_replay_{unlink,link,create}()
reach __ext4_unlink() and __ext4_link(), which start a handle.
ext4_journal_check_start() returns -EROFS on a read-only sb, and as
that is not -ENOENT it propagates out of jbd2_journal_recover() and
kills the whole recovery.  The EXT4_FC_REPLAY check that would hand
out a no-journal handle sits after the sb_rdonly() test, so replay can
never complete read-only.

ext4_load_journal() has already promised that write access will be
enabled during recovery, so make that true for the superblock as well:
clear SB_RDONLY across jbd2_journal_load() when recovery is needed on a
read-only mount and the devices are writable, as ext4_orphan_cleanup()
does.  Unlike ext4_handle_error(), which avoids SB_RDONLY because it
would need s_umount, the sb here is still inside ext4_fill_super() and
not published, so nothing can observe it.

The failure is not clean either: the replay handlers passing a NULL
handle (ext4_fc_replay_inode(), _add_range(), _del_range()) never hit
ext4_journal_check_start() and do write, leaving a partially applied
fast commit behind.

Reproducer, where the unlink only ever reaches the fast commit area:

  mke2fs -q -F -t ext4 -O fast_commit -b 4096 /dev/sdb3 262144
  mount /dev/sdb3 /mnt
  dd if=/dev/zero of=/mnt/victim bs=4k count=1 conv=fsync
  sync                          # victim now in a full commit
  rm /mnt/victim
  dd if=/dev/zero of=/mnt/trigger bs=4k count=1 conv=fsync
  <crash, or snapshot the device while mounted and write it back>
  mount -o ro /dev/sdb3 /mnt

Without this patch that mount fails; with it recovery completes and
victim is gone, i.e. the UNLINK record was really replayed.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260812044353.1018268-1-swinds24@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e4d305a03116b..17e116f69b351 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5937,6 +5937,7 @@ static int ext4_load_journal(struct super_block *sb,
 	int err = 0;
 	int really_read_only;
 	int journal_dev_ro;
+	bool enable_write = false;
 
 	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
 		return -EFSCORRUPTED;
@@ -5993,6 +5994,7 @@ static int ext4_load_journal(struct super_block *sb,
 			}
 			ext4_msg(sb, KERN_INFO, "write access will "
 			       "be enabled during recovery");
+			enable_write = true;
 		}
 	}
 
@@ -6009,7 +6011,19 @@ static int ext4_load_journal(struct super_block *sb,
 		if (save)
 			memcpy(save, ((char *) es) +
 			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
+		/*
+		 * Fast commit replay performs regular ext4 metadata updates
+		 * (see ext4_fc_replay()) which refuse to run on a read-only
+		 * superblock.  We promised write access above, so make that
+		 * true for the duration of the recovery, the same way
+		 * ext4_orphan_cleanup() does.  The superblock is not published
+		 * yet, so nothing can observe the transient state.
+		 */
+		if (enable_write)
+			sb->s_flags &= ~SB_RDONLY;
 		err = jbd2_journal_load(journal);
+		if (enable_write)
+			sb->s_flags |= SB_RDONLY;
 		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
 				   save, EXT4_S_ERR_LEN)) {
 			memcpy(((char *) es) + EXT4_S_ERR_START,
-- 
2.53.0



