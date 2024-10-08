Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9511DD867;
	Tue,  8 Oct 2024 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390406; cv=none; b=OC3kCbSEmR+MULw5/s4jN9oUVhvrxi64XyRRUbReCVYggI/FDWCm58L4Y5pLDir4+qOOHo983N02scSON22wgspWW1XjEb/YM9xK1Fbh38S+mOnDg3SR5qXsamfgBXit1zrSVFvN6yvICbBsV3syuzE73FzDRToUbH9gntDSyY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390406; c=relaxed/simple;
	bh=oMMevxg9lN1pDqU0NVh52ePpRPM67XdOQi8mibOME1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J42Gh7psuZHCmQmVp/GkTlsGBtG/X9eoyMkuejHY2Sp2zaSzeR9BZWSAZBUv0156Vd3gX3YHIgvWcX8MLjo6i0FiwdZ9nwFmZAS1CGK4M1fLcdSLkxvoef7jjG+cyoKGLeWdZoXZ2Y758N4Fi+kOEEFlfwI3RXovLMZaYapqfYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXEd4P6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXEd4P6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C4C4CECE;
	Tue,  8 Oct 2024 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390405;
	bh=oMMevxg9lN1pDqU0NVh52ePpRPM67XdOQi8mibOME1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXEd4P6OLe8GjLfSBooDADzTh3x5tWl5MJ4GD+ZTFMPPCZaVu+nu3U3X7nMsq9Unm
	 SPRVFjel++CE0Q82e7pIhIMp4Ky840kJQJw5BO9eLggkwOtqcyRbqg4ShH0kkkj3vA
	 aAy6b6cAbBsavyszTIf+y0M20AL/afL1KzEWOyYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+341e5f32ebafbb46b81c@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 279/482] f2fs: fix to dont panic system for no free segment fault injection
Date: Tue,  8 Oct 2024 14:05:42 +0200
Message-ID: <20241008115659.260094379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5646ffed70f77..297cc89cbcca0 100644
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



