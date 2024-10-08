Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F51DF25D;
	Tue,  8 Oct 2024 12:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392174; cv=none; b=s5TrXfS4H/Lq8Sn69Y0RlHUL7t430obKkSldf0yyEs/ydOI0RApnlM95Gx2Rg7JfLhSs7I9MDuDvyOsXC8/m6Z4jiyjNkeuYRgKlZ3J9EDKfuetw+yueXc4Q62Tv2Ko5HCcHs8bO8ZRU5CSSMVIBwK5ezTCdGeTlMi5pU19a+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392174; c=relaxed/simple;
	bh=z8PFOzfMDbHzurXRuwRbi6Qm00EBjh5FTBokDDC4tL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDKhSNxTc/444IQIr9l7wsJ26f/FOt/4Jo/LUw1XFF9W1g3bTKKoVBAoIKStsFhXZe0mlGZ+ieYEDDy/zyugwNIHt5PrUx0xh00nWbI5iSj7Oh5Zu9ObCEf8lzA80Z5A7oNH9qv7tdyjdE8Ji5Dsz0o+k/XqKujsDXG4V8RFCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ7JCL5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ7JCL5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC92C4CED3;
	Tue,  8 Oct 2024 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392173;
	bh=z8PFOzfMDbHzurXRuwRbi6Qm00EBjh5FTBokDDC4tL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ7JCL5x2HKT/YlJyvOON4FLIQdoe/PtqbgUqh2qQRM+2r8OmYvL+f9XPAnHlyt5u
	 4KdZPFdEU0p9eXIiFbBJmbnxe12Sjzd2V8lhmcD8VtKDs+DwSSYppzXhzbjU2Z7D1G
	 GNmuKXEE23ZiVhCM1QtFsSwIsXDwSOEccPq/O/Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+341e5f32ebafbb46b81c@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 336/558] f2fs: fix to dont panic system for no free segment fault injection
Date: Tue,  8 Oct 2024 14:06:06 +0200
Message-ID: <20241008115715.525354225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 65a6ce4726c27b45600303f06496fef46d00b57f ]

f2fs: fix to don't panic system for no free segment fault injection

syzbot reports a f2fs bug as below:

F2FS-fs (loop0): inject no free segment in get_new_segment of __allocate_new_segment+0x1ce/0x940 fs/f2fs/segment.c:3167
F2FS-fs (loop0): Stopped filesystem due to reason: 7
------------[ cut here ]------------
kernel BUG at fs/f2fs/segment.c:2748!
CPU: 0 UID: 0 PID: 5109 Comm: syz-executor304 Not tainted 6.11.0-rc6-syzkaller-00363-g89f5e14d05b4 #0
RIP: 0010:get_new_segment fs/f2fs/segment.c:2748 [inline]
RIP: 0010:new_curseg+0x1f61/0x1f70 fs/f2fs/segment.c:2836
Call Trace:
 __allocate_new_segment+0x1ce/0x940 fs/f2fs/segment.c:3167
 f2fs_allocate_new_section fs/f2fs/segment.c:3181 [inline]
 f2fs_allocate_pinning_section+0xfa/0x4e0 fs/f2fs/segment.c:3195
 f2fs_expand_inode_data+0x5d6/0xbb0 fs/f2fs/file.c:1799
 f2fs_fallocate+0x448/0x960 fs/f2fs/file.c:1903
 vfs_fallocate+0x553/0x6c0 fs/open.c:334
 do_vfs_ioctl+0x2592/0x2e50 fs/ioctl.c:886
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0010:get_new_segment fs/f2fs/segment.c:2748 [inline]
RIP: 0010:new_curseg+0x1f61/0x1f70 fs/f2fs/segment.c:2836

The root cause is when we inject no free segment fault into f2fs,
we should not panic system, fix it.

Fixes: 8b10d3653735 ("f2fs: introduce FAULT_NO_SEGMENT")
Reported-by: syzbot+341e5f32ebafbb46b81c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/000000000000f0ee5b0621ab694b@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 987165a58b708..c9320c98cb142 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2730,6 +2730,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 								MAIN_SECS(sbi));
 		if (secno >= MAIN_SECS(sbi)) {
 			ret = -ENOSPC;
+			f2fs_bug_on(sbi, 1);
 			goto out_unlock;
 		}
 	}
@@ -2740,6 +2741,7 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 							MAIN_SECS(sbi));
 		if (secno >= MAIN_SECS(sbi)) {
 			ret = -ENOSPC;
+			f2fs_bug_on(sbi, 1);
 			goto out_unlock;
 		}
 	}
@@ -2781,10 +2783,8 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 out_unlock:
 	spin_unlock(&free_i->segmap_lock);
 
-	if (ret == -ENOSPC) {
+	if (ret == -ENOSPC)
 		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_NO_SEGMENT);
-		f2fs_bug_on(sbi, 1);
-	}
 	return ret;
 }
 
-- 
2.43.0



