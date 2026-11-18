Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047175;
	b=V+KQL1au/lxiyrtXxSjSFJn6RG9d3opk4Bz8x6xNH8aw3kxXCsPPG9OK7tU8ti5ou9pu
	 Z22NGPkhIHqLFf/J+BCTYbVCLZTV7s0+FKtJF2S+e58yKLQ5C8V1gon2kNbYSlcfJuuRS
	 /1UjWEXAqdE3jJXgu6FEitq4pi8btYh0GxlnRNQ1vKOTyatYgftVC1eC6MKfmtcrEjzMA
	 6aqyq1rcqc/IoUZkL3OOzwDtA/3rdciixSimdYrtyhpFo1FfplFREJAmZbo6rrSyyw+NZ
	 7QqnAoumySIe+e+H/dNGe6BH3QsZYZsX/ls9XaLAjOzkrtSKUHpGKIoIczyc0fLvQ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuxZJleSCimPABGnwQcgHXV5FtIAjkTdrxcjEWlx1cI=;
	b=ESX7HSzYM3r9enWX+43YB9Xdp0V9y4ThhejptUDrSHzuTcZhmk8rq89BjlK6Pf+h9xjx
	 Mjj0ymf3wyXvgoPCLA+2WCYspB8LZtBbpiEvoByTytOAXNZ8Ew1BRPEzJbMBBfh85xIqn
	 sK7EVHBfK1K62Z/g7Ii2K/izPhAQcByYCkNE9gtNbRjY9rty+6R1fZ6L/HnEyqs2HOfpy
	 fPdfix9vJ572pFUXHYL/lBzIT0YwAgTwCkxpjKPYc+T8k6DCeynBDHHRpxChvqlnsVFMy
	 JDRto+pGw06Kz5p0wj3wSjlehCBqKh/g8OXdCwKGqjl3+fur61F8bNt9UO3356hB1Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZLrzEqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED58606A325;
	Thu, 19 Nov 2026 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZLrzEqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6F51F000C5;
	Thu, 19 Nov 2026 00:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047175;
	bh=cuxZJleSCimPABGnwQcgHXV5FtIAjkTdrxcjEWlx1cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZLrzEqsNEGENC2jlEBzbi/AXnYd1Zx3iK/XOb7QRQofrIUFLIoO8TnVlF2gSgM6k
	 uj9VT+y6rg2BgZYeM9AjPzn2nXmbwvAMTYWbAsDy1xX/QPSgoKgQhWC5gU22eR49MB
	 Hx7yKXEk8kXtT5+jkWEI9pFEMu5olTN9enmUSmRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sean Greenslade <sean@seangreenslade.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1544/2857] ext4: avoid updating the superblock on a r/o mount if not needed
Date: Wed, 18 Nov 2026 15:42:58 +0100
Message-ID: <20261118150256.919164301@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 2ef6c32a914b85217b44a0a2418e830e520b085e ]

This was noticed by a user who noticied that the mtime of a file
backing a loopback device was getting bumped when the loopback device
is mounted read/only.  Note: This doesn't show up when doing a
loopback mount of a file directly, via "mount -o ro /tmp/foo.img
/mnt", since the loop device is set read-only when mount automatically
creates loop device.  However, this is noticeable for a LUKS loop
device like this:

% cryptsetup luksOpen /tmp/foo.img test
% mount -o ro /dev/loop0 /mnt ; umount /mnt

or, if LUKS is not in use, if the user manually creates the loop
device like this:

% losetup /dev/loop0 /tmp/foo.img
% mount -o ro /dev/loop0 /mnt ; umount /mnt

The modified mtime causes rsync to do a rolling checksum scan of the
file on the local and remote side, incrementally increasing the time
to rsync the not-modified-but-touched image file.

Fixes: eee00237fa5e ("ext4: commit super block if fs record error when journal record without error")
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/ZIauBR7YiV3rVAHL@glitch
Reported-by: Sean Greenslade <sean@seangreenslade.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: e1a881ea4674 ("ext4: fix fast commit replay failing on a read-only mount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fee5438e2cf08..e4d305a03116b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6003,19 +6003,27 @@ static int ext4_load_journal(struct super_block *sb,
 		err = jbd2_journal_wipe(journal, !really_read_only);
 	if (!err) {
 		char *save = kmalloc(EXT4_S_ERR_LEN, GFP_KERNEL);
+		__le16 orig_state;
+		bool changed = false;
 
 		if (save)
 			memcpy(save, ((char *) es) +
 			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
 		err = jbd2_journal_load(journal);
-		if (save)
+		if (save && memcmp(((char *) es) + EXT4_S_ERR_START,
+				   save, EXT4_S_ERR_LEN)) {
 			memcpy(((char *) es) + EXT4_S_ERR_START,
 			       save, EXT4_S_ERR_LEN);
+			changed = true;
+		}
 		kfree(save);
+		orig_state = es->s_state;
 		es->s_state |= cpu_to_le16(EXT4_SB(sb)->s_mount_state &
 					   EXT4_ERROR_FS);
+		if (orig_state != es->s_state)
+			changed = true;
 		/* Write out restored error information to the superblock */
-		if (!bdev_read_only(sb->s_bdev)) {
+		if (changed && !really_read_only) {
 			int err2;
 			err2 = ext4_commit_super(sb);
 			err = err ? : err2;
-- 
2.53.0



