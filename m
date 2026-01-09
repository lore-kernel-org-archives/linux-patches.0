Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B83433BBBD;
	Fri,  9 Jan 2026 12:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960581; cv=none; b=VOQlL1TDrBKND6gAznNOGUcpj5GOU+jW3VVNOCHy3NL29/EpE9ImBbIKe5sIFpFrIZGB8oZXzCpi2bVajFQO++/GEQYICRmaSPEoN9Nc0+frwZNzobZ1GVBlYyCAvcNzP9FAaFmDpVtdj2y2Jc325TjViDgVwJchFKj09fqL2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960581; c=relaxed/simple;
	bh=WCslTM6MsuBzeeCbstisTqvvrHcePYfa2wSbjvb8NOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCDVBiUvGv5Y36c3uXGyjdpHVfHSHcF5p3wgDUh4EL9ADMVd8DoEO6pa4ZMB1wrr/f5rTW7e0ovChapGafiIDeHbOucrO+jGK5ZlAimVjolsCMpSaBddlO1GffSfcpw8aX1TAnrSYIClxCab+7heNewieSE0EPWS1Kz2DIF/FCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IMBPoiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IMBPoiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA6BC4CEF1;
	Fri,  9 Jan 2026 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960581;
	bh=WCslTM6MsuBzeeCbstisTqvvrHcePYfa2wSbjvb8NOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IMBPoiqN0iZKG/c1DERRW9zB2hGt/KMWXd6jW153MbuXWUD4fRaop9fLrA78+g+Z
	 bTULTI8rO7pjtwpq+RkJPpV5GR5ea8lbPvs8tXf7gr8w89S0m9K8mtuf+Pih38/yE/
	 /2m6FChkv2lX8ZgB0rCGKlVUC6KcYf5CXGdMy6qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 453/737] f2fs: fix return value of f2fs_recover_fsync_data()
Date: Fri,  9 Jan 2026 12:39:52 +0100
Message-ID: <20260109112151.035154756@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -4692,11 +4692,15 @@ try_onemore:
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
 


