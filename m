Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878C43C00BF;
	Thu, 15 Jan 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499825; cv=none; b=LIDIUs7we9hK0HylLiL6M/NgfFzBIiLBRLZPnAWvoP8PZuOjtnr3RnlMOc6R3j9+IduZpK9+rLKh8ay1ISQoQeIVgvHfm5PS1XI7muyIJL/2auHxUEs+ZZZpHPtu/xM+bKls6tgXIRK3fGqLPZ0uiSZ+2Xo8AFEFB7jJ129dU90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499825; c=relaxed/simple;
	bh=13nflMFjf4RskqzRazg4yzUffDVzU72jarIk58uwNI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcpCJ9m6lhXahU8Kt5DAwo1ZNReQGZ5wvlrxuzhbb4A7slDiY+4ItsL03cxt+ECoqzu5bfdh+5l/rNMl7BlneCdL0v/pMq+nnk6hK4jXeq7gW/9OLjytzMSkRZJl8rEGG/ZyreQPKTA1zEIc1xl8/XqBALZxGOucthZ/2X3Dffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ1WM1HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ1WM1HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1303BC116D0;
	Thu, 15 Jan 2026 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499825;
	bh=13nflMFjf4RskqzRazg4yzUffDVzU72jarIk58uwNI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ1WM1HUql2+hMa8ZhyygCw94q8HPhySJ6IQJCARyDtKQ1Ig0LMlDTRdA0fsctzza
	 JYN26sT7H34R2MAv1jFaL54ujCr/RjvktvC59p3gYXd414V7L061fdCiNDm1zqYVVF
	 p/4stN2JvAt4K3jlP1ObBvXo69Qi81xxg5/ZY7nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+24124df3170c3638b35f@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/451] f2fs: fix to avoid updating zero-sized extent in extent cache
Date: Thu, 15 Jan 2026 17:49:23 +0100
Message-ID: <20260115164244.001963041@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7c37c79510329cd951a4dedf3f7bf7e2b18dccec ]

As syzbot reported:

F2FS-fs (loop0): __update_extent_tree_range: extent len is zero, type: 0, extent [0, 0, 0], age [0, 0]
------------[ cut here ]------------
kernel BUG at fs/f2fs/extent_cache.c:678!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5336 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__update_extent_tree_range+0x13bc/0x1500 fs/f2fs/extent_cache.c:678
Call Trace:
 <TASK>
 f2fs_update_read_extent_cache_range+0x192/0x3e0 fs/f2fs/extent_cache.c:1085
 f2fs_do_zero_range fs/f2fs/file.c:1657 [inline]
 f2fs_zero_range+0x10c1/0x1580 fs/f2fs/file.c:1737
 f2fs_fallocate+0x583/0x990 fs/f2fs/file.c:2030
 vfs_fallocate+0x669/0x7e0 fs/open.c:342
 ioctl_preallocate fs/ioctl.c:289 [inline]
 file_ioctl+0x611/0x780 fs/ioctl.c:-1
 do_vfs_ioctl+0xb33/0x1430 fs/ioctl.c:576
 __do_sys_ioctl fs/ioctl.c:595 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f07bc58eec9

In error path of f2fs_zero_range(), it may add a zero-sized extent
into extent cache, it should be avoided.

Fixes: 6e9619499f53 ("f2fs: support in batch fzero in dnode page")
Cc: stable@kernel.org
Reported-by: syzbot+24124df3170c3638b35f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/68e5d698.050a0220.256323.0032.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1458,7 +1458,8 @@ static int f2fs_do_zero_range(struct dno
 		f2fs_set_data_blkaddr(dn);
 	}
 
-	f2fs_update_extent_cache_range(dn, start, 0, index - start);
+	if (index > start)
+		f2fs_update_extent_cache_range(dn, start, 0, index - start);
 
 	return ret;
 }


