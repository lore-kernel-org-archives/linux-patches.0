Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE37299948;
	Mon, 13 Oct 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367736; cv=none; b=Ejfa5g6DzGPCONpJvQ+Rg+38fCXUQavwdruMTXtojinr4wFJv9y0GbyaHMmhTTpX0pMqFy/rLD2Q/it3RH2U94hHTV2OlWQqKUWeLH0WHps0a3PtnSCd0wtOuTiqxlkd92FwL0ro9hbTPPe4cyqDhXEBwSCKVooUHuquqyh9DII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367736; c=relaxed/simple;
	bh=o76ZkAKGjwwOich42hTAb5srdrxbscIygpBr6LFSNuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWLBzw5x2qp2jf/hR6Er440QAYq5osDqFvcHzvWun3DPC4sMPqE5xuSdvuiMLjFMyjzjwM2s/k62PqVJ8vhFs7fjhULTcxX4TKyMr4BJy30gRXltTxmHDA4n1bloCybnnFnVBgNmo86wb06HCbg+ZaViWKE2YzJ8LVBHhdqUkT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgUL3X2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgUL3X2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77D2C4CEE7;
	Mon, 13 Oct 2025 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367736;
	bh=o76ZkAKGjwwOich42hTAb5srdrxbscIygpBr6LFSNuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgUL3X2ak08H0eY8bG9xsHRV22oWyqYcufIw4ROUgTfQbPQvdv2E9E+BKwpb2PWh/
	 8aizw21RJs4guavpd1Pi1EkwDjX75A2i8+nJrum8mebDEaShzYn/1yZllT5WlOmKjB
	 OcyDynKKB+iafI1+7qX1OHgORMvH67O9eLSFpGLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+90266696fe5daacebd35@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/196] f2fs: fix to truncate first page in error path of f2fs_truncate()
Date: Mon, 13 Oct 2025 16:45:07 +0200
Message-ID: <20251013144319.506808672@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 9251a9e6e871cb03c4714a18efa8f5d4a8818450 ]

syzbot reports a bug as below:

loop0: detected capacity change from 0 to 40427
F2FS-fs (loop0): Wrong SSA boundary, start(3584) end(4096) blocks(3072)
F2FS-fs (loop0): Can't find valid F2FS filesystem in 1th superblock
F2FS-fs (loop0): invalid crc value
F2FS-fs (loop0): f2fs_convert_inline_folio: corrupted inline inode ino=3, i_addr[0]:0x1601, run fsck to fix.
------------[ cut here ]------------
kernel BUG at fs/inode.c:753!
RIP: 0010:clear_inode+0x169/0x190 fs/inode.c:753
Call Trace:
 <TASK>
 evict+0x504/0x9c0 fs/inode.c:810
 f2fs_fill_super+0x5612/0x6fa0 fs/f2fs/super.c:5047
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

During f2fs_evict_inode(), clear_inode() detects that we missed to truncate
all page cache before destorying inode, that is because in below path, we
will create page #0 in cache, but missed to drop it in error path, let's fix
it.

- evict
 - f2fs_evict_inode
  - f2fs_truncate
   - f2fs_convert_inline_inode
    - f2fs_grab_cache_folio
    : create page #0 in cache
    - f2fs_convert_inline_folio
    : sanity check failed, return -EFSCORRUPTED
  - clear_inode detects that inode->i_data.nrpages is not zero

Fixes: 92dffd01790a ("f2fs: convert inline_data when i_size becomes large")
Reported-by: syzbot+90266696fe5daacebd35@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/68c09802.050a0220.3c6139.000e.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 031015823acb2..20d102009f715 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -844,8 +844,16 @@ int f2fs_truncate(struct inode *inode)
 	/* we should check inline_data size */
 	if (!f2fs_may_inline_data(inode)) {
 		err = f2fs_convert_inline_inode(inode);
-		if (err)
+		if (err) {
+			/*
+			 * Always truncate page #0 to avoid page cache
+			 * leak in evict() path.
+			 */
+			truncate_inode_pages_range(inode->i_mapping,
+					F2FS_BLK_TO_BYTES(0),
+					F2FS_BLK_END_BYTES(0));
 			return err;
+		}
 	}
 
 	err = f2fs_truncate_blocks(inode, i_size_read(inode), true);
-- 
2.51.0



