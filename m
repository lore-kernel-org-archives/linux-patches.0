Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FD63B2FD8;
	Sat, 17 Oct 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259278; cv=none; b=TwRUHwnZcQDJyN6XjrGGVDUBBADxXf8KQc3c/sRCQgtFWngJGOXi6O9TuEC+CZHVOL022slh9f5gv2PvteIYM1Uz4dx+p5FlspQTNKIxmhvx3ckqJFs+A4+l0SPuFTFnMFolDTmewsvZEIaGdV5IydkdxVNoK7mtlC4Ek8s4u9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259278; c=relaxed/simple;
	bh=xBP42CYxRnEu9og0KM6wmvLHOzn/DPLauMVI+aPqjMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQ+EQdl8Cgr0gytPTUxpsQ5epLqNIDZatGiqPN8IBLQZ73vUCIcLR2JYLYPyQqTJ8cDix2gFWFTiCOMlvtU8useAK1q6Y9p6riXBvIy7GC4dFJaG6czQgX0KaiG7Vm+5ealVQ7QE998AkuXnC+shySPPmzrcgL8WVbKFPpPeShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMmyhjQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMmyhjQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCE41F000C4;
	Sat, 17 Oct 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259277;
	bh=R2UhIB9oItK/E2WlD3tqjiV8DABsKfLClrdg6kzQhwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMmyhjQR2ADclM9iqdaNf69B1cCelJ/Lxn7c7M1BejQOQa1DNeVaNMg9JZ5f9N+YJ
	 v9m0KSHog1fHCRxl3nkRovCjk8Nr1R3Ry3UqqgfQvgBa7Rc7CIpfAdRsbBh1MW6Dpb
	 Pyz5fwlQwuvUdu9UySM0u3vBh9Nb+V7aO5c0UzZA=
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
Subject: [PATCH 6.6 1161/1674] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Sat, 17 Oct 2026 17:57:13 +0200
Message-ID: <20261017160500.950840855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ext4/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e27eae7f163df..242974bf3c0aa 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1373,6 +1373,11 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto mext_out;
 		}
 
+		if (file_inode(filp)->i_sb != file_inode(donor.file)->i_sb) {
+			err = -EXDEV;
+			goto mext_out;
+		}
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			goto mext_out;
-- 
2.53.0



