Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB81B424F;
	Sun,  7 Sep 2025 20:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276478; cv=none; b=jhfQT3uSDIp4QFjAWgYnYfDF6Afob245E1hDxkS9YM248X9rHdvI12om7w/HgLR+x6gnm/ByTxK1D5RJ/zUnI81e26mgDGvg5xj92PJMwdNLd47kG9cRRddTfLLol6Ko2SPzHexHx3ROTzN7iiOphNB+ykrtgDCXfDxubOJJHfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276478; c=relaxed/simple;
	bh=uPHazi7ST8e3CWC1XephXK9MNwarKgbkjR4XVX1FtLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6x/xz15wB1gAcCgQhO/anaU+9Is1vFbB9PRZIqtEO9aNd7g8TEKs9FV23RWWIqQnqUEXN5ktZOcfI6kVpVcA75TPC0wTnmU1zHvA4QENM+IygbE78ITZD/6XV06h9TUkLg5aGip/UMhFcdZT1ol3bl03Ck1Pa2E3aKKOD5CGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcXWOlAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcXWOlAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBEAC4CEF0;
	Sun,  7 Sep 2025 20:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276478;
	bh=uPHazi7ST8e3CWC1XephXK9MNwarKgbkjR4XVX1FtLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcXWOlACCkz7eRmUQQ16EnxqHaUfF8lAdkkwipe8owxSOvQLR5SIxQlh6EjT6qfnp
	 Ni4Cer2lKT8bFICxGiCr45k3a5m4ygCx+58FNcCd26tqYhTE7ZXQJvy7y1QlEFrWSH
	 6il1govARyUQDGXh/UtVrPPxTv7WVSxrOr7gqbb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiufei Xue <jiufei.xue@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/121] fs: writeback: fix use-after-free in __mark_inode_dirty()
Date: Sun,  7 Sep 2025 21:57:29 +0200
Message-ID: <20250907195610.153427506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiufei Xue <jiufei.xue@samsung.com>

[ Upstream commit d02d2c98d25793902f65803ab853b592c7a96b29 ]

An use-after-free issue occurred when __mark_inode_dirty() get the
bdi_writeback that was in the progress of switching.

CPU: 1 PID: 562 Comm: systemd-random- Not tainted 6.6.56-gb4403bd46a8e #1
......
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __mark_inode_dirty+0x124/0x418
lr : __mark_inode_dirty+0x118/0x418
sp : ffffffc08c9dbbc0
........
Call trace:
 __mark_inode_dirty+0x124/0x418
 generic_update_time+0x4c/0x60
 file_modified+0xcc/0xd0
 ext4_buffered_write_iter+0x58/0x124
 ext4_file_write_iter+0x54/0x704
 vfs_write+0x1c0/0x308
 ksys_write+0x74/0x10c
 __arm64_sys_write+0x1c/0x28
 invoke_syscall+0x48/0x114
 el0_svc_common.constprop.0+0xc0/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x40/0xe4
 el0t_64_sync_handler+0x120/0x12c
 el0t_64_sync+0x194/0x198

Root cause is:

systemd-random-seed                         kworker
----------------------------------------------------------------------
___mark_inode_dirty                     inode_switch_wbs_work_fn

  spin_lock(&inode->i_lock);
  inode_attach_wb
  locked_inode_to_wb_and_lock_list
     get inode->i_wb
     spin_unlock(&inode->i_lock);
     spin_lock(&wb->list_lock)
  spin_lock(&inode->i_lock)
  inode_io_list_move_locked
  spin_unlock(&wb->list_lock)
  spin_unlock(&inode->i_lock)
                                    spin_lock(&old_wb->list_lock)
                                      inode_do_switch_wbs
                                        spin_lock(&inode->i_lock)
                                        inode->i_wb = new_wb
                                        spin_unlock(&inode->i_lock)
                                    spin_unlock(&old_wb->list_lock)
                                    wb_put_many(old_wb, nr_switched)
                                      cgwb_release
                                      old wb released
  wb_wakeup_delayed() accesses wb,
  then trigger the use-after-free
  issue

Fix this race condition by holding inode spinlock until
wb_wakeup_delayed() finished.

Signed-off-by: Jiufei Xue <jiufei.xue@samsung.com>
Link: https://lore.kernel.org/20250728100715.3863241-1-jiufei.xue@samsung.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0a498bc60f557..ed110568d6127 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2536,10 +2536,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			wakeup_bdi = inode_io_list_move_locked(inode, wb,
 							       dirty_list);
 
-			spin_unlock(&wb->list_lock);
-			spin_unlock(&inode->i_lock);
-			trace_writeback_dirty_inode_enqueue(inode);
-
 			/*
 			 * If this is the first dirty inode for this bdi,
 			 * we have to wake-up the corresponding bdi thread
@@ -2549,6 +2545,11 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			if (wakeup_bdi &&
 			    (wb->bdi->capabilities & BDI_CAP_WRITEBACK))
 				wb_wakeup_delayed(wb);
+
+			spin_unlock(&wb->list_lock);
+			spin_unlock(&inode->i_lock);
+			trace_writeback_dirty_inode_enqueue(inode);
+
 			return;
 		}
 	}
-- 
2.50.1



