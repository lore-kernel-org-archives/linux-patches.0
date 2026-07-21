Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E9446F499;
	Tue, 21 Jul 2026 19:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662084; cv=none; b=NBsrnOde5nqsLSD/x1D2gK+g5D7CMh9yW31uS1cOYgItmNBw5hrS9hHUi4FsiIuahq3hQX9W4UF7XAtEtSXW9JK+cNmHGRCEJfIv96jMn1k/JYLu9+hqeOgDFpq1g1TMvFnDnnaUeaSxVSA+M2T5z29OgLY8my/AR5BYEKkAdIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662084; c=relaxed/simple;
	bh=LRSVsMoyapdTrKmbDmJxX0achR/EQSBXjD7W0NRdPxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXTSsXjj20vWBlMJUpkL+qzEcgm0jqqz5nF8xQ3qdYssI8E2eAn+9+VySyrCU/gY+HMnNJdFwjXfBIM9373kpD7DTdVGXfvQk8rHsCAosD6bzKCR+7kkjGnYC05ZTPAXxX07PMb4h+0KAsb4kTmYA/qCkSVI4EyHr/4/JbzJgfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Brp3Lwmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Brp3Lwmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FE71F000E9;
	Tue, 21 Jul 2026 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662082;
	bh=APTxwH6QhlMVKgXdg7+uOaKcKNf3xeaqBLDY7a6Nmcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Brp3LwmxrpPBr86/eM6JE7kFJxpbW36jTlxx6cQRSK7YapurbD5n74VAz7kJ2SbzH
	 258FWvuDvu9BXtMBfMOSsFksWFzGacXA9GwAIG/0DnbPhKl3WbOVNorrFYtqIU5EvB
	 lK+sLLD+fY+xjS4calA8mAEktxsPKMYWa2ci+f4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0309/1276] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Tue, 21 Jul 2026 17:12:32 +0200
Message-ID: <20260721152453.007613078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit c143957520c6c9b5cd72e0de8b52b814f0c576fe ]

Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
belong to the same superblock as the original file.  Currently, this
validation is performed inside ext4_move_extents() by
mext_check_validity(), but only after lock_two_nondirectories() has
already acquired the inode locks.  When the donor fd refers to a file
on a different filesystem (e.g., overlayfs), this late validation
creates a circular lock dependency:

  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
  ----                              ----
  inode_lock(ovl_inode)
                                    mnt_want_write_file(filp)
                                      sb_start_write(ext4_sb)   [sb_writers]
    backing_file_write_iter()
      vfs_iter_write(real_file)
        file_start_write(real_file)
          sb_start_write(ext4_sb)   [blocked by freeze]
                                    lock_two_nondirectories()
                                      inode_lock(ovl_inode)     [blocked]

With a concurrent freeze operation holding sb_writers write side, this
forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.

Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
it fundamentally requires both files to reside on the same ext4
filesystem.  Moving the superblock check before any lock acquisition
is both semantically correct and eliminates the circular dependency
by ensuring that cross-filesystem donor fds are rejected before
sb_writers or inode locks are taken.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c3758c64fc4e03..a8a024bb62b4f7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1372,6 +1372,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto mext_out;
 		}
 
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
+			return -EXDEV;
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			goto mext_out;
-- 
2.53.0



