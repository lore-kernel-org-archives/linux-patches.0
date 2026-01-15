Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715283C1FF1;
	Thu, 15 Jan 2026 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498084; cv=none; b=V1oWs5GFDcMcQeM6tBV5qBELU3C1pphktryEHu5H5xcM3ZzprPxg0O+zSY5MnaxnOqfTy6T8YHQeN+36rsU6h2ciCxVSurvmjm3B0vHv4rTjmtTG1/bxa/2cLTZtHQnW1PI3Ab7gKcRJg+TlKr7IffUQ6+C+Cs3l4DSfytlht4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498084; c=relaxed/simple;
	bh=6KtPtxOSY6c6P9g3m27uGSMM4fjDAFckT3SJlr14uD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK+mgjDjXZjoJpZqvJH9uqv0VzSWKT1SN7Eyj/G7XT0Bnbzr0dCbP5f+xlg4Z6ctovHR7X4vdVEZnBJaYelpGixaEZ+/WJ1V8yojT98dm34AG9pLyq9qsQwBmpnISHs2NI+xP24sCqaBVXFGGDi9R38SsS6atnmybdD8CTjqx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TouEBffh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TouEBffh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07DBC116D0;
	Thu, 15 Jan 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498084;
	bh=6KtPtxOSY6c6P9g3m27uGSMM4fjDAFckT3SJlr14uD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TouEBffhFZ7uB0N/5Pr3LTHyeMCDh0jfvjSmXcuVelrkr59oFPHonJ5rrQi9rg1MA
	 8IQ1vvIsuyzx2ASkkzWpPEGLILyF/s00KdahZQ+yDcJ1EmcekJ1e8QS3tiyMh55cHF
	 yd+Ac8jiNpxJGZS+0N+BhJLaQ0ML4FRHSaIhcI4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 306/554] f2fs: fix return value of f2fs_recover_fsync_data()
Date: Thu, 15 Jan 2026 17:46:12 +0100
Message-ID: <20260115164257.306424592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 01fba45deaddcce0d0b01c411435d1acf6feab7b upstream.

With below scripts, it will trigger panic in f2fs:

mkfs.f2fs -f /dev/vdd
mount /dev/vdd /mnt/f2fs
touch /mnt/f2fs/foo
sync
echo 111 >> /mnt/f2fs/foo
f2fs_io fsync /mnt/f2fs/foo
f2fs_io shutdown 2 /mnt/f2fs
umount /mnt/f2fs
mount -o ro,norecovery /dev/vdd /mnt/f2fs
or
mount -o ro,disable_roll_forward /dev/vdd /mnt/f2fs

F2FS-fs (vdd): f2fs_recover_fsync_data: recovery fsync data, check_only: 0
F2FS-fs (vdd): Mounted with checkpoint version = 7f5c361f
F2FS-fs (vdd): Stopped filesystem due to reason: 0
F2FS-fs (vdd): f2fs_recover_fsync_data: recovery fsync data, check_only: 1
Filesystem f2fs get_tree() didn't set fc->root, returned 1
------------[ cut here ]------------
kernel BUG at fs/super.c:1761!
Oops: invalid opcode: 0000 [#1] SMP PTI
CPU: 3 UID: 0 PID: 722 Comm: mount Not tainted 6.18.0-rc2+ #721 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:vfs_get_tree.cold+0x18/0x1a
Call Trace:
 <TASK>
 fc_mount+0x13/0xa0
 path_mount+0x34e/0xc50
 __x64_sys_mount+0x121/0x150
 do_syscall_64+0x84/0x800
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fa6cc126cfe

The root cause is we missed to handle error number returned from
f2fs_recover_fsync_data() when mounting image w/ ro,norecovery or
ro,disable_roll_forward mount option, result in returning a positive
error number to vfs_get_tree(), fix it.

Cc: stable@kernel.org
Fixes: 6781eabba1bd ("f2fs: give -EINVAL for norecovery and rw mount")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4374,11 +4374,15 @@ try_onemore:
 		}
 	} else {
 		err = f2fs_recover_fsync_data(sbi, true);
-
-		if (!f2fs_readonly(sb) && err > 0) {
-			err = -EINVAL;
-			f2fs_err(sbi, "Need to recover fsync data");
-			goto free_meta;
+		if (err > 0) {
+			if (!f2fs_readonly(sb)) {
+				f2fs_err(sbi, "Need to recover fsync data");
+				err = -EINVAL;
+				goto free_meta;
+			} else {
+				f2fs_info(sbi, "drop all fsynced data");
+				err = 0;
+			}
 		}
 	}
 


